#!/bin/bash

# pecoで選択肢をフィルタリングして選択する関数
function selector_with_peco() {
  # 引数から入力リストを生成し、pecoで選択
  local input_list=("$@")
  printf "%s\n" "${input_list[@]}" | peco
}

# pecoが利用可能かチェック
if ! type peco &>/dev/null; then
  echo "peco is not installed. Please install peco."
  exit 1
fi

# Dockerが利用可能かチェック
if ! type docker &>/dev/null; then
  echo "Docker is not installed. Please install Docker."
  exit 1
fi

# 稼働中のDockerコンテナを選択
containers=$(docker ps --format "{{.Names}}")
if [ -z "$containers" ]; then
  echo "No running containers found. Exiting."
  exit 1
fi
container=$(selector_with_peco $containers)
if [ -z "$container" ]; then
  echo "No container selected. Exiting."
  exit 1
fi

# 実行するコマンドを選択
commands="bash sh"
command=$(selector_with_peco $commands)
if [ -z "$command" ]; then
  echo "No command selected. Exiting."
  exit 1
fi

echo -e "Executing... 'docker exec -it ${container} ${command}'\n"

docker exec -it "${container}" "${command}"
