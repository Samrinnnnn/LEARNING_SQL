--PRIMARY KEY,FOREIGN KEY--
--PRIMARY KEY--
--1.Create a table called music_label with:LabelId (Primary Key),LabelName
CREATE TABLE music_label(
label_id  SERIAL PRIMARY KEY,
label_name VARCHAR(100) NOT NULL 
);

DROP TABLE IF EXISTS music_label;
--2.Add primary key to music_label if not defined.
ALTER TABLE music_label
ADD CONSTRAINT music_label_pkey
 PRIMARY KEY(label_id);
 --3.Create table label_artist with composite primary key.
CREATE TABLE label_artist(
label_id INT,
artist_id INT,
PRIMARY KEY(label_id,artist_id)
);
--4.Insert duplicate primary key to test constraint.
INSERT INTO music_label(label_name)
VALUES( 'UK MUSIC HUB');

INSERT INTO music_label(label_id,label_name)
VALUES('1','SONY MUSIC');

--.Know constraint_name:
SELECT constraint_name 
FROM information_schema.table_constraints 
WHERE table_name = 'artist_parent' 
AND constraint_type = 'FOREIGN KEY';

--5.Remove primary key.
ALTER TABLE music_label
DROP CONSTRAINT  music_label_pkey;

--6.Create digital_release table with UUID PK.
CREATE TABLE digital_release(
digital_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
title           VARCHAR(100) NOT NULL
);

--7 Create table without SERIAL.
CREATE TABLE physical_store(
stored_id  INT  PRIMARY KEY,
stored_name TEXT NOT NULL
);

--8.Insert NULL into primary key column.

INSERT INTO physical_store(stored_id,stored_name)
VALUES(NULL,'ASIAN POP');

--9.Change primary key from one column to another.

ALTER TABLE physical_store
DROP CONSTRAINT physical_store_pkey;
ALTER TABLE physical_store
ADD PRIMARY KEY(stored_name);

--FOREIGN KEY--

--1.Create Parent Table

CREATE TABLE artist_parent(
artist_id  SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL
);
 --2.Create Child Table with Foreign Key--
 CREATE TABLE album_child(
album_id SERIAL PRIMARY KEY,
title VARCHAR(50),
artist_id INT,
FOREIGN KEY(artist_id)
REFERENCES artist_parent(artist_id)
 );
--3.Insert Valid Data
INSERT INTO artist_parent(name)
VALUES('RJK');
INSERT INTO album_child(title,artist_id)
VALUES('Sunshine',2);

SELECT *from artist;
--4.Insert Invalid Foreign Key

INSERT INTO album_child(title,artist_id)
VALUES('RAIN',6);
--WHAT IF--
INSERT INTO artist_parent(name)
VALUES('The Beatles');
INSERT INTO album_child(title,artist_id)
VALUES('RAIN',3);
--5.ON DELETE CASCADE
CREATE TABLE album_cascade(
album_id SERIAL PRIMARY KEY,
artist_id INT,
FOREIGN KEY(artist_id)
REFERENCES artist_parent(artist_id)
ON DELETE CASCADE
);

DROP TABLE IF EXISTS album_cascade CASCADE;

--6.ON DELETE SET NULL
CREATE TABLE album_delete(
album_id SERIAL PRIMARY KEY,
artist_id INT,
FOREIGN KEY(artist_id)
REFERENCES artist_parent(artist_id)
ON DELETE SET NULL
);
--7.Add Foreign Key Later (ALTER)
ALTER TABLE album_child
ADD CONSTRAINT f_artist_id
FOREIGN KEY(artist_id)
REFERENCES artist_parent(artist_id);

--8.Composite Foreign Key
-- a. Create the Parent Table with a Composite Primary Key
CREATE TABLE PlaylistTrack (
    PlaylistId INTEGER NOT NULL,
    TrackId INTEGER NOT NULL,
    PRIMARY KEY (PlaylistId, TrackId), -- This is a Composite Primary Key
    FOREIGN KEY (PlaylistId) REFERENCES Playlist (PlaylistId),
    FOREIGN KEY (TrackId) REFERENCES Track (TrackId)
);
-- b. Create the Child Table with a Composite Foreign Key
CREATE TABLE PlaylistTrackNotes (
    NoteId SERIAL PRIMARY KEY,
    PlaylistId INTEGER,
    TrackId INTEGER,
    NoteText TEXT,
    -- This defines the COMPOSITE FOREIGN KEY
    FOREIGN KEY (PlaylistId, TrackId) 
        REFERENCES PlaylistTrack (PlaylistId, TrackId)
        ON DELETE CASCADE
);

--9.View Foreign Keys in Database
SELECT *
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';

--10.Drop Foreign Key
ALTER TABLE album_child
DROP CONSTRAINT f_artist_id ;



