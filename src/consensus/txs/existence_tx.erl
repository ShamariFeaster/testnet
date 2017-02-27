-module(existence_tx).
-export([doit/5, make/3]).
-record(ex, {from, fee = 0, nonce = 0, commit = 0}).

make(From, Fee, Data) ->
    {_, Acc, Proof} = account:get(From),
    Nonce = account:nonce(Acc) + 1,
    Tx = #ex{from = From, fee = Fee, nonce = Nonce, commit = hash:doit(Data)},
    {Tx, [Proof]}.
doit(Tx, Channels, Accounts, Commits, NewHeight) ->
    %charge the fee.
    C = Tx#ex.commit,
    {_, empty, _} = commits:get(C, Commits),
    NewCommits = commits:write(C, Commits),
    Acc = account:update(Tx#ex.from, Accounts, -Tx#ex.fee, Tx#ex.nonce, NewHeight),
    NewAccounts = accounts:write(Accounts, Acc),
    {Channels, NewAccounts, NewCommits}.
    

    