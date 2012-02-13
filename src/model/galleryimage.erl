-module(galleryimage,[Id,GalleryId,ImageId,Ordinality]).
-compile(export_all).

-belongs_to(gallery).
-belongs_to(image).

before_create() ->
    ModifiedRecord = set(ordinality,
			 boss_db:count(galleryimage, 
				       [gallery_id = GalleryId]) + 1),
    {ok, ModifiedRecord}.
    
