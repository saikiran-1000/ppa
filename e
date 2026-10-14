import boto3
from sftp.sftp_client import SFTPClient
import os
from dotenv import load_dotenv
load_dotenv()
 
 
# Create an S3 client
s3 = boto3.client('s3')
 
 
SFTP_HOST = os.getenv('SFTP_HOST')
SFTP_PORT = int(os.getenv('SFTP_PORT', 22))
SFTP_USER = os.getenv('SFTP_USER')
SFTP_PASS = os.getenv('SFTP_PASS')
SFTP_KEY = os.getenv('SFTP_KEY') or None
  # You can also move this to .env if needed
LOCAL_FILE = os.getenv('local_file_path')
 
with SFTPClient(SFTP_HOST, SFTP_PORT, SFTP_USER, SFTP_PASS, SFTP_KEY).get_connection() as sftp:
    remote_dir = '/PPA_DATA/PPA_test' # Update to your directory
    files = sftp.listdir(remote_dir)
    print(f"Files found: {files}")    
 
    for filename in files:
        remote_file = f"{remote_dir}/{filename}"  # Join with forward slash
        local_file = filename  # Save with same name locally
 
        print(f"Downloading {remote_file} from SFTP...")
        sftp.download(remote_file, local_file)
        print(f"Downloaded to {local_file}")              
