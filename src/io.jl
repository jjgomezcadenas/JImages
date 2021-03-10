using HDF5

"""
Syntactic sugar for h5open
"""
function load_h5(path::String, image_id::String)
    image = h5open(path, "r") do file
        read(file, image_id)
    end
    return image
end