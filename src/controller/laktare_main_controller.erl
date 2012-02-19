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
%    {output,io_lib:format("~w",[Req:post_params()])}.

    {ok,Data} = file:read_file(TmpFile),
    URL = "http://apomixis.thraxil.org/",
    Boundary = "------------a450glvjfEoqerAc1p431paQlfDac152cadADfd",
    Body = helpers:format_multipart_formdata(Boundary, [], [{image, OrigFilename, binary_to_list(Data)}]),
    ContentType = lists:concat(["multipart/form-data; boundary=", Boundary]),
    Headers = [{"Content-Length", integer_to_list(length(Body))}],
    {ok,{_,_Headers,Response}} = httpc:request(post, {URL, Headers, ContentType, Body}, [], []),
    {struct,Json} = mochijson2:decode(Response),
    Hash = proplists:get_value(<<"hash">>,Json),
    I = image:new(id,Title,slug,Description,created,Medium,Hash,Extension),
    {ok,SI1} = I:save(),
    {redirect, "/"}.

add_gallery('GET',[]) ->
    {ok,[]};
add_gallery('POST',[]) ->
    Title = Req:post_param("title"),
    Description = Req:post_param("description"),
    G = gallery:new(id,Title,slug,Description,ordinality),
    {ok,SG} = G:save(),
    {redirect, "/main/add_gallery/"}.
