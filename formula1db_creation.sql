
CREATE SCHEMA IF NOT EXISTS `formula1_db` DEFAULT CHARACTER SET utf8 ;
USE `formula1_db` ;

CREATE TABLE IF NOT EXISTS `formula1_db`.`season` (
  `id_season` INT NOT NULL,
  `year` INT,
  `total_grand_prix` INT DEFAULT 0,
  PRIMARY KEY (`id_season`),
  UNIQUE INDEX `id_sezon_UNIQUE` (`id_season` ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`personal` (
  `id_personal` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `nationality` VARCHAR(45) NOT NULL,
  `salary` INT NOT NULL,
  PRIMARY KEY (`id_personal`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`driver` (
   `id_personal` INT NOT NULL,
  `driver_number` INT NOT NULL,
  -- PRIMARY KEY (`id_driver`), deleted for make driver weak entity of personal data
  INDEX `fk_driver_personal_idx` (`id_personal` ASC) VISIBLE,
  UNIQUE INDEX `id_personal_UNIQUE` (`id_personal` ASC) VISIBLE,
  CONSTRAINT `fk_driver_personal`
    FOREIGN KEY (`id_personal`)
    REFERENCES `formula1_db`.`personal` (`id_personal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `formula1_db`.`country` (
  `id_country` INT NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_country`),
  UNIQUE INDEX `country_name_UNIQUE` (`country_name` ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`team` (
  `id_team` INT NOT NULL AUTO_INCREMENT,
  `id_country` INT NOT NULL,
  `team_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_team`),
  INDEX `fk_team_country1_idx` (`id_country` ASC) VISIBLE,
  CONSTRAINT `fk_team_country1`
    FOREIGN KEY (`id_country`)
    REFERENCES `formula1_db`.`country` (`id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`city` (
  `id_city` INT NOT NULL AUTO_INCREMENT,
  `id_country` INT NOT NULL,
  `city_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_city`),
  INDEX `fk_city_country1_idx` (`id_country` ASC) VISIBLE,
  CONSTRAINT `fk_city_country1`
    FOREIGN KEY (`id_country`)
    REFERENCES `formula1_db`.`country` (`id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`circuit` (
  `id_circuit` INT NOT NULL AUTO_INCREMENT,
  `id_country` INT NOT NULL,
  `id_city` INT NOT NULL,
  `circuit_name` VARCHAR(45) NOT NULL,
  `circuit_corners_amount` INT NOT NULL,
  `circuit_length` FLOAT NOT NULL,
  PRIMARY KEY (`id_circuit`),
  INDEX `fk_circuit_city1_idx` (`id_city` ASC) VISIBLE,
  INDEX `fk_circuit_country1_idx` (`id_country` ASC) VISIBLE,
  CONSTRAINT `fk_circuit_city1`
    FOREIGN KEY (`id_city`)
    REFERENCES `formula1_db`.`city` (`id_city`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_circuit_country1`
    FOREIGN KEY (`id_country`)
    REFERENCES `formula1_db`.`country` (`id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`grand_prix` (
  `id_grand_prix` INT NOT NULL AUTO_INCREMENT,
  `id_season` INT NOT NULL,
  `id_circuit` INT NOT NULL,
  `grand_prix_name` VARCHAR(45) NOT NULL,
  `grand_prix_round` INT NOT NULL,
  `grand_prix_date` DATE NOT NULL,
  PRIMARY KEY (`id_grand_prix`),
  INDEX `fk_grand_prix_season1_idx` (`id_season` ASC) VISIBLE,
  INDEX `fk_grand_prix_circuit1_idx` (`id_circuit` ASC) VISIBLE,
  CONSTRAINT `fk_grand_prix_season1`
    FOREIGN KEY (`id_season`)
    REFERENCES `formula1_db`.`season` (`id_season`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_grand_prix_circuit1`
    FOREIGN KEY (`id_circuit`)
    REFERENCES `formula1_db`.`circuit` (`id_circuit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`engine_manufacturer` (
  `id_engine_manufacturer` INT NOT NULL AUTO_INCREMENT,
  `id_country` INT NOT NULL,
  `engine_manufacturer_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_engine_manufacturer`),
  INDEX `fk_engine_manufacturer_country1_idx` (`id_country` ASC) VISIBLE,
  UNIQUE INDEX `engine_manufacturer_name_UNIQUE` (`engine_manufacturer_name` ASC) VISIBLE,
  CONSTRAINT `fk_engine_manufacturer_country1`
    FOREIGN KEY (`id_country`)
    REFERENCES `formula1_db`.`country` (`id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`team_employee` (
  `id_personal_team_employee` INT NOT NULL,
  `id_team_team_employee` INT NOT NULL,
  `job_title` VARCHAR(45) NOT NULL,
  -- delete for weak entity PRIMARY KEY (`id_team_employee`),
  INDEX `fk_team_employee_team1_idx` (`id_team_team_employee` ASC) VISIBLE,
  INDEX `fk_team_employee_personal_data1_idx` (`id_personal_team_employee` ASC) VISIBLE,
  UNIQUE INDEX `id_personal_data_UNIQUE` (`id_personal_team_employee` ASC) VISIBLE,
  -- UNIQUE INDEX `id_team_employee_UNIQUE` (`id_team_employee` ASC) VISIBLE,
  CONSTRAINT `fk_team_employee_team1`
    FOREIGN KEY (`id_team_team_employee`)
    REFERENCES `formula1_db`.`team` (`id_team`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_employee_personal_data1`
    FOREIGN KEY (`id_personal_team_employee`)
    REFERENCES `formula1_db`.`personal` (`id_personal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `formula1_db`.`car` (
  -- `id_car` INT NOT NULL AUTO_INCREMENT, we dont need beacuse season, team and engine manufacter enough to identify a car.
  `id_season` INT NOT NULL,
  `id_team` INT NOT NULL,
  `id_engine_manufacturer` INT NOT NULL,
  `car_chassis_name` VARCHAR(45) NULL,
  -- PRIMARY KEY (`id_car`),
  INDEX `fk_car_team1_idx` (`id_team` ASC) VISIBLE,
  INDEX `fk_car_engine_manufacturer1_idx` (`id_engine_manufacturer` ASC) VISIBLE,
  INDEX `fk_car_season1_idx` (`id_season` ASC) VISIBLE,
  CONSTRAINT `fk_car_team1`
    FOREIGN KEY (`id_team`)
    REFERENCES `formula1_db`.`team` (`id_team`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_car_engine_manufacturer1`
    FOREIGN KEY (`id_engine_manufacturer`)
    REFERENCES `formula1_db`.`engine_manufacturer` (`id_engine_manufacturer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_car_season1`
    FOREIGN KEY (`id_season`)
    REFERENCES `formula1_db`.`season` (`id_season`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`race_result` (
  `id_race_result_driver_id` INT NOT NULL AUTO_INCREMENT,
  `id_race_result_season_id` INT NOT NULL,
  `id_grand_prix` INT NOT NULL,
  `race_result_position` INT NOT NULL,
  CONSTRAINT uc_attrs UNIQUE (id_race_result_driver_id, id_race_result_season_id, id_grand_prix),
  CONSTRAINT uc_attrs2 UNIQUE (id_race_result_season_id, id_grand_prix, race_result_position),
  INDEX `fk_race_result_idx` (`race_result_position` ASC) VISIBLE,
  CONSTRAINT `fk_race_result1`
    FOREIGN KEY (`id_race_result_driver_id`)
    REFERENCES `formula1_db`.`driver` (`id_personal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_race_result2`
    FOREIGN KEY (`id_race_result_season_id`)
    REFERENCES `formula1_db`.`season` (`id_season`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_race_result3`
    FOREIGN KEY (`id_grand_prix`)
    REFERENCES `formula1_db`.`grand_prix` (`id_grand_prix`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`quali_result` (
  `id_quali_result_driver_id` INT NOT NULL AUTO_INCREMENT,
  `id_quali_result_season_id` INT NOT NULL,
  `id_grand_prix` INT NOT NULL,
  `quali_result_position` INT NOT NULL,
  CONSTRAINT uc_attrs UNIQUE (id_quali_result_driver_id, id_quali_result_season_id, id_grand_prix),
  INDEX `fk_race_result_idx` (`quali_result_position` ASC) VISIBLE,
  CONSTRAINT `fk_quali_result1`
    FOREIGN KEY (`id_quali_result_driver_id`)
    REFERENCES `formula1_db`.`driver` (`id_personal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_quali_result2`
    FOREIGN KEY (`id_quali_result_season_id`)
    REFERENCES `formula1_db`.`season` (`id_season`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_quali_result3`
    FOREIGN KEY (`id_grand_prix`)
    REFERENCES `formula1_db`.`grand_prix` (`id_grand_prix`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `formula1_db`.`driver_standings` (
	`id_driver` INT NOT NULL,
    `id_season` INT NOT NULL,
    `driver_total_point` INT DEFAULT 0,
    INDEX `fk_driver_standings_idx` (`driver_total_point` ASC) VISIBLE,
    CONSTRAINT `fk_driver_standings1`
    FOREIGN KEY (`id_driver`)
    REFERENCES `formula1_db`.`driver` (`id_personal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_driver_standings2`
    FOREIGN KEY (`id_season`)
    REFERENCES `formula1_db`.`season` (`id_season`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
