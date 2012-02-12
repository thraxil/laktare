-module(gallery,[Id,Title,Slug,Description,Ordinality]).
-compile(export_all).

-has({galleryimage,many,[{sort_by,ordinality}]}).
