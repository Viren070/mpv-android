# mpv-android-lib

[![Build Status](https://github.com/Viren070/mpv-android/actions/workflows/build.yml/badge.svg?branch=library)](https://github.com/Viren070/mpv-android/actions/workflows/build.yml)

A library version of [mpv-android](https://github.com/mpv-android/mpv-android), providing [libmpv](https://github.com/mpv-player/mpv) for Android applications.
Initially made for [mpvKt](https://github.com/abdallahmehiz/mpvKt).

This fork is the build [AIOStreams](https://github.com/Viren070/AIOStreams)' Android app ships. Every source is pinned to a commit in [depinfo.sh](buildscripts/include/depinfo.sh), and each push to `library` publishes the AAR for arm64-v8a, armeabi-v7a and x86_64 as a release, with its SHA-256.

## "New" Features

* **Multiple MPV instances**
* **`mpv_node` support**
* **DASH support** 

## Installation

Download the AAR from [Releases](https://github.com/Viren070/mpv-android/releases) and check it against the SHA-256 in the release notes. It needs `androidx.core` and `kotlinx-coroutines-android` beside it.

## Getting Started

### Using BaseMPVView

The simplest way to extend `BaseMPVView`:

```kotlin
class MyPlayerView(context: Context, attrs: AttributeSet?) : BaseMPVView(context, attrs) {

    override fun initOptions() {
        // Set options before mpv.init() is called
        mpv.setOptionString("hwdec", "auto")
    }

    override fun postInitOptions() {
        // Set options after mpv.init() is called
        mpv.setOptionString("sub-auto", "fuzzy")
    }
}

val playerView = MyPlayerView(context, null)
playerView.initialize(configDir = filesDir.path, cacheDir = cacheDir.path)
playerView.playFile("/path/to/video.mp4")
```

### Using MPV() Directly

You can also use `MPV()` then attach to fully control your mpv instance.

```kotlin
val mpv = MPV()

mpv.create(context)
mpv.setOptionString("config", "yes")
mpv.init()

// Attach to a view surface
mpv.attachSurface(surface)

// Load and play a file
mpv.command("loadfile", "/path/to/video.mp4")

// Access props
val paused: Boolean? = mpv.prop["pause"]
mpv.prop["pause"] = false

// access and set nodes
val node: MPVNode? = mpv.getPropertyNode("track-list")
mpv.setPropertyNode("chapter-list", myCustomChaptersList)

// observe as kotlin flows
val pauseState: StateFlow<Boolean?> = mpv.propFlow["pause"]

// cleanup
mpv.detachSurface()
mpv.destroy()
```

### Multiple Instances

Each `MPV()` or `BaseMPVView` instance is independent:

```kotlin
val player1 = MPV()
val player2 = MPV()

player1.create(context)
player2.create(context)

// Each player can play different content simultaneously
```

## Building from source

Take a look at the [README](buildscripts/README.md) inside the `buildscripts` directory.

Some other documentation can be found at this [link](http://mpv-android.github.io/mpv-android/).
