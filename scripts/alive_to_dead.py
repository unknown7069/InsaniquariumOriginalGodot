import sys 
import time
from statistics import mean 
import traceback
from PIL import Image, ImageFilter
import numpy as np
import math 
import colorsys

try:
    image_path = sys.argv[1]
    print(image_path)
    
    # MODIFY PIXELS 
    # multiply each pixel by 1.2
    # out = im.point(lambda i: i * 1.2)
    
    # MASK IMAGE EXAMPLE
    # split the image into individual bands
    # source = im.split()
    # R, G, B = 0, 1, 2
    # select regions where red is less than 100
    # mask = source[R].point(lambda i: i < 100 and 255)
    # process the green band
    # out = source[G].point(lambda i: i * 0.7)
    # paste the processed band back, but only where red was < 100
    # source[G].paste(out, None, mask)
    # build a new multiband image
    # im = Image.merge(im.mode, source)

    # load image
    print('load image')
    im = Image.open(image_path)
    
    # get the first sprite from the sheet, assume it has two subs
    print('grab sprite...')
    (width, height) = im.size
    subsprite = im.crop((0, 0, width/2, height))
    
    # direction
    print('direction...')
    subsprite = subsprite.transpose(Image.FLIP_LEFT_RIGHT)
    subsprite = subsprite.transpose(Image.ROTATE_180)
    
    # recolor 
    print('color set...')
    subsprite = subsprite.convert(mode="RGBA")
    subsprite_colors = subsprite.split()
    R, G, B, A = 0, 1, 2, 3
    R_COEF, G_COEF, B_COEF = 0.2989, 0.5870, 0.1140
    
    def grayscale(picture):
        print('looping')
        res=Image.new(picture.mode, picture.size)
        width, height = picture.size
        for i in range(0, width):
            for j in range(0, height):
                pixel=picture.getpixel((i,j))
                avg=int((pixel[0]+pixel[1]+pixel[2])/3)
                (h, l, s) = colorsys.rgb_to_hls(pixel[0], pixel[1], pixel[2])
                avg = int(avg - l/10)
                res.putpixel((i,j),(avg, avg, avg+5, pixel[3]))
        return res 
        
    new_image = grayscale(subsprite)
    # write out 
    new_image.save("demo.png")
except Exception as e:
    traceback.print_exc()
    time.sleep(5)
finally:
    time.sleep(5)