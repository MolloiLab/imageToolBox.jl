using Images

"""
    This function read a png file.
    - input:
        1. String: Path to the png file
    - output:
        1. Matrix{Float32}: the image
"""
function read_png(path_to_file::String)
    _, f_ext = splitext(path_to_file)
    if f_ext != ".png"
        println("Error: not a png file.")
    end
    return Float32.(Images.load(path_to_file))
end

"""
    This function find the breast area and create a mask.
    - input:
        1. Matrix{Float32}: the raw image.
    - output:
        1. Matrox{Float32}: the binary mask.
"""
function get_breast_mask(raw_img::Matrix{Float32})
    mask = 1 .- round.(imageToolBox.zoom_pixel_values(raw_img))
    return mask
end