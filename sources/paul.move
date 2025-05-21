/// Module: paul
module paul::paul;

use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct PAUL has drop {}

fun init(witness: PAUL, ctx: &mut TxContext) {
    let icon_url = url::new_unsafe_from_bytes(
        b"https://www.pauldmv.com/wp-content/uploads/2023/09/PAUL-national-coffee-day.jpg",
    );
    let decimals: u8 = 8;

    let multiplier = 100000000;

    let (mut treasury, metadata) = coin::create_currency(
        witness,
        decimals,
        b"PAUL",
        b"PAULY",
        b"A coin for lovers of The PAUL Cafe",
        option::some(icon_url),
        ctx,
    );

    let initial_coins = coin::mint(&mut treasury, 300 * multiplier, ctx);
    transfer::public_transfer(initial_coins, tx_context::sender(ctx));

    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, tx_context::sender(ctx));
}

public entry fun mint(
    treasury_cap: &mut TreasuryCap<PAUL>,
    amount: u64,
    recipients: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);

    transfer::public_transfer(coin, recipients);
}

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions
