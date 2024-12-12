from PIL import Image

for ind in range(0, 4):
	for bcol in range(0, 3):
		file = open(f"./game_assets/coe/rotate/Bird{ind}{bcol}_Rotate_48kx16.coe","w")
		file.write(";48k*16\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")

		# size: 24*24*9= 5184*16 < 6k*16
		size = 49152
		img_raw = Image.open(f"./game_assets/rotate/bird{ind}_{bcol}_strip30.png")
		print(ind, bcol)
		img = img_raw.convert("RGBA")
		img_w = img.size[0]
		img_h = img.size[1]
		for i in range(0, img_w):
			for j in range(0, img_h):
				data=img.getpixel((i, j))
				re=(16*int(data[0]/16),16*int(data[1]/16),16*int(data[2]/16),16*int(data[3]/16))
				img.putpixel((i,j),re)

		imgn = 30
		width=40
		height=40
		for imgi in range(0, imgn):
			for i in range(0, height):
				for j in range(imgi * width, (imgi + 1) * width):
					data=img.getpixel((j, i))
					re=['%01X' %int(s/16) for s in data]
					result=""
					for item in re:
						result+=item
					file.write(result)
					file.write(" ")
				file.write("\n")

		for i in range(0,49152 - 48000):
			file.write("0000 ")
		file.write("\n;")
		file.close()
		print("Finish")