-module(laktare_main_controller,[Req]).
-compile(export_all).

index('GET',[]) ->
    Galleries = boss_db:find(gallery,[]),
    RecentImages = boss_db:find(image,[],15),
    {ok,[{images,RecentImages},{galleries,Galleries}]}.
