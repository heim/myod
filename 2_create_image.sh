_githash=$(git rev-parse --short HEAD)
_timestamp=$(date +%Y%m%d_%H%M%S)
_project=<your-project-here>
_family_name=test-base-image
_image_name=$_family_name-$_githash
_instance_name=base-instance
_commit_message=$(git log --pretty=oneline --abbrev-commit | head -n1 | sed 's/[^0-9a-zA-Z -]//g' | sed 's/[ -]/_/g' | tr '[:upper:]' '[:lower:]')


_finished=1
while [[ $_finished > 0 ]]; do
  echo "Sleeping"
  sleep 1
  response=$(gcloud compute ssh --quiet $_instance_name --zone=europe-west1-d --project=$_project -- ls /tmp/finished)
  _finished=$?
  echo "Exit code: " $_finished
  echo "Response: " $response
done

echo "Compute instance is ready. Stopping it."
gcloud compute instances stop $_instance_name --zone=europe-west1-d --project=$_project

echo "Instance stopped. Creating Image."
gcloud compute images create $_image_name --project=$_project --family=$_family_name --source-disk=$_instance_name --source-disk-zone=europe-west1-d --labels=commit=$_githash,timestamp=$_timestamp,commit_message=$_commit_message --storage-location=eu
