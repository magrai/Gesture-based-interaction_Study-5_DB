-- Find minimum gps distance
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION f_t_adtf_scenario_gps_dist_min (scenario_id INT DEFAULT NULL, event_id INT DEFAULT NULL) 
RETURNS VOID
LANGUAGE plpgsql AS $$
--------------------------------------------------------------------------------
DECLARE scenario_id_txt TEXT = LPAD(scenario_id::text, 2, '0');
DECLARE event_id_txt TEXT = LPAD(event_id::text, 2, '0');
DECLARE index_txt TEXT = CONCAT('s', scenario_id_txt, '_', 'e', event_id_txt);
DECLARE dist_val_min NUMERIC = 0;
DECLARE dist_val_max NUMERIC = 9999;
--------------------------------------------------------------------------------
BEGIN
RAISE INFO '==================================================';
RAISE INFO 'Processing f_t_adtf_scenario_gps_dist_min';
RAISE INFO 'Scenario %', scenario_id;
RAISE INFO 'Event %', event_id;
RAISE INFO '==================================================';
--------------------------------------------------------------------------------
IF scenario_id = 1 THEN 
		IF event_id = 1
			THEN dist_val_max := 1170;
			ELSE dist_val_min := 1170;
		END IF;
	ELSE
	-- Do nothing
END IF;

IF scenario_id = 2 THEN 
		IF event_id <= 2
			THEN dist_val_max := 1480;
			ELSE dist_val_min := 1480;
		END IF;
	ELSE
	-- Do nothing
END IF;

IF scenario_id = 3 THEN 
		IF event_id = 1
			THEN dist_val_max := 588;
			ELSE dist_val_min := 588;
		END IF;
	ELSE
	-- Do nothing
END IF;
--------------------------------------------------------------------------------
EXECUTE '
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_adtf_' || index_txt || '_gps_dist_min CASCADE;
CREATE TABLE t_adtf_' || index_txt || '_gps_dist_min AS
--------------------------------------------------------------------------------
SELECT
t_adtf_' || index_txt || '_gps_dist.subject_id,
t_adtf_' || index_txt || '_gps_dist.scenario_id,
MIN(t_adtf_' || index_txt || '_gps_dist.row_nr) AS row_nr,
MIN(t_adtf_' || index_txt || '_gps_dist.time_s) AS time_s,
MIN(t_adtf_' || index_txt || '_gps_dist.dist_m) AS dist_m,
temp.' || index_txt || '_gps_dist_m_min

FROM
t_adtf_' || index_txt || '_gps_dist,
(
	SELECT 
	subject_id, 
	scenario_id,
	MIN(' || index_txt || '_gps_dist_m) AS ' || index_txt || '_gps_dist_m_min

	FROM 
	t_adtf_' || index_txt || '_gps_dist
	
	WHERE 
	t_adtf_' || index_txt || '_gps_dist.dist_m >= ' || dist_val_min || ' AND
	t_adtf_' || index_txt || '_gps_dist.dist_m <= ' || dist_val_max || '
	
	GROUP BY 
	subject_id,
	scenario_id
) temp

WHERE 
t_adtf_' || index_txt || '_gps_dist.' || index_txt || '_gps_dist_m = temp.' || index_txt || '_gps_dist_m_min AND
t_adtf_' || index_txt || '_gps_dist.subject_id = temp.subject_id AND
t_adtf_' || index_txt || '_gps_dist.scenario_id = temp.scenario_id

GROUP BY
t_adtf_' || index_txt || '_gps_dist.subject_id,
t_adtf_' || index_txt || '_gps_dist.scenario_id,
temp.' || index_txt || '_gps_dist_m_min

ORDER BY
t_adtf_' || index_txt || '_gps_dist.subject_id,
t_adtf_' || index_txt || '_gps_dist.scenario_id
';
--------------------------------------------------------------------------------
END $$;
	
	
	
