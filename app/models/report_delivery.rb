class ReportDelivery
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :mechanism, Enum[:email, :ftp], :default => :email
  property :type, Enum[:reject, :ingest, :disseminate], :default => :ingest

  belongs_to :package
end