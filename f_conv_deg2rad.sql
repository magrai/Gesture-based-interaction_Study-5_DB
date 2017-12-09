CREATE OR REPLACE FUNCTION f_conv_deg2rad(deg numeric) 
RETURNS numeric AS $$

DECLARE
  result numeric;

BEGIN
  result = deg * pi() / 180;
  RETURN result;
END
$$ LANGUAGE plpgsql; 