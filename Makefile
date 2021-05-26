clean:
	@rm -rf ./dist/ || true

install:
	@dfx canister create --all
	@dfx build
	@dfx canister install --all

local-deploy:
	@dfx build
	@dfx canister install --all --mode reinstall