%% @author Lenz Gschwendtner <lenz@ideegeo.com>
%% @copyright 2008 lenz.

%% @doc Web server for umleitung.

-module(umleitung_web).
-author('Lenz Gschwendtner <lenz@ideegeo.com>').

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

%% @doc Process requests for GET/HEAD requests and reply with a HTTP
%% redirect if we find a matching destination.
loop(Req, DocRoot) ->
    Host = Req:get_header_value(host),
    Path = Host ++ Req:get(path),
    case Req:get(method) of
        Method when Method =:= 'GET'; Method =:= 'HEAD' ->
            case lookup(Path) of
                {ok, Dest} ->
                    io:format("DESTINATION: ~s~n", [Dest]),
                    Req:respond({302, [{"Location", Dest}, {"Content-Type", "text/html; charset=UTF-8"}], ""});
                _ ->
                    Req:serve_file("404.html", DocRoot)
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

%% @spec lookup(Path::string()) -> term
%% @doc Process a lookup request. This takes a URI and asks CouchDB for
%% a known destination. Response is the destination or error.

lookup(Path) ->
    io:format("PATH: ~s~n", [Path]),
    {json,{struct, Props}} = erlang_couchdb:invoke_view({"127.0.0.1", 5984}, "umleitung", "redir", "uri_match", [{"key", "\"" ++ Path ++ "\""}]),
    try  proplists:get_value(<<"rows">>, Props) of
        [{struct, Rows} | _] ->
            {ok, proplists:get_value(<<"value">>, Rows)};
        _ -> {error, unknown}
    catch
        _:_ -> {error, unknown}
    end.

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.

