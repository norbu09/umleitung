%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Web server for umleitung.

-module(umleitung_web).
-author('author <author@example.com>').

-export([start/1, stop/0, loop/2]).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, DocRoot) ->
    "/" ++ Path = Req:get(path),
    case Req:get(method) of
        Method when Method =:= 'GET'; Method =:= 'HEAD' ->
            case lookup(Path) of
                {ok, Dest} ->
                    Req:respond({302, [{"Location", Dest}], ""});
                _ ->
                    Req:respond({501, [], "error"})
            end;
        'POST' ->
            case Path of
                _ ->
                    Req:not_found()
            end;
        _ ->
            Req:respond({501, [], []})
    end.

%% Internal API

lookup(Path) ->
    io:format("PATH: ~s~n", [Path]),
    {json,{struct, Props}} = erlang_couchdb:invoke_view({"localhost", 5984}, "umleitung", "redir", "match", [{"key", "\"" ++ Path ++ "\""}]),
    try  proplists:get_value(<<"rows">>, Props) of
        [{struct, Rows} | _] ->
            {ok, proplists:get_value(<<"value">>, Rows)};
        _ -> {error, unknown}
    catch
        _:_ -> {error, unknown}
    end.

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.
