# BBC BASIC for Feersum MicroBeast

This is a z80 BBC BASIC v5.00 port to the [Feersum Technologies MicroBeast](https://feersumbeasts.com/microbeast.html) and [NanoBeast](https://feersumbeasts.com/nanobeast.html).

It is a builder project wrapped around Richard T Russell's [BBC BASIC original repo](https://github.com/rtrussell/BBCZ80)

The webpage/manual for BBC BASIC is [here](https://www.bbcbasic.co.uk/bbcbasic/mancpm/bbc1.html)

Things I have added in the build wrapper:

1. a `DIST.Z80` specific to MicroBeast/NanoBeast to enable timer and terminal functions
2. an easy way to build it in a linux environment

The build wrapper is *MOSTLY* all the stuff you get from a standard  [BBCZ80V5.zip](https://www.bbcbasic.co.uk/bbcbasic/BBCZ80V5.zip) from Russell's website.

On top of this we overlay Russell's source repo, our modified `DIST.Z80`,
a copy of RunCPM for linux, and  our own `build.sh` script.

# Build it 

First, init the submodule:

```
git submodule init 
git submodule update
```

Then run the build script:

```
./build.sh
```


This will build a new version of the executable in the `build` directory.

More details in [BUILD.md](BUILD.md).

