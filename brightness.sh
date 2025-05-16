#!/usr/bin/bash

## Identify primary display
PrimaryScreen=$(/usr/bin/xrandr --current | \
	/usr/bin/grep -w connected | \
	/usr/bin/cut -f 1 -d " ")

if [[ ! "${PrimaryScreen}" ]];
then
	echo "Failed to identify primary display. Closing brightness app." >&2
	exit $?
fi;

## Identify current Brightness value
CurrentBrightness=$(/usr/bin/xrandr --current --verbose | \
	/usr/bin/sed -n "/ connected primary /,/ disconnected / p" | \
	/usr/bin/grep -wi brightness | \
	/usr/bin/sed "s/^.*: //")
CurrentBrightness=$(echo "${CurrentBrightness} * 100 / 1" | /usr/bin/bc)

if [[ ${CurrentBrightness} -lt 0 || ${CurrentBrightness} -gt 100 ]];
then
	echo "Failed to identify primary display. Closing brightness app." >&2
	exit $?
fi;

## Draw a Zenity Window to Adjust Brightness
## Prevents Brightness from being set below 15%
set -o pipefail
/usr/bin/zenity --scale \
	--title="Brightness" \
	--ok-label="Done" \
	--cancel-label="Revert" \
	--text="" \
	--value=${CurrentBrightness} \
	--min-value=0 \
	--max-value=100 \
	--print-partial | \
	while read BrightPercent;
	do
		if [[ ${BrightPercent} -lt 15 ]];
		then
			BrightPercent=15;
		fi;
		BrightValue=$(echo "${BrightPercent} * 0.01" | /usr/bin/bc)
		/usr/bin/xrandr --output ${PrimaryScreen} \
			--brightness ${BrightValue}
	done

## If user cancels, revert to original Brightness
ExitCode=$?
if [[ ${ExitCode} -eq 1 ]];
then
	BrightValue=$(echo "${CurrentBrightness} * 0.01" | /usr/bin/bc)
	/usr/bin/xrandr --output ${PrimaryScreen} \
		--brightness ${BrightValue}
	exit $?
fi

## Quit
exit ${ExitCode}
