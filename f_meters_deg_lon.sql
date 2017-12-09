CREATE OR REPLACE FUNCTION f_meters_deg_lon(deg numeric) 
RETURNS numeric AS $$

DECLARE
	deg_in_rad numeric;
  result numeric;

BEGIN
	deg_in_rad = f_conv_deg2rad(deg);
	result = 
		(111415.13 * cos(deg_in_rad)) - 
		(94.55 * cos(3.0 * deg_in_rad)) + 
		(0.12 * cos(5.0 * deg_in_rad));
  RETURN result;
END
$$ LANGUAGE plpgsql; 