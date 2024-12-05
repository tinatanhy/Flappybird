from PIL import Image

file = open("./game_assets/coe/CompTexture_10kx16.coe","w")
file.write(";10k*16\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")

fname = [
	"./game_assets/land_compressed.png",
	"./game_assets/tube_compressed.png",
	"./game_assets/tutorial.png",
	"./game_assets/gameover.png",
	"./game_assets/ready.png",
	"./game_assets/numbers.png"
]
# size: 24*24*9= 5184*16 < 6k*16
for fname in files:
	img_raw = Image.open(fname)
	print(fname)
	img = img_raw.convert("RGBA")
	img_w = img.size[0]
	img_h = img.size[1]
	for i in range(0, img_w):
		for j in range(0, img_h):
			data=img.getpixel((i, j))
			re=(16*int(data[0]/16),16*int(data[1]/16),16*int(data[2]/16),16*int(data[3]/16))
			img.putpixel((i,j),re)
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