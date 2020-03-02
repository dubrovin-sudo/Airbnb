DROP FUNCTION IF EXISTS airbnb.rating_users;

DELIMITER $$
$$
CREATE FUNCTION airbnb.rating_users(check_user INT)
RETURNS float reads sql data

begin
	declare users_book int;
	declare users_reviews int;
	declare users_disputes int;

	set users_book = (
		select count(*)
		from airbnb.bookings 
		where user_id = check_user
	);

	set users_reviews = (
		select count(*)
		from airbnb.property_reviews 
		where review_by_user = check_user
	);

	set users_disputes = (
		select count(*)
		from airbnb.disputes 
		where user_id = check_user
	);

	return users_book + users_reviews - users_disputes;
END$$
DELIMITER ;
