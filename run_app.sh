#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/tindi-plus/novapay"
TARGET_DIR="novapay"
FLUTTER_VERSION="3.47.4"

echo "=========================================="
echo " 1. Checking & Installing FVM"
echo "=========================================="

if ! command -v fvm >/dev/null 2>&1; then
    echo "FVM not found in PATH. Activating FVM via pub..."

    if command -v dart >/dev/null 2>&1; then
        dart pub global activate fvm
    elif command -v flutter >/dev/null 2>&1; then
        flutter pub global activate fvm
    else
        echo "Error: Neither Dart nor Flutter CLI is installed."
        echo "Please install Flutter/Dart or install FVM via Homebrew:"
        echo "  brew install fvm"
        exit 1
    fi

    export PATH="$PATH:$HOME/.pub-cache/bin"
fi

echo "FVM is ready."

echo "=========================================="
echo " 2. Installing Flutter $FLUTTER_VERSION via FVM"
echo "=========================================="

if ! fvm list | grep -q "$FLUTTER_VERSION"; then
    fvm install "$FLUTTER_VERSION"
fi

echo "=========================================="
echo " 3. Preparing Repository Directory"
echo "=========================================="

CURRENT_DIR_NAME=$(basename "$PWD")

if [ "$CURRENT_DIR_NAME" = "$TARGET_DIR" ]; then
    echo "Already inside '$TARGET_DIR' directory. Skipping clone step."
elif [ -d "$TARGET_DIR" ]; then
    echo "Directory '$TARGET_DIR' found in current path. Navigating into it..."
    cd "$TARGET_DIR"
else
    echo "Cloning $REPO_URL into $TARGET_DIR..."
    git clone "$REPO_URL" "$TARGET_DIR"
    cd "$TARGET_DIR"
fi

echo "=========================================="
echo " 4. Pinning Flutter Version with FVM"
echo "=========================================="

fvm use "$FLUTTER_VERSION"

echo "=========================================="
echo " 5. Checking Android Emulator Status"
echo "=========================================="

if ! command -v adb >/dev/null 2>&1; then
    echo "Error: 'adb' tool not found in your PATH."
    echo "Please ensure Android SDK Platform Tools are installed and added to PATH."
    exit 1
fi

# Look for an actively connected Android emulator
RUNNING_EMULATOR=$(
    adb devices |
    awk '$1 ~ /^emulator-[0-9]+$/ && $2 == "device" {print $1}' |
    head -n 1
)

if [ -z "$RUNNING_EMULATOR" ]; then
    echo "No active Android emulator detected."

    if ! command -v emulator >/dev/null 2>&1; then
        echo "Error: 'emulator' CLI not found in PATH."
        echo "Ensure \$ANDROID_HOME/emulator is in your PATH."
        exit 1
    fi

    # Get the first available AVD
    AVD_NAME=$(emulator -list-avds | head -n 1)

    if [ -z "$AVD_NAME" ]; then
        echo "Error: No Android Virtual Devices (AVDs) found."
        echo "Please open Android Studio and create an AVD first."
        exit 1
    fi

    echo "Starting emulator: $AVD_NAME..."

    nohup emulator -avd "$AVD_NAME" >/dev/null 2>&1 &

    echo "Waiting for emulator to connect..."

    adb wait-for-device

    echo "Waiting for Android to finish booting..."

    until [ "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
        sleep 2
    done

    # Get the emulator ID AFTER it has started
    RUNNING_EMULATOR=$(
        adb devices |
        awk '$1 ~ /^emulator-[0-9]+$/ && $2 == "device" {print $1}' |
        head -n 1
    )

    if [ -z "$RUNNING_EMULATOR" ]; then
        echo "Error: Emulator started but could not be detected by adb."
        exit 1
    fi

    echo "Emulator is fully booted: $RUNNING_EMULATOR"

else
    echo "Detected running emulator: $RUNNING_EMULATOR"
fi

echo "=========================================="
echo " 6. Fetching Dependencies & Launching App"
echo "=========================================="

fvm flutter pub get

echo "Launching Flutter app on Android emulator: $RUNNING_EMULATOR"

fvm flutter run -d "$RUNNING_EMULATOR"