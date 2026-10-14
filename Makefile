SHELL := /bin/bash

IMAGE := texlive/texlive:latest

MAIN := main.tex
BUILD_DIR := build
OUTPUT_DIR := dist

DOCKER_WORKDIR := /workspace

DOCKER_RUN := MSYS_NO_PATHCONV=1 docker run --rm \
	-e HOME=/tmp \
	--mount "type=bind,source=$(CURDIR),target=$(DOCKER_WORKDIR)" \
	-w $(DOCKER_WORKDIR) \
	$(IMAGE)

.PHONY: build clean shell

build:
	mkdir -p "$(BUILD_DIR)" "$(OUTPUT_DIR)"
	$(DOCKER_RUN) \
		latexmk \
		-lualatex \
		-synctex=1 \
		-interaction=nonstopmode \
		-halt-on-error \
		-outdir=$(BUILD_DIR) \
		$(MAIN)
	cp "$(BUILD_DIR)/$(basename $(notdir $(MAIN))).pdf" "$(OUTPUT_DIR)/"

clean:
	$(DOCKER_RUN) \
		latexmk \
		-C \
		-outdir=$(BUILD_DIR) \
		$(MAIN)

shell:
	$(DOCKER_RUN) bash