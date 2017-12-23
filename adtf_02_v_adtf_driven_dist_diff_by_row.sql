--------------------------------------------------------------------------------
DROP VIEW IF EXISTS v_adtf_driven_dist_diff_by_row CASCADE;
CREATE VIEW v_adtf_driven_dist_diff_by_row AS
--------------------------------------------------------------------------------
SELECT
row_nr,
file_name,
subject_id,
scenario_id,
time_s,

CASE
	WHEN 
		speed_kmh / 3.6 * (time_s - lag(time_s) 
			OVER (PARTITION BY subject_id ORDER BY row_nr)) IS NULL 
	THEN 
		speed_kmh / 3.6 * time_s 
	ELSE 
		speed_kmh / 3.6 * (time_s - lag(time_s) 
			OVER (PARTITION BY subject_id ORDER BY row_nr))
	END AS dist_m_diff,

speed_kmh,
acc_lon_ms2,
acc_lat_ms2,
brake_pressure_status,
brake_pressure_bar,
yaw_rate_sign,
yaw_rate_degs,
acc_pedal_pos_perc,
steer_angle_deg_sign,
steer_angle_deg,
steer_angle_speed_degs_sign,
steer_angle_speed_degs,
gps_lon,
gps_lat,
-- pos_x,
-- pos_y,
gps_alt,
itrace_speed_x,
itrace_speed_y,
itrace_speed_z,
itrace_acc_x,
itrace_acc_y,
itrace_acc_z,
itrace_roll,
itrace_pitch,
itrace_yaw,
itrace_angular_velocity_x,
itrace_angular_velocity_y,
itrace_angular_velocity_z

FROM
t_adtf_formatted

ORDER BY
row_nr