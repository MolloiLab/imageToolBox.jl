using DICOM, Statistics

"""
    This function reads the dicom file.
    - input:
        1. path to the dicom file
    - output:
        1. dcm_data
        2. SID
        3. V_P
        4. image
"""
function read_dicom(path_to_file::String)
    dcm_data = dcm_parse(path_to_file)
    # image
    image = dcm_data[(0x7fe0, 0x0010)]
    # v_p
    LorR = ""
    try
        LorR = uppercase(dcm_data[(0x0020,0x0062)])
    catch e
        println("---------Error---------")
        println(e)
        println(curr_path)
        println("---------Error---------")
    end
    V_P = ""
    try
        V_P = uppercase(dcm_data[(0x0018,0x5101)])
    catch e
        println("---------Error---------")
        println(e)
        println(curr_path)
        println("---------Error---------")
    end
    curr_key = LorR*" "*V_P
    # SID
    sid = [(0x0010, 0x0020)]
    return dcm_data, sid, curr_key, image
end

"""
    This function gets the number of patches needed for a iamge.
    - input:
        1. Matrix of Float32: the image
        2. Matrix of Float32: the roi
        3. Matrix of Float32: the binary mask representing the breast area.
    - optional input:
        1. Float64: `thd`. The threshold of percentage of the white area. Default = 0.35
        2. Int: 'patch_size'. The size of each patch. Default = 256
    - output:
        1. int: Number of without-BAC patches.
        2. int: Number of with-BAC patches.
"""
function get_num_of_patches(img::Matrix{Float32}, lbl::Matrix{Float32}, mask::Matrix{Float32}; thd = 0.35, patch_size = 256)
    patch_size_half = round(Int, patch_size/2)
    s = size(img)
    x = ceil(Int, s[1]/patch_size) + floor(Int, (s[1]-patch_size_half)/patch_size)
    y = ceil(Int, s[2]/patch_size) + floor(Int, (s[2]-patch_size_half)/patch_size)
    ct_empty, ct_non_empty = 0, 0
    for i = 1 : x-1
        x_start = 1+(i-1)*patch_size_half
        x_end = x_start+patch_size-1
        for j = 1 : y-1
            y_start = 1+(j-1)*patch_size_half
            y_end = y_start+patch_size-1
            # check if this is forgounrd
            if mean(mask[x_start:x_end, y_start:y_end]) > thd
                # check if contains BAC
                if sum(lbl[x_start:x_end, y_start:y_end]) > 0
                    ct_non_empty += 1
                else
                    ct_empty += 1
                end
            end
        end
        # right col
        y_start, y_end = s[2]-patch_size+1, s[2]
        # check if this is forgounrd
        if mean(mask[x_start:x_end, y_start:y_end]) > thd
            # check if contains BAC
            if sum(lbl[x_start:x_end, y_start:y_end]) > 0
                ct_non_empty += 1
            else
                ct_empty += 1
            end
        end
    end
    # last row
    x_start, x_end = s[1]-patch_size+1, s[1]
    for j = 1 : y-1
        y_start = 1+(j-1)*patch_size_half
        y_end = y_start+patch_size-1
        # check if this is forgounrd
        if mean(mask[x_start:x_end, y_start:y_end]) > thd
            # check if contains BAC
            if sum(lbl[x_start:x_end, y_start:y_end]) > 0
                ct_non_empty += 1
            else
                ct_empty += 1
            end
        end
    end
    # right col
    y_start, y_end = s[2]-patch_size+1, s[2]
    # check if this is forgounrd
    if mean(mask[x_start:x_end, y_start:y_end]) > thd
        # check if contains BAC
        if sum(lbl[x_start:x_end, y_start:y_end]) > 0
            ct_non_empty += 1
        else
            ct_empty += 1
        end
    end
    return ct_empty, ct_non_empty
end