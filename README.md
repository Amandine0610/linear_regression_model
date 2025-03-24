# 📊 Sports Premium Sales Forecasting Project

This project predicts sales for premium sports products using a linear regression model, deployed as a FastAPI API on Render, and integrated with a Flutter mobile app.

## Overview
- **Task 1**: Trained a linear regression model on sports premium sales data in Google Colab.
- **Task 2**: Built a FastAPI API to serve predictions, deployed on Render.
- **Task 3**: Developed a Flutter app with a beautiful UI to interact with the API.

## 📂 Project Structure  

linear_regression_model/
├── summative/
│   ├── API/
│   │   ├── prediction.py              # FastAPI app
│   │   ├── best_sports_premium_model.pkl  # Trained model
│   │   ├── scaler.pkl                # Data scaler
│   │   └── requirements.txt          # Python dependencies
├── flutter_app/                      # Flutter project folder
│   ├── lib/
│   │   └── main.dart                # Flutter UI code
│   └── pubspec.yaml                 # Flutter dependencies
└── README.md

---

## Setup and Installation

### Prerequisites
- Python 3.10
- Flutter 3.x
- Git
- Render account

### API Setup (Task 2)
1. **Clone the Repository**
   ```bash
   git clone https://github.com/Amandine0610/linear_regression_model.git
   cd linear_regression_model/summative/API

2. **Install Dependencies**
   ```bash
   pip install -r requirements.txt

3. **Run locally**
   ```bash
   python prediction.py

Access Swagger UI at http://localhost:8000/docs.

4. **Deployed API**

  - Live at: https://linear-regression-model-2-v1gt.onrender.com/predict .
  - Swagger UI: https://linear-regression-model-2-v1gt.onrender.com/docs.
  
**Flutter App Setup (Task 3)**
1. **Navigate to Flutter Folder**
   ```bash
   cd FlutterApp
   cd sales_forecasting_app
2. **Install dependencies**
   ```bash
   flutter pub get
3. **Run the App**
  - Connect a physical device (USB Debugging enabled).
  - Update main.dart with the Render URL: 
   ```dart
   final url = Uri.parse("https://linear-regression-model-2-v1gt.onrender.com/predict");
- Run:
  ``` bash
  flutter run

# Usage
 - **API:** POST to /predict with:
  ```json
  {"price": 500, "discount": 20, "marketing_spend": 5000}
  Response: {"predicted_units_sold": 31.09}.
 - **Flutter App:** Enter Price, Discount, and Marketing Spend, tap "Predict" to see forecasted units sold.
# Dependencies
 - **Python:** fastapi, uvicorn, scikit-learn, pandas, numpy, pydantic (see requirements.txt).
 - **Flutter:** http, fl_chart (see pubspec.yaml).

# Deployment
 - Hosted on Render with root directory summative/API.
 - Build: pip install -r requirements.txt.
 - Start: python prediction.py.

# Notes
 - Model trained on synthetic sports premium sales data (Task 1).
 - API validates inputs: Price (0-1000), Discount (0-50), Marketing Spend (0-10000).
 - Flutter UI uses Material 3 with a teal theme.

# Author
 - Amandine0610

# Demo Video link

