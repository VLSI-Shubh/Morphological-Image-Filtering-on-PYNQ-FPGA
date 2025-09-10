# 🎨 Morphological Image Filtering on PYNQ FPGA

This project implements **morphological filtering (min, max, and median filters)** on color images using the **PYNQ-Z2 FPGA board**, achieving real-time image enhancement.  
The design demonstrates how FPGA-based hardware acceleration can outperform software-only approaches for **noise reduction, edge preservation, and texture segmentation**.  

The project integrates:  
1. **Custom VHDL hardware IP** for filtering operations  
2. **Python (PYNQ framework)** for image I/O, DMA communication, and visualization  

While median, min, and max filters were successfully implemented, the mean filter was excluded due to latency overheads.  

---

## 🧠 Project Overview

The main learning objective was to design a **hybrid HW/SW image processing system** where:  
- FPGA handles **parallel pixel processing** using dedicated filter modules.  
- Python handles **pre/post-processing** and user interaction.  

This project highlights the FPGA’s ability to perform morphological operations at high speed while keeping the design flexible via software control.  

---

## ⚙️ Design Approaches

### 🔧 Hardware: VHDL Filtering IP

- Developed custom IP block `FilterSelect_v1_0` containing three submodules:  
  - `FilterSelectColorR.vhdl`  
  - `FilterSelectColorG.vhdl`  
  - `FilterSelectColorB.vhdl`  
- Each module processes its **8-bit RGB channel** with a **3×3 kernel**.  
- **Filter operations implemented**:  
  - **Min filter** → smooths image, preserves large edges (erosion)  
  - **Max filter** → enhances bright regions, fills small gaps (dilation)  
  - **Median filter** → removes noise while preserving edges (bubble sort)  
- Two on-board switches used for **real-time selection**:  
  - `00` → Min filter  
  - `01` → Median filter  
  - `10` → Max filter  
![Hardware Block Diagram](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/419d0e4cca2e53c5f4f26212dc5e29819e28c714/images/hardware%20block%20diagram.png)  
---

### 🖥️ Software: Python on PYNQ

- Loaded input image (`reflect.jpg`) and split into **RGB channels**.  
- Packed channels into **32-bit arrays** (`R<<16 | G<<8 | B`).  
- Sent pixel streams via **AXI-DMA (PS→PL)** to the FPGA.  
- Collected processed pixels (PL→PS) and reconstructed image arrays.  
- Displayed results using **Matplotlib** for visualization.  
![Software Block Diagram](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/419d0e4cca2e53c5f4f26212dc5e29819e28c714/images/software%20block%20diagram.png)  
---

## 🧩 Architecture Overview

### 🧭 System Block Diagram
![System Block Diagram](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/419d0e4cca2e53c5f4f26212dc5e29819e28c714/images/schematic.png)  

- Python sends pre-processed pixel streams → FPGA IP  
- FPGA applies selected filter → returns processed data  
- Python reconstructs RGB image and displays output  

---

### 🔁 Filter Selection Logic
![Filter Selection](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/d7d0a722a6d87ce8659386d8c5e3ae0e81111da5/images/filter%20selection%20logic.png)  

| Switch `sw1` | Switch `sw0` | Operation |
|--------------|--------------|-----------|
| 0            | 0            | Min       |
| 0            | 1            | Median    |
| 1            | 0            | Max       |

---

## 🔬 Output Snapshots

### 📷 Input Image
![Input](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/d7d0a722a6d87ce8659386d8c5e3ae0e81111da5/images/input%20Image.jpeg)  

### 🔎 Min Filter Output
![Min](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/d7d0a722a6d87ce8659386d8c5e3ae0e81111da5/images/Min.jpeg)  

### 🧮 Median Filter Output
![Median](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/d7d0a722a6d87ce8659386d8c5e3ae0e81111da5/images/Median.jpeg)  

### 💡 Max Filter Output
![Max](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/d7d0a722a6d87ce8659386d8c5e3ae0e81111da5/images/Max.jpeg)  

### 💡 Verification from Matlab
![Verification (from Matlab)](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/935d42752c23a625714e7765272f9e601c4ba141/images/matlab%20output.png)  
---

## 📁 Project Files

| File/Folder            | Description |
|------------------------|-------------|
| `VHDL/`                | VHDL source code (filter modules, IP wrapper) |
| `MorthFilters-1-1.ipynb`   | Python Jupyter notebook for image processing |
| `images/`              | Input/output test images and results |

---

## 🛠️ Tools Used

| Tool / Framework       | Purpose |
|------------------------|---------|
| **Vivado 2018**        | VHDL synthesis & bitstream generation |
| **Python (PYNQ)**      | Image processing, DMA communication |
| **NumPy / Matplotlib** | Image packing, reconstruction & visualization |
| **MATLAB**             | Reference image filtering for verification |

---

## 📊 Results

- Real-time processing of **64×64 RGB images** with **<10% LUT usage**.  
- **Pixel-level accuracy** verified against MATLAB outputs for min, median, and max filters.  
- Successfully implemented **switch-controlled runtime filter selection**.  
- Excluded mean filter due to high latency, ensuring real-time performance.  

---

## 🚀 Future Enhancements

- Extend system to process **live webcam input**.  
- Implement an **optimized mean filter** to complete filter set.  
- Add a **GUI-based filter selector** instead of hardware switches.  
- Explore **advanced morphological operations** (region-based, texture analysis).  
- Potential integration with **machine learning pipelines**.  

---

## ✅ Conclusion

This project demonstrates how **morphological filtering can be accelerated on FPGA** for real-time image enhancement.  
By combining **parallel VHDL-based hardware filters** with **Python-based orchestration**, we achieved:  

- ✅ Fast, switch-controlled filter selection  
- ✅ Resource-efficient design (<10% LUTs)  
- ✅ MATLAB-verified accuracy  

This work highlights the **strength of HW/SW co-design** in digital image processing applications.  

---

## 📝 License

Open for educational and personal use under the ![MIT License](https://github.com/VLSI-Shubh/Morphological-Image-Filtering-on-PYNQ-FPGA/blob/148607d639a483a29600fda4e68388c838aca323/License.txt).  

