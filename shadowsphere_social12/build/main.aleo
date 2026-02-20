import merkle_tree.aleo;
import test_usdcx_multisig_core.aleo;
import test_usdcx_freezelist.aleo;
import test_usdcx_stablecoin.aleo;
program shadowsphere_social12.aleo;

record PrivateMessage:
    owner as address.private;
    message_id as field.private;
    from as address.private;
    to as address.private;
    content_hash as field.private;
    timestamp as u32.private;
    read as boolean.private;

record GiftReceipt:
    owner as address.private;
    gift_id as field.private;
    sender as address.private;
    receiver as address.private;
    amount as u128.private;
    message_hash as field.private;
    timestamp as u32.private;
    claimed as boolean.private;

record UserSecret:
    owner as address.private;
    identity_hash as field.private;

record FriendKey:
    owner as address.private;
    key_id as field.private;
    from as address.private;
    to as address.private;

struct UserProfile:
    public_key as address;
    reputation as u32;
    created_at as u32;
    is_verified as boolean;
    is_registered as boolean;
    balance as u128;

struct Post:
    post_id as u32;
    author as address;
    content_hash as field;
    timestamp as u32;
    likes as u32;
    comments as u32;
    encrypted as boolean;
    category as u8;

struct Comment:
    comment_id as u32;
    post_id as u32;
    author as address;
    content_hash as field;
    timestamp as u32;

struct Friendship:
    user_a as address;
    user_b as address;
    status as u8;
    since as u32;

struct MerkleProof:
    siblings as [field; 16u32];
    leaf_index as u32;

struct WalletEcdsaSigner:
    wallet_id as address;
    ecdsa_signer as [u8; 20u32];

struct AdminOp:
    op as u8;
    threshold as u8;
    aleo_signer as address;
    ecdsa_signer as [u8; 20u32];

mapping users:
    key as address.public;
    value as UserProfile.public;

mapping posts:
    key as u32.public;
    value as Post.public;

mapping comments:
    key as u32.public;
    value as Comment.public;

mapping friendships:
    key as field.public;
    value as Friendship.public;

mapping user_posts:
    key as address.public;
    value as u32.public;

mapping post_comments:
    key as u32.public;
    value as u32.public;

mapping user_activity:
    key as address.public;
    value as u32.public;

mapping message_activity:
    key as address.public;
    value as u32.public;

mapping total_users:
    key as u32.public;
    value as u32.public;

mapping total_posts:
    key as u32.public;
    value as u32.public;

mapping total_comments:
    key as u32.public;
    value as u32.public;

function register:
    cast self.caller into r0 as field;
    hash.bhp256 r0 into r1 as field;
    cast self.caller r1 into r2 as UserSecret.record;
    async register self.caller into r3;
    output r2 as UserSecret.record;
    output r3 as shadowsphere_social12.aleo/register.future;

finalize register:
    input r0 as address.public;
    get.or_use total_users[0u32] 0u32 into r1;
    add r1 1u32 into r2;
    set r2 into total_users[0u32];
    cast r0 0u32 block.height false false 0u128 into r3 as UserProfile;
    get.or_use users[r0] r3 into r4;
    is.eq r4.is_registered false into r5;
    assert.eq r5 true;
    cast r0 0u32 block.height false true 0u128 into r6 as UserProfile;
    set r6 into users[r4.public_key];
    set block.height into user_activity[r4.public_key];

function verify_login:
    input r0 as field.private;
    cast self.caller into r1 as field;
    hash.bhp256 r1 into r2 as field;
    is.eq r2 r0 into r3;
    assert.eq r3 true;
    async verify_login self.caller into r4;
    output r4 as shadowsphere_social12.aleo/verify_login.future;

finalize verify_login:
    input r0 as address.public;
    get users[r0] into r1;
    is.eq r1.is_registered true into r2;
    assert.eq r2 true;
    set block.height into user_activity[r0];

