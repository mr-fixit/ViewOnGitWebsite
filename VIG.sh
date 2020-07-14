#!/bin/bash

AS_RESULT=$(osascript \
-e 'tell application "Xcode"' \
-e '   set n to name of front window' \
-e '   set o to offset of " — " in n' \
-e '   if o > 0 then set n to text 1 thru (o - 1) of n' \
-e '   set doc to source document named n' \
-e '   set r to selected character range of doc' \
-e '   set sel0 to first item of r - 1' \
-e '   set sel1 to 2nd item of r' \
-e '   set docPath to path of doc' \
-e 'end tell' \
-e 'return sel0 as string & " " & sel1 & " " & docPath' )

FIRST=`echo $AS_RESULT | cut -f 1 -d ' '`
LAST=`echo $AS_RESULT | cut -f 2 -d ' '`
offsetToFilePath=$((${#FIRST}+${#LAST}+2))
FILEPATH=${AS_RESULT:offsetToFilePath}

read LINE0 LINE1 <<< $(./convert_char_offsets_to_line_numbers.sh "$FILEPATH" $FIRST $LAST)

cd `dirname "$FILEPATH"`
DIR=`pwd`
relativePathToBaseDir=$(git rev-parse --show-cdup)
if [[ -s $relativePathToBaseDir ]]; then
    cd $relativePathToBaseDir
fi
BASE=`pwd`
SUBPATH="${FILEPATH:${#BASE}}"

REPO_URL=$(git remote show origin | grep 'Fetch URL:' | cut -c 14- | sed -e 's|git@||' -e 's|:|/|' -e 's|.git||')
BRANCH=$(git branch | cut -c 3-)

URL="https://$REPO_URL/blob/${BRANCH}${SUBPATH}#L${LINE0}-L${LINE1}"
URL=$(echo $URL | sed -e 's| |%20|g')
echo $URL
#open $URL
