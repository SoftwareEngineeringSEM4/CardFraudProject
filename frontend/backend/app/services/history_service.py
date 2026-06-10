from sqlalchemy.orm import Session
from backend.app.database import SessionLocal
from backend.app.models.transaction import Transaction

def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()

def get_history():

    db = SessionLocal()

    transactions = db.query(Transaction).all()

    result = []

    for transaction in transactions:

        result.append({
            "id": transaction.id,
            "merchant": transaction.merchant,
            "amount": transaction.amount,
            "status": transaction.status,
            "location": transaction.location,
            "time": transaction.time,
            "date": transaction.date
        })

    db.close()

    return result

def get_latest_transaction():

    data = get_history()

    if len(data) > 0:
        return data[-1]

    return None

def get_high_risk_transactions():

    data = get_history()

    high_risk = []

    for transaction in data:

        if transaction["status"] == "High Risk":

            high_risk.append(transaction)

    return high_risk

def get_transaction_by_id(transaction_id):

    data = get_history()

    for transaction in data:

        if transaction["id"] == transaction_id:

            return transaction

    return None