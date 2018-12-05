pragma solidity ^0.4.24;
//pragma experimental ABIEncoderV2;

import './RMP721.sol';

/**
 *
 * Music Royalty Management Platform
 * Uses RMP721 Non-Fungible Token (Based on ERC721 standard)
 *
 */

contract MRMP is RMP721 {

    address rmpManager;
    address rmpContAddress;

//    mapping (uint8 => string[]) internal genreToArtists;
//
//    mapping (string => string[]) internal artistToAlbums;
//
//    mapping (string => string[]) internal albumToSongs;

    string[] artist;

    mapping (uint8 => mapping (uint256 => string)) internal genreToArtists;

    mapping (string => mapping (uint256 => string)) internal artistToAlbums;

    mapping (string => mapping (uint256 => string)) internal albumToSongs;


    mapping (string => uint256) internal songToTokenId;

    mapping (string => string) internal songToAlbum;

    mapping (string => string) internal albumToArtist;


    mapping (uint256 => address) internal rmpIdToContract;

    mapping (uint256 => string) internal rmpIdToImage; // IPFS image link

    uint256 numContracts;


    constructor(address _rmpContAddress) public {
        rmpManager = msg.sender;
        rmpContAddress = _rmpContAddress;
    }


    //To add a song:
    //Call generateId to obtain an ID
    //Upload image to IPFS and obtain URI (Needs to be done in javascript????)
    //Call addSong to generate contract and mint token
    //Call addStakeholder as many times as needed to add all stakeholders to the official contract



    function generateId() public view returns (uint256) {
        require(msg.sender == rmpManager);

        //function calls _exists from ERC721
        uint256 rmpId = 0;
        while (rmpId == 0 || _exists(rmpId)) {
            rmpId = uint256(now);
            //rmpId = uint256(keccak256(bytes((_rYear * _rMonth * _rDay)))); won't compile
        }
        return rmpId;
    }



    function addSong(
        uint256 _rmpId,
        address _trustee,
        string _title,
        string _artist,
        string _album,
        uint _rMonth,
        uint _rDay,
        uint _rYear,
        Genre _genre,
        string _image
    )
        public
    {
        require(msg.sender == rmpManager);

        //verify parameters here
        //i.e. require(_genre > 0 && _genre <= 12)

        //create contract
        address _contAddress = new RMPcontract();

        // RMPcontract RMPcont = RMPcontract(_contAddress);

        //RMPcont.initRMPcont(_rmpId, _trustee, rmpManager);

        rmpIdToContract[numContracts] = _contAddress;

        numContracts++;


        //check to see if artist exists, if not then add it
        bool exists = false;
        for (uint256 i = 0; i < artist.length; i++) {
           if (keccak256(bytes(artist[i])) == keccak256(bytes(_artist))) exists = true;
            // is there a better way? Needs to be tested
        }
        if (!exists)
        artist.push(_artist);


        //add artist to genreToArtists;

        //add album to artistToAlbums;

        //add song to albumToSongs;


        rmpIdToImage[_rmpId] = _image; // IPFS image link

        songToTokenId[_title] = _rmpId;

        songToAlbum[_title] = _album;

        albumToArtist[_album] = _artist;

        //mint token
        mintRMP721(_rmpId, _contAddress, _trustee, _title, _artist, _album, _rMonth, _rDay, _rYear, _genre, _image);

    }

    function addStakeholder(
        uint256 _rmpId,
        string _name,
        string _title,
        uint _percentage,
        address _addr
    )
    public
    {
        require(msg.sender == rmpManager); // what about trustee?

        RMPcontract RMPcont = RMPcontract(rmpIdToContract[_rmpId]);

        RMPcont.addStakeholderOfficial(_name, _title, _percentage, _addr);
    }

    function getArtists(uint8 genre, uint256 index) public view returns (string) {
        return genreToArtists[genre][index];
    }

    function getContractAddress(uint256 _rmpId) public view returns (address) {
        return rmpIdToContract[_rmpId];
    }

    //In order to return string[], had to use 'pragma experimental ABIEncoderV2;', warning: don't use on live deployments
//    function getArtists(uint8 genre) public view returns (string[]) {
//        return genreToArtists[genre];
//    }

    //Need more getters like one above, should test above function first

}






