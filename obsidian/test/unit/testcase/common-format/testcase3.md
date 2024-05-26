参考：

# サマリ

* * *

サマリ

# 概要

* * *

参考

- https://docs.aws.amazon.com/ja_jp/ram/latest/userguide/what-is.html
- https://dev.classmethod.jp/articles/reinvent-2018-ram/

アカウント間でリソースを共有アクセスするためのサービス。

共有タイプ（信頼関係の構築手続き）には以下2つがある。
1. アカウント間で個別に信頼関係を構築（認証リクエスト→承認の手続きが必要）
2. AWS Organizationsの管理アカウントで一括構築（アカウント毎の承認手続きが不要）
![image.png](07_SAP勉強/07_ワークロード運営/_resources/image-4.png)

### *共有可能なサービスリソース*

参考：

- https://docs.aws.amazon.com/ja_jp/ram/latest/userguide/shareable.html
- https://docs.aws.amazon.com/ja_jp/ram/latest/userguide/working-with-regional-vs-global.html

RAMで共有可能なサービスは以下2つ。

|                      |                                                           |
| -------------------- | --------------------------------------------------------- |
| **リソースタイプ**   | **概要**                                                  |
| リージョナルリソース | リージョン単位で存在する（VPCなどネットワークリソース系） |
| グローバルリソース   | AWSアカウントを通じて一度に1つのリソースしか存在できない  |

具体的には以下28種類のサービスの各リソースが対応している。
**コンフィグ的なリソースのみが共有対象なケースもあるので要確認。**
**例えばEC2インスタンスの場合、インスタンスそのものはゾーンレベルのため、RAMでの共有可能リソースに含まれない（RI's設定などは共有可能）**

**恐らくだが、細かいワークロードリソース単位の共有制御はIAMロールで行い、RAMはあくまでOrganizationsでマルチアカウント運用をスムーズに行う上で必要となるリソースのアカウント間共有を可能にしているというスタンスな気がする。**

*コンピューティングとインスタンスサービス*

- Amazon EC2
- EC2 Image Builder
- AWS Outposts
- Amazon S3 on Outposts

*データベースとデータストレージサービス*

- Amazon Aurora
- Amazon DataZone
- Amazon FSx for OpenZFS
- Amazon Simple Storage Service (Amazon S3)

*ネットワーキングとコンテンツ配信サービス*

- Amazon VPC
- Amazon VPC Lattice
- AWS クラウド WAN
- Amazon Route 53
- Amazon Route 53 Application Recovery Controller
- AWS Network Firewall
- AWS App Mesh

*開発者ツール*

- AWS CodeBuild
- AWS Service Catalog AppRegistry

*管理、ガバナンス、移行サービス*

- AWS Systems Manager Incident Manager
- AWS Systems Manager パラメータストア
- AWS License Manager
- AWS Resource Explorer
- AWS Resource Groups
- AWS Migration Hub Refactor Spaces

*その他*

- AWS Private Certificate Authority
- Amazon SageMaker
- AWS AppSync GraphQL API
- AWS Glue
- AWS Marketplace

# Old

* * *

参考：

    - https://aws.amazon.com/jp/ram/
    - https://docs.aws.amazon.com/ja_jp/ram/latest/userguide/what-is.html
    - https://dev.classmethod.jp/articles/reinvent-2018-ram/

複数のAWSアカウント間で特定のAWSリソースを共有する場合に、その管理が行えるサービス。
管理イメージ

![image.png](07_SAP勉強/07_ワークロード運営/_resources/image-4.png)

要するに、RAMを使うととあるAWSアカウント内に存在するAWSリソースについて、それにアクセス可能なAWSアカウントの対応関係を作成できる。
RAMでリソースに紐づけられるアカウントリソースはAWS Organizationsで定義されるもの（Organizationsそのもの、OU、MA）である。