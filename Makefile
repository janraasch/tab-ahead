install:
	npm install
uglify:
	node_modules/uglify-js/bin/uglifyjs node_modules/fuzzy/lib/fuzzy.js lib/js/jquery-1.9.1.js lib/js/bootstrap-typeahead.js popup.js -o build/popup.min.js
copy:
	cp popup.css build/popup.css
	cp manifest.json build/manifest.json
package:
	zip -r -X build.zip build
buildzip:
	make uglify
	make copy
	make package
