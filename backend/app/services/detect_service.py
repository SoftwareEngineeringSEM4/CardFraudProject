import joblib
import pandas as pd
from datetime import datetime

from backend.app.database import SessionLocal
from backend.app.models.transaction import Transaction

# Load scaler dan model
scaler = joblib.load("backend/Models/scaler_fraud.pkl")
model = joblib.load("backend/Models/model_fraud_rf.pkl")

# Threshold sementara
BEST_THRESHOLD = 0.65

# Debug
print(model)
print(scaler.feature_names_in_)

# Dummy merchant data
MERCHANT_DATA = {
    "Tokopedia": {
        "category": 1,
        "state": 1,
        "city_pop": 1000000,
        "merch_zipcode": 10110,
        "distance_km": 5
    },
    "Shopee": {
        "category": 2,
        "state": 1,
        "city_pop": 1200000,
        "merch_zipcode": 10220,
        "distance_km": 8
    },
    "Traveloka": {
        "category": 3,
        "state": 2,
        "city_pop": 800000,
        "merch_zipcode": 40115,
        "distance_km": 20
    },
    "Netflix": {
        "category": 4,
        "state": 3,
        "city_pop": 500000,
        "merch_zipcode": 60231,
        "distance_km": 15
    },
    "Steam": {
        "category": 5,
        "state": 4,
        "city_pop": 700000,
        "merch_zipcode": 80119,
        "distance_km": 30
    }
}


def detect_transaction(data):

    merchant_data = MERCHANT_DATA.get(data.merchant)

    if not merchant_data:
        return {
            "error": "Merchant not found"
        }

    now = datetime.now()

    sample = pd.DataFrame([{
        "category": merchant_data["category"],
        "amt": data.amount,
        "state": merchant_data["state"],
        "city_pop": merchant_data["city_pop"],
        "merch_zipcode": merchant_data["merch_zipcode"],
        "age": data.age,
        "distance_km": merchant_data["distance_km"],
        "gender_female": 1 if data.gender.lower() == "female" else 0,
        "trans_month": now.month,
        "trans_day": now.day,
        "trans_hour": now.hour,
        "trans_dayofweek": now.weekday(),
        "trans_dayofyear": now.timetuple().tm_yday
    }])

    # Samakan urutan feature dengan scaler
    sample = sample[list(scaler.feature_names_in_)]

    # Scaling
    scaled_sample = scaler.transform(sample)

    # Probability
    proba = model.predict_proba(scaled_sample)[0][1]



    prediction = (
        1
        if proba >= BEST_THRESHOLD
        else 0
    )


    #
    prediction_label = (
        "Low Risk"
        if prediction == 0
        else "High Risk"
)

    db = SessionLocal()

    # Simpan ke database
    new_transaction = Transaction(
        merchant=data.merchant,
        amount=data.amount,
        status=prediction_label,
        location="Indonesia",
        time=now.strftime("%H:%M"),
        date=now.strftime("%Y-%m-%d")
    )

    db.add(new_transaction)
    db.commit()
    db.refresh(new_transaction)
    db.close()

    return {
        "prediction": prediction_label,
        "probability": round(float(proba), 4),
        "transaction_id": new_transaction.id,
        "merchant": new_transaction.merchant,
        "amount": new_transaction.amount,
        "status": new_transaction.status
    }