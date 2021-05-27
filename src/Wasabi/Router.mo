import Principal "mo:base/Principal";
import Hash "mo:base/Hash";

import HashMap "mo:base/HashMap";
import D "mo:base/Debug";

import T "Types";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import DIP20 "../DIP20/DIP20";


shared(msg) actor class WasabiRouter()  : async T.Router = this {

    stable let originator: Principal = msg.caller;
    stable var owner : Principal = msg.caller;

    let noOp : T.SwapResult = (0,0);


    func pairEqual(x : T.Path, y : T.Path) : Bool {
        if ((Principal.equal(x.0,y.0) and Principal.equal(x.1,y.1))){
            return true;
        };
        return false;
    };

    func pairHash(x: T.Path) : Hash.Hash{
        //the hash of our pair is a 32 bit Nat, +% allows wrapping and lets us add two together to get unique hash, +% 1 helps us keep the path unique, ie eth->icp and icp->eth need to be differnt
        return Principal.hash(x.0) +% (Principal.hash(x.1)  +%  1);
    };

    stable var pairEntries : [(T.Path, T.PricePair)] = [];
    let pairs : HashMap.HashMap<T.Path, T.PricePair> = HashMap.fromIter<T.Path, T.PricePair>(pairEntries.vals(), 10, pairEqual, pairHash);

    stable var pairTokens : [(T.Path, T.TokenAddress)] = [];
    let pairTokenss : HashMap.HashMap<T.Path, T.TokenAddress> = HashMap.fromIter<T.Path, T.TokenAddress>(pairTokens.vals(), 10, pairEqual, pairHash);

    public query func name() : async Text {
        return "WasabiRouterV1";
    };


    public query func currentPrice(path: T.Path) : async ?T.PricePair{
        let pair : ?T.PricePair = pairs.get(path);
    };

    public
    shared(msg)
    func loadLiquidity(
        price: T.PricePair,
        path: T.Path
    ) : async Nat {
        //check possible 1
        //check possible 2
        //transfer
        //check LP
        //create LP if it doesn't exist
        // let mintableDIP20LP : T.DIP20 = new MintableDIP20LP(name, symbol, decimals, etc)
        //Mint - need to implement mintable ERC20
        return 0;
    };

    public
    shared(msg)
    func swapExactTokensForTokens(
        amountIn: Nat,
        amountOutMin: Nat,
        path: T.Path,
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async T.SwapResult {
        let this_identity : Principal = Principal.fromActor(this);
        let sourceToken : T.DIP20 = actor(Principal.toText(path.0));
        let destToken : T.DIP20 = actor(Principal.toText(path.1)) ;
        let pair : ?T.PricePair = pairs.get((path.0,path.1));

        switch pair {
            case null{
                return noOp;
            };
            case (?pair){
                if(pair.1 == 0){
                    return noOp;
                };
                //check amount in
                var takePossible : ?Nat = await sourceToken.allowance(msg.caller, this_identity);
                switch takePossible{
                    case null{
                        return noOp;
                    };
                    case (?takePossible){
                        if (takePossible < amountIn){
                            //not enough allowance
                            return noOp;
                        };
                        //calc amount out
                        var amountOut : Nat = Nat.div(Nat.mul(amountIn, pair.0),pair.1);
                        if (amountOut < amountOutMin){
                            return noOp;
                        };

                        //check amount out vs ms
                        //todo, you may want to take the whole amount possible here and then refund so that users can safely add a good buffer to pay for the balance percentage
                        let takeResult : Bool = await sourceToken.transferFrom(msg.caller, this_identity, amountIn);
                        if (takeResult != true){
                            return noOp;
                        };
                        let putResult : Bool = await destToken.transfer(recipient, amountOut);
                        if (putResult != true){
                            //refund the intake
                            //since we have issued an await, the take has been locked into state, we need to give it back
                            let refund : Bool = await sourceToken.transfer(msg.caller, amountIn);
                            return noOp;
                        };
                        //balance prices
                        let newPair : (Nat, Nat) = (Nat.add(pair.0, amountIn), Nat.sub(pair.1, amountOut));
                        pairs.put((path.0,path.1), newPair);
                        return (amountIn,amountOut);


                    };
                };


            };
        };



        return noOp;
    };

    public
    shared(msg)
    func swapTokensForExactTokens(
        amountOut: Nat,
        amountInMax: Nat,
        path: T.Path,
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async T.SwapResult {
        return noOp;
    };

    public
    shared(msg)
    func swapExactICPForTokens(
        amountOutMin: Nat,
        path: T.Path,
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async T.SwapResult {
        return noOp;
    };

    public
    shared(msg)
    func swapTokensForExactICP(
        amountOut: Nat,
        amountInMax: Nat,
        path: T.Path,
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async T.SwapResult {
        return noOp;
    };

    public
    shared(msg)
    func swapExactTokensForICP(
        amountIn: Nat,
        amountOutMin: Nat,
        path: T.Path,
        recipient: T.TokenAddress,
        deadline: Nat
    ) : async T.SwapResult {
        return noOp;
    };
};