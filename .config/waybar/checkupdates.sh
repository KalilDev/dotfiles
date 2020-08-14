#!/bin/bash

# icon 
output="$(checkupdates)"
number="$(echo "$output" | wc -l)"
tooltip=""

if [ $number -ge 30 ]
then
    tooltip="$(echo "$output" | head -n 20 | sed -z 's/\n/\\n/g')"
    tooltip+='...'
else
    tooltip="$(echo "$output" | sed -z 's/\n/\\n/g')"
#    tooltip=${tooltip::-2}
fi

# trim
tooltip=$(echo "$tooltip" | sed -e s/\n//g'')

#echo "{\n  "text\": \""$number"\",\n  \"tooltip\": \""$tooltip"\"\n}"
cat << EOF
{
  "text": "$number",
  "tooltip": "$tooltip"
}
EOF
#exit 0
