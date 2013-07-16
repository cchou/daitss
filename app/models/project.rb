require 'dm-core'
require 'dm-validations'

class Project
  include DataMapper::Resource

  property :id, String, :key => true
  property :description, Text

  property :account_id, String, :key => true

  has 0..n, :packages

  belongs_to :account, :key => true
  
 def to_param
    id
   # "#{id}/#{account_id}"
  end  
end
