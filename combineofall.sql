--PRACTICAL QUE--
--1.Create a table music_award with primary key.
CREATE TABLE music_award(
award_name VARCHAR(50),
award_id SERIAL PRIMARY KEY,
award_year INT NOT NULL
);
--2.Create table to store favorite tracks per customer.
CREATE TABLE fav_tracks(
customer_id INT,
track_id INT,
PRIMARY KEY(customer_id,track_id)
);
--3.Add Foreign Keys to Above Table
ALTER TABLE fav_tracks
ADD CONSTRAINT fk_track
FOREIGN KEY(track_id)
REFERENCES track (track_id);

ALTER TABLE fav_tracks
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

--4.Create Invoice Archive with FK
CREATE TABLE invoice_archive(
archive_id SERIAL PRIMARY KEY,
invoice_id INT,
FOREIGN KEY(invoice_id)
REFERENCES invoice(invoice_id)
ON DELETE SET NULL
);

--5.Show Artist and Album Names
SELECT a.name as artist_name,
al.title as album_name
FROM artist a
JOIN album al ON a.artist_id=al.artist_id;

--6.Show Track, Album, Artist
SELECT t.name as track_name,
al.title as album_title,
a.name as artist_name
FROM track t
JOIN album al ON t.album_id=al.album_id
JOIN artist a ON al.artist_id=a.artist_id;

--7.Find Top Spending Customers
SELECT customer_id, SUM(total) as total_spending
FROM invoice
GROUP BY customer_id
ORDER BY total_spending DESC;
--BY NAME
SELECT c.first_name||' '|| c.last_name as full_name, SUM(i.total) as total_spent
FROM invoice i
JOIN customer c ON i.customer_id=c.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;
--8.Customers Who Never Purchased
SELECT c.first_name||'  '|| c.last_name as full_name,i.total
FROM invoice i
LEFT JOIN customer c ON i.customer_id=c.customer_id
where i.total IS NULL;
--9.Create View for Customer Spending
CREATE VIEW vw_customer_spend as 

SELECT customer_id, SUM(total) as total_spending
FROM invoice
GROUP BY customer_id
ORDER BY total_spending DESC;

--TO CALL VIEW
SELECT *FROM vw_customer_spend; 

--10. View for Artist Track Count
SELECT a.name as artist_name, COUNT(t.track_id) as artist_track
FROM artist a
JOIN album al ON a.artist_id=al.artist_id
JOIN track t ON al.album_id=t.album_id
GROUP BY a.name;
--11.Function to Get Artist Name by ID
CREATE OR REPLACE FUNCTION f_get_artist(p_artist_id int)
RETURNS TEXT
LANGUAGE plpgsql 
AS $$
DECLARE
artist_name TEXT;
BEGIN
SELECT a.name INTO artist_name
FROM artist a
where artist_id=p_artist_id;
RETURN artist_name;
END;
$$;
--CALL--
SELECT f_get_artist(7);

--12.Function to Return Total Tracks per Album
CREATE FUNCTION f_tracks_per_album(p_album_name TEXT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
total_tracks INT;
BEGIN
SELECT COUNT(t.track_id) INTO  total_tracks
FROM album al
JOIN track t ON al.album_id=t.album_id
WHERE al.title=p_album_name;
RETURN total_tracks;
END;
$$;
--Call--
SELECT *FROM album;
SELECT  f_tracks_per_album('A Matter of Life and Death');


--13.Create Index on Track Name
CREATE INDEX ind_track
ON track(name);

--CALL--
SELECT * FROM track WHERE name = 'Balls to the Wall';
SELECT *from track;

--14.Create Composite Index

CREATE INDEX comp_index
ON track(album_id,name);


--CALL--
SELECT *FROM track WHERE album_id=19;

--TEST--
SELECT *FROM artist WHERE artist_id=2;

SELECT *from track WHERE track_id=2;

--15.Check Indexes

SELECT *
FROM pg_indexes
WHERE tablename = 'track';


--16.Most Popular Genre
SELECT g.name as genre_name,g.genre_id,COUNT(t.track_id) as total_tracks
FROM genre g
JOIN track t ON g.genre_id=t.genre_id
GROUP BY g.genre_id
ORDER BY total_tracks DESC;
--IF TOP 5, THEN ADDING LIMIT AFTER ORDER BY
LIMIT 5;

--17.Create View for Top 5 Artists by Sales
CREATE VIEW vw_top5_artist as

SELECT a.name as artist_name, SUM(i.total) as revenue
FROM artist a
JOIN album al ON a.artist_id=al.artist_id
JOIN track t ON t.album_id=al.album_id
JOIN invoice_line il ON t.track_id=il.track_id
JOIN  invoice i ON il.invoice_id=i.invoice_id
GROUP BY a.name
ORDER BY revenue DESC
LIMIT 5;

--CALL--
SELECT *FROM  vw_top5_artist;

--18.Function to Return Customer Total Spending

CREATE OR REPLACE FUNCTION total_spending(p_customer_name TEXT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
total_spending INT;
BEGIN
SELECT SUM(i.total) INTO total_spending
FROM invoice i
JOIN customer c ON i.customer_id=c.customer_id
WHERE c.first_name=p_customer_name;
RETURN total_spending INT;
END;
$$;
--CALL--
SELECT *FROM total_spending('Kara');

--19 Function that Accepts artist_id,Returns artist name and total number of albums.
CREATE OR REPLACE FUNCTION f_total_number_albums(p_artist_id INT)
RETURNS TABLE(
artist_name VARCHAR,
total_albums BIGINT  
)
LANGUAGE plpgsql
AS $$
BEGIN
RETURN QUERY
SELECT a.name,COUNT(al.album_id) 
FROM artist a
JOIN album al ON a.artist_id=al.artist_id
where a.artist_id=p_artist_id
GROUP BY a.name;
END;
$$;

SELECT *FROM f_total_number_albums(99);

--20. Return All Tracks of an Album(Takes album_id,Returns track name + genre)

CREATE OR REPLACE FUNCTION f_all_tracks(p_album_id INT)
RETURNS TABLE(
track_name VARCHAR,
genre_name VARCHAR
)
language plpgsql
AS $$
BEGIN
RETURN QUERY
SELECT t.name, g.name 
FROM track t
JOIN genre g ON t.genre_id=g.genre_id
where t.album_id=p_album_id;
END;
$$;
--CALL
SELECT *FROM f_all_tracks(99);

--21.Most Popular Genre by Sales Revenue
CREATE OR REPLACE FUNCTION f_popular_genre()
RETURNS TABLE(
genre_name VARCHAR,
revenue NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
RETURN QUERY
SELECT g.name,SUM(i.total):: NUMERIC
FROM genre g
JOIN track t on g.genre_id=t.genre_id
JOIN invoice_line il on t.track_id=il.track_id
JOIN invoice i ON il.invoice_id=i.invoice_id
GROUP BY g.name
ORDER BY revenue;
END;
$$;

SELECT *FROM f_popular_genre();















DROP table  invoice_archive;
SELECT *FROM invoice_archive;




DROP TABLE fav_tracks;


SELECT 
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name IN ('customer', 'playlist')
ORDER BY table_name, column_name;



