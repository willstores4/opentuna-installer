import os
from PIL import Image, ImageDraw, ImageFont

# Source image from artifact
logo_path = r"C:\Users\XEON-2680v4-RTX3060\.gemini\antigravity-ide\brain\8061988d-63a9-4554-92ff-1ecc88457160\tuna_can_logo_1791259114004.jpg"
out_dir = r"c:\1-arquivos-nao-apagar\Desktop\Paineis_Sistemas\opentuna-installer-main\BMP"

screens = {
    "wait": "Installing...",
    "complete": "Installation Complete!",
    "error": "Error",
    "INST_SLOT_1": "Insert Memory Card in Slot 1",
    "INST_SLOT_2": "Insert Memory Card in Slot 2",
    "NON_COMPATIBLE": "Console not compatible",
}

# Try to load a font, fallback to default
try:
    font_large = ImageFont.truetype("arial.ttf", 48)
    font_small = ImageFont.truetype("arial.ttf", 32)
except IOError:
    font_large = ImageFont.load_default()
    font_small = ImageFont.load_default()

# Open logo and resize
try:
    tuna_logo = Image.open(logo_path).convert("RGBA")
    tuna_logo = tuna_logo.resize((200, 200), Image.Resampling.LANCZOS)
except Exception as e:
    print(f"Failed to load logo: {e}")
    # Create dummy logo
    tuna_logo = Image.new("RGBA", (200, 200), (0, 0, 0, 0))

width, height = 640, 448

for name, text in screens.items():
    # Create black background
    img = Image.new("RGBA", (width, height), (0, 0, 0, 255))
    draw = ImageDraw.Draw(img)

    # Draw top text
    top_text = "OpenTuna WILL-installer"
    
    # Calculate text bounds manually or use textbbox
    if hasattr(draw, 'textbbox'):
        bbox = draw.textbbox((0, 0), top_text, font=font_large)
        tw = bbox[2] - bbox[0]
        th = bbox[3] - bbox[1]
    else:
        tw, th = draw.textsize(top_text, font=font_large)
        
    draw.text(((width - tw) // 2, 40), top_text, fill=(255, 255, 255, 255), font=font_large)

    # Paste logo in center
    img.paste(tuna_logo, ((width - 200) // 2, 100), tuna_logo)

    # Draw bottom text
    if hasattr(draw, 'textbbox'):
        bbox = draw.textbbox((0, 0), text, font=font_small)
        tw = bbox[2] - bbox[0]
        th = bbox[3] - bbox[1]
    else:
        tw, th = draw.textsize(text, font=font_small)
        
    draw.text(((width - tw) // 2, 320), text, fill=(200, 200, 200, 255), font=font_small)

    # Now convert image to C array
    # PS2 GS 32-bit pixel format is typically ABGR in little endian: 0xAABBGGRR
    # Since alpha is ignored usually, we can just do 0x00BBGGRR or 0x80BBGGRR
    # The original file says RGB888, often means (R) | (G<<8) | (B<<16)
    
    pixels = list(img.getdata())
    
    header_path = os.path.join(out_dir, f"{name}.h")
    with open(header_path, "w") as f:
        f.write("/*\n * BMP image data converted from 24bpp\n * to RGB888\n */\n\n")
        f.write('#include "defines.h"\n')
        f.write(f"uint32 {name}_w = {width};\n")
        f.write(f"uint32 {name}_h = {height};\n\n")
        f.write(f"uint32 __attribute__((aligned(16))) {name}[] = {{\n")
        
        for i in range(0, len(pixels), 6):
            chunk = pixels[i:i+6]
            hex_vals = []
            for p in chunk:
                r, g, b, a = p
                # PS2 ABGR layout -> 0x00BBGGRR
                val = (b << 16) | (g << 8) | r
                hex_vals.append(f"0x{val:08x}")
            f.write("    " + ", ".join(hex_vals) + ",\n")
            
        f.write("};\n")
        
    print(f"Generated {header_path}")
