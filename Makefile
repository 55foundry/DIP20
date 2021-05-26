clean:
	@rm -rf ./dist/ || true

demo:
	@./demo.sh

install:
	@dfx canister create --all
	@dfx build
	@dfx canister install --all

local-deploy:
	@dfx build
	@dfx canister install --all --mode reinstall