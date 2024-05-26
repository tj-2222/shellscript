#!/bin/bash

# 一時ファイル作成
tmpfile=$(mktemp)

# 生成した一時ファイルを削除する
function rm_tmpfile {
  [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
}
# 正常終了したとき
trap rm_tmpfile EXIT
# 異常終了したとき
trap 'trap - EXIT; rm_tmpfile; exit -1' INT PIPE TERM

# obsidianドキュメントに埋め込まれたimageタグを整理する

tree >"$tmpfile"

cat "$tmpfile" | grep -v "directories,\|files" | awk '
  NR>1{
    print $NF;
  }
' | grep -v '^$' # 空行はじく
