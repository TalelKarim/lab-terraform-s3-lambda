import boto3
import pandas as pd
import io
import os
import sys
import json 

# Initialize S3 and DynamoDB clients
s3 = boto3.client('s3')
dynamodb = boto3.client('dynamodb')
def lambda_handler(event, context):
    table =  os.environ['DYNAMODB_TABLE_NAME']  
    # Attempt to extract bucket_name and file_key from the event
    # Extract bucket_name and file_key based on the trigger source
    if "Records" in event:  # S3 event
        bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
        file_key = event["Records"][0]["s3"]["object"]["key"]
    elif "queryStringParameters" in event:  # API Gateway GET request
        bucket_name = event["queryStringParameters"].get("bucket_name")
        file_key = event["queryStringParameters"].get("file_key")

    # Read CSV data from S3
    csv_obj = s3.get_object(Bucket=bucket_name, Key=file_key)
    data = csv_obj['Body'].read().decode('utf-8')
    friends = data.split("\n")

    # Store data in DynamoDB
    for friend in friends:
        # Check if friend data is not empty to avoid processing empty lines
        if friend:
            friend_data = friend.split(",")
            try: 
                item = {
                    "id"      :  {"N": friend_data[0]},
                    "name"    :  {"S": friend_data[1]},
                    "Subject" :  {"S": friend_data[2]}
                }
                dynamodb.put_item(TableName=table, Item=item)
            except Exception as e:
                print("Error processing item: ", e)  
    
    # Return a statusCode of 200 and a success message in the body
    return {
        'statusCode': 200,
        'body': json.dumps('Data successfully processed and stored in DynamoDB')
    }
