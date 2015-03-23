class ChangePasswordForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates :old_password, :password, :password_confimation, presence: true
  validates :verify_old_password
  attr_accessor :old_password, :password, :password_confirmation

  def initialize(user)
    @user = user
  end

  def change(params)
    self.old_password = params[:old_pasword]
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]

    if valid?
      @user.password = password
      @user.password_confirmation = password_confirmation
      @user.save!
      true
    else
      false
    end
  end

  def verify_old_password
      self.errors.add(:invaild, '"Not valid"') if @user.password != password
  end

  def persisted?
    false
  end

end