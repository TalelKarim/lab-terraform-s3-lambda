import boto3
import pandas as pd
import io
import os

def lambda_handler(event, context):
    # Initialize S3 and DynamoDB clients
    s3 = boto3.client('s3')
    dynamodb = boto3.client('dynamodb')

    # Specify your S3 bucket and file details
    bucket_name = os.environ['BUCKET_NAME']
    file_key = os.environ['FILE_KEY']

    # Read CSV data from S3
    csv_obj = s3.get_object(Bucket=bucket_name, Key=file_key)
    csv_string = csv_obj['Body'].read().decode('utf-8')
    df = pd.read_csv(io.StringIO(csv_string))

    # Process data (if needed)

    # Store data in DynamoDB
    table_name =  os.environ['DYNAMODB_TABLE_NAME']
    for _, row in df.iterrows():
        item = {
            'GameNumber': {'N': str(row['GameNumber'])},
            'GameLength': {'N': str(row['GameLength'])}
            # Add other attributes as needed
        }
        dynamodb.put_item(TableName=table_name, Item=item)

    return "Data successfully processed and stored in DynamoDB"
