// Awesome Anonymous Social Network - "ShadowSphere"
// Private, decentralized social platform with USDCx integration
import test_usdcx_stablecoin.aleo;

program shadowsphere_social16.aleo {
    @noupgrade
    async constructor() {}

    // ==============================================
    // DATA STRUCTURES
    // ==============================================

    // Privacy: Removed 'public_key' from struct.
    // The mapping key (hashed address) acts as the identity.
    struct UserProfile {
        reputation: u32,
        created_at: u32,
        is_verified: bool,
        is_registered: bool,
        balance: u128
    }

    struct Post {
        post_id: u32,
        // Privacy: Author is stored as a hash
        author_hash: field, 
        content_hash: field,
        timestamp: u32,
        likes: u32,
        comments: u32,
        encrypted: bool,
        category: u8
    }

    struct Comment {
        comment_id: u32,
        post_id: u32,
        author_hash: field,
        content_hash: field,
        timestamp: u32
    }

    struct Friendship {
        user_a_hash: field,
        user_b_hash: field,
        status: u8,
        since: u32
    }

    record PrivateMessage {
        owner: address,
        message_id: field,
        from: address,
        to: address,
        content_hash: field,
        timestamp: u32,
        read: bool
    }

    record GiftReceipt {
        owner: address,
        gift_id: field,
        sender_hash: field, // Anonymized sender
        receiver: address,  // Receiver needs to be address to receive tokens
        amount: u128,
        message_hash: field,
        timestamp: u32,
        claimed: bool
    }

    record UserSecret {
        owner: address,
        identity_hash: field,
    }

    record FriendKey {
        owner: address,
        key_id: field,
        from_hash: field,
        to_hash: field
    }

    // ==============================================
    // STORAGE MAPPINGS
    // ==============================================

    // Privacy: Keys are now hashed fields, not addresses
    mapping users: field => UserProfile;
    mapping posts: u32 => Post;
    mapping comments: u32 => Comment;
    mapping friendships: field => Friendship;
    
    // Privacy: Tracking counts by hash
    mapping user_post_counts: field => u32; 
    mapping post_comment_counts: u32 => u32;
    
    mapping user_activity: field => u32;
    mapping message_activity: field => u32;
    
    mapping total_users: u32 => u32;
    mapping total_posts: u32 => u32;
    mapping total_comments: u32 => u32;

    mapping post_likes: field => bool;  

    // ==============================================
    // CONSTANTS
    // ==============================================

    const ADMIN: address = aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h;
    const PLATFORM_FEE: u128 = 100000u128;
    const MIN_DEPOSIT: u128 = 1000000u128;
    const VERIFICATION_THRESHOLD: u32 = 100u32;

    // ==============================================
    // USER REGISTRATION & LOGIN
    // ==============================================

    async transition register(
    ) -> (UserSecret, Future) {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        
        return (UserSecret {
            owner: caller,
            identity_hash: caller_hash
        }, finalize_registration(caller_hash));
    }

    // Privacy: Finalize takes 'field' (hash), not 'address'
    async function finalize_registration(
        caller_hash: field
    ) {
        let user_count: u32 = Mapping::get_or_use(total_users, 0u32, 0u32);
        Mapping::set(total_users, 0u32, user_count + 1u32);

        let profile: UserProfile = Mapping::get_or_use(users, caller_hash, UserProfile{
            reputation: 0u32,
            created_at: 0u32,
            is_verified: false,
            is_registered: false,
            balance: 0u128
        });

        assert(profile.is_registered == false);

        Mapping::set(users, caller_hash, UserProfile {
            reputation: 0u32,
            created_at: block.height,
            is_verified: false,
            is_registered: true,
            balance: 0u128
        });
        Mapping::set(user_activity, caller_hash, block.height);
    }

    async transition verify_login(
        identity_hash: field
    ) -> Future {
        let caller: address = self.caller; 
        let computed_identity: field = BHP256::hash_to_field(caller as field);
        assert(computed_identity == identity_hash);
    
        return finalize_verify_login(identity_hash);
    }

    async function finalize_verify_login(
        user_hash: field
    ) {
        let profile: UserProfile = Mapping::get(users, user_hash);
        assert(profile.is_registered == true);
        Mapping::set(user_activity, user_hash, block.height);
    }


    // ==============================================
    // FINANCIAL OPERATIONS
    // ==============================================

    async transition deposit(amount: u128) -> Future {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        
        assert(amount >= MIN_DEPOSIT);
        let deposit_future: Future = test_usdcx_stablecoin.aleo/transfer_public_as_signer(self.address, amount);
        return finalize_deposit(caller_hash, amount, deposit_future);
    }

    async function finalize_deposit(caller_hash: field, amount: u128, deposit_future: Future) {
        deposit_future.await();
        
        let user: UserProfile = Mapping::get(users, caller_hash);
        let new_balance: u128 = user.balance + amount;
        
        Mapping::set(users, caller_hash, UserProfile {
            reputation: user.reputation,
            created_at: user.created_at,
            is_verified: user.is_verified,
            is_registered: user.is_registered,
            balance: new_balance
        });
    }

    async transition withdraw(amount: u128) -> Future {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        
        let withdraw_future: Future = test_usdcx_stablecoin.aleo/transfer_public(caller, amount);
        return finalize_withdraw(caller_hash, amount, withdraw_future);
    }

    async function finalize_withdraw(caller_hash: field, amount: u128, withdraw_future: Future) {
        let user: UserProfile = Mapping::get(users, caller_hash);
        assert(user.balance >= amount);
        
        withdraw_future.await();
        
        Mapping::set(users, caller_hash, UserProfile {
            reputation: user.reputation,
            created_at: user.created_at,
            is_verified: user.is_verified,
            is_registered: user.is_registered,
            balance: user.balance - amount
        });
    } 

    // ==============================================
    // SOCIAL FEATURES 
    // ==============================================

    async transition create_post(
        public content_hash: field,
        public encrypted: bool,
        public category: u8
    ) -> Future {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        
        return finalize_create_post(caller_hash, content_hash, encrypted, category);
    }

    async function finalize_create_post(
        author_hash: field,
        content_hash: field,
        encrypted: bool,
        category: u8
    ) {
        let profile: UserProfile = Mapping::get(users, author_hash);
        assert(profile.is_registered == true);

        assert(category <= 10u8); 
        assert(content_hash != 0field);

        let post_id: u32 = Mapping::get_or_use(total_posts, 0u32, 0u32) + 1u32;
        Mapping::set(total_posts, 0u32, post_id);
        
        let current_count: u32 = Mapping::get_or_use(user_post_counts, author_hash, 0u32);
        Mapping::set(user_post_counts, author_hash, current_count + 1u32);

        let post: Post = Post {
            post_id: post_id,
            author_hash: author_hash,
            content_hash: content_hash,
            timestamp: block.height,
            likes: 0u32,
            comments: 0u32,
            encrypted: encrypted,
            category: category
        };

        Mapping::set(posts, post_id, post);
        
        Mapping::set(users, author_hash, UserProfile {
            reputation: profile.reputation + 3u32,
            created_at: profile.created_at,
            is_verified: profile.is_verified,
            is_registered: profile.is_registered,
            balance: profile.balance
        });
    }

    async transition like_post(post_id: u32) -> Future {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        return finalize_like_post(caller_hash, post_id);
    }

    async function finalize_like_post(caller_hash: field, post_id: u32) {
        let profile: UserProfile = Mapping::get(users, caller_hash);
        assert(profile.is_registered == true);

        let like_key: field = BHP256::hash_to_field(post_id as field + caller_hash);
        let already_liked: bool = Mapping::get_or_use(post_likes, like_key, false);
        assert(already_liked == false); 

        let post: Post = Mapping::get(posts, post_id);
        
        // Privacy: We can update the author's reputation using their hash found in the post
        let author_hash: field = post.author_hash;
        
        Mapping::set(posts, post_id, Post {
            post_id: post.post_id,
            author_hash: author_hash,
            content_hash: post.content_hash,
            timestamp: post.timestamp,
            likes: post.likes + 1u32,
            comments: post.comments,
            encrypted: post.encrypted,
            category: post.category
        });

        let author_user: UserProfile = Mapping::get(users, author_hash);
        Mapping::set(users, author_hash, UserProfile {
            reputation: author_user.reputation + 1u32,
            created_at: author_user.created_at,
            is_verified: author_user.is_verified,
            is_registered: author_user.is_registered,
            balance: author_user.balance
        });
    }

    async transition add_comment(
        public post_id: u32,
        public content_hash: field
    ) -> Future {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        
        return finalize_add_comment(caller_hash, post_id, content_hash);
    }

    async function finalize_add_comment(
        author_hash: field,
        post_id: u32,
        content_hash: field
    ) {   
        let user: UserProfile = Mapping::get(users, author_hash);
        assert(user.is_registered == true);   

        let comment_id: u32 = Mapping::get_or_use(total_comments, 0u32, 0u32) + 1u32;
        Mapping::set(total_comments, 0u32, comment_id);

        let comment_count: u32 = Mapping::get_or_use(post_comment_counts, post_id, 0u32);
        Mapping::set(post_comment_counts, post_id, comment_count + 1u32);

        let comment: Comment = Comment {
            comment_id: comment_id,
            post_id: post_id,
            author_hash: author_hash,
            content_hash: content_hash,
            timestamp: block.height
        };

        Mapping::set(comments, comment_id, comment);

        let post: Post = Mapping::get(posts, post_id);
        Mapping::set(posts, post_id, Post {
            post_id: post.post_id,
            author_hash: post.author_hash,
            content_hash: post.content_hash,
            timestamp: post.timestamp,
            likes: post.likes,
            comments: post.comments + 1u32,
            encrypted: post.encrypted,
            category: post.category
        });

        Mapping::set(users, author_hash, UserProfile {
            reputation: user.reputation + 2u32,
            created_at: user.created_at,
            is_verified: user.is_verified,
            is_registered: user.is_registered,
            balance: user.balance
        });
    }

    // ==============================================
    // PRIVATE MESSAGING
    // ==============================================

    async transition send_message(
        private receiver: address,
        private content_hash: field,
        private timer: u32
    ) -> (PrivateMessage, PrivateMessage, Future) {
        let sender: address = self.caller;
        let sender_hash: field = BHP256::hash_to_field(sender as field);
        let receiver_hash: field = BHP256::hash_to_field(receiver as field);

        let message_id: field = BHP256::hash_to_field(sender_hash + receiver_hash + content_hash +  timer as field);
        
        let sender_message: PrivateMessage = PrivateMessage {
            owner: sender,
            message_id: message_id,
            from: sender,
            to: receiver,
            content_hash: content_hash,
            timestamp: timer,
            read: true
        };
        
        let receiver_message: PrivateMessage = PrivateMessage {
            owner: receiver,
            message_id: message_id,
            from: sender,
            to: receiver,
            content_hash: content_hash,
            timestamp: timer,
            read: false
        };
        
        return (sender_message, receiver_message, finalize_send_message(sender_hash, receiver_hash));
    }

    async function finalize_send_message(
        sender_hash: field,
        receiver_hash: field
    ) {
        let profile: UserProfile = Mapping::get(users, sender_hash);
        assert(profile.is_registered == true); 
        Mapping::set(message_activity, sender_hash, block.height);
        Mapping::set(message_activity, receiver_hash, block.height);
    }

    // ==============================================
    // GIFT SYSTEM
    // ==============================================

    async transition send_gift(
        public receiver: address,
        public amount: u128,
        public message_hash: field, 
        public timer: u32,
    ) -> (GiftReceipt, GiftReceipt, Future) {
        let sender: address = self.caller;
        let sender_hash: field = BHP256::hash_to_field(sender as field);

        let gift_id: field = BHP256::hash_to_field(sender_hash + BHP256::hash_to_field(receiver as field) + amount as field + message_hash);
    
        let net_amount: u128 = amount;
        
        let sender_receipt: GiftReceipt = GiftReceipt {
            owner: sender,
            gift_id: gift_id,
            sender_hash: sender_hash,
            receiver: receiver,
            amount: net_amount,
            message_hash: message_hash,
            timestamp: timer,
            claimed: true
        };
        
        let receiver_receipt: GiftReceipt = GiftReceipt {
            owner: receiver,
            gift_id: gift_id,
            sender_hash: sender_hash,
            receiver: receiver,
            amount: net_amount,
            message_hash: message_hash,
            timestamp: timer,
            claimed: false
        };
        
        let final_transfer_amt: u128 = amount - PLATFORM_FEE;
        
        let transfer_to_receiver: Future = test_usdcx_stablecoin.aleo/transfer_public_as_signer(receiver, final_transfer_amt);
        let transfer_to_admin: Future = test_usdcx_stablecoin.aleo/transfer_public_as_signer(ADMIN, PLATFORM_FEE);
        
        return (sender_receipt, receiver_receipt, finalize_send_gift(sender_hash, amount, final_transfer_amt, transfer_to_receiver, transfer_to_admin));
    }

    async function finalize_send_gift(sender_hash: field, gross_amount: u128, net_amount: u128, transfer_to_receiver: Future, transfer_to_admin: Future) {
        let profile: UserProfile = Mapping::get(users, sender_hash);
        assert(profile.is_registered == true);

        assert(profile.balance >= gross_amount);
        assert(profile.balance >= gross_amount + PLATFORM_FEE);

        transfer_to_receiver.await();
        transfer_to_admin.await();
       
        // Deduct from internal balance using only the hash
        Mapping::set(users, sender_hash, UserProfile {
            reputation: profile.reputation + 5u32,
            created_at: profile.created_at,
            is_verified: profile.is_verified,
            is_registered: profile.is_registered,
            balance: profile.balance - gross_amount
        });
    }

    transition claim_gift(private gift_receipt: GiftReceipt) -> (GiftReceipt, bool) {
        let caller: address = self.caller;
        
        let valid_owner: bool = gift_receipt.owner == caller;
        let not_claimed: bool = !gift_receipt.claimed;
        assert(valid_owner && not_claimed);
        
        return (GiftReceipt {
            owner: gift_receipt.owner,
            gift_id: gift_receipt.gift_id,
            sender_hash: gift_receipt.sender_hash,
            receiver: gift_receipt.receiver,
            amount: gift_receipt.amount,
            message_hash: gift_receipt.message_hash,
            timestamp: gift_receipt.timestamp,
            claimed: true
        }, true);
    }

    // ==============================================
    // FOLLOWER / FRIENDSHIP
    // ==============================================

    async transition add_friend(public friend: address) -> (FriendKey,  FriendKey, Future) {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        let friend_hash: field = BHP256::hash_to_field(friend as field);

        // Using ternary operator for ordering
        let hash_a: field = caller_hash < friend_hash ? caller_hash : friend_hash;
        let hash_b: field = caller_hash < friend_hash ? friend_hash : caller_hash;
        let key: field = BHP256::hash_to_field(hash_a + hash_b);
        
        let send_request: FriendKey = FriendKey {
            owner: caller,
            key_id: key,
            from_hash: caller_hash,
            to_hash: friend_hash,
        };
        
        let receive_request: FriendKey = FriendKey {
            owner: friend,
            key_id: key,
            from_hash: caller_hash,
            to_hash: friend_hash,
        };
        
        return (send_request, receive_request, finalize_add_friend(caller_hash, friend_hash));
    }

    async function finalize_add_friend(caller_hash: field, friend_hash: field) {        
        let profile: UserProfile = Mapping::get(users, caller_hash);
        assert(profile.is_registered == true);
        assert(caller_hash != friend_hash);

        // Using ternary operator for ordering
        let hash_a: field = caller_hash < friend_hash ? caller_hash : friend_hash;
        let hash_b: field = caller_hash < friend_hash ? friend_hash : caller_hash;
        let key: field = BHP256::hash_to_field(hash_a + hash_b);
        
        let existing: Friendship = Mapping::get_or_use(friendships, key, Friendship {
            user_a_hash: 0field,
            user_b_hash: 0field,
            status: 0u8,
            since: 0u32
        });

        assert(existing.status == 0u8);
        
        let friendship: Friendship = Friendship {
            user_a_hash: hash_a,
            user_b_hash: hash_b,
            status: 1u8,    
            since: block.height
        };
        
        Mapping::set(friendships, key, friendship);
        Mapping::set(user_activity, caller_hash, block.height);
        Mapping::set(user_activity, friend_hash, block.height);
    }

    async transition block_user(public user_to_block: address) -> Future {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        let block_hash: field = BHP256::hash_to_field(user_to_block as field);
                
        return finalize_block_user(caller_hash, block_hash);
    }

    async function finalize_block_user(caller_hash: field, block_hash: field) {
        let profile: UserProfile = Mapping::get(users, caller_hash);
        assert(profile.is_registered == true);
        assert(caller_hash != block_hash);

        // Using ternary operator for ordering
        let hash_a: field = caller_hash < block_hash ? caller_hash : block_hash;
        let hash_b: field = caller_hash < block_hash ? block_hash : caller_hash;
        let key: field = BHP256::hash_to_field(hash_a + hash_b);
        
        let friendship: Friendship = Friendship {
            user_a_hash: hash_a,
            user_b_hash: hash_b,
            status: 2u8,    
            since: block.height
        };
        
        Mapping::set(friendships, key, friendship);
    }

    async transition remove_friend(public friend: address) -> Future {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        let friend_hash: field = BHP256::hash_to_field(friend as field);
                
        return finalize_remove_friend(caller_hash, friend_hash);
    }

    async function finalize_remove_friend(caller_hash: field, friend_hash: field) {
        let profile: UserProfile = Mapping::get(users, caller_hash);
        assert(profile.is_registered == true);
        
        // Using ternary operator for ordering
        let hash_a: field = caller_hash < friend_hash ? caller_hash : friend_hash;
        let hash_b: field = caller_hash < friend_hash ? friend_hash : caller_hash;
        let key: field = BHP256::hash_to_field(hash_a + hash_b);
        
        let existing: Friendship = Mapping::get(friendships, key);
        assert(existing.status != 0u8);
        
        Mapping::remove(friendships, key);
    }

    // ==============================================
    // VERIFICATION
    // ==============================================

    async transition verify_user() -> Future {
        let caller: address = self.caller;
        let caller_hash: field = BHP256::hash_to_field(caller as field);
        return finalize_verify_user(caller_hash);
    }

    async function finalize_verify_user(user_hash: field) {
        let user_data: UserProfile = Mapping::get(users, user_hash);
        assert(user_data.reputation >= VERIFICATION_THRESHOLD);
        
        Mapping::set(users, user_hash, UserProfile {
            reputation: user_data.reputation,
            created_at: user_data.created_at,
            is_verified: true,
            is_registered: user_data.is_registered,
            balance: user_data.balance
        });
    }

    // ==============================================
    // ADMIN FUNCTIONS
    // ==============================================

    async transition admin_withdraw_fees(amount: u128) -> Future {
        let caller: address = self.caller;
        assert(caller == ADMIN);
        
        let withdraw_future: Future = test_usdcx_stablecoin.aleo/transfer_public(ADMIN, amount);
        return finalize_admin_withdraw(withdraw_future);
    }

    async function finalize_admin_withdraw(withdraw_future: Future) {
        withdraw_future.await();
    }

    transition is_admin(public user_address: address) -> bool {
        return user_address == ADMIN;
    }
}
