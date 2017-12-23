DROP VIEW IF EXISTS v_vtd_coordinates_xy_events_start CASCADE;
CREATE VIEW v_vtd_coordinates_xy_events_start AS

SELECT 
scenario_id,
event_id,
pos_x_conflict,
pos_y_conflict

FROM
t_coordinates_xy_events

WHERE
event_reason = 'situation start'