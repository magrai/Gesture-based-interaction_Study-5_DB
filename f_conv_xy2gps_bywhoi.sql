DROP FUNCTION IF EXISTS f_conv_xy2gps_bywhoi(numeric,numeric,numeric,numeric,numeric,numeric,numeric);
CREATE OR REPLACE FUNCTION f_conv_xy2gps_bywhoi(
	pos_x numeric, 
	pos_y numeric,
	gps_lon_origin numeric,
	gps_lat_origin numeric,
	angle numeric default 0,
	xoffset_m numeric default 0,
	yoffset_m numeric default 0,
	OUT gps_lon numeric,
	OUT gps_lat numeric) 
AS $$

DECLARE
	result numeric;
	xx numeric;
	yy numeric;
	ct numeric;
	st numeric;
	r numeric;

BEGIN
  
	angle = f_conv_deg2rad(angle);
  
	xx = pos_x + xoffset_m;
	yy = pos_y + yoffset_m;
	
	 r = sqrt(xx*xx + yy*yy);

  --if r THEN
      ct = xx/r;
      st = yy/r;
      xx = r * ( (ct * cos(angle)) + (st * sin(angle)) );
      yy = r * ( (st * cos(angle)) - (ct * sin(angle)) );
	
  gps_lon = gps_lon_origin + xx / f_meters_deg_lon(gps_lat_origin);
  gps_lat = gps_lat_origin + yy / f_meters_deg_lat(gps_lat_origin);
  

	--END IF;

	
	
  --RETURN result;
END
$$ LANGUAGE plpgsql; 