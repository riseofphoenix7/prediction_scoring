# app.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import joblib
import numpy as np

# Initialize the FastAPI app
app = FastAPI()
# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins, you can restrict this to specific domains
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load your trained model
model = joblib.load('linear_regression_model.pkl')  # Update with your actual model filename

# Define the input data model
class InputData(BaseModel):
    revenue: float
    income: float

# Define the original prediction range
min_orig = 0  # Replace with your actual minimum predicted value from the model
max_orig = 10000000  # Replace with your actual maximum predicted value from the model

@app.post("/predict/")
def predict(data: InputData):
    # Prepare input data
    input_data = np.array([[data.revenue, data.income]])  # Convert to a numpy array
    prediction = model.predict(input_data)[0]

    # Scale prediction to a range of 0 to 10
    scaled_prediction = (prediction - min_orig) / (max_orig - min_orig) * 10
    scaled_prediction = min(max(scaled_prediction, 0), 10)  # Ensure it's between 0 and 10

    return {"predicted_rating": scaled_prediction}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
