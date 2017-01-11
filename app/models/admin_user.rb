class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
  			# :registerable,
         #:recoverable, 
         :rememberable, :trackable, :validatable


  private
  def confirmation_period_valid?
    return true
  end

end
