-- Objective: Create readable column names
-- Estimated time: 40 s
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_adtf_formatted CASCADE;
CREATE TABLE t_adtf_formatted AS
--------------------------------------------------------------------------------
SELECT 
-- Row numbers for complete table
ROW_NUMBER() 
	OVER (ORDER BY t_adtf_raw.file_name, t_adtf_raw."Time"::NUMERIC) 
	AS row_nr,

t_adtf_raw.file_name,
v_adtf_useable_events.subject_id,
v_adtf_useable_events.scenario_id,
t_adtf_raw."Time" AS time_s,
t_adtf_raw."can.angez_Geschw" AS speed_kmh,
t_adtf_raw."can.Laengsbeschleunigung" AS acc_lon_ms2,
t_adtf_raw."can.Querbeschleunigung" AS acc_lat_ms2,
-- t_adtf_raw."can.Gemessene_Querbeschleunigung",
t_adtf_raw."can.Status_Bremsdruck" AS brake_pressure_status,
t_adtf_raw."can.Bremsdruck" AS brake_pressure_bar,
t_adtf_raw."can.Signum_Giergeschwindigkeit" AS yaw_rate_sign,
t_adtf_raw."can.Giergeschwindigkeit" AS yaw_rate_degs,
t_adtf_raw."can.Fahrpedal_Rohsignal" AS acc_pedal_pos_perc,
t_adtf_raw."can.Lenkradwinkel_Sign" AS steer_angle_deg_sign,
t_adtf_raw."can.Lenkradwinkel" AS steer_angle_deg,
t_adtf_raw."can.Lenkradwinkelgeschw_Sign" AS steer_angle_speed_degs_sign,
t_adtf_raw."can.Lenkradwinkelgeschwindigkeit" AS steer_angle_speed_degs,
t_adtf_raw."itrace.gps.Longitude" AS gps_lon,
t_adtf_raw."itrace.gps.Latitude" AS gps_lat,
-- (result).*,
t_adtf_raw."itrace.gps.Altitude" AS gps_alt,
t_adtf_raw."itrace.speed.v_x" AS itrace_speed_x,
t_adtf_raw."itrace.speed.v_y" AS itrace_speed_y,
t_adtf_raw."itrace.speed.v_z" AS itrace_speed_z,
t_adtf_raw."itrace.acc.acc_x_komp" AS itrace_acc_x,
t_adtf_raw."itrace.acc.acc_y_komp" AS itrace_acc_y,
t_adtf_raw."itrace.acc.acc_z_komp" AS itrace_acc_z,
t_adtf_raw."itrace.orientation.Roll" AS itrace_roll,
t_adtf_raw."itrace.orientation.Pitch" AS itrace_pitch,
t_adtf_raw."itrace.orientation.Yaw" AS itrace_yaw,
t_adtf_raw."itrace.angular_velocity.dr_x" AS itrace_angular_velocity_x,
t_adtf_raw."itrace.angular_velocity.dr_y" AS itrace_angular_velocity_y,
t_adtf_raw."itrace.angular_velocity.dr_z" AS itrace_angular_velocity_z

FROM 
-- (
	-- SELECT
	-- *,
	-- Convert GPS longitude and latitude to XY
	-- f_conv_gps2xy_byWHOI(
-- 		t_adtf_raw."itrace.gps.Longitude"::numeric, t_adtf_raw."itrace.gps.Latitude"::numeric, 
-- 		t_coordinates_gps_reference.gps_lon, t_coordinates_gps_reference.gps_lat, 
-- 		-1.85) 
-- 		AS result
-- 
	-- FROM
	-- t_adtf_raw,
-- 	t_coordinates_gps_reference
-- ) gps_xy
t_adtf_raw
LEFT JOIN v_adtf_useable_events ON
	t_adtf_raw.file_name = v_adtf_useable_events.file_name