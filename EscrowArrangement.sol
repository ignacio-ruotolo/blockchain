// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.31;

contract EscrowArrangement {

    /// @notice Possible states of the escrow.
    enum State {
        CREATED,
        FUNDED,
        DISPUTED,
        RELEASED,
        REFUNDED
    }

    /// @notice Current state of the escrow
    State public state;

    /// @notice Addresses of the buyer (deployer), seller and arbiter
    address payable public buyer;
    address payable public seller;
    address public arbiter;

    /// @notice Creates a new escrow contract.
    constructor(address _seller, address _arbiter) {
        buyer = payable(msg.sender);
        seller = payable(_seller);
        arbiter = _arbiter;
        state = State.CREATED;
    }

    /// @notice Emitted when the buyer deposits ETH into the escrow.
    event Deposited(address indexed buyer, uint256 amount);

    /// @notice Emitted when the buyer opens a dispute.
    event DisputeOpened(address indexed buyer);

    /// @notice Emitted when funds are released to the seller./
    event Released(address indexed seller, uint256 amount);

    /// @notice Emitted when funds are refunded to the buyer./
    event Reimbursed(address indexed buyer, uint256 amount);

    /// @dev Ensures that a uint256 value represents a boolean (0 or 1).
    modifier checkBoolean(uint256 releaseFunds) {
        require(releaseFunds == 0 || releaseFunds == 1, "Must be 0 or 1");
        _;
    }

    /**
     * @notice Deposits ETH into the escrow.
     * @dev Can only be called by the buyer in CREATED state.
     */
    function deposit() external payable {
        require(state == State.CREATED, "Invalid state");
        require(msg.sender == buyer, "Only buyer");
        require(msg.value > 0, "No ETH sent");

        state = State.FUNDED;
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @notice Releases the escrow funds to the seller.
     * @dev Can only be called by the buyer in FUNDED state.
     */
    function release() external {
        require(state == State.FUNDED, "Invalid state");
        require(msg.sender == buyer, "Only buyer");

        state = State.RELEASED;
        uint256 amount = address(this).balance;

        (bool success, ) = seller.call{value: amount}("");
        require(success, "ETH transfer failed");

        emit Released(seller, amount);
    }

    /**
     * @notice Opens a dispute.
     * @dev Can only be called by the buyer in FUNDED state.
     */
    function openDispute() external {
        require(state == State.FUNDED, "Invalid state");
        require(msg.sender == buyer, "Only buyer");

        state = State.DISPUTED;
        emit DisputeOpened(msg.sender);
    }

    /**
     * @notice Resolves a dispute and releases or refunds funds.
     * @param releaseFunds 1 to release funds to seller, 0 to refund buyer.
     * @dev Can only be called by the arbiter in DISPUTED state.
     */
    function releaseByArbiter(uint256 releaseFunds)
        external
        checkBoolean(releaseFunds)
    {
        require(state == State.DISPUTED, "Invalid state");
        require(msg.sender == arbiter, "Only arbiter");

        uint256 amount = address(this).balance;

        if (releaseFunds == 1) {
            state = State.RELEASED;
            (bool success, ) = seller.call{value: amount}("");
            require(success, "ETH transfer failed");

            emit Released(seller, amount);
        } else {
            state = State.REFUNDED;
            (bool success, ) = buyer.call{value: amount}("");
            require(success, "ETH transfer failed");

            emit Reimbursed(buyer, amount);
        }
    }
}
