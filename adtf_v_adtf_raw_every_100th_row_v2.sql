DROP TABLE IF EXISTS t_adtf_raw_every_100th_row_v2 CASCADE;
CREATE TABLE t_adtf_raw_every_100th_row_v2 AS

SELECT 
*

FROM
(
	SELECT 
	t_100th_row.file_name,
	t_100th_row.row_nr,
	t_100th_row.time_s,
	t_100th_row.gps_lon,
	t_100th_row.gps_lat,
	t_100th_row.speed_kmh,
	(f_conv_gps2xy_byWHOI(t_100th_row.gps_lon::numeric, t_100th_row.gps_lat::numeric, t_gps_reference_coordinates.gps_lon, t_gps_reference_coordinates.gps_lat, -1.85)).pos_x,
	(f_conv_gps2xy_byWHOI(t_100th_row.gps_lon::numeric, t_100th_row.gps_lat::numeric, t_gps_reference_coordinates.gps_lon, t_gps_reference_coordinates.gps_lat, -1.85)).pos_y

	FROM (
		SELECT
		t_adtf_raw.file_name,
		MIN(t_adtf_raw.row_nr) AS row_nr,
		ROUND(t_adtf_raw."Time"::NUMERIC, 1) AS time_s,
		MIN(t_adtf_raw."itrace.gps.Longitude") AS gps_lon,
		MIN(t_adtf_raw."itrace.gps.Latitude") AS gps_lat,
		MIN(t_adtf_raw."can.angez_Geschw") AS speed_kmh

		FROM
		t_adtf_raw

		WHERE row_nr % 100 = 0

		GROUP BY
		t_adtf_raw.file_name,
		ROUND(t_adtf_raw."Time"::NUMERIC, 1)
	) t_100th_row,
	t_gps_reference_coordinates
) temp