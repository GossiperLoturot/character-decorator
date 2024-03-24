use godot::prelude::*;
use palette::*;

struct Extension;

#[gdextension]
unsafe impl ExtensionLibrary for Extension {}

struct ImageItem {
    name: String,
    image: image::RgbaImage,
}

impl ImageItem {
    fn new(name: String, image: image::RgbaImage) -> Self {
        Self { name, image }
    }
}

struct ImagePick {
    name: String,
    l: f32,
    c: f32,
    h: f32,
}

impl ImagePick {
    fn new(name: String, l: f32, c: f32, h: f32) -> Self {
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

        let mut dir = godot::engine::DirAccess::open(GString::from(&root_path))
            .unwrap_or_else(|| panic!("failed to read dir {:?}", root_path));

        for file_name in dir.get_files().to_vec() {
            let file_name = file_name.to_string();
            let file_path = format!("{}/{}", root_path, file_name);

            let Some((file_stem, _)) = file_name.split_once('.') else {
                println!("failed to parse file name {:?}", file_path);
                continue;
            };

            let Ok(src_image) = try_load::<godot::engine::Image>(GString::from(&file_path)) else {
                println!("failed to open image file {:?}", file_path);
                continue;
            };

            if src_image.get_width() as u32 != width || src_image.get_height() as u32 != height {
                println!("image size must be {:?} x {:?}", width, height);
                continue;
            }

            let mut image = image::RgbaImage::new(width, height);
            for y in 0..height {
                for x in 0..width {
                    let rgba = src_image.get_pixel(x as i32, y as i32);
                    let rgba = image::Rgba([rgba.r8(), rgba.g8(), rgba.b8(), rgba.a8()]);
                    image.put_pixel(x, y, rgba);
                }
            }
            items.push(ImageItem::new(file_stem.to_string(), image));
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

            let mut image = item.image.clone();

            image
                .pixels_mut()
                .for_each(|rgba| oklcha_shift_mut(rgba, pick.l, pick.c, pick.h));

            image::imageops::overlay(&mut collect_image, &image, 0, 0);
        }

        godot::engine::Image::create_from_data(
            self.width as i32,
            self.height as i32,
            false,
            godot::engine::image::Format::RGBA8,
            PackedByteArray::from(collect_image.to_vec().as_slice()),
        )
        .unwrap()
    }
}

fn oklcha_shift_mut(rgba: &mut image::Rgba<u8>, l: f32, c: f32, h: f32) {
    let image::Rgba([r, g, b, a]) = rgba;

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
