DROP FUNCTION IF EXISTS f_conv_gps2xy_bywhoi(numeric,numeric,numeric,numeric,numeric,numeric,numeric);
CREATE OR REPLACE FUNCTION f_conv_gps2xy_byWHOI(
	gps_lon numeric, 
	gps_lat numeric,
	gps_lon_origin numeric,
	gps_lat_origin numeric,
	angle numeric default 0,
	xoffset_m numeric default 0,
	yoffset_m numeric default 0,
	OUT pos_x numeric,
	OUT pos_y numeric) 
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
  
  xx = (gps_lon - gps_lon_origin) * f_meters_deg_lon(gps_lat_origin);
  yy = (gps_lat - gps_lat_origin) * f_meters_deg_lat(gps_lat_origin);
  
  r = sqrt(xx*xx + yy*yy);

  --if r THEN
      ct = xx/r;
      st = yy/r;
      xx = r * ( (ct * cos(angle)) + (st * sin(angle)) );
      yy = r * ( (st * cos(angle)) - (ct * sin(angle)) );
	--END IF;
  pos_x := xx + xoffset_m;
  pos_y := yy + yoffset_m;
	
	
  --RETURN result;
END
$$ LANGUAGE plpgsql; 