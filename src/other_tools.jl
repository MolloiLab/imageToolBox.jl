using CSV, DataFrames, Dates





"""
    This function saves data to local as csv file.
    - input:
      1. String: file_name
      2. 1-D Array of Strings: column normalizes
      3. 2-D Array: data
"""
function save_to_csv(column_names_, data::Matrix, csv_name::String)
    column_names = vec(column_names_)
    # Ensure the column names match the data dimensions
    if size(data, 2) != length(column_names)
        throw(ArgumentError("Mismatch between number of columns in data and provided column names"))
    end

    # Create a DataFrame from the data and column names
    df = DataFrame(data, Symbol.(column_names))

    # Save the DataFrame to a CSV file
    CSV.write(csv_name, df)
end

"""
    This function gets the last edit time of a file.
    - input:
        1. String: path to the file
    - output:
        1. Dates: the last edit time
"""
function get_last_edit_time(file_path::String)
    try
        # Get the file's stat information
        file_stat = stat(file_path)
        
        # Extract the last modification time (mtime) in seconds since the epoch
        last_edit_time_epoch = file_stat.mtime
        
        # Convert the epoch time to a more readable DateTime format
        last_edit_time = Dates.unix2datetime(last_edit_time_epoch)
        
        return last_edit_time
    catch e
        println("An error occurred: ", e)
        return nothing
    end
end

"""
    This function recursively look for all files in folders and subfolders.
    - input:
        1. String: root dir
        2. String: extension of a file to search for. Note: input should be ".dcm" instead of "dcm".
    - output:
        1. Array: a list of found paths.
"""
function search_files_by_ext(root_dir, file_ext)

	files=[]
	
	# collect curr folder info
	sub_files, sub_dirs = [], []
	for f in readdir(root_dir)
		curr_path = joinpath(root_dir, f)

		if isdir(curr_path)
			push!(sub_dirs, curr_path)
		else
			push!(sub_files, curr_path)
		end
	end
	dir_ct = size(sub_dirs)[1]
	files_found = Array{Any}(undef, dir_ct)
	
	# folders: rec calls
	Threads.@threads for i = 1 : dir_ct
		files_found[i] = rec_search(sub_dirs[i], file_ext)
	end
	
	# Append after multithreading to prevent data races
	for i = 1 : dir_ct
		append!(files, files_found[i])
	end

	# files: check if it's DICOM image
	for f in sub_files
		 _, f_ext = splitext(f)
		if f_ext == file_ext
			push!(files, f)
		end
	end
	
	return files
end

"""
    This function recursively look for the target file.
    - input:
        1. String: root dir
        2. String: file name of the target file
    - output:
        1. Array of String: path to the target file. "" if not found.
"""
function search_files_by_name(root_dir, file_name)
	# collect curr folder info
	sub_files, sub_dirs = [], []
	for f in readdir(root_dir)
		curr_path = joinpath(root_dir, f)

		if isdir(curr_path)
			push!(sub_dirs, curr_path)
		else
			push!(sub_files, curr_path)
		end
	end
	dir_ct = size(sub_dirs)[1]
	files_found = Array{Any}(undef, dir_ct)
	
	# folders: rec calls
	Threads.@threads for i = 1 : dir_ct
		files_found[i] = search_files_by_name(sub_dirs[i], file_name)
	end

    new_founds = Array{String, 1}(undef, 0)
	# files: check if it's target_file
	for f in sub_files
		if rsplit(f, "/"; limit = 2)[2] == file_name
            push!(new_founds, f)
		end
	end

    rslt = Array{String, 1}(undef, 0)
    # combine paths
    for f in files_found
        for ff in f
            if ff != ""
                push!(rslt, ff)
            end
        end
    end
    for ff in new_founds
        if ff != ""
            push!(rslt, ff)
        end
    end
    return unique(rslt)
end

"""
    This function looks for a target element in a array. The input array should be already sorted.
    - input:
        1. Array of T: list contains the target
        2. T: the target
    - output:
        1. int: index of the target in SID list. -1 if not found.
"""
function binary_search_SID(SIDs, target)
    low = 1
    high = size(SIDs)[1]
    
    while low <= high
        mid = div(low + high, 2)
        
        if SIDs[mid] == target
            return mid
        elseif SIDs[mid] < target
            low = mid + 1
        else
            high = mid - 1
        end
    end
    
    return -1  # Return -1 if the target is not found
