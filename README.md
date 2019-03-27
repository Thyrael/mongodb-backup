# mongodb-backup


A simple bash to do :
*  A snapshot of mongo database
*  A restore of mongo database snapshot
*  Purge snapshot folder when there are more than 10 snapshot.


This script don't work in **case of non local mongo database**. Replace the **mongodump** or **mongorestore** options if you want to use it
with distant mongo database.
  
This script accept two arguments.
First is the mode. It can be "backup" or "restore".
Then, second arg is the database name.

In **case of "backup"** mode, the script create a snapshot into a local folder.
In **case of "restore"** mode, the script check the snapshot folder, and apply the lastest.

At the end, the script call a purge function. If there are more than 10 snapshot into the snapshot folder, the oldest snapshot will be removed.



    
