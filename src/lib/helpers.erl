-module(helpers).
-compile(export_all).

populate_test_data() ->
    G = gallery:new(id,"first gallery",slug,"description",ordinality),
    {ok,SG1} = G:save(),
    I = image:new(id,"first image",slug,"description",created,"medium","1d3964dfd1664247fef81c265dedd7a4c040eb3a",".jpg"),
    {ok,SI1} = I:save(),
    SI3 = SI1:set(created_time,{{2012,2,25},{23,20,9}}),
    {ok,SI4} = SI3:save(),
    I2 = image:new(id,"second image",slug,"description",created_time,"medium","477da14b4128da9e94677d5a61e786874484cd12",".jpg"),
    {ok,SI2} = I2:save(),
    GI = galleryimage:new(id,SG1:id(),SI4:id(),ordinality),
    {ok,SGI1} = GI:save(),
    GI2 = galleryimage:new(id,SG1:id(),SI2:id(),ordinality),
    {ok,SGI2} = GI2:save(),
    {SG1,SI4,SGI1,SI2,SGI2}.

% from: http://lethain.com/formatting-multipart-formdata-in-erlang/
format_multipart_formdata(Boundary, Fields, Files) ->
    FieldParts = lists:map(fun({FieldName, FieldContent}) ->
                                   [lists:concat(["--", Boundary]),
                                    lists:concat(["Content-Disposition: form-data; name=\"",atom_to_list(FieldName),"\""]),
                                    "",
                                    FieldContent]
                           end, Fields),
    FieldParts2 = lists:append(FieldParts),
    FileParts = lists:map(fun({FieldName, FileName, FileContent}) ->
                                  [lists:concat(["--", Boundary]),
                                   lists:concat(["Content-Disposition: format-data; name=\"",atom_to_list(FieldName),"\"; filename=\"",FileName,"\""]),
                                   lists:concat(["Content-Type: ", "application/octet-stream"]),
                                   "",
                                   FileContent]
                          end, Files),
    FileParts2 = lists:append(FileParts),
    EndingParts = [lists:concat(["--", Boundary, "--"]), ""],
    Parts = lists:append([FileParts2, EndingParts]),
    string:join(Parts, "\r\n").

is_nonzero(0) ->
    false;
is_nonzero(_) ->
    true.

head_or_false([]) ->
    false;
head_or_false([H|_]) ->
    H.

parse_datetime(DTString) ->
    Fields = [list_to_integer(I) || I <- string:tokens(DTString,"{,}")],
    {Year,Month,Day,Hour,Minute,Second} = list_to_tuple(Fields),
    {{Year,Month,Day},{Hour,Minute,Second}}.

load() ->
    load_from_json("/home/anders/myopica.json").

load_from_json(FilePath) ->
    {ok,Data} = file:read_file(FilePath),
    {struct,TopLevel} = mochijson:decode(Data),
    {array,Images} = proplists:get_value("images",TopLevel),
    {array,Galleries} = proplists:get_value("galleries",TopLevel),
    {array,GalleryImages} = proplists:get_value("galleryimages",TopLevel),
    
    CreatedImages = lists:map(fun({struct,PList}) ->  
				      Title = proplists:get_value("title",PList),
				      Description = proplists:get_value("description",PList),
				      Medium = proplists:get_value("medium",PList),
				      Slug = proplists:get_value("slug",PList),
				      AHash = proplists:get_value("ahash",PList),
				      Extension = proplists:get_value("extension",PList),
				      Created = parse_datetime(proplists:get_value("created",PList)),
				      I = image:new(id,Title,Slug,Description,Created,Medium,AHash,Extension),
				      {ok,SI} = I:save(),
                                      % update the slug and created times
				      I2 = SI:set([{slug,Slug},{created_time,Created}]),
				      {ok,SI2} = I2:save(),
				      SI2
			      end, Images),
    CreatedGalleries = lists:map(fun({struct,PList}) ->
					 io:format("~p~n",[PList]),
					 Title = proplists:get_value("title",PList),
					 Slug = proplists:get_value("slug",PList),
					 Description = proplists:get_value("description",PList),
					 Ordinality = proplists:get_value("ordinality",PList),
					 G = gallery:new(id,Title,Slug,Description,ordinality),
					 {ok,SG} = G:save(),
					 % update the ordinality
					 G2 = SG:set(ordinality,Ordinality),
					 {ok,SG2} = G2:save(),
					 SG2
					 end,
				 Galleries),
    CreatedGIs = lists:map(
    		   fun({struct,PList}) ->
    			   io:format("~p~n",[PList]),
    			   ImageSlug = proplists:get_value("image",PList),
    			   GallerySlug = proplists:get_value("gallery",PList),
    			   Ordinality = proplists:get_value("ordinality",PList),
    			   io:format("~p~n",[boss_db:count(image,[slug=ImageSlug])]),
    			   io:format("~p~n",[boss_db:count(gallery,[slug=GallerySlug])]),
    			   Image = hd(boss_db:find(image,[slug=ImageSlug])),
    			   Gallery = hd(boss_db:find(gallery,[slug=GallerySlug])),
    			   GI = galleryimage:new(id,Gallery:id(),Image:id(),ordinality),
    			   {ok,SGI} = GI:save(),
    			   GI2 = SGI:set(ordinality,Ordinality),
    			   {ok,SGI2} = GI2:save(),
    			   SGI2
    			   end, GalleryImages),

    {ok}.
    
