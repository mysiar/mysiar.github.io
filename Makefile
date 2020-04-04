SHELL := /bin/bash

serve:
	bundle exec jekyll serve --watch --verbose
.PHONY: serve

build:
	bundle exec jekyll build
.PHONY: build


