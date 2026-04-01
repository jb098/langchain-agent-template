# The aim of this makefile is to make the setup and installation \
and of an agent template within a virtual environment as simple as possible. \

.ONESHELL:
VENV_NAME := agent_venv
VENV_DIR := ~/.virtualenvs
VENV_BIN_DIR := ${VENV_DIR}/${VENV_NAME}/bin
PIP := ${VENV_DIR}/${VENV_NAME}/bin/pip
PYTHON := ${VENV_DIR}/${VENV_NAME}/bin/python
BASH_PROFILE = ~/.bash_profile
ZSHRC_FILE = ~/.zshrc

# Detect the Operating System
UNAME_S := $(shell uname -s)
UNAME_R := $(shell uname -r)

# Define OS-specific variables
ifeq ($(UNAME_S),Darwin)
	# macOS Specific
	INSTALL_CMD = brew install
	UNINSTALL_CMD = brew uninstall
	PLATFORM = MacOS
	PYTHON_VERSION = @3.13
	WHICH_VERSION = /usr/bin/which
else
	# Check if this is Linux under WSL
	ifneq ($(filter %microsoft%,$(shell echo $(UNAME_R) | tr '[:upper:]' '[:lower:]')),)
		INSTALL_CMD = sudo apt-get install -y
		UNINSTALL_CMD = sudo apt-get remove -y
		PLATFORM = WSL
		PYTHON_VERSION=3.13
		WHICH_VERSION=which
	else
		INSTALL_CMD = sudo apt-get install -y
		UNINSTALL_CMD = sudo apt-get remove -y
		PLATFORM = Linux (Native)
		PYTHON_VERSION=3.13
		WHICH_VERSION=which
	endif
endif

define create-venv
	python3.13 -m venv ${VENV_DIR}/${VENV_NAME}
endef

install:

	@echo Installing Python3.13...
	@${INSTALL_CMD} python$(PYTHON_VERSION)

	@echo Creating python virtual environment and installing mite packages...
	@mkdir -p $(VENV_DIR)
	@${create-venv}

	@echo Upgrading pip...
	@${PIP} install --upgrade pip

	@echo Installing python libraries...
	@${PIP} install -r requirements.txt

	@if ! [ $(${WHICH_VERSION} -s ollama) ]; then \
		echo "Ollama is already installed. Skipping installation."; \
	else \
		echo Install Ollama local llm manager...; \
		curl -fsSL https://ollama.com/install.sh | sh; \
	fi

	@echo Pulling lightweight qwen3.52b llm...
	@ollama pull qwen3.5:2b

	@echo "\n****** Done installing ******"
	@echo "To get started run:\n\033[0;92m. ${VENV_BIN_DIR}/activate\033[0m"

	@if ! grep -q "source ${BASH_PROFILE}" ${ZSHRC_FILE}; then \
		echo "\n\nsource ${BASH_PROFILE}" >> ${ZSHRC_FILE}; \
		echo Added 'source ${BASH_PROFILE}' in ${ZSHRC_FILE}; \
	else \
		echo 'source ${BASH_PROFILE}' already in ${ZSHRC_FILE}; \
	fi

uninstall:
	@echo "Removing ${VENV_NAME} from ${VENV_DIR}..."
	@rm -rf ${VENV_DIR}/${VENV_NAME}

	@echo Removing qwen3.5:2b...
	@ollama rm qwen3.5:2b
		
	@echo Removing ollama...
	@${UNINSTALL_CMD} ollama

