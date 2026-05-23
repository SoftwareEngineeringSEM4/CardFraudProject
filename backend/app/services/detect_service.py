import joblib
import pandas as pd

from backend.app.services.history_service import get_latest_transaction

model = joblib.load("backend/Models/model_fraud_rf.pkl")

print(model)
print(model.feature_names_in_)

def detect_latest_transaction():
    
    sample = pd.DataFrame([{
        "category": 1,
        "amt": 500000,
        "state": 1,
        "city_pop": 100000,
        "merch_zipcode": 12345,
        "age": 21,
        "distance_km": 5,
        "gender_female": 0,
        "trans_month": 5,
        "trans_day": 22,
        "trans_hour": 14,
        "trans_minute": 30,
        "trans_dayofweek": 4,
        "trans_dayofyear": 142
    }])

    prediction = model.predict(sample)[0]
    prediction_label = "Low Risk" if prediction == 0 else "High Risk"

    result = {
        "prediction": int (prediction)
    }

    return {"prediction": prediction_label}
