require 'nokogiri'
file_name = ARGV[0]

doc = Nokogiri::XML(File.open(file_name))
columns = doc.css 'Column'
types = columns.map { |c| c['sqltype'] }
p types.uniq