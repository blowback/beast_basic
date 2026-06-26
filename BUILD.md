# Building BBC BASIC (Z80)

The sources in `BBCZ80/src/*.Z80` are written for R.T.Russell's original CP/M
toolchain — they use SLR-style relocatable modules (`GLOBAL`, `ASEG`,
`/rmf`), so they're assembled and linked *inside CP/M*, not by a modern
cross-assembler. The build is the vendor `MAKE.SUB` driven by:

- **SLR Systems Z80ASM** (`A/0/Z80ASM.COM`) — assembles each module to `.REL`
- **R.T.Russell's LINK** (`A/0/LINK.COM`) — links the modules at fixed addresses
- **HEXBIN** (`A/0/HEXBIN.COM`) — converts the linked image to a binary

These live on the `A:` drive of the bundled **RunCPM** emulator. The Windows
`runcpm.exe` here is unusable on Linux, so `tools/RunCPM` is a native Linux
RunCPM build (from github.com/MockbaTheBorg/RunCPM, internal CCP) that uses the
same `A/` and `B/` drive folders.

## Build

```sh
./build.sh          # CP/M edition   -> build/BBCBASIC.COM
./build.sh acorn    # Acorn Tube ed. -> build/BBCTUBE.COM
```

Both outputs are verified bit-for-bit identical to the distributed binaries in
`BBCZ80/bin/`.

`build.sh` is self-contained: it stages `BBCZ80/src/*.Z80` + the relevant
`MAKE.SUB` onto a throwaway `build/` drive (converting to CR/LF), runs the
make under RunCPM, and copies out the result. It does **not** touch the runtime
`B/` drive.

## Customising for the MicroBeast

Edit `BBCZ80/src/DIST.Z80` — the hardware-abstraction module (jump table:
`CLS`, `PUTCSR`/`GETCSR`, timer via `TICKS`, `INKEY`, `COUT`, the editing-key
table at `ORG 1F0H`, etc.). It must stay within 256 bytes (`ORG 100H` ..
`1F0H`). Then re-run `./build.sh` and flash/copy the resulting
`build/BBCBASIC.COM`.

## Rebuilding the Linux RunCPM (if `tools/RunCPM` is missing)

```sh
git clone --depth 1 https://github.com/MockbaTheBorg/RunCPM
make -C RunCPM/RunCPM -f Makefile.posix CCP=INTERNAL
cp RunCPM/RunCPM/RunCPM tools/RunCPM
```
