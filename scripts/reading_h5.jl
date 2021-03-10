using Images
path = string(JImages.datadir, "/", "lena.h5")
println("path to Lena is $path")
lena = JImages.load_h5(path, "lena")
Gray.(lena)
