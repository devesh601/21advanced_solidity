pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale , CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale { // UPDATE THE CONTRACT SIGNATURE TO ADD INHERITANCE
    
    constructor(
        uint rate, // rate in TKN bits
        address payable wallet, // sale beneficiary
        KaseiCoin token, // the ArcadeToken itself that the ArcadeTokenSale will work with
        uint goal,
        uint open_time, 
        uint close_time
    )
    
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(open_time, close_time)
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract KaseiCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    uint open_time;
    uint close_time;
    uint goal;

    constructor(
        string memory name,
        string memory symbol, 
        address payable wallet //this address will receive all Ether raised by the sale
    )
        public
    {
        // @TODO: create the KaseiCoin and keep its address handy
        KaseiCoin token = new KaseiCoin(name, symbol, 0);
        token_address = address(token);

        // @TODO: create the KaseiCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        KaseiCoinSale token_sale = new KaseiCoinSale (1, wallet, token, now, now + 24 weeks, 100);
        token_sale_address = address (token_sale);

        // make the KaseiCoinSale contract a minter, then have the KaseiCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
