# blockchain
Escrow Arrangement
# EscrowArrangement Smart Contract

## 📌 Overview

`EscrowArrangement` is a simple Ethereum smart contract that implements an escrow mechanism between a **buyer** and a **seller**, with optional **arbitration** in case of disputes.

The contract follows a **state machine pattern** to ensure that funds are only released or refunded under well-defined conditions.

This project was built as a learning exercise and portfolio piece to demonstrate Solidity fundamentals, contract design, and best practices.

---

## 🧠 Key Concepts Demonstrated

- Solidity `0.8.x`
- State machine design
- Escrow logic
- Role-based access control
- Events and off-chain observability
- NatSpec documentation
- Checks-Effects-Interactions pattern

---

## 👥 Roles

- **Buyer**  
  Deploys the contract and deposits ETH.

- **Seller**  
  Receives the funds once the buyer confirms delivery.

- **Arbiter**  
  Resolves disputes by deciding whether funds are released to the seller or refunded to the buyer.

---

## 🔄 Escrow Lifecycle

1. **CREATED**  
   Contract deployed by the buyer.

2. **FUNDED**  
   Buyer deposits ETH into the contract.

3. **DISPUTED** *(optional)*  
   Buyer opens a dispute.

4. **RELEASED**  
   Funds are sent to the seller.

5. **REFUNDED**  
   Funds are refunded to the buyer.

---

## ⚙️ Contract Functions

### `deposit()`
Deposits ETH into the escrow.  
- Callable only by the buyer  
- Moves state from `CREATED` → `FUNDED`

### `release()`
Releases funds to the seller.  
- Callable only by the buyer  
- Moves state from `FUNDED` → `RELEASED`

### `openDispute()`
Opens a dispute.  
- Callable only by the buyer  
- Moves state from `FUNDED` → `DISPUTED`

### `releaseByArbiter(uint256 releaseFunds)`
Resolves a dispute.  
- Callable only by the arbiter  
- `releaseFunds = 1` → funds released to seller  
- `releaseFunds = 0` → funds refunded to buyer

---

## 📣 Events

- `Deposited`
- `DisputeOpened`
- `Released`
- `Reimbursed`

Events enable easy tracking of contract activity from off-chain services such as frontends or indexers.

---

## 🛡️ Security Considerations

- Uses Solidity `0.8.x` (built-in overflow checks)
- Explicit state validation for every function
- Follows the Checks-Effects-Interactions pattern
- Prevents invalid boolean input via a custom modifier

> This contract is **not audited** and is intended for educational purposes only.

---

## 🚀 Possible Improvements

- Support ERC20 tokens instead of ETH
- Add time-based auto-release or auto-refund
- Allow seller-initiated disputes
- Use custom errors instead of revert strings
- Add unit tests (Hardhat / Foundry)

---

## 📄 License

LGPL-3.0-only
