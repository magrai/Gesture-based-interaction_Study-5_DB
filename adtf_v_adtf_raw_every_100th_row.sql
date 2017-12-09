DROP VIEW IF EXISTS v_adtf_raw_every_100th_row CASCADE;
CREATE VIEW v_adtf_raw_every_100th_row AS

SELECT
t_adtf_raw.file_name,
MIN(t_adtf_raw.row_nr) AS row_nr,
ROUND(t_adtf_raw."Time"::NUMERIC, 1) AS time_s,
MIN(t_adtf_raw."itrace.gps.Longitude") AS gps_lon,
MIN(t_adtf_raw."itrace.gps.Latitude") AS gps_lat,
MIN(t_adtf_raw."can.angez_Geschw") AS speed_kmh

FROM
t_adtf_raw

WHERE row_nr % 100 = 0

GROUP BY
t_adtf_raw.file_name,
ROUND(t_adtf_raw."Time"::NUMERIC, 1)
