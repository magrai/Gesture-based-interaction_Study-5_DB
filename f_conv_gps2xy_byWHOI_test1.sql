SELECT (result).pos_x, (result).pos_y
FROM (
	SELECT f_conv_gps2xy_byWHOI(11.62683, 48.07223, 11.63825455, 48.07737816, 0) AS result
) AS x

UNION ALL

SELECT round((result).gps_lon, 5), round((result).gps_lat, 5)
FROM (
	SELECT f_conv_xy2gps_byWHOI(-851.312280833, -572.432176301089, 11.63825455, 48.07737816, 0) AS result
) AS y


