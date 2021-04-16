#!/bin/bash
# commented for now as since pre-rel-v0.6.4-rc5 there seem to be no hangups anymore
if grep -q "Error sending invoice" /root/.local/share/ya-provider/ya-provider_rCURRENT.log
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