contract RMPcontract {
    uint256 rmpId;
    address rmpManager;
    address trustee;

    struct stakeholder {
        string name; //Stakeholder's name
        string title; //Stakeholder's title i.e. songwriter, composer, musician, organization, other
        uint percentage; //Integer 1 to 100 indicating percentage of royalties
        address addr; //Stakeholder's Ethereum address
    }

    mapping (uint256 => stakeholder) private stHolder; //List of stakeholders, (0 to stHolderCount - 1)

    uint256 stHolderCount;

    event RoyaltyPayment(uint256 tokenId, uint amount);




    constructor() public {
    }

    function initRMPcont(uint256 _rmpId, address _rmpManager, address _trustee) public {
        require(msg.sender == rmpManager);
        rmpId = _rmpId;
        rmpManager = _rmpManager;
        trustee = _trustee;
    }

    function addStakeholderOfficial(
        string _name,
        string _title,
        uint _percentage,
        address _addr
    )
    public
    {
        require(msg.sender == rmpManager || msg.sender == trustee);
        stHolder[stHolderCount] = stakeholder(_name, _title, _percentage, _addr);
        stHolderCount++;
    }

    function getStakeholder(uint index) public view returns(
        string _name,
        string _title,
        uint _percentage,
        address _addr
    )
    {
        stakeholder memory stk = stHolder[index];

        _name = stk.name;
        _title = stk.title;
        _percentage = stk.percentage;
        _addr = stk.addr;
    }

    function getNumStakeholders() public view returns (uint) {
        return stHolderCount;
    }

    function() public payable {
        uint amountReceived = msg.value;


        //Unfinished
        //Need to distribute funds to stakeholders
        //Can this be done without floating points?

        emit RoyaltyPayment(rmpId, amountReceived);
    }
}




/*

    contract RMPcontract {

        function initRMPcont(uint256 _rmpId, address _rmpManager, address _trustee) public;

        function addStakeholderOfficial(
        string _name,
        string _title,
        uint _percentage,
        address _addr
        )
        public;

        function getStakeholder(uint index) public view returns(
        string _name,
        string _title,
        uint _percentage,
        address _addr
        );

        function getNumStakeholders() public view returns (uint);

        function() public payable;
    }

*/







/*
contract RMPcontract {
    uint256 rmpId;
    address rmpManager;
    address trustee;

    struct stakeholder {
        string name; //Stakeholder's name
        string title; //Stakeholder's title i.e. songwriter, composer, musician, organization, other
        uint percentage; //Integer 1 to 100 indicating percentage of royalties
        address addr; //Stakeholder's Ethereum address
    }

    mapping (uint256 => stakeholder) private stHolder; //List of stakeholders, (0 to stHolderCount - 1)

    uint256 stHolderCount;

    event RoyaltyPayment(uint256 tokenId, uint amount);


    constructor(uint256 _rmpId, address _rmpManager, address _trustee) public {
        rmpId = _rmpId;
        rmpManager = _rmpManager;
        trustee = _trustee;
    }

    function addStakeholderOfficial(
        string _name,
        string _title,
        uint _percentage,
        address _addr
    )
    public
    {
        require(msg.sender == rmpManager || msg.sender == trustee);
        stHolder[stHolderCount] = stakeholder(_name, _title, _percentage, _addr);
        stHolderCount++;
    }

    function getStakeholder(uint index) public view returns(
        string _name,
        string _title,
        uint _percentage,
        address _addr
    )
    {
        stakeholder memory stk = stHolder[index];

        _name = stk.name;
        _title = stk.title;
        _percentage = stk.percentage;
        _addr = stk.addr;
    }

    function getNumStakeholders() public view returns (uint) {
        return stHolderCount;
    }

    function() public payable {
        uint amountReceived = msg.value;


        //Unfinished
        //Need to distribute funds to stakeholders
        //Can this be done without floating points?

        emit RoyaltyPayment(rmpId, amountReceived);
    }
}
*/



