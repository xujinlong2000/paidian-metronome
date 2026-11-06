#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/.tmp/build-macos"
APP_PATH="$PROJECT_ROOT/output/拍点.app"
ARCHIVE_PATH="$PROJECT_ROOT/output/Paidian-macOS-universal.zip"
mkdir -p "$BUILD_DIR/module-cache" "$PROJECT_ROOT/.tmp/clang-module-cache" "$APP_PATH/Contents/MacOS" "$APP_PATH/Contents/Resources/web"
# Preserve the system TMPDIR: Swift 6.3 can crash with a non-ASCII temp path.
export CLANG_MODULE_CACHE_PATH="$PROJECT_ROOT/.tmp/clang-module-cache"

# Both architectures use the system WebKit; no npm packages or network are needed.
for ARCH in arm64 x86_64; do
  /usr/bin/xcrun swiftc -O -target "$ARCH-apple-macosx13.0" \
    -module-cache-path "$BUILD_DIR/module-cache" \
    -framework Cocoa -framework WebKit \
    "$PROJECT_ROOT/native/main.swift" -o "$BUILD_DIR/Paidian-$ARCH"
done
/usr/bin/xcrun lipo -create "$BUILD_DIR/Paidian-arm64" "$BUILD_DIR/Paidian-x86_64" -output "$APP_PATH/Contents/MacOS/Paidian"
cp "$PROJECT_ROOT/native/Info.plist" "$APP_PATH/Contents/Info.plist"
cp "$PROJECT_ROOT/dist/index.html" "$APP_PATH/Contents/Resources/web/index.html"
/usr/bin/xcrun swift -module-cache-path "$BUILD_DIR/module-cache" "$PROJECT_ROOT/scripts/make-icon.swift" "$BUILD_DIR/AppIcon.iconset"
/usr/bin/iconutil --convert icns "$BUILD_DIR/AppIcon.iconset" --output "$APP_PATH/Contents/Resources/AppIcon.icns"
/usr/bin/plutil -lint "$APP_PATH/Contents/Info.plist"
/usr/bin/codesign --force --sign - --identifier com.xujinlong2000.paidian "$APP_PATH"
/usr/bin/codesign --verify --deep --strict "$APP_PATH"
/usr/bin/ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" "$ARCHIVE_PATH"
echo "已生成：$APP_PATH"
echo "安装包：$ARCHIVE_PATH"
