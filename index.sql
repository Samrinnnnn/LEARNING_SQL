--INDEX--
--1. Create an index on artist.name for faster search.
CREATE INDEX idx_artist_search
ON artist(name);

--2. Make sure album.title is unique.
CREATE UNIQUE INDEX idx_album_title
ON album(title);

--3.Index on track(album_id, genre_id)
CREATE INDEX idx_track_ai_gi
ON track(album_id,genre_id);

--4.Remove an index
DROP INDEX idx_artist_search;

--5.Index for LIKE queries,Question: Index to speed up LIKE 'A%' search
CREATE INDEX idx_for_like
ON artist (name text_pattern_ops );
--6.Index for Foreign Key Column
CREATE INDEX idx_foreign_key_column
ON album(artist.id);

--7.View all index
SELECT tablename,
       indexname,
       indexdef
FROM pg_indexes
WHERE schemaname = 'public';


