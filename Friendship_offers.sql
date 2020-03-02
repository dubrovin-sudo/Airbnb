/*Подборка юзеров из других стран для общения между собой,
 * из других стран
 */

drop procedure if exists friendship_offers;

delimiter //
create procedure friendship_offers (in for_user_id BIGINT)
begin
	-- 
	select p2.user_id
	from properties p1
	join properties p2 on p1.country_id <> p2.country_id 
	where p1.user_id = for_user_id
		and p2.user_id <> for_user_id  
	order by rand()
	limit 5
	
; 
end//
delimiter ; 

call friendship_offers(1);