-- Trigger to prevent the deletion of a country if it is associated with a team or circuit
------------------------------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER prevent_country_deletion
BEFORE DELETE ON country
FOR EACH ROW
BEGIN
    DECLARE team_count INT;
    DECLARE circuit_count INT;
    SET team_count = (SELECT COUNT(*) FROM team WHERE id_country = OLD.id_country);
    SET circuit_count = (SELECT COUNT(*) FROM circuit WHERE id_country = OLD.id_country);
    IF team_count > 0 OR circuit_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete the country because it is associated with a team or circuit.';
    END IF;
END //
DELIMITER ;

-- Trigger to automatically update the total number of circuits when a new circuit is inserted
-----------------------------------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER update_grand_prix_count
AFTER INSERT ON grand_prix
FOR EACH ROW
BEGIN
    UPDATE season
    SET total_grand_prix = total_grand_prix + 1
    WHERE id_season = (SELECT id_season FROM grand_prix WHERE id_grand_prix = NEW.id_grand_prix);
END //
DELIMITER ;

-- Trigger to automatically update(substract) the total number of circuits when a new circuit is inserted
DELIMITER //
CREATE TRIGGER update_total_grand_prix_count_sub
AFTER DELETE ON grand_prix
FOR EACH ROW
BEGIN
    UPDATE season
    SET total_grand_prix = total_grand_prix - 1
    WHERE id_season = OLD.id_season;
END //
DELIMITER ;


-- Trigger to update driver standings table after each insertion in race results, if the driver does not exist in driver_standings table
-- it also inserts it into it too

DELIMITER //

CREATE TRIGGER update_driver_standings
AFTER INSERT ON race_result
FOR EACH ROW
BEGIN
    DECLARE points INT;

    -- Retrieve the points based on the race result position
    CASE NEW.race_result_position
        WHEN 1 THEN SET points = 25;
        WHEN 2 THEN SET points = 18;
        WHEN 3 THEN SET points = 15;
        WHEN 4 THEN SET points = 12;
        WHEN 5 THEN SET points = 10;
        WHEN 6 THEN SET points = 8;
        WHEN 7 THEN SET points = 6;
        WHEN 8 THEN SET points = 4;
        WHEN 9 THEN SET points = 2;
        WHEN 10 THEN SET points = 1;
        ELSE SET points = 0;
    END CASE;

    UPDATE driver_standings
    SET driver_total_point = driver_total_point + points
    WHERE id_driver = NEW.id_race_result_driver_id AND id_season = NEW.id_race_result_season_id;

    IF ROW_COUNT() = 0 THEN
        INSERT INTO driver_standings (id_driver, id_season, driver_total_point)
        VALUES (NEW.id_race_result_driver_id, NEW.id_race_result_season_id, points);
    END IF;
END //

DELIMITER ;

-- Trigger that substracts point when deleting from race result
DELIMITER //

CREATE TRIGGER delete_driver_standings
AFTER DELETE ON race_result
FOR EACH ROW
BEGIN
    DECLARE points INT;

    -- Retrieve the points based on the deleted race result position
    CASE OLD.race_result_position
        WHEN 1 THEN SET points = 25;
        WHEN 2 THEN SET points = 18;
        WHEN 3 THEN SET points = 15;
        WHEN 4 THEN SET points = 12;
        WHEN 5 THEN SET points = 10;
        WHEN 6 THEN SET points = 8;
        WHEN 7 THEN SET points = 6;
        WHEN 8 THEN SET points = 4;
        WHEN 9 THEN SET points = 2;
        WHEN 10 THEN SET points = 1;
        ELSE SET points = 0;
    END CASE;

    UPDATE driver_standings
    SET driver_total_point = driver_total_point - points
    WHERE id_driver = OLD.id_race_result_driver_id AND id_season = OLD.id_race_result_season_id;
END //

DELIMITER ;

-- Trigger to substract old points and add new points into driver standings table after an update
DELIMITER //

