BIN := ./node_modules/.bin
FILES := $(shell find lib spec/lib examples  -type f -name "*.js")
TEST_FILES := spec/helper.js $(shell find spec/lib -type f -name "*.js")

VERSION := $(shell node -e "console.log(require('./package.json').version)")

.PHONY: cover test bdd lint ci release

test: lint
	@$(BIN)/mocha --colors -R dot $(TEST_FILES)

bdd: lint
	@$(BIN)/mocha --colors -R spec $(TEST_FILES)

cover:
	@istanbul cover $(BIN)/_mocha $(TEST_FILES) --report lcovonly -- -R spec

lint:
	@jshint $(FILES)

ci: lint cover

release:
	@git push origin master
	@git checkout release ; git merge master ; git push ; git checkout master
	@git tag -m "$(VERSION)" v$(VERSION)
	@git push --tags
	@npm publish ./
