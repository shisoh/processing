//playerDisp & Moveの変数を定義
float px = 0.0;
float py =0.0;
float vx = 0.0;
float vy = 0.0;
//maskvirusAllの変数を定義
int maskX[] =new int [7], maskY[]=new int [7];
int maskspeed[] =new int[7];
int virusX[] =new int[7], virusY[]=new int[7];
int virusspeed[] =new int[7];
float threshould =33;
boolean hitmask =false;
boolean hitvirus =false;
int mask;
int hp;
//ゲーム内のカウントで使う変数を定義
int gseq;
int startcount ;
int s ;
int mcnt;
int bariaCount;
//bariaで使う変数を定義
float bariaX;
float bariaY;
//キャンパスを作成
void setup() {
  size(500, 700);
  background(0);
  gameInit();
}
//ゲームを実行
void draw() {
  if (gseq==0) {
    gameTitle();
  } else if (gseq ==1) {
    gamePlay();
  } else if (gseq==2) {
    gameClear();
  } else {
    gameOver();
  }
}
//ゲームの初期設定
void gameInit() {
  background(0);
  gseq =0;
  mask=0;
  hp=3;
  px=width/2;
  py=650;
  startcount=0;
  s=0;
  mcnt=0;
  maskvirusAll();
  //リスタート時のマスクとウイルスのy値&バリアカウント値を戻す
  for (int i=0; i<7; i++) {
    maskX[i]=int(random(width));
    maskY[i]=-25;
    maskspeed[i]=int(random(8, 10));
    virusX[i]=int(random(width));
    virusY[i]=-25;
    virusspeed[i]=int(random(7, 12));
  }
  bariaCount=0;
}

//タイトルに表示する文字
void titleDisp() {
  fill(255, 0, 0);
  textSize(60);
  text("<FIGHT VIRUS>", 20, height/2-170);
  fill(255);
  textSize(20);
  text("You win if you collect 15 masks (white circles).", 40, height/2-70);
  text("Lost if you touch the virus (red circle) ", 40, height/2-30);
  text("three times.", 330, height/2+10);
  text("Bomus Time: While the green circle is spining.",40,height/2+50);
  text("→Disable the Virus!",40,height/2+80);
  mcnt++;
  if ((mcnt%60)<40) {
    textSize(40);
    fill(0, 255, 0);
    text("Click to start", 120, height/2+180);
  }
}
//タイトル画面
void gameTitle() {
  gseq=0;
  background(0);
  titleDisp();
}
//ゲームで使う関数達
void gamePlay () {
  playerMove();
  playerDisp();
  maskvirusAll();
  score();
  scoreDisp();
  count();
  if(bariaCount>0&&bariaCount<6&&hp==3&&mask>=5){
    baria();
  }
}
//ゲームをクリアしたら
void gameClear() {
  fill(0, 255, 0);
  textSize(90);
  text("YOU WIN!", 50, height/2-90);
  textSize(35);
  text("Clear time:"+s+"s", 75, height/2-30);
  fill(200, 0, 200);
  textSize(40);
  text("Crick to Play again!", 80, height/2+150);
}
//ゲームに負けたら
void gameOver() {
  fill(255, 0, 255);
  textSize(70);
  text("GAME OVER...", 30, height/2-30);
  fill(0, 255, 0);
  textSize(40);
  text("Click to retry", 120, height/2+150);
}
//プレーヤの円を表示
void  playerDisp() {
  background(0);
  px=px+vx;
  py =py+vy;
  fill(0, 0, 255);
  circle(px, py, 50);
}
//プレーヤーの円を動かす
void playerMove() {
  if (keyPressed&&keyCode==UP) {
    vx=0.0;
    vy =-5.0;
  } else if (keyPressed&&keyCode==DOWN) {
    vx=0.0;
    vy=5.0;
  } else if (keyPressed&&keyCode==LEFT) {
    vx=-5.0;
    vy=0.0;
  } else if (keyPressed&&keyCode==RIGHT) {
    vx=5.0;
    vy=0.0;
  }
  //プレイヤーが画面外に出そうになったら押し返す
  if (px<25) {
    vx=1.0;
    vy=0.0;
  } else if (px>475) {
    vx = -1.0;
    vy =0.0;
  } else if (py<25) {
    vx=0.0;
    vy = 1.0;
  } else if (py>675) {
    vx=0.0;
    vy = -1.0;
  }
}
//マスクとウイルスを描画
void maskvirusAll() {
  for (int i =0; i<7; i++) {
    fill(255);
    circle(maskX[i], maskY[i], 25);
    maskY[i]+=maskspeed[i];
    fill(255, 0, 0);
    circle(virusX[i], virusY[i], 25);
    virusY[i]+=virusspeed[i];
    //マスクとウイルスが画面外に出たらもう１度描画
    if (maskY[i]-12.5>height) {
      maskdo(i);
    }
    if (virusY[i]-12.5>height) {
      virusdo(i);
    }
    //マスクとウイルス＆バリアのヒット判定
    float dist =sqrt(sq(px-maskX[i])+sq(py-maskY[i]));
    float dist2 = sqrt(sq(px-virusX[i])+sq(py-virusY[i]));
    hitmask = dist < threshould;
    hitvirus = dist2 < threshould;
    if (hitmask) {
      maskdo(i);
      mask++;
      if(mask>=4&&hp==3){
      bariaCount++;
      }
    }
    if (hitvirus) {
       if(bariaCount>0&&bariaCount<6&&mask>=5&&hp==3){
        hp++;
      }
      virusdo(i);
      hp--;
    }  
  }  
}
//マスク15枚orウイルス３個でgameover or game clearへ
void score() {
  if (mask==15) {
    gseq=2;
  }
  if (hp==0) {
    gseq=3;
  }
}
//スコアを表示
void scoreDisp() {
  fill(255);
  textSize(20);
  text("HP"+hp, 10, 20);
  text("mask"+mask, 10, 40);
  text(s+"seconds", 10, 60);
}
//マウスをクリックで画面を切替
void mousePressed() {
  if (gseq==0) {
    gseq=1;
  }
  if (gseq==3||gseq==2) {
    gameTitle();
    gameInit();
  }
}
//秒数をカウント
void count() {
  startcount++;
  if (startcount%60==0) {
    s++;
  }
}
//マスクとウイルスの座標を設定する
void maskdo(int i) {
  maskX[i]=int(random(width));
  maskY[i]=-25;
  maskspeed[i]=int(random(8, 10));
}
void virusdo(int i) {
  virusX[i]=int(random(width));
  virusY[i]=-25;
  virusspeed[i]=int(random(7, 12));
}
//バリア設定
void baria(){
  float centerX = px;
  float centerY = py;
  float length = min(width,height)/2-200;
  float theta = frameCount/10.0;
  float bariaX = length * cos(theta)+centerX;
  float bariaY = length*sin (theta)+centerY;
  fill(0,255,0);
  ellipse(bariaX,bariaY,30,30);
}
