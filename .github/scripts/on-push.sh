#!/bin/bash

set -e

if [ ! -z "$TRAVIS_BUILD_DIR" ]; then
	export GITHUB_WORKSPACE="$TRAVIS_BUILD_DIR"
	export GITHUB_REPOSITORY="$TRAVIS_REPO_SLUG"
elif [ -z "$GITHUB_WORKSPACE" ]; then
	export GITHUB_WORKSPACE="$PWD"
	export GITHUB_REPOSITORY="circuitcode/AsyncTCP"
fi

# PlatformIO Test
source ./.github/scripts/install-platformio.sh

echo "Installing AsyncTCP ..."
python -m platformio lib --storage-dir "$GITHUB_WORKSPACE" install

BOARD="esp32dev"
build_pio_sketches "$BOARD" "$GITHUB_WORKSPACE/examples"

if [[ "$OSTYPE" != "cygwin" ]] && [[ "$OSTYPE" != "msys" ]] && [[ "$OSTYPE" != "win32" ]]; then
	echo "Installing ESPAsyncWebServer ..."
	python -m platformio lib -g install https://github.com/circuitcode/ESPAsyncWebServer.git > /dev/null 2>&1
	git clone https://github.com/circuitcode/ESPAsyncWebServer "$HOME/ESPAsyncWebServer" > /dev/null 2>&1

	echo "Installing ArduinoJson ..."
	python -m platformio lib -g install https://github.com/bblanchon/ArduinoJson.git > /dev/null 2>&1

	build_pio_sketches "$BOARD" "$HOME/ESPAsyncWebServer/examples"
fi
