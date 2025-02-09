pragma solidity >=0.5.0 < 0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    mapping (uint => address) zombieApprovals;
    function balanceOf(address _owner) external view returns (uint256){
        return uint256(ownerZombieCount[_owner]);
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return zombieToOwner[_tokenId];
    }
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(zombieToOwner[_tokenId] == msg.sender||zombieToOwner[_tokenId]==zombieApprovals[_tokenId]);
        _transfer(_from, _to, tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
    function _transfer(address _from, address _to, uint tokenId) private {
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        zombieToOwner[tokenId] = _to;
        emit Transfer(_from, _to, tokenId);
    }
}