from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import pickle
import pandas as pd

app = FastAPI(title="Sports Premium Sales Forecasting API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class SalesInput(BaseModel):
    price: float = Field(..., ge=0, le=1000, description="Price of the sports product (0-1000)")
    discount: float = Field(..., ge=0, le=50, description="Discount percentage (0-50)")
    marketing_spend: float = Field(..., ge=0, le=10000, description="Marketing spend in dollars (0-10000)")

# Load model and scaler
with open('best_sports_premium_model.pkl', 'rb') as f:
    model = pickle.load(f)
with open('scaler.pkl', 'rb') as f:
    scaler = pickle.load(f)

@app.post("/predict")
async def predict(input_data: SalesInput):
    try:
        data = pd.DataFrame({
            'Price': [input_data.price],
            'Discount': [input_data.discount],
            'Marketing_Spend': [input_data.marketing_spend]
        })
        scaled_data = scaler.transform(data)
        prediction = model.predict(scaled_data)[0]
        prediction = round(float(prediction), 2)
        return {"predicted_units_sold": prediction}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8000))  
    uvicorn.run(app, host="0.0.0.0", port=port)