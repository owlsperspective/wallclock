# WallClock
## 概要
- 設定機能も何もない、シンプルな壁時計です。起動するとメインモニタの右上に時刻と日付、曜日が表示されます。終了するときはタスクトレイアイコンを右クリックして終了を選択します。
- 時計は24時間表記で、毎秒コロン(":")が点滅します。また毎正時の前後2秒間は文字の色が赤くなります。
- 時計の表示はマウス操作を透過します。またマウスカーソルを時計の上に置くと、表示が見えなくならない程度に薄くなります。
- 他のプログラムが(PowerPointのスライドショーのように)全画面表示したり、全画面のDirect3Dアプリケーションが実行されているときは非表示になります。

## 開発環境
- RAD Stusio (Delphi) 11 Update 3 (11.3)<br />
  https://www.embarcadero.com/jp/products/delphi
- Skia4Delphi 6.0.0 beta 3<br />
  https://skia4delphi.org/<br />
  https://github.com/skia4delphi/skia4delphi
- 基本的にSkia4Delphiに対応しているDelphi XE7以降のバージョンであればコンパイルできるはずです。またCommunity Editionを含む全てのSKUでコンパイルできます。

    Delphi Community Edition - エンバカデロ・テクノロジーズ<br />
    https://www.embarcadero.com/jp/products/delphi/starter

## 技術的なポイント
### マウス操作を透過
pikさんの以下の記事そのままです。

[Delphi] 半透明でクリックを透過するウィンドウの作り方 - Qiita<br />
https://qiita.com/pik/items/71142d607937bc713af2

フォームの`AlphaBlend`プロパティを`True`にすることでLayered Windowにして、`CreateParams`メソッドを`override`して`Params.ExStyle`に`WS_EX_TRANSPARENT`と`WS_EX_NOACTIVATE`を追加することでマウス操作を透過させます。

### 文字の縁取り
デスクトップ上に単に文字を表示すると、デスクトップや下のウィンドウの表示との関係から、常に見やすい色というのは存在しません。そこで文字を濃色として、淡色で縁取りするためにSkia4Delphiの`TSkLabel`を使用しています。

### フォントの選択
英数字だけの表示なので、きれいにアンチエイリアスされる英字フォントとしてCalibriを選択しました。しかしWindows標準の英字フォントはCalibriを含めほとんどがプロポーショナルフォントのため表示内容によって幅が変化してしまい、時計として表示したときに表示位置がちらちらと変化して見づらくなってしまいます。そこで1文字ごとにLabel(`TSkLabel`)を配置しています。

### 文字以外の部分の透過
フォームの`TransparentColor`プロパティをTrueにして、色を`TransparentColorValue`プロパティに設定することで文字以外の部分を透過します。しかしそのままでは縁取りのアンチエイリアスの部分がきれいに透過されません。そこで縁取りの色とフォームの色が極めて近く(RGB各1ビットの違いに)なるようにしています。

### マウスオーバ時の半透過
時計表示の部分はマウス操作が透過しますが、そのままでは時計表示が邪魔をして下に何があるかわからなくなるため、マウスがフォーム上にあるときはフォームの`AlphaBlendValue`プロパティを(段階的に)255から減らして半透過にすることでマウス操作を妨げないようにしています。

### 全画面表示になっているときの非表示
全画面でゲームをしているときなどは時計表示が邪魔なので、フォームの`Visible`プロパティを`False`にして非表示にしています。他のプログラムが全画面を占有しているかどうかは

c++ - Detecting full screen mode in Windows - Stack Overflow<br />
https://stackoverflow.com/questions/7009080/detecting-full-screen-mode-in-windows

を参考にして、Win32APIの`SHQueryUserNotificationState`で`QUNS_BUSY`または`QUNS_RUNNING_D3D_FULL_SCREEN`が返ってくるかどうかで判定しています。

SHQueryUserNotificationState function (shellapi.h) - Win32 apps | Microsoft Learn<br />
https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shqueryusernotificationstate

QUERY_USER_NOTIFICATION_STATE (shellapi.h) - Win32 apps | Microsoft Learn<br />
https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ne-shellapi-query_user_notification_state

### タスクバー上にアプリケーション/メインフォームを表示しない
タスクバー上にアプリケーションやメインフォームが表示されても邪魔なだけなので、

delphi - How to hide an application from taskbar in Windows 7? - Stack Overflow<br />
https://stackoverflow.com/questions/14811935/how-to-hide-an-application-from-taskbar-in-windows-7

にあるように、フォームの`CreateParams`メソッドを`override`して`Params.ExStyle`から`WS_EX_APPWINDOW`を削除するとともに、`PopupMode`プロパティを`pmExplicit`にしています。

### 常に最前面に表示
フォームの`FormStyle`プロパティを`fsStayOnTop`にすることで、常に最前面で表示されるはずなのですが、なにかの拍子で他のプログラムの後ろになってしまうことがあります。そこで全画面解除で`Visble`プロパティを`True`にする、タスクトレイアイコンのクリック、タスクトレイアイコンの右クリックでポップアップメニューが表示される、というタイミングで`HWND_TOPMOST`を指定してWin32APIの`SetWindowPos`を呼び出すことでフォームが最前面を維持するようにしています。

SetWindowPos function (winuser.h) - Win32 apps | Microsoft Learn<br />
https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowpos

## 既知かもしれない問題
- マルチモニタに対する考慮がありません。マルチモニタ環境では意図しない位置に表示されるかもしれません。	
- HiDPIの対応は単にマニフェストで"Per-Monitor (V2) DPI"を指定しているだけなので、100%以外のスケールでは正しく表示されないかもしれません。

## プログラムの変更について
このプログラムには設定機能が一切存在しないため、何かを変えようとするときはプログラムを変更して再コンパイルする必要があります。DelphiのCommunity Editionは商用でなければ(商用でも一定の範囲で)自由に使用できるため、適宜コードを変更して再コンパイルしてご使用ください。

## ライセンス
このプログラムに固有のコードについてはMITライセンスが適用されます。

Copyright 2023 Owl's Perspective

The MIT License – Open Source Initiative<br />
https://opensource.org/license/mit/

(日本語参考訳)<br />
https://licenses.opensource.jp/MIT/MIT.html
