
class User < ActiveRecord::Base
  require'digest/md5'
  belongs_to :company, dependent: :destroy
	GROUP = [:admin, :company]
  before_create :md5   
  validates :account, :password, :password_confirmation, :name,:address, presence: true, on: :create
  validates :account, :name, :address, presence: true, on: :update
  validates :account, uniqueness: true, length: { minimum: 6 }, on: :create
  validates :password , confirmation:true, length:{minimum:6}, on: :create
  validates :account,:password, format: { with: /\A[a-zA-Z0-9]+\z/, message: " is invalid"} ,on: :create
  def self.search(query)
    result="1=1 "
    # # if query[:group]
    # #   result += " and group like '%#{query[:group]}%' "
    # # end
    unless query[:account].blank?
      result +=" and account like '%#{query[:account]}%' "
    end
    unless query[:name].blank?
      result += " and name like '%#{query[:name]}%' "
    end
    unless query[:address].blank?
      result += " and address like '%#{query[:address]}%' "
    end
    if query[:group] != "All"
      result += " and users.group ='#{query[:group]}' "
    end
    unless query[:company].blank?
      result += " and company_id = #{query[:company]} "
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

    # abort(query[:name])
    # query.each do | fillter|
    #  raise RuntimeError, "#{fillter.account}; Message goes here"
    # end
    # where(:title, query) -> This would return an exact match of the query
    # result=
    # abort(result)
    # where(result)
    where(result)
  end
  private
  def md5
      self.password = Digest::MD5.hexdigest(password)
  end
  def self.login(account, pass)
    where("account like ? and password like ?","#{account}","#{pass}").first
  end
end
