#!/usr/bin/env bash
#
# Build BBC BASIC (Z80) from BBCZ80/src using the original CP/M toolchain
# (SLR Z80ASM + R.T.Russell's LINK + HEXBIN) running under RunCPM.
#
# This reproduces the vendor MAKE.SUB build exactly (verified bit-for-bit
# against the distributed BBCBASIC.COM).  Customise the build by editing
# BBCZ80/src/DIST.Z80 then re-running this script.
#
# Usage:
#   ./build.sh            # CP/M edition  -> build/BBCBASIC.COM
#   ./build.sh acorn      # Acorn Tube ed -> build/BBCTUBE.COM
#
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$PWD"

EDITION="${1:-cpm}"
case "$EDITION" in
  cpm)   SUBFILE="BBCZ80/bin/cpm/MAKE.SUB";   OUT="BBCBASIC.COM" ;;
  acorn) SUBFILE="BBCZ80/bin/acorn/MAKE.SUB"; OUT="BBCTUBE.COM"  ;;
  *) echo "usage: $0 [cpm|acorn]" >&2; exit 2 ;;
esac

RUNCPM="$ROOT/tools/RunCPM"
[ -x "$RUNCPM" ] || { echo "missing $RUNCPM (build it from MockbaTheBorg/RunCPM)"; exit 1; }

# Use the locally-maintained DIST.Z80 (kept in the root so it survives the
# BBCZ80 git submodule), overwriting the submodule's stock copy before staging.
if [ -f "$ROOT/DIST.Z80" ]; then
  cp "$ROOT/DIST.Z80" "$ROOT/BBCZ80/src/DIST.Z80"
  echo "==> using ./DIST.Z80 (overwriting BBCZ80/src/DIST.Z80)"
else
  echo "warning: ./DIST.Z80 not found; building with submodule's stock DIST.Z80" >&2
fi

# Fresh, isolated CP/M working tree:
#   A: = the toolchain disk (Z80ASM/LINK/HEXBIN/SUBMIT, shared, read via symlink)
#   B: = staging drive holding the sources + MAKE.SUB
BUILD="$ROOT/build"
rm -rf "$BUILD"
mkdir -p "$BUILD/B/0"
ln -s "$ROOT/A" "$BUILD/A"

# Stage sources + the chosen MAKE.SUB onto B:, converting LF -> CR/LF
# (the CP/M tools expect classic line endings).
for f in BBCZ80/src/*.Z80; do
  sed 's/$/\r/' "$f" > "$BUILD/B/0/$(basename "$f")"
done
# Append a final EXIT so RunCPM quits itself once the make completes
# (feeding EXIT over stdin races with SUBMIT's console handling).
{ sed 's/$/\r/' "$SUBFILE"; printf 'EXIT\r\n'; } > "$BUILD/B/0/MAKE.SUB"

# Run the build: switch to B:, SUBMIT the make file (which ends in EXIT).
( cd "$BUILD" && printf 'B:\r\nSUBMIT MAKE\r\n' | timeout 120 "$RUNCPM" ) || true

# HEXBIN writes <name>.COM; the MAKE.SUB's trailing REN is a CP/M-ism that
# leaves the artefact as .COM under RunCPM.  Collect it.
if [ -f "$BUILD/B/0/$OUT" ]; then
  cp "$BUILD/B/0/$OUT" "$BUILD/$OUT"
  echo
  echo "==> built $BUILD/$OUT ($(wc -c < "$BUILD/$OUT") bytes)"
else
  echo "BUILD FAILED: $OUT not produced (check assembler output above)" >&2
  exit 1
fi
