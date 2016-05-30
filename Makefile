.PHONY: deploy deps check-elm

deploy:
	git push heroku master

deps:
	mix deps.get
	npm install

check-elm:
	cd web/static/js/elm && elm-make App.elm --warn && rm index.html
