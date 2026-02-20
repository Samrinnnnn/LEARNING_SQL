--functions--
--1.Create a function that returns the total amount spent by a customer using customer_id.--

CREATE FUNCTION amount_spent(p_customer_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
 total_spent NUMERIC;
 BEGIN
  SELECT SUM(total) INTO total_spent
  FROM invoice
  WHERE customer_id=p_customer_id;

  RETURN COALESCE(total_spent,0);
  END;
  $$;

  SELECT amount_spent(5);

  --2 Create a function that returns total number of tracks purchased by a customer.

CREATE FUNCTION tracks_purchased(p_customer_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
total_tracks INT;
BEGIN
SELECT COUNT(il.track_id) INTO total_tracks
FROM invoice_line il
JOIN invoice i ON il.invoice_id=i.invoice_id

WHERE i.customer_id=p_customer_id;

RETURN COALESCE(total_tracks,0);
  END;
  $$;
  SELECT tracks_purchased(1);

  --3.Return all purchased track names for a customer.--

  CREATE FUNCTION purchased_track_name (p_customer_id INT)
  RETURNS TEXT
  LANGUAGE plpgsql
  AS $$
  DECLARE 
  track_names TEXT;
  BEGIN
  SELECT t.track_names
  JOIN 

  Use DROP FUNCTION accept_artist(text) ;
 --4.Create a function that accepts an artist name and returns the length of that name.--
CREATE OR REPLACE FUNCTION accept_artist(p_name TEXT)
RETURNS INT
LANGUAGE plpgsql
AS $$
 BEGIN
  RETURN length(p_name);
  END;
  $$;

  SELECT accept_artist('accept');

  --5.Create a function that:Accepts an artist_id,Returns the artist name from the artist table,If the artist does not
  --exist, return NULL
--Must use:DECLARE,SELECT INTO,Return type: TEXT

CREATE OR REPLACE FUNCTION artist_id_returnn(p_artist_id INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
 artist_name TEXT;
BEGIN
SELECT name INTO artist_name
FROM artist
WHERE artist_id=p_artist_id;
RETURN artist_name;
END;
$$;

SELECT artist_id_returnn(45666);

--6.Create a function that:Accepts an artist_id,Returns:,'EXISTS' if the artist exists,'NOT EXISTS' if the artist does not exist
--Must use:IF,SELECT INTO,Return type: TEXT

CREATE FUNCTION fn_accept_artistid(p_artist_id INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
c_artist_id INT;
BEGIN
SELECT COUNT(artist_id) INTO c_artist_id
FROM artist
where artist_id=p_artist_id;
if c_artist_id > 0
 THEN RETURN 'EXIST';
ELSE
RETURN ' NOT EXIST';
END IF;
END;
$$;

SELECT fn_accept_artistid(2);

--7.Create a function that:Accepts an artist_id,Returns:,Artist name if found
--'UNKNOWN ARTIST' if not found,Must use:SELECT INTO,IF artist_name IS NULL,Return type: TEXT

CREATE FUNCTION fn_artist_name(p_artist_id INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE 
artist_name TEXT;
  
BEGIN
SELECT name INTO artist_name
FROM artist
where artist_id=p_artist_id;
IF artist_name IS NULL
  THEN RETURN 'UNKNOWN ARTIST';
  ELSE
  RETURN artist_name ;
  END IF;
  END;
  $$;

  SELECT fn_artist_name(0);

 --8. Create a PostgreSQL function that:,Accepts an album_id,Calculates the total number of tracks in that album
--Uses LOOP (not COUNT directly),Must:,Fetch tracks belonging to the album
--Increment a counter inside a LOOP,Returns the total track count as INT

CREATE  FUNCTION fn_accept_album_id(p_album_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE total_tracks INT;
BEGIN
SELECT 
 album_id
FROM track
where album_id=p_album_id;


--9PostgreSQL function that:Accepts an album_id;Returns:Album title,Artist name,Uses:,JOIN,SELECT INTO--
CREATE OR REPLACE FUNCTION fn_album_artist(p_album_id INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE 
album_title TEXT;
artist_name TEXT;
BEGIN
SELECT al.title,a.name INTO album_title, artist_name
FROM album al
JOIN artist a ON al.artist_id=a.artist_id::integer
where al.album_id=p_album_id;
RETURN album_title,artist_name;
END;
$$;


SELECT fn_album_artist(2);

CREATE OR REPLACE FUNCTION fn_album_artist(p_album_id INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE 
    album_title TEXT;
    artist_name TEXT;
BEGIN
    SELECT al.title, a.name
    INTO album_title, artist_name
    FROM album al
    JOIN artist a ON al.artist_id = a.artist_id
    WHERE al.album_id = p_album_id;

    IF album_title IS NULL THEN
        RETURN 'ALBUM NOT FOUND';
    END IF;

    RETURN album_title || ' - ' || artist_name;
END;
$$;




















