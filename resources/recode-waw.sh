#!/bin/sh
for f in *.wav
do
  mv $f $f.bak
  ffmpeg -i $f.bak -ar 44100 -ac 2 -f wav $f
done

