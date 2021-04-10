#!/bin/bash
if grep -q ERROR root/.local/share/yagna/yagna_rCURRENT.log
    then
        echo ERROR found!; exit 1
    else
        echo No error found in logs
fi
if golemsp status
    then
        echo golemsp is OK
    else
        echo golemsp failed
        exit 1
fi
