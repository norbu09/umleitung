%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the umleitung application.

-module(umleitung_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for umleitung.
start(_Type, _StartArgs) ->
    umleitung_deps:ensure(),
    umleitung_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for umleitung.
stop(_State) ->
    ok.
