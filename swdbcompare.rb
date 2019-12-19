################################################################################
# Assumptions:
#   - Just going to output Create/alter/delete tables
#     and ignore if there's >1 <Aplication> tag
#   - Will check all attributes of columns, and if attrs !=, then column will be
#     updated.
#   - If a column doesn't explicitly say it's nullable, this script will make it
#     not nullable.
################################################################################
require "nokogiri"
require "./Helpers"

sql = '';

new_doc = Nokogiri::XML(File.open('./new.xml'))
old_doc = Nokogiri::XML(File.open('./old.xml'))

tables_path = 'Application[name=swserverservice] Database[name=swdata] Tables Table'
# columns_path = "#{tables_path} Column"

tables_in_new = new_doc.css tables_path
columns_in_new = new_doc.css "#{tables_path} Column"

tables_to_add = tables_in_new.select do |e|
  (old_doc.css "#{tables_path}[name=#{e['name']}]").length == 0
end

columns_to_add = columns_in_new.select do |e|
  table_name = e.parent['name']
  (old_doc.css "#{tables_path}[name=#{table_name}] Column[name=#{e['name']}]").length == 0
end

# add the tables
tables_to_add.each do |e|
  sql += "CREATE TABLE #{e['name']} (\n"
  e.css('Column').each do |c|
    sql += "\t#{c['name']} #{Helpers.data_type(c)} #{Helpers.constraints(c)}, \n"
  end
  sql += ");\n"
end

columns_to_add.each do |e|
  table_name = e.parent['name']
  sql += "ALTER TABLE #{table_name} \n"
  sql += "ADD #{e['name']} #{Helpers.data_type(e)} #{Helpers.constraints(e)};\n"
end

File.open("changes.sql", "w") { |f| f.write sql }
