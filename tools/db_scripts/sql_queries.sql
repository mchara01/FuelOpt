-- create fuel_prices table
CREATE TABLE `stations_fuelprice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `unleaded_price` decimal(4,1) DEFAULT NULL,
  `diesel_price` decimal(4,1) DEFAULT NULL,
  `super_unleaded_price` decimal(4,1) DEFAULT NULL,
  `premium_diesel_price` decimal(4,1) DEFAULT NULL,
  `unleaded_date` date DEFAULT NULL,
  `diesel_date` date DEFAULT NULL,
  `super_unleaded_date` date DEFAULT NULL,
  `premium_diesel_date` date DEFAULT NULL,
  `station_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `stations_fuelprice_station_id_3a85ef52_fk_stations_` (`station_id`),
  CONSTRAINT `stations_fuelprice_station_id_3a85ef52_fk_stations_` FOREIGN KEY (`station_id`) REFERENCES `stations_station` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- create stations table
CREATE TABLE `stations_station` (
  `name` varchar(200) NOT NULL,
  `street` varchar(200) NOT NULL,
  `postcode` varchar(12) NOT NULL,
  `lat` decimal(10,7) NOT NULL,
  `lng` decimal(10,7) NOT NULL,
  `station_id` int(11) NOT NULL,
  `car_wash` tinyint(1) NOT NULL DEFAULT 0,
  `air_and_water` tinyint(1) NOT NULL DEFAULT 0,
  `car_vacuum` tinyint(1) NOT NULL DEFAULT 0,
  `24_7_opening_hours` tinyint(1) NOT NULL DEFAULT 0,
  `toilet` tinyint(1) NOT NULL DEFAULT 0,
  `convenience_store` tinyint(1) NOT NULL DEFAULT 0,
  `atm` tinyint(1) NOT NULL DEFAULT 0,
  `parking_facilities` tinyint(1) NOT NULL DEFAULT 0,
  `disabled_toilet_baby_change` tinyint(1) NOT NULL DEFAULT 0,
  `alcohol` tinyint(1) NOT NULL DEFAULT 0,
  `wi_fi` tinyint(1) NOT NULL DEFAULT 0,
  `hgv_psv_fueling` tinyint(1) NOT NULL DEFAULT 0,
  `fuelservice` tinyint(1) NOT NULL DEFAULT 0,
  `payphone` tinyint(1) NOT NULL DEFAULT 0,
  `restaurant` tinyint(1) NOT NULL DEFAULT 0,
  `electric_car_charging` tinyint(1) NOT NULL DEFAULT 0,
  `repair_garage` tinyint(1) NOT NULL DEFAULT 0,
  `shower_facilities` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- insert into stations table: example
INSERT INTO db_fuelopt.stations_station
(station_id, street, postcode, lat, lng, name)
VALUES(1, 'GODSTONE ROAD', 'CR3 0EG', 51.3135, -0.0819079, 'BP WHYTELEAFE (GODSTONE ROAD SF CONNECT)');

-- instert into fuel_prices table: example
INSERT INTO db_fuelopt.stations_station
(name, street, postcode, lat, lng, station_id, car_wash, air_and_water, car_vacuum, `24_7_opening_hours`, toilet, convenience_store, atm, parking_facilities, disabled_toilet_baby_change, alcohol, wi_fi, hgv_psv_fueling, fuelservice, payphone, restaurant, electric_car_charging, repair_garage, shower_facilities)
VALUES('BP WHYTELEAFE (GODSTONE ROAD SF CONNECT)', 'GODSTONE ROAD', 'CR3 0EG', 51.3134521, -0.0819079, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0);

-- instert into fuel_prices table: example
INSERT INTO db_fuelopt.stations_fuelprice
(id, unleaded_price, diesel_price, super_unleaded_price, premium_diesel_price, unleaded_date, diesel_date, super_unleaded_date, premium_diesel_date, station_id)
VALUES(1, 151.90, 153.90, 164.90, 169.90, '2021-10-13', '2021-10-13', '2021-10-13', '2021-10-13', 1);

