from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from google.oauth2 import service_account
import io

# Path to your service account key JSON file
SERVICE_ACCOUNT_FILE = "path/to/your-service-account.json"

SCOPES = ["https://www.googleapis.com/auth/drive"]

# Authenticate and build the service
creds = service_account.Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
service = build("drive", "v3", credentials=creds)

file_id = "YOUR_FILE_ID"
request = service.files().get_media(fileId=file_id)
file = io.BytesIO()

downloader = MediaIoBaseDownload(file, request)
done = False
while not done:
    status, done = downloader.next_chunk()
    print(f"Download {int(status.progress() * 100)}%.")

# Save the file locally
with open("downloaded_file.ext", "wb") as f:
    f.write(file.getvalue())

print("Download complete!")