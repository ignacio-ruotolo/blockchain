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

stateDiagram-v2
    direction LR

    [*] --> CREATED

    CREATED --> FUNDED : deposit()
    FUNDED --> RELEASED : release()
    FUNDED --> DISPUTED : openDispute()
    DISPUTED --> RELEASED : releaseByArbiter(1)
    DISPUTED --> REFUNDED : releaseByArbiter(0)

    RELEASED --> [*]
    REFUNDED --> [*]

    %% State styling
    classDef initial fill:#E3F2FD,stroke:#1E88E5,stroke-width:2px
    classDef funded fill:#E8F5E9,stroke:#43A047,stroke-width:2px
    classDef dispute fill:#FFF3E0,stroke:#FB8C00,stroke-width:2px
    classDef success fill:#E0F2F1,stroke:#00897B,stroke-width:2px
    classDef refund fill:#FCE4EC,stroke:#C2185B,stroke-width:2px

    class CREATED initial
    class FUNDED funded
    class DISPUTED dispute
    class RELEASED success
    class REFUNDED refund

    %% Notes
    note right of FUNDED
        Funds locked in escrow
    end note

    note right of DISPUTED
        Arbiter decision required
    end note

    note right of RELEASED
        Seller receives ETH
    end note

    note right of REFUNDED
        Buyer refunded
    end note
``

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
