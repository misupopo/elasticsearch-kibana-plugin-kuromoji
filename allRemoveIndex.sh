#!/bin/sh

# ElasticsearchのベースURL
ELASTICSEARCH_URL="http://localhost:9200"

# Elasticsearchからインデックス情報を取得し、JSONをパース
INDEX_INFO=$(curl -s "${ELASTICSEARCH_URL}/_cat/shards" -H "Accept: application/json")
INDEX_NAMES=($(echo "$INDEX_INFO" | jq -r '.[].index'))

echo "$INDEX_INFO"

# ループで各インデックスを削除
for index_name in "${INDEX_NAMES[@]}"; do
  # index_nameが"kibana"で始まるかどうかを確認
  if [[ $index_name == kibana* ]]; then
    # インデックス名を使用してDELETEリクエストを送信
    curl -XDELETE "${ELASTICSEARCH_URL}/${index_name}"
    echo "Deleted index: ${index_name}"
  fi
done
