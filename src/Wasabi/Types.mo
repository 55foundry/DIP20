import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {
    public type TokenAddress = Principal;
    public type Path = (TokenAddress, TokenAddress);
    public type PricePair = (Nat, Nat);
    public type SwapResult = (Nat, Nat);

    public type Router = actor {
        name: query () -> async Text;

        currentPrice: query (
            path: Path
        ) -> async ?PricePair;

        loadLiquidity: (
            price: PricePair,
            path: Path
        ) -> async Nat;



        swapExactTokensForTokens: (
            amountIn: Nat,
            amountOutMin: Nat,
            path: Path,
            recipient: TokenAddress,
            deadline: Nat
        ) -> async SwapResult;

        swapTokensForExactTokens: (
            amountOut: Nat,
            amountInMax: Nat,
            path: Path,
            recipient: TokenAddress,
            deadline: Nat
        ) -> async SwapResult;

        swapExactICPForTokens: (
            amountOutMin: Nat,
            path: Path,
            recipient: TokenAddress,
            deadline: Nat
        ) -> async SwapResult;

        swapTokensForExactICP: (
            amountOut: Nat,
            amountInMax: Nat,
            path: Path,
            recipient: TokenAddress,
            deadline: Nat
        ) -> async SwapResult;

        swapExactTokensForICP: (
            amountIn: Nat,
            amountOutMin: Nat,
            path: Path,
            recipient: TokenAddress,
            deadline: Nat
        ) -> async SwapResult;
    };
    public type DIP20 = actor {
        name: query ()  -> async Text;
        symbol: query () -> async Text;
        decimals: query () -> async Nat;
        totalSupply: query () -> async Nat;
        balanceOf: (address: TokenAddress) -> async ?Nat;
        transfer: (recipient: TokenAddress, amount: Nat) -> async Bool;
        transferFrom: (sender: TokenAddress, recipient: TokenAddress, amount: Nat) -> async Bool;
        approve: (spender: TokenAddress, amount: Nat) -> async Bool;
        allowance: query (owner: TokenAddress, spender: TokenAddress) -> async ?Nat;
    };
}