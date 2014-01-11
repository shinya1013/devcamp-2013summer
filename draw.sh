#!/bin/bash

# functions
sigtrap()
{
	# カーソルを再度表示
	tput cvvis

	# カーソルをリセット
	tput_loop "cud1"
	tput clear
	echo "Thank you for watching this animation, "
	echo ""
	echo "/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
	echo "             GOOD   BYE !              "
	echo "/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
	echo ""
	echo "Quietting...                           "

	exit 1
}

colorize()
{
	if [ "$1" = '\n' ];then
		echo "=============================="
	fi
	if [[ $1 =~ ^[0-9]+$ ]]; then
		num=$((40 + $1))
		color="\x1b[${num}m \x1b[0m"
		echo -ne  $color
	else
		echo -ne " "
	fi
}

while IFS= read line
# 各行ごとの処理
do for ((i=0; i < ${#line}; i++)); do
	chara="${line:i:1}";
	colorize "$chara"
	
done;
 
echo;
done < $1

# def
REFRESH_TIME="0.8"

LINES_PER_IMG=$(( $(echo $IMG[0] | sed 's/\\n/\n/g' | wc -l) + 1))

# used for cuu1(cursor up) and cud1(cursor down)
tput_loop() { for((x=0; x < $LINES_PER_IMG; x++)); do tput $1; done; }

# ^C abort, script cleanup
trap sigtrap INT

# need multi-space strings
IFS='%'

# disable cursor

# main loop
# コマ表示ループを繰り返し表示する
while [ 1 ]; do for koma in "${IMG[@]}"; do
	echo -ne $koma
	tput_loop "cuu1"
	sleep $REFRESH_TIME
done; done


