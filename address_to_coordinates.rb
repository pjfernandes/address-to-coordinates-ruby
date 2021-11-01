require 'csv'
require 'geocoder'
Geocoder.configure(:timeout => 50000)

csv_options = { col_sep: ';', headers: :first_row }
filepath = 'address_list.csv'

coords_array = []
address_name_array = []

CSV.foreach(filepath, csv_options) do |row|
  address_name_array << [row[0],row[1]]
  coords = Geocoder.coordinates(row[1])
  unless coords.nil?
    coords_array << coords
  else
    coords = Geocoder.coordinates(row[0])
    coords_array << coords.to_a
  end
end

csv_options_to_save = { col_sep: ';', force_quotes: true, quote_char: '"' }
filepath_to_save = 'coordinates.csv'

CSV.open(filepath_to_save, 'wb', csv_options_to_save) do |csv|
  # coords_array.each_with_index do |index|
  # end
  for i in (0..coords_array.size-1) do
    csv << address_name_array[i] + coords_array[i]
    puts i
  end
end
