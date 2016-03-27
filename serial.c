//
//  main.c
//  sok_ore
//
//  Created by shinya on 2014/01/12.
//  Copyright (c) 2014年 shinya. All rights reserved.

/**
 * ヘッダー
 * unistd : open, read, closeなどのIO
 * termios : 端末インターフェースの構造体。c_iflagを呼ぶため
 *
 * signal : Ctrl-cとトラップ
 *
 */
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <strings.h>
#include <signal.h>

//#define _POSIX_SOURCE 1 /* POSIX準拠 */
#define BAUDRATE B9600  /* todo:ボーレートはarduinoに合わせた。 */
#define MODEMDEVICE "/dev/cu.usbserial-A9005aOW"
#define FALSE 0
#define TRUE 1

int fileDesc;
int isrunning = TRUE;  // 終了シグナル用フラグ
struct termios oldtio, newtio;

/**
 * シリアル通信用ストリームをopenする
 *
 */
int serialOpen() {
	fileDesc = open(MODEMDEVICE, O_RDWR | O_NOCTTY );
	if (fileDesc <0) {
		printf("error: %s\n",MODEMDEVICE); // エラー処理
        
		return -1;
	}
    // 現在のポート設定を保存
	tcgetattr(fileDesc, &oldtio);
	bzero(&newtio,  sizeof(newtio));
	newtio.c_cflag = BAUDRATE | CRTSCTS | CS8 | CLOCAL | CREAD;
	newtio.c_iflag = IGNPAR;
	newtio.c_oflag = 0;
	/* インプットモードの設定 (non-canonical, no echo,...) */
	newtio.c_lflag = 0;
	newtio.c_cc[VTIME]    = 0;
    /* 文字ベースでの読み込み */
	newtio.c_cc[VMIN]     = 1;
	tcflush(fileDesc, TCIFLUSH);
	tcsetattr(fileDesc,TCSANOW,&newtio);
    
	return 0;
}

/**
 * ストリームのcloseする
 * 前回のポート設定をリストア
 */
void serialClose() {
	tcsetattr(fileDesc,TCSANOW, &oldtio);
	close(fileDesc);
}

/**
 * シグナルを読み込む
 */
unsigned char serialReadChar() {
	unsigned char result;
    
    // バッファをクリアし、1バイトごとに読み込み（それまではブロッキングしつつ、1byteをバッファ）
	tcflush(fileDesc, TCIFLUSH);
    read(fileDesc, &result, 1);
    
	return result;
}

/**
 *
 * Ctrl-Cをトラップする。
 */
void interrupt(int sig) {
    isrunning = FALSE;
}

/**
 * main
 */
int main(int argc, const char * argv[])
{
    // チェック
	if(serialOpen() != 0)
    {
        return -1;
    }
    
    signal(SIGINT, interrupt);
//	while (isrunning) {
        printf("%c\n", serialReadChar());
//	}
	serialClose();
    
	return 0;
}



