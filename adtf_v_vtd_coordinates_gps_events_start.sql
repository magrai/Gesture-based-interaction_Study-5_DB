DROP VIEW IF EXISTS v_vtd_coordinates_gps_events_start CASCADE;
CREATE VIEW v_vtd_coordinates_gps_events_start AS

SELECT 
scenario_id,
event_id,
--position_x_action,
--position_y_action,
position_x_conflict,
position_y_conflict,
(result).*

FROM 
(
	SELECT
	*,
		-- Convert XY coordinates to GPS
	f_conv_xy2gps_byWHOI(
		position_x_conflict::NUMERIC, position_y_conflict::NUMERIC, 
		-- position_x_action::NUMERIC, position_y_action::NUMERIC, 
		t_coordinates_gps_reference.gps_lon, t_coordinates_gps_reference.gps_lat, 
		t_coordinates_gps_reference.angle,
		t_coordinates_gps_reference.x_offset,
		t_coordinates_gps_reference.y_offset) 
		AS result

	FROM
	t_coordinates_xy_events,
	t_coordinates_gps_reference
	
	WHERE 
	t_coordinates_xy_events.event_reason = 'situation start'
) xy2gps
