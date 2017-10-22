from PIL import Image
from collections import Counter
from scipy.spatial import KDTree
import numpy as np
def hex_to_rgb(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
def rgb_to_hex(num):
    h = str(num)
    return int(h[0:4], 16), int(('0x' + h[4:6]), 16), int(('0x' + h[6:8]), 16)
filename = input("What's the image name? ")
new_w, new_h = map(int, input("What's the new height x width? Like 28 28. ").split(' '))
palette_hex = ['0xFF69B4', '0x000000', '0xDADAFF', '0xFF0000', '0x006DFF', '0xE85C00', '0xE5E800', '0x00031A', '0x000F2E', '0x01254E', '0x001437', '0x001E4B', '0x495251', '0x9C9E73', '0xF000FF', '0x00FF07', '0x403F56', '0x212036', '0xE3B181', '0x111010', '0x3B3944', '0xE8D7A4', '0xD9CAAE', '0xB98F5C', '0xC87958', '0x985C3E', '0x625F55', '0x949087', '0x105772', '0xF1ACDA', '0x247BAA', '0xF7D0EA', '0x2CE8FE', '0x0091F3', '0x01136A']
palette_rgb = [hex_to_rgb(color) for color in palette_hex]

pixel_tree = KDTree(palette_rgb)
im = Image.open("./sprite_originals/" + filename+ ".png") #Can be many different formats.
im = im.convert("RGBA")
layer = Image.new('RGBA',(new_w, new_h), (0,0,0,0))
layer.paste(im, (0, 0))
im = layer
#im = im.resize((new_w, new_h),Image.ANTIALIAS) # regular resize
pix = im.load()
pix_freqs = Counter([pix[x, y] for x in range(im.size[0]) for y in range(im.size[1])])
pix_freqs_sorted = sorted(pix_freqs.items(), key=lambda x: x[1])
pix_freqs_sorted.reverse()
print(pix)
outImg = Image.new('RGB', im.size, color='white')
outFile = open("./sprite_bytes/" + filename + '.txt', 'w')
i = 0

for y in range(im.size[1]):
    for x in range(im.size[0]):
        pixel = im.getpixel((x,y))
        print(pixel)
        if(pixel[3] < 200):
            outImg.putpixel((x,y), palette_rgb[0])
            outFile.write("%x\n" %(0))
            print(i)
        else:
            index = pixel_tree.query(pixel[:3])[1]
            outImg.putpixel((x,y), palette_rgb[index])
            outFile.write("%x\n" %(index))
        i += 1
    
            
outFile.close()
outImg.save("./sprite_converted/" + filename + ".png" )
