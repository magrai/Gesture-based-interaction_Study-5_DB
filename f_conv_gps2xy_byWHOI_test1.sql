SELECT (result).x, (result).y
FROM (
	SELECT f_conv_gps2xy_byWHOI(11.62683, 48.07223, 11.63825455, 48.07737816, -1.9) AS result
) AS x


