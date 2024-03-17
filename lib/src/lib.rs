use godot::prelude::*;
use palette::FromColor;

struct Extension;

#[gdextension]
unsafe impl ExtensionLibrary for Extension {}

struct ImageItem {
    name: std::ffi::OsString,
    data: image::RgbaImage,
}

impl ImageItem {
    fn new(name: std::ffi::OsString, data: image::RgbaImage) -> Self {
        Self { name, data }
    }
}

struct ImagePick {
    name: std::ffi::OsString,
    hue: f32,
    sat: f32,
    val: f32,
}

impl ImagePick {
    fn new(name: std::ffi::OsString, hue: f32, sat: f32, val: f32) -> Self {
        Self {
            name,
            hue,
            sat,
            val,
        }
    }
}

#[derive(GodotClass)]
#[class(base=Node)]
struct ImageBuilder {
    width: u32,
    height: u32,
    items: Vec<ImageItem>,
    picks: Vec<ImagePick>,
    base: Base<Node>,
}

#[godot_api]
impl INode for ImageBuilder {
    fn init(base: Base<Self::Base>) -> Self {
        Self {
            width: Default::default(),
            height: Default::default(),
            items: Default::default(),
            picks: Default::default(),
            base,
        }
    }
}

#[godot_api]
impl ImageBuilder {
    #[func]
    fn width(&self) -> u32 {
        self.width
    }

    #[func]
    fn height(&self) -> u32 {
        self.height
    }

    #[func]
    fn from_file(width: u32, height: u32, root_path: String) -> Gd<Self> {
        let mut items = vec![];

        // through invalid entry
        for entry in std::fs::read_dir(&root_path)
            .unwrap_or_else(|_| panic!("failed to read dir {:?}", root_path))
            .flatten()
        {
            let path = entry.path();
            let Some(name) = path.file_stem() else {
                println!("file name is nothing {:?}", path);
                continue;
            };

            let Ok(data) = image::open(&path) else {
                println!("failed to open image file {:?}", path);
                continue;
            };

            if data.width() != width || data.height() != height {
                println!("image size must be {:?} x {:?}", width, height);
                continue;
            }

            items.push(ImageItem::new(name.into(), data.to_rgba8()));
        }

        Gd::from_init_fn(|base| Self {
            width,
            height,
            items,
            picks: vec![],
            base,
        })
    }

    #[func]
    fn add_pick(&mut self, name: String, hue: f32, sat: f32, val: f32) {
        self.picks.push(ImagePick::new(name.into(), hue, sat, val));
    }

    #[func]
    fn clear_pick(&mut self) {
        self.picks.clear();
    }

    #[func]
    fn build(&self, output_path: String) {
        let mut output_image = image::RgbaImage::new(self.width, self.height);

        for pick in &self.picks {
            let item = self
                .items
                .iter()
                .find(|item| item.name == pick.name)
                .unwrap_or_else(|| panic!("image is not found {:?}", pick.name));

            let mut image = item.data.clone();
            image.pixels_mut().for_each(|image::Rgba([r, g, b, a])| {
                let rgba = palette::Srgba::new(
                    *r as f32 / 255.0,
                    *g as f32 / 255.0,
                    *b as f32 / 255.0,
                    *a as f32 / 255.0,
                );

                let mut hsva = palette::Hsva::from_color(rgba);
                hsva.hue += pick.hue;
                hsva.saturation += pick.sat;
                hsva.value += pick.val;

                let rgba = palette::Srgba::from_color(hsva);
                *r = (rgba.red * 255.0) as u8;
                *g = (rgba.green * 255.0) as u8;
                *b = (rgba.blue * 255.0) as u8;
                *a = (rgba.alpha * 255.0) as u8;
            });

            image::imageops::overlay(&mut output_image, &image, 0, 0);
        }

        output_image
            .save(&output_path)
            .unwrap_or_else(|_| panic!("failed to write image file {:?}", output_path));
    }
}
