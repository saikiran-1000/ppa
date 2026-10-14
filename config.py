import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SFTP_HOST = os.getenv("SFTP_HOST")
    SFTP_PORT = int(os.getenv("SFTP_PORT", 22))
    SFTP_USERNAME = os.getenv("SFTP_USERNAME")
    SFTP_PASSWORD = os.getenv("SFTP_PASSWORD")

    SFTP_BASE_PATH = os.getenv("SFTP_BASE_PATH")
    LOCAL_BASE_PATH = os.getenv("LOCAL_BASE_PATH")
