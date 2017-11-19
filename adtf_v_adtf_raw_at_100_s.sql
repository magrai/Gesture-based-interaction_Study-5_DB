DROP VIEW IF EXISTS v_adtf_raw_at_100_s CASCADE;
CREATE VIEW v_adtf_raw_at_100_s AS

SELECT
t_adtf_file_assignment.subject_id,
t_adtf_raw."itrace.gps.Longitude",
t_adtf_raw."itrace.gps.Latitude",
t_adtf_file_assignment.trip_nr

FROM
t_adtf_raw
LEFT JOIN t_adtf_file_assignment ON t_adtf_raw.file_name = t_adtf_file_assignment.file_name

WHERE
row_nr = 1