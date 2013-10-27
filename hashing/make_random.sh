#!/bin/bash
#
# Get a bunch of random numbers from RANDOM.ORG. These are then parsed and put
# into a particular header file.

# Returns a list of 66 lines, each of which has four (random) numbers
URL="http://www.random.org/integers/?num=264&min=0&max=65536&col=4&base=10&format=plain&rnd=new"

#NUMBERS="$(curl $URL)"
NUMBERS=$(cat random.org)

#echo "$NUMBERS"

RAND=random-numbers.hpp
TAB="$(printf '\t')"
# Generate random number header file:
cat <<EOF > $RAND
/**
 * This file is auto-generated by make-random.sh and should not be edited by
 * hand. It contains a list of 'struct number', 66 all in all, generated by
 * contacting random.org using the following URL:
 *
 * $TAB$URL
 */
#ifndef __RANDOM_NUMBERS
#define __RANDOM_NUMBERS

#include "dshash.hpp"
struct number random_numbers[66] = {
EOF

#static struct number a = { 0, ((uint32_t) 248421 << 16) | ((uint32_t) 17703), ((uint32_t) 367827 << 16) | ((uint32_t) 516523) };
while read -r line; do
	arr=(${line//\t/ })
	#echo "1: echo ${arr[0]}, 2: ${arr[1]}, 3: ${arr[2]}, 4: ${arr[3]}"
	cat <<EOF >> $RAND
$TAB{ 0, ((uint32_t) ${arr[0]} << 16)$TAB| ((uint32_t) ${arr[1]}), ((uint32_t) ${arr[2]} << 16)$TAB| ((uint32_t) ${arr[3]}) },
EOF
done <<< "$NUMBERS"

cat <<EOF >> $RAND
};
#endif
EOF
