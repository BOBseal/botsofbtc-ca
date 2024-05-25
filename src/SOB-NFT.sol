// SPDX-License-Identifier:  MIT


pragma solidity ^0.8.20;
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Math/Math.sol";
import {ERC2981} from "openzeppelin-contracts/contracts/token/common/ERC2981.sol";
import "./Events/PointsCore.sol";


contract SKIBBIDIESOFBITCOIN is ERC721, ERC721URIStorage, Ownable, ERC2981{
    using Math for uint;
    bytes16 private constant HEX_DIGITS = "0123456789abcdef";

    EventCore internal RPCore;

    uint internal RPPerMint = 1000;
    uint public totalSupply = 3456;
    uint internal nextIdToMint = 1;
    string internal baseUri;
    
    event Burn(uint indexed  id , address indexed from);

    mapping (address => bool) internal Managers;

    constructor(address _RpCore , address manager, string memory _BaseUri)
        ERC721("Skibbidies Of Bitcoin", "SOB")
        Ownable(msg.sender)
    {   
        
        _setDefaultRoyalty(msg.sender, 1000);
        Managers[msg.sender]= true;
        Managers[manager]= true;
        RPCore = EventCore(_RpCore);        
        baseUri = _BaseUri;
    }

    function setBaseUri(string memory newUri) public onlyOwner{
        baseUri = newUri;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function burn(uint id) public {
        require(_requireOwned(id) == msg.sender);
        _burn(id);
        emit Burn(id, msg.sender);
    }

    function mintMethod1(address to) external {
        require(Managers[msg.sender],"not allowed");
        uint tokenId = nextIdToMint;
        require(tokenId <= totalSupply,"minted out");
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _calculateUri(tokenId));
        nextIdToMint +=1;
        if(address(RPCore) != address(0)){
            RPCore.addPoints(to ,RPPerMint);
        }
    }

    function mintMethod2(address to, uint256 amount) external {
        require(Managers[msg.sender],"not allowed");
        for(uint i = 0; i < amount; i++){
            uint tokenId = nextIdToMint;
            require(tokenId <= totalSupply,"minted out");
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, _calculateUri(tokenId));
            nextIdToMint +=1;
        }
        if(address(RPCore) != address(0)){
            RPCore.addPoints(to ,RPPerMint * amount);
        }
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function setRoyalty(address reciever, uint96 fraction) public  onlyOwner{
        _setDefaultRoyalty(reciever,  fraction);
    }

    function addManager(address a , bool state) public onlyOwner{
        Managers[a] = state;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // uint to str helper
    function _toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }
    // minting uri generation helper
    function _calculateUri(uint id) internal pure returns(string memory){
        return (string.concat("/",_toString(id),".json"));
    }
}
