-- Who is the senior most employee based on job title?
/* 'Employee' table contain 'level' column which represents the level to the employeees. 
Higher the level, higher the position, senior the person. 
Hence in order to get the senior most employee we need to find the employee who has higher level.*/
select first_name, last_name, levels from employee 
order by levels DESC
limit 1;

-- Which countries have most Invoices?
/* In 'invoice' table we have 'billing_country' column.
In order to get the country which have most invoices we need to calculate 'Invoice_id' count for each country.*/
select count(invoice_id) as invoice_count, billing_country from invoice
group by billing_country
order by invoice_count DESC;

-- What are the top 3 values of total invoice?
/* Here we just need to arrange 'total' column into descresing order. */
select total from invoice 
order by total DESC
limit 3;

-- Which city has the best customers? We would like to throw a promotional Music Festival in the City we made the most money. Write a query that returns one city has the highest sum of invoice totals. Return both the city name and sum of all invoice totals.
/* Here we will be dealing with 'billing_city' column.
 The city which has highest sum of invoice total that city will be choosen for Music Festival.
 In order to get the sum of total we have to use aggregate function 'sum()' and by ordering it in descending order we will get the city with highest total invoice. */
select billing_city, sum(total) as invoice_total from invoice 
group by billing_city
order by invoice_total desc;

-- Who is the best customer? The customer who has spent the most money will be declared as the best customer. Write a query that returns the person who has spnetthe most money.
/* Here we have to deal with two tables at the same time hence we have to join two tables which are 'customer' and 'invoice' base on common column which is 'customer_id'.*/
select c.customer_id, c.first_name, c.last_name, sum(i.total) as total_invoice
from customer as c inner join invoice as i
on c.customer_id = i.customer_id
group by c.customer_id
order by total_invoice DESC
limit 1;

-- Let's invite the artist who have written the most rock music in our dataset. Write a query that returns the Artist name and totla count of the top 10 rock bands.
/*To understand the connection refer the Schema Diagram*/
select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from artist join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by number_of_songs DESC
limit 10;

-- Write query to retun the email, first name and genre of all rock mucis listeners. Return your list ordered alphabetically by email starting with A.
/* To undetstand the connection between the tables refer to Schema Diagram */
select distinct(customer.email), customer.first_name, genre.name
from customer join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
order by email asc;

--or

select distinct email, first_name
from customer join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by email;

--Retuen all the track names that have a song length longer than the average sond length. Order by the song length with the longest songs listed first.
/* Here we are dealing with 'track' table.
 This query will get solve in two steps. 
 First we need to find the average length of song/track and then we need to compare other track with it.
 So we are using subquery here. */
select name, milliseconds from track
where milliseconds > (
	select avg(milliseconds) as song_length
	from track )
order by milliseconds desc;

-- Find the money spnet by each customer on artist. Write a query which retuern the customer name, artist name and total spent.
/*Here we are dealing with five tables in total. 
'Invoice' table have 'total' column but that column represents the MRP of one song/ track only. 
Here we want to find the sale per quantity.*/
select c.first_name, a.name, sum(inline.unit_price*inline.quantity) as total_sale
from customer as c join invoice on c.customer_id = invoice.customer_id
join invoice_line as inline on inline.invoice_id = invoice.invoice_id
join track on track.track_id = inline.track_id
join album on album.album_id = track.album_id
join artist as a on a.artist_id = album.artist_id
group by 1, 2
order by total sale;




























