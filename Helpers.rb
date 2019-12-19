module Helpers
  def self.data_type(column)
    case column["sqltype"].downcase
    when "integer"
      "INT"
    when "varchar"
      "VARCHAR (#{column["size"]})"
    when "longvarchar"
      "TEXT"
    when "double"
      "FLOAT"
    when "time", "date", "timestamp"
      "DATETIME"
    else
      column["sqltype"].upcase
    end
  end
  def self.constraints(column)
    column["primarykey"] == "yes" ? "PRIMARY KEY NOT NULL" : ""
  end
end
