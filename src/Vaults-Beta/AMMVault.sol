// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./ERC4626.sol";

contract AMMVault is ERC4626MOD{
    uint8 internal _decimal;

    using Math for uint256;

    uint256 private constant _BASIS_POINT_SCALE = 1e4; // 0.1% fee is applied to redeems of shares and burned

    constructor(address asset, uint buffer, string memory shareName , string memory shareSymbol)
    ERC20(shareName,shareSymbol)
    {
        _decimal = ERC20(asset).decimals();
        _mint(msg.sender, buffer * 10 ** decimals());
    }
    // === Overrides ===

    function decimals() public view override(ERC4626MOD) returns (uint8){
        return _decimal;
    }
}