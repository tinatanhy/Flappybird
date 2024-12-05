from PIL import Image

file = open("./game_assets/coe/Bird_NoRotate_6kx16.coe","w")
file.write(";6k*16\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")

# size: 24*24*9= 5184*16 < 6k*16
size = 5184
for k in range(0, 3):
	for l in range(0, 3):
		img_raw = Image.open(f"./game_assets/bird{k}_{l}.png")
		print(k, l)
		img = img_raw.convert("RGBA")
		img_w = img.size[0]
		img_h = img.size[1]
		for i in range(0, img_w):
			for j in range(0, img_h):
				data=img.getpixel((i, j))
				re=(16*int(data[0]/16),16*int(data[1]/16),16*int(data[2]/16),16*int(data[3]/16))
				img.putpixel((i,j),re)

		width=24
		height=24
		for j in range(0,img_w):
			for i in range(0,img_h):
				data=img.getpixel((i, j))
				re=['%01X' %int(s/16) for s in data]
				result=""
				for item in re:
					result+=item
				file.write(result)
				file.write(" ")
			file.write("\n")

for i in range(0,6*1024-5184):
	file.write("0000 ")
file.write("\n;")
print("Finish")