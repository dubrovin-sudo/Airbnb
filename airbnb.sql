DROP DATABASE IF EXISTS airbnb;
CREATE DATABASE airbnb;
USE airbnb;


-- Create table of users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL, 
    email VARCHAR(120) UNIQUE NOT NULL,
    `password` TEXT NOT NULL, 
    user_type VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    login_with TINYINT(2),
    facebook_id VARCHAR(255) UNIQUE,
    twitter_id VARCHAR(255) UNIQUE,
    about TEXT,
    recieve_coupon TINYINT(2),
    created DATETIME DEFAULT NOW(), 
    modified DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
);


-- Create table of countries and their country code ISO 3166-1 alpha-2 (two-letter country code)
DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
	id SERIAL primary key,
	name VARCHAR(255) not NULL,
	code VARCHAR(255) not NULL
);



-- Create table of cities
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id SERIAL primary key,
	country_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(255) not NULL,
	FOREIGN KEY (country_id) REFERENCES countries(id) on delete RESTRICT
	
);


-- Create table of type of neighbourhood, i.e. one word description of area. It is for example “hip” or “quiet”
-- Neighborhoods are a way to help travelers make informed decisions about where to stay when planning a trip. 
-- When visiting a new city, it can be helpful to know which neighborhoods may fit your interests and the purpose of your trip.
-- On Airbnb, neighborhood boundaries are based on research with locals and city experts. 
-- A cartographer helps make sure these boundaries are accurate and up-to-date. 
-- This research also informs the detailed descriptions, photos, and stories about each neighborhood.

DROP TABLE IF EXISTS neighbourhood; 
CREATE TABLE neighbourhood (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	description TEXT,
	city_id BIGINT UNSIGNED NOT NULL,
	latitude VARCHAR(50) not NULL,
	longitude VARCHAR(50) not NULL,
	tags TEXT,
	added_by_user BIGINT UNSIGNED NOT NULL,
	created DATETIME DEFAULT NOW(),
	modified DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	FOREIGN KEY (city_id) REFERENCES cities(id) on delete RESTRICT,
	FOREIGN KEY (added_by_user) REFERENCES users(id) on delete cascade
);


-- Create table of type of property (“house”, “appertment”, “villa”, “guesthouse” and etc)
DROP TABLE IF EXISTS property_type;
CREATE TABLE property_type (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) not NULL,
	icon_image BLOB
);

-- Create table of amenities (“Wifi”, “Iron”, “heating”, “TV” and etc)
DROP TABLE IF EXISTS amenities;
CREATE TABLE amenities (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) not NULL,
	icon_image BLOB
);

-- Create table of amenities of properties
DROP TABLE IF EXISTS property_amenities;
CREATE TABLE property_amenities (
	id SERIAL PRIMARY KEY,
	property_id BIGINT UNSIGNED NOT NULL,
	amenity_id BIGINT UNSIGNED NOT NULL,
	created DATETIME DEFAULT NOW(),
	modified DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	FOREIGN KEY (property_id) REFERENCES property_type(id) on delete RESTRICT,
	FOREIGN KEY (amenity_id) REFERENCES amenities(id) on delete RESTRICT
);

-- Create table of room type
DROP TABLE IF EXISTS room_type;
CREATE TABLE room_type (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) not NULL,
	icon_image BLOB
);

-- Create table of languages
-- DROP TABLE IF EXISTS languages;
-- CREATE TABLE languages (
-- 	id SERIAL PRIMARY KEY,
-- 	name VARCHAR(255) not NULL,
-- 	code tinyint UNSIGNED,
-- 	created DATETIME,
-- 	modified DATETIME
-- );


DROP TABLE IF EXISTS currencies;
CREATE TABLE currencies (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) not NULL,
	icon_image BLOB
);

-- Create table of properties


DROP TABLE IF EXISTS properties;
CREATE TABLE properties (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	description TEXT,
	user_id BIGINT UNSIGNED NOT NULL,
	property_type_id BIGINT UNSIGNED NOT NULL,
	room_type_id BIGINT UNSIGNED NOT NULL,
	country_id BIGINT UNSIGNED NOT NULL,
	city_id BIGINT UNSIGNED NOT NULL, 
	address TEXT not NULL,
	latitude VARCHAR(50), 
	longitude VARCHAR(50),
	bedroom_count VARCHAR(10) not NULL, 
	bed_count VARCHAR(10) not NULL,
	bathroom_count VARCHAR(10) not NULL, 
	accomodates_count VARCHAR(10) not NULL, 
	avalability_type TINYINT(2) not NULL, 
	start_date DATE, 
	end_date DATE, 
	price DECIMAL(10) not NULL,
	currency_id BIGINT UNSIGNED NOT NULL,
	price_type TINYINT(2),
	minimum_stay VARCHAR(5),
	minimum_stay_type TINYINT(2),
	refund_type TINYINT(2),
	created DATETIME DEFAULT NOW(),
	modified DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	
	index properties_cities (city_id),
	index properties_price (price),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (property_type_id) REFERENCES property_type(id) on delete RESTRICT,
	FOREIGN KEY (room_type_id) REFERENCES room_type(id) on delete RESTRICT,
	FOREIGN KEY (country_id) REFERENCES countries(id) on delete RESTRICT,
	FOREIGN KEY (city_id) REFERENCES cities(id) on delete RESTRICT,
	FOREIGN KEY (currency_id) REFERENCES currencies(id) on delete RESTRICT
);

