# 目次

- [目次](#目次)
- [概要](#概要)
- [詳細](#詳細)
  - [検証1：正規表現はちゃんとparse出来るのか](#検証1正規表現はちゃんとparse出来るのか)


# 概要

実行結果の証跡

# 詳細

## 検証1：正規表現はちゃんとparse出来るのか

用意したtestcaseでは問題なくparse出来ている。

```bash
# 一般的なmarkdown image埋め込みパターン
$  cat testcase1.md | grep -E '!\[.+?\]\(.+?\)' | grep -n ""
1:![image.png](07_SAP勉強/01_ワークロード構築/_resources/image-23.png)
2:![tmp45.drawio.png](tmp45.drawio.png)
3:![image.png](07_SAP勉強/01_ワークロード構築/_resources/image-24.png)
4:![image.png](07_SAP勉強/01_ワークロード構築/_resources/image-21.png)
5:![re-introduction-2022-elasticache-2-640x360.png](re-introduction-2022-elasticache)
6:![image031.2c611a204ad53487bff21174f11c60a5b5e6a53f.png](image031.2c611a204ad53487bff2117)
7:![image067.6fed7fefc335947f9befa1898a010ce6afb0b08f.png](image067.6fed7fefc335947f9befa18)
8:![image.png](07_SAP勉強/01_ワークロード構築/_resources/image-22.png)
9:![amazon-elasticache-redis-param-003-1.png](amazon-elasticache-redis-param-0)
Ubuntu-22.04 raki@DESKTOP-C56454C ~/workspace/03_obsidian-tools/test/unit/testcase/common-format 
$  cat testcase2.md | grep -E '!\[.+?\]\(.+?\)' | grep -n ""
1:![image.png](07_SAP勉強/07_ワークロード運営/_resources/image-4.png)
2:![image.png](07_SAP勉強/07_ワークロード運営/_resources/image-4.png)
Ubuntu-22.04 raki@DESKTOP-C56454C ~/workspace/03_obsidian-tools/test/unit/testcase/common-format 
$  cd ../obsidian-format/
Ubuntu-22.04 raki@DESKTOP-C56454C ~/workspace/03_obsidian-tools/test/unit/testcase/obsidian-format 

# obsidian形式
$  cat testcase1.md | grep -E '!\[\[.+?\]\]'
![[請求書作成-20240509000539490.webp|#left|331]]
![[請求書作成-20240509020601097.webp|#left|536]]
Ubuntu-22.04 raki@DESKTOP-C56454C ~/workspace/03_obsidian-tools/test/unit/testcase/obsidian-format 
$  cat testcase1.md | grep -E '!\[\[.+?\]\]' -n
34:![[請求書作成-20240509000539490.webp|#left|331]]
65:![[請求書作成-20240509020601097.webp|#left|536]]
Ubuntu-22.04 raki@DESKTOP-C56454C ~/workspace/03_obsidian-tools/test/unit/testcase/obsidian-format 
$  cat testcase3.md | grep -E '!\[\[.+?\]\]' -n
7:![[Pasted image 20240503172938.png]]
Ubuntu-22.04 raki@DESKTOP-C56454C ~/workspace/03_obsidian-tools/test/unit/testcase/obsidian-format 
$  
```