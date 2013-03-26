#!/bin/bash
########################################
# gather all scripts info and generate Markdown README
# 
# the markdown format README is an overview of all scripts
# it could be used at Bitbucket or Github
# 
# The script requires all script following a rule that
# short introduction was written in certain line
# 
# Kai Yuan 
# kent.yuan at gmail dot com
# 2011-11-01
# here I made some changes too (test1)
#
########################################

if [ $# != 2 ]; then
	cat <<EOF
	script to generate md format README for Bitbucket or Github.

	Usage:
		$0 <short desc line No.> <top level title>
		example: $0 3 myScript
	
EOF

	exit 2
fi

INFO=$1
H1=$2
README=README.md
echo -e "

**$README was generated by shell script $0**
" > $README

echo -e "$H1
==========" >> $README

# only get the 1st level sub-directories (excluding hidden stuffs)
for d in $(ls -dF *|grep "\/$")
do
	echo -e "$d\\n----------" >> $README
	
	for f in $(ls -dF $d*|grep -Ev "\/$")
	do
		# awk line removing directory prefix and pushing INFO line to target file.
		awk -v pre=$d -v idx=$1 -v target=$README \
			'NR==idx{gsub(pre,"",FILENAME);gsub(/^#/,"");printf "\t- %-14s ---------- %s\n", FILENAME, $0 >> (target); exit; }'  $f
	done
done

