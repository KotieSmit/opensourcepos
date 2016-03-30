ALTER TABLE `ospos`.`ospos_sales_payments`
ADD COLUMN `cashup_id` INT(10) NOT NULL AFTER `payment_amount`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`sale_id`, `payment_type`, `cashup_id`);


ALTER TABLE `ospos`.`ospos_sales` 
ADD COLUMN `cashup_id` VARCHAR(45) NULL AFTER `sale_id`;




-- --

-- Table structure for table `ospos_cashups`
--



CREATE TABLE IF NOT EXISTS `ospos_cashups` (
  `cashup_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(45) NOT NULL,
  `started` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  PRIMARY KEY (`cashup_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

-- --------------------------------------------------------

--
-- Table structure for table `ospos_cashups_declared`
--

CREATE TABLE IF NOT EXISTS `ospos_cashups_declared` (
  `ospos_cashups_payments_id` int(11) NOT NULL AUTO_INCREMENT,
  `cashup_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `declared_value` decimal(15,2) NOT NULL DEFAULT '0.00',
  `reported_total` decimal(15,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`ospos_cashups_payments_id`,`cashup_id`,`payment_method_id`,`employee_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=120 ;



--
-- Table structure for table `ospos_payment_methods`
--

CREATE TABLE IF NOT EXISTS `ospos_payment_methods` (
  `payment_method_id` int(3) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `active` int(1) NOT NULL DEFAULT '0',
  `language_id` varchar(255) NOT NULL,
  `allow_over_tender` int(1) NOT NULL DEFAULT '0',
  `is_change` int(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `Name` (`payment_method_id`,`Name`),
  KEY `payment_method_id` (`payment_method_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `ospos_payment_reason`
--

CREATE TABLE IF NOT EXISTS `ospos_payment_reason` (
  `payment_reson_id` int(11) NOT NULL,
  `reason` varchar(45) NOT NULL,
  PRIMARY KEY (`payment_reson_id`),
  UNIQUE KEY `payment_reson_id_UNIQUE` (`payment_reson_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Add columns for bill of materials
--

ALTER TABLE `ospos_items`
ADD COLUMN `stock_keeping_item` INT(1) NOT NULL DEFAULT 1 AFTER `custom10`,
ADD COLUMN `production_item` INT(1) NOT NULL DEFAULT 0 AFTER `stock_keeping_item`,
ADD COLUMN `cost_from_bom` INT(1) NOT NULL DEFAULT 1 AFTER `production_item`;


--
-- Table structure for table `ospos_item_bom`
--

CREATE TABLE IF NOT EXISTS `ospos_item_bom` (
  `item_bom_id` int(10) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `bom_item_id` int(11) NOT NULL,
  `quantity` double(15,3) NOT NULL,
  PRIMARY KEY (`item_bom_id`,`item_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=300 ;



--
-- Create view to ease up looking up and updating BOM cost
--

CREATE
VIEW `view_item_bom_cost` AS
  select `ib`.`item_id` AS `item_id`,
         sum((`bi`.`cost_price` * `ib`.`quantity`)) AS `bom_line_cost`,
         `i`.`cost_price` AS `item_cost_price`,
         `i`.`cost_from_bom` AS `cost_from_bom`
  from (
      (`ospos_item_bom` `ib`
        left join `ospos_items` `i` on((`ib`.`item_id` = `i`.`item_id`)))
      left join `ospos_items` `bi` on((`ib`.`bom_item_id` = `bi`.`item_id`)))
  group by `ib`.`item_id`;


ALTER TABLE `ospos_items`
ADD COLUMN `retail_item` VARCHAR(45) NOT NULL DEFAULT '1' AFTER `cost_from_bom`;


ALTER TABLE `ospos_inventory`
CHANGE COLUMN `trans_inventory` `trans_inventory` DECIMAL(8,3) NOT NULL DEFAULT '0' ;

ALTER TABLE `ospos_item_quantities`
CHANGE COLUMN `quantity` `quantity` DECIMAL(8,3) NOT NULL DEFAULT '0' ;


