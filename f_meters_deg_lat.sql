CREATE OR REPLACE FUNCTION f_meters_deg_lat(deg numeric) 
RETURNS numeric AS $$

DECLARE
	deg_in_rad numeric;
  result numeric;

BEGIN
	deg_in_rad = f_conv_deg2rad(deg);
	result = 
		(111132.09 - (566.05 * cos(2.0 * deg_in_rad)) + 
	  (1.20 * cos(4.0 * deg_in_rad)) - 
		(0.002 * cos(6.0 * deg_in_rad)));
  RETURN result;
END
$$ LANGUAGE plpgsql; 