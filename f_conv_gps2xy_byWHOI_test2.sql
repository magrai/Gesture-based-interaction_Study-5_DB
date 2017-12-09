SELECT 
file_name, 
(result).*

FROM (
	SELECT 
	file_name,
	f_conv_gps2xy_byWHOI(gps_lon_first::numeric, gps_lat_first::numeric, 11.63825455, 48.07737816, -1.9) AS result
	FROM 
	t_adtf_raw_first_and_last_row
) AS x