--What is the average age of officers when they have a complaint filed against them by another officer?
WITH my_officer_complaints_table as
   (SELECT EXTRACT('year' from incident_date) incident_year, birth_year --officer_age doesn't work (they're all null)
    FROM (data_allegation a JOIN data_officerallegation d on a.crid = d.allegation_id) JOIN data_officer o on o.id=d.officer_id
    WHERE is_officer_complaint=True)
SELECT avg(incident_year - birth_year) avg_age_at_time_of_incident
FROM my_officer_complaints_table;