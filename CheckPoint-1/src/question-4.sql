-- Query 4-1: what is the percentage of the complaints filed by officers that involve the use of force/firearms?
select COUNT(*) *100.0 / (select count(*)
                          from data_allegation
                          where most_common_category_id in (select id
                                                            from data_allegationcategory a)
                            and (is_officer_complaint=False))
from data_allegation da
where da.most_common_category_id in (select id
    from data_allegationcategory a
    where UPPER(a.allegation_name) like UPPER('%Firearm%'))
and da.is_officer_complaint = False;

-- Query 4-2: what is the percentage of the complaints filed by civilians that involve the use of force/firearms?
select COUNT(*) *100.0 / (select count(*)
                          from data_allegation
                          where most_common_category_id in (select id
                                                            from data_allegationcategory a)
                            and (is_officer_complaint=True))
from data_allegation da
where da.most_common_category_id in (select id
    from data_allegationcategory a
    where UPPER(a.allegation_name) like UPPER('%Firearm%'))
and da.is_officer_complaint = True;

-- Query 4-3: what is the percentage of the complaint-categories that involve the use of force/firearms?
select count(*) *100.0 / (select count(*)
                    from data_allegationcategory)
from data_allegationcategory a
where UPPER(a.allegation_name) like UPPER('%Firearm%');