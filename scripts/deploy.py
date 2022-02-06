from brownie import FundMe, network,config, MockV3Aggregator
from scripts.helpful_script import get_account,get_publish_source,get_price_feed_address


def deploy_fund_me():
    account = get_account()
    price_feed_addess = get_price_feed_address();
    print(f"the feed address is {price_feed_addess}");
    fund_me = FundMe.deploy(price_feed_addess,
                            {"from":account},
                            publish_source = get_publish_source())
    
    return fund_me
    
def main():
    deploy_fund_me()
    
