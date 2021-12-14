-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema myschool
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `myschool` ;

-- -----------------------------------------------------
-- Schema myschool
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `myschool` DEFAULT CHARACTER SET utf8 ;
USE `myschool` ;

-- -----------------------------------------------------
-- Table `myschool`.`countries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myschool`.`countries` ;

CREATE TABLE IF NOT EXISTS `myschool`.`countries` (
  `country_id` INT NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(45) NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE INDEX `country_id_UNIQUE` (`country_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myschool`.`states`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myschool`.`states` ;

CREATE TABLE IF NOT EXISTS `myschool`.`states` (
  `state_id` INT NOT NULL AUTO_INCREMENT,
  `state_name` VARCHAR(45) NULL,
  `zip_code` VARCHAR(45) NULL,
  `country_id` INT NOT NULL,
  PRIMARY KEY (`state_id`),
  INDEX `fk_City_Country1_idx` (`country_id` ASC) VISIBLE,
  UNIQUE INDEX `state_id_UNIQUE` (`state_id` ASC) VISIBLE,
  CONSTRAINT `fk_City_Country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `myschool`.`countries` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myschool`.`addresses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myschool`.`addresses` ;

CREATE TABLE IF NOT EXISTS `myschool`.`addresses` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `street_name` VARCHAR(45) NULL,
  `building_no` VARCHAR(45) NULL,
  `state_id` INT NOT NULL,
  `address_num` VARCHAR(45) NULL,
  PRIMARY KEY (`address_id`),
  INDEX `fk_addresses_states1_idx` (`state_id` ASC) VISIBLE,
  UNIQUE INDEX `address_id_UNIQUE` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_addresses_states1`
    FOREIGN KEY (`state_id`)
    REFERENCES `myschool`.`states` (`state_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myschool`.`parents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myschool`.`parents` ;

CREATE TABLE IF NOT EXISTS `myschool`.`parents` (
  `parent_id` INT NOT NULL AUTO_INCREMENT,
  `parent_name` VARCHAR(45) NULL,
  `amt_paid` DECIMAL(5,2) NULL,
  `email` VARCHAR(45) NULL,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`parent_id`),
  INDEX `fk_Parent_Address1_idx` (`address_id` ASC) VISIBLE,
  UNIQUE INDEX `parent_id_UNIQUE` (`parent_id` ASC) VISIBLE,
  CONSTRAINT `fk_Parent_Address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `myschool`.`addresses` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myschool`.`students`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myschool`.`students` ;

CREATE TABLE IF NOT EXISTS `myschool`.`students` (
  `student_id` INT NOT NULL AUTO_INCREMENT,
  `f_name` VARCHAR(45) NULL,
  `l_name` VARCHAR(45) NULL,
  `dob` VARCHAR(45) NULL,
  `registration_fee` DECIMAL(5,2) NULL,
  `parent_id` INT NOT NULL,
  PRIMARY KEY (`student_id`),
  INDEX `fk_Students_Parent1_idx` (`parent_id` ASC) VISIBLE,
  UNIQUE INDEX `student_id_UNIQUE` (`student_id` ASC) VISIBLE,
  CONSTRAINT `fk_Students_Parent1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `myschool`.`parents` (`parent_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myschool`.`schools`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myschool`.`schools` ;

CREATE TABLE IF NOT EXISTS `myschool`.`schools` (
  `school_id` INT NOT NULL AUTO_INCREMENT,
  `school_name` VARCHAR(45) NULL,
  `school_no` INT NULL,
  `address_id` INT NOT NULL,
  `base_fee` DECIMAL(5,2) NULL,
  PRIMARY KEY (`school_id`),
  INDEX `fk_Location_Address1_idx` (`address_id` ASC) VISIBLE,
  UNIQUE INDEX `location_id_UNIQUE` (`school_id` ASC) VISIBLE,
  CONSTRAINT `fk_Location_Address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `myschool`.`addresses` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myschool`.`grade_levels`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myschool`.`grade_levels` ;

CREATE TABLE IF NOT EXISTS `myschool`.`grade_levels` (
  `grade_level_id` INT NOT NULL AUTO_INCREMENT,
  `grade` VARCHAR(45) NULL,
  `monthly_fee` DECIMAL(5,2) NULL,
  `school_id` INT NOT NULL,
  PRIMARY KEY (`grade_level_id`),
  INDEX `fk_Grade_level_Location1_idx` (`school_id` ASC) VISIBLE,
  UNIQUE INDEX `grade_level_id_UNIQUE` (`grade_level_id` ASC) VISIBLE,
  CONSTRAINT `fk_Grade_level_Location1`
    FOREIGN KEY (`school_id`)
    REFERENCES `myschool`.`schools` (`school_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myschool`.`students_grade_levels`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myschool`.`students_grade_levels` ;

CREATE TABLE IF NOT EXISTS `myschool`.`students_grade_levels` (
  `grade_level_id` INT NOT NULL,
  `students_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  PRIMARY KEY (`grade_level_id`, `students_id`),
  INDEX `fk_Grade_level_has_Students_Students1_idx` (`students_id` ASC) VISIBLE,
  INDEX `fk_Grade_level_has_Students_Grade_level_idx` (`grade_level_id` ASC) VISIBLE,
  CONSTRAINT `fk_Grade_level_has_Students_Grade_level`
    FOREIGN KEY (`grade_level_id`)
    REFERENCES `myschool`.`grade_levels` (`grade_level_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Grade_level_has_Students_Students1`
    FOREIGN KEY (`students_id`)
    REFERENCES `myschool`.`students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;




USE myschool; 

INSERT INTO countries (country_id, country_name) 
Values (DEFAULT, 'INDIA');
SET @india = last_insert_id();

INSERT INTO states (state_id, state_name, zip_code, country_id)
VALUES (DEFAULT, 'NEW DELHI', '110047', @india);
SET @new_delhi = last_insert_id(); 

INSERT INTO states (state_id, state_name, zip_code, country_id)
VALUES (DEFAULT, 'Guragon', '122001', @india);
SET @gurgaon = last_insert_id(); 

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Arjun Nagar' , '594 & 595',  @gurgaon, '1');
SET @GUR595 = last_insert_id();

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Ashok Vihar' , '17',  @gurgaon, '2');
SET @GUR17 = last_insert_id(); 

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Aya Nagar' , 'C-185',  @new_delhi, '3');
SET @DEL185 = last_insert_id(); 

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Aya Nagar Street 5' , '188',  @new_delhi, 'A');
SET @Street5 = last_insert_id();

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Aya Nagar Street 8' , '295',  @new_delhi, 'A');
SET @Street8 = last_insert_id();


INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Aya Nagar Street A12' , '207',  @new_delhi, 'B');
SET @StreetA12 = last_insert_id();

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Arjun Nagar Street C2' , '111',  @GURGAON, 'B');
SET @StreetC2 = last_insert_id();

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Arjun Nagar Street D3' , '134',  @GURGAON, 'D');
SET @StreetD3 = last_insert_id();

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Arjun Nagar Street C2' , '45',  @GURGAON, 'B');
SET @StreetC2 = last_insert_id();

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Ashok Vihar Street 110B' , '37',  @GURGAON, 'E');
SET @Street110B = last_insert_id();

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Ashok Vihar Street 115D' , '23',  @GURGAON, 'E');
SET @Street115D = last_insert_id();

INSERT INTO addresses ( address_id, street_name, building_no, state_id, address_num)
VALUES ( DEFAULT, 'Ashok Vihar Street 223D' , '11',  @GURGAON, 'G');
SET @Street223D = last_insert_id();

-- add parent addresses here = in number to parents added

INSERT INTO schools ( school_id, school_name, school_no, address_id, base_fee)
VALUES (DEFAULT, 'Arjun Nagar', '1', @GUR595, 8); 
SET @ARJUN1 = last_insert_id();

INSERT INTO schools ( school_id, school_name, school_no, address_id, base_fee)
VALUES (DEFAULT, 'Arjun Nagar', '2', @GUR17, 8); 
SET @ASHOK2 = last_insert_id();

INSERT INTO schools ( school_id, school_name, school_no, address_id, base_fee)
VALUES (DEFAULT, 'Aya Nagar', '3', @DEL185, 12 ); 
SET @AYA3 = last_insert_id(); 



-- insert at least 3 parents
INSERT INTO parents ( parent_id, parent_name, amt_paid, email, address_id) 
VALUES (DEFAULT, 'Jacob Thapa', 8, 'DEC@gmail.com', @Street5);  -- Aya Nagar
SET @J_THAPA = last_insert_id();

INSERT INTO parents ( parent_id, parent_name, amt_paid, email, address_id) 
VALUES (DEFAULT, 'Travis Dun', 12, 'XYZ@gmail.com', @Street8); -- Aya Nagar 
SET @T_DUN = last_insert_id();

INSERT INTO parents ( parent_id, parent_name, amt_paid, email, address_id) 
VALUES (DEFAULT, 'Stephen Manual', 5, '123@gmail.com',  @StreetD3);  -- Arjun Nagar 
SET @S_Manual = last_insert_id();

INSERT INTO parents ( parent_id, parent_name, amt_paid, email, address_id) 
VALUES (DEFAULT, 'Rohan Singh', 5, '456@gmail.com', @Street223D); -- (Ashok Vihar) This is a parent address ID
SET @R_Singh = last_insert_id();

-- insert at least 5 students
INSERT INTO students ( student_id, f_name, l_name, dob, registration_fee, parent_id) 
VALUES (DEFAULT, 'Ravi' , 'Singh', '2017-04-13', 3, @R_Singh);
SET @SINGH_17_04_13 = last_insert_id(); 

INSERT INTO students ( student_id, f_name, l_name, dob, registration_fee, parent_id) 
VALUES (DEFAULT, 'Selvi' , 'Manual', '2016-06-9', 3, @S_Manual);
SET @Manual_16_06_09 = last_insert_id();   

INSERT INTO students ( student_id, f_name, l_name, dob, registration_fee, parent_id) 
VALUES (DEFAULT, 'Moses' , 'Manual', '2017-08-11', 3, @S_Manual);
SET @Manual_17_08_11 = last_insert_id();   

INSERT INTO students ( student_id, f_name, l_name, dob, registration_fee, parent_id) 
VALUES (DEFAULT, 'Andrew' , 'Dun', '2018-03-06', 3, @T_DUN);
SET @DUN_18_03_06 = last_insert_id();  

INSERT INTO students ( student_id, f_name, l_name, dob, registration_fee, parent_id) 
VALUES (DEFAULT, 'Tiwnkle' , 'Dun', '2019-04-12', 3, @T_DUN);
SET @DUN_19_04_12 = last_insert_id();   


-- insert K-3 for all three schools

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'Kindergarten', 0, @GUR595); 
SET @GUR595_K = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'First Grade', 2, @GUR595); 
SET @GUR595_1 = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'Second Grade', 4, @GUR595); 
SET @GUR595_2 = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'Third Grade', 5, @GUR595); 
SET @GUR595_3 = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'KinderGarten', 0, @GUR17); 
SET @GUR17_K = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'First Grade', 2.5, @GUR17); 
SET @GUR17_1 = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'Second Grade', 4, @GUR17); 
SET @GUR17_2 = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'Third Grade', 6, @GUR17); 
SET @GUR17_3 = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'Kindergarten',0, @DEL185); 
SET @DEL185_K = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'First Grade',4, @DEL185); 
SET @DEL185_1 = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'Second Grade',6, @DEL185); 
SET @DEL185_2 = last_insert_id();

INSERT INTO grade_levels ( grade_level_id, grade, monthly_fee, school_id) 
VALUES (DEFAULT, 'Third Grade',7, @DEL185); 
SET @DEL185_3 = last_insert_id();


-- have a few students do 3 grades, or change schools, or something

INSERT INTO students_grade_levels (grade_level_id, students_id, start_date, end_date) VALUES
(@GUR17_K, @SINGH_17_04_13, '2020-09-01', '2021-05-30'),
(@GUR17_1, @SINGH_17_04_13, '2021-09-01', NULL),
(@DEL185_2,@DUN_18_03_06,  '2020-04-01', NULL),
(@DEL185_3,@DUN_19_04_12, '2020-04-01', NULL),
(@GUR595_K,@Manual_17_08_11, '2019-04-01', '2021-03-15');  








