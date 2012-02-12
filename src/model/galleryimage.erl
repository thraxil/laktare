-module(galleryimage,[Id,GalleryId,ImageId,Ordinality]).
-compile(export_all).

-belongs_to(gallery).
-belongs_to(image).
