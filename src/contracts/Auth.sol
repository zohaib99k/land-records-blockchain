// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.6.0;

contract Auth {
    struct UserDetail {
        address addr;
        string name;
        string password;
        string CNIC;
        string ipfsImageHash;
        bool isUserLoggedIn;
    }

    mapping(address => UserDetail) user;

    // user registration function
    function registerUser(
        address _address,
        string memory _name,
        string memory _password,
        string memory _cnic
    ) public notAdmin returns (bool) {
        require(user[_address].addr != msg.sender);
        user[_address].addr = _address;
        user[_address].name = _name;
        user[_address].password = _password;
        user[_address].CNIC = _cnic;
        user[_address].isUserLoggedIn = false;
        return true;
    }

    // user login function
    function loginUser(address _address, string memory _password)
        public
        notAdmin
        returns (bool)
    {
        require(user[_address].addr == msg.sender);
        if (
            keccak256(abi.encodePacked(user[_address].password)) ==
            keccak256(abi.encodePacked(_password))
        ) {
            user[_address].isUserLoggedIn = true;
            return user[_address].isUserLoggedIn;
        } else {
            return false;
        }
    }
    
    // user forgot password function
    function forgetPasswordUser(address _address, string memory _password)
        public
        notAdmin
        returns (bool)
    {
        require(user[_address].addr == msg.sender);

        if (user[_address].addr == msg.sender) {
            user[_address].password = _password;
            return true;
        } else {
            return false;
        }
    }

    // check the user logged In or not
    function checkIsUserLogged(address _address)
        public
        notAdmin
        returns (
            bool,
            string memory,
            string memory
        )
    {
        require(user[_address].addr == msg.sender);
        return (
            user[_address].isUserLoggedIn,
            user[_address].ipfsImageHash,
            user[_address].name
        );
    }

    // logout the user
    function logoutUser(address _address) public notAdmin {
        require(user[_address].addr == msg.sender);
        user[_address].isUserLoggedIn = false;
    }

    function getUserBalance(address _address)
        public
        notAdmin
        returns (uint256)
    {
        require(user[_address].addr == msg.sender);
        return (user[_address].addr.balance);
    }

    // get username
    function getUserName(address _address) public returns (string memory) {
        //require(user[_address].addr == msg.sender);
        return user[_address].name;
    }

    // set and get the user ipfs image hash
    function setUserIpfsImageHash(
        address _address,
        string memory _ipfsImageHash
    ) public notAdmin returns (bool) {
        require(user[_address].addr == msg.sender);
        user[_address].ipfsImageHash = _ipfsImageHash;
        return true;
    }

    function getUserIpfsImageHash(address _address)
        public
        notAdmin
        returns (string memory)
    {
        require(user[_address].addr == msg.sender);
        return user[_address].ipfsImageHash;
    }

    struct AdminDetail {
        address adminAddress;
        string name;
        string password;
        string ipfsImageHash;
        bool isAdminLoggedIn;
    }
    mapping(address => AdminDetail) admin;
    // admin registration function

    address adminAddress;

    constructor() public {
        adminAddress = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == adminAddress);
        _;
    }

    modifier notAdmin() {
        require(msg.sender != adminAddress);
        _;
    }

    function registerAdmin(
        address _address,
        string memory _name,
        string memory _password
    ) public onlyAdmin returns (bool) {
        require(admin[_address].adminAddress != msg.sender);
        admin[_address].adminAddress = _address;
        admin[_address].name = _name;
        admin[_address].password = _password;
        admin[_address].isAdminLoggedIn = false;
        return true;
    }

    // admin login function
    function loginAdmin(address _address, string memory _password)
        public
        onlyAdmin
        returns (bool)
    {
        if (
            keccak256(abi.encodePacked(admin[_address].password)) ==
            keccak256(abi.encodePacked(_password))
        ) {
            admin[_address].isAdminLoggedIn = true;
            return admin[_address].isAdminLoggedIn;
        } else {
            return false;
        }
    }

    // check the admin logged In or not
    function checkIsAdminLogged(address _address)
        public
        onlyAdmin
        returns (
            bool,
            string memory,
            string memory
        )
    {
        return (
            admin[_address].isAdminLoggedIn,
            admin[_address].ipfsImageHash,
            admin[_address].name
        );
    }

    // logout the admin
    function logoutAdmin(address _address) public onlyAdmin {
        admin[_address].isAdminLoggedIn = false;
    }

    function getAdminBalance(address _address)
        public
        onlyAdmin
        returns (uint256)
    {
        return (admin[_address].adminAddress.balance);
    }

    // set and get the admin ipfs image hash
    function setAdminIpfsImageHash(
        address _address,
        string memory _ipfsImageHash
    ) public onlyAdmin returns (bool) {
        admin[_address].ipfsImageHash = _ipfsImageHash;
        return true;
    }

    function getAdminIpfsImageHash(address _address)
        public
        onlyAdmin
        returns (string memory)
    {
        return admin[_address].ipfsImageHash;
    }
}
