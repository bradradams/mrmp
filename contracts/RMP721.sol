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
    // Can't use in mapping
    // Considering just using an integer instead.
    enum Genre { All, Rock, Pop, Jazz, Blues, Classical, Soul, Latin, World, Metal, Alternative, Traditional, Other }

    struct metaData {
        address contAddress; //Official contract address for this token
        address trustee; //Ethereum address where the token will be stored
        string title; //Title of recording
        string artist; //Title of performer or band
        string album; //Album, if none use 'single'
        uint rMonth; //Release month
        uint rDay; //Release day
        uint rYear; //Release year
        Genre genre; //enum Genre : See notes by enum definition above
        string image; //uri for cover art image stored on IPFS
    }

    mapping (uint256 => metaData) public _mData; //Mapping from Token ID to metadata

    event newToken(uint256 tokenId);

    constructor() ERC721Full("RMP721", "RMP") public {
        rmpManager = msg.sender;
        tokenCount = 0;
    }

    function mintRMP721 (
        uint256 _rmpId,
        address _contAddress,
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

        _mint(_trustee, _rmpId); //Call to _mint in ERC721

        _mData[_rmpId] = metaData(_contAddress, _trustee, _title, _artist, _album, _rMonth, _rDay, _rYear, _genre, _image);

        tokenCount++;

        emit newToken(_rmpId);
    }

    function getMdata (uint256 _rmpId) public view returns (
        address _contAddress,
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

    {
        metaData memory md = _mData[_rmpId];

        _contAddress = md.contAddress;
        _trustee = md.trustee;
        _title = md.title;
        _artist = md.artist;
        _album = md.album;
        _rMonth = md.rMonth;
        _rDay = md.rDay;
        _rYear = md.rYear;
        _genre = md.genre;
        _image = md.image;
    }
}
