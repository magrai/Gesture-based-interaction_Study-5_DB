-- Round values of distance-based arrival measures
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION f_t_adtf_scenario_am_aggr_tti_rnd1 (scenario_id INT DEFAULT NULL, event_id INT DEFAULT NULL) 
RETURNS VOID
LANGUAGE plpgsql AS $$
--------------------------------------------------------------------------------
DECLARE scenario_id_txt TEXT = LPAD(scenario_id::text, 2, '0');
DECLARE event_id_txt TEXT = LPAD(event_id::text, 2, '0');
DECLARE index_txt TEXT = CONCAT('s', scenario_id_txt, '_', 'e', event_id_txt);
DECLARE dist_val_before NUMERIC = -200;
DECLARE dist_val_after NUMERIC = 50;
--------------------------------------------------------------------------------
BEGIN
RAISE INFO '==================================================';
RAISE INFO 'Processing f_t_adtf_scenario_am_tti_rnd1';
RAISE INFO 'Scenario %', scenario_id;
RAISE INFO 'Event %', event_id;
RAISE INFO '==================================================';
--------------------------------------------------------------------------------
-- Adapt data section for following events
IF 
	(scenario_id = 0) OR
	(scenario_id = 1 AND event_id = 2) OR 
	(scenario_id = 2 AND event_id = 3) OR 
	(scenario_id = 3 AND event_id = 1) OR 
	(scenario_id = 4 AND event_id = 1)
		THEN dist_val_after := 500;
		ELSE 
		-- Do nothing
END IF;
--------------------------------------------------------------------------------
EXECUTE '
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_adtf_' || index_txt || '_am_tti_rnd1 CASCADE;
CREATE TABLE t_adtf_' || index_txt || '_am_tti_rnd1 AS
--------------------------------------------------------------------------------
SELECT 
MIN(row_nr) as row_nr,
subject_id,
scenario_id,
ROUND(' || index_txt || '_tti_s::NUMERIC, 1) AS ' || index_txt || '_tti_s_rnd1,
MIN(' || index_txt || '_dti_m) AS ' || index_txt || '_dti_m
--------------------------------------------------------------------------------
FROM
t_adtf_' || index_txt || '_am
--------------------------------------------------------------------------------
WHERE 
' || index_txt || '_dti_m >= ' || dist_val_before || ' AND 
' || index_txt || '_dti_m <= ' || dist_val_after || '
--------------------------------------------------------------------------------
GROUP BY
subject_id,
scenario_id,
round(' || index_txt || '_tti_s::NUMERIC, 1)
--------------------------------------------------------------------------------
ORDER BY
MIN(row_nr)
--------------------------------------------------------------------------------
';
--------------------------------------------------------------------------------
END $$;