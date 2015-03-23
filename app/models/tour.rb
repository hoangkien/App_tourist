class Tour < ActiveRecord::Base

  has_and_belongs_to_many :travellers
  has_and_belongs_to_many :tourguides
  belongs_to :company
  def self.search(query)
  	where("name like ? or information like ?","%#{query}%","%#{query}%")
  end
  def self.search(query,company_id = nil)
  	if company_id
  		where("1=1 and ( name like ? or information like ? ) and company_id = ? ","%#{query}%","%#{query}%","#{company_id}")	
  	else
  		where("name like ? or information like ?","%#{query}%","%#{query}%")
  	end
  end
end
