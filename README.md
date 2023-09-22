# 🌟 Medical Image Processing Tools 🌟

Welcome to the **Medical Image Processing Tools** repository! This repository provides a collection of tools for processing medical images, specifically DICOM and PNG files, as well as various utility functions.

---

## 📌 Table of Contents

- [🔧 Dependencies](#dependencies)
- [🖼 DICOM Tools](#dicom-tools)
- [🛠 Other Tools](#other-tools)
- [🎨 PNG Tools](#png-tools)

---

## 🔧 Dependencies

- 📦 `DICOM`
- 📊 `Statistics`
- 📄 `CSV`
- 📈 `DataFrames`
- 📅 `Dates`
- 🖼 `Images`

---

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

## 🛠 Other Tools

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

[... Continue with other functions in the same format ...]

---

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

