from PIL import Image

def save_brightness_to_file(image_path, output_file_path):
    try:
        image = Image.open(image_path)
        if image.mode != "RGB":
            image = image.convert("RGB")

        width, height = image.size
        size = min(width, height)
        with open(output_file_path, 'w') as writer:
            for y in range(size):
                for x in range(size):
                    rgb = image.getpixel((x, y))
                    brightness = sum(rgb) // 3
                    writer.write(str(brightness) + " ")
                writer.write("\n")

        print("Pixel brightness values have been saved to:", output_file_path)
    except Exception as e:
        print("An error occurred:", e)

image_path = "input.png"
output_file_path = "output.txt"
save_brightness_to_file(image_path, output_file_path)
