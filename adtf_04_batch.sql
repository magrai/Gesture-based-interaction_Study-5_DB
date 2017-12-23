-- Objective: ...
--------------------------------------------------------------------------------
DO
$do$
--------------------------------------------------------------------------------
DECLARE 
s_id INT;
scenario_ids INT[];
-- scenario_ids INT[] := array[2];
e_id INT;
event_ids INT[];
-- event_ids INT[] := array[3];
--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------
SELECT 
 	ARRAY_AGG(DISTINCT v_vtd_coordinates_gps_events_start.scenario_id ORDER BY v_vtd_coordinates_gps_events_start.scenario_id) 
	FROM v_vtd_coordinates_gps_events_start 
	INTO scenario_ids;
--------------------------------------------------------------------------------
-- For manual situation selection use following line
-- SELECT array_agg(1) INTO position_ids;
--------------------------------------------------------------------------------
-- Loop through each position
FOREACH s_id IN ARRAY scenario_ids LOOP

	SELECT 
		ARRAY_AGG(
			DISTINCT v_vtd_coordinates_gps_events_start.event_id 
			ORDER BY v_vtd_coordinates_gps_events_start.event_id
		) 
	FROM v_vtd_coordinates_gps_events_start
	WHERE v_vtd_coordinates_gps_events_start.scenario_id = s_id
	INTO event_ids;

	FOREACH e_id IN ARRAY event_ids LOOP
	
		RAISE INFO 'Processing scenario %', s_id;
		RAISE INFO 'Processing event %', e_id;
		
		-- Compute distance between gps data and reference position
		-- Estimated time: 265 s
		PERFORM f_t_adtf_scenario_gps_dist(s_id, e_id); 
			
		-- Find minimum gps distance
		-- Estimated time: 15 s
		PERFORM f_t_adtf_scenario_gps_dist_min(s_id, e_id); 
		
		-- Compute driven distance or time until reaching the gps reference position
		-- Estimated time: 40 s
		PERFORM f_t_adtf_scenario_am(s_id, e_id); 
		
		-- Aggregate to 10 Hz time (and minimise distance)
		-- Estimated time: 22 s
		PERFORM f_t_adtf_scenario_am_aggr_dti_rnd1(s_id, e_id); 
		
		-- Aggregate to 10 Hz distance (and minimise time)
		-- Estimated time: 20 s
		PERFORM f_t_adtf_scenario_am_aggr_tti_rnd1(s_id, e_id); 
		
		-- Join non-aggregated arrival measures with vehicle data and round names
		-- Estimated time: 161 s
		-- PERFORM f_t_adtf_scenario_full(s_id, e_id); 
		
		-- Join distance-aggregated arrival measures with vehicle data and round names
		-- Estimated time: 130 s
		PERFORM f_t_adtf_scenario_full_aggr_dti_rnd1(s_id, e_id); 
		
		-- Join time-aggregated arrival measures with vehicle data and round names
		-- Estimated time: 55 s
		PERFORM f_t_adtf_scenario_full_aggr_tti_rnd1(s_id, e_id); 

	END LOOP;
END LOOP;
--------------------------------------------------------------------------------
END $do$;