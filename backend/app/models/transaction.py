class Transaction:
    def __init__(self, id, merchant, amount, status, location, time, date):
        self.id = id
        self.merchant = merchant
        self.amount = amount
        self.status = status
        self.location = location
        self.time = time
        self.date = date
        pass