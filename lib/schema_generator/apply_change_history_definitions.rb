module SchemaGenerator
  # This class adds change history as part of the details hash as this is
  # something done automatically by Publishing API and should be changed there
  # to be outside the details hash
  class ApplyChangeHistoryDefinitions
    def self.call(definitions)
      return definitions unless definitions["details"]

      definitions.tap do |d|
        d["details"]["properties"]["change_history"] = {
          "$ref" => "#/definitions/change_history"
        }
      end
    end
  end
end
