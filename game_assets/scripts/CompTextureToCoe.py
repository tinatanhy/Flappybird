from PIL import Image

file = open("./game_assets/coe/CompTexture_7kx16.coe","w")
file.write(";7k*16\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")

files = [
	"./game_assets/tutorial.png",
	"./game_assets/gameover.png",
	"./game_assets/ready.png",
]
size = 57*49+96*21+92*25
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
	for j in range(0,img_h):
		for i in range(0,img_w):
			data=img.getpixel((i, j))
			re=['%01X' %int(s/16) for s in data]
			result=""
			for item in re:
				result+=item
			file.write(result)
			file.write(" ")
		file.write("\n")

for i in range(0,7 * 1024 - size):
	file.write("0000 ")
file.write("\n;")
print("Finish")