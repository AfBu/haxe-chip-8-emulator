haxe-chip-8-emulator
====================

CHIP 8 Emulator written in HAXE/OpenFL

Windows binary download: http://bit.ly/chip8emu

Current state of development:
- all chip-8 opcodes implemented
- basic debug information
- running speed is 1000 steps per second
- keyboard mapped to 1234/qwer/asdf/zxcv keys
- loaded rom is defined in main.hx
- no problems were detected running wide variety of roms so far
- plenty of public domain roms included
- compiles only for NEKO/CPP
- basic GUI for loading roms
- original fontset as separate data file, ability to load custom fontset/bios
- beep using wave sound file

Future plans:
- more advanced GUI
- other targets support (Android/HTML5/Flash)

Information sources and inspiration:
- http://www.multigesture.net/articles/how-to-write-an-emulator-chip-8-interpreter/
- http://devernay.free.fr/hacks/chip8/C8TECH10.HTM
