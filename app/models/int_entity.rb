  class Intentity
    include DataMapper::Resource
    property :id, String, :key => true, :length => 50
    # daitss1 ieid
    property :original_name, String, :length => 32, :required => true, :default => "UNKNOWN"
    # i.e. package_name
    property :entity_id, String, :length => 100
    property :volume, String, :length => 64
    property :issue, String, :length => 64
    property :title, Text

    belongs_to :package
    has 0..n, :datafiles, :constraint=>:destroy

    #before :destroy, :deleteChildren

    def check_errors
      unless self.valid?
        bigmessage = self.errors.full_messages.join "\n" 
        raise bigmessage unless bigmessage.empty?
      end
      
      unless package.valid?
        bigmessage = package.errors.full_messages.join "\n"
        raise bigmessage unless bigmessage.empty?
      end
      
      datafiles.each {|df| df.check_errors }
    end
    
    # construct an int entity with the information from the aip descriptor
    def fromAIP aip
      entity = aip.find_first('//p2:object[p2:objectCategory="intellectual entity"]', NAMESPACES)
      raise "cannot find required intellectual entity object in the aip descriptor" if entity.nil?
      # extract and set int entity id
      id = entity.find_first("p2:objectIdentifier/p2:objectIdentifierValue", NAMESPACES)
      raise "cannot find required objectIdentifierValue for the intellectual entity object in the aip descriptor" if id.nil?
      attribute_set(:id, id.content)

      originalName = entity.find_first("p2:originalName", NAMESPACES)
      attribute_set(:original_name, originalName.content) if originalName

      # extract and set the rest of int entity metadata
      mods = aip.find_first('//mods:mods', NAMESPACES)
      if mods
        title = mods.find_first("mods:titleInfo/mods:title", NAMESPACES)
        attribute_set(:title, title.content) if title
        volume = mods.find_first("mods:part/mods:detail[@type = 'volume']/mods:number", NAMESPACES)
        attribute_set(:volume, volume.content) if volume
        issue = mods.find_first("mods:part/mods:detail[@type = 'issue']/mods:number", NAMESPACES)
        attribute_set(:issue, issue.content) if issue
        entityid = mods.find_first("mods:identifier[@type = 'entity id']", NAMESPACES)
        attribute_set(:entity_id, entityid.content) if entityid
      end
    end

    # delete this datafile record and all its children from the database
    def deleteChildren
      # find the id of all datafiles belong to this int entity
      sql = "SELECT id from datafiles where intentity_id = '#{@id}'"
      dfids = DataMapper.repository(:default).adapter.select(sql)
      #puts sql
      dfids.each do |dfid|
        # delete all related premis_events records and its associated relationships which will be deleted
        # automatically by cascade delete
        del_sql = "DELETE from premis_events where related_object_id = '#{dfid}'"
        DataMapper.repository(:default).adapter.execute(del_sql)
      end
      
      # delete all events associated with this int entity
      sql = "delete from premis_events where related_object_id = '#{@id}'"
      DataMapper.repository(:default).adapter.execute(sql)
    end

    def match id
      matched = false
      if id && id == @id
        matched = true
      end
      matched
    end

  end

