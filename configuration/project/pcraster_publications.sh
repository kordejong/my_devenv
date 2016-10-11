export PCRASTER_PUBLICATIONS="$PROJECTS/`\ls $PROJECTS | \grep -i \"^pcraster_publications$\"`"

cd $PCRASTER_PUBLICATIONS

export TEXINPUTS="$PCRASTER_PUBLICATIONS/devbase/latex:"

unalias pcraster_publications 2>/dev/null

workon pcraster_publications

pwd
