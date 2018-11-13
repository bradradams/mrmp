pragma solidity ^0.4.24;

import './MRMP.sol';

/**
 *
 * Official Royalty Distribution Contract
 * Music Royalty Management Platform
 *
 */



contract RMPcontract {
    uint256 rmpId;
    MRMP _mrmp;

    // trying to access values from MRMP.sol using methods from class

    event RoyaltyPayment(uint256 tokenId, uint amount);


    constructor(uint256 _rmpId, address mrmpAdd) public {
        rmpId = _rmpId;
        _mrmp = MRMP(mrmpAdd);
    }

    function() public payable {
        uint amountReceived = msg.value;
        //uint num = _mrmp.getNumStakeholders(rmpId);

        //Unfinished
        //Not compiling apparently because this contract is imported by MRMP.sol ?
        //Need to distribute funds to stakeholders
        //Can this be done without floating points?

        emit RoyaltyPayment(rmpId, amountReceived);
    }
}

contract MRMP is RMP721 {

    function getNumStakeholders(uint256 _rmpId) public view returns (uint) {}

    function getStakeholder(uint256 _rmpId, uint index) public view returns(
        string _name,
        string _title,
        uint _percentage,
        address _addr
    )

    {}
}



