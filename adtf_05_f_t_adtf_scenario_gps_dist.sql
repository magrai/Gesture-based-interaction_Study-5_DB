-- Compute distance between gps data and reference gps points
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION f_t_adtf_scenario_gps_dist (scenario_id INT DEFAULT NULL, event_id INT DEFAULT NULL) 
RETURNS VOID
LANGUAGE plpgsql AS $$
--------------------------------------------------------------------------------
DECLARE scenario_id_txt TEXT = LPAD(scenario_id::text, 2, '0');
DECLARE event_id_txt TEXT = LPAD(event_id::text, 2, '0');
DECLARE index_txt TEXT = CONCAT('s', scenario_id_txt, '_', 'e', event_id_txt);
--------------------------------------------------------------------------------
BEGIN
RAISE INFO '==================================================';
RAISE INFO 'Processing f_t_adtf_pxx_xy_dist';
RAISE INFO 'Scenario %', scenario_id;
RAISE INFO 'Event %', event_id;
RAISE INFO '==================================================';
--------------------------------------------------------------------------------
EXECUTE '
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_adtf_s' || scenario_id_txt || '_e' || event_id_txt || '_gps_dist CASCADE;
CREATE TABLE t_adtf_s' || scenario_id_txt || '_e' || event_id_txt || '_gps_dist AS
--------------------------------------------------------------------------------

		SELECT
		t_adtf_formatted.row_nr,
		t_adtf_formatted.subject_id,
		t_adtf_driven_dist_cum.scenario_id,
		t_adtf_formatted.time_s,
		t_adtf_driven_dist_cum.dist_m,
		t_adtf_formatted.gps_lon,
		t_adtf_formatted.gps_lat,

		ST_DistanceSphere(
			st_point(t_adtf_formatted.gps_lon, t_adtf_formatted.gps_lat), 
			st_point(gps_ref_temp.gps_lon, gps_ref_temp.gps_lat)) 
		AS ' || index_txt || '_gps_dist_m

		FROM
		t_adtf_formatted 
		LEFT JOIN t_adtf_driven_dist_cum 
			ON t_adtf_formatted.row_nr = t_adtf_driven_dist_cum.row_nr,
		(
			SELECT 
			scenario_id,
			event_id,
			gps_lat, 
			gps_lon 
			
			FROM 
			v_vtd_coordinates_gps_events_start 
			
			WHERE 
			scenario_id = ' || scenario_id || ' AND
			event_id = ' || event_id || '
		) gps_ref_temp
		
		WHERE
		t_adtf_driven_dist_cum.scenario_id = ' || scenario_id || '
		
		ORDER BY
		row_nr
		';
END $$;



