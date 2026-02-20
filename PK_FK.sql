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
WHERE table_name = 'physical_store' 
AND constraint_type = 'PRIMARY KEY';

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


 