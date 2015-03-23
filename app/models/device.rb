class Device < ActiveRecord::Base
  require 'active_support/core_ext/array/conversions.rb'
  belongs_to :tourguide
  belongs_to :traveller
  belongs_to :company
  has_one :feedback
  # def self.search(query,company_id = nil)
  # 	if company_id
  # 		where("1=1 and name like ? and company_id = ? ","%#{query}%","#{company_id}")	
  # 	else
  # 		where("name like ? or id = ?","%#{query}%","#{query}")	
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
    if query[:status] != "All"
      status=  query[:status] == "True" ? 1 : 0;
      result += " and status ='#{status}' "
    end
    if company_id == nil 
      unless query[:company].blank?
        result += " and company_id = #{query[:company]} "
      end
    end
    unless query[:lat].blank?
      result += " and lat = #{query[:lat]} "
    end
    unless query[:lng].blank?
      result += " and lng = #{query[:lng]} "
    end
    if query[:created_at] == "Day ago"
      date = Time.at(1.day.ago.to_i)
      result += " and created_at > '#{date}'"
    elsif query[:created_at] == "Weeks ago"
      date = Time.at(1.week.ago.to_i)
      result += " and created_at > '#{date}'"
    elsif query[:created_at] == "A month ago"
      date = Time.at(1.month.ago.to_i)
      result += " and created_at > '#{date}'"
    elsif query[:created_at] == "Six month ago"
      date = Time.at(6.months.ago.to_i)
      result += " and created_at > '#{date}'"
    elsif query[:created_at] == "Years ago"
      date = Time.at(1.year.ago.to_i)
      result += " and created_at > '#{date}'"
    end
    # abort(result)
    where(result)
  end
  def self.search_active_o
  	where("status = 0")
  end
end
