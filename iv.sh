#!/bin/sh

task=$1

if [ $task == "test" ]
	then
	echo "testing neko"
	haxe resources/hxml/neko.hxml 
	echo "texting js"
	haxe resources/hxml/js.hxml

elif [ $task == "docs" ]
	then
	rm -rf dist/doc
	haxe resources/hxml/doc.hxml
    haxelib run dox -i build -in intravenous -o dist/doc

elif [ $task == "viewdoc" ]
	then
	open dist/doc/index.html

elif [ $task == "pack" ]
	then
	rm -f dist/archive.zip,
    cd src
    zip -r ../dist/archive.zip ./

elif [ $task == "install-lib" ]
	then
	haxelib local dist/archive.zip
fi

