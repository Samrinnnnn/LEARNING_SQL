--view--
--1.Create a view showing invoice details with customer name--
CREATE VIEW vw_invoice_detail AS
SELECT
i.invoice_id,
i.invoice_date,
i.total,
c.first_name as customer_first_name,
c.last_name as customer_last_name
FROM invoice i
JOIN customer c ON i.customer_id=c.customer_id;

SELECT *from vw_invoice_detail ;
--2.View of track with genre & media type--
CREATE VIEW vw_genre_media AS
SELECT 
t.name as track_name,
g.name as genre_name,
m.name as media_type_name
FROM track t
JOIN media_type m ON t.media_type_id=m.media_type_id
JOIN genre g ON t.genre_id=g.genre_id;
--3.Query data from view--
SELECT *from vw_genre_media 
WHERE genre_name = 'Rock';
--4.View showing number of tracks per genre--
CREATE VIEW vw_tracks AS
SELECT
g.name as genre_name,
count(t.track_id) as number_of_tracks
FROM track t
JOIN genre g on t.genre_id=g.genre_id--(leftjoin too)--
GROUP BY g.name
ORDER BY number_of_tracks DESC; --after only --
SELECT *FROM vw_genre_track_count ORDER BY number_of_tracks DESC;--here order can be used--

--5.View showing total sales per customer--
CREATE VIEW vw_total_sales AS
SELECT
c.first_name || ' ' || c.last_name AS full_name,

SUM(i.total) as total_sales
FROM customer c
JOIN invoice i ON c.customer_id=i.customer_id
GROUP BY full_name
ORDER BY total_sales DESC;

SELECT *from vw_USA;

--6.View showing total revenue per artist--

CREATE VIEW vw_revenue_artist AS
SELECT 
a.name as artist_name,
SUM(i.quantity*i.unit_price) as revenue
FROM invoice_line i
JOIN track t ON i.track_id=t.track_id
JOIN album al ON t.album_id=al.album_id
JOIN artist a ON al.artist_id=a.artist_id
GROUP BY a.name
--7.View of customers from USA only--
CREATE VIEW vw_USA    as          
SELECT 
first_name, last_name
From customer
where country='USA';

SELECT * FROM vw_track_details ORDER BY track_name;

--8.Create a simple updatable view--
UPDATE vw_customer_email        --join, group by updatable hard--
SET email = 'newmail@gmail.com'
WHERE customer_id = 5;
