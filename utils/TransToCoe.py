# Auther: Xhy
# 将图片自动转换为指定大小的.coe文件
# 最终的文件默认200*150大小，请尽量使用200k*150*k大小的图片
# 图片格式任意，路径可自行修改，默认为"test.jpeg"
# 输出image_thumb.jpg为缩略图，并输出result.coe

from PIL import Image

img_raw = Image.open("./test_assets/test200x150.png")

#预处理
# 获取图片尺寸的大小__预期(600,400)
print (img_raw.size)
# 获取图片的格式 png
print (img_raw.format)
# 获取图片的图像类型 RGBA
print (img_raw.mode)
# 生成缩略图
img_raw.thumbnail((200, 150))
# 把图片强制转成RGB
img = img_raw.convert("RGB")
# 把图片调整为16色
img_w=img.size[0]
img_h=img.size[1]
for i in range(0,img_w):
 for j in range(0,img_h):
  data=img.getpixel((i,j))
  re=(16*int(data[0]/16),16*int(data[1]/16),16*int(data[2]/16))
  img.putpixel((i,j),re)
# 保存图片
img.save('./test_assets/test200x150_thumb.jpg', 'JPEG')
# 显示图片
# img.show()

# 转换为.coe文件
width=200
height=150
file = open("./test_assets/result200x150.coe","w")
file.write(";32k*12\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")

for j in range(0,height):
 for i in range(0,width):
  data=img.getpixel((i, j))
  re=['%01X' %int(s/16) for s in data]
  result=""
  for item in re:
    result+=item
  file.write(result)
  file.write(" ")
 file.write("\n")
for i in range(0,32*1024-width*height):
 file.write("000 ")
file.write("\n;")
print("Finish")