build:
	docker build -t lp_app .
	@echo "Build complete. Run 'make run' to execute the application."

run:
	@docker run --rm -v $(shell pwd)/src:/app/src lp_app

