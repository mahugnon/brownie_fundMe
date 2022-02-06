//SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{

    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address public owner;

    // array of addresses who deposited
    address[] public funders;

    AggregatorV3Interface public priceFeed;


    constructor(address _priceFeed) public{
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

   function fund() public payable{
     uint256 minimumUSD = 50*10**10;
     uint256 fundedUSD = getConversionRate(msg.value);

     require(fundedUSD >=minimumUSD,"You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
    funders.push(msg.sender);
    }
    function getVersion() public view returns (uint256){
      //AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    function getPrice() public view returns(uint256){
     //AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
      (,int256 answer,,,) = priceFeed.latestRoundData();
    return uint256(answer/(10**8));
    }

    function getEntranceFee() public view returns (uint256){
        // minimum usd
        uint256 minimumUSD = 50*10**10;
        uint256 price = getPrice();
        uint256 precision = 1*10**10;
        return (minimumUSD* precision)/price;

    }

    function getConversionRate( uint256 ethAmount) public view returns(uint256){
       uint256 ethPrice = getPrice(); 
       uint256 ethAmountUsd = (ethPrice * ethAmount);
       return ethAmountUsd;

    }

   modifier onlyOwner {
    	//is the message sender owner of the contract?
        require(msg.sender == owner);
        
        _;
    }
    
     function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);

        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
    
}