// ポイント
Point[] p;

// 現在位置
Cursor c;

// 表示されている球
Sphere current_s, next_s;

// ポイントの個数
int num = 10;

/**
 * ポイント・クラス
 */
class Point {
  float x; // x座標
  float y; // y座標

  // 描画
  void draw() {
    fill(255);
    ellipse(x, y, 5, 5);
  }
}

/**
 * 現在位置を表すカーソル・クラス
 */
class Cursor extends Point {
  int current_index; // 現在のポイントの番号
  float duration; // 移動時間(ミリ秒)
  boolean moveFlag; // 移動中フラグ

  int tick; // 移動カウンタ

  // コンストラクタ
  Cursor() {
    // 初期設定
    current_index = 0;
    duration = 3000;
    moveFlag = false;
    tick = 0;
    x = p[current_index].x;
    y = p[current_index].y;
  }

  // 移動メソッド
  void move() {
    // 移動フラグがtrueのときのみ実行
    if (moveFlag == true) {
      // 移動先を次のインデックスの番号に設定
      int next = (current_index + 1) % num;

      // 移動
      x = p[current_index].x + (p[next].x - p[current_index].x) * tick / (duration / 1000 * frameRate);
      y = p[current_index].y + (p[next].y - p[current_index].y) * tick / (duration / 1000 * frameRate);

      // 移動カウンタを増やす
      tick++;

      // 移動が終了したら
      if (tick > duration / 1000 * frameRate) {
        // 移動カウンタを0に戻す
        tick = 0;
        // 移動フラグをオフ
        moveFlag = false;
        // 次の場所を現在位置に
        current_index = next;
        current_s.x = p[c.current_index].x;
        current_s.y = p[c.current_index].y;
        next_s = null;
      }
    }
  }

  // 描画
  void draw() {
    fill(255, 0, 0);
    ellipse(x, y, 5, 5);
  }
}

/**
 * 球クラス
 */
class Sphere {
  float x; // x座標
  float y; // y座標
  float d; // 直径

  Sphere(int index) {
    d = 10;
    x = p[index].x;
    y = p[index].y;
  }

  void draw() {
    fill(0, 0, 255);
    ellipse(x, y, d, d);
  }
}

// 初期化
void setup() {
  size(250, 250);

  // ポイントの初期化
  p = new Point[num];

  // 位置のランダム生成
  for (int i = 0; i < p.length; i++) {
    p[i] = new Point();
    p[i].x = random(0, width);
    p[i].y = random(0, height);
  }

  // 現在位置の生成
  c = new Cursor();

  // 現在表示している球の生成
  current_s = new Sphere(c.current_index);
}

// 毎フレーム実行する内容
void draw() {
  // 背景を白く塗りつぶす
  background(255);

  // 移動
  c.move();

  // 描画
  current_s.draw();
  if (next_s != null) {
    next_s.draw();
  }
  for (int i = 0; i < p.length; i++) {
    p[i].draw();
  }
  c.draw();
}

// キーを押したら
void keyPressed() {
  // 移動フラグをオン
  c.moveFlag = true;

  // 移動先の球を生成
  next_s = new Sphere((c.current_index + 1) % num);
}


