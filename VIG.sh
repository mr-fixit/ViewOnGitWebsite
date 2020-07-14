#!/bin/bash

source ./convert_char_offsets_to_line_numbers

set $(osascript \
-e 'tell application "Xcode"' \
-e '   set n to name of front window' \
-e '   set o to offset of " — " in n' \
-e '   if o > 0 then set n to text 1 thru (o - 1) of n' \
-e '   set doc to source document named n' \
-e '   set r to selected character range of doc' \
-e '   set out1 to path of doc' \
-e '   set out2 to first item of r - 1' \
-e '   set out3 to 2nd item of r' \
-e 'end tell' \
-e 'return out1 & " " & out2 & " " & out3' )

FILEPATH="$1"
FIRST=$2
LAST=$3

read LINE0 LINE1 <<< $(convert_char_offsets_to_line_numbers.sh $FILEPATH $FIRST $LAST)

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

