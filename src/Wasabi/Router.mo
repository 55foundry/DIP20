import Principal "mo:base/Principal";
import D "mo:base/Debug";

import T "Types";

shared(msg) actor class WasabiRouter(): async T.Router {
    public query func name() : async Text {
        return "WasabiRouterV1";
    };

    public 
    shared(msg) 
    func swapExactTokensForTokens(
        amountIn: Nat,
        amountOutMin: Nat,
        path: [T.TokenAddress],
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async [Nat64] {
        // Should call an external source/oracle of some type to get the amounts
        // amounts = {Actor.rate(amountIn)}
        //
        // assert(amounts[0] >= amountOutMin)
        
        // path[0].transferFrom(msg.sender, recipient, amountOutMin)

        return [0, 0];
    };

    public 
    shared(msg) 
    func swapTokensForExactTokens(
        amountOut: Nat,
        amountInMax: Nat,
        path: [T.TokenAddress],
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async [Nat64] {
        return [0, 0];
    };

    public 
    shared(msg) 
    func swapExactICPForTokens(
        amountOutMin: Nat,
        path: [T.TokenAddress],
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async [Nat64] {
        return [0, 0];
    };

    public 
    shared(msg) 
    func swapTokensForExactICP(
        amountOut: Nat,
        amountInMax: Nat,
        path: [T.TokenAddress],
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async [Nat64] {
        return [0, 0];
    };

    public 
    shared(msg) 
    func swapExactTokensForICP(
        amountIn: Nat,
        amountOutMin: Nat,
        path: [T.TokenAddress],
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async [Nat64] {
        return [0, 0];
    };
};