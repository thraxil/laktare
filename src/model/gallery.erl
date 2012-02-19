-module(gallery,[Id,Title,Slug,Description,Ordinality]).
-compile(export_all).

-has({galleryimages,many,[{sort_by,ordinality}]}).

before_create() ->
    ModifiedRecord = set([{slug,slugs:slugify(Title)},
			{ordinality,boss_db:count(gallery) + 1}]),
    {ok, ModifiedRecord}.

has_image(ImageId) ->
    boss_db:count(galleryimage,[gallery_id = Id,
				image_id = ImageId]) == 1.

newest_images() ->
    [GI:image() || GI <- lists:sublist(galleryimages(),15)].

first_image() ->
    GI = first_galleryimage(),
    GI:image().

has_images() ->
    boss_db:count(galleryimage,[gallery_id = Id]) == 0.

images() ->
    [GI:image() || GI <- galleryimages()].

get_absolute_url() ->
    "/gallery/view/" ++ Id.

get_image_url() ->
    "/gallery/image/" ++ Id.

formatted_description() ->
    markdown:conv(Description).
