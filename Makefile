PYTHON       = python3
PIP          = pip3
PYINSTALLER  = pyinstaller
SCRIPT       = main.py
APP_NAME     = Argon2_PasswordHasher
DIST_DIR     = dist
BUILD_DIR    = build
SPEC_FILE    = $(APP_NAME).spec

# Detect OS to select the correct separator (; for Windows, : for Unix)
ifeq ($(OS),Windows_NT)
    SEP = ;
    RM_CMD = if exist $(BUILD_DIR) rd /s /q $(BUILD_DIR) && if exist $(DIST_DIR) rd /s /q $(DIST_DIR) && if exist $(SPEC_FILE) del /f /q $(SPEC_FILE)
else
    SEP = :
    RM_CMD = rm -rf $(BUILD_DIR) $(DIST_DIR) $(SPEC_FILE)
endif

DATA_JSON    = --add-data "config.json$(SEP)."
DATA_CONFIG  = --add-data "GLOBAL_CONFIG.config$(SEP)."

.PHONY: all build clean setup-env

all: setup-env build

setup-env:
	$(PIP) install --upgrade pip
	$(PIP) install argon2-cffi pyinstaller

build:
	$(PYINSTALLER) --noconfirm --onefile --console \
		--name "$(APP_NAME)" \
		--collect-all argon2 \
		--collect-all _argon2_cffi_bindings \
		$(DATA_JSON) \
		$(DATA_CONFIG) \
		$(SCRIPT)

clean:
	$(RM_CMD)