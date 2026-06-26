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

# Why should I use this over stock BBCBASIC.COM ?

The stock BBCBASIC.COM works very well on MicroBeast, with a couple of exceptions:

 - `TIME`, and `INKEY` or `INKEY$` with a timeout value don't work
 - `CLS` and `TAB(x,y)` don't work

 This port provides the shims to make those functions work.

**N.B.**: `VDU12`, `VDU30`, and `VDU31,a,b` still won't work! AFAICT, there is no clean way 
to patch them in.

# Did you change the editing keys?

I mean, I tried. But BeastOS messes about with the cursor keys, CP/M messes about 
with them too, VT52 terminals send `ESC` prefixed sequences for cursor keys, and BBC 
BASIC is adamant that `ESC` means `Escape` (as in "break out of program"). There is 
no portable way to achieve any sort of sane layout, so I've left it in the defaults,
which are:

|Key|Action|
|---|------|
|Ctrl-G| cursor UP (move left)|
|Ctrl-O| cursor DOWN (move right)|
|Ctrl-F| start of line|
|Ctrl-N| end of line|
|Ctrl-X| delete to end of line|
|Ctrl-H| BACKSPACE (delete left)|
|Ctrl-U| delete to start of line|
|Ctrl-J| cursor left|
|Ctrl-L| cursor right|
|Ctrl-R| delete right|
|Ctrl-Q| insert/overwrite toggle|

I know, I know. Why do up & left do the same thing? and down / right? Near as I can 
tell, they are redundant in this *line based* editor, but are holdovers from the original
BBC Micro's rather splendid full-screen copy edit malarky (which incidentally also exists 
on RISCiX!) Sadly that method doesn't exist in other versions...I wonder if Acorn patented it?


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

# Can I just get a prebuilt binary?

Sure: click "Releases" over on the right, then "latest release" then "assets" 
and download the BBCBASIC.COM executable.

