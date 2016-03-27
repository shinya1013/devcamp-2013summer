#!/bin/bash

#################################
# 
# 
#################################

######################################################
# キーボードイベントをトラップ
sigtrap()
{
	# カーソルを再度表示
    tput civis
	tput_loop "cud1"
	tput clear
	echo " "
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo "/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
	echo "/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
	echo "             GOOD   BYE !              "
	echo "/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
	echo "/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo "Quietting...                           "
	echo ""

	exit 1
}

######################################################
# 文字を解析し、カラーピクセルに変換nする
colorize()
{
	if [ "$1" = '\n' ];then
		echo "error 引数がない"
	fi
	if [[ $1 =~ ^[0-9]+$ ]]; then
		num=$((40 + $1))
		color="\x1b[${num}m \x1b[0m"
		echo -ne  $color
	else
		echo -ne " "
	fi
}
# fix
REFRESH_TIME="0.5"

######################################################
# コマの定義。ファイルから読み込むのもありかも
KOMA=(
"
                                              \n\
                                              \n\
                                              \n\
                                              \n\
                                              \n\
                                              \n\
(」・ω・)」よし...                             \n\
ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo\n
         しばらくお待ちください                  \n
ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo\n
" "
                                              \n\
                                              \n\
                                              \n\
                                              \n\
                                              \n\
                                              \n\
      (/・ω・)/それ!                         \n\
000000000000000000000000000000000000000000000000000000000000000\n
         しばらくお待ちください                  \n
000000000000000000000000000000000000000000000000000000000000000\n
" "
                                              \n\
                                              \n\
                                              \n\
                                              \n\
                                              \n\
              (/・ω・)/                   \n\
                                              \n\
ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo\n
         しばらくお待ちください                  \n
ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo\n
" "
                                              \n\
                                              \n\
                                              \n\
                                              \n\
                            -(  ^ ω ^)-! \n\
                                              \n\
                                              \n\
000000000000000000000000000000000000000000000000000000000000000\n
         しばらくお待ちください                  \n
000000000000000000000000000000000000000000000000000000000000000\n
"
)

######################################################
# カーソル移動
# cuu1 = カーソルup、 cud1 = カーソル down
tput_loop() {
	for((x=0; x < $LINES_PER_KOMA; x++)); do
		tput $1;
	done;
}

# Ctrl-Cで終了できるようキートラップ
trap sigtrap INT

#############################################################
#while [ 1 ]; do find . -name "*.dat" | while read SRC; do

	# コマごとの処理
#	while IFS= read line
		# 各行ごとの処理
#		do for ((i=0; i < ${#line}; i++)); do
#			chara="${line:i:1}";
#			colorize "$chara"
#		done;
#	echo '';
#	done < $SRC;
#	tput clear;
#done;
#done;
#############################################################




#############################################################
# アニメーション処理
#############################################################

# 複数業で定義した１コマを１行に変換する
LINES_PER_KOMA=$(( $(echo $KOMA[0] | sed 's/\\n/\n/g' | wc -l) + 1))

# カーソルを再度表示
tput civis
# disable cursor
#tput cnorm
tput vs

# コマ表示ループを繰り返し表示する
IFS='%'
#while [ 1 ]; do for koma in "${KOMA[@]}"; do
for i in `seq -w 1 6`; do for koma in "${KOMA[@]}"; do
	echo -ne $koma
	tput_loop "cuu1"
	CHAR=0
	read -s -n 1 CHAR < /tmp/StreamTest
# 数字チェク
	while [[ ! $CHAR =~ ^[0-9]+$ ]]; do
		read -s -n 1 CHAR < /tmp/StreamTest
	done
# bashでは少数の計算ができないので、閾値で判定する
	if [ $CHAR -lt 5 ];then
		#sleep $REFRESH_TIME;
		sleep 0.2;
		echo "--------------------------"
	else
		sleep 1.5;
		echo "==================="
	fi
		tput clear;

done;
done; 

########################################
# アニメーション再生
# 
while :;do
find . -name "*.at" | while read SRC; do

	# コマごとの処理
	while IFS= read line
		# 各行ごとの処理
		do for ((i=0; i < ${#line}; i++)); do
			chara="${line:i:1}";
			colorize "$chara"
		done;
	echo;
	done < $SRC;
	
	tput clear;
done;
done;
