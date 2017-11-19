DROP TABLE IF EXISTS t_adtf_raw_first_and_last_row CASCADE;
CREATE TABLE t_adtf_raw_first_and_last_row AS

SELECT
t_adtf_raw.file_name,
t_adtf_file_assignment.subject_id,
t_adtf_file_assignment.trip_nr,
t_adtf_raw."itrace.gps.Longitude" AS gps_lon_first,
t_adtf_raw."itrace.gps.Latitude" AS gps_lat_first,
t_adtf_raw."can.angez_Geschw" AS speed_kmh_first,
temp_last.row_nr_last,
temp_last.gps_lon_last,
temp_last.gps_lat_last,
temp_last.speed_kmh_last


FROM 
t_adtf_raw
LEFT JOIN t_adtf_file_assignment ON 
	t_adtf_raw.file_name = t_adtf_file_assignment.file_name
LEFT JOIN (
	SELECT
	t_adtf_raw.file_name,
	t_adtf_link_file_name_and_last_row_nr.row_nr_last,
	t_adtf_raw."itrace.gps.Longitude" AS gps_lon_last,
	t_adtf_raw."itrace.gps.Latitude" AS gps_lat_last,
	t_adtf_raw."can.angez_Geschw" AS speed_kmh_last

	FROM
	t_adtf_raw
	LEFT JOIN t_adtf_link_file_name_and_last_row_nr ON 
		t_adtf_raw.file_name = t_adtf_link_file_name_and_last_row_nr.file_name AND 
		t_adtf_raw.row_nr = t_adtf_link_file_name_and_last_row_nr.row_nr_last
		
	ORDER BY
	t_adtf_raw.file_name
	) temp_last ON
	t_adtf_raw.file_name = temp_last.file_name

WHERE
t_adtf_raw.row_nr = 1

ORDER BY
t_adtf_raw.file_name
