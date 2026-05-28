import joblib
import pandas as pd
from datetime import datetime

from backend.app.database import SessionLocal
from backend.app.models.transaction import Transaction

# Load scaler dan model terbaru
scaler = joblib.load("backend/Models/scaler_fraud.pkl")
model = joblib.load("backend/Models/model_fraud_rf.pkl")

# Debug
print(model)
print(scaler.feature_names_in_)


def detect_latest_transaction():

    # Sample dummy transaction
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
        "trans_dayofweek": 4,
        "trans_dayofyear": 142
    }])

    # Samakan urutan feature dengan scaler
    sample = sample[list(scaler.feature_names_in_)]

    # Scaling data sebelum prediction
    scaled_sample = scaler.transform(sample)

    # Prediction asli dari model ML
    prediction = model.predict(scaled_sample)[0]

    # Label hasil prediction
    prediction_label = (
        "Low Risk"
        if prediction == 0
        else "High Risk"
    )

    now = datetime.now()

    db = SessionLocal()

    # Simpan transaksi ke database
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

    # Return response API
    return {
        "prediction": prediction_label,
        "transaction_id": new_transaction.id,
        "merchant": new_transaction.merchant,
        "amount": new_transaction.amount,
        "status": new_transaction.status
    }