class Code < ActiveRecord::Base
  validates :code, numericality: { only_integer: true }, length: { is: 4 }, presence: true
  validates :name, presence: true, uniqueness: true
end
