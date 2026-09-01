# Android FFmpeg Builder

🎬 Automated FFmpeg shared library and binary builder for Android. This script builds FFmpeg with full codec support and hardware acceleration for multiple Android architectures.

[![License](https://img.shields.io/badge/License-LGPL-blue.svg)](LICENSE)
[![FFmpeg Version](https://img.shields.io/badge/FFmpeg-9.0.1-green.svg)](https://ffmpeg.org/releases/ffmpeg-9.0.1.tar.bz2)
[![GitHub last commit](https://img.shields.io/github/last-commit/Ero-gamer/ffmpeg-android-binary?label=Last%20Update)](https://github.com/Ero-gamer/ffmpeg-android-binary/commits/main)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/Ero-gamer/ffmpeg-android-binary)](https://github.com/Ero-gamer/ffmpeg-android-binary/releases/latest)

## 🚀 Features

- FFmpeg 9.0.1 with full codec and format support
- Supported architectures:
  - arm64-v8a
  - armeabi-v7a
  - x86_64
- Hardware acceleration enabled
- MediaCodec support
- NEON optimization
- Network capabilities
- All encoders and decoders
- All muxers and demuxers
- All protocols enabled
- ffmpeg binaries included

## 📋 Prerequisites

### Required Tools

- Android NDK
- Build essentials (gcc, make)
- YASM/NASM assembler
- wget
- pkg-config

On Ubuntu/Debian:

```bash
sudo apt-get update && sudo apt-get install -y \
    build-essential \
    gcc \
    make \
    yasm \
    nasm \
    pkg-config \
    wget
```

On macOS:

```bash
brew install automake yasm nasm pkg-config wget
```

### Android NDK Setup

1. Download Android NDK from [Android's NDK page](https://developer.android.com/ndk/downloads)
2. Extract it to a location (default: `/opt/android-ndk`)
3. Update the `ANDROID_NDK_HOME` variable in the script if your NDK is installed elsewhere
4. Ensure NDK toolchain is accessible

## 🛠️ Usage

1. Clone the repository:

```bash
git clone https://github.com/Ero-gamer/android-ffmpeg-builder.git
cd android-ffmpeg-builder
```

2. Make the script executable:

```bash
chmod +x build_ffmpeg.sh
```

3. Run the script:

```bash
./build_ffmpeg.sh
```

## 📚 Output Structure

```
android/project_output/
├── arm64-v8a/
│   ├── bin/
│   │   ├── ffmpeg
│   └── lib/
│       ├── libavcodec.so
│       ├── libavdevice.so
│       ├── libavfilter.so
│       ├── libavformat.so
│       ├── libavutil.so
│       ├── libpostproc.so
│       ├── libswresample.so
│       └── libswscale.so
├── armeabi-v7a/
├── x86_64/
└── build_info.txt
```

## 🔧 Configurations

The script builds FFmpeg with these features:

- Shared libraries enabled
- Hardware acceleration
- MediaCodec support
- NEON optimization
- Network support
- All codecs and formats
- Debug symbols stripped
- Size-optimized binaries

## 📦 Releases & Pre-built Binaries

### Latest Release

[![Latest Release](https://img.shields.io/github/v/release/Ero-gamer/ffmpeg-android-binary)](https://github.com/Ero-gamer/ffmpeg-android-binary/releases/latest)

Pre-built binaries are available in the [Releases](https://github.com/Ero-gamer/ffmpeg-android-binary/releases) section. Each release includes:

- Built `.so` files for all supported architectures (arm64-v8a, armeabi-v7a, x86_64)
- ffmpeg binaries
- Build information and checksums
- Source code archive

## 🔄 Updating FFmpeg Version

1. Update the version in `build_ffmpeg.sh`:

```bash
# Change this line
FFMPEG_VERSION="9.0.1"
```

2. Download the new FFmpeg source:

```bash
wget https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2
```

3. Clean old build files:

```bash
rm -rf ffmpeg-*
rm -rf android/project_output/*
```

4. Run the build script:

```bah
./build_ffmpeg.sh
```

## 📜 License

This project is licensed under the GNU Lesser General Public Version 3 License - see the [LICENSE](./LICENSE) file for details.
