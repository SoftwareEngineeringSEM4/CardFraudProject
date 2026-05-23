import json

def get_history():
    with open("backend/app/data/dummy_history.json") as file:
        data = json.load(file)
    return data

def get_latest_transaction():
    data = get_history()
    return data[0]

def get_high_risk_transactions():
    data = get_history()

    high_risk = []

    for transaction in data:
        if transaction["status"] == "High Risk":
            high_risk.append(transaction)

    return high_risk

def get_transaction_by_id (transaction_id):
    data = get_history()

    for transaction in data:
        if transaction["id"] == transaction_id:
            return transaction
    
    return None