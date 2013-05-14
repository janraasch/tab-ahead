install:
	npm install
uglify:
	node_modules/uglify-js/bin/uglifyjs node_modules/fuzzy/lib/fuzzy.js lib/js/jquery-1.9.1.js lib/js/bootstrap-typeahead.js popup.js -o build/popup.min.js
package:
	zip -r -X build.zip build
