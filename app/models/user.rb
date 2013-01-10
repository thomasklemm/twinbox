# == Schema Information
#
# Table name: users
#
#  company                :text             not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :text
#  confirmed_at           :datetime
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :text
#  email                  :text             default(""), not null
#  encrypted_password     :text             default(""), not null
#  first_name             :text             not null
#  id                     :integer          not null, primary key
#  last_name              :text             not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :text
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :text
#  sign_in_count          :integer          default(0)
#  slug                   :text
#  unconfirmed_email      :text
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :confirmable

  # FriendlyId
  extend FriendlyId
  friendly_id :company, use: :slugged

  # Validations
  validates :first_name, :last_name, :company, presence: true

  # Virtual attributes
  def full_name
    "#{ first_name } #{ last_name }"
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :company
end
