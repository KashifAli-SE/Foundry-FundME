include .env
export

build:; forge build

deploy-sepolia:; forge script script/DeployFundMe.s.sol --rpc-url $(Sepolia_rpc_url) --private-key $(Sepolia_private_key) --broadcast --verify --etherscan-api-key $(Etherscan_api_key)
# --verify --etherscan-api-key 51B5MJIUWJRT7GAGAFZFEQJ7BJ2AVJH17X -vvv