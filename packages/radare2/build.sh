#!/usr/bin/sh

cd ${SRC_DIR}

case "$HOST" in
    "arm-linux-androideabi")
        CPU="armv7l"
        FAMILY="arm"
        ;;
    "aarch64-linux-android")
        CPU="aarch64"
        FAMILY="aarch64"
        ;;
    "i686-linux-android")
        CPU="i686"
        FAMILY="i686"
        ;;
    "x86_64-linux-android")
        CPU="x86_64"
        FAMILY="x86_64"
        ;;
    *)
        echo "Unknown HOST: $HOST"
        exit 1
        ;;
esac

echo "Prefix: $PREFIX"
echo "CPU: $CPU"
echo "FAMILY: $FAMILY"

cat <<EOF > meson-android.ini
[binaries]
c       = '${ANDROID_HOME}/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-clang'
cpp     = '${ANDROID_HOME}/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-clang++'
ar      = '${ANDROID_HOME}/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-ar'
as      = '${ANDROID_HOME}/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-as'
ranlib  = '${ANDROID_HOME}/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-ranlib'
ld      = '${ANDROID_HOME}/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-ld'
strip   = '${ANDROID_HOME}/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-strip'
pkgconfig = 'false'

[properties]
sys_root = '${ANDROID_HOME}/ndk/22.1.7171670/sysroot'

[host_machine]
system = 'android'
cpu_family = '${FAMILY}'
cpu = '${CPU}'
endian = 'little'
EOF

meson --prefix=${PREFIX} build --cross-file ./meson-android.ini

ninja -C build
ninja -C build install
