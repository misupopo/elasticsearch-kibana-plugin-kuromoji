kibanaVersion := 8.9.2
pluginName := customKibanaTheme

# submodule を clone する
clone-submodule:
	git submodule update --init --recursive

install-plugin:
	docker exec -it docker-elk-kibana-1 bin/kibana-plugin install file:///usr/share/kibana/pluginBuild/$(pluginName)-$(kibanaVersion).zip

optimize-kibana:
	docker exec -it docker-elk-kibana-1 /usr/share/kibana/bin/kibana --optimize

delete-plugin:
	docker exec -it docker-elk-kibana-1 bin/kibana-plugin remove customKibanaTheme
	docker exec -it docker-elk-kibana-1 rm -fr plugins/*

# plugin の入れ直し
update-plugin:
	$(MAKE) delete-plugin
	$(MAKE) install-plugin
	$(MAKE) optimize-kibana
	$(MAKE) plugin-list

# plugin のリソースの更新
silent-update-plugin:
	cd docker-elk/pluginBuild && \
	rm -fr kibana && \
	unzip $(pluginName)-$(kibanaVersion).zip && \
	docker exec -it docker-elk-kibana-1 cp -r pluginBuild/kibana/customKibanaTheme plugins

plugin-list:
	docker exec -it docker-elk-kibana-1 bin/kibana-plugin list
