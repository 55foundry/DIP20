import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {
    public type TokenAddress = Principal;    
    public type Router = actor {
        name: query () -> async Text;

        swapExactTokensForTokens: (
            amountIn: Nat,
            amountOutMin: Nat,
            path: [TokenAddress],
            recipient: TokenAddress,
            deadline: Nat
        ) -> async [Nat64];
        
        swapTokensForExactTokens: (
            amountOut: Nat,
            amountInMax: Nat,
            path: [TokenAddress],
            recipient: TokenAddress,
            deadline: Nat
        ) -> async [Nat64];

        swapExactICPForTokens: (
            amountOutMin: Nat,
            path: [TokenAddress],
            recipient: TokenAddress,
            deadline: Nat
        ) -> async [Nat64];

        swapTokensForExactICP: (
            amountOut: Nat,
            amountInMax: Nat,
            path: [TokenAddress],
            recipient: TokenAddress,
            deadline: Nat
        ) -> async [Nat64];

        swapExactTokensForICP: (
            amountIn: Nat,
            amountOutMin: Nat,
            path: [TokenAddress],
            recipient: TokenAddress,
            deadline: Nat
        ) -> async [Nat64];
    }
}