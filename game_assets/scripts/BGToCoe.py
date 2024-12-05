from PIL import Image

file = open("./game_assets/coe/Background_72kx12.coe","w")
file.write(";72k*12\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")
# size: 256*144*2 *12 = 72k*12
size = 72*1024
cnt = 0
for k in range(0, 2):
	img_raw = Image.open(f"./game_assets/bg_0.png")
	print(k)
	img = img_raw.convert("RGB")
	img_w = img.size[0]
	img_h = img.size[1]
	for i in range(0, img_w):
		for j in range(0, img_h):
			data=img.getpixel((i, j))
			re=(16*int(data[0]/16),16*int(data[1]/16),16*int(data[2]/16))
			img.putpixel((i,j),re)

	for j in range(0,img_h):
		for i in range(0,img_w):
			data=img.getpixel((i, j))
			re=['%01X' %int(s/16) for s in data]
			result=""
			for item in re:
				result+=item
			file.write(result)
			file.write(" ")
			cnt += 1
		file.write("\n")

for i in range(0,72*1024-cnt):
	file.write("000 ")
file.write(";")
print("Finish")