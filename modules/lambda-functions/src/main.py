import boto3
import pandas as pd
import io
import os
import sys 


def lambda_handler(event, context):
    # Initialize S3 and DynamoDB clients
    s3 = boto3.client('s3')
    dynamodb = boto3.client('dynamodb')
    table =  os.environ['DYNAMODB_TABLE_NAME']  
    # Specify your S3 bucket and file details
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    file_key = event["Records"][0]["s3"]["object"]["key"]

    # Read CSV data from S3
    csv_obj = s3.get_object(Bucket=bucket_name, Key=file_key)
    data = csv_obj['Body'].read().decode('utf-8')
    friends= data.split("\n")

    # Store data in DynamoDB
    for friend in friends:
        friend_data = friend.split(",")
        try: 
            item = {
                "id"      :  {"N": friend_data[0]},
                "name"    :  {"S": friend_data[1]},
                "Subject" :  {"S": friend_data[2]}
            }
            dynamodb.put_item(TableName=table, Item=item)
        except Exception as e:
            print("End of file")  
    return "Data successfully processed and stored in DynamoDB"

