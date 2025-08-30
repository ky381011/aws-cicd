import json
import hashlib
from hash import lambda_handler

def test_lambda_with_text():
    text = "hello"
    event = {"text": text}
    result = lambda_handler(event, None)

    assert result["statusCode"] == 200
    body = json.loads(result["body"])

    expected_hash = hashlib.sha256(text.encode("utf-8")).hexdigest()
    assert body["hash"] == expected_hash

def test_lambda_without_text():
    event = {}
    result = lambda_handler(event, None)

    assert result["statusCode"] == 400
    body = json.loads(result["body"])
    assert body["error"] == "No text provided"

def test_lambda_invalid_event():
    event = "not a dict"
    result = lambda_handler(event, None)

    assert result["statusCode"] == 400
    body = json.loads(result["body"])
    assert body["error"] == "No text provided"
