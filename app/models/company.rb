# == Schema Information
#
# Table name: companies
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :text             not null
#  updated_at :datetime         not null
#

class Company < ActiveRecord::Base
  # Validations
  validates :name, presence: true

  # Employees
  has_many :users

  attr_accessible :name
end
