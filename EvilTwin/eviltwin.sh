#!/bin/bash

wd="$WD/EvilTwin/"

$wd/killeviltwin.sh
$wd/scanForTwins.sh &
$wd/eviltwinAutoRemover.sh &

