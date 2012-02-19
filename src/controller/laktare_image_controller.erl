-module(laktare_image_controller,[Req]).
-compile(export_all).
-default_action(view).

view('GET',[Slug]) ->
    [Image|_Rest] = boss_db:find(image,[slug=Slug]),
    {ok,[{image,Image}]}.
