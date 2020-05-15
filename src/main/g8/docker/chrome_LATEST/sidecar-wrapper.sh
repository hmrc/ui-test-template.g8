#!/usr/bin/env bash

IFS=',' read -r -a PORT_MAPPINGS_ARRAY <<< \$PORT_MAPPINGS

for PORT_MAPPING in "\${PORT_MAPPINGS_ARRAY[@]}"; do
  IFS='>' read -r -a PORT <<< \$PORT_MAPPING
  echo "Mapping localhost:\${PORT[0]::-1} to \$TARGET_IP:\${PORT[1]}"
  echo "localhost \${PORT[0]::-1} \$TARGET_IP \${PORT[1]}" >> ~/rinetd.conf
done

rinetd --conf-file ~/rinetd.conf --foreground &

/opt/bin/entry_point.sh