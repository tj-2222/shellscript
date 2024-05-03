#!/usr/bin/bash

# select container
PS3="Which container number? (Enter 'q' for exit.)> "
menu="$(docker ps | tail -n +2 | rev | cut -d" " -f1 | rev)"
item=""
select item in $menu; do
  # If enter 'q', exit this shell.
  if [ "${REPLY}" = "q" ]; then
    echo "exit."
    exit 0
  fi

  if [ -n "${item}" ]; then
    break
  else
    echo "invalid selection."
    echo "exit."
    exit 0
  fi
done

# select command

docker exec -it "${item}" sh
