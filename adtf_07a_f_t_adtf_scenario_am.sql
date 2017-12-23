CREATE OR REPLACE FUNCTION f_t_adtf_scenario_am (scenario_id INT DEFAULT NULL, event_id INT DEFAULT NULL) 
RETURNS VOID
LANGUAGE plpgsql AS $$
--------------------------------------------------------------------------------
DECLARE scenario_id_txt TEXT = LPAD(scenario_id::text, 2, '0');
DECLARE event_id_txt TEXT = LPAD(event_id::text, 2, '0');
DECLARE index_txt TEXT = CONCAT('s', scenario_id_txt, '_', 'e', event_id_txt);
DECLARE dist_val_before NUMERIC = -150;
DECLARE dist_val_after NUMERIC = 150;
--------------------------------------------------------------------------------
BEGIN
RAISE INFO '==================================================';
RAISE INFO 'Processing f_t_adtf_scenario_am';
RAISE INFO 'Scenario %', scenario_id;
RAISE INFO 'Event %', event_id;
RAISE INFO '==================================================';
--------------------------------------------------------------------------------
EXECUTE '
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_adtf_' ||  index_txt || '_am CASCADE;
CREATE TABLE t_adtf_' ||  index_txt || '_am AS
--------------------------------------------------------------------------------
SELECT
t_adtf_' || index_txt || '_gps_dist.row_nr,
t_adtf_' || index_txt || '_gps_dist.subject_id,
t_adtf_' || index_txt || '_gps_dist.scenario_id,
--------------------------------------------------------------------------------
t_adtf_' || index_txt || '_gps_dist.time_s,
t_adtf_' || index_txt || '_gps_dist.dist_m,
--------------------------------------------------------------------------------
t_adtf_' || index_txt || '_gps_dist.time_s - t_adtf_' || index_txt || '_gps_dist_min.time_s AS ' || index_txt || '_tti_s,
t_adtf_' || index_txt || '_gps_dist.dist_m - t_adtf_' || index_txt || '_gps_dist_min.dist_m AS ' || index_txt || '_dti_m
--------------------------------------------------------------------------------
FROM
t_adtf_' || index_txt || '_gps_dist
LEFT JOIN
t_adtf_' || index_txt || '_gps_dist_min ON
	t_adtf_' || index_txt || '_gps_dist.subject_id = t_adtf_' || index_txt || '_gps_dist_min.subject_id AND
	t_adtf_' || index_txt || '_gps_dist.scenario_id = t_adtf_' || index_txt || '_gps_dist_min.scenario_id
--------------------------------------------------------------------------------
ORDER BY
t_adtf_' ||  index_txt || '_gps_dist.row_nr
--------------------------------------------------------------------------------
';
--------------------------------------------------------------------------------
END $$;



