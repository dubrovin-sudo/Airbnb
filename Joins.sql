USE airbnb;


-- Consolidation of results of bookings and transactions
SELECT check_in_date, check_out_date, booking_data, transactions.id, transactions.reciever_id, transactions.payee_id, transactions.currency_id, transactions.promo_code_id, transactions.property_id 
FROM bookings
INNER JOIN transactions 
ON bookings.id = transactions.id;

-- Consolidation of results of users and properties tables
select firstname, lastname, email, date_of_birth, facebook_id, properties.address, properties.country_id, properties.city_id, properties.latitude, properties.longitude
from users 
inner join properties 
on users.id = properties.user_id;



