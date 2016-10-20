#!/bin/bash
#
# Generates the source-able environment for a newly created
# CODK project, by combining new values for ARC/X86_PROJ_DIR
# with the contents of zephyr-env.sh

if [ $# != 2 ]
then
    echo "Usage: $0 <CODK_DIR> <PROJ_DIR>"
    exit 1
fi

outfile="$2"/env.sh

cat << EOT >> "$outfile"
if [[ \$_ == \$0 ]]
then
        echo "Source this script (don't execute it)"
        exit 1
fi

source $1/../zephyr/zephyr-env.sh
export CODK_DIR=$1
export ARC_PROJ_DIR=$1/$2/arc
export X86_PROJ_DIR=$1/$2/x86
EOT

echo
echo "New project created in '$2'"
echo "To work in '$2', exit your current shell session and start"
echo "a new one. Then source your project's env.sh script;"
echo
echo "    $ source $2/env.sh"
echo
echo "Now, you are ready to write code in $2/arc and"
echo "$2/x86"
echo
