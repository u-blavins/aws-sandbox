import json
from simple_api.handler import hello


class TestHandler:
    """Test Suite for testing Python Lambda Handler"""

    def test_hello_returns_default_values_with_empty_params(self):
        expected_status_code = 200
        expected_response_message = "Go Serverless v3.0! Your function executed successfully!"
        sut = hello({}, {})
        assert json.loads(sut.get('body'))['message'] == expected_response_message
        assert sut['statusCode'] == expected_status_code
