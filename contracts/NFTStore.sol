pragma solidity >=0.5.0 <=0.6.0; 

contract ERC721{
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
  event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
  event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

  function balanceOf(address owner) public view returns (uint256 balance);
  function ownerOf(uint256 tokenId) public view returns (address owner);

  function approve(address to, uint256 tokenId) public;
  function getApproved(uint256 tokenId) public view returns (address operator);

  function setApprovalForAll(address operator, bool _approved) public;
  function isApprovedForAll(address owner, address operator) public view returns (bool);

  function transferFrom(address from, address to, uint256 tokenId) public;
  function safeTransferFrom(address from, address to, uint256 tokenId) public;

  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

contract ERC721x{
  function implementsERC721X() public pure returns (bool);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function balanceOf(address owner) public view returns (uint256);
  function balanceOf(address owner, uint256 tokenId) public view returns (uint256);
  function tokensOwned(address owner) public view returns (uint256[], uint256[]);

  function transfer(address to, uint256 tokenId, uint256 quantity) public;
  function transferFrom(address from, address to, uint256 tokenId, uint256 quantity) public;

  // Fungible Safe Transfer From
  function safeTransferFrom(address from, address to, uint256 tokenId, uint256 _amount) public;
  function safeTransferFrom(address from, address to, uint256 tokenId, uint256 _amount, bytes data) public;

  // Batch Safe Transfer From
  function safeBatchTransferFrom(address _from, address _to, uint256[] tokenIds, uint256[] _amounts, bytes _data) public;

  function name() external view returns (string);
  function symbol() external view returns (string);

  // Required Events
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
  event TransferWithQuantity(address indexed from, address indexed to, uint256 indexed tokenId, uint256 quantity);
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
  event BatchTransfer(address indexed from, address indexed to, uint256[] tokenTypes, uint256[] amounts);
}

contract NFTStore is ERC721x{
  //Data
  mapping(address => mapping(uint256 => uint256)) packedTokenBalance;
  mapping(uint256 => address) internal tokenOwner;
  mapping(address => mapping(address => bool)) operators;
  mapping (uint256 => address) internal tokenApprovals;
  mapping(uint256 => uint256) tokenType;

  //721 Functions
  function implementsERC721X() public pure returns (bool){ return true; }
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function balanceOf(address owner) public view returns (uint256);
  function balanceOf(address owner, uint256 tokenId) public view returns (uint256);
  function tokensOwned(address owner) public view returns (uint256[], uint256[]);

  function transfer(address to, uint256 tokenId, uint256 quantity) public;
  function transferFrom(address from, address to, uint256 tokenId, uint256 quantity) public;

  // Fungible Safe Transfer From
  function safeTransferFrom(address from, address to, uint256 tokenId, uint256 _amount) public;
  function safeTransferFrom(address from, address to, uint256 tokenId, uint256 _amount, bytes data) public;

  // Batch Safe Transfer From
  function safeBatchTransferFrom(address _from, address _to, uint256[] tokenIds, uint256[] _amounts, bytes _data) public;

  function name() external view returns (string);
  function symbol() external view returns (string);

  // Required Events
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
  event TransferWithQuantity(address indexed from, address indexed to, uint256 indexed tokenId, uint256 quantity);
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
  event BatchTransfer(address indexed from, address indexed to, uint256[] tokenTypes, uint256[] amounts);

}