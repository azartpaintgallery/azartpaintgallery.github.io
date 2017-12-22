#!/bin/bash

mkdir posts
DATE=`date +%Y-%m-%d`;

for file in `find . -maxdepth 1  -name "*.jpg"` 
do
	file=${file:2}
	echo $file
	
	convert -resize 250 $file "${file%.*}".png	
	mv $file backup2
	convert "${file%.*}".png "${file%.*}".jpg
	array=( $(identify -format '%w %h' $file) )
	width=${array[0]}
	height=${array[1]}
	if [ $width -lt $height ]
	then
		convert $file -crop 250x250 "${file%.*}"2.jpg
		mv "${file%.*}"2-0.jpg $file
		rm -f "${file%.*}"2-0.jpg
		rm -f "${file%.*}"2-1.jpg
		rm -f "${file%.*}"2-2.jpg
	fi
	rm -f "${file%.*}".png
	post_name=`echo "${file%.*}" | tr -d ' ./'  | sed 's/\([A-Z]\)/ \1/g'`
	post_title=`echo "$post_name" | tr ' ' '-'`
	post_file="$DATE"-"$post_title".markdown

	echo $post_name
	echo $post_title
	echo $post_file

	echo "---" > $post_file
	echo "layout: post" >> $post_file


	echo "title: $post_name" >> $post_file
	TIME=`date +%H:%M:%S`
	echo "date: $DATE $TIME" >> $post_file 
	echo "thumbnail: $file">> $post_file
	echo "---" >> $post_file

	mv $post_file posts
	
done
