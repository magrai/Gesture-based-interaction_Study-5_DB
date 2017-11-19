DROP TABLE IF EXISTS t_adtf_link_file_name_and_last_row_nr CASCADE;
CREATE TABLE t_adtf_link_file_name_and_last_row_nr AS

SELECT 
temp_adtf_last_value.file_name,
temp_adtf_last_value.row_nr_last

FROM (
	SELECT
	t_adtf_raw.file_name,
	t_adtf_raw.row_nr,
	MAX(t_adtf_raw.row_nr) OVER (PARTITION BY t_adtf_raw.file_name) AS row_nr_last

	FROM
	t_adtf_raw

	ORDER BY
	row_nr
) temp_adtf_last_value

-- Select any row will display the same result
WHERE
row_nr = 1

ORDER BY
file_name