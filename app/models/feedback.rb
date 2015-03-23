class Feedback < ActiveRecord::Base
  belongs_to :traveller
  def self.search(query,company_id=nil)
    # where(:title, query) -> This would return an exact match of the query
    if company_id
   		where("name like ? ","%#{query}%")
    else
    	where("name like ? and company_id = ? ","%#{query}%","#{company_id}")
	end
  end
end
