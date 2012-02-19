-module(laktare_02_other).

-export([init/0, stop/1]).

% This script is first executed at server startup 
init() ->
    inets:start(),
    {ok, []}.

% stop is executed if the script is ever reloaded.
stop(ListOfWatchIDs) ->
    inets:stop().
