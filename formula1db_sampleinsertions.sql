INSERT INTO season VALUE(1, 2023,0);

INSERT INTO personal VALUE(1,"Lewis", "Hamilton", "1985-01-07", "British", 55000000);
INSERT INTO personal VALUE(2,"Toto", "Wolff", "1972-01-12", "German", 68000);

INSERT INTO driver VALUE(1,44);

INSERT INTO country VALUE(1,"United Kingdom");

INSERT INTO team VALUE(1,1,"Mercedes");

INSERT INTO city VALUE(1,1,"Towcester");

INSERT INTO circuit VALUE(1,1,1,"Silverstone",18, 5.794);

INSERT INTO grand_prix VALUE(1,1,1,"British GP", 11, "2023-07-09");

INSERT INTO country VALUE(2,"Germany");

INSERT INTO engine_manufacturer VALUE(1,2,"Mercedes");

INSERT INTO team_employee VALUE(2,1,"Team Principal");

INSERT INTO personal VALUE(3,"Peter", "Bonnington", "1975-02-12", "British", 50000);

INSERT INTO team_employee VALUE(3,1,"Race Engineer");

INSERT INTO car VALUE(1, 1, 1, "W14");	-- 1:2023 seasonid, 1: mercedes team id, 1: mercedes manufactere id, "w14" chassis name

INSERT INTO team VALUE(2,1,"Redbull"); 
INSERT INTO country VALUE(3,"Japan");
INSERT INTO season VALUE(2,2022, 0);

INSERT INTO engine_manufacturer VALUE(2,3,"Honda");

INSERT INTO car VALUE(1, 2, 2, "RB19");
INSERT INTO car VALUE(2, 2, 2, "RB18");

INSERT INTO personal VALUE(4,"Max", "Verstappen", "1997-10-30", "Dutch", 45000000);
INSERT INTO driver VALUE(4,1);

INSERT INTO race_result VALUE(1, 1, 1, 1); 
INSERT INTO race_result VALUE(4, 1, 1, 2);


INSERT INTO grand_prix VALUE(2,1,1,"test gp", 17, "2023-06-18");

INSERT INTO quali_result VALUE(1,1,1,2);
INSERT INTO quali_result VALUE(4, 1, 1, 1);

INSERT INTO quali_result VALUE(1,1,2,2);
INSERT INTO quali_result VALUE(4, 1, 2, 2);

INSERT INTO personal VALUE(5,"George", "Russell", "1998-02-15", "British", 10000000);
INSERT INTO driver VALUE(5,63);

INSERT INTO race_result VALUE(5, 1, 1, 3); 

INSERT INTO circuit VALUE(3,1,1,"Silverstone2",18, 5.794);

INSERT INTO grand_prix VALUE(3,1,1,"British GP2", 11, "2023-07-09");

INSERT INTO race_result VALUE(5, 1, 2, 4); 
INSERT INTO race_result VALUE(1, 1, 3, 1); 


DELETE FROM race_result where id_race_result_driver_id = 5 AND id_race_result_season_id = 1 AND id_grand_prix = 1;

UPDATE race_result SET id_race_result_driver_id = 5, id_race_result_season_id = 1, id_grand_prix = 2, race_result_position = 5
	WHERE id_race_result_driver_id = 5 AND id_race_result_season_id = 1 AND id_grand_prix = 2;


INSERT INTO grand_prix VALUE(4,1,1,"test gp3", 17, "2023-06-25");

INSERT INTO city VALUE(2,3,"Mie");

INSERT INTO circuit VALUE(5,3,2,"Suzuka",18, 5.794);






