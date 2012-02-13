-module(laktare_gallery_controller,[Req]).
-compile(export_all).

index('GET',[]) ->
    {ok,[{images,[]},{galleries,[]}]}.

