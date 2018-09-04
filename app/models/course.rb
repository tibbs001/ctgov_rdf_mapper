class Course < ActiveRecord::Base

  self.table_name = 'PS_DU_INSTR_CRS_VW'

  def self.for_strm_and_duids(strm, duids)
     array = Course.where(:strm => strm).value_of :strm, :subject, :catalog_nbr, :course_title_long, :strm_descr, :campus_id
     array = array.select{ |c| duids.include? c[5]}
     array.map {|c| VivoMapper::Course.new(
        :uid          => "#{c[1].strip}#{c[2].strip}", 
        :label        => "#{c[1]} #{c[2]}: #{c[3]}", 
        :start_year   => c[4].split(' ').first, 
        :term         => c[4].split(' ').last, 
        :person_uid   => c[5], 
        :teacher_role => 'Instructor') 
     }
  end

end
