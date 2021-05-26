import Principal "mo:base/Principal";
import Text "mo:base/Text";

module {
    public type TokenAddress = Principal;
    public type TokenId = Nat;
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
    }
}
