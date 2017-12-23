DROP VIEW IF EXISTS v_adtf_useable_events CASCADE;
CREATE VIEW v_adtf_useable_events AS

SELECT
subject_id::NUMERIC,
file_name,
trip_nr_clean::NUMERIC AS scenario_id,
event_01_usable,
event_02_usable,
event_03_usable

FROM
t_adtf_file_assignment_v3_commented_v2_events

WHERE
discard = FALSE