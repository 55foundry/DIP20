import Array "mo:base/Array";
import Error "mo:base/Error";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";

import T "Types";

actor class ERC20(_name : Text, _symbol : Text, _decimals : Nat) {
  // mapping (address => uint256) private _balances;
  private stable var balancesEntries : [(Principal, Nat)] = [];
  private let balances : HashMap.HashMap<Principal, Nat> = HashMap.fromIter<Principal, Nat>(balancesEntries.vals(), 10, Principal.equal, Principal.hash);

  // mapping (address => mapping (address => uint256)) private _allowances;
  private stable var approvalEntries : [(Principal, [Principal])] = [];
  private let approvals : HashMap.HashMap<Principal, [Principal]> = HashMap.fromIter<Principal, [Principal]>(approvalEntries.vals(), 10, Principal.equal, Principal.hash);


  // uint256 private _totalSupply;
  private stable var _totalSupply : Nat = 0;

  public shared query func name() : async Text {
    return _name;
  };

  public shared query func symbol() : async Text {
      return _symbol;
  };

  public shared query func decimals() : async Nat {
    return _decimals;
  };

  public shared func balanceOf(p : Principal) : async ?Nat {
    return balances.get(p);
  };

  private func _mint(to : Principal, tokenId : Nat, uri : Text) : () {
    // ...
  };

  private func _burn(tokenId : Nat) {
    // ...
  };

  public shared(msg) func approve(to : Principal, tokenId : T.TokenId) : async () {
    // ...
  };

  public shared(msg) func transferFrom(from : Principal, to : Principal, tokenId : Nat) : () {
    // ...
  };

  public shared(msg) func mint(uri : Text) : async Nat {
    // ...
  };
};
