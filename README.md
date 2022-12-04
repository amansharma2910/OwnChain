# OwnChain
---

An on-chain physical asset ownership management dApp POC.

Deployed Smart Contract (Polygon Mumbai Testnet): [[Click Here!](https://mumbai.polygonscan.com/address/0x1150964331fbf3dd7d6a6a68be75d806ea3fa900)]

## Steps to Setup Development Environment

* Install node dependencies (ensure you have node@18 installed):
```bash
npm install
```

* Install python dependencies (preferrably in a virtual env):
```python
pip install -r requirements.txt
```

You will require the smart contract hash and ABI to test everything out using python. For that, you need to compile and deploy the smart contract first. Check the `.example_env` file to fill in the env vars.

* You can get your `POLYGONSCAN_API_KEY` by registering on the [polygonscan](https://polygonscan.com/) website.
* For getting your `ALCHEMY_URL`, kindly register and create an app on Alchemy.
* To get your `CONTRACT_ADDRESS` and `CONTRACT_ABI` you need to deploy your smart contract first. To do that, run this command:

```bash
npx hardhat run scripts/deploy.js --network polygon_mumbai
```

You can find your contract address on [polygonscan](https://polygonscan.com/).
The ABI can be found at the path `artifacts/contracts/OwnChain.sol/OwnChain.json` within your workdir.


The POC methods are in main.py file where we interact with the smart contract.

