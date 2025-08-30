import json
import hashlib

def lambda_handler(event, context):
    """
    Lambda function that returns the input string hashed with SHA256
    event = {"text": "hello"}
    """
    text = None
    if isinstance(event, dict):
        text = event.get("text")

    if not text:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "No text provided"})
        }

    # Hash using SHA256
    hashed = hashlib.sha256(text.encode("utf-8")).hexdigest()

    return {
        "statusCode": 200,
        "body": json.dumps({"hash": hashed})
    }