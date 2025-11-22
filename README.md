# Heart-attack-prediction -A Machine Learning Project

## 📊 Project Overview
This interactive R Shiny application allows users to calculate their Body Mass Index (BMI) and evaluate their potential risk for a heart attack based on key health factors.  
The app leverages both **manual rule-based risk logic** and a **Naive Bayes machine learning model** trained on simulated health data to provide actionable health insights.  

Users can:
- Calculate BMI and view category-specific recommendations  
- Assess heart attack risk using lifestyle, medical, and demographic inputs  
- Receive personalized health guidance based on risk factors  
- Explore BMI categories through interactive plots  

This project is ideal for **health awareness, personal risk assessment, and demonstration of health analytics using R Shiny**.

---

## 🛠 Tools and Technologies

### **Languages & Frameworks**
- **R** – Core language for computation and modeling  
- **R Shiny** – Interactive web application framework  
- **Shinydashboard** – Dashboard layout  
- **Shinythemes** – Custom styling  

### **Data Handling & Machine Learning**
- **dplyr** – Data manipulation  
- **caret** – Model training and evaluation  
- **e1071** – Naive Bayes classifier  

### **Visualization**
- **ggplot2** – Static plots (used in BMI calculation logic)  
- **plotly** – Interactive BMI category plots  

---

## 🎯 Objectives
- Provide a simple yet informative **BMI calculator**  
- Predict **heart attack risk** using lifestyle, medical, and demographic inputs  
- Generate **personalized recommendations** for maintaining or improving heart health  
- Demonstrate integration of **machine learning with interactive visualization**  

---

## 🔍 Features

### **1. BMI Calculation**
- Calculates BMI from user-provided height and weight  
- Categorizes BMI as Underweight, Normal, Overweight, or Obese  
- Provides health recommendations for each BMI category  

### **2. Heart Attack Risk Prediction**
- Rule-based risk logic based on:
  - Age  
  - Cholesterol level  
  - Smoking habit  
  - BMI  
  - Stress level  
  - Sleeping habits  
- Naive Bayes ML model trained on simulated health data for prediction  

### **3. Personalized Recommendations**
- Suggestions for reducing heart attack risk based on the user’s input factors  
- Covers cholesterol, smoking, BMI, stress, sleep, and age  

### **4. Interactive BMI Visualization**
- Bar plot showing BMI categories  
- Highlights the user’s BMI category for quick interpretation  

---

## 🧭 Example Use Case
1. User enters personal health details (age, height, weight, cholesterol, lifestyle factors).  
2. Clicks **Calculate** to get:
   - BMI value and category  
   - Heart attack risk (High or Low)  
   - Personalized recommendations
3. Users can visualize BMI categories and understand where they fall relative to others.

---

##  Visuals
<img width="780" height="386" alt="heart1" src="https://github.com/user-attachments/assets/e310c3b0-f397-45b3-a9b1-69adb9da1f13" />

---
<img width="760" height="852" alt="Heart2" src="https://github.com/user-attachments/assets/6d7460fd-7e00-4cfd-a146-7aa055fe924c" />

