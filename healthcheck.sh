#!/bin/bash
if grep -q ERROR ~/.local/share/yagna/yagna_rCURRENT.log; then exit 1; else exit 0; fi
golemsp status || exit 1
