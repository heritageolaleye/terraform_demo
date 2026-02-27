from google.cloud import storage
from google.auth import default

# Use credentials from gcloud CLI
credentials, project = default(scopes=["https://www.googleapis.com/auth/cloud-platform"])
client = storage.Client(credentials=credentials, project=project)

for bucket in client.list_buckets():
    print(bucket.name)

