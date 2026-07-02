# 詳細設計書

---

# **1. システム概要**

## 1.1 対象システム

> 詳細設計の対象となるシステム名・概要を記載する。

## 1.2 対象範囲

> 今回の詳細設計で扱う機能範囲を記載する。  
> 例：ログイン、ログアウト、ユーザー登録、ユーザー情報表示、ユーザー一覧、編集、削除

---

# **2. 使用技術**

|項目|内容|
|:--|:--|
|開発言語|Ruby on Rails|
|データベース|PostgreSQL|
|開発環境|Docker for Desktop|
|os|Ubuntu|

---

# **3. ルーティング設計**

|HTTPメソッド|URL|Controller|Action|概要|
|:---|:---|:---|:---|:---|
|GET|/users/sign_in|Devise|new|ログイン画面表示|
|POST|/users/sign_in|Devise|create|ログインを実行|
|DELETE|/users/sign_out|Devise|destroy|ログアウトを実行|
|GET|/users/sign_up|Devise|new|新規登録画面を表示|
|POST|/users|Devise|create|ユーザー登録を実行|
|GET|/users|UsersController|index|一覧画面を表示|
|GET|/users/:id|UsersController|show|ユーザー情報を表示|
|GET|/users/:id/edit|UsersController|edit|編集画面を表示|
|PATCH|/users/:id|UsersController|update|更新を実行|
|DELETE|/users/:id|UsersController|destroy|削除を実行|

---

# **4. コントローラ設計**


## 4.1 UsersController
|処理|概要|
|:---|:---|
|index|一覧表示|
|show|自身の情報を表示|
|edit|ユーザー情報の編集フォームを表示|
|update|DBの情報を更新|
|destroy|情報を削除|


## 4.2 Devise::SessionsController
|処理|概要|
|:---|:---|
|new|ログイン画面を表示|
|create|ログイン処理を実行|
|destroy|ログアウト処理を実行|

## 4.3 Devise::RegistrationsController
|処理|概要|
|:---|:---|
|new|ユーザー登録画面を表示|
|create|ユーザーを登録|

---

# 5. **モデル設計**

## 5.1 モデル一覧

|モデル名|対応テーブル|役割|
|:--|:--|:--|
|User|users|認証情報、ユーザー情報、権限情報を管理|


## 5.2 Userモデル

|項目|内容|
|:--|:--|
|モデル名|User|
|対応テーブル|users|
|主な役割|認証情報、ユーザー情報、権限情報を管理|
|認証方式|Devise|
|権限管理|roleカラムで管理|

## 5.3 関連設計

今回は存在するモデルがUsersだけなので関連設計はない

## 5.4 enum設計

### role

|値|名称|説明|
|:---:|:---|:---|
|0|general|一般ユーザー|
|1|admin|管理者|

---

# 6. DB詳細設計

> テーブルごとのカラム、型、NULL可否、キー、制約、初期値を記載する。

## 6.1 usersテーブル

## users

|カラム|型|NULL|キー|初期値|備考|
|:---|:---|:---:|:---:|:---|:---|
|id|bigint|×|PK|-|ユーザーID|
|name|string|×|-|-|ユーザー名|
|email|string|×|UNIQUE|-|メールアドレス|
|encrypted_password|string|×|-|-|暗号化済みパスワード|
|role|integer|×|-|0|0:一般ユーザー、1:管理者|
|created_at|datetime|×|-|-|作成日時|
|updated_at|datetime|×|-|-|更新日時|

---

# 7. バリデーション設計

## 7.1 ユーザー登録

|項目|必須|文字数|その他|エラー時の動作|
|:--|:--|:--|:--|:--|
|名前|○|50文字以内|-|メッセージ表示<br>「条件を満たしていません」|
|メールアドレス|○|254文字以内|メールアドレスの重複×<br>メールアドレス形式|メッセージ表示<br>「条件を満たしていません」
|パスワード|○|8文字以上|-|メッセージ表示<br>「条件を満たしていません」

## 7.2 ログイン画面

|項目|必須|その他|エラー時の動作|
|:--|:--|:--|:--|
|メールアドレス|○|メールアドレス形式|メッセージ表示<br>「メールアドレスが間違っています」
|パスワード|○|-|メッセージ表示<br>「パスワードが間違っています」

---

# 8. 認可・権限制御設計

> 一般ユーザーと管理者で利用できる機能を整理する。

