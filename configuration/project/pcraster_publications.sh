export PCRASTER_PUBLICATIONS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^pcraster_publications$\"`"

cd $PCRASTER_PUBLICATIONS

unalias pcraster_publications 2>/dev/null

pwd
