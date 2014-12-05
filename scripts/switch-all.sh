#!/bin/bash
redColor=`tput setaf 1`
greenColor=`tput setaf 2`
resetColor=`tput sgr0`

# Get path to this file
TMP=$(readlink --canonicalize --no-newline $BASH_SOURCE)
# Get the current working directory (without final slash)
TMP=$(dirname $TMP)
# cd ..
TMP=$TMP/..
# Get path. At this point we should be at CODYCO_SUPERBUILD_ROOT
CODYCO_SUPERBUILD_ROOT=$(readlink --canonicalize --no-newline $TMP)

# Or ...
# CODYCO_SUPERBUILD_ROOT=$(readlink --canonicalize --no-newline $(dirname $(readlink --canonicalize --no-newline $BASH_SOURCE))/..)

# Execute script
#  . $CODYCO_SUPERBUILD_ROOT/walkman-env.bash

if [ $# -ne 1 ]; then
    echo "Error: switch-all.sh accepts exactly one input parameter, the branch name. For example: ./switch_all.sh new_wbi_ID"
    exit 1
fi

echo
echo "switch-all will switch branches for all local projects to branch $1"
echo
echo

cd ${CODYCO_SUPERBUILD_ROOT}
git fetch --all              # Get all branches
git checkout -b $1 origin/$1 # Create local branch new_wbi_ID branch
git checkout $1              # Checkout new_wbi_ID

# True if $CODYCO_SUPERBUILD_ROOT/xxx exists and is a directory
components=(main libraries)
for COMPONENT in ${components[*]}
do
    echo ""
    tput bold
    echo "${redColor}**Switching branch for projects in: ${COMPONENT}** ${resetColor}"
    if [ -d ${CODYCO_SUPERBUILD_ROOT}/${COMPONENT} ]; then
        for PROJ_NAME in `ls ${CODYCO_SUPERBUILD_ROOT}/${COMPONENT}`;
        do
            if [ -d ${CODYCO_SUPERBUILD_ROOT}/${COMPONENT}/${PROJ_NAME}/.git ]; then
                cd ${CODYCO_SUPERBUILD_ROOT}/${COMPONENT}/$PROJ_NAME
                echo ""
                tput bold
                echo "${greenColor}In project: $PROJ_NAME ${resetColor}"
                echo "Checking out branch $1 of $PROJ_NAME ... "
                git fetch --all
                git checkout -b $1 origin/$1
                git checkout $1
                echo "done"
            else
                echo "Error: folder $PROJ_NAME is not a git repository"
            fi
        done
    else
        echo "Error: could not find folder ${CODYCO_SUPERBUILD_ROOT}/components[0]"
    fi
done

cd ${CODYCO_SUPERBUILD_ROOT}
cd build
make update-all
