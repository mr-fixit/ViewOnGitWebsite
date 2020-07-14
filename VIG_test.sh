#!/bin/bash

function test() {
  RESULT=$(./convert_char_offsets_to_line_numbers.sh "test file.txt" $1 $2)
  if [[ "$RESULT" != "$3" ]]; then
      echo "FAIL: $1 $2 -> $RESULT, expected $3"
  fi
}

test 0 1 "1 1"
test 0 2 "1 2"
