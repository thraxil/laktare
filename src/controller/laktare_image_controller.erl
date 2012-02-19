-module(laktare_image_controller,[Req]).
-compile(export_all).

view('GET',[ImageId]) ->
    Image = boss_db:find(ImageId),
    {ok,[{image,Image}]}.
