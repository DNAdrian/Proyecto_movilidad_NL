-- MySQL Workbench Synchronization
-- Generated: 2025-02-02 22:06
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER SCHEMA `transport_project`  DEFAULT COLLATE utf8mb4_general_ci ;

ALTER TABLE `transport_project`.`Poblacion_NL` 
COLLATE = utf8mb4_general_ci ,
CHANGE COLUMN `Year` `Year` CHAR(4) NOT NULL ,
CHANGE COLUMN `Poblacion_total` `Poblacion_total` FLOAT(11) NOT NULL ,
CHANGE COLUMN `code` `code` VARCHAR(12) NOT NULL,
ADD PRIMARY KEY (`idx_year_code`);
;

ALTER TABLE `transport_project`.`municipios` 
COLLATE = utf8mb4_general_ci ,
CHANGE COLUMN `Municipio` `Municipio` VARCHAR(35) NOT NULL ,
CHANGE COLUMN `code` `code` VARCHAR(12) NOT NULL ,
ADD PRIMARY KEY (`code`),
DROP PRIMARY KEY;
;

ALTER TABLE `transport_project`.`ingreso_trim_hogar_nl` 
COLLATE = utf8mb4_general_ci ,
CHANGE COLUMN `year` `year` CHAR(4) NOT NULL ,
CHANGE COLUMN `ingreso` `ingreso` FLOAT(11) NOT NULL ,
ADD PRIMARY KEY (`year`);
;

ALTER TABLE `transport_project`.`gasto_trim_transp_nl` 
COLLATE = utf8mb4_general_ci ,
CHANGE COLUMN `gasto` `gasto` FLOAT(11) NOT NULL FIRST,
CHANGE COLUMN `year` `year` CHAR(4) NOT NULL ,
ADD PRIMARY KEY (`year`),
DROP PRIMARY KEY;
;

ALTER TABLE `transport_project`.`transporte_nl_inegi` 
COLLATE = utf8mb4_general_ci ,
CHANGE COLUMN `Unidades en operacion de L-V` `Unidades en operacion de L-V` FLOAT(11) NOT NULL ,
CHANGE COLUMN `Unidades en operacion de S-D` `Unidades en operacion de S-D` FLOAT(11) NOT NULL ,
CHANGE COLUMN `Miles de km recorridos` `Miles de km recorridos` FLOAT(11) NOT NULL ,
CHANGE COLUMN `Pasajeros transportados-total` `Pasajeros transportados-total` FLOAT(11) NOT NULL ,
CHANGE COLUMN `month` `month` CHAR(10) NOT NULL ,
CHANGE COLUMN `year` `year` CHAR(4) NOT NULL ,
CHANGE COLUMN `ecovia` `ecovia` VARCHAR(1) BINARY NOT NULL ,
CHANGE COLUMN `metro` `metro` VARCHAR(1) BINARY NOT NULL ,
CHANGE COLUMN `metrobus` `metrobus` VARCHAR(1) BINARY NOT NULL ,
CHANGE COLUMN `transmetro` `transmetro` VARCHAR(1) BINARY NOT NULL ,
CHANGE COLUMN `Pasajeros transportados-tarifa completa` `Pasajeros transportados-tarifa completa` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pasajeros transportados-con descuento` `Pasajeros transportados-con descuento` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pasajeros transportados-con cortesia` `Pasajeros transportados-con cortesia` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Numero de rutas` `Numero de rutas` INT(3) NULL DEFAULT NULL ,
CHANGE COLUMN `Personal ocupado` `Personal ocupado` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Ingresos miles de pesos de pasajes` `Ingresos miles de pesos de pasajes` FLOAT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Miles de KWH consumido` `Miles de KWH consumido` FLOAT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `id` `id` INT(11) NOT NULL ;

CREATE TABLE IF NOT EXISTS `transport_project`.`metropoli_mty` (
  `year` CHAR(4) NOT NULL,
  `poblacion_total` FLOAT(11) NOT NULL,
  `pasajeros_total` FLOAT(11) NULL DEFAULT NULL,
  `mkm_recorridos` FLOAT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`year`),
  CONSTRAINT `year`
    FOREIGN KEY (`year`)
    REFERENCES `transport_project`.`ingreso_trim_hogar_nl` (`year`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    COLLATE = utf8mb4_general_ci
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


CREATE TABLE IF NOT EXISTS `transport_project`.`metro` (
  `id` INT(11) NOT NULL,
  `Miles de KWH consumido` FLOAT(11) NOT NULL,
  `Ingresos miles de pesos de pasajes` FLOAT(11) NOT NULL,
  `Unidades en operacion de L-V` FLOAT(11) NOT NULL,
  `Miles de km recorridos` FLOAT(11) NOT NULL,
  `Unidades en operacion de S-D` FLOAT(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `conjunto_metro`
    FOREIGN KEY (`id`)
    REFERENCES `transport_project`.`conjunto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `transport_project`.`ecovia` (
  `id` INT(11) NOT NULL ,
  `Pasajeros transportados-tarifa completa` INT(11) NOT NULL,
  `Pasajeros transportados-con descuento` INT(11) NOT NULL,
  `Unidades en operacion de L-V` FLOAT(11) NOT NULL,
  `Miles de km recorridos` FLOAT(11) NOT NULL,
  `Unidades en operacion de S-D` FLOAT(11) NOT NULL,
  `Pasajeros transportados-con cortesia` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `conjunto_eco`
    FOREIGN KEY (`id`)
    REFERENCES `transport_project`.`conjunto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `transport_project`.`metrobus` (
  `id` INT(11) NOT NULL ,
  `Numero de rutas` INT(11) NOT NULL,
  `Personal ocupado` INT(11) NOT NULL,
  `Unidades en operacion de L-V` FLOAT(11) NOT NULL,
  `Miles de km recorridos` FLOAT(11) NOT NULL,
  `Unidades en operacion de S-D` FLOAT(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `conjunto_metrobus`
    FOREIGN KEY (`id`)
    REFERENCES `transport_project`.`conjunto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `transport_project`.`transmetro` (
  `id` INT(11) NOT NULL ,
  `Numero de rutas` INT(11) NOT NULL,
  `Personal ocupado` INT(11) NOT NULL,
  `Unidades en operacion de L-V` FLOAT(11) NOT NULL,
  `Miles de km recorridos` FLOAT(11) NOT NULL,
  `Unidades en operacion de S-D` FLOAT(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `conjunto_trans`
    FOREIGN KEY (`id`)
    REFERENCES `transport_project`.`conjunto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `transport_project`.`conjunto` (
  `month` CHAR(10) NOT NULL,
  `year` CHAR(4) NOT NULL,
  `ecovia` VARCHAR(1) BINARY NOT NULL,
  `metro` VARCHAR(1) BINARY NOT NULL,
  `metrobus` VARCHAR(1) BINARY NOT NULL,
  `transmetro` VARCHAR(1) BINARY NOT NULL,
  `id` INT(11) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

ALTER TABLE `transport_project`.`Poblacion_NL`
ADD CONSTRAINT `code_muni`
FOREIGN KEY (`code`)
REFERENCES `transport_project`.`municipios` (`code`)
ON DELETE NO ACTION
ON UPDATE NO ACTION,
ADD CONSTRAINT `year_metro`
FOREIGN KEY (`Year`)
REFERENCES `transport_project`.`metropoli_mty` (`year`)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE `transport_project`.`gasto_trim_transp_nl` 
ADD CONSTRAINT `year_lk`
  FOREIGN KEY (`year`)
  REFERENCES `transport_project`.`ingreso_trim_hogar_nl` (`year`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
