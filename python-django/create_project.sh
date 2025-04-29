#!/bin/bash

bold_blue() {
  echo -e "\e[1;34m$1\e[0m"
}


# Default values
NAME=""
DESTINATION="~/Documents/git_repos"  # Default destination

# Parse command-line options
while getopts "n:d:" opt; do
  case $opt in
    n)
      NAME=$OPTARG
      ;;
    d)
      DESTINATION=$OPTARG
      ;;
    \?)
      echo "Usage: $0 -n <name> [-d <destination>]"
      exit 1
      ;;
  esac
done


# Shift positional arguments after options
shift $((OPTIND -1))

# Validate project name
if [ -z "$NAME" ]; then
  echo "Error: The -n flag is required."
  echo "Usage: $0 -n <name> [-d <destination (excluding project name folder)>]"
  exit 1
fi

if [[ ! "$NAME" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
  echo "❌ Invalid project name '$NAME'."
  echo "Project name must start with a letter or underscore and contain only letters, numbers, and underscores."
  exit 1
fi

RESERVED_NAMES=("django" "test" "tests" "async" "await" "types" "sys" "os" "json" "re" "datetime" "email" "html" "math" "string" "random" "uuid" "site" "project")

for reserved in "${RESERVED_NAMES[@]}"; do
  if [[ "$NAME" == "$reserved" ]]; then
    echo "❌ Invalid project name '$NAME'."
    echo "It conflicts with a reserved Python or Django module."
    exit 1
  fi
done

## === Start Creating the Project === ##

echo "Project name: $NAME"
echo "Destination: $DESTINATION"
echo 

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_SRC_DIR="${SCRIPT_DIR}/src" 


mkdir $NAME

cd ./$NAME

## Env files are kept outside of the project
mkdir -p ~/env_setup/$NAME

### Root Folder ### 
mkdir backend frontend _images request_flows _top_level_docs

###  Send templates with pre-filled project name #### 
## pk_host is also here, but since it's unlikely that i already have the domain chosen, i am not concerned with that, juts CTRL + F 

# Deployment 
sed "s|pk_projName|$NAME|g" $TEMPLATE_SRC_DIR/build_and_deploy_local.sh > ./build_and_deploy_local.sh
sed "s|pk_projName|$NAME|g" $TEMPLATE_SRC_DIR/deploy.sh > ./deploy.sh

# Env Vars 
sed "s|pk_projName|$NAME|g" $TEMPLATE_SRC_DIR/env/local_backend.sh > ~/env_setup/$NAME/local_backend.sh
sed "s|pk_projName|$NAME|g" $TEMPLATE_SRC_DIR/env/prod_backend.sh > ~/env_setup/$NAME/prod_backend.sh

# Docker Compose 
sed "s|pk_projName|$NAME|g" $TEMPLATE_SRC_DIR/compose_local.yaml > ./compose_local.yaml
sed "s|pk_projName|$NAME|g" $TEMPLATE_SRC_DIR/compose_deploy.yaml > ./compose_deploy.yaml

cp -r $TEMPLATE_SRC_DIR/no-modification-before-copy/ ./ 
mv ./no-modification-before-copy/frontend-Dockerfile ../frontend/Dockerfile

bold_blue "To Do: Set ssh login on deploy.sh"
bold_blue "To Do: Navigate to ~/env_setup/$NAME and set environment variables for local and prod"


#### Project SubDirs #### 

# ### Add some top level Docs
echo "Adding top level docs"
cd ./_top_level_docs
cp $TEMPLATE_SRC_DIR/USEFUL.md ./USEFUL.md
touch ./README.md
cd ../

### Create backend subdirs & files 
echo "Creating backend subdirs & files "
cp -r "$TEMPLATE_SRC_DIR/backend" "$SCRIPT_DIR/$NAME/"
# Look for Pk Proj name in files and modify
find "$SCRIPT_DIR/$NAME/backend" -type f -exec sed -i "s|pk_projName|$NAME|g" {} \;
mv "$SCRIPT_DIR/$NAME/backend/pk_projName" "$SCRIPT_DIR/$NAME/backend/$NAME"

### Create request_flows subdirs & files 
echo ""

echo "Creating request_flows subdirs & files"
cd ./request_flows
git clone https://github.com/Trones21/noCRUD.git
mv ./noCRUD/python/* .
rm -rf ./noCRUD
cd ../


### Frontend will be created manually for now
cp -r "$TEMPLATE_SRC_DIR/frontend" "$SCRIPT_DIR/$NAME/"
printf "\nFrontend will be created manually for now. Only nginx and Dockerfile transferred "
echo
printf "\nDone. Install dependencies and run.\n"

# Expand tilde manually because `mv` doesn't automatically expand ~
DESTINATION_EXPANDED=$(eval echo "$DESTINATION")

mkdir -p "$DESTINATION_EXPANDED"  # Ensure destination exists
mv "$SCRIPT_DIR/$NAME" "$DESTINATION_EXPANDED/$NAME"

CMD="cd \"$DESTINATION_EXPANDED/$NAME\""
echo -e "\nDone. Run this to enter the folder:"
echo "$CMD"

if command -v xclip &> /dev/null; then
  echo "$CMD" | xclip -selection clipboard
  echo "(Copied to clipboard via xclip ✅)"
elif command -v wl-copy &> /dev/null; then
  echo "$CMD" | wl-copy
  echo "(Copied to clipboard via wl-copy ✅)"
else
  echo "(Clipboard tool not found — copy manually)"
fi