import joblib
import pandas as pd
from datetime import datetime

from backend.app.database import SessionLocal
from backend.app.models.transaction import Transaction

# Load model ML
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

    # Prediction dari model ML
    # prediction = model.predict(sample)[0]

    # sementara dummy dulu
    prediction = 1

    prediction_label = (
        "Low Risk"
        if prediction == 0
        else "High Risk"
    )

    now = datetime.now()

    db = SessionLocal()

    new_transaction = Transaction(
        merchant="Tokopedia",
        amount=500000,
        status=prediction_label,
        location="Jakarta",
        time=now.strftime("%H:%M"),
        date=now.strftime("%Y-%m-%d")
    )

    db.add(new_transaction)

    db.commit()

    db.refresh(new_transaction)

    db.close()

    return {
        "prediction": prediction_label,
        "transaction_id": new_transaction.id,
        "merchant": new_transaction.merchant,
        "amount": new_transaction.amount,
        "status": new_transaction.status
    }