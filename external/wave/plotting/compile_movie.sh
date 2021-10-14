#!/bin/bash
#
# COMPILE MOVIE rolls a movie from PDF frames 
# (suitable for exporting movies from MATLAB on Linux)
# Lyle Muller, 27 October 2013
#
# depends: inkscape, ffmpeg (bleeding)
#
# INPUT
# $1 - dpi for rasterization
# $2 - filename
#
# OUTPUT: AVI Movie
#

# convert PDF frames to PNG using inkscape (specifying dpi)
for i in ./frame*.pdf
do
inkscape --export-png=./${i%.pdf}.png -d $1 ./$i
done

# wrap the frames into an AVI
ffmpeg -start_number 1 -i ./frame_%02d.png -vcodec mpeg4 -r 10 -b: 2000k ./$2.avi 

# clean up the individual frames
# rm ./frame*.pdf
# rm ./frame*.png

