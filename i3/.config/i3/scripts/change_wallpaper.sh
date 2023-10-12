#!/bin/bash
# Modify this
WALLS="$HOME/pictures/wallpapers"

# Non-moddable part
set -e
IFS=$'\n'
if [ -e "${HOME}/.cycle" ]; then
	. "${HOME}/.cycle"
	if [[ $1 = "-r" ]]; then
		PATHS=( $(ls "$WALLS" | grep -E '\.png|\.jpg' | sort -r) )
	else
		PATHS=( $(ls "$WALLS" | grep -E '\.png|\.jpg' | sort) )
	fi
	for i in "${!PATHS[@]}"; do
		if [[ "${PATHS[$i]}" = "${CURRENT_WAL}" ]]; then
			INDEX=$i
			break
		fi
	done
	if [[ $1 = "-c" ]]; then
		CHANGETO="${PATHS[$i]}"
	else
		NEXT=$(( $i + 1 ))
		if (( $NEXT >= ${#PATHS[@]} )); then
			NEXT=$(( $NEXT - ${#PATHS[@]} ))
		fi
		CHANGETO="${PATHS[$NEXT]}"
	fi
else
	touch -f "${HOME}/.cycle"
	PATHS=( $(ls "$WALLS") )
	CHANGETO="${PATHS[0]}"
fi
echo 'CURRENT_WAL="'"$CHANGETO"'"' | tee "${HOME}/.cycle" &> /dev/null || exit 1

# echo "${WALLS}/${CHANGETO}" # debugging purposes
wal -i "${WALLS}/${CHANGETO}"