|機能|一般ユーザー|管理者|
|:---|:---:|:---:|
|ログイン|○|○|
|ログアウト|○|○|
|新規登録|○|×|
|自身の情報閲覧|○|×|
|自身の情報編集|○|×|
|ユーザー一覧表示|×|○|
|他ユーザー編集|×|○|
|ユーザー削除|×|○|

---

# 9. 処理フロー

> 機能ごとの処理の流れを順番に記載する。  
> 実装前に「何をどの順番で処理するか」を整理する。

## 9.1 ログイン処理フロー

1. ログイン画面を表示する
1. メールアドレス・パスワードを入力する
1. ログインボタンを押下する
1. 入力内容のバリデーションを実施する
1. Deviseで認証する
1. 認証成功時はroleを判定する
1. 一般ユーザーはユーザー情報画面へ遷移する
1. 管理者はユーザー一覧画面へ遷移する
1. 認証失敗時はエラーメッセージを表示する


## 9.2 ユーザー登録処理フロー

1. ユーザー登録画面を表示する
1. 名前・メールアドレス・パスワードを入力する
1. 新規登録ボタンを押下する
1. 入力内容のバリデーションを実施する
1. Userテーブルへユーザー情報を登録する
1. roleに一般ユーザー(0)を設定する
1. ユーザー情報画面へ遷移する

## 9.3 ユーザー一覧表示処理フロー

1. 管理者がログインする
1. UsersController#indexを実行する
1. Userテーブルからユーザー情報を取得する
1. ユーザー一覧画面を表示する

## 9.4 ユーザー編集処理フロー

1. 編集画面を表示する
1. 編集内容を入力する
1. 更新ボタンを押下する
1. 入力内容のバリデーションを実施する
1. Userテーブルを更新する
1. 更新完了後、遷移元の画面へ戻る

## 9.5 ユーザー削除処理フロー

1. 管理者がユーザー一覧画面を表示する
1. 削除対象ユーザーを選択する
1. 削除ボタンを押下する
1. 確認ダイアログを表示する
1. Userテーブルから対象ユーザーを削除する
1. ユーザー一覧画面を再表示する
 

---

# 10. シーケンス図

> 利用者、ブラウザ、Rails、DBのやり取りをMermaidで記載する。  
> 特にログイン、登録、編集、削除などの主要処理を書く。

## 10.1 ログイン

```mermaid
sequenceDiagram
    actor User
    participant Browser
    participant Rails
    participant DB

    User->>Browser: ログイン情報を入力
    Browser->>Rails: ログインリクエスト
    Rails->>DB: ユーザー情報照会
    DB-->>Rails: ユーザー情報返却
    Rails-->>Browser: 認証結果返却
    Browser-->>User: 遷移先画面を表示
```

## 10.2 ユーザー登録

```mermaid
sequenceDiagram
    actor User
    participant Browser
    participant Rails
    participant DB

    User->>Browser: 新規情報を入力
    Browser->>Rails: 新規登録リクエスト
    Rails->>Rails: ユーザー情報のバリデーション
    Rails->>Rails:roleに一般ユーザーを設定
    Rails->>DB:ユーザー情報を登録
    DB-->>Rails: ユーザー情報登録結果を返却
    Rails-->>Browser: ユーザー情報画面へリダイレクト
    Browser-->>User: ユーザー情報画面を表示
```

## 10.3 ユーザー情報編集

```mermaid
sequenceDiagram
    actor User
    participant Browser
    participant Rails
    participant DB

    User->>Browser:変更箇所を入力
    Browser->>Rails:ユーザー情報の編集をリクエスト
    Rails->>Rails:変更内容をバリデーション
    Rails->>DB:変更情報を登録
    DB-->>Rails:編集情報登録結果
    Rails-->>Browser:ユーザー情報画面へリダイレクト
    Browser-->>User:ユーザー情報画面を表示

```

## 10.4 ユーザー削除

```mermaid
sequenceDiagram
    actor User
    participant Browser
    participant Rails
    participant DB

    User->>Browser:削除ボタンをクリック
    Browser->>Rails:指定ユーザーの削除リクエスト
    Rails-->>Browser:確認ダイアログ送信
    Browser-->>User:確認ダイアログ送信
    User->>Browser:確認ボタンをクリック
    Browser->>Rails:ユーザー削除リクエスト
    Rails->>DB:指定ユーザーを削除
    DB-->>Rails:削除結果返却
    Rails-->>Browser:ユーザー一覧画面へリダイレクト
    Browser-->>User:ユーザー一覧画面を表示

```