end

"""
    This function zoom pixel values of a image to range of [0, 1]. If the optional `mask` is provided, it will still process the whole image but only based on the mask area.
    - input:
        1. Matrix: the input image
        2. (optional) Array: mask, which contains only 1 and 0.
    - output: 
        1. Matrix: the zoomed image.
"""
function zoom_pixel_values(img; mask=nothing)
    selection = (mask == nothing) ? nothing : findall(isone, mask)
    # Determine if we're working on the whole image or a selection
    working_img = (selection !== nothing) ? img[selection] : img
    
    a, b = minimum(working_img), maximum(working_img)
    img_ = (img .- a) ./ (b - a)
    
    if mask !== nothing
        img_ = img_ .* mask
    end

    return img_
end

"""
    This function copys a file to a new path.
    - input:
        1. String: old path of the file
        2. String: new path of the file
"""
function copy_file(old_path::String, new_path::String)
    # Check if the old DICOM file exists
    if !isfile(old_path)
        println("Error: The file does not exist.")
        return
    end
    
    # Check if the new path directory exists, if not create it
    new_dir = dirname(new_path)
    if !isdir(new_dir)
        # println("Creating new directory: ", new_dir)
        mkpath(new_dir)
    end
    
    # Copy the file
    if isfile(new_path)
        return
    end
    try
        cp(old_path, new_path)
    catch e
        println("An error occurred while copying the file: ", e)
    end
end

"""
    This function deletes verything inside the dir.
    - input:
        1. String: dir to be cleaned.
"""
function clean_directory(directory::String)
    for item in readdir(directory)
        item_path = joinpath(directory, item)
        rm(item_path, recursive=true)
    end
end

"""
    This function changes the image, making mean of all pixel values to 0, and std to 1. If the optional `mask` is provided, it will still process the whole image but only based on the mask area.
    - input:
        1. Array: image to be processed.
        2. (optional) Array: mask, which contains only 1 and 0.
    - output:
        1. Array: The processed image.
"""
function normalize_img(img; mask=nothing, invert = false)
    if mask !== nothing
        selection = findall(isone, mask)
        selected_area = img[selection]
        m = maximum(selected_area)
        a = mean(selected_area)
        s = std(selected_area)
    else
        m = maximum(img)
        a = mean(img)
        s = std(img)
    end

    img_ = deepcopy(img)

    if invert
    	img_ = m .- img_
    end
    
    img_ = (img_ .- a) ./ s 

    if mask !== nothing
        img_ = img_.*mask
    end

    return img_
end

"""
    This function applies histogram equalization to the image. If the optional `mask` is provided, it will still process the whole image but only based on the mask area.
    - input:
        1. Array: image to be processed.
        2. (optional) Array: mask, which contains only 1 and 0.
    - output:
        1. Array: The processed image.
"""
function histogram_equalization(img; mask=nothing)
    selection = (mask == nothing) ? nothing : findall(isone, mask)
    img = zoom_pixel_values(img; mask = mask)
    # Determine if we're working on the whole image or a selection
    working_img = (selection !== nothing) ? img[selection] : img
    len = length(working_img)
    
    # Initialize histogram and cumulative histogram
    nbins = 256
    hist = zeros(Int, nbins)
    chist = zeros(Int, nbins)
    
    # Compute the histogram
    for val in working_img
        bin = Int(floor(val * (nbins - 1)) + 1)
        hist[bin] += 1
    end
    
    # Compute the cumulative histogram
    chist[1] = hist[1]
    for i in 2:nbins
        chist[i] = chist[i - 1] + hist[i]
    end
    
    # Perform histogram equalization
    min_chist = minimum(filter(x -> x > 0, chist))
    total_pixels = len
    new_img = copy(img)
    
    indices = (selection !== nothing) ? selection : 1:length(img)
    for i in indices
        bin = Int(floor(img[i] * (nbins - 1)) + 1)
        new_intensity = (chist[bin] - min_chist) / (total_pixels - min_chist)
        new_img[i] = Float32(new_intensity)
    end
    
    if mask !== nothing
        new_img = new_img .* mask
    end

    return new_img
end
