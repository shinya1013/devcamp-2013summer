#!/bin/bash

##################################
# config
##################################
# リフレッシュ時間
REFRESH_TIME="0.8"

# アニメーション定義
KOMA=(
"
                       _                      \n\
                      | |                     \n\
(」・ω・)」えい!     | |                     \n\
----------------------------------------------\n
" "
                       _                      \n\
                      | |                     \n\
      (/・ω・)/やー! | |                     \n\
----------------------------------------------\n
" "
                       _                      \n\
                      | |   -(  ^ ω ^)-とう! \n\
                      | |                     \n\
----------------------------------------------\n
"
)

# Ctrl + Cをトラップする
sigtrap()
{
	# make cursor visible again
	tput cvvis

	# reset cursor
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

# tputをループ制御
tput_loop()
{
	for((x=0; x < $LINES_PER_IMG; x++)); do tput $1; done;
}
##################################

trap sigtrap INT
LINES_PER_IMG=$(( $(echo $KOMA[0] | sed 's/\\n/\n/g' | wc -l) + 1))

tput civis

tput clear
# main loop コマ表示ループを繰り返し表示する
IFS='%'
while [ 1 ]; do for koma in "${KOMA[@]}"; do
	echo -ne $koma
	tput_loop "cuu1"
	sleep $REFRESH_TIME
	tput clear
done; done


