CREATE VIEW DriverInfo AS
SELECT p.id_personal, p.name, p.surname, p.date_of_birth, p.nationality, p.salary, d.driver_number
FROM personal p
JOIN driver d ON p.id_personal = d.id_personal;

SELECT * FROM DriverInfo;

CREATE VIEW TeamInfo AS
SELECT t.id_team, t.team_name, c.country_name
FROM team t
JOIN country c ON t.id_country = c.id_country;

SELECT * FROM TeamInfo;

CREATE VIEW GrandPrixInfo AS
SELECT gp.id_grand_prix, gp.grand_prix_name, gp.grand_prix_round, gp.grand_prix_date, s.year
FROM grand_prix gp
JOIN season s ON gp.id_season = s.id_season;

SELECT * FROM GrandPrixInfo;

CREATE VIEW CircuitInfo AS
SELECT c.id_circuit, c.circuit_name, ci.city_name, co.country_name, c.circuit_corners_amount, c.circuit_length
FROM circuit c
JOIN city ci ON c.id_city = ci.id_city
JOIN country co ON c.id_country = co.id_country;

SELECT * FROM CircuitInfo;

CREATE VIEW Standings AS
SELECT ds.id_season, d.id_personal, CONCAT(p.name, ' ', p.surname) AS driver_name, ds.driver_total_point
FROM driver_standings ds
JOIN driver d ON ds.id_driver = d.id_personal
JOIN personal p ON d.id_personal = p.id_personal;

SELECT * FROM Standings;

CREATE VIEW CityInfo AS
SELECT c.`id_city`, c.`city_name`, c.`id_country`, co.`country_name`
FROM city AS c
INNER JOIN country AS co ON c.id_country = co.id_country;

SELECT * FROM CityInfo;
