pragma solidity ^0.4.24;

//import './MRMP.sol';

/**
 *
 * Official Royalty Distribution Contract
 * Music Royalty Management Platform
 *
 */



contract RMPcontract {
    uint256 rmpId;
    uint numStakeholders;

    event RoyaltyPayment(uint256 tokenId, uint amount);

    constructor(uint256 _rmpId, uint _numStakeholders) public {
        rmpId = _rmpId;
        numStakeholders = _numStakeholders;
    }

    function() public payable {
        uint amountReceived = msg.value;


        //Unfinished
        //
        //
    }
}






//constructor(uint256 _rmpId, address mrmpAdd) public {
//    rmpId = _rmpId;
//    _mrmp = MRMP(mrmpAdd);
//}

//contract MRMP is RMP721 {
//
//    function getNumStakeholders(uint256 _rmpId) public view returns (uint) {}
//}