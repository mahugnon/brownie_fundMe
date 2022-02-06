from brownie import accounts, config, network, MockV3Aggregator
from web3 import Web3

DECIMAL = 8;
STARTING_PRICE = 2000;
LOCAL_BLOCHAIN_ENVIRONNMENT = ["development","ganache-local"]
def get_account():
    if network.show_active() in LOCAL_BLOCHAIN_ENVIRONNMENT:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def get_publish_source():
    return config["networks"][network.show_active()].get("verify");


def get_price_feed_address():
    if network.show_active() not in LOCAL_BLOCHAIN_ENVIRONNMENT:
        return config["networks"][network.show_active()]["eth_usd_price_feed"];
    else:
      return deploy_mock()


def deploy_mock():
    if len(MockV3Aggregator)<=0:
         MockV3Aggregator.deploy(DECIMAL, Web3.toWei(STARTING_PRICE,"ether"), {"from": get_account()});
    return MockV3Aggregator[-1].address;

