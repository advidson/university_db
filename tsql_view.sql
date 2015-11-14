select client_id, c.name, c.family
from (
	select client_id, 
			(case when COUNT(book_id) >= 2 then 1 end) as num_of_books 
	from journal 
	where return_date_real IS not null 
	group by client_id
) as sort_client
join clients c ON client_id = c.id
where num_of_books IS NOT NULL
