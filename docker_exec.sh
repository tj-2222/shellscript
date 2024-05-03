#!/usr/bin/bash

# 選択関数
function selector() {
  local menu=("$@") # 配列として引数を受け取る
  select item in "${menu[@]}"; do
    if [ -n "${item}" ]; then
      echo "${item}" # 選択された項目を出力
      return
    else
      echo "Invalid selection. Please try again."
      return 1
    fi
  done
}

# Dockerが利用可能かチェック
if ! type docker &>/dev/null; then
  echo "Docker is not installed. Exiting."
  exit 1
fi

# コンテナを選択
PS3="Which container? > "
mapfile -t containers < <(docker ps --format "{{.Names}}")
if [ ${#containers[@]} -eq 0 ]; then
  echo "No running containers found."
  exit 1
fi
container=$(selector "${containers[@]}")
if [ $? -ne 0 ]; then exit 1; fi

# 改行
echo ""

# コマンドを選択
PS3="Which command? > "
commands=('bash' 'sh')
command=$(selector "${commands[@]}")
if [ $? -ne 0 ]; then exit 1; fi

echo -e "Executing... 'docker exec -it ${container} ${command}'\n"

docker exec -it "${container}" "${command}"
