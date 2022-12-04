import os
import json
import web3
from web3 import Web3

from dotenv import load_dotenv
load_dotenv()


# function to connect to a web3 provider
def connect_to_web3_provider():
    w3 = Web3(Web3.HTTPProvider(os.getenv("ALCHEMY_URL")))
    if w3.isConnected():
        return w3
    return None

# function to get the contract address
def get_contract_address():
    return os.getenv("CONTRACT_ADDRESS")


# function to get the contract ABI
def get_contract_abi():
    abi = json.loads(os.getenv("CONTRACT_ABI"))
    return abi

# function to get the contract
def get_contract():
    w3 = connect_to_web3_provider()
    contract_address = get_contract_address()
    contract_abi = get_contract_abi()
    contract = w3.eth.contract(address=contract_address, abi=contract_abi)
    return contract

# function to get the contract balance
def get_contract_balance():
    w3 = connect_to_web3_provider()
    contract_address = get_contract_address()
    return w3.eth.get_balance(contract_address)


if __name__=="__main__":
    print(get_contract_balance())