-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema verkkokauppa
-- -----------------------------------------------------
-- Harjoitustyö Tietokanta peruskurssille Jyväskylän Ammattiopisto, Kevät 2023
DROP SCHEMA IF EXISTS `verkkokauppa` ;

-- -----------------------------------------------------
-- Schema verkkokauppa
--
-- Harjoitustyö Tietokanta peruskurssille Jyväskylän Ammattiopisto, Kevät 2023
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `verkkokauppa` ;
USE `verkkokauppa` ;

-- -----------------------------------------------------
-- Table `verkkokauppa`.`clubmember`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `verkkokauppa`.`clubmember` (
  `clubmember_id` INT NOT NULL AUTO_INCREMENT,
  `clubmember_lvl` VARCHAR(45) NOT NULL,
  `discount` DOUBLE NOT NULL,
  PRIMARY KEY (`clubmember_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `verkkokauppa`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `verkkokauppa`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(64) NOT NULL,
  `lastname` VARCHAR(64) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `cm_id` INT NULL,
  PRIMARY KEY (`customer_id`),
  INDEX `fk_customer_clubmember_idx` (`cm_id` ASC),
  CONSTRAINT `fk_customer_clubmember`
    FOREIGN KEY (`cm_id`)
    REFERENCES `verkkokauppa`.`clubmember` (`clubmember_id`)
    ON DELETE NO ACTION
    ON UPDATE SET NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `verkkokauppa`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `verkkokauppa`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `c_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `verkkokauppa`.`manufacture`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `verkkokauppa`.`manufacture` (
  `manufacture_id` INT NOT NULL AUTO_INCREMENT,
  `m_name` VARCHAR(64) NOT NULL,
  `m_country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`manufacture_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `verkkokauppa`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `verkkokauppa`.`product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `p_name` VARCHAR(64) NOT NULL,
  `p_price` DOUBLE NULL,
  `c_id` INT NOT NULL,
  `m_id` INT NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_product_category1_idx` (`c_id` ASC),
  INDEX `fk_product_manufacture1_idx` (`m_id` ASC),
  CONSTRAINT `fk_product_category1`
    FOREIGN KEY (`c_id`)
    REFERENCES `verkkokauppa`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_manufacture1`
    FOREIGN KEY (`m_id`)
    REFERENCES `verkkokauppa`.`manufacture` (`manufacture_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `verkkokauppa`.`delivery_options`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `verkkokauppa`.`delivery_options` (
  `do_id` INT NOT NULL AUTO_INCREMENT,
  `delivery_option_name` VARCHAR(45) NOT NULL,
  `delivery_price` INT NOT NULL,
  PRIMARY KEY (`do_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `verkkokauppa`.`cm_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `verkkokauppa`.`cm_orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `delivery_options_do_id` INT NOT NULL,
  `order_time` DATETIME NOT NULL,
  `total` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_order_delivery_options1_idx` (`delivery_options_do_id` ASC),
  CONSTRAINT `fk_order_delivery_options1`
    FOREIGN KEY (`delivery_options_do_id`)
    REFERENCES `verkkokauppa`.`delivery_options` (`do_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `verkkokauppa`.`shoppingcart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `verkkokauppa`.`shoppingcart` (
  `row_id` INT NOT NULL AUTO_INCREMENT,
  `c_id` INT NULL,
  `p_id` INT NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`row_id`),
  INDEX `fk_customer_has_product_product1_idx` (`p_id` ASC),
  INDEX `fk_customer_has_product_customer1_idx` (`c_id` ASC),
  INDEX `fk_shoppingcart_delivery1_idx` (`order_id` ASC),
  CONSTRAINT `fk_customer_has_product_customer1`
    FOREIGN KEY (`c_id`)
    REFERENCES `verkkokauppa`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customer_has_product_product1`
    FOREIGN KEY (`p_id`)
    REFERENCES `verkkokauppa`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shoppingcart_delivery1`
    FOREIGN KEY (`order_id`)
    REFERENCES `verkkokauppa`.`cm_orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `verkkokauppa`;

DELIMITER $$
USE `verkkokauppa`$$
CREATE DEFINER = CURRENT_USER TRIGGER `verkkokauppa`.`customer_BEFORE_DELETE` 
BEFORE DELETE ON `customer` FOR EACH ROW
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Action is not allowed, deleting prevented.";$$

USE `verkkokauppa`$$
CREATE DEFINER = CURRENT_USER TRIGGER `verkkokauppa`.`customer_BEFORE_INSERT` 
BEFORE INSERT ON `customer` FOR EACH ROW
BEGIN
	IF NEW.lastname IS NULL OR NEW.firstname IS NULL
    THEN
    DELETE FROM customer WHERE NEW.lastname IS NULL OR NEW.firstname IS NULL;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "The Information is required";
    END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `verkkokauppa`.`clubmember`
-- -----------------------------------------------------
START TRANSACTION;
USE `verkkokauppa`;
INSERT INTO `verkkokauppa`.`clubmember` (`clubmember_id`, `clubmember_lvl`, `discount`) VALUES (1, 'Gold', 0.45);
INSERT INTO `verkkokauppa`.`clubmember` (`clubmember_id`, `clubmember_lvl`, `discount`) VALUES (2, 'Silver', 0.35);
INSERT INTO `verkkokauppa`.`clubmember` (`clubmember_id`, `clubmember_lvl`, `discount`) VALUES (3, 'Copper', 0.25);
INSERT INTO `verkkokauppa`.`clubmember` (`clubmember_id`, `clubmember_lvl`, `discount`) VALUES (4, 'Sprout', 0.10);
INSERT INTO `verkkokauppa`.`clubmember` (`clubmember_id`, `clubmember_lvl`, `discount`) VALUES (5, 'Not member', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `verkkokauppa`.`customer`
-- -----------------------------------------------------
START TRANSACTION;
USE `verkkokauppa`;
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (1, 'Aila', 'Mäkinen', 'Jyväskylä', 5);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (2, 'Helmi', 'Haapamäki', 'Hämeenlinna', 2);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (3, 'Kaija', 'Väisänen', 'Helsinki', 5);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (4, 'Kaarina', 'Jokinen', 'Tampere', 3);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (5, 'Aino', 'Virtanen', 'Helsinki', 1);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (6, 'Soile', 'Auvila', 'Savonlinna', 4);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (7, 'Katri', 'Ojala', 'Tampere', 2);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (8, 'Kirsi', 'Koivisto', 'Hämeenlinna', 1);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (9, 'Tanja', 'Ikonen', 'Jyväskylä', 3);
INSERT INTO `verkkokauppa`.`customer` (`customer_id`, `firstname`, `lastname`, `city`, `cm_id`) VALUES (10, 'Eeva', 'Svard', 'Jyväskylä', 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `verkkokauppa`.`category`
-- -----------------------------------------------------
START TRANSACTION;
USE `verkkokauppa`;
INSERT INTO `verkkokauppa`.`category` (`category_id`, `c_name`) VALUES (1, 'hair');
INSERT INTO `verkkokauppa`.`category` (`category_id`, `c_name`) VALUES (2, 'face');
INSERT INTO `verkkokauppa`.`category` (`category_id`, `c_name`) VALUES (3, 'body');

COMMIT;


-- -----------------------------------------------------
-- Data for table `verkkokauppa`.`manufacture`
-- -----------------------------------------------------
START TRANSACTION;
USE `verkkokauppa`;
INSERT INTO `verkkokauppa`.`manufacture` (`manufacture_id`, `m_name`, `m_country`) VALUES (1, 'Lumene', 'Finland');
INSERT INTO `verkkokauppa`.`manufacture` (`manufacture_id`, `m_name`, `m_country`) VALUES (2, 'XZ', 'Finland');
INSERT INTO `verkkokauppa`.`manufacture` (`manufacture_id`, `m_name`, `m_country`) VALUES (3, 'LancÔme', 'France');
INSERT INTO `verkkokauppa`.`manufacture` (`manufacture_id`, `m_name`, `m_country`) VALUES (4, 'Urtekram', 'Denmark');

COMMIT;


-- -----------------------------------------------------
-- Data for table `verkkokauppa`.`product`
-- -----------------------------------------------------
START TRANSACTION;
USE `verkkokauppa`;
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (1, 'Curly Mascara', 17.90, 2, 1);
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (2, 'Tasapainottava Savinaamio', 23.90, 2, 1);
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (3, 'Luminous Moisture Huulipuna', 13.50, 2, 1);
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (4, 'Aito Omena Shampoo 250ml', 3.90, 1, 2);
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (5, 'Kaura Hiusöljy 100ml ', 5.90, 1, 2);
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (6, 'Teint Miracle Meikkivoide', 52.00, 2, 3);
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (7, '24H Drama Liqui-Pencil Rajauskynä', 24.00, 2, 3);
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (8, 'Luomu Soft Wild Rose Pink Salt Vartalokuorinta 150ml', 11.90, 3, 4);
INSERT INTO `verkkokauppa`.`product` (`product_id`, `p_name`, `p_price`, `c_id`, `m_id`) VALUES (9, ' Luomu Wild Lemongrass Deodorantti 50ml', 5.50, 3, 4);

COMMIT;


-- -----------------------------------------------------
-- Data for table `verkkokauppa`.`delivery_options`
-- -----------------------------------------------------
START TRANSACTION;
USE `verkkokauppa`;
INSERT INTO `verkkokauppa`.`delivery_options` (`do_id`, `delivery_option_name`, `delivery_price`) VALUES (1, 'posti', 4.90);
INSERT INTO `verkkokauppa`.`delivery_options` (`do_id`, `delivery_option_name`, `delivery_price`) VALUES (2, 'matkahuolto', 2.90);
INSERT INTO `verkkokauppa`.`delivery_options` (`do_id`, `delivery_option_name`, `delivery_price`) VALUES (3, 'ups', 5.80);
INSERT INTO `verkkokauppa`.`delivery_options` (`do_id`, `delivery_option_name`, `delivery_price`) VALUES (4, 'nouto', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `verkkokauppa`.`cm_orders`
-- -----------------------------------------------------
START TRANSACTION;
USE `verkkokauppa`;
INSERT INTO `verkkokauppa`.`cm_orders` (`order_id`, `delivery_options_do_id`, `order_time`, `total`) VALUES (10011, 2, '2021-01-02', DEFAULT);
INSERT INTO `verkkokauppa`.`cm_orders` (`order_id`, `delivery_options_do_id`, `order_time`, `total`) VALUES (10012, 3, '2021-02-28', DEFAULT);
INSERT INTO `verkkokauppa`.`cm_orders` (`order_id`, `delivery_options_do_id`, `order_time`, `total`) VALUES (10013, 1, '2021-04-06', DEFAULT);
INSERT INTO `verkkokauppa`.`cm_orders` (`order_id`, `delivery_options_do_id`, `order_time`, `total`) VALUES (10014, 1, '2022-05-11', DEFAULT);
INSERT INTO `verkkokauppa`.`cm_orders` (`order_id`, `delivery_options_do_id`, `order_time`, `total`) VALUES (10015, 4, '2022-07-08', DEFAULT);
INSERT INTO `verkkokauppa`.`cm_orders` (`order_id`, `delivery_options_do_id`, `order_time`, `total`) VALUES (10016, 2, '2022-06-21', DEFAULT);
INSERT INTO `verkkokauppa`.`cm_orders` (`order_id`, `delivery_options_do_id`, `order_time`, `total`) VALUES (10017, 3, '2022-09-26', DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table `verkkokauppa`.`shoppingcart`
-- -----------------------------------------------------
START TRANSACTION;
USE `verkkokauppa`;
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (1, 2, 3, 10012);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (2, 2, 4, 10012);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (3, 2, 1, 10012);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (4, 4, 8, 10013);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (5, 4, 7, 10013);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (6, 4, 7, 10013);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (7, 4, 5, 10013);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (8, 1, 8, 10011);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (9, 1, 4, 10011);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (10, 1, 3, 10011);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (11, 6, 2, 10015);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (12, 6, 9, 10015);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (13, 6, 8, 10015);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (14, 6, 3, 10015);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (15, 6, 3, 10015);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (16, 8, 1, 10014);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (17, 8, 2, 10014);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (18, 8, 3, 10014);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (19, 8, 4, 10014);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (20, 8, 5, 10014);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (21, 8, 6, 10014);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (22, 8, 7, 10014);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (23, 8, 8, 10014);
INSERT INTO `verkkokauppa`.`shoppingcart` (`row_id`, `c_id`, `p_id`, `order_id`) VALUES (24, 8, 9, 10014);

COMMIT;

