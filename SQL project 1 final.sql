/** 
Who is the senior most employee based on the job title
**/
select employee_id as seniormost_employee_id,levels 
from employee
order by levels DESC
limit 1;

/**
Which countries have the most invoices 
**/
select billing_country,count(billing_country) as count
from invoice
group by billing_country
order by count desc;

/**
What are the top 3 values of total invoice
**/
select total from invoice
order by total desc
limit 3;

/**
Write a query to return the details of a customer who has the maximum spendings
**/
select *
from customer
where customer_id In (select customer_id
from invoice
group by customer_id
order by sum(total)desc
limit 1);
	
/**
Write a query to return that one city which has the highest sum of invoice totals 
**/
select billing_city,sum(total) as t
from invoice
group by billing_city
order by t desc
limit 1;

/**
Write a query to return the email,firstname,lastname of all the Rock music listeners.
Return the list ordered alphabetically by email starting from A
**/
select  first_name,last_name,email
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
    select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name = 'Rock'
)
group by 1,2,3
order by 3

/**
Return all the track names that have the song length longer than the average song length. Return the
names and milliseconds for each track. Order by song length with the longest song listed first.
**/
select name as track_name,milliseconds as length
from track
where milliseconds >(select avg(milliseconds) from track)
order by 2 desc

/**
Find out total amount spent by each customer.
**/
select first_name,last_name,sum(invoice.total) as total_amount_spent
from customer
join invoice on customer.customer_id = invoice.customer_id
group by 1,2
order by 1

/**
We want to find out the most popular music genre for each country.We determine the most popular genre 
as the genre with the highest amount of puchases.Write a query to return each country along with top genre.
**/
with popular_genre as(select customer.country,genre.name,count(invoice_line.quantity) as puchases,
					  
					  ROW_NUMBER() over (partition by customer.country order by count(invoice_line.quantity) desc) as row_no
                      from invoice_line
                      join invoice on invoice.invoice_id = invoice_line.invoice_id
                      join customer on customer.customer_id = invoice.customer_id
                      join track on track.track_id = invoice_line.track_id
                      join genre on genre.genre_id = track.genre_id
                      group by 1,2
                      order by 1 asc, 3 desc
)
select * from popular_genre where row_no<=1

/**
Write a query that determines the customer that has spent the most on music for each country. Write
a query that returns the country along with the top customer's name and the total amount they have spent.
**/

with ce as(select billing_country,customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) as total_amount_spent,
		   row_number() over(partition by billing_country order by sum(total) desc) as rn
           from invoice
		   join customer on customer.customer_id = invoice.customer_id
           group by 1,2,3,4
           order by 1 asc)
select * from ce where rn<=1;








