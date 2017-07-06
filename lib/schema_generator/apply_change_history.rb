module SchemaGenerator
  # This class adds change history as part of the details hash as this is
  # something done automatically by Publishing API and should be changed there
  # to be outside the details hash
  class ApplyChangeHistory
    def self.call(schema)
      cloned = schema.clone
      return schema unless schema["definitions"]["details"]

      cloned["definitions"]["details"].tap do |details|
        details["properties"]["change_history"] = {
          "$ref"=>"#/definitions/change_history"
        }
      end
      cloned
    end
  end
end
