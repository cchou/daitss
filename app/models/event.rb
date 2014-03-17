class Event
    include DataMapper::Resource

    property :id, Serial, :key => true
    property :name, String, :required => true, :index => true
    property :timestamp, DateTime, :required => true, :default => proc { DateTime.now }
    property :notes, Text, :length => 2**32-1
    property :outcome, String, :default => "N/A"

    belongs_to :agent
    belongs_to :package
    has n, :comments

  def polite_name
    if name =~ /unsnafu/
      name.gsub 'unsnafu', 'reset' 
    else
      name.gsub 'snafu', 'error'
    end
  end
end
