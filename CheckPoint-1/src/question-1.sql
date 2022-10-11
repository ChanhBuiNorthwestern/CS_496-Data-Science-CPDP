-- Query 1-1: what is the percentage of allegations filed by police officers?
select (count(*)*100.0/(select count(*) from data_allegation ))
   as "percentage of allegations filed by police officers"
from data_allegation a
where a.is_officer_complaint = True;