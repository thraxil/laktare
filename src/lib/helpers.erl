-module(helpers).
-compile(export_all).

populate_test_data() ->
    G = gallery:new(id,"first gallery",slug,"description",ordinality),
    {ok,SG1} = G:save(),
    I = image:new(id,"first image",slug,"description",created,"medium","1d3964dfd1664247fef81c265dedd7a4c040eb3a",".jpg"),
    {ok,SI1} = I:save(),
    SI3 = SI1:set(created_time,{{2012,2,25},{23,20,9}}),
    {ok,SI4} = SI3:save(),
    I2 = image:new(id,"second image",slug,"description",created_time,"medium","477da14b4128da9e94677d5a61e786874484cd12",".jpg"),
    {ok,SI2} = I2:save(),
    GI = galleryimage:new(id,SG1:id(),SI4:id(),ordinality),
    {ok,SGI1} = GI:save(),
    GI2 = galleryimage:new(id,SG1:id(),SI2:id(),ordinality),
    {ok,SGI2} = GI2:save(),
    {SG1,SI4,SGI1,SI2,SGI2}.

% from: http://lethain.com/formatting-multipart-formdata-in-erlang/
format_multipart_formdata(Boundary, Fields, Files) ->
    FieldParts = lists:map(fun({FieldName, FieldContent}) ->
                                   [lists:concat(["--", Boundary]),
                                    lists:concat(["Content-Disposition: form-data; name=\"",atom_to_list(FieldName),"\""]),
                                    "",
                                    FieldContent]
                           end, Fields),
    FieldParts2 = lists:append(FieldParts),
    FileParts = lists:map(fun({FieldName, FileName, FileContent}) ->
                                  [lists:concat(["--", Boundary]),
                                   lists:concat(["Content-Disposition: format-data; name=\"",atom_to_list(FieldName),"\"; filename=\"",FileName,"\""]),
                                   lists:concat(["Content-Type: ", "application/octet-stream"]),
                                   "",
                                   FileContent]
                          end, Files),
    FileParts2 = lists:append(FileParts),
    EndingParts = [lists:concat(["--", Boundary, "--"]), ""],
    Parts = lists:append([FileParts2, EndingParts]),
    string:join(Parts, "\r\n").

is_nonzero(0) ->
    false;
is_nonzero(_) ->
    true.

head_or_false([]) ->
    false;
head_or_false([H|_]) ->
    H.

