from PIL import Image

input_file_path = "convolution_output.txt"
output_image_path = "image.png"

with open(input_file_path, 'r') as file:
    lines = file.readlines()

image_height = len(lines)
image_width = image_height
image = Image.new("RGB", (image_width, image_height))

for row, line in enumerate(lines):
    values = line.strip().split()
    col = 0
    for brightness_str in values:
        if brightness_str.strip() == "":
            continue
        brightness_f = float(brightness_str)
        brightness = int(brightness_f)
        if brightness_f < 0:
            brightness = 0
        if brightness_f > 255:
            brightness = 255
        rgb = (brightness << 16) | (brightness << 8) | brightness
        image.putpixel((col, row), rgb)
        col += 1

image.save(output_image_path)
print("Image has been created and saved to:", output_image_path)
