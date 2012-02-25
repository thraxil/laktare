-module(galleryimage,[Id,GalleryId,ImageId,Ordinality]).
-compile(export_all).

-belongs_to(gallery).
-belongs_to(image).

before_create() ->
    ModifiedRecord = set(ordinality,
			 boss_db:count(galleryimage, 
				       [gallery_id = GalleryId]) + 1),
    {ok, ModifiedRecord}.

get_absolute_url() ->
    G = gallery(),
    I = image(),
    G:get_image_url() ++ "/" ++ I:slug().

next_image() ->
    G = gallery(),
    helpers:head_or_false(boss_db:find(galleryimage,[ordinality > Ordinality, gallery_id = G:id()],all,0,id,num_descending)).

prev_image() ->
    G = gallery(),
    helpers:head_or_false(boss_db:find(galleryimage,[ordinality < Ordinality, gallery_id = G:id()],all,0,id,num_ascending)).

has_other_galleries() ->
    I = image(),
    G = gallery(),
    helpers:is_nonzero(boss_db:count(galleryimage,[image_id = I:id(),
				gallery_id ≠ G:id()])).

other_galleries() ->
    I = image(),
    G = gallery(),
    boss_db:find(galleryimage,[image_id = I:id(),
			       gallery_id ≠ G:id()]).
