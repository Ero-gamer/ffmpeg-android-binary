#!/bin/bash
set -e

# Default NDK path fallback if not set by environment
ANDROID_NDK_HOME="${ANDROID_NDK_HOME:-/opt/android-ndk}"
FFMPEG_VERSION="9.0.1"
WORK_DIR=$(pwd)

echo "Working directory: $WORK_DIR"
echo "FFmpeg version: $FFMPEG_VERSION"

# Download FFmpeg tarball if not present
if [ ! -f "ffmpeg-${FFMPEG_VERSION}.tar.bz2" ]; then
    echo "Downloading FFmpeg ${FFMPEG_VERSION}..."
    curl -sLO "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"
fi

# Clean old extract directory
if [ -d "ffmpeg-${FFMPEG_VERSION}" ]; then
    echo "Cleaning old FFmpeg build directory..."
    rm -rf "ffmpeg-${FFMPEG_VERSION}"
fi

echo "Extracting FFmpeg..."
tar xjf "ffmpeg-${FFMPEG_VERSION}.tar.bz2"

cd "ffmpeg-${FFMPEG_VERSION}"

# Verify NDK path & Host OS toolchain
HOST_TAG="linux-x86_64"
if [ "$(uname)" == "Darwin" ]; then
    HOST_TAG="darwin-x86_64"
fi

TOOLCHAIN="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$HOST_TAG"

if [ ! -d "$TOOLCHAIN" ]; then
    echo "Error: NDK Toolchain not found at $TOOLCHAIN"
    exit 1
fi

ABI="armeabi-v7a"
ANDROID_API=21
ARCH="arm"
CPU="armv7-a"

# Compiler toolchain paths for NDK r19+
CC="$TOOLCHAIN/bin/armv7a-linux-androideabi${ANDROID_API}-clang"
CXX="$TOOLCHAIN/bin/armv7a-linux-androideabi${ANDROID_API}-clang++"
CROSS_PREFIX="$TOOLCHAIN/bin/llvm-"

PREFIX="$WORK_DIR/android/$ABI"
mkdir -p "$PREFIX"

# Optimization flags targeting ARMv7-A NEON / VFPv4
OPTIMIZATION_CFLAGS="-O3 -ffast-math -ftree-vectorize -mfloat-abi=softfp -mfpu=neon-vfpv4 -march=armv7-a -fPIC"

echo "Configuring FFmpeg for $ABI..."
./configure \
    --prefix="$PREFIX" \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --cc="$CC" \
    --cxx="$CXX" \
    --cross-prefix="$CROSS_PREFIX" \
    --sysroot="$TOOLCHAIN/sysroot" \
    --enable-shared \
    --disable-static \
    --enable-pic \
    --enable-neon \
    --enable-asm \
    --enable-inline-asm \
    --enable-jni \
    --enable-mediacodec \
    --enable-hwaccels \
    --enable-gpl \
    --enable-version3 \
    --enable-nonfree \
    --enable-postproc \
    --enable-avdevice \
    --enable-swscale \
    --enable-swresample \
    --enable-avfilter \
    --enable-avformat \
    --enable-avcodec \
    --enable-avutil \
    --enable-protocols \
    --enable-encoders \
    --enable-decoders \
    --enable-demuxers \
    --enable-muxers \
    --enable-filters \
    --enable-bsfs \
    --enable-indevs \
    --enable-outdevs \
    --enable-network \
    --enable-ffmpeg \
    --disable-ffprobe \
    --disable-ffplay \
    --disable-small \
    --disable-debug \
    --disable-doc \
    --extra-cflags="$OPTIMIZATION_CFLAGS" \
    --extra-ldflags="-L$PREFIX/lib"

echo "Building FFmpeg for $ABI..."
make clean
make -j$(nproc)
make install

# Prepare artifact release directory
PROJECT_OUTPUT="$WORK_DIR/android/project_output/$ABI"
mkdir -p "$PROJECT_OUTPUT/lib" "$PROJECT_OUTPUT/bin"

echo "Copying individual shared (.so) libraries..."
cp -d "$PREFIX"/lib/*.so* "$PROJECT_OUTPUT/lib/"

echo "Copying ffmpeg executable binary..."
if [ -f "$PREFIX/bin/ffmpeg" ]; then
    cp "$PREFIX/bin/ffmpeg" "$PROJECT_OUTPUT/bin/"
    chmod +x "$PROJECT_OUTPUT/bin/ffmpeg"
fi

echo "Build process finished successfully! Output is located in $PROJECT_OUTPUT"
