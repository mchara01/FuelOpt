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
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- insert into stations table: example
INSERT INTO db_fuelopt.stations_station
(station_id, street, postcode, lat, lng, name)
VALUES(1, 'GODSTONE ROAD', 'CR3 0EG', 51.3135, -0.0819079, 'BP WHYTELEAFE (GODSTONE ROAD SF CONNECT)');

-- instert into fuel_prices table: example
INSERT INTO db_fuelopt.stations_fuelprice
(unleaded_price, diesel_price, super_unleaded_price, premium_diesel_price, unleaded_date, diesel_date, super_unleaded_date, premium_diesel_date, station_id)
VALUES(151.9, 153.9, 164.9, 169.9, '2021-10-13', '2021-10-13', '2021-10-13', '2021-10-13', 1);

