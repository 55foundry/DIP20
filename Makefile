clean:
	@rm -rf ./dist/ || true

demo:
	@./demo.sh

swap:
	@./swap.sh

install:
	@dfx canister create --all
	@dfx build
	@dfx canister install --all

local-deploy:
	@dfx build
	@dfx canister install --all --mode reinstall