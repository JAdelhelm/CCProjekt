from logging import getLogger
from os import getenv, remove, path
import json

import boto3
from botocore.exceptions import ClientError
import yaml

LOG_LEVEL = getenv("LOG_LEVEL", "INFO")
LAMBDA_WRITE_DIRECTORY = getenv("LAMBDA_WRITE_DIRECTORY", "/tmp")
CONVERTED_BUCKET = getenv(
    "CONVERTED_BUCKET", "com.decentnodes.file-converter.converted")

logger = getLogger()
logger.setLevel(LOG_LEVEL)


def lambda_handler(event, context):
    """
    This is the main lambda handler function, which gets invoked by a lambda trigger.

    Args:
        event: Event as received by this lambda function.
        context: Context for this lambda function invocations

    Returns:
        None
    """

    logger.debug(event.items())

    for record in event["Records"]:
        logger.debug(record.items())
        body = json.loads(record["body"])
        logger.debug(body.items())
        for message in body["Records"]:
            logger.debug(message.items())
            consume_sqs_message(message["s3"])


def consume_sqs_message(sqs_message_record_s3: dict):

    # get s3 object and bucket
    s3_data = parse_message(sqs_message_record_s3)

    # load file from s3
    DOWNLOADED_FILE_PATH = path.join(
        LAMBDA_WRITE_DIRECTORY, s3_data["OBJECT_NAME"])
    s3 = boto3.client('s3')
    s3.download_file(s3_data["BUCKET_NAME"],
                     s3_data["OBJECT_NAME"], DOWNLOADED_FILE_PATH)

    # get json output file name
    json_file_name = convert_file_name(s3_data["OBJECT_NAME"])

    # parse into json
    CONVERTED_FILE_PATH = path.join(LAMBDA_WRITE_DIRECTORY, json_file_name)
    yaml_json_converter(DOWNLOADED_FILE_PATH, CONVERTED_FILE_PATH)

    # upload to converted bucket
    try:
        response = s3.upload_file(
            CONVERTED_FILE_PATH, CONVERTED_BUCKET, json_file_name)
    except ClientError as e:
        logger.error(e)
        return False

    # delete local files
    remove(CONVERTED_FILE_PATH)
    remove(DOWNLOADED_FILE_PATH)

    logger.info(
        "Conversion of file %s/%s successful", s3_data["BUCKET_NAME"], s3_data["OBJECT_NAME"])


def parse_message(sqs_message_record_s3: dict):

    return {
        "BUCKET_NAME": sqs_message_record_s3["bucket"]["name"],
        "OBJECT_NAME": sqs_message_record_s3["object"]["key"]
    }


def convert_file_name(s3_object_name: str):
    dot_index = s3_object_name.rfind(".")
    return f"{s3_object_name[:dot_index]}.json"


def yaml_json_converter(yaml_input: str, json_output: str):
    """This function converts a yaml file into a json file.

    Args:
        yaml_input (str): absolute or relative path of the yaml file which should be converted 
        json_output (str): absolute or relative path of the json file for the converted result
    """

    with open(yaml_input, 'r') as yaml_file:
        input_loaded = yaml.safe_load(yaml_file)

    with open(json_output, 'w') as json_file:
        json.dump(input_loaded, json_file)


if __name__ == "__main__":

    lambda_input = {
        "Records": [
            {
                "messageId": "19dd0b57-b21e-4ac1-bd88-01bbb068cb78",
                "receiptHandle": "MessageReceiptHandle",
                "body": "{\"Records\":[{\"eventVersion\":\"2.1\",\"eventSource\":\"aws:s3\",\"awsRegion\":\"eu-central-1\",\"eventTime\":\"2022-06-08T12:18:23.457Z\",\"eventName\":\"ObjectCreated:Put\",\"userIdentity\":{\"principalId\":\"AWS:AIDAXMV3DAZJ3RWLCLF7U\"},\"requestParameters\":{\"sourceIPAddress\":\"79.252.87.99\"},\"responseElements\":{\"x-amz-request-id\":\"H45F9BV4BHF42XY3\",\"x-amz-id-2\":\"AYGcNy4jFhSzUQH03dP/wAlw8mR05pveydAVWhZhvpiMhCOIFZkysuwrHKr1pTzZFi++hgfHts79C6tbGG3FDjzLZubT1PF7\"},\"s3\":{\"s3SchemaVersion\":\"1.0\",\"configurationId\":\"tf-s3-topic-20220608115136729600000001\",\"bucket\":{\"name\":\"com.decentnodes.file-converter.ingestion\",\"ownerIdentity\":{\"principalId\":\"A206983IIR6N1U\"},\"arn\":\"arn:aws:s3:::com.decentnodes.file-converter.ingestion\"},\"object\":{\"key\":\"docker-compose.yml\",\"size\":1798,\"eTag\":\"00c4f511b9e0ea3fc6d8e07f4cc66855\",\"sequencer\":\"0062A0938F6BC61155\"}}}]}",
                        "attributes": {
                            "ApproximateReceiveCount": "1",
                            "SentTimestamp": "1523232000000",
                            "SenderId": "123456789012",
                            "ApproximateFirstReceiveTimestamp": "1523232000001"
                        },
                "messageAttributes": {},
                "md5OfBody": "7b270e59b47ff90a553787216d55d91d",
                "eventSource": "aws:sqs",
                "eventSourceARN": "arn:aws:sqs:eu-central-1:123456789012:MyQueue",
                "awsRegion": "eu-central-1"
            }
        ]
    }
    
    lambda_handler(lambda_input, None)
