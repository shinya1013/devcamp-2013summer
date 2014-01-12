#!/bin/bash

#################################
# 
# 
# Usage:
# Ctrl-cで終了
# 
#################################

###########################
# キーボードイベントをトラップ
###########################
sigtrap()
{
	# カーソルを再度表示
    tput civis
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

###########################
# 文字を解析し、カラーピクセルに変換nする
# 
###########################
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


######################################################
# アニメーション再生
######################################################
while IFS= read line
# 各行ごとの処理
do for ((i=0; i < ${#line}; i++)); do
       chara="${line:i:1}";
       colorize "$chara"

done;

echo;
done < $1


########################################################################
# def
REFRESH_TIME="0.5"
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


# used for cuu1(cursor up) and cud1(cursor down)
tput_loop() {
	for((x=0; x < $LINES_PER_KOMA; x++)); do
		tput $1;
	done;
}

# トラップ
trap sigtrap INT

LINES_PER_KOMA=$(( $(echo $KOMA[0] | sed 's/\\n/\n/g' | wc -l) + 1))

# カーソルを再度表示
tput civis

# main loop コマ表示ループを繰り返し表示する
IFS='%'

# disable cursor
#tput cnorm
tput vs


# コマ表示ループを繰り返し表示する
while [ 1 ]; do for koma in "${KOMA[@]}"; do
	echo -ne $koma
	tput_loop "cuu1"
	sleep $REFRESH_TIME
	tput clear;
done; 
done

########################################
