FONTS_DIR = fonts
BUILD_DIR = build

ifeq ($(OS),Windows_NT)
	MKDIR = if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	RMDIR = if exist $(BUILD_DIR) rmdir /s /q $(BUILD_DIR)
else
	MKDIR = mkdir -p $(BUILD_DIR)
	RMDIR = rm -rf $(BUILD_DIR)
endif

.PHONY: prepare clean help

all: help

prepare:
	@$(MKDIR)

watch-%: prepare
	@echo Watching $*.typ and outputting to $(BUILD_DIR)/$*.pdf...
	typst watch $*.typ $(BUILD_DIR)/$*.pdf --font-path $(FONTS_DIR)

compile-%: prepare
	@echo Compiling $*.typ to $(BUILD_DIR)/$*.pdf...
	typst compile $*.typ $(BUILD_DIR)/$*.pdf --font-path $(FONTS_DIR)

clean:
	@echo Cleaning up...
	@$(RMDIR)

help:
	@echo Game Engine Notes Build System
	@echo ------------------------------
	@echo Usage:
	@echo   make watch-[filename]   - e.g., make watch-Memory
	@echo   make compile-[filename] - e.g., make compile-Renderer
	@echo   make clean              - Remove build folder
