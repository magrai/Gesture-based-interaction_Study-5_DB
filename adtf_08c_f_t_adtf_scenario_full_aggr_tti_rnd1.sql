--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION f_t_adtf_scenario_full_aggr_tti_rnd1 (scenario_id INT DEFAULT NULL, event_id INT DEFAULT NULL) 
RETURNS VOID
LANGUAGE plpgsql AS $$
--------------------------------------------------------------------------------
DECLARE scenario_id_txt TEXT = LPAD(scenario_id::text, 2, '0');
DECLARE event_id_txt TEXT = LPAD(event_id::text, 2, '0');
DECLARE index_txt TEXT = CONCAT('s', scenario_id_txt, '_', 'e', event_id_txt);
--------------------------------------------------------------------------------
BEGIN
RAISE INFO '==================================================';
RAISE INFO 'Processing f_t_adtf_scenario_full_aggr_tti_rnd1';
RAISE INFO 'Scenario %', scenario_id;
RAISE INFO 'Event %', event_id;
RAISE INFO '==================================================';
--------------------------------------------------------------------------------
EXECUTE '
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_adtf_' ||  index_txt || '_full_tti_rnd1 CASCADE;
CREATE TABLE t_adtf_' ||  index_txt || '_full_tti_rnd1 AS
--------------------------------------------------------------------------------
SELECT
t_adtf_' || index_txt || '_am_tti_rnd1.row_nr,
t_adtf_' || index_txt || '_am_tti_rnd1.subject_id,
t_adtf_' || index_txt || '_am_tti_rnd1.scenario_id,
--------------------------------------------------------------------------------
t_adtf_formatted.time_s,
t_adtf_driven_dist_cum.dist_m,
--------------------------------------------------------------------------------
t_adtf_' || index_txt || '_am_tti_rnd1.'|| index_txt ||'_tti_s_rnd1,
t_adtf_' || index_txt || '_am_tti_rnd1.'|| index_txt ||'_dti_m,
--------------------------------------------------------------------------------
t_adtf_formatted.gps_lat,
t_adtf_formatted.gps_lon,
--------------------------------------------------------------------------------
t_adtf_formatted.speed_kmh,
t_adtf_formatted.acc_lon_ms2,
t_adtf_formatted.acc_lat_ms2,
t_adtf_formatted.brake_pressure_status,
t_adtf_formatted.brake_pressure_bar,
t_adtf_formatted.yaw_rate_sign,
t_adtf_formatted.yaw_rate_degs,
t_adtf_formatted.acc_pedal_pos_perc,
t_adtf_formatted.steer_angle_deg_sign,
t_adtf_formatted.steer_angle_deg,
t_adtf_formatted.steer_angle_speed_degs_sign,
t_adtf_formatted.steer_angle_speed_degs,
-- t_adtf_formatted.ind
--------------------------------------------------------------------------------
t_adtf_formatted.itrace_speed_x,
t_adtf_formatted.itrace_speed_y,
t_adtf_formatted.itrace_speed_z,
t_adtf_formatted.itrace_acc_x,
t_adtf_formatted.itrace_acc_y,
t_adtf_formatted.itrace_acc_z,
t_adtf_formatted.itrace_roll,
t_adtf_formatted.itrace_pitch,
t_adtf_formatted.itrace_yaw,
t_adtf_formatted.itrace_angular_velocity_x,
t_adtf_formatted.itrace_angular_velocity_y,
t_adtf_formatted.itrace_angular_velocity_z
--------------------------------------------------------------------------------
FROM
t_adtf_' || index_txt || '_am_tti_rnd1
LEFT JOIN t_adtf_formatted ON 
	t_adtf_' || index_txt || '_am_tti_rnd1.row_nr = t_adtf_formatted.row_nr
LEFT JOIN t_adtf_driven_dist_cum ON 
	t_adtf_' || index_txt || '_am_tti_rnd1.row_nr = t_adtf_driven_dist_cum.row_nr
--------------------------------------------------------------------------------
ORDER BY
t_adtf_' || index_txt || '_am_tti_rnd1.row_nr	
--------------------------------------------------------------------------------
';
--------------------------------------------------------------------------------
END $$;