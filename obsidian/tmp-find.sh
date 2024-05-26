#!/bin/bash

# 対象ディレクトリを指定
TARGET_DIR="./test/unit/testcase"

# 対象ディレクトリからファイルを検索し、その内容を表示
find "$TARGET_DIR" -type f -print | while read file; do
    echo "Contents of $file:"
    #cat "$file"
    cat $file | grep -E '!\[\[.+?\]\]'

    echo "----------------------------------------"

done

echo ""

find "$TARGET_DIR" -type f -print | while read file; do
    echo "Contents of $file:"
    #cat "$file"
    cat $file | grep -E '!\[.+?\]\(.+?\)'

    echo "----------------------------------------"

done
