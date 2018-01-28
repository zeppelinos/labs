pragma solidity ^0.4.18;

import './Token_V0.sol';
import './OwnedToken.sol';

/**
 * @title Token_V1
 * @dev Version 1 of a token to show upgradeability.
 * The idea here is to extend a token behaviour providing mintable token functionalities as opposed to version 0
 */
contract Token_V1 is Token_V0, OwnedToken {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  modifier canMint() {
    require(!mintingFinished());
    _;
  }

  function initialize(address owner) public {
    require(!initialized());
    setTokenOwner(owner);
    boolStorage[keccak256('token_v1_initialized')] = true;
  }

  function initialized() public view returns (bool) {
    return boolStorage[keccak256('token_v1_initialized')];
  }

  function mintingFinished() public view returns (bool) {
    return boolStorage[keccak256('mintingFinished')];
  }

  function mint(address to, uint256 value) public onlyTokenOwner canMint {
    super.mint(to, value);
    Mint(to, value);
  }

  function finishMinting() public onlyTokenOwner canMint {
    boolStorage[keccak256('mintingFinished')] = true;
    MintFinished();
  }
}