CREATE TRIGGER update_driver_standings_after_update
AFTER UPDATE ON race_result
FOR EACH ROW
BEGIN
    DECLARE oldPoints INT;
    DECLARE newPoints INT;

    -- Retrieve the old points based on the previous race result position
    CASE OLD.race_result_position
        WHEN 1 THEN SET oldPoints = 25;
        WHEN 2 THEN SET oldPoints = 18;
        WHEN 3 THEN SET oldPoints = 15;
        WHEN 4 THEN SET oldPoints = 12;
        WHEN 5 THEN SET oldPoints = 10;
        WHEN 6 THEN SET oldPoints = 8;
        WHEN 7 THEN SET oldPoints = 6;
        WHEN 8 THEN SET oldPoints = 4;
        WHEN 9 THEN SET oldPoints = 2;
        WHEN 10 THEN SET oldPoints = 1;
        ELSE SET oldPoints = 0;
    END CASE;

    -- Retrieve the new points based on the updated race result position
    CASE NEW.race_result_position
        WHEN 1 THEN SET newPoints = 25;
        WHEN 2 THEN SET newPoints = 18;
        WHEN 3 THEN SET newPoints = 15;
        WHEN 4 THEN SET newPoints = 12;
        WHEN 5 THEN SET newPoints = 10;
        WHEN 6 THEN SET newPoints = 8;
        WHEN 7 THEN SET newPoints = 6;
        WHEN 8 THEN SET newPoints = 4;
        WHEN 9 THEN SET newPoints = 2;
        WHEN 10 THEN SET newPoints = 1;
        ELSE SET newPoints = 0;
    END CASE;

    UPDATE driver_standings
    SET driver_total_point = driver_total_point - oldPoints + newPoints
    WHERE id_driver = OLD.id_race_result_driver_id AND id_season = OLD.id_race_result_season_id;
END //

DELIMITER ;

-- Trigger to check is grand_prix date is Sunday
DELIMITER //

CREATE TRIGGER check_grand_prix_date
BEFORE INSERT ON grand_prix
FOR EACH ROW
BEGIN
    IF DAYNAME(NEW.grand_prix_date) <> 'Sunday' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only Grand Prix events on Sundays are allowed.';
    END IF;
END //

DELIMITER ;

-- Trigger to check is grand_prix date is Sunday(on update)
DELIMITER //

CREATE TRIGGER check_grand_prix_date_update
BEFORE UPDATE ON grand_prix
FOR EACH ROW
BEGIN
    IF DAYNAME(NEW.grand_prix_date) <> 'Sunday' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only Grand Prix events on Sundays are allowed.';
    END IF;
END //

DELIMITER ;

-- Trigger to check when insertion into circuit, is city exists in country
DELIMITER //

CREATE TRIGGER check_city_country
BEFORE INSERT ON circuit
FOR EACH ROW
BEGIN
    DECLARE country_id INT;
    DECLARE city_country_id INT;

    -- Get the country ID of the circuit
    SELECT id_country INTO country_id FROM city WHERE id_city = NEW.id_city;

    -- Get the country ID of the city
    SELECT id_country INTO city_country_id FROM country WHERE id_country = NEW.id_country;

    -- Check if the city's country is different from the circuit's country
    IF country_id <> city_country_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'City is not related to the country.';
    END IF;
END //

DELIMITER ;

-- Trigger to check when update on circuit, is city exists in country
DELIMITER //

CREATE TRIGGER check_city_country_update
BEFORE UPDATE ON circuit
FOR EACH ROW
BEGIN
    DECLARE country_id INT;
    DECLARE city_country_id INT;

    -- Get the country ID of the circuit
    SELECT id_country INTO country_id FROM city WHERE id_city = NEW.id_city;

    -- Get the country ID of the city
    SELECT id_country INTO city_country_id FROM country WHERE id_country = NEW.id_country;

    -- Check if the city's country is different from the circuit's country
    IF country_id <> city_country_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'City is not related to the country.';
    END IF;
END //

DELIMITER ;






