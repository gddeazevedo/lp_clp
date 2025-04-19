build:
	docker build -t lp_app .
	@echo "Build complete. Run 'make run' to execute the application."
	@echo "Run 'make clean' to remove the container and image."

run:
	@docker run --rm -v $(shell pwd)/src:/app/src lp_app

