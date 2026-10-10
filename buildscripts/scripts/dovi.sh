#!/bin/bash -e

. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf dolby_vision/target
	exit 0
else
	exit 255
fi

# Rust's names for the NDK targets
case "$ndk_triple" in
	arm-linux-androideabi) target=armv7-linux-androideabi ;;
	*) target=$ndk_triple ;;
esac
rustup target add $target

linker=$(command -v $CC)
target_var=$(echo $target | tr 'a-z-' 'A-Z_')
export CARGO_TARGET_${target_var}_LINKER="$linker"
export CC_${target//-/_}="$linker" AR_${target//-/_}=llvm-ar

# The C API as libdovi.so, as cargo-c would name it, without needing cargo-c.
cd dolby_vision
cargo rustc --release --locked --features capi --target $target --crate-type cdylib -- \
	-C panic=abort -C link-arg=-Wl,-soname,libdovi.so -C link-arg=-Wl,-z,max-page-size=16384
install -D target/$target/release/libdolby_vision.so "$prefix_dir/lib/libdovi.so"
