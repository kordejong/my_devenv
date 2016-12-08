cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
source $cwd/util.sh
unset cwd


parse_commandline $*


if [ ! "$RIVM_AFWEGING" ]; then
    export RIVM_AFWEGING="$PROJECTS/`\ls $PROJECTS | \grep -i \"^rivm_afweging$\"`"
fi

export PATH="$RIVM_AFWEGING/docker_base/script:$RIVM_AFWEGING/environment/script:$PATH"
export PYTHONPATH="$RIVM_AFWEGING/docker_base/source:$PYTHONPATH"

export RIVM_AFWEGING_DATA=/mnt/data2/kor/project/rivm_afweging

workon rivm_afweging

cd $RIVM_AFWEGING
