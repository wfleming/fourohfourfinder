.PHONY: deps clean deploy format

deps:
	mix deps.get
	npm install

deploy:
	git push heroku master

format:
	#elm-format src --yes
	@echo "Don't use this yet: it's kind of crazy."

clean:
	rm -r app.js elm-stuff/build-artifacts
