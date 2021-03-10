using JImages
using Images 
using Test

function test_image_fom(x::AbstractArray, y::AbstractArray)
    dff = x .- y
    adff = broadcast(abs,dff)
    sdff = sum(adff) /sum(x)
    return sdff
end

function test_limit_boundaries_low(y::AbstractArray)
    yc = copy(y)
    yc2 = copy(y)
    for i in 1:5
        yc[i,i] = 0
        yc2[i,i] = 0.5
    end
    JImages.limit_boundaries(yc, 0.5)
    return yc, yc2
end

function test_zero_protection(y::AbstractArray)
    yc = copy(y)
    yc2 = copy(y)
    for i in 1:5
        yc[i,i] = 0
        yc2[i,i] = 0.5
    end
    println("in test zero protection")
    JImages.zero_protection(yc, 0.5)
    return yc, yc2
end


function test_limit_boundaries_high(y::AbstractArray)
    yc = copy(y)
    yc2 = copy(y)
    for i in 1:5
        yc[i,i] = 200.
        yc2[i,i] = 100.
    end
    JImages.limit_boundaries(yc, eps(), 100.)
    return yc,yc2
end
@testset "JImages.jl" begin
    x = reshape([i+(j-1)* 1. * i for j in 1:5 for i in 1:5],(5,5))
    y = reshape([i+(j-1)*2. * i for j in 1:5 for i in 1:5],(5,5))
    xy = reshape([(i,j) for j in -2:2 for i in -2:2], (5,5))
    xc = reshape([[4.,6.,8.] [6.,9.,12.] [8.,12.,16.]],(3,3))
    xf = reshape([[25,
                20, 15, 10, 5] [20,
                16, 12, 8, 4] [15,
                12, 9, 6, 3] [10,
                8, 6, 4, 2] [5,
                4, 3, 2, 1]],
               (5,5)) .*1.0
    kg1 = Kernel.gaussian(1)
    ktest = JImages.gaussianxy(xy)
    @test JImages.dxy(10, -3) == 13
    @test JImages.image_fom(x, y) == test_image_fom(x, y)
    @test JImages.center_view(x, 1) == xc
    @test JImages.flip2d(x) == xf
    @test isapprox(ktest, collect(kg1))

    yl, yl2 = test_limit_boundaries_low(y)
    yh, yh2 = test_limit_boundaries_high(y)
    yz, yz2 = test_zero_protection(y)
    @test isapprox(yl,yl2)
    @test isapprox(yh,yh2)
    @test isapprox(yz,yz2)
end

