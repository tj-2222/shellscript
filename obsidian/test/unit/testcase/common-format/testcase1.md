参考：

# サマリ

* * *

サマリ

# トピック

* * *

参考：https://aws.amazon.com/jp/elasticache/redis/?nc=sn&loc=0

redis互換のあるインメモリデータストア。
要するにフルマネージドで使えるredis。

### *redisって何に使うの？*

参考：https://dev.classmethod.jp/articles/elasticache-cached-rdsquery/

主な用途はキャッシュデータストア。特にその中でも以下のようなユースケースがある模様
    1. データベースクエリのキャッシュ：RDBなどのクエリ結果をキャッシュする。なかったらとってくる。

    2. セッション情報のキャッシュ：webアプリにおけるユーザーセッション情報を内部インスタンスではなく外部（redis）でキャッシュする。セッション情報の保持と管理をAPIサーバから分離することでサーバインスタンスのスケールアウト制御が容易になる。

    3. ページキャッシュ：APIレスポンス結果をキャッシュする。

ちなみにキャッシュ利用時の原則として、ヒット時挙動とミスヒット時の挙動があるが、このあたりの制御はアプリケーションロジック側の責務となる。
redisはあくまでキャッシュデータをTTL期間内で保持するだけのシンプルな責務に留まる。

### *redis AUTHについて*

redisサーバアクセス時の認証トークンのこと。
要するにDBアクセスパスワード。

### *Elasticache for Redisクラスターについて*

参考：

- https://dev.classmethod.jp/articles/amazon-elasticache-redis-param/
- https://docs.aws.amazon.com/ja_jp/AmazonElastiCache/latest/red-ug/Replication.Redis-RedisCluster.html

RedisをDBエンジンに選択した場合、クラスター構成をとることが出来る。
クラスタモードのon/off、レプリケーションのon/offで下記4パターンに分かれる。

Redisはインメモリデータベースで揮発性のため、クラスター構成をとらない場合にノードが死ぬとデータ復旧が出来なくなるため、クラスター構成が推奨される。（気がする）

![image.png](07_SAP勉強/01_ワークロード構築/_resources/image-23.png)

### *memcachedとの違い*

参考：

    - https://aws.amazon.com/jp/elasticache/redis-vs-memcached/
    - https://dev.classmethod.jp/articles/which-choice-redis-memcached/

redisもmemcachedのどちらもインメモリデータストアに関するDBエンジン。
redisの方が多機能の模様。

例えばmemcachedの場合、冗長構成（レプリケーション）に対応していなかったりする。

### *NoSQLとしての違い*

vs. mongDB
例えばJSONデータを扱う場合、redis（キーバリューストア）とmongoDB（ドキュメントストア）で何が違うのかChatGPTに聞いてみた。
参考：https://chat.openai.com/c/d0a9d099-f8b9-4c90-bb42-1aae74d72e18

ざっくりいうと、JSON丸ごと引っ張ってくるだけでいいならredis、JSONに対して更に細かいクエリ掛けたいならmongoDBという使い分けになる模様。
ここにredisとmongoDBが別ジャンルのNoSQLとして扱われてる理由が表れてそう。

vs. DynamoDB
参考：https://zenn.dev/issy/articles/zenn-elasticache-overview

データ永続化が不要なデータ（セッションデータなど）を扱う場合は、コスト的にElastiCacheが適する模様。

# ハンズオン

* * *

参考：https://aws.amazon.com/jp/getting-started/hands-on/boosting-mysql-database-performance-with-amazon-elasticache-for-redis/module-one/

以下構成を作成する。AZ周りの冗長構成含んだ実際の配置は省略する。
**単純に各リソース作成して、接続に必要な情報（IP、ポートなど）をEC2に付与して、pythonロジックでキャッシュ制御してるだけ**
![tmp45.drawio.png](tmp45.drawio.png)

*手順概要*
※EC2インスタンスは作成済みとする。
1. Redisの作成
2. MySQLデータベースの作成
3. MySQLデータベースにデータを入力する
4. キャッシュ読み取り
5. クリーンアップ

*手順詳細*
①Redisの作成
ElastiCacheより、以下のようなRedisクラスターを作成する。
![image.png](07_SAP勉強/01_ワークロード構築/_resources/image-24.png)
    1. ElastiCacheのマネジメントコンソール上で「開始」を選択
    2. DBエンジンを選択
        1. Redis（オプションでクラスター構成も可能。今回は選ばない）
        2. Memcached
    3. 基本項目の設定
        1. デプロイオプションを選択（サーバレスorNot）
        2. クラスターモードの有無
        3. デプロイ先を選択（オンプレorAWS）
        4. クラスター設定（名前、DBエンジンver、ハードウェアスペック、レプリケーション数）
        5. デプロイ先ネットワーク（VPC、サブネット）
    4. 詳細項目を設定
        1. セキュリティ（データ暗号化、セキュリティグループの付与）
        2. バックアップ
        3. メンテナンス
        4. スローログ出力設定

②MySQL
Amazon RDSより、以下のようなMySQLインスタンスを作成する
![image.png](07_SAP勉強/01_ワークロード構築/_resources/image-21.png)

※インスタンス作成手順は割愛

③MySQLにデータレコードをinsertする。
あらかじめ用意したEC2インスタンスからMySQLにログインし、テーブルを作成し、サンプルレコードを10個ほどinsertする。
手順は割愛

以下、DBの中身

```
mysql> USE tutorial;
Database changed
mysql> CREATE TABLE planet (
    -> id INT UNSIGNED AUTO_INCREMENT,
    -> name VARCHAR(30),
    -> PRIMARY KEY(id));
Query OK, 0 rows affected (0.057 sec)
mysql> INSERT INTO planet (name) VALUES ("Mercury");
Query OK, 1 row affected (0.008 sec)
mysql> INSERT INTO planet (name) VALUES ("Venus");
Query OK, 1 row affected (0.011 sec)
mysql> INSERT INTO planet (name) VALUES ("Earth");
Query OK, 1 row affected (0.009 sec)
mysql> INSERT INTO planet (name) VALUES ("Mars");
Query OK, 1 row affected (0.009 sec)
mysql> INSERT INTO planet (name) VALUES ("Jupiter");
Query OK, 1 row affected (0.008 sec)
mysql> INSERT INTO planet (name) VALUES ("Saturn");
Query OK, 1 row affected (0.010 sec)
mysql> INSERT INTO planet (name) VALUES ("Uranus");
Query OK, 1 row affected (0.009 sec)
mysql> INSERT INTO planet (name) VALUES ("Neptune");
Query OK, 1 row affected (0.009 sec)
```

④キャッシュ利用
EC2インスタンス上で以下pythonコードを実装し、実行する。

```
def fetch(sql):
  result = cache.get(sql)
  if result:
    return deserialize(result)
  else:
    result = db.query(sql)
    cache.setex(sql, ttl, serialize(result))
    return result

print(fetch("SELECT * FROM planet"))
```

3-20
3-72
4-71
5-56

![re-introduction-2022-elasticache-2-640x360.png](re-introduction-2022-elasticache)

![image031.2c611a204ad53487bff21174f11c60a5b5e6a53f.png](image031.2c611a204ad53487bff2117)

![image067.6fed7fefc335947f9befa1898a010ce6afb0b08f.png](image067.6fed7fefc335947f9befa18)

![image.png](07_SAP勉強/01_ワークロード構築/_resources/image-22.png)
![amazon-elasticache-redis-param-003-1.png](amazon-elasticache-redis-param-0)