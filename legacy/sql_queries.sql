-- create fuel_prices table
CREATE TABLE `fuel_prices` (
  `unleaded` float DEFAULT NULL,
  `diesel` float DEFAULT NULL,
  `super_unleaded` float DEFAULT NULL,
  `premium_diesel` float DEFAULT NULL,
  `unleaded_date` date DEFAULT NULL,
  `diesel_date` date DEFAULT NULL,
  `super_unleaded_date` date DEFAULT NULL,
  `premium_unleaded_date` date DEFAULT NULL,
  `ID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `station_id` mediumint(9) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fuel_prices_FK` (`station_id`),
  CONSTRAINT `fuel_prices_FK` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1320 DEFAULT CHARSET=utf8mb4;

-- create stations table
CREATE TABLE `stations` (
  `station_id` mediumint(9) NOT NULL,
  `street` varchar(100) NOT NULL,
  `postcode` varchar(12) NOT NULL,
  `lat` float NOT NULL,
  `lng` float NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- insert into stations table: example
INSERT INTO db_fuelopt.stations
(station_id, street, postcode, lat, lng, name)
VALUES(1, 'GODSTONE ROAD', 'CR3 0EG', 51.3135, -0.0819079, 'BP WHYTELEAFE (GODSTONE ROAD SF CONNECT)');

-- instert into fuel_prices table: example
INSERT INTO db_fuelopt.fuel_prices
(unleaded, diesel, super_unleaded, premium_diesel, unleaded_date, diesel_date, super_unleaded_date, premium_unleaded_date, station_id)
VALUES(151.9, 153.9, 164.9, 169.9, '2021-10-13', '2021-10-13', '2021-10-13', '2021-10-13', 1);

