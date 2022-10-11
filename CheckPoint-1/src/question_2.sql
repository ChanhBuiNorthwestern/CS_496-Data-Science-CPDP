WITH first_officer_complaint AS (
        SELECT officer_id, COALESCE(resignation_date, NOW()) last_service, MIN(incident_date) first_officer_incident
        FROM data_allegation a JOIN data_officerallegation d on a.crid = d.allegation_id
                JOIN data_officer o on d.officer_id = o.id
        WHERE is_officer_complaint = True
        GROUP BY officer_id, COALESCE(resignation_date, NOW()) ),
    first_civilian_complaint AS (
        SELECT officer_id, COALESCE(resignation_date, NOW()) last_service, MIN(incident_date) first_civilian_incident
        FROM data_allegation a JOIN data_officerallegation d on a.crid = d.allegation_id
                JOIN data_officer o on d.officer_id = o.id
        WHERE is_officer_complaint = False
        GROUP BY officer_id, COALESCE(resignation_date, NOW()) )

SELECT COUNT(*)*100.0/(select count(*) from first_officer_complaint)/
       (SELECT COUNT(*)*100.0/(select count(*) from first_civilian_complaint)
        FROM first_civilian_complaint
        WHERE first_civilian_incident < last_service and (EXTRACT('year' FROM age(last_service, first_civilian_incident)) <=2))
FROM first_officer_complaint
WHERE first_officer_incident < last_service and (EXTRACT('year' FROM age(last_service, first_officer_incident)) <=2);