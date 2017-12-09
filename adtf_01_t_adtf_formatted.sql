DROP TABLE IF EXISTS t_adtf_formatted CASCADE;
CREATE TABLE t_adtf_formatted AS

SELECT 
row_nr,
file_name,
"Time" AS time_s,
"can.angez_Geschw" AS speed_kmh,
"can.Laengsbeschleunigung" AS acc_lon_ms2,
"can.Querbeschleunigung" AS acc_lat_ms2,
-- "can.Gemessene_Querbeschleunigung",
"can.Status_Bremsdruck" AS brake_pressure_status,
"can.Bremsdruck" AS brake_pressure_bar,
"can.Signum_Giergeschwindigkeit" AS yaw_rate_sign,
"can.Giergeschwindigkeit" AS yaw_rate_degs,
"can.Fahrpedal_Rohsignal" AS acc_pedal_pos_perc,
"can.Lenkradwinkel_Sign" AS steer_angle_deg_sign,
"can.Lenkradwinkel" AS steer_angle_deg,
"can.Lenkradwinkelgeschw_Sign" AS steer_angle_speed_degs_sign,
"can.Lenkradwinkelgeschwindigkeit" AS steer_angle_speed_degs,
"itrace.gps.Longitude" AS gps_lon,
"itrace.gps.Latitude" AS gps_lat,
(result).*,
"itrace.gps.Altitude" AS gps_alt,
"itrace.speed.v_x" AS itrace_speed_x,
"itrace.speed.v_y" AS itrace_speed_y,
"itrace.speed.v_z" AS itrace_speed_z,
"itrace.acc.acc_x_komp" AS itrace_acc_x,
"itrace.acc.acc_y_komp" AS itrace_acc_y,
"itrace.acc.acc_z_komp" AS itrace_acc_z,
"itrace.orientation.Roll" AS itrace_roll,
"itrace.orientation.Pitch" AS itrace_pitch,
"itrace.orientation.Yaw" AS itrace_yaw,
"itrace.angular_velocity.dr_x" AS itrace_angular_velocity_x,
"itrace.angular_velocity.dr_y" AS itrace_angular_velocity_y,
"itrace.angular_velocity.dr_z" AS itrace_angular_velocity_z

FROM 
(
	SELECT
	*,
	-- Convert GPS longitude and latitude to XY
	f_conv_gps2xy_byWHOI(
		"itrace.gps.Longitude"::numeric, "itrace.gps.Latitude"::numeric, 
		t_gps_reference_coordinates.gps_lon, t_gps_reference_coordinates.gps_lat, 
		-1.85) 
		AS result

	FROM
	t_adtf_raw,
	t_gps_reference_coordinates
) gps_xy