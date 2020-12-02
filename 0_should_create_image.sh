_githash=$(git rev-parse --short HEAD)
_timestamp=$(date +%Y%m%d_%H%M%S)
_project=<your-project-here>
_family_name=test-base-image
_image_name=$_family_name-$_githash
_instance_name=base-instance
gcloud compute images describe $_image_name  --project=$_project > /dev/null 2>&1 
if [[ $? = 0 ]]; then
  echo "Image exists already, exiting"
  exit 1
fi
echo "Image not found. Proceeding"
