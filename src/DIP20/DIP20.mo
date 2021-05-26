import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Option "mo:base/Option";
import Array "mo:base/Array";
import D "mo:base/Debug";

import T "Types";

//type TokenAddress = T.TokenAddress; //just to make code cleaner

shared(msg) actor class CoolCoin(_name : Text, _symbol : Text, _decimals : Nat): async T.DIP20 {
  // mapping (address => uint256) private _balances;
  stable let owner = msg.caller;
  stable var _totalSupply : Nat = 100000000000000;
  stable var balancesEntries : [(T.TokenAddress, Nat)] = Array.make((owner, _totalSupply));
  let balances : HashMap.HashMap<T.TokenAddress, Nat> = HashMap.fromIter<T.TokenAddress, Nat>(balancesEntries.vals(), 10, Principal.equal, Principal.hash);



  // mapping (address => mapping (address => uint256)) private _allowances;
  stable var approvalEntries : [(T.TokenAddress, [(T.TokenAddress, Nat)])] = [];
  let approvals : HashMap.HashMap<T.TokenAddress, [(T.TokenAddress, Nat)]> = HashMap.fromIter<T.TokenAddress, [(T.TokenAddress, Nat)]>(approvalEntries.vals(), 10, Principal.equal, Principal.hash);

  // uint256 private _totalSupply;


  //if we don't have any balances yet, lets give them to the owner


  public query func name() : async Text {
    return _name;
  };

  public query func symbol() : async Text {
    return _symbol;
  };

  public query func decimals() : async Nat {
    return _decimals;
  };

  public query func totalSupply() : async Nat {
    return _totalSupply;
  };

  public func balanceOf(p : T.TokenAddress) : async ?Nat {
    return balances.get(p);
  };
  public func getowner() : async T.TokenAddress {
    return owner;
  };



  public shared(msg) func transfer(recipient : Principal, amount : Nat) : async Bool {
    D.print(debug_show(msg));
    let balance : ?Nat = balances.get(msg.caller);
    let recipientBalance: ?Nat = balances.get(recipient);
    D.print(debug_show(balance));
    D.print(debug_show(recipientBalance));
    switch balance {
      case null {return false};
      case (?balance) { //unwraps balance as a Nat b
        //let unwrapedBalance : Nat = Option.unwrap<Nat>(balance);
        D.print(debug_show("hit balance not null"));
        if (balance >= amount) {
          D.print(debug_show("balance is greater"));
          balances.put(msg.caller, balance - amount);

          switch recipientBalance {
            case null {
              balances.put(recipient, amount);
            };
            case (?recipentBalance) { //unwraps recipent balance as a nat rb

              balances.put(recipient, recipentBalance + amount);
            };
          };
          return true;
        };
      };

    };
    D.print(debug_show("got to the end"));
    return false;
  };

  func _findAllowance(sender : T.TokenAddress, recipient: T.TokenAddress ) : ?Nat{
    let allowances : ?[(T.TokenAddress, Nat)] = approvals.get(sender);
    var foundAllowance : ?Nat = null;
    switch allowances {
      case null{
        return null;
      };
      case (?allowances){
        label allow for ((targetRecipient, allowance) in allowances.vals()){
          if(targetRecipient == recipient){

              foundAllowance := ?allowance;
              break allow;
          };

        };
        switch (foundAllowance){
          case null{
            return null;
          };
          case (?foundAllowance){
            return ?foundAllowance;
          };
        };
      };
    };
  };



  public shared(msg) func transferFrom(sender : T.TokenAddress, recipient : T.TokenAddress, tokenAmount : Nat) : async Bool {
    //check that sender has at least token amount
    let balance : ?Nat = balances.get(sender);
    let recipientBalance: ?Nat = balances.get(recipient);

    switch balance{
      case null{ //sender doesn't exist
        return false;
      };
      case (?balance){ //unwraps balance
        //check allowance
        let allowances : ?[(T.TokenAddress, Nat)] = approvals.get(sender);
        var foundAllowance = _findAllowance(sender, msg.caller);

        switch (foundAllowance){
          case null{
            return false;
          };
          case (?foundAllowance){
            if (balance >= foundAllowance){
              balances.put(sender, balance - tokenAmount);
              switch recipientBalance {
                case null {
                  balances.put(recipient, tokenAmount);
                };
                case (?recipentBalance) { //unwraps recipent balance as a nat
                  balances.put(recipient, recipentBalance + tokenAmount);
                };
              };
              //remove the approval
              let oAllowances = Option.unwrap<[(T.TokenAddress, Nat)]>(allowances);

              var newAllowances : [(T.TokenAddress, Nat)] = Array.filter<(T.TokenAddress, Nat)>(oAllowances, func (item : (T.TokenAddress, Nat)){
                return item.0 != msg.caller;
              });
              if(foundAllowance > tokenAmount){
                newAllowances := Array.append(newAllowances, Array.make((msg.caller, Nat.sub(foundAllowance,tokenAmount))));
              };
              approvals.put(sender, newAllowances);
              return true;

            } else {
              return false;
            };
          };
        };

      };
    };
  };


  public query(msg)  func allowance(owner : T.TokenAddress, spender : T.TokenAddress) : async ?Nat {
    return _findAllowance(owner, spender);
  };

  public shared(msg) func approve(spender : T.TokenAddress, amount : Nat) : async Bool {
    let balance : ?Nat = balances.get(msg.caller);
    switch balance {
      case null{
        return false;
      };
      case (?balance){
        if (balance >= amount){
          let allowances : ?[(T.TokenAddress, Nat)] = approvals.get(msg.caller);
          switch allowances {
            case null{
              approvals.put(msg.caller, Array.make((spender, amount)));
              return true;
            };
            case (?allowances){
              approvals.put(msg.caller, Array.append(allowances,Array.make((spender, amount))));
            };
          };

        } else {
          return false;
        }
      }
    };
    return false;
  };





};
