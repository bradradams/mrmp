pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract RMP721 is ERC721Full, ERC721Mintable {
  constructor() ERC721Full("RMP721", "RMP") public {
  }
}
