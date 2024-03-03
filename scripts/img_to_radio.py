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

    # load image
    print('load image')
    im = Image.open(image_path)
    
    # resize image 
    print('resize...')
    cur_size_width, cur_size_height = im.size
    new_size_width = int(cur_size_width / 8)
    new_size_height = int(cur_size_height / 8)
    im = im.resize((new_size_width, new_size_height))
    
    # unselected - nothing
    print('save resized...')
    im.save("nothing.png")
    
    # selected - check 
    print('load check...')
    check = Image.open('check-mark.png')
    im_check = im.copy()
    print('overlay check...')
    center = (int(im_check.size[0]/2),int(im_check.size[1]/2))
    im_check.paste(check, center, check)
    im_check.save('selected.png')
    
    # locked - grey/black 
    print('color set...')
    subsprite = im.convert(mode="RGBA")
    
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
    new_image.save("locked.png")
    
except Exception as e:
    traceback.print_exc()
    time.sleep(5)
finally:
    print('done')
    time.sleep(5)