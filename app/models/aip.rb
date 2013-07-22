
require 'libxml'
require 'net/http'

include LibXML
XML.default_line_numbers = true


  class Aip
    include DataMapper::Resource

    XML_SIZE = 2**32-1
    XML_ERRATA_SIZE = 65535
    
    property :id, Serial
    property :xml, Text, :required => true, :length => XML_SIZE
    property :xml_errata, Text, :length => XML_ERRATA_SIZE, :required => false
    property :datafile_count, Integer # uncomment after all d1 packages are migrated, :required => true

    belongs_to :package
    has 0..1, :copy # 0 if package has been withdrawn, otherwise, 1

    # report error upon failure in saving 
    def check_errors
      unless self.valid?
        bigmessage = self.errors.full_messages.join "\n" 
        raise bigmessage unless bigmessage.empty?
      end
      
      unless copy.valid?
        bigmessage =  copy.errors.full_messages.join "\n" 
        raise bigmessage unless bigmessage.empty?
      end
    end
   
    # save to database
    def toDB
      @xml_errata = @xml_errata.slice(0, XML_ERRATA_SIZE) if @xml_errata
      unless self.save
        self.check_errors 
        raise "error in saving Aip record, no validation error found"
      end
    end
  
  end

