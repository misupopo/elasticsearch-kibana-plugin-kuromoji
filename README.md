# elasticsearch-kibana-plugin-kuromoji

## Kibanaの日本語化
デフォルトの設定ではKibanaのUIは英語表記のため、少しとっつきにくいと思います。
kibanaを日本語化するためにはdocker-elk/kibana/config/kibana.ymlの末尾に
i18n.locale: ja-JPを追記します
```
---
## Default Kibana configuration from Kibana base image.
## https://github.com/elastic/kibana/blob/master/src/dev/build/tasks/os_packages/docker_generator/templates/kibana_yml.template.ts
#
server.name: kibana
server.host: 0.0.0.0
elasticsearch.hosts: [ "http://elasticsearch:9200" ]
monitoring.ui.container.elasticsearch.enabled: true

## X-Pack security credentials
#
elasticsearch.username: kibana_system
elasticsearch.password: ${KIBANA_SYSTEM_PASSWORD}
i18n.locale: ja-JP
```

## Elastic Searchの日本語解析用プラグインの導入
Elastic Searchで日本語データの全文検索を可能にするためにプラグインを導入します。
docker-elk/elasticsearch/Dockerfileを次のように修正します。
```
ARG ELASTIC_VERSION

# https://www.docker.elastic.co/
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}

# Add your elasticsearch plugins setup here
RUN elasticsearch-plugin install analysis-icu
RUN elasticsearch-plugin install analysis-kuromoji
```

## コンテナの起動
```
cd docker-elk
docker-compose up
```

## 初期のログイン情報
```
ユーザネーム：elastic
パスワード：changeme
```

## Kibana server is not ready yet というエラーが出たら
docker の sysytem volume の容量がいっぱいだったりするのでエラーログを確認すること。

```
docker system prune --volumes // これで local volumes を削除
```

## 下記のエラーが出たら
これは、違うバージョンの kibana で docker-compose up したりすると、
elasticsearch に index されている、version 情報が食い違っているために起こる。
```
docker-elk-kibana-1  |  FATAL  Error: Unable to complete saved object migrations for the [.kibana_task_manager] index: The .kibana_task_manager alias is pointing to a newer version of Kibana: v8.10.2
```
下記のシェルで index 情報を消す
```
bash allRemoveIndex.sh
```