function deposit:
    input r0 as u128.private;
    gte r0 1000000u128 into r1;
    assert.eq r1 true;
    call test_usdcx_stablecoin.aleo/transfer_public_as_signer shadowsphere_social12.aleo r0 into r2;
    async deposit self.caller r0 r2 into r3;
    output r3 as shadowsphere_social12.aleo/deposit.future;

finalize deposit:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as test_usdcx_stablecoin.aleo/transfer_public_as_signer.future;
    await r2;
    get users[r0] into r3;
    add r3.balance r1 into r4;
    cast r3.public_key r3.reputation r3.created_at r3.is_verified r3.is_registered r4 into r5 as UserProfile;
    set r5 into users[r0];

function withdraw:
    input r0 as u128.private;
    call test_usdcx_stablecoin.aleo/transfer_public self.caller r0 into r1;
    async withdraw self.caller r0 r1 into r2;
    output r2 as shadowsphere_social12.aleo/withdraw.future;

finalize withdraw:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as test_usdcx_stablecoin.aleo/transfer_public.future;
    await r2;
    get users[r0] into r3;
    gte r3.balance r1 into r4;
    assert.eq r4 true;
    sub r3.balance r1 into r5;
    cast r3.public_key r3.reputation r3.created_at r3.is_verified r3.is_registered r5 into r6 as UserProfile;
    set r6 into users[r0];

function create_post:
    input r0 as field.public;
    input r1 as boolean.public;
    input r2 as u8.public;
    async create_post self.caller r0 r1 r2 into r3;
    output r3 as shadowsphere_social12.aleo/create_post.future;

finalize create_post:
    input r0 as address.public;
    input r1 as field.public;
    input r2 as boolean.public;
    input r3 as u8.public;
    get users[r0] into r4;
    is.eq r4.is_registered true into r5;
    assert.eq r5 true;
    lte r3 10u8 into r6;
    assert.eq r6 true;
    is.neq r1 0field into r7;
    assert.eq r7 true;
    get.or_use total_posts[0u32] 0u32 into r8;
    add r8 1u32 into r9;
    set r9 into total_posts[0u32];
    set r9 into user_posts[r0];
    cast r9 r0 r1 block.height 0u32 0u32 r2 r3 into r10 as Post;
    is.neq r10.post_id 0u32 into r11;
    assert.eq r11 true;
    set r10 into posts[r9];
    get users[r0] into r12;
    add r12.reputation 3u32 into r13;
    cast r12.public_key r13 r12.created_at r12.is_verified r12.is_registered r12.balance into r14 as UserProfile;
    set r14 into users[r0];

function like_post:
    input r0 as u32.private;
    async like_post self.caller r0 into r1;
    output r1 as shadowsphere_social12.aleo/like_post.future;

finalize like_post:
    input r0 as address.public;
    input r1 as u32.public;
    get users[r0] into r2;
    is.eq r2.is_registered true into r3;
    assert.eq r3 true;
    get posts[r1] into r4;
    add r4.likes 1u32 into r5;
    cast r4.post_id r4.author r4.content_hash r4.timestamp r5 r4.comments r4.encrypted r4.category into r6 as Post;
    set r6 into posts[r1];
    get users[r4.author] into r7;
    add r7.reputation 1u32 into r8;
    cast r7.public_key r8 r7.created_at r7.is_verified r7.is_registered r7.balance into r9 as UserProfile;
    set r9 into users[r4.author];

function add_comment:
    input r0 as u32.public;
    input r1 as field.public;
    async add_comment self.caller r0 r1 into r2;
    output r2 as shadowsphere_social12.aleo/add_comment.future;

