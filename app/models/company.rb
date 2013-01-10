# == Schema Information
#
# Table name: companies
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :text             not null
#  slug       :text
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companies_on_slug  (slug) UNIQUE
#

class Company < ActiveRecord::Base
  # FriendlyId
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # Employees
  has_many :users

  attr_accessible :name
end
