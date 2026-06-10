from backend.app.services.history_service import (
    get_history, get_high_risk_transactions, get_latest_transaction
)

def get_home_summary():
    history = get_history()
    high_risk = get_high_risk_transactions()
    latest = get_latest_transaction()

    summary = {
        "total_transactions" : len(history),
        "high_risk_count" : len(high_risk),
        "latest_transaction": latest
    }

    return summary