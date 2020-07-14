FILEPATH=$1; CHAR0=$2; CHAR1=$3

NCHARS=0; NLINES=0
unset L1; unset L2
# echo CHAR0=$CHAR0 CHAR1=$CHAR1
cat "$FILEPATH" | while read L; do
  ((NLINES += 1 ))
  thisLength=$(( ${#L} + 1 ))
  # echo L:$NLINES C:$NCHARS lenL=$thisLength
  if [[ -z $L0 ]] && (( CHAR0 < NCHARS + thisLength )); then
    L0=$NLINES
  fi
  if [[ -z $L1 ]] && (( CHAR1 < NCHARS + thisLength )); then 
    L1=$NLINES
    echo $L0 $L1  # this  is the output of the function
    break
  fi; 
  ((NCHARS += thisLength ))
done
