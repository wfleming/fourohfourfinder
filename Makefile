.PHONY: format

app.js: src/*.elm
	elm make src/App.elm --output app.js

format:
	elm-format src --yes
