#!/bin/bash
xxd -c 1 mario.gb  > f1.txt
xxd -c 1 baserom.gb  > f2.txt
vimdiff f1.txt f2.txt

