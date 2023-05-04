#!/bin/sh -uex
echo "Knowl script running to auto-merge docs..."

BIN_PATH="$HOME"
WORKING_DIR="$BIN_PATH/knowl_temp"
KNOWL_AUTOMERGE_NAME="automerge.zip"
AUTOMERGE_DOWNLOAD_URL='https://releases.knowl.io/automerge.zip'


get_abs_filename() {
  # $1 : relative filename
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [ -z "$1" ]
then
    echo 'no repo path provided'
    exit 0
fi

GIT_REPO="$REPO_NAME"
GIT_OWNER="$OWNER_NAME"
GIT_BRANCH="$BRANCH_NAME"
REPO_PATH=${1}

verify_wget() {
    BIN_WGET=$(which wget) || {
        echo "You need to install 'wget' to use this hook."
    }
}

verify_unzip() {
    BIN_UNZIP=$(which unzip) || {
        echo "You need to install 'unzip' to use this hook."
    }
}

verify_tmp() {
    touch $BIN_PATH || {
        error_out "Could not write to $BIN_PATH"
    }
}

create_working_dir(){
    working_dir=$1
    if [ ! -d "$working_dir" ]
        then
            mkdir -p -- "$working_dir"
    fi
}


download_from_link() {
    echo "download begins ..."
    echo "$1"
    download_url="$1"
    directory_name="$2"
    file_path="$3"
    
    create_working_dir $directory_name
    $BIN_WGET --no-check-certificate $download_url -O $file_path
    chmod +x $file_path
    echo "download ends ..."

}

check_knowl_utils_version() {
    echo "downloading the latest knowl utils version"
    file_url=$AUTOMERGE_DOWNLOAD_URL
    #get folder names in the working directory
    download_from_link $file_url $WORKING_DIR/ $WORKING_DIR/$KNOWL_AUTOMERGE_NAME

    export PATH=$PATH:$WORKING_DIR

}

cleanup() {
    echo "Cleaning up..."
}

#machine_type=""
verify_wget
verify_unzip
verify_tmp
check_knowl_utils_version
cd $WORKING_DIR
$BIN_UNZIP $WORKING_DIR/$KNOWL_AUTOMERGE_NAME -d $WORKING_DIR
cd automerge/knowl-utils
npm install -g typescript@4.8.4 ts-node@10.9.1
npm install node-fetch@2.6.2 @types/node-fetch@2.6.2 ws dotenv cmd-ts http-status-codes
ts-node src/index.ts automerge $GIT_REPO $GIT_OWNER $GIT_BRANCH
