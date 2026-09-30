IMAGE := texlive/texlive:latest

MAIN := main.tex
BUILD_DIR := build
OUTPUT_DIR := dist

DOCKER_WORKDIR := /workspace

DOCKER_RUN := docker run --rm \
	-e HOME=/tmp \
	-v "$(CURDIR):$(DOCKER_WORKDIR)" \
	-w $(DOCKER_WORKDIR) \
	$(IMAGE)

.PHONY: build clean shell

build:
	if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	if not exist $(OUTPUT_DIR) mkdir $(OUTPUT_DIR)
	$(DOCKER_RUN) \
		latexmk \
		-lualatex \
		-synctex=1 \
		-interaction=nonstopmode \
		-halt-on-error \
		-outdir=$(BUILD_DIR) \
		$(MAIN)
	copy $(BUILD_DIR)\main.pdf $(OUTPUT_DIR)\main.pdf

clean:
	$(DOCKER_RUN) \
		latexmk \
		-C \
		-outdir=$(BUILD_DIR) \
		$(MAIN)

shell:
	$(DOCKER_RUN) bash