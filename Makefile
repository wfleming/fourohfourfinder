.PHONY: format clean

app.js: src/*.elm
	elm make src/App.elm --output app.js

format:
	#elm-format src --yes
	@echo "Don't use this yet: it's kind of crazy."

clean:
	rm -r app.js elm-stuff/build-artifacts
