//UNLICNESED
pragma solidity 0.8.0;
/**
 * @title ERC-20 With additional function approve function
 * @author mon-1 https://github.com/mon-1
 * @notice this is a contract with an additional approve function that allows the owner to be approved as a spender to the contracts token balance
 * @dev UNAUDITED CODE CAN CAUSE ERRORS AND EXPLOITS, THIS IS NOT PRODUCTION READY
 */ */
contract ERC20{

    mapping (address => uint) public balances;
    mapping (address => mapping(address => uint)) public allowences;

    uint public totalSupply;
    uint public decimals;

    string public name;
    string public symbol;
    address public owner;


    event Transfer(address indexed from, address indexed to, uint amount);

    event Approval(address indexed owner, address indexed spender, uint amount);


    constructor(string calldata _name, string calldata _symbol){
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        decimals = 18;
        totalSupply = 21 * 10**18;
        balances[msg.sender] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not the owener");
        _;
    }

    function balanceOf(address account) external view returns(uint256){
        return balances[account];
    }


    function transfer(address to, uint amount) external returns(bool success){

        require(balances[msg.sender] > amount && balances[msg.sender] > 0, "Insufficient tokens");
        require(to != address(0), "probably shouldnt send to the zero address");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint amount) external returns (bool success){
        uint256 spendable = allowences[from][to];
        require(balances[from] >= amount && spendable >= amount, "Unauthorized");

        balances[from] -= amount;
        balances[to] += amount;

        allowences[from][to] -= amount;

        emit Transfer(from, to, amount);

        return true;
    }

    function approve(address spender, uint amount) external returns (bool success) {
        require(spender != address(0), "You shouldn't approve to the zero address");

        allowences[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowence(address tokenOwner, address spender) external view returns(uint256 amount){
        return allowences[tokenOwner][spender];
    }

    function _mint(address account, uint amount) external onlyOwner { //kept external for testing purposes
        require(account != address(0),"You shouldn't mint to the zero address");
        totalSupply += amount;
        balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint amount) external onlyOwner { //kept external for testing purposes
        require(account != address(0), "Cant burn from the zero address");
        require(amount <= balances[account]);

        totalSupply -= amount;
        balances[account] -= amount;
        emit Transfer(account, address(0), amount);
    }

    function approveWithin(uint amount) external onlyOwner returns (bool success){
        address thisContract = address(this);
        address _owner = owner;
        allowences[thisContract][_owner] = amount;
        emit Approval(thisContract, _owner, amount);
        return true;
    }
}