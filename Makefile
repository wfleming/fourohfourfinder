.PHONY: deps deploy

deps:
	mix deps.get
	npm install

deploy:
	git push heroku master

