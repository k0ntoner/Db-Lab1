SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `cinema` DEFAULT CHARACTER SET utf8 ;
USE `cinema` ;

CREATE TABLE IF NOT EXISTS `cinema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `email` VARCHAR(65) NOT NULL,
  `hash_pasword` varchar(225) not null,
  `role_id` int not null ,
  `card_id` int not null ,
  `cart_id` int not null ,
  `is_deleted` bool default(false),
  `updated_at` timestamp,
  
  PRIMARY KEY (`id`),
  foreign key(`role_id`) references `cinema`.`roles`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  foreign key(`card_id`) references `cinema`.`cards`(`id`) on delete cascade on update cascade,   
  foreign key(`cart_id`) references `cinema`.`carts`(`id`) on delete cascade on update cascade)
ENGINE = InnoDB;

Create table if not exists `cinema`.`roles`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` varchar(225) not null,
  
  PRIMARY KEY (`id`)
  )
ENGINE = InnoDB;

Create table if not exists `cinema`.`cards`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `number` int NOT NULL,
  `expres_end` date  not null,
  `cardholder_name` varchar(25) not null,
  `hash_cvv` varchar(225) not null,
  
  PRIMARY KEY (`id`)
  )
ENGINE = InnoDB;

Create table if not exists `cinema`.`carts`(
  `id` INT NOT NULL AUTO_INCREMENT,
  
  PRIMARY KEY (`id`)
  )
ENGINE = InnoDB;

Create table if not exists `cinema`.`goods_carts`(
  `goods_id` INT NOT NULL,
  `cart_id` int not null,
  
  PRIMARY KEY (`goods_id`, `cart_id`),
  foreign key(`goods_id`) references  `cinema`.`goods`(`id`) on delete cascade on update cascade,
  foreign key(`cart_id`) references  `cinema`.`carts`(`id`) on delete cascade on update cascade)
ENGINE = InnoDB;

Create table if not exists `cinema`.`goods`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` varchar(45) not null,
  `price` decimal not null,
  `is_deleted` bool not null,
  
  PRIMARY KEY (`id`)
  )
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `cinema`.`films`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`genres`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`genres_films`(
  `genre_id` INT NOT NULL,
  `films_id` INT NOT NULL,
  
  PRIMARY KEY (`genre_id`, `films_id`),
  FOREIGN KEY (`genre_id`) REFERENCES `cinema`.`genres`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`films_id`) REFERENCES `cinema`.`films`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`schedules`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `film_id` INT NOT NULL,
  `date` DATE NOT NULL,
  
  PRIMARY KEY (`id`),
  FOREIGN KEY (`film_id`) REFERENCES `cinema`.`films`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`promotions`(
  `id` INT NOT NULL AUTO_INCREMENT,
  
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`promotions_users`(
  `user_id` INT NOT NULL,
  `promotion_id` INT NOT NULL,
  
  PRIMARY KEY (`user_id`, `promotion_id`),
  FOREIGN KEY (`user_id`) REFERENCES `cinema`.`users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`promotion_id`) REFERENCES `cinema`.`promotions`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`halls`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `is_deleted` BOOL DEFAULT FALSE,
  
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`seats`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `hall_id` INT NOT NULL,
  `row` INT NOT NULL,
  `seat_number` INT NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  
  PRIMARY KEY (`id`),
  FOREIGN KEY (`hall_id`) REFERENCES `cinema`.`halls`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`screenings`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `hall_id` INT NOT NULL,
  `schedule_id` INT NOT NULL,
  
  PRIMARY KEY (`id`),
  FOREIGN KEY (`hall_id`) REFERENCES `cinema`.`halls`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`schedule_id`) REFERENCES `cinema`.`schedules`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`tickets`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `seat_id` INT NOT NULL,
  `screening_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  
  PRIMARY KEY (`id`),
  FOREIGN KEY (`seat_id`) REFERENCES `cinema`.`seats`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`screening_id`) REFERENCES `cinema`.`screenings`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `cinema`.`users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `cinema`.`users_changes`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `updated_by` INT NOT NULL,
  `relation_name` VARCHAR(100) NOT NULL,
  `record_id` INT NOT NULL,
  `old_value` TEXT,
  `new_value` TEXT,
  `updated_at` TIMESTAMP NOT NULL,
  `is_deleted` BOOL DEFAULT FALSE,
  
  PRIMARY KEY (`id`),
  FOREIGN KEY (`updated_by`) REFERENCES `cinema`.`users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;