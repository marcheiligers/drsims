#!/bin/sh

DRB_ROOT=~/Temp/dragonruby-macos

OSTYPE=`uname -s`
if [ "x$OSTYPE" = "xDarwin" ]; then
  PLATFORM=macos
  DLLEXT=dylib
else
  PLATFORM=linux-amd64
  DLLEXT=so
fi

crystal build ext/verlet.cr --link-flags "-dynamiclib" -o ext/verlet.$DLLEXT

mkdir -p native/$PLATFORM

$DRB_ROOT/dragonruby-bind --output=native/ext-bindings.c ext/verlet.h
clang \
  -isystem $DRB_ROOT/include -isystem $DRB_ROOT -I. \
  -fPIC -shared native/ext-bindings.c ext/verlet.$DLLEXT -o native/$PLATFORM/ext.$DLLEXT

