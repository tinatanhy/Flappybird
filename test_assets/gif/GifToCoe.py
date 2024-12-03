# Auther: Xhy
# 将图片自动转换为指定大小的.coe文件
# 最终的文件默认200*150大小，请尽量使用200k*150*k大小的图片
# 图片格式任意，路径可自行修改，默认为"test.jpeg"
# 输出image_thumb.jpg为缩略图，并输出result.coe

from PIL import Image

file = open("./result100x75x40.coe","w")
file.write(";320k*12\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")

for k in range(1, 41):
	img_raw = Image.open(f"./frame/frame_{k}.png")
	print(k)

	#预处理
	# 获取图片尺寸的大小__预期(600,400)
	# 生成缩略图
	img_raw.thumbnail((75, 75))
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
	# 转换为.coe文件
	width=100
	height=75
	for j in range(0,height):
		for i in range(0,width):
			if i < 13 or i >= 88:
				file.write("FFF ")
				continue
			data=img.getpixel((i - 13, j))
			re=['%01X' %int(s/16) for s in data]
			result=""
			for item in re:
				result+=item
			file.write(result)
			file.write(" ")
		file.write("\n")

for i in range(0,320*1024-width*height*40):
	file.write("000 ")
file.write("\n;")
print("Finish")