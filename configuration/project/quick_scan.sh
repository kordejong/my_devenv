source $PERSONAL_FILES/Environment/project/devenv_basic.sh


QUICK_SCAN="$PROJECTS/`\ls $PROJECTS | \grep -i \"^quick_scan$\"`"
PATH=$QUICK_SCAN/environment/script:$PATH
PYTHONPATH=$QUICK_SCAN/source:$PYTHONPATH

alias psql_quick_scan="psql postgresql://$QUICK_SCAN_DATABASE_USER:$QUICK_SCAN_DATABASE_PASSWORD@$QUICK_SCAN_DATABASE_HOST/$QUICK_SCAN_DATABASE_NAME"

export PATH QUICK_SCAN

cd $QUICK_SCAN
pwd
