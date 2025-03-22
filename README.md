# 📊 Sales Forecasting Model 

## 🚀 Project Overview  
This project focuses on **predicting sales** for an **E-commerce business** using **Machine Learning models**.  
The goal is to help businesses optimize pricing, discounts, and marketing strategies by predicting **units sold** based on key factors like:  

✔ **Product Category**  
✔ **Price**  
✔ **Discount**  
✔ **Customer Segment**  
✔ **Marketing Spend**  

I implemented **Linear Regression, Decision Trees, and Random Forest** models and deployed the best-performing model using **FastAPI**. The predictions are used in a **Flutter mobile app** that allows users to input product details and get sales forecasts.  

---

## 📂 Project Structure  
linear_regression_model/ │ ├── summative/ │ ├── linear_regression/ │ │ ├── multivariate.ipynb # Jupyter notebook with model training & evaluation │ ├── API/ │ │ ├── prediction.py # FastAPI implementation │ │ ├── requirements.txt # Required Python libraries │ ├── FlutterApp/ │ │ ├── main.dart # Flutter app for predictions
---

## 📊 Dataset Description  
- **Source**: *(Add the Kaggle or other dataset link here)*  
- **Size**: *(Number of rows & columns)*  
- **Features**:  
  - `Product_Category`: Encoded categorical variable representing product type  
  - `Price`: The cost of the product  
  - `Discount`: Discount offered on the product  
  - `Customer_Segment`: Encoded categorical variable representing the customer group  
  - `Marketing_Spend`: Amount spent on marketing  
  - `Units_Sold`: The target variable (sales prediction)  

📌 **Data Processing Steps:**  
✔ Encoded categorical variables (`Product_Category`, `Customer_Segment`)  
✔ Standardized numerical features (`Price`, `Discount`, `Marketing_Spend`)  
✔ Split dataset into **80% training and 20% testing**  

---

## 🛠️ Models Implemented  

| Model               | Mean Squared Error (MSE) | R² Score |
|---------------------|------------------------|----------|
| **Linear Regression (SGD)** | 84.7276  | -0.0925  |
| **Decision Tree**  | 106.0950  | -0.1504  |
| **Random Forest**  | 59.0906  | -0.0925  |

🎯 **Best Model: Random Forest**  
📌 **Reason**: Lowest MSE and better predictive performance.  

---

## 🌐 API Implementation (FastAPI)  
We built an API using **FastAPI** to handle prediction requests.  

✔ **Endpoint**: `/predict`  
✔ **Method**: `POST`  
✔ **Input Variables**:  

---

## 📊 Dataset Description  
- **Source**: *(Add the Kaggle or other dataset link here)*  
- **Size**: *(Number of rows & columns)*  
- **Features**:  
  - `Product_Category`: Encoded categorical variable representing product type  
  - `Price`: The cost of the product  
  - `Discount`: Discount offered on the product  
  - `Customer_Segment`: Encoded categorical variable representing the customer group  
  - `Marketing_Spend`: Amount spent on marketing  
  - `Units_Sold`: The target variable (sales prediction)  

📌 **Data Processing Steps:**  
✔ Encoded categorical variables (`Product_Category`, `Customer_Segment`)  
✔ Standardized numerical features (`Price`, `Discount`, `Marketing_Spend`)  
✔ Split dataset into **80% training and 20% testing**  

---

## 🛠️ Models Implemented  

| Model               | Mean Squared Error (MSE) | R² Score |
|---------------------|------------------------|----------|
| **Linear Regression (SGD)** | 84.7276  | -0.0925  |
| **Decision Tree**  | 106.0950  | -0.1504  |
| **Random Forest**  | 59.0906  | -0.0925  |

🎯 **Best Model: Random Forest**  
📌 **Reason**: Lowest MSE and better predictive performance.  

---

## 🌐 API Implementation (FastAPI)  
We built an API using **FastAPI** to handle prediction requests.  

✔ **Endpoint**: `/predict`  
✔ **Method**: `POST`  
✔ **Input Variables**:  

```json
{
  "Product_Category": 0,
  "Price": 500,
  "Discount": 10,
  "Customer_Segment": 2,
  "Marketing_Spend": 7000
}
✔ Response Example:

json
Copy
Edit
{
  "Predicted_Sales": 35.80
}
🚀 Running the API

1️⃣ Install dependencies
pip install -r requirements.txt
2️⃣ Run FastAPI

uvicorn API.prediction:app --reload
3️⃣ Open Swagger UI to test the API
http://127.0.0.1:8000/docs

📱 Flutter Mobile App
A Flutter app was created to interact with the API. Users enter product details, click "Predict," and receive an estimated sales figure.

✔ Has input fields for all features
✔ Sends data to API and displays the prediction
✔ Handles errors (e.g., missing inputs)

🎥 Demo Video
📌 Watch the 2-minute demo of the API & mobile app:
👉 [Insert YouTube link here]

🚀 Deployment & Testing
📌 Live API URL: [Insert public API URL if hosted]
📌 GitHub Repository: [Insert your GitHub repo link]

📌 How to Run Locally
1️⃣ Clone the Repository
bash
Copy
Edit
git clone https://github.com/your_username/sales_forecasting.git
cd sales_forecasting
2️⃣ Install Dependencies
pip install -r requirements.txt
3️⃣ Run the API
uvicorn API.prediction:app --reload
4️⃣ Run the Flutter App
flutter run

📌 Conclusion
✔ This project successfully builds a sales forecasting model and integrates it into an API & mobile app.
✔ The Random Forest model provided the best results.
✔ The FastAPI endpoint allows real-time predictions.
✔ The Flutter app makes predictions user-friendly & accessible.


🚀 Future Improvements
🔹 Fine-tune hyperparameters for better performance
🔹 Deploy API to a cloud service for real-world use
🔹 Improve Flutter UI for better user experience

📩 Contact
📌 Have questions? Reach out via [a.irakoze@alustudent.com]