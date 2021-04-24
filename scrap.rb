require 'nokogiri'
require 'open-uri'
require 'csv'

csv_file_path = 'data.csv'
url = 'Business - Insider.htm'
doc = Nokogiri::HTML(open(url), nil, 'utf-8')

title = []

doc.search('.tout-title-link').each do |element|
  new_element = element.text.strip.tr("0-9", "")
  unless (new_element == "") || (new_element == " ")
    title << new_element
  end
end

csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

CSV.open(csv_file_path, 'wb', csv_options) do |csv|
  title.each do |article|
    csv << [article]
  end
end


# CNBC Data
csv_file_path_cnbc = 'data_cnbc.csv'
url_cnbc = 'cnbc.htm'
doc_cnbc = Nokogiri::HTML(open(url_cnbc), nil, 'utf-8')

title_cnbc = []

doc_cnbc.search('.Card-titleContainer').each do |element|
  new_element = element.text.strip.tr("0-9", "")
  unless (new_element == "") || (new_element == " ")
    title_cnbc << new_element
  end
end

CSV.open(csv_file_path_cnbc, 'wb', csv_options) do |csv|
  title_cnbc.each do |article|
    csv << [article]
  end
end