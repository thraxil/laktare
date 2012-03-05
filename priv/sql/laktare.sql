BEGIN;
CREATE TABLE "images" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(256) NOT NULL,
    "slug" varchar(256) NOT NULL,
    "description" text default '',
    "created_time" timestamp with time zone NOT NULL,
    "medium" varchar(256) NOT NULL,
    "ahash" varchar(256),
    "extension" varchar(256)
)
;
CREATE TABLE "galleries" (
    "id" serial NOT NULL PRIMARY KEY,
    "title" varchar(256) NOT NULL,
    "slug" varchar(50) NOT NULL,
    "description" text default '',
    "ordinality" smallint CHECK ("ordinality" >= 0) NOT NULL
)
;
CREATE TABLE "galleryimages" (
    "id" serial NOT NULL PRIMARY KEY,
    "gallery_id" integer NOT NULL REFERENCES "galleries" ("id") DEFERRABLE INITIALLY DEFERRED,
    "image_id" integer NOT NULL REFERENCES "images" ("id") DEFERRABLE INITIALLY DEFERRED,
    "ordinality" smallint CHECK ("ordinality" >= 0) NOT NULL
)
;
COMMIT;
