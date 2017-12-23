-- Objective: Cumulative driven distance per row
-- Estimated time: 50 s
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS t_adtf_driven_dist_cum CASCADE;
CREATE TABLE t_adtf_driven_dist_cum AS
--------------------------------------------------------------------------------
SELECT
row_nr,
file_name,
subject_id,
scenario_id,
time_s,

-- Sum driven distance over all rows
SUM(dist_m_diff) 
	OVER (PARTITION BY file_name 
				ORDER BY row_nr) 
	AS dist_m
	
FROM
v_adtf_driven_dist_diff_by_row

ORDER BY
row_nr
