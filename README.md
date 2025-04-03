# Godot Swift XR

An example XR project built in Godot, leveraging Swift for application logic and deployable to Meta Quest devices.

## Setup

In addition to installing a Swift SDK capable of cross-compiling to Android, a few additional steps are required to complete the project setup.

### Plugins

Install the following plugins from AssetLib:

- Godot XR Tools
- Godot OpenXR Vendors
- ProtonScatter

### Libraries

Compile the Swift project and copy the necessary libraries to `swift/bin`, depending on the target platform.

**Android** (to run the project on a device):

- libGodotVrTest.so, libSwiftGodot.so
  - Located in `./swift/.build/aarch64-unknown-linux-android24/debug/`
- .so libs from Swift OSS toolchain
  - Located in `/path-to-swift-toolchain/swift-6.0.3-RELEASE-android-24-0.1.artifactbundle/swift-6.0.3-release-android-24-sdk/android-27c-sysroot/usr/lib/aarch64-linux-android/`

**macO** (to see changes in the editor):

- libGodotVrTest.dylib, libSwiftGodot.dylib
  - Located in `./swift/.build/arm64-apple-macosx/debug/libGodotVrTest.so`
