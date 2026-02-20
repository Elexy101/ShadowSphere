// Awesome Anonymous Social Network - "ShadowSphere"
// Private, decentralized social platform with USDCx integration
import test_usdcx_stablecoin.aleo;

program shadowsphere_social12.aleo {
    @noupgrade
    async constructor() {}

    // ==============================================
    // DATA STRUCTURES
    // ==============================================

    struct UserProfile {
        public_key: address,
        reputation: u32,
        created_at: u32,
        is_verified: bool,
        is_registered: bool,
        balance: u128
    }

    struct Post {
        post_id: u32,
        author: address,
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
        author: address,
        content_hash: field,
        timestamp: u32
    }

    struct Friendship {
        user_a: address,
        user_b: address,
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
        sender: address,
        receiver: address,
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
        from: address,
        to: address
    }

    // ==============================================
    // STORAGE MAPPINGS
    // ==============================================

    mapping users: address => UserProfile;
    mapping posts: u32 => Post;
    mapping comments: u32 => Comment;
    mapping friendships: field => Friendship;
    
    mapping user_posts: address => u32;
    mapping post_comments: u32 => u32;
    mapping user_activity: address => u32;
    mapping message_activity: address => u32;
    
    mapping total_users: u32 => u32;
    mapping total_posts: u32 => u32;
    mapping total_comments: u32 => u32;

    // ==============================================
    // CONSTANTS
    // ==============================================

    const ADMIN: address = aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h;
    const PLATFORM_FEE: u8 = 2u8;
    const MIN_DEPOSIT: u128 = 1000000u128;
    const VERIFICATION_THRESHOLD: u32 = 100u32;
    //const DEFAULT_TIMESTAMP: u32 = 0u32;y

    // ==============================================
    // USER REGISTRATION & LOGIN
    // ==============================================

    async transition register(
    ) -> (UserSecret, Future) {

        //checks for self.caller
        let caller: address = self.caller;
        
        return (UserSecret {
            owner: caller,
            identity_hash: BHP256::hash_to_field(caller as field)
        }, finalize_registration(caller));
    }

    async function finalize_registration(
        caller: address
    ) {
        let user_count: u32 = Mapping::get_or_use(total_users, 0u32, 0u32);
        Mapping::set(total_users, 0u32, user_count + 1u32);

        let profile: UserProfile = Mapping::get_or_use(users, caller, UserProfile{
            public_key: caller,
            reputation: 0u32,
            created_at: block.height,
            is_verified: false,
            is_registered: false,
            balance: 0u128
        });

        //checks  for  double registration
        assert(profile.is_registered == false);

        Mapping::set(users, profile.public_key, UserProfile {
            public_key: caller,
            reputation: 0u32,
            created_at: block.height,
            is_verified: false,
            is_registered: true,
            balance: 0u128
        });
        Mapping::set(user_activity, profile.public_key, block.height);
    }

    // 🔐 Login verification
    async transition verify_login(
        identity_hash: field
    ) -> Future {
        let caller: address = self.caller; 

        let computed_identity: field = BHP256::hash_to_field(caller as field);

        // Verify the identity matches
        let is_correct: bool = (computed_identity == identity_hash);
        assert(is_correct);
    
        return finalize_verify_login(self.caller);
    }

    async function finalize_verify_login(
        user: address
    ) {
        // Get user profile
        let profile: UserProfile = Mapping::get(users, user);
        assert(profile.is_registered == true);
    
        // Update last login activity
        Mapping::set(user_activity, user, block.height);
    }


    // ==============================================
    // FINANCIAL OPERATIONS
    // ==============================================

    async transition deposit(amount: u128) -> Future {
        let caller: address = self.caller;
        assert(amount >= MIN_DEPOSIT);
        
        let deposit_future: Future = test_usdcx_stablecoin.aleo/transfer_public_as_signer(self.address, amount);
        return finalize_deposit(caller, amount, deposit_future);
    }

    async function finalize_deposit(caller: address, amount: u128, deposit_future: Future) {
        deposit_future.await();
        
        let user: UserProfile = Mapping::get(users, caller);
        let new_balance: u128 = user.balance + amount;
        
        Mapping::set(users, caller, UserProfile {
            public_key: user.public_key,
            reputation: user.reputation,
            created_at: user.created_at,
            is_verified: user.is_verified,
            is_registered: user.is_registered,
            balance: new_balance
        });
    }

    async transition withdraw(amount: u128) -> Future {
        let caller: address = self.caller;
        
        let withdraw_future: Future = test_usdcx_stablecoin.aleo/transfer_public(caller, amount);
        return finalize_withdraw(caller, amount, withdraw_future);
    }

    async function finalize_withdraw(caller: address, amount: u128, withdraw_future: Future) {
        withdraw_future.await();
        
        let user: UserProfile = Mapping::get(users, caller);
        assert(user.balance >= amount);
        
        // Update balance first
        Mapping::set(users, caller, UserProfile {
            public_key: user.public_key,
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
        
        return finalize_create_post(caller, content_hash, encrypted, category);
    }

    async function finalize_create_post(
        author: address,
        content_hash: field,
        encrypted: bool,
        category: u8
    ) {
        // Get caller's username
        let profile: UserProfile = Mapping::get(users, author);
        assert(profile.is_registered == true);

        //Check input validations
        assert(category <= 10u8); // Max 10 categories
        assert(content_hash != 0field);

        let post_id: u32 = Mapping::get_or_use(total_posts, 0u32, 0u32) + 1u32;
        Mapping::set(total_posts, 0u32, post_id);
        Mapping::set(user_posts, author, post_id);

        let post: Post = Post {
            post_id: post_id,
            author: author,
            content_hash: content_hash,
            timestamp: block.height,
            likes: 0u32,
            comments: 0u32,
            encrypted: encrypted,
            category: category
        };

        //check post existence
        assert(post.post_id != 0u32);

        Mapping::set(posts, post_id, post);
        
        let user: UserProfile = Mapping::get(users, author);
        Mapping::set(users, author, UserProfile {
            public_key: user.public_key,
            reputation: user.reputation + 3u32,
            created_at: user.created_at,
            is_verified: user.is_verified,
            is_registered: user.is_registered,
            balance: user.balance
        });
    }

    async transition like_post(post_id: u32) -> Future {
        let caller: address = self.caller;
        return finalize_like_post(caller, post_id);
    }

    async function finalize_like_post(caller: address, post_id: u32) {
        // Get caller's username
        let profile: UserProfile = Mapping::get(users, caller);
        assert(profile.is_registered == true);

        let post: Post = Mapping::get(posts, post_id);
        
        Mapping::set(posts, post_id, Post {
            post_id: post.post_id,
            author: post.author,
            content_hash: post.content_hash,
            timestamp: post.timestamp,
            likes: post.likes + 1u32,
            comments: post.comments,
            encrypted: post.encrypted,
            category: post.category
        });

        let author_user: UserProfile = Mapping::get(users, post.author);
        Mapping::set(users, post.author, UserProfile {
            public_key: author_user.public_key,
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
        
        return finalize_add_comment(caller, post_id, content_hash);
    }

    async function finalize_add_comment(
        author: address,
        post_id: u32,
        content_hash: field
    ) {   

        let user: UserProfile = Mapping::get(users, author);
        assert(user.is_registered == true);   

        let comment_id: u32 = Mapping::get_or_use(total_comments, 0u32, 0u32) + 1u32;

        Mapping::set(total_comments, 0u32, comment_id);
        Mapping::set(post_comments, post_id, comment_id);

        let comment: Comment = Comment {
            comment_id: comment_id,
            post_id: post_id,
            author: author,
            content_hash: content_hash,
            timestamp: block.height
        };

        Mapping::set(comments, comment_id, comment);

        let post: Post = Mapping::get(posts, post_id);
        Mapping::set(posts, post_id, Post {
            post_id: post.post_id,
            author: post.author,
            content_hash: post.content_hash,
            timestamp: post.timestamp,
            likes: post.likes,
            comments: post.comments + 1u32,
            encrypted: post.encrypted,
            category: post.category
        });

        let commenter: UserProfile = Mapping::get(users, author);
        Mapping::set(users, author, UserProfile {
            public_key: commenter.public_key,
            reputation: commenter.reputation + 2u32,
            created_at: commenter.created_at,
            is_verified: commenter.is_verified,
            is_registered: commenter.is_registered,
            balance: commenter.balance
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

        //generate the message id
        let message_id: field = BHP256::hash_to_field(sender as field + receiver as field + content_hash +  timer as field);
        
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
        
        return (sender_message, receiver_message, finalize_send_message(sender, receiver));
    }

    async function finalize_send_message(
        sender: address,
        receiver: address,
    ) {
        // Get caller's username
        let profile: UserProfile = Mapping::get(users, sender);
        assert(profile.is_registered == true); 

        Mapping::set(message_activity, sender, block.height);
        Mapping::set(message_activity, receiver, block.height);
    }

    // ==============================================
    // GIFT SYSTEM - AWESOME AND SIMPLE
    // ==============================================

    async transition send_gift(
        public receiver: address,
        public amount: u128,
        public message_hash: field, 
        public timer: u32,
    ) -> (GiftReceipt, GiftReceipt, Future) {
        let sender: address = self.caller;
        
        assert(amount > 0u128);

        //generate the gift id
        let gift_id: field = BHP256::hash_to_field(sender as field + receiver as field + amount as field + message_hash);
    
        let fee: u128 = 100000u128; //0.1 usdcx fee for every gift transaction
        let net_amount: u128 = amount - fee;
        
        let sender_receipt: GiftReceipt = GiftReceipt {
            owner: sender,
            gift_id: gift_id,
            sender: sender,
            receiver: receiver,
            amount: net_amount,
            message_hash: message_hash,
            timestamp: timer,
            claimed: true
        };
        
        let receiver_receipt: GiftReceipt = GiftReceipt {
            owner: receiver,
            gift_id: gift_id,
            sender: sender,
            receiver: receiver,
            amount: net_amount,
            message_hash: message_hash,
            timestamp: timer,
            claimed: false
        };
        
        let transfer_to_receiver: Future = test_usdcx_stablecoin.aleo/transfer_public_as_signer(receiver, net_amount);
        let transfer_to_admin: Future = test_usdcx_stablecoin.aleo/transfer_public_as_signer(ADMIN, fee);
        
        return (sender_receipt, receiver_receipt, finalize_receiver_withdraw(sender, receiver, amount, net_amount, transfer_to_receiver, transfer_to_admin));
    }

    async function finalize_receiver_withdraw(sender: address, receiver: address, amount: u128, net_amount: u128, transfer_to_receiver: Future, transfer_to_admin: Future) {
        // Get caller's username
        let profile: UserProfile = Mapping::get(users, sender);
        assert(profile.is_registered == true);

        //To avoid double-spending...
        transfer_to_receiver.await();
        transfer_to_admin.await();
       
        // Update sender balance
        Mapping::set(users, sender, UserProfile {
            public_key: profile.public_key,
            reputation: profile.reputation + 5u32,
            created_at: profile.created_at,
            is_verified: profile.is_verified,
            is_registered: profile.is_registered,
            balance: profile.balance - amount
        });
        
        // Update receiver balance
        let receiver_user: UserProfile = Mapping::get(users, receiver);
        Mapping::set(users, receiver, UserProfile {
            public_key: receiver_user.public_key,
            reputation: receiver_user.reputation + 3u32,
            created_at: receiver_user.created_at,
            is_verified: receiver_user.is_verified,
            is_registered: receiver_user.is_registered,
            balance: receiver_user.balance + net_amount
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
            sender: gift_receipt.sender,
            receiver: gift_receipt.receiver,
            amount: gift_receipt.amount,
            message_hash: gift_receipt.message_hash,
            timestamp: gift_receipt.timestamp,
            claimed: true
        }, true);
    }

    // ==============================================
    // FRIENDSHIP (Using username)
    // ==============================================

    async transition add_friend(public friend: address) -> (FriendKey,  FriendKey, Future) {
        let caller: address = self.caller;

        // Create consistent key
        let key: field = BHP256::hash_to_field(caller as field + friend as field);
        
        let send_request: FriendKey = FriendKey {
            owner: caller,
            key_id: key,
            from: self.caller,
            to: friend,
        };
        
        let receive_request: FriendKey = FriendKey {
            owner: friend,
            key_id: key,
            from: friend,
            to: caller,
        };
        
        return (send_request, receive_request, finalize_add_friend(caller, friend));
    }

    async function finalize_add_friend(caller: address, friend: address) {        
        // Get caller's username
        let profile: UserProfile = Mapping::get(users, caller);
        assert(profile.is_registered == true);
        
        // Can't friend yourself
        assert(profile.public_key != friend);

        // Create consistent key
        let key: field = BHP256::hash_to_field(caller as field + friend as field);
        
        // Check if relationship already exists
        let existing: Friendship = Mapping::get_or_use(friendships, key, Friendship {
        user_a: caller,
        user_b: friend,
        status: 0u8,
        since: 0u32
    });
        assert(existing.status == 0u8);
        
        // Create friendship
        let friendship: Friendship = Friendship {
            user_a: caller,
            user_b: friend,
            status: 1u8,    // 1 = friends
            since: block.height
        };
        
        Mapping::set(friendships, key, friendship);
        Mapping::set(user_activity, caller, block.height);
        Mapping::set(user_activity, friend, block.height);
    }

    async transition block_user(public user_to_block: address) -> Future {
        let caller: address = self.caller;
                
        return finalize_block_user(caller, user_to_block);
    }

    async function finalize_block_user(caller: address, user_to_block: address) {
        // Get caller's username
        let profile: UserProfile = Mapping::get(users, caller);
        assert(profile.is_registered == true);
        
        // Can't block yourself
        assert(profile.public_key != user_to_block);

        // Create consistent key
        let key: field = BHP256::hash_to_field(caller as field + user_to_block as field);
        
        // Create/update block relationship
        let friendship: Friendship = Friendship {
            user_a: caller,
            user_b: user_to_block,
            status: 2u8,    // 2 = blocked
            since: block.height
        };
        
        Mapping::set(friendships, key, friendship);
    }

    async transition remove_friend(public friend: address) -> Future {
        let caller: address = self.caller;
                
        return finalize_remove_friend(caller, friend);
    }

    async function finalize_remove_friend(caller: address, friend: address) {
        // Get caller's username
        let profile: UserProfile = Mapping::get(users, caller);
        assert(profile.is_registered == true);
        
        // Create consistent key
        let key: field = BHP256::hash_to_field(caller as field + friend as field);
        
        // Check if relationship exists
        let existing: Friendship = Mapping::get(friendships, key);
        assert(existing.status != 0u8);
        
        // Remove the mapping entry
        Mapping::remove(friendships, key);
    }



    // ==============================================
    // VERIFICATION
    // ==============================================

    async transition verify_user() -> Future {
        let caller: address = self.caller;
        return finalize_verify_user(caller);
    }

    async function finalize_verify_user(user: address) {
        let user_data: UserProfile = Mapping::get(users, user);
        assert(user_data.reputation >= VERIFICATION_THRESHOLD);
        
        Mapping::set(users, user, UserProfile {
            public_key: user_data.public_key,
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
        return finalize_admin_withdraw(caller, amount, withdraw_future);
    }

    async function finalize_admin_withdraw(caller: address, amount: u128, withdraw_future: Future) {
        withdraw_future.await();

    }

    transition is_admin(public user_address: address) -> bool {
        return user_address == ADMIN;
    }
}