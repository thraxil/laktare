-module(gallery,[Id,Title,Slug,Description,Ordinality]).
-compile(export_all).

-has({galleryimages,many,[{sort_by,ordinality}]}).

before_create() ->
    ModifiedRecord = set([{slug,slugs:slugify(Title)},
			 {ordinality,boss_db:count(gallery) + 1}]),
    {ok, ModifiedRecord}.

