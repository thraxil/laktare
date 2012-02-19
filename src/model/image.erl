-module(image,[Id,Title,Slug,Description,CreatedTime,Medium,Ahash,Extension]).
-compile(export_all).

-has({galleryimages,many,[{sort_by,ordinality}]}).

before_create() ->
    ModifiedRecord = set([{slug,slugs:slugify(Title)},
			  {created_time,erlang:now()}
			 ]),
    {ok, ModifiedRecord}.

get_absolute_url() ->
    "/image/view/" ++ Id.

prev_image() ->
    case boss_db:count(image,[id > Id]) of 
	0 ->
	    false;
	_ ->
	    [P|_Rest] = boss_db:find(image,[id > Id],all,0,id,str_descending),
	    P
    end.

next_image() ->
    case boss_db:count(image,[id < Id]) of 
	0 ->
	    false;
	_ ->
	    [N|_Rest] = boss_db:find(image,[id < Id],all,0,id,str_ascending),
	    N
    end.

formatted_description() ->
    markdown:conv(Description).

