-module(laktare_gallery_controller,[Req]).
-compile(export_all).

index('GET',[]) ->
    Galleries = boss_db:find(gallery,[]),
    RecentImages = boss_db:find(image,[],15),
    {ok,[{images,RecentImages},{galleries,Galleries}]}.

view('GET',[GalleryId]) ->
    Gallery = boss_db:find(GalleryId),
    {ok,[{gallery,Gallery}]}.

image('GET',[GalleryId,ImageSlug]) ->
    Gallery = boss_db:find(GalleryId),
    [Image|_] = boss_db:find(image,[slug=ImageSlug]),
    ImageId = Image:id(),
    [GalleryImage|_] = boss_db:find(galleryimage,
				[image_id=ImageId,gallery_id=GalleryId]),
    {ok,[{gallery,Gallery},{image,Image},{gi,GalleryImage}]}.
