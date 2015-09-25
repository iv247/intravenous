#!/bin/sh

task=$1

if [ $task == "test" ]
	then
	echo "\n*** TESTING IN NEKO ***"
	haxe resources/hxml/neko.hxml 
	echo "\n*** TESTING IN NODE.JS ***"
	haxe resources/hxml/node.hxml
	echo "\n*** TESTING IN JS ***"
	haxe resources/hxml/js.hxml
	echo "\n*** TESTING IN PHP ***"
    	haxe resources/hxml/php.hxml
    echo "\n*** TESTING IN C++ ***"
        haxe resources/hxml/cpp.hxml


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

