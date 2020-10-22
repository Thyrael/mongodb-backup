#!/bin/bash
echo 'Begin of mongoDB_backup execution'
# Script to create or restore a mongoDB snapshot.
# Mode can be backup or restore
MODE=$1
DB_NAME=$2
# Convert args into UPPERCASE string
if [ -z $MODE || -z $DB_NAME]; then
  echo 'No args passed. First argument is mode, second is DB name. Exit script ...'
  exit 1
fi

MODE_AS_UPPER_STRING=${MODE^^}
DIRECTORY="mongodb_backup/"
echo 'Mode :' $MODE_AS_UPPER_STRING
##### FUNCTIONS #######

# Function to create a snapshot.
Snapshot() {
  # Init directory name with the current date
  DIR=`date +%m%d%y%T`
  FOLDER_DEST=$DIR
  # Create child directory with current date
  mkdir $FOLDER_DEST
  # Snapshot of mongo DB into the $FOLDER_DEST
  mongodump --db $DB_NAME --out $FOLDER_DEST
  echo 'Snapshot successfully created'
}

# Function to restore a snapshot.
Restore() {
  # Get last created directory
  LASTBACKUP="$(ls -td -- */ | head -n 1)"
  if [ ! -z "$LASTBACKUP" ]; then
    echo 'Lastest backup ' $LASTBACKUP
    # This backup will be restore
    mongorestore $LASTBACKUP
    echo 'Restore successfully applied'
  else
    echo 'No backup directory find'
    echo 'Restore can t be applied'
  fi
}

PurgeSnapshot() {
  COUNT_SNAPSHOT="$(ls -1 | wc -l)"
  if [ $COUNT_SNAPSHOT -gt 10 ]; then
    echo 'There are more than 10 snapshot. Purge in progress'
    OLDESTBACKUP="$(ls -td -- */ | tail -n 1)"
    echo 'Oldest backup ' $OLDESTBACKUP
    # DELETE the oldest snapshot
    rm -rf $OLDESTBACKUP
    echo 'One snapshot was removed.'
  fi
}

# Function to check if the parent directory exist.
CheckIfDirectoryExist() {
  if [ ! -d "$DIRECTORY" ]; then
    # The directory not exist
    mkdir $DIRECTORY
  fi
  cd $DIRECTORY
}

##### END FUNCTIONS #######

##### MAIN #####

CheckIfDirectoryExist
if [ $MODE_AS_UPPER_STRING == "BACKUP" ]; then
  Snapshot
  #echo 'Snapshot'
elif [ $MODE_AS_UPPER_STRING == "RESTORE" ]; then
  #echo 'Restore'
  Restore
else
  echo 'An error occured with passed args'
fi
PurgeSnapshot
echo 'End of mongoDB_backup execution'

##### END #####
