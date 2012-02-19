-module(laktare_main_controller,[Req]).
-compile(export_all).

index('GET',[]) ->
    Galleries = boss_db:find(gallery,[]),
    RecentImages = boss_db:find(image,[],15),
    {ok,[{images,RecentImages},{galleries,Galleries}]}.

add('GET',[]) ->
    Galleries = boss_db:find(gallery,[]),
    {ok, [{galleries,Galleries}]};
add('POST',[]) ->
    Title = Req:post_param("title"),
    Description = Req:post_param("description"),
    Medium = Req:post_param("medium"),
    [{uploaded_file,OrigFilename,TmpFile,Length}|_Rest] = Req:post_files(),
    Extension = filename:extension(OrigFilename),
    I = image:new(id,Title,slug,Description,created,Medium,"1d3964dfd1664247fef81c265dedd7a4c040eb3a",Extension),
    {ok,SI1} = I:save(),
    {redirect, "/"}.
