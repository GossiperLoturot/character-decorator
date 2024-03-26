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
#[class(init, base=Resource)]
struct ImageBuilderDescItem {
    #[export]
    name: GString,
    #[export]
    image: Gd<godot::engine::Image>,
}

#[derive(GodotClass)]
#[class(init, base=Resource)]
struct ImageBuilderDesc {
    #[export]
    width: u32,
    #[export]
    height: u32,
    #[export]
    items: Array<Gd<ImageBuilderDescItem>>,
}

#[derive(GodotClass)]
#[class(no_init, base=RefCounted)]
struct ImageBuilder {
    width: u32,
    height: u32,
    items: Vec<ImageItem>,
    picks: Vec<ImagePick>,
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
    fn from_desc(desc: Gd<ImageBuilderDesc>) -> Gd<Self> {
        let mut items = vec![];

        let width = desc.bind().width;
        let height = desc.bind().height;

        for item in desc.bind().items.iter_shared() {
            let src_name = &item.bind().name;
            let src_image = &item.bind().image;

            if src_image.get_width() as u32 != width || src_image.get_height() as u32 != height {
                println!("image size must be {:?} x {:?}", width, height);
                continue;
            }

            let name = src_name.to_string();
            let mut image = image::RgbaImage::new(width, height);
            for y in 0..height {
                for x in 0..width {
                    let rgba = src_image.get_pixel(x as i32, y as i32);
                    let rgba = image::Rgba([rgba.r8(), rgba.g8(), rgba.b8(), rgba.a8()]);
                    image.put_pixel(x, y, rgba);
                }
            }
            items.push(ImageItem::new(name, image));
        }

        Gd::from_init_fn(|_| Self {
            width,
            height,
            items,
            picks: vec![],
        })
    }

    #[func]
    fn pick_image(&mut self, name: GString, l: f32, c: f32, h: f32) {
        self.picks.push(ImagePick::new(name.to_string(), l, c, h));
    }

    #[func]
    fn clear_image(&mut self) {
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