-- Create table of property's images


DROP TABLE IF EXISTS property_images;
CREATE TABLE property_images (
	id SERIAL PRIMARY KEY,
	property_id BIGINT UNSIGNED NOT NULL, 
	added_by_user BIGINT UNSIGNED NOT NULL,
	image BLOB,
	created DATETIME DEFAULT NOW(),
	index from_property_id(property_id),
	FOREIGN KEY (property_id) REFERENCES properties(id) on delete CASCADE,
	FOREIGN KEY (added_by_user) REFERENCES users(id) on delete CASCADE
);

-- Create table of promo codes
DROP TABLE IF EXISTS promo_codes;
CREATE TABLE promo_codes (
	id SERIAL PRIMARY KEY,
	title VARCHAR(255) not null,
	description TEXT,
	code VARCHAR(5) not null,
	discount DECIMAL(5) not null,
	created DATETIME DEFAULT NOW(),
	expiration_date DATETIME
	
);

-- Create table of bookings
DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings (
	id SERIAL PRIMARY KEY,
	property_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT null,
	check_in_date DATETIME,
	check_out_date DATETIME,
	price_per_day DECIMAL(10),
	price_for_stay DECIMAL(10),
	tax_paid DECIMAL(10),
	site_fees DECIMAL(10),
	amount_paid DECIMAL(10),
	is_refund BOOLEAN,
	cancel_date DATETIME,
	refund_paid DECIMAL(10),
	transaction_id BIGINT UNSIGNED NOT null,
	effective_amount DECIMAL(10),
	booking_data DATETIME,
	created DATETIME DEFAULT NOW(),
	modified DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	FOREIGN KEY (property_id) REFERENCES properties(id) on delete CASCADE,
	FOREIGN KEY (user_id) REFERENCES users(id) on delete CASCADE
);

-- Create table of property's reviews
DROP TABLE IF EXISTS property_reviews;
CREATE TABLE property_reviews (
	id SERIAL PRIMARY KEY,
	property_id BIGINT UNSIGNED NOT null,
	review_by_user BIGINT UNSIGNED NOT null,
	booking_id BIGINT UNSIGNED NOT null,
	comment TEXT,
	created DATETIME DEFAULT NOW(),
	modified DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	FOREIGN KEY (property_id) REFERENCES properties(id) on delete CASCADE,
	FOREIGN KEY (review_by_user) REFERENCES users(id),  
	FOREIGN KEY (booking_id) REFERENCES bookings(id)on delete cascade 
);

-- Create table of disputes
DROP TABLE IF EXISTS disputes;
CREATE TABLE disputes (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT null,
	property_id BIGINT UNSIGNED NOT null,
	booking_id BIGINT UNSIGNED NOT null,
	title VARCHAR(255) not NULL,
	description TEXT not NULL,
	discount DECIMAL(5), 
	created DATETIME DEFAULT NOW(),
	modified DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	FOREIGN KEY (property_id) REFERENCES properties(id) on delete CASCADE,
	FOREIGN KEY (user_id) REFERENCES users(id) on delete CASCADE,
	FOREIGN KEY (booking_id) REFERENCES bookings(id) on delete cascade 
);


-- Create table of transactions
DROP TABLE IF EXISTS transactions; 
CREATE TABLE transactions (
	id SERIAL PRIMARY KEY, 
	property_id BIGINT UNSIGNED NOT null,
	reciever_id BIGINT UNSIGNED NOT null, 
	payer_id BIGINT UNSIGNED NOT null,
	booking_id BIGINT UNSIGNED NOT null,
	site_fees DECIMAL(10) not NULL ,
	amount DECIMAL(10) not NULL,
	transfer_on DATETIME not NULL,
	currency_id BIGINT UNSIGNED NOT null,
	promo_code_id BIGINT UNSIGNED NOT null,
	discount_amt DECIMAL(5),
	created DATETIME DEFAULT NOW(),
	modified DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	index recievers(reciever_id),
	FOREIGN KEY (property_id) REFERENCES properties(id) on delete CASCADE,
	FOREIGN KEY (reciever_id) REFERENCES users(id) on delete CASCADE,
	FOREIGN KEY (payer_id) REFERENCES users(id) on delete CASCADE,	
	FOREIGN KEY (booking_id) REFERENCES bookings(id) on delete CASCADE,
	FOREIGN KEY (currency_id) REFERENCES currencies(id) on delete Restrict,	
	FOREIGN KEY (promo_code_id) REFERENCES promo_codes(id) on delete cascade	
);

-- ALTER TABLE bookings ADD FOREIGN KEY (transaction_id)
-- REFERENCES transactions(id);








