finalize add_comment:
    input r0 as address.public;
    input r1 as u32.public;
    input r2 as field.public;
    get users[r0] into r3;
    is.eq r3.is_registered true into r4;
    assert.eq r4 true;
    get.or_use total_comments[0u32] 0u32 into r5;
    add r5 1u32 into r6;
    set r6 into total_comments[0u32];
    set r6 into post_comments[r1];
    cast r6 r1 r0 r2 block.height into r7 as Comment;
    set r7 into comments[r6];
    get posts[r1] into r8;
    add r8.comments 1u32 into r9;
    cast r8.post_id r8.author r8.content_hash r8.timestamp r8.likes r9 r8.encrypted r8.category into r10 as Post;
    set r10 into posts[r1];
    get users[r0] into r11;
    add r11.reputation 2u32 into r12;
    cast r11.public_key r12 r11.created_at r11.is_verified r11.is_registered r11.balance into r13 as UserProfile;
    set r13 into users[r0];

function send_message:
    input r0 as address.private;
    input r1 as field.private;
    input r2 as u32.private;
    cast self.caller into r3 as field;
    cast r0 into r4 as field;
    add r3 r4 into r5;
    add r5 r1 into r6;
    cast r2 into r7 as field;
    add r6 r7 into r8;
    hash.bhp256 r8 into r9 as field;
    cast self.caller r9 self.caller r0 r1 r2 true into r10 as PrivateMessage.record;
    cast r0 r9 self.caller r0 r1 r2 false into r11 as PrivateMessage.record;
    async send_message self.caller r0 into r12;
    output r10 as PrivateMessage.record;
    output r11 as PrivateMessage.record;
    output r12 as shadowsphere_social12.aleo/send_message.future;

finalize send_message:
    input r0 as address.public;
    input r1 as address.public;
    get users[r0] into r2;
    is.eq r2.is_registered true into r3;
    assert.eq r3 true;
    set block.height into message_activity[r0];
    set block.height into message_activity[r1];

function send_gift:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as field.public;
    input r3 as u32.public;
    gt r1 0u128 into r4;
    assert.eq r4 true;
    cast self.caller into r5 as field;
    cast r0 into r6 as field;
    add r5 r6 into r7;
    cast r1 into r8 as field;
    add r7 r8 into r9;
    add r9 r2 into r10;
    hash.bhp256 r10 into r11 as field;
    sub r1 100000u128 into r12;
    cast self.caller r11 self.caller r0 r12 r2 r3 true into r13 as GiftReceipt.record;
    cast r0 r11 self.caller r0 r12 r2 r3 false into r14 as GiftReceipt.record;
    call test_usdcx_stablecoin.aleo/transfer_public_as_signer r0 r12 into r15;
    call test_usdcx_stablecoin.aleo/transfer_public_as_signer aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h 100000u128 into r16;
    async send_gift self.caller r0 r1 r12 r15 r16 into r17;
    output r13 as GiftReceipt.record;
    output r14 as GiftReceipt.record;
    output r17 as shadowsphere_social12.aleo/send_gift.future;

finalize send_gift:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u128.public;
    input r3 as u128.public;
    input r4 as test_usdcx_stablecoin.aleo/transfer_public_as_signer.future;
    input r5 as test_usdcx_stablecoin.aleo/transfer_public_as_signer.future;
    get users[r0] into r6;
    is.eq r6.is_registered true into r7;
    assert.eq r7 true;
    await r4;
    await r5;
    add r6.reputation 5u32 into r8;
    sub r6.balance r2 into r9;
    cast r6.public_key r8 r6.created_at r6.is_verified r6.is_registered r9 into r10 as UserProfile;
    set r10 into users[r0];
    get users[r1] into r11;
    add r11.reputation 3u32 into r12;
    add r11.balance r3 into r13;
    cast r11.public_key r12 r11.created_at r11.is_verified r11.is_registered r13 into r14 as UserProfile;
    set r14 into users[r1];

function claim_gift:
    input r0 as GiftReceipt.record;
    is.eq r0.owner self.caller into r1;
    not r0.claimed into r2;
    and r1 r2 into r3;
    assert.eq r3 true;
    cast r0.owner r0.gift_id r0.sender r0.receiver r0.amount r0.message_hash r0.timestamp true into r4 as GiftReceipt.record;
    output r4 as GiftReceipt.record;
    output true as boolean.private;

