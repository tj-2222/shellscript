#!/usr/bin/bash

function selector() {
  menu=$1
  select item in $menu; do
    if [ -n "${item}" ]; then
      break
    else
      echo "invalid selection."
      echo "exit."
      exit 0
    fi
  done
}

# コンテナ選択
PS3="Which container? > "
menu="$(docker ps | tail -n +2 | rev | cut -d" " -f1 | rev)"
item=""
selector "$menu"
container=$item

# 改行
echo ""

# 起動コマンド選択
PS3="Which command? > "
menu='bash sh'
item=""
selector "$menu"
command=$item

echo -e "Executing... 'docker exec -it ${container} ${command}'\n"

docker exec -it "${container}" "${command}"
