%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(umleitung).
-author('author <author@example.com>').
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.
        
%% @spec start() -> ok
%% @doc Start the umleitung server.
start() ->
    umleitung_deps:ensure(),
    ensure_started(crypto),
    application:start(umleitung).

%% @spec stop() -> ok
%% @doc Stop the umleitung server.
stop() ->
    Res = application:stop(umleitung),
    application:stop(crypto),
    Res.
