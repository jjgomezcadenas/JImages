 using Images
# using ImageIO
# using ImageView

using ImageFiltering
using BenchmarkTools

using JImages

path = string(datadir, "/", "lena.h5")
println("path to Lena is $path")
lena = load_h5(path, "lena")

# define a gaussian Kernel
kg1 = Kernel.gaussian(1)

# convolve
println("Convolving Lena")
@time lena_g1 = imfilter(lena, reflect(centered(kg1)), Fill(0))
