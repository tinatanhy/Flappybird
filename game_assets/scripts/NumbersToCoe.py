from PIL import Image

dep = 3
wid = 16
file = open(f"./game_assets/coe/Numbers_{dep}kx{wid}.coe","w")
file.write(f";{dep}k*{wid}\nmemory_initialization_radix=16;\nmemory_initialization_vector=\n")

size = 120 * 18
img_raw = Image.open("./game_assets/numbers.png")
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

for i in range(0,dep * 1024 - size):
	file.write("0000 ")
file.write("\n;")
print("Finish")