# Senior-Project-Files
Advancing Breast Cancer Diagnosis: Deep Learning-Based AI for Automated Histopathological Tissue Scoring for

---

## 🧠 Project Overview

This application uses transfer learning with pretrained convolutional neural networks (CNNs) — **VGG19**, **InceptionNet**, and **AlexNet** — to classify immunohistochemically stained breast cancer tissue into 4 categories based on HER2 expression:
- **0+** (Benign)
- **1+** (Normal)
- **2+** (In-Situ)
- **3+** (Malignant)

A custom MATLAB-based GUI provides model selection, performance visualization, and evaluation of classification outcomes.

---

## 🛠️ Features

- MATLAB GUI with interactive navigation
- Preprocessing and dataset loading automation
- Transfer learning using VGG19, ResNet-50, GoogLeNet
- Confusion matrix generation and accuracy/precision/recall/F1-score computation
- Heatmap and misclassified sample visualization
- Evaluation against validation/test datasets
- Learning rate tuning (control: `0.0005`, optimized: `0.00025`)

---

## 📁 Folder Structure
├── evaluateModel.m # Evaluates model predictions and metrics
├── createImgDB.m # Loads and preprocesses image dataset
├── AlexNetClassification.m # Sets up AlexNet for HER2 classification
├── TransferLearnVGG.m # VGG19 model setup with new classification layers
├── InceptionNet.m # InceptionNet model setup and training
├── googleNet.m # (Optional) Experimental model setup for GoogLeNet
├── README.md # Project documentation
├── .git/ # Git tracking folder
---

## 📊 Results Summary

| Model       | Accuracy | Precision | Recall | F1 Score |
|-------------|----------|-----------|--------|----------|
| VGG19       | 90%      | 89%       | 90%    | 89%      |
| Inception   | **91%**  | 91%       | 91%    | 90%      |
| AlexNet     | 88%      | 87%       | 88%    | 87%      |

*Note: Best performance was achieved with a learning rate of `0.00025`.*

---

## ⚙️ Requirements

- MATLAB R2024b or later
- Deep Learning Toolbox
- Image Processing Toolbox
- Pretrained CNN models (install via Add-Ons in MATLAB)

---

## 🚀 How to Run

1. Clone this repository:
   ```bash
   git clone https://github.com/JalenM4/Senior-Project-Files.git
   run evaluateModel.m'''

---

## Author

Jalen Mason
Computer Science, Class of 2025
Virginia State University
GitHub: @JalenM4
