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

# Deconvolve
iter = 100
println("Running RL with  iter = $iter  variable quiet = $quiet")
@time lena_d, DFR = richardson_lucy(lena_g1, kg1,
                                    iterations=iter,
                                    view_window =1,
                                    fom_window=64,
                                    debug_level=quiet)


println(" Running fast RL: iter = $iter")
@time lena_d2 = frichardson_lucy(lena_g1, kg1, iterations=iter)
