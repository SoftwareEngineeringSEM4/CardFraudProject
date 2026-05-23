def success_response (message, data):
    return{
        "success": True,
        "message": message,
        "data": data
    }

def error_response (message):
    return {
        "success": False,
        "message": message,
        "data": None
    }