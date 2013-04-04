all : datamock.js datamock.min.js

datamock.js : datamock.coffee
	coffee -c -p $< > $@

datamock.min.js : datamock.js
	uglifyjs $< -c -m > $@

bookmarklet : datamock.min.js
	@echo "javascript:\c"
	@cat datamock.min.js
	@echo "\$$('body').datamock();"
