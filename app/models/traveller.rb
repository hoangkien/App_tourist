class Traveller < ActiveRecord::Base
  has_and_belongs_to_many :tours
  belongs_to :company
  has_one :device
  validates :name,:phone, presence:true
  # def self.search(query,company_id = nil)
  # 	if company_id
  # 		where("1=1 and name like ? and company_id = ? ","%#{query}%","#{company_id}")	
  # 	else
  # 		where("1=1 and name like ? ","%#{query}%")	
  # 	end
  # end
    def self.search(query,company_id = nil)
     if company_id
       result="1=1  and company_id = #{company_id}"
     else
        result="1=1 "
     end
    # # if query[:group]
    # #   result += " and group like '%#{query[:group]}%' "
    # # end
    unless query[:name].blank?
      result += " and name like '%#{query[:name]}%' "
    end
    if query[:gender] != "All"
      gender=  query[:gender] == "Male" ? 0 : 1;
      result += " and gender ='#{gender}' "
    end
    if company_id == nil 
      unless query[:company].blank?
        result += " and company_id = #{query[:company]} "
      end
    end
    unless query[:address].blank?
      result += "  and address like '%#{query[:address]}%'"
    end
    unless query[:phone].blank?
      result += "  and phone like '%#{query[:phone]}%'"
    end
    unless query[:device_name].blank?
      @device = Device.where("name like '%#{query[:device_name]}%'")
      if @device.empty?
        result += " and 1 = 0"
      else
        array_id = []
        @device.each do |device|
          array_id << device.id
        end
         new_array_id = array_id.join(',')
        result += " and device_id in (#{new_array_id})" 
      end
    end
    if query[:active] != "All"
        active = query[:active] == "True" ? 1 : 0 ;
        result += " and active = '#{active}'"
    end
    # abort(result)
    where(result)
  end
   def self.upload(traveller)
      name = traveller['images'].original_filename
      directory = "app/assets/images/images_travellers"
    # create the file path
      path = File.join(directory, name)
    # write the file
      File.open(path, "wb") { |f| f.write(traveller['images'].read) }
  end
end
