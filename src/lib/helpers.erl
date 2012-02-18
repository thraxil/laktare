-module(helpers).
-compile(export_all).

populate_test_data() ->
    G = gallery:new(id,"first gallery",slug,"description",ordinality),
    {ok,SG1} = G:save(),
    I = image:new(id,"first image",slug,"description",created,"medium","1d3964dfd1664247fef81c265dedd7a4c040eb3a",".jpg"),
    {ok,SI1} = I:save(),
    GI = galleryimage:new(id,SG1:id(),SI1:id(),ordinality),
    {ok,SGI1} = GI:save(),
    {SG1,SI1,SGI1}.
