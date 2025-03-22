from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import joblib
import numpy as np

# Load the saved model
model = joblib.load("sales_forecasting_model.pkl")

# Define the API app
app = FastAPI(title="Sales Forecasting API", description="Predicts the number of units sold based on input features")

# Define the expected input data format
class SalesInput(BaseModel):
    Product_Category: int
    Price: float
    Discount: float
    Customer_Segment: int
    Marketing_Spend: float


@app.post("/predict")
def predict_sales(data: SalesInput):
    """Predict the number of units sold based on input features."""
    
    # Convert input data into NumPy array
    input_data = np.array([[data.Product_Category, data.Price, data.Discount, data.Customer_Segment, data.Marketing_Spend]])
    
    # Make prediction
    prediction = model.predict(input_data)[0]
    
    return {"Predicted Units Sold": round(prediction, 2)}

@app.get("/")
def home():
    return {"message": "API is running!"}

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (you can restrict to specific domains later)
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

# Run the API using uvicorn
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
