use godot::prelude::*;
use palette::*;

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
    l: f32,
    c: f32,
    h: f32,
}

impl ImagePick {
    fn new(name: std::ffi::OsString, l: f32, c: f32, h: f32) -> Self {
        Self { name, l, c, h }
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
    fn add_pick(&mut self, name: String, l: f32, c: f32, h: f32) {
        self.picks.push(ImagePick::new(name.into(), l, c, h));
    }

    #[func]
    fn clear_pick(&mut self) {
        self.picks.clear();
    }

    #[func]
    fn build(&self) -> Gd<godot::engine::Image> {
        let mut collect_image = image::RgbaImage::new(self.width, self.height);

        for pick in &self.picks {
            let item = self
                .items
                .iter()
                .find(|item| item.name == pick.name)
                .unwrap_or_else(|| panic!("image is not found {:?}", pick.name));

            let mut image = item.data.clone();
            image
                .pixels_mut()
                .for_each(|rgba| hsv_shift_mut(rgba, pick.l, pick.c, pick.h));

            image::imageops::overlay(&mut collect_image, &image, 0, 0);
        }

        let mut gd_image = godot::engine::Image::new_gd();
        gd_image.set_data(
            self.width() as i32,
            self.height() as i32,
            false,
            godot::engine::image::Format::RGBA8,
            PackedByteArray::from_iter(collect_image.iter().cloned()),
        );
        gd_image
    }
}

fn hsv_shift_mut(rgba: &mut image::Rgba<u8>, l: f32, c: f32, h: f32) {
    let [r, g, b, a] = &mut rgba.0;

    let rgba = palette::Srgba::new(
        *r as f32 / 255.0,
        *g as f32 / 255.0,
        *b as f32 / 255.0,
        *a as f32 / 255.0,
    );

    let mut oklcha = palette::Oklcha::from_color(rgba);
    oklcha.l += l;
    oklcha.chroma += c;
    oklcha.hue += h;

    let rgba = palette::Srgba::from_color(oklcha);

    *r = (rgba.red * 255.0) as u8;
    *g = (rgba.green * 255.0) as u8;
    *b = (rgba.blue * 255.0) as u8;
    *a = (rgba.alpha * 255.0) as u8;
}
