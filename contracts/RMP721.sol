pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

/**
 *
 * RMP721 Non-Fungible Token (Based on ERC721 standard)
 *
 */

contract RMP721 is ERC721Full, ERC721Mintable {

    address rmpManager;
    uint tokenCount;

    // Note that according to the types section in solidity.readthedocs.io, enum types are not part of the ABI
    // Externally they are referred to by corresponding integer
    enum Genre { Rock, Pop, Jazz, Blues, Classical, Soul, Latin, World, Metal, Alternative, Traditional, Other }

    struct metaData {
        address contAddress; //Official contract address for this token
        address trustee; //Ethereum address where the token will be stored
        string title; //Title of recording
        string artist; //Title of performer or band
        uint rMonth; //Release month
        uint rDay; //Release day
        uint rYear; //Release year
        Genre genre; //enum Genre : See notes by enum definition above
        string image; //uri for cover art image stored on IPFS
    }

    struct stakeholder {
        string name; //Stakeholder's name
        string title; //Stakeholder's title i.e. songwriter, composer, musician, organization, other
        uint percentage; //Integer 1 to 100 indicating percentage of royalties
        address addr; //Stakeholder's Ethereum address
    }

    mapping (uint256 => metaData) private _mData; //Mapping from Token ID to metadata

    mapping (uint256 => stakeholder[]) private _stHolder; //Mapping from Token ID to array of stakeholders

    mapping (uint256 => uint256) private _stHolderCount; //Mapping from from Token ID to number of stakeholders

    constructor() ERC721Full("RMP721", "RMP") public {
        rmpManager = msg.sender;
        tokenCount = 0;
    }

    function mintRMP721 (
        address _contAddress,
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

        //Generate token ID, calls _exists from ERC721
        uint256 rmpId = 0;
        while (rmpId == 0 || _exists(rmpId)) {
            rmpId = uint256(now);
            //rmpId = uint256(keccak256(bytes((_rYear * _rMonth * _rDay))));
        }

        _mint(_trustee, rmpId); //Call to _mint in ERC721

        _mData[rmpId] = metaData(_contAddress, _trustee, _title, _artist, _rMonth, _rDay, _rYear, _genre, _image);

        tokenCount++;
    }

    function getMdata (uint256 _rmpId) public view returns (
        address _contAddress,
        address _trustee,
        string _title,
        string _artist,
        uint _rMonth,
        uint _rDay,
        uint _rYear,
        Genre _genre,
        string _image
    )

    {
        metaData memory md = _mData[_rmpId];

        _contAddress = md.contAddress;
        _trustee = md.trustee;
        _title = md.title;
        _artist = md.artist;
        _rMonth = md.rMonth;
        _rDay = md.rDay;
        _rYear = md.rYear;
        _genre = md.genre;
        _image = md.image;
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
}
