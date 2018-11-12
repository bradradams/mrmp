pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import './RMP721.sol';
import './RMPcontract.sol';

/**
 *
 * Music Royalty Management Platform
 * Uses RMP721 Non-Fungible Token (Based on ERC721 standard)
 *
 */

contract MRMP is RMP721 {

    address rmpManager;

    struct stakeholder {
        string name; //Stakeholder's name
        string title; //Stakeholder's title i.e. songwriter, composer, musician, organization, other
        uint percentage; //Integer 1 to 100 indicating percentage of royalties
        address addr; //Stakeholder's Ethereum address
    }

    mapping (uint256 => stakeholder[]) private _stHolder; //Mapping from Token ID to array of stakeholders

    mapping (uint256 => uint256) private _stHolderCount; //Mapping from from Token ID to number of stakeholders


    string[] artist;

    mapping (uint8 => string[]) internal genreToArtists;

    mapping (string => string[]) internal artistToAlbums;

    mapping (string => string[]) internal albumToSongs;

    mapping (string => uint256) internal songToTokenId;

    mapping (string => string) internal songToAlbum;

    mapping (string => string) internal albumToArtist;


    constructor() public {
        rmpManager = msg.sender;
    }

    function generateId() private view returns (uint256) {
        require(msg.sender == rmpManager);

        //calls _exists from ERC721
        uint256 rmpId = 0;
        while (rmpId == 0 || _exists(rmpId)) {
            rmpId = uint256(now);
            //rmpId = uint256(keccak256(bytes((_rYear * _rMonth * _rDay)))); won't compile
        }
        return rmpId;
    }

    function addStakeholder(
        uint256 _rmpId,
        string _name,
        string _title,
        uint _percentage,
        address _addr
    )
        private
    {
        require(msg.sender == rmpManager);

        _stHolder[_rmpId].push(stakeholder(_name, _title, _percentage, _addr));
        _stHolderCount[_rmpId] = _stHolderCount[_rmpId].add(1);
    }

    function getStakeholder(uint256 _rmpId, uint index) public view returns(
        string _name,
        string _title,
        uint _percentage,
        address _addr
    )

    {
        stakeholder memory stk = _stHolder[_rmpId][index];

        _name = stk.name;
        _title = stk.title;
        _percentage = stk.percentage;
        _addr = stk.addr;
    }

    function addSong(
        uint256 _rmpId,
        address _trustee,
        string _title,
        string _artist,
        uint _rMonth,
        uint _rDay,
        uint _rYear,
        Genre _genre,
        string _image
    )
        private
    {
        require(msg.sender == rmpManager);

        //require(_genre > 0 && )

        //create contract

        address _contAddress = new RMPcontract(_rmpId, _stHolderCount[_rmpId]);


        bool exists = false;
        for (uint256 i = 0; i < artist.length; i++) {
           if (keccak256(bytes(artist[i])) == keccak256(bytes(_artist))) exists = true;
        }
        if (!exists)
        artist.push(_artist);

        //add artist to genreToArtists;

        //add album to artistToAlbums;

        //add song to albumToSongs;

        songToTokenId[_title] = _rmpId;

        //songToAlbum[_title] = ;




        //mint token
        mintRMP721(_rmpId, _contAddress, _trustee, _title, _artist, _rMonth, _rDay, _rYear, _genre, _image);

    }

    function getNumStakeholders(uint256 _rmpId) public view returns (uint) {
        return _stHolderCount[_rmpId];
    }

    //In order to return string[], had to use 'pragma experimental ABIEncoderV2;', warning: don't use on live deployments
    function getArtists(uint8 genre) public view returns (string[]) {
        return genreToArtists[genre];
    }


}
