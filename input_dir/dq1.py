import boto3
import csv
import os

# Initialize S3 client
s3 = boto3.client('s3')

# Bucket names
input_bucket = 'ddsl-extension-bucket'
output_bucket = 'ddsl-dq1'  

# Function to count rows in a file
def count_rows(file_path):
    with open(file_path, 'r') as file:
        reader = csv.reader(file, delimiter='|')
        row_count = sum(1 for row in reader)
    return row_count

# Function to move file to another folder in S3
def move_file(source_key, destination_folder):
    s3.copy_object(
        Bucket=output_bucket,
        CopySource={'Bucket': input_bucket, 'Key': source_key},
        Key=os.path.join(destination_folder, os.path.basename(source_key))
    )
    s3.delete_object(Bucket=input_bucket, Key=source_key)

# List files in input bucket
response = s3.list_objects_v2(Bucket=input_bucket, Prefix='updatedsegted_files/')

# Iterate through each file
for obj in response.get('Contents', []):
    file_key = obj['Key']
    file_name = os.path.basename(file_key)

    # Download file from S3
    local_file_path = '/tmp/' + file_name
    s3.download_file(input_bucket, file_key, local_file_path)

    # Parse file content
    with open(local_file_path, 'r') as file:
        rows = file.readlines()
        last_row = rows[-1]
        reference_row_count = int(last_row.strip().split('|')[-1])

    # Count actual rows
    actual_row_count = count_rows(local_file_path)

    # Compare row counts
    if actual_row_count != reference_row_count:
        print(f"Row count mismatch for file {file_name}: Actual: {actual_row_count}, Reference: {reference_row_count}")
        move_file(file_key, 'bad')  # Move to 'bad' folder if counts don't match
    else:
        print(f"Row count match for file {file_name}: {actual_row_count}")
        move_file(file_key, 'good')  # Move to 'good' folder if counts match