function add_friend:
    input r0 as address.public;
    cast self.caller into r1 as field;
    cast r0 into r2 as field;
    add r1 r2 into r3;
    hash.bhp256 r3 into r4 as field;
    cast self.caller r4 self.caller r0 into r5 as FriendKey.record;
    cast r0 r4 r0 self.caller into r6 as FriendKey.record;
    async add_friend self.caller r0 into r7;
    output r5 as FriendKey.record;
    output r6 as FriendKey.record;
    output r7 as shadowsphere_social12.aleo/add_friend.future;

finalize add_friend:
    input r0 as address.public;
    input r1 as address.public;
    get users[r0] into r2;
    is.eq r2.is_registered true into r3;
    assert.eq r3 true;
    is.neq r2.public_key r1 into r4;
    assert.eq r4 true;
    cast r0 into r5 as field;
    cast r1 into r6 as field;
    add r5 r6 into r7;
    hash.bhp256 r7 into r8 as field;
    cast r0 r1 0u8 0u32 into r9 as Friendship;
    get.or_use friendships[r8] r9 into r10;
    is.eq r10.status 0u8 into r11;
    assert.eq r11 true;
    cast r0 r1 1u8 block.height into r12 as Friendship;
    set r12 into friendships[r8];
    set block.height into user_activity[r0];
    set block.height into user_activity[r1];

function block_user:
    input r0 as address.public;
    async block_user self.caller r0 into r1;
    output r1 as shadowsphere_social12.aleo/block_user.future;

finalize block_user:
    input r0 as address.public;
    input r1 as address.public;
    get users[r0] into r2;
    is.eq r2.is_registered true into r3;
    assert.eq r3 true;
    is.neq r2.public_key r1 into r4;
    assert.eq r4 true;
    cast r0 into r5 as field;
    cast r1 into r6 as field;
    add r5 r6 into r7;
    hash.bhp256 r7 into r8 as field;
    cast r0 r1 2u8 block.height into r9 as Friendship;
    set r9 into friendships[r8];

function remove_friend:
    input r0 as address.public;
    async remove_friend self.caller r0 into r1;
    output r1 as shadowsphere_social12.aleo/remove_friend.future;

finalize remove_friend:
    input r0 as address.public;
    input r1 as address.public;
    get users[r0] into r2;
    is.eq r2.is_registered true into r3;
    assert.eq r3 true;
    cast r0 into r4 as field;
    cast r1 into r5 as field;
    add r4 r5 into r6;
    hash.bhp256 r6 into r7 as field;
    get friendships[r7] into r8;
    is.neq r8.status 0u8 into r9;
    assert.eq r9 true;
    remove friendships[r7];

function verify_user:
    async verify_user self.caller into r0;
    output r0 as shadowsphere_social12.aleo/verify_user.future;

finalize verify_user:
    input r0 as address.public;
    get users[r0] into r1;
    gte r1.reputation 100u32 into r2;
    assert.eq r2 true;
    cast r1.public_key r1.reputation r1.created_at true r1.is_registered r1.balance into r3 as UserProfile;
    set r3 into users[r0];

function admin_withdraw_fees:
    input r0 as u128.private;
    is.eq self.caller aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h into r1;
    assert.eq r1 true;
    call test_usdcx_stablecoin.aleo/transfer_public aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h r0 into r2;
    async admin_withdraw_fees self.caller r0 r2 into r3;
    output r3 as shadowsphere_social12.aleo/admin_withdraw_fees.future;

finalize admin_withdraw_fees:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as test_usdcx_stablecoin.aleo/transfer_public.future;
    await r2;

function is_admin:
    input r0 as address.public;
    is.eq r0 aleo1f5enhpxfz3l3pqyh8k9d5xkqu0njv27xp5sv4nedarrk3nrgnuzqm3pp9h into r1;
    output r1 as boolean.private;

constructor:
    assert.eq edition 0u16;
