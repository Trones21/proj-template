#!/bin/bash

# Default values
NAME=""

# Parse command-line options
while getopts "n:" opt; do
  case $opt in
    n)
      NAME=$OPTARG
      ;;
    \?)
      echo "Usage: $0 -n <name>"
      exit 1
      ;;
  esac
done

# Ensure the -n flag is provided
if [ -z "$NAME" ]; then
  echo "Error: The -n flag is required."
  echo "Usage: $0 -n <name>"
  exit 1
fi

# Shift positional arguments after options
shift $((OPTIND -1))

echo "Project name: $NAME"

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
sed "s|pk_projName|$NAME|g" "$TEMPLATE_SRC_DIR/build_and_deploy_local.sh" > "./build_and_deploy_local.sh"
sed "s|pk_projName|$NAME|g" "$TEMPLATE_SRC_DIR/deploy.sh" > "./deploy.sh"

# Env Vars 
sed "s|pk_projName|$NAME|g" "$TEMPLATE_SRC_DIR/env/local_backend.sh" > "~/env_setup/$NAME/local_backend.sh"
sed "s|pk_projName|$NAME|g" "$TEMPLATE_SRC_DIR/env/prod_backend.sh" > "~/env_setup/$NAME/prod_backend.sh"

# Docker Compose 
sed "s|pk_projName|$NAME|g" "$TEMPLATE_SRC_DIR/compose_local.yaml" > "./compose_local.yaml"
sed "s|pk_projName|$NAME|g" "$TEMPLATE_SRC_DIR/env/prod_backend.sh" > "~/env_setup/$NAME/prod_backend.sh"

cp "$TEMPLATE_SRC_DIR/no-modification-before-copy/" ./ 

echo "To Do: Set ssh login on deploy.sh"
echo "To Do: Navigate to ~/env_setup/$NAME and set environment variables for local and prod"


#### Project SubDirs #### 

### Add some top level Docs
echo "Adding top level docs"
cd ./top-level-docs
cp $TEMPLATE_SRC_DIR/USEFUL.md ./USEFUL.md
touch ./README.md
cd ../

### Create backend subdirs & files 
echo "Creating backend subdirs & files "
cp $TEMPLATE_SRC_DIR/backend/ ./backend

# Look for Pk Proj name in files and modify
find "./backend" -type f -exec sed -i "s|pk_projName|$NAME|g" {} \;

cd ../

### Create request_flows subdirs & files 
echo "Creating request_flows subdirs & files"
cp $TEMPLATE_SRC_DIR/request_flows/ ./request_flows
cd ./request_flows

# Look for Pk Proj name in files and modify
find "./request_flows" -type f -exec sed -i "s|pk_projName|$NAME|g" {} \;

cd ../

### Frontend will be created manually for now
echo "Frontend will be created manually for now. Use Quasar CLI"


echo "Done. Install dependencies and run."

mv $SCRIPT_DIR/$NAME ~/$NAME