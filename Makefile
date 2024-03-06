# SHELL := /bin/bash


# .PHONY: help
# help: ## Display this help.
# 	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

# .PHONY: catalog-crds-json-schema
# catalog-crds-json-schema: ## Convert catalog-crds to catalog-crds-json-schema
# 	@cd catalog-crds-scripts; \
# 	curl -sS https://raw.githubusercontent.com/yannh/kubeconform/master/scripts/openapi2jsonschema.py -o openapi2jsonschema.py; \
# 	bash gen_catalog_crds_json_schema.sh;

# .PHONY: test
# test: kubeconform unittest ## Launch all tests

# .PHONY: unittest
# unittest: ## Launch all unittest tests
# 	set -e; \
# 	for helm_dir in $$(ls -d helm-*); do \
# 		echo "- Testing $${helm_dir}"; \
# 		make -C $${helm_dir} unittest; \
# 	done

# .PHONY: kubeconform
# kubeconform: ## Launch all kubeconform tests
# 	set -e; \
# 	for helm_dir in $$(ls -d helm-*); do \
# 		echo "- Testing $${helm_dir}"; \
# 		make -C $${helm_dir} kubeconform; \
# 	done

# .PHONY: example
# example: ## Launch all examples helm execution as demonstration
# 	set -e; \
# 	for helm_dir in $$(ls -d helm-*); do \
# 		echo "- Testing $${helm_dir}"; \
# 		make -C $${helm_dir} example; \
# 	done

# .PHONY: ci-dep
# ci-dep: ## Install all ci dependencies
# 	@npm install -g @commitlint/cli @commitlint/config-conventional

# .PHONY: schemas-doc
# schemas-doc: ## Generate schema doc in markdown and html, prerequisite: https://github.com/coveooss/json-schema-for-humans
# 	@rm -r docs/schemas-html
# 	@mkdir -p docs/schemas-html
# 	@generate-schema-doc --config template_name=js --config with_footer=false --config link_to_reused_ref=true schemas docs/schemas-html
# 	@rm -r docs/schemas-md
# 	@mkdir -p docs/schemas-md
# 	@generate-schema-doc --config template_name=md --config show_breadcrumbs=false --config with_footer=false --config show_toc=false schemas docs/schemas-md

# .PHONY: schemas-server
# schemas-server:
# 	docker run -v ./schemas:/usr/share/nginx/html/schemas/v1 -p 8080:80 nginx 

# .PHONY: check-artifacts-uptodate
# check-artifacts-uptodate:
# 	@echo "- Generate catalog crds json schema"
# 	@make catalog-crds-json-schema 
# 	@if [[ ! -z $$(git status catalog-crds-json-schema -s) ]]; then \
# 		echo "Change detected ! Please run 'make catalog-crds-json-schema' and commit the changes"; \
# 		exit 1; \
# 	fi
# 	@echo "- Generate json schemas"
# 	@make schemas-doc
# 	@if [[ ! -z $$(git status docs -s) ]]; then \
# 		echo "Change detected ! Please run 'make schemas-doc' and commit the changes"; \
# 		exit 1; \
# 	fi
