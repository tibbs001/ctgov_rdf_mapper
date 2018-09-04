class Grant < ActiveRecord::Base

  self.table_name = 'V_GRANTS'

  def self.for_vivo(duids=(Person.duids_for_vivo & Grant.duids))
    if duids.size < 500
      array = (Grant.where('duid in (?)', duids).value_of :grant_uid, :parent_uid, :person_uid, :faculty_name, :sponsor, :organizational_unit, :title, :start_date, :end_date, :investigator_role, :agency_id_core).sort {|a,b| b[0]<=>a[0]}
    else
      array = (Grant.where('investigator_role is not null').value_of :grant_uid, :parent_uid, :person_uid, :faculty_name, :sponsor, :organizational_unit, :title, :start_date, :end_date, :investigator_role, :agency_id_core).sort {|a,b| b[0]<=>a[0]}
      array = array.select{|g| duids.include? g[2]}
    end
    Hide.remove_hidden_from(transform_to_objects(array),'Grant')
  end

  def self.for_vivo_sponsor_initial(letter)
    query_sponsor_string = "regexp_replace(regexp_replace(trim(upper(sponsor)),'[^a-z,_, ,A-Z,@,&,$,%,'']',''),'[[:space:]]{1,}','') "
    array = (Grant.where("#{query_sponsor_sring} like ? ","#{letter.upcase}%").value_of :grant_uid, :parent_uid, :person_uid, :faculty_name, :sponsor, :organizational_unit, :title, :start_date, :end_date, :investigator_role, :agency_id_core).sort {|a,b| b[0]<=>a[0]}
    Hide.remove_hidden_from(transform_to_objects(array), 'Grant')
  end

  def self.transform_to_objects(array)
    array1= array.map {|g| 
      VivoMapper::Grant.new(
        :uid               => g[0],
        :parent_uid        => (g[1] if ! g[1].blank?), 
        :person_uid        => g[2],
        :faculty_name      => g[3],
        :institution_uid   => g[4].gsub(/[^0-9a-z]/i, '').downcase, 
        :sponsor           => g[4],
        :organization_uid  => g[5],
        :label             => g[6].gsub('  ',' '), 
        :start_date        => g[7],
        :end_date          => g[8],
        :investigator_role => g[9],
        :agency_id_core    => g[10]
      )
    }
    merge_repeating_grants(array1, &unique_label_key) 
  end
 
  def self.merge_repeating_grants(array, &key_map)
    hash = {}
    array.each {|g| hash[key_map.call(g)] = g }
    return hash.values
  end

  def self.unique_label_key
    Proc.new {|g| g.label ? "#{g.institution_uid}-#{g.person_uid}-#{g.label.gsub(/[^0-9a-z]/i, '')}".downcase : "#{g.institution_uid}-#{g.person_uid}-#{g.uid}".downcase } 
  end

  def self.refresh_view
    Grant.transaction do
      Grant.drop_view
      Grant.create_view
    end
  end

  def self.drop_view
    begin
      self.new.connection.execute('DROP MATERIALIZED VIEW vivo_mapper.mv_grants')
    rescue Exception => e 
      puts "Error when dropping grants view:  #{e.message}"
    end
  end

  def self.create_view
    begin
      self.new.connection.execute(Grant.sql_to_create_materialized_view)
    rescue Exception => e 
      puts "Error when creatign grants view:  #{e.message}"
      raise Exception
    end
  end

  def self.sql_to_create_materialized_view
    "CREATE MATERIALIZED VIEW vivo_mapper.mv_grants
AS
SELECT DISTINCT
       to_char(p.proposalid)                     grant_uid, 
       p.parentproposalid                        parent_uid,
       pp.dukeuniqueid                           person_uid, 
       pp.fullname                               faculty_name, 
       p.sponsorname                             sponsor, 
       TRIM(p.shorttitle)                        title,
       pa.projectperiodstartdate                 start_date,
       pa.projectperiodenddate                   end_date,
       DECODE(pp.investigatorroleid,
           1, pp.investigatorroledescription,
           2, pp.investigatorroledescription,
           3, ' ',
          DECODE(pp.ismultipi,1,'Multi-PI',' ')) investigator_role,
       NVL(pp.participantroledescription,' ')    participant_role,
       vivo_o.vivo_organizational_unit           organizational_unit,
       p.originatingproposalid                   originating_sps_id, 
       p.agencyidcorenumber                      agency_id_core,
       p.documentstatecode                       status,
       p.proposalactivitydescription             activity,
       p.proposaltypedescription                 proposal_type,
       p.programprojectgrantindicator            classification,
       p.awarddate                               award_date
FROM proposalds                                     p, 
     proposalpersonds                               pp,
     personds                                       per,
     proposalawardds                                pa,
     vivo_mapper.v_vivo_people@FDRPRD.world         vivo_p,
     vivo_mapper.organization_lookups@FDRPRD.world  vivo_o,
     mv_most_recent_grants                          most_recent
WHERE p.proposalid    = pp.proposalid
  AND p.proposalid    = pa.proposalid
  AND pp.personID     = per.personid
  AND vivo_p.duid     = pp.dukeuniqueid
  AND vivo_o.bfr_code = p.owningbfrcode
  AND (per.canbepi = 1 or per.facultystatus = 'Faculty')
  AND (pp.investigatorroleid in (1,2) or (pp.investigatorroleid IS NULL AND pp.ismultipi = 1) or pp.investigatorroleid IS NULL)
  AND p.documentstatecode in ('AWARD', 'AIP','AWD-IN')
  AND TRIM(pp.investigatorroleid) is NOT NULL
  AND TRIM(p.sponsorname) IS NOT NULL
  AND (p.agencyidcorenumber is NULL  
      OR (p.agencyidcorenumber IS NOT NULL 
         AND p.proposalid = most_recent.proposalid)
      )"
  end
end

