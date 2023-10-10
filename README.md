# 🌟 Medical Image Processing Tools 🌟

Welcome to the **Medical Image Processing Tools** repository! This repository provides a collection of tools for processing medical images, specifically DICOM and PNG files, as well as various utility functions.

---

## 📌 Table of Contents

- [🔧 Dependencies](#dependencies-🔧)
- [🖼 DICOM Tools](#dicom-tools-🖼)
- [🛠 Other Tools](#other-tools-🛠)
- [🎨 PNG Tools](#png-tools-🎨)

---

<a name="dependencies-🔧"></a>
## 🔧 Dependencies

- 📦 `DICOM`
- 📊 `Statistics`
- 📄 `CSV`
- 📈 `DataFrames`
- 📅 `Dates`
- 🖼 `Images`

---

<a name="dicom-tools-🖼"></a>
## 🖼 DICOM Tools

### 📖 `read_dicom(path_to_file::String)`

🔍 Reads a DICOM file.

- **Input**:
  - 📂 `path_to_file`: Path to the DICOM file.
- **Output**:
  - 📄 DICOM data.
  - 🆔 SID.
  - 🔑 V_P.
  - 🖼 Image.

### 📖 `get_num_of_patches(img::Matrix{Float32}, lbl::Matrix{Float32}, mask::Matrix{Float32}; thd = 0.35, patch_size = 256)`

🔍 Gets the number of patches needed for an image.

- **Input**:
  - 🖼 `img`: The image.
  - 🎯 `lbl`: The ROI.
  - 🎭 `mask`: Binary mask representing the breast area.
- **Optional Input**:
  - 📏 `thd`: Threshold of percentage of the white area. Default = 0.35.
  - 📐 `patch_size`: Size of each patch. Default = 256.
- **Output**:
  - 🚫 Number of without-BAC patches.
  - ✅ Number of with-BAC patches.

---

<a name="other-tools-🛠"></a>
## 🛠 Other Tools

### 📖 `histogram_equalization(img; mask=nothing)`

🔍 Applies histogram equalization to the image. If the optional `mask` is provided, it will still process the whole image but only based on the mask area.

- **Input**:
  - 🖼 `img`: Image to be processed.
  - (optional) 🎭 `mask`: Mask containing only 1 and 0.
- **Output**:
  - 🖼 Processed image.
  
### 📖 `save_to_csv(column_names_, data::Matrix, csv_name::String)`

💾 Saves data to a local CSV file.

- **Input**:
  - 📋 `column_names_`: Column names.
  - 📊 `data`: 2D array of data.
  - 📄 `csv_name`: Name of the CSV file.

### 📖 `get_last_edit_time(file_path::String)`

🕰 Gets the last edit time of a file.

- **Input**:
  - 📂 `file_path`: Path to the file.
- **Output**:
  - 📅 Last edit time in `Dates` format.

### 📖 `search_files_by_ext(root_dir, file_ext)`

🔍 Recursively looks for all files in folders and subfolders based on file extension.

- **Input**:
  - 📂 `root_dir`: Root directory.
  - 📄 `file_ext`: Extension of a file to search for (e.g., ".dcm").
- **Output**:
  - 📋 List of found paths.

### 📖 `search_files_by_name(root_dir, file_name)`

🔍 Recursively looks for the target file by name.

- **Input**:
  - 📂 `root_dir`: Root directory.
  - 📄 `file_name`: Name of the target file.
- **Output**:
  - 📋 Path to the target file (or an empty string if not found).

### 📖 `binary_search_SID(SIDs, target)`

🔍 Looks for a target element in an array (binary search). The input array should be sorted.

- **Input**:
  - 📋 `SIDs`: List containing the target.
  - 🎯 `target`: The target element.
- **Output**:
  - 🔢 Index of the target in the SID list (-1 if not found).

### 📖 `zoom_pixel_values(img; mask=nothing)`

🔍 Zooms pixel values of an image to the range [0, 1]. If the optional `mask` is provided, it will still process the whole image but only based on the mask area.

- **Input**:
  - 🖼 `img`: Input image.
  - (optional) 🎭 `mask`: Mask containing only 1 and 0.
- **Output**:
  - 🖼 Zoomed image.

### 📖 `copy_file(old_path::String, new_path::String)`

🔍 Copies a file to a new path.

- **Input**:
  - 📂 `old_path`: Old path of the file.
  - 📂 `new_path`: New path for the file.

### 📖 `clean_directory(directory::String)`

🔍 Deletes everything inside a directory.

- **Input**:
  - 📂 `directory`: Directory to be cleaned.

### 📖 `normalize_img(img; mask=nothing)`

🔍 Changes the image, making the mean of all pixel values to 0, and std to 1. If the optional `mask` is provided, it will still process the whole image but only based on the mask area.

- **Input**:
  - 🖼 `img`: Image to be processed.
  - (optional) 🎭 `mask`: Mask containing only 1 and 0.
- **Output**:
  - 🖼 Processed image.

---

<a name="png-tools-🎨"></a>
## 🎨 PNG Tools

### 📖 `read_png(path_to_file::String)`

🔍 Reads a PNG file.

- **Input**:
  - 📂 `path_to_file`: Path to the PNG file.
- **Output**:
  - 🖼 Image in `Matrix{Float32}` format.

### 📖 `get_breast_mask(raw_img::Matrix{Float32})`

🎭 Finds the breast area and creates a mask.

- **Input**:
  - 🖼 `raw_img`: The raw image in `Matrix{Float32}` format.
- **Output**:
  - 🎭 Binary mask in `Matrix{Float32}` format.

---

