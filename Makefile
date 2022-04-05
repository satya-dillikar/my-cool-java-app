NAME:=tanzu-java-web-app
DOCKER_REPOSITORY:=dsatya6
DOCKER_IMAGE_NAME:=$(DOCKER_REPOSITORY)/$(NAME)
VERSION:=0.1.0

.PHONY: build clean test build-container push-container test-container

build :
	mvn compile

run :
	java -jar target/*.jar

clean :
	mvn clean dependency:copy-dependencies package
	mvn clean install

test:
	mvn package
	# mvn site

build-container :
	@docker build -t dsatya6/$(NAME):$(VERSION) .

push-container :
	@docker push dsatya6/$(NAME):$(VERSION)

test-container :
	@docker rm -f $(NAME) || true
	@docker run -dp 8080:8080	--name=$(NAME) $(DOCKER_IMAGE_NAME):$(VERSION)
	@echo  ""
	@sleep 5
	curl http://localhost:8080 | grep Satya
	@echo  ""
	@sleep 2
	@docker stop $(NAME) || true
	@docker rm -f $(NAME) || true

