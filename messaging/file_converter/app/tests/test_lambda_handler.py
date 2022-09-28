import json
import os
import shutil

from app.lambda_handler import yaml_json_converter, convert_file_name


TEST_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_YAML = os.path.join(TEST_DIR, "fixtures/docker-compose.yml")
OUTPUT_DIR = os.path.join(TEST_DIR, "outputs")
OUTPUT_JSON = os.path.join(TEST_DIR, "outputs/docker-compose.json")


def test_convert_file_name():
    
    json_file_name = convert_file_name("do.cker-co.mpose.yml")
    assert json_file_name == "do.cker-co.mpose.json"

def test_yaml_json_conversion():

    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    yaml_json_converter(INPUT_YAML, OUTPUT_JSON)
    
    with open(OUTPUT_JSON) as f:
        loaded_json = json.load(f)

    shutil.rmtree(OUTPUT_DIR, ignore_errors=True)

    assert loaded_json["version"] == "2.4"