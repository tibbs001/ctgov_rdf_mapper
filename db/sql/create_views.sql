CREATE OR REPLACE VIEW vivo_mapper.v_schools
AS
SELECT om.organizational_unit, o.display_name
  FROM organization_mergings om, organizations o 
 WHERE o.organizational_unit = om.organizational_unit
   AND  om.organization_type='School' 
   AND om.organizational_unit = om.visible_organizational_unit

------------------------------

CREATE OR REPLACE VIEW  vivo_mapper.v_current_professorships
AS
SELECT  prof.source_key unique_id, 
        prof.title, 
        p.duid, 
        o.organizational_unit,
        to_char(prof.start_date,'MM/DD/YYYY') start_date,
        to_char(prof.end_date,'MM/DD/YYYY') end_date 
  FROM  apt.professorships prof, 
        apt.people p,
        apt.current_organizations o,
        vivo_mapper.v_vivo_people vp
 WHERE  prof.person_id = p.id
   AND  p.organizational_unit = o.organizational_unit
   AND (prof.end_date IS NULL or prof.end_date >= sysdate)
   AND  prof.start_date <= sysdate
   AND  p.duid = vp.duid

------------------------------

CREATE OR REPLACE VIEW  vivo_mapper.v_opt_in_duids
AS
SELECT DISTINCT p.duid
  FROM vivo_mapper.organization_mergings  om,
       vivo_mapper.opt_in_organizations   opt_in, 
       apt.v_current_organizations        o, 
       apt.v_current_organizations        child,
       apt.people                         p,
       apt.appointments                   a,
       vivo_mapper.organization_lookups   lkp
 WHERE om.visible_organizational_unit = o.organizational_unit 
   AND opt_in.organizational_unit       = om.visible_organizational_unit
   AND om.organizational_unit           = child.organizational_unit
   AND p.id                             = a.person_id
   AND a.appointment_type               = 'P'
   AND a.organizational_unit            = lkp.organizational_unit
   AND (a.end_date is null OR a.end_date >= sysdate)
   AND (a.start_date <= sysdate)
   AND a.source != 'InProcess'
   AND (   lkp.organizational_unit = child.organizational_unit 
        OR lkp.organizational_unit = o.organizational_unit)
 UNION
SELECT duid from vivo_mapper.opt_in_people

------------------------------

--  The opt_in table should be referenced only when loading data that should NOT appear in the pilot system.
--  Since all active faculty and their dFac data (appointments, education, professorships, etc.) will appear
--  in scholars@duke, we don't want to restrict according to the opt_in on this view.

CREATE OR REPLACE VIEW vivo_mapper.v_vivo_people 
AS
SELECT DISTINCT 
      p.duid,
      p.pro_first_name || ' ' || p.pro_middle_name || ' ' || p.pro_last_name as professional_name,
      a.organizational_unit,
      a.appointment_type
 FROM apt.people                  p,
--      vivo_mapper.v_opt_in_duids  opt_in,
      apt.appointments            a
WHERE p.id = a.person_id
  AND p.employment_status IN ('Active','Inactive')
  AND p.source not in ('InProcess','Approved')
  AND (a.end_date is null or a.end_date >= sysdate)
  AND (a.start_date <= sysdate)
  AND a.source != 'InProcess'
--  AND p.duid = opt_in.duid

--------------------------

CREATE OR REPLACE VIEW vivo_mapper.v_current_appointments
AS
SELECT  a.id,
        p.duid,
        a.organizational_unit,
        o.description as organizational_description,
        o.display_name,
        a.start_date,
        a.end_date,
        a.end_reason,
        a.begin_contract_date,
        a.end_contract_date,
        a.title,
        a.status,
        a.status_date,
        a.subtrack,
        a.trustee_date,
        a.tenure_years,
        j.code as job_code,
        j.title as job_title,
        j.code_type as job_code_type,
        j.historical as historical_job_code,
        a.do_not_reappoint,
        a.action,
        a.appointment_type,
        a.full_service_flag,
        a.title_precedence,
        a.source_key as appointment_number,
        a.workflow_level
  FROM  apt.appointments a, 
        apt.people       p,
        vivo_mapper.v_vivo_people vp, 
        apt.job_codes j, 
        apt.current_organizations o
 WHERE  a.person_id = p.id
   AND  p.duid = vp.duid
   AND  a.organizational_unit = o.organizational_unit
   AND  a.organizational_unit = vp.organizational_unit
   AND  a.appointment_type    = vp.appointment_type
   AND  p.duid                = vp.duid
   AND  j.id                  = a.job_code_id
   AND  (a.end_date is null or a.end_date >= sysdate)
   AND  (a.start_date <= sysdate)
   AND  a.source != 'InProcess'

--------------------------

CREATE OR REPLACE VIEW vivo_mapper.v_addresses
AS
SELECT  p.duid || '_' || a.address_type  unique_id,
        a.line_1 || ' ' || a.line_2 || ' ' || a.city || ', ' || a.state label,
        p.duid person_uid,
        a.line_1 street,
        a.city,
        a.state,
        a.zip_code,
        a.country_code country,
        a.address_type,
        work_a.phone_1 phone,
        lower(p.email) email
  FROM  apt.addresses a, 
        apt.addresses work_a,
        apt.people p,
        vivo_mapper.v_vivo_people vp
 WHERE  a.person_id = p.id
   AND work_a.person_id = p.id
   AND work_a.address_type='work_location'
   AND a.address_type IN ('work_location', 'work_mailing')
   AND p.employment_status = 'Active' 
   AND p.source NOT IN ('InProcess','Approved') 
   AND p.position_job_code NOT IN (1599) 
   AND p.duid = vp.duid

--  These views created in SPS_DS vivo_mapper schema

--DROP MATERIALIZED VIEW vivo_mapper.mv_most_recent_grants
CREATE MATERIALIZED VIEW vivo_mapper.mv_most_recent_grants
AS
SELECT DISTINCT
       max(p.proposalid)                     proposalid, 
       p.agencyidcorenumber                  agencyidcorenumber
FROM proposalds                              p, 
     proposalpersonds                        pp,
     personds                                per,
     proposalawardds                         pa,
     vivo_mapper.v_vivo_people@FDRPRD.world  vivo_p
WHERE p.proposalid    =   pp.proposalid
  AND p.proposalid    =   pa.proposalid
  AND pp.personID     =   per.personid
  AND vivo_p.duid     =   pp.dukeuniqueid
  AND (per.canbepi    = 1 OR per.facultystatus = 'Faculty')
  AND (pp.investigatorroleid in (1,2) OR (pp.investigatorroleid IS NULL AND pp.ismultipi = 1) OR pp.investigatorroleid IS NULL)
  AND p.documentstatecode in ('AWARD', 'AIP','AWD-IN')
  AND TRIM(pp.investigatorroleid) IS NOT NULL
  AND TRIM(p.sponsorname) IS NOT NULL
GROUP BY p.agencyidcorenumber

---------------------------------
--CREATE MATERIALIZED VIEW vivo_mapper.mv_grants
--  see app/models/grant.rb
---------------------------------

CREATE OR REPLACE VIEW v_grants 
AS
SELECT g.* 
  FROM mv_grants g, mv_most_recent_grants r
 WHERE g.agency_id_core IS NOT NULL
   AND g.grant_uid = r.proposalid

UNION

SELECT *
  FROM mv_grants
 WHERE agency_id_core IS NULL


