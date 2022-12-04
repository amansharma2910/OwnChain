import os
from web3 import Web3

from dotenv import load_dotenv
load_dotenv()


# function to connect to a smart contract
def connect_to_contract():
    w3 = Web3(Web3.HTTPProvider(os.getenv("ALCHEMY_URL")))
    if w3.isConnected():
        return w3
    return



if __name__=="__main__":
    w3 = connect_to_contract()
    print(w3.isConnected())