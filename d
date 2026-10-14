import os
import stat
import paramiko
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

HOST = os.getenv("SFTP_HOST")
PORT = int(os.getenv("SFTP_PORT"))
USERNAME = os.getenv("SFTP_USERNAME")
PASSWORD = os.getenv("SFTP_PASSWORD")

REMOTE_BASE_PATH = "/PPA_DATA"
LOCAL_BASE_PATH = "./PPA_DATA"

FOLDERS = [
    "Vendor",
    "PO Header",
    "PO Line",
    "Invoice Header",
    "Invoice Line",
    "GRN Header",
    "GRN Line",
    "Contract"
]


def connect_sftp():
    print("Connecting to SFTP...")
    transport = paramiko.Transport((HOST, PORT))
    transport.connect(username=USERNAME, password=PASSWORD)
    sftp = paramiko.SFTPClient.from_transport(transport)
    print("Connected successfully.")
    return transport, sftp


def download_folder(sftp, remote_path, local_path):
    os.makedirs(local_path, exist_ok=True)

    try:
        for item in sftp.listdir_attr(remote_path):
            remote_item_path = f"{remote_path}/{item.filename}"
            local_item_path = os.path.join(local_path, item.filename)

            if stat.S_ISDIR(item.st_mode):
                download_folder(sftp, remote_item_path, local_item_path)
            else:
                print(f"Downloading: {remote_item_path}")
                sftp.get(remote_item_path, local_item_path)

    except FileNotFoundError:
        print(f"Folder not found on server: {remote_path}")
    except Exception as e:
        print(f"Error processing {remote_path}: {e}")


def main():
    transport = None
    sftp = None

    try:
        transport, sftp = connect_sftp()

        print("Remote folders available:")
        print(sftp.listdir(REMOTE_BASE_PATH))

        for folder in FOLDERS:
            remote_path = f"{REMOTE_BASE_PATH}/{folder}"
            local_path = os.path.join(LOCAL_BASE_PATH, folder)

            print(f"\nProcessing folder: {remote_path}")
            download_folder(sftp, remote_path, local_path)

        print("\nDownload completed successfully.")

    except Exception as e:
        print(f"Connection failed: {e}")

    finally:
        if sftp:
            sftp.close()
        if transport:
            transport.close()
        print("SFTP connection closed.")


if __name__ == "__main__":
    main()
