# ShadowSphere

**A Private, Decentralized Social Network on Aleo Blockchain**

ShadowSphere is a privacy-first social platform built with the Leo programming language on the **Aleo blockchain**. It enables anonymous social interactions, private messaging, and value transfers—all while preserving user privacy through zero-knowledge cryptography.

[![Aleo](https://img.shields.io/badge/Aleo-Built%20on%20Aleo-blue)](https://aleo.org)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Testnet](https://img.shields.io/badge/Testnet-Deployed-orange)](https://testnet.explorer.provable.com/program/shadowsphere_social9.aleo)

## 📖 Overview

ShadowSphere revolutionizes social networking by bringing true privacy to Web3 social interactions. Unlike traditional social platforms where all data is visible, ShadowSphere leverages Aleo's zero-knowledge technology to create a social network where:

- **Your identity stays private** - No usernames or emails, just cryptographic identities
- **Your content is yours** - Posts can be encrypted and only shared with intended audiences
- **Your interactions are confidential** - Private messaging with end-to-end encryption
- **Your value transfers are secure** - Send gifts and tips with complete privacy
- **Your reputation is earned** - Build verified reputation through positive contributions

## ✨ Why ShadowSphere Matters

In today's digital landscape, social platforms have become the ultimate privacy paradox:

- **Data Exploitation** - Platforms mine your data for profit
- **Censorship** - Centralized control over content and accounts
- **Surveillance** - Every like, comment, and message is tracked
- **Identity Theft** - Personal information is constantly at risk
- **Shadow Bans** - Opaque moderation and account restrictions

**ShadowSphere solves these** by providing:
- **True anonymity** - No personal data collection
- **User sovereignty** - You control your content and identity
- **Cryptographic privacy** - Zero-knowledge proofs keep interactions private
- **Fair moderation** - Transparent, on-chain governance
- **Portable reputation** - Your reputation travels with you

### Perfect For:
- Privacy-conscious individuals
- Whistleblowers and activists
- Content creators seeking freedom
- Communities requiring anonymity
- Anyone tired of data exploitation

## 🚀 Key Features

### 🎭 **Anonymous Identity**
- **ZK-based Authentication** - Prove identity without revealing it
- **Unique Cryptographic Identities** - No emails, no phone numbers
- **Self-Sovereign** - Complete control over your digital presence
- **Recovery Options** - Secure account recovery mechanisms

### 📝 **Private Social Features**
- **Encrypted Posts** - Content visible only to intended audiences
- **Anonymous Interactions** - Like, comment, and share privately
- **Content Categories** - Organize posts without compromising privacy
- **Reputation System** - Earn verified status through positive engagement
- **Friendship Network** - Build private social graphs

### 💬 **Private Messaging**
- **End-to-End Encrypted** - Messages visible only to sender and receiver
- **Message Records** - Private message receipts stored on-chain
- **Read Receipts** - Know when messages are viewed
- **Message History** - Persistent, private conversation threads

### 🎁 **Gift System with USDCx**
- **Send Anonymous Gifts** - Transfer value without revealing identity
- **Platform Fee** - 2% fee supports ecosystem development
- **Gift Receipts** - Provable gift records
- **Claim Mechanism** - Secure gift claiming process
- **Real Value Transfer** - Integrated with USDCx stablecoin

### 👥 **Social Graph Management**
- **Private Friendships** - Build connections privately
- **Block System** - Control your social environment
- **Activity Tracking** - Monitor engagement without compromising privacy
- **Relationship Status** - Manage social connections on-chain

### 🛡️ **Verification & Trust**
- **Reputation-Based Verification** - Earn trust through activity
- **100 Reputation Threshold** - Minimum for verified status
- **Tamper-Proof Reputation** - On-chain, immutable reputation history
- **Anti-Sybil Measures** - Cryptographic prevention of fake accounts

### 🔧 **Admin Capabilities**
- **Fee Management** - Adjust platform fees
- **Ecosystem Fund** - Collected fees support development
- **Emergency Controls** - Admin functions for platform safety

## 🏗️ Architecture

### Core Components

#### **Data Structures**
```leo
// User Profile - Anonymous identity
UserProfile {
    public_key: address,
    reputation: u32,
    created_at: u32,
    is_verified: bool,
    is_registered: bool,
    balance: u128
}

// Post - Private content
Post {
    post_id: u32,
    author: address,
    content_hash: field,
    timestamp: u32,
    likes: u32,
    comments: u32,
    encrypted: bool,
    category: u8
}

// Private Message Record
record PrivateMessage {
    owner: address,
    message_id: field,
    from: address,
    to: address,
    content_hash: field,
    timestamp: u32,
    read: bool
}

// Gift Receipt
record GiftReceipt {
    owner: address,
    gift_id: field,
    sender: address,
    receiver: address,
    amount: u128,
    message_hash: field,
    timestamp: u32,
    claimed: bool
}
```

### Storage Mappings
```leo
users: address => UserProfile           // User registry
posts: u32 => Post                       // Content storage
comments: u32 => Comment                  // Comment storage
friendships: field => Friendship          // Social graph
user_activity: address => u32             // Activity tracking
total_users: u32 => u32                    // Platform statistics
```

## 📋 Program Functions

### User Management
| Function | Description | Access |
|----------|-------------|---------|
| `register()` | Create anonymous account | Public |
| `verify_login()` | ZK-based authentication | Registered Users |
| `verify_user()` | Earn verified status | Registered Users |

### Social Features
| Function | Description | Access |
|----------|-------------|---------|
| `create_post()` | Create encrypted/public post | Registered Users |
| `like_post()` | Like content anonymously | Registered Users |
| `add_comment()` | Comment on posts | Registered Users |
| `add_friend()` | Build private connections | Registered Users |
| `block_user()` | Block unwanted interactions | Registered Users |
| `remove_friend()` | Remove connections | Registered Users |

### Messaging
| Function | Description | Access |
|----------|-------------|---------|
| `send_message()` | Send private encrypted message | Registered Users |
| `receive_message()` | Receive private messages | Registered Users |

### Financial
| Function | Description | Access |
|----------|-------------|---------|
| `deposit()` | Add USDCx funds | Registered Users |
| `withdraw()` | Withdraw USDCx | Registered Users |
| `send_gift()` | Send anonymous gifts | Registered Users |
| `claim_gift()` | Claim received gifts | Registered Users |

### Admin
| Function | Description | Access |
|----------|-------------|---------|
| `admin_withdraw_fees()` | Withdraw platform fees | Admin Only |
| `is_admin()` | Check admin status | Public |

## 🔒 Privacy Guarantees

ShadowSphere ensures privacy through multiple layers:

1. **Identity Privacy**
   - No usernames or emails stored
   - All identities are cryptographic addresses
   - Zero-knowledge proofs for authentication

2. **Content Privacy**
   - Content stored as hashes only
   - Optional encryption for sensitive posts
   - Private by default, public by choice

3. **Interaction Privacy**
   - Private message records
   - Anonymous likes and comments
   - Hidden social graph relationships

4. **Value Privacy**
   - Gift amounts visible only to participants
   - Private gift messages
   - Anonymous value transfer

## 🚦 Getting Started

### Prerequisites
- [Leo CLI](https://github.com/ProvableHQ/leo) installed
- Aleo account with testnet credits
- Basic understanding of Aleo blockchain

### Deployment

```bash
# Clone the repository
git clone https://github.com/yourusername/shadowsphere.git
cd shadowsphere

# Deploy to testnet
leo deploy --network testnet
```

### Interaction Examples

```bash
# Register a new user
leo execute register --broadcast

# Verify login
leo execute verify_login [identity_hash]field

# Create a post
leo execute create_post [content_hash]field [encrypted] [category]u8

# Send a gift
leo execute send_gift [receiver_address] [amount]u128 [message_hash]field [timer]u32

# Add a friend
leo execute add_friend [friend_address]
```

## 📊 Platform Statistics

| Metric | Value |
|--------|-------|
| Max Categories | 10 |
| Min Deposit | 1,000,000 USDCx |
| Platform Fee | 2% |
| Verification Threshold | 100 Reputation |
| Reputation per Post | +3 |
| Reputation per Comment | +2 |
| Reputation per Like | +1 |
| Reputation per Gift | +5 |

## 🗺️ Roadmap

### Phase 1: Foundation ✅
- [x] Core smart contract implementation
- [x] USDCx integration
- [x] Basic social features
- [x] Private messaging

### Phase 2: Enhanced Privacy (Building...) 🚧
- [ ] End-to-end encryption for all messages
- [ ] Zero-knowledge proof verification
- [ ] Anonymous group chats
- [ ] Private content feeds

### Phase 3: Community Features (Not Yet...) 🔮
- [ ] DAO governance
- [ ] Community moderation
- [ ] Token-gated content
- [ ] NFT integration for profiles

## FLOWCHART
<img width="8558" height="4326" alt="ShadowSphere Web3 Social Network Flowchart" src="https://github.com/user-attachments/assets/fbfd8126-63b4-49aa-9f8d-4bc1965c7810" />


## 🤝 Contributing

We welcome contributions! Whether it's:
- Bug fixes
- Feature enhancements
- Documentation improvements
- Security audits

Please see our [Contributing Guidelines](CONTRIBUTING.md) for more details.

## 🔐 Security

ShadowSphere prioritizes security:
- `@noupgrade` ensures contract immutability
- Comprehensive assertions prevent invalid states
- Future-based async operations prevent race conditions
- Cryptographic hashing for all sensitive data

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Aleo Team** - For the amazing zero-knowledge blockchain
- **USDCx** - For stablecoin integration
- **Leo Language** - For making ZK development accessible
- **Community** - For feedback and support

## 📞 Other Links

- **GitHub**: [Issues](https://github.com/yourusername/shadowsphere/issues)
- **Youtube**:

## ⚡ Quick Links

- [Testnet Explorer](https://testnet.explorer.provable.com/program/shadowsphere_social9.aleo)
- [Aleo Documentation](https://developer.aleo.org)
- [Leo Language Guide](https://developer.aleo.org/leo)

---

**Built with 💜 on Aleo | Privacy is not a feature, it's a right**
