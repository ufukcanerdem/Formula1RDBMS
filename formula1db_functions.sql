-- Function that calculates total number of wins of a driver
DELIMITER //

CREATE FUNCTION count_first_place_results(driver_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE count INT;
    
    SELECT COUNT(*) INTO count
    FROM race_result
    WHERE id_race_result_driver_id = driver_id
    AND race_result_position = 1;
    
    RETURN count;
END //

DELIMITER ;

SELECT count_first_place_results(1);