class Company < ActiveRecord::Base
  has_one :user
  has_many :tourguides
  has_many :travellers
  has_many :devices,dependent: :destroy
  has_many :tours, dependent: :destroy
  require 'securerandom'

  validates :name, :address, presence: true
  validates :name ,uniqueness: true

  def self.generate_company_code
    begin
      code = SecureRandom.hex(6)
    end while Company.find_by_code(code)
    code
  end
  def self.get_all_company
    Company.select(:id,:name)
  end
  private
  def self.search(query)
    where("name like ? or address like ?","%#{query}%","%#{query}%")
  end

end
