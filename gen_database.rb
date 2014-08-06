# encoding: utf-8
require 'json'
$dir = "songs/"
database = Hash.new
Dir.foreach($dir) do |item|
	next if item == '.' or item == '..'
	next if not File.directory? $dir+item # skip files
	file = $dir+'/'+item+'/metadata.json'
	if File.exists? file
		metadata = JSON.parse(File.read file)
		database[item] = metadata['Title']
	end
end
d = database.to_json.gsub("\",","\",\n\r")
File.open($dir +'/database.json', 'w:UTF-8') { |file| file.write(d) }
