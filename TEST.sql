	SELECT
		t_adtf_driven_dist_cum.row_nr,
		t_adtf_driven_dist_cum.subject_id,
		t_adtf_driven_dist_cum.scenario_id,
		t_adtf_driven_dist_cum.time_s,
		t_adtf_driven_dist_cum.dist_m,
		t_adtf_formatted.gps_lon,
		t_adtf_formatted.gps_lat,

		ST_DistanceSphere(
			st_point(t_adtf_formatted.gps_lon, t_adtf_formatted.gps_lat), 
			st_point(gps_ref_temp.gps_lon, gps_ref_temp.gps_lat)) 
		AS s02_e01_gps_dist_m

		FROM
		t_adtf_driven_dist_cum
		LEFT JOIN t_adtf_formatted ON 
		t_adtf_driven_dist_cum.row_nr = t_adtf_formatted.row_nr,
		(
			SELECT 
			scenario_id,
			event_id,
			gps_lat, 
			gps_lon 
			
			FROM 
			v_vtd_coordinates_gps_events_start 
			
			WHERE 
			scenario_id = 2 AND
			event_id = 1
		) gps_ref_temp
		
		WHERE
		t_adtf_driven_dist_cum.scenario_id = 2
		AND t_adtf_driven_dist_cum.subject_id = 515
		
		ORDER BY
		t_adtf_driven_dist_cum.row_nr
