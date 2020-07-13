#!/bin/bash

function convert_char_offsets_to_line_numbers() 
{
  FILEPATH=$1; CHAR0=$2; CHAR1=$3

  NCHARS=0; NLINES=0
  unset L1; unset L2
  echo CHAR0=$CHAR0 CHAR1=$CHAR1
  cat $FILEPATH | while read L; do
    ((NLINES += 1 ))
    thisLength=$(( ${#L} + 1 ))
    echo L:$NLINES C:$NCHARS lenL=$thisLength
    if [[ -z $L0 ]] && (( CHAR0 <= NCHARS + thisLength )); then
      L0=$NLINES
    fi
    if [[ -z $L1 ]] && (( CHAR1 <= NCHARS + thisLength )); then 
      L1=$NLINES
      if (( CHAR1 == NCHARS + thisLength )); then (( L1-- )); fi
      echo $L0 $L1  # this  is the output of the function
      break;
    fi; 
    ((NCHARS += thisLength ))
  done
}

set $(osascript \
-e 'tell application "Xcode"' \
-e '   set doc to source document 0' \
-e '   set r to selected character range of doc' \
-e '   set out1 to path of doc' \
-e '   set out2 to first item of r - 1' \
-e '   set out3 to 2nd item of r' \
-e 'end tell' \
-e 'return out1 & " " & out2 & " " & out3' )

FILEPATH="$1"
FIRST=$2
LAST=$3

# convert_char_offsets_to_line_numbers $FILEPATH $FIRST $LAST
# exit
# 
read LINE0 LINE1 <<< $(convert_char_offsets_to_line_numbers $FILEPATH $FIRST $LAST)

cd `dirname "$FILEPATH"`
DIR=`pwd`
cd $(git rev-parse --show-cdup)
BASE=`pwd`
SUBPATH="${FILEPATH:${#BASE}}"

REPO_URL=$(git remote show origin | grep 'Fetch URL:' | cut -c 14- | sed -e 's|git@||' -e 's|:|/|' -e 's|.git||')
BRANCH=$(git branch | cut -c 3-)

URL="https://$REPO_URL/blob/${BRANCH}${SUBPATH}#L${LINE0}-L${LINE1}"
echo $URL
open $URL

