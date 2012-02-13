-module(image,[Id,Title,Slug,Description,CreatedTime,Medium,Ahash,Extension]).
-compile(export_all).

-has({galleryimages,many,[{sort_by,ordinality}]}).

before_create() ->
    ModifiedRecord = set([{slug,slugs:slugify(Title)},
			  {created_time,erlang:now()}
			 ]),
    {ok, ModifiedRecord}.
