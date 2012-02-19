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


    % def has_other_galleries(self):
    %     return self.other_galleries().count() > 0

    % def other_galleries(self):
    %     return self.image.galleryimage_set.all().exclude(gallery=self.gallery)
