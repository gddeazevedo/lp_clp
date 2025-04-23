build:
	docker build -t lp_app .
	@echo "Build complete. Run 'make run' to execute the application."

run:
	@docker run --rm -v $(shell pwd):/app lp_app julia /app/src/main.jl

run-example:
	@docker run --rm -v $(shell pwd):/app lp_app julia /app/examples/$(file)
