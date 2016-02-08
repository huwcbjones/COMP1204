#!/bin/bash

score="$(grep "<Overall>" $1)"
score=${score%<Overall>}
echo $score