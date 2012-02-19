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

prev_image() ->
    G = gallery(),
    case boss_db:count(galleryimage,[id > Id, gallery_id = G:id()]) of 
	0 ->
	    false;
	_ ->
	    [P|_Rest] = boss_db:find(galleryimage,[id > Id, gallery_id = G:id()],all,0,id,str_descending),
	    P
    end.

next_image() ->
    G = gallery(),
    case boss_db:count(galleryimage,[id < Id, gallery_id = G:id()]) of 
	0 ->
	    false;
	_ ->
	    [N|_Rest] = boss_db:find(galleryimage,[id < Id, gallery_id = G:id()],all,0,id,str_ascending),
	    N
    end.

is_nonzero(R) ->
    case R of
	0 ->
	    false;
	_ ->
	    true
   end.

has_other_galleries() ->
    I = image(),
    G = gallery(),
    is_nonzero(boss_db:count(galleryimage,[image_id = I:id(),
				gallery_id ≠ G:id()])).

other_galleries() ->
    I = image(),
    G = gallery(),
    boss_db:find(galleryimage,[image_id = I:id(),
			       gallery_id ≠ G:id()]).
