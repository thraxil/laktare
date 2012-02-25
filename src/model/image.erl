-module(image,[Id,Title,Slug,Description,CreatedTime,Medium,Ahash,Extension]).
-compile(export_all).

-has({galleryimages,many,[{sort_by,ordinality}]}).

before_create() ->
    ModifiedRecord = set([{slug,slugs:slugify(Title)},
			  {created_time,erlang:now()}
			 ]),
    {ok, ModifiedRecord}.

get_absolute_url() ->
    "/image/view/" ++ Slug.

next_image() ->
    helpers:head_or_false(boss_db:find(image,[created_time < CreatedTime],all,0,id,str_descending)).

prev_image() ->
    helpers:head_or_false(boss_db:find(image,[created_time > CreatedTime],all,0,id,str_ascending)).

formatted_description() ->
    markdown:conv(Description).

