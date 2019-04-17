pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "sc-library/contracts/ERC223/ERC223Receiver.sol";

/*
 * 에어드랍을 위한 스마트 컨트랙트.
 * addresses와 amounts는 외부에서 csv 와 같은 형태로 가지고 있다가 transfer를 호출해야 한다.
*/
contract AirDrop is Ownable {
    ERC20 public token;
    uint public createdAt;
    constructor(address _target, ERC20 _token) public {
        owner = _target;
        token = _token;
        createdAt = block.number;
    }

    function transfer(address[] _addresses, uint[] _amounts) external onlyOwner {
        require(_addresses.length == _amounts.length);

        for (uint i = 0; i < _addresses.length; i ++) {
            token.transfer(_addresses[i], _amounts[i]);
        }
    }

    function transferFrom(address _from, address[] _addresses, uint[] _amounts) external onlyOwner {
        require(_addresses.length == _amounts.length);

        for (uint i = 0; i < _addresses.length; i ++) {
            token.transferFrom(_from, _addresses[i], _amounts[i]);
        }
    }

    function tokenFallback(address, uint, bytes) public pure {
        // receive tokens
    }

    function withdraw(uint _value) public onlyOwner {
        token.transfer(owner, _value);
    }

    function withdrawToken(address _token, uint _value) public onlyOwner {
        ERC20(_token).transfer(owner, _value);
    }
}
