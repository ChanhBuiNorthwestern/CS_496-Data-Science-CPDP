-- Query 2-1: what is the percentage of officers who resigned after 2 years after a officer-filed complaint?
WITH first_officer_complaint AS (
        SELECT officer_id, COALESCE(resignation_date, NOW()) last_service, MIN(incident_date) first_officer_incident
        FROM data_allegation a JOIN data_officerallegation d on a.crid = d.allegation_id
                JOIN data_officer o on d.officer_id = o.id
        WHERE is_officer_complaint = True
        GROUP BY officer_id, COALESCE(resignation_date, NOW()) )
SELECT COUNT(*)*100.0/(select count(*) from first_officer_complaint) as "Percentage from officer-filed complaint"
FROM first_officer_complaint
WHERE first_officer_incident < last_service and (EXTRACT('year' FROM age(last_service, first_officer_incident)) <=2);


-- Query 2-2: what is the percentage of officers who resigned after 2 years after a civilian-filed complaint?
WITH first_civilian_complaint AS (
        SELECT officer_id, COALESCE(resignation_date, NOW()) last_service, MIN(incident_date) first_civilian_incident
        FROM data_allegation a JOIN data_officerallegation d on a.crid = d.allegation_id
                JOIN data_officer o on d.officer_id = o.id
        WHERE is_officer_complaint = False
        GROUP BY officer_id, COALESCE(resignation_date, NOW()))
SELECT COUNT(*)*100.0/(select count(*) from first_civilian_complaint) as "Percentage from civilian-filed complaint"
        FROM first_civilian_complaint
        WHERE first_civilian_incident < last_service and (EXTRACT('year' FROM age(last_service, first_civilian_incident)) <=2);

-- Query 2-3: What is the normalized percentage of officers who resigned after 2 years after a officer-filed complaint
-- against the civilian-filed complaint?
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
        as "normalized ratio"
FROM first_officer_complaint
WHERE first_officer_incident < last_service and (EXTRACT('year' FROM age(last_service, first_officer_incident)) <=2);