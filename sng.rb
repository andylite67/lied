# encoding: utf-8
require 'fileutils'
require 'json'
$from = './SNG'
def clean_filename(name)
	name = name.sub '.sng', ''
	name = name.gsub('ä','ae').gsub('Ä','Ae').gsub('ö','oe').gsub('Ö','Oe').gsub('ü','ue').gsub('Ü','Ue').gsub('ß','ss')
	name = name.gsub('(', ' ').gsub(')', ' ')
	name = name.gsub(',', ' ').gsub(':', ' ').gsub('.', ' ')
	name = name.gsub("'", ' ')
	cap = ""
	name.split(' ').each do |x|
		cap  += x.capitalize.chomp
	end
	return cap
end

Dir.foreach($from) do |item|
	next if item == '.' or item == '..' or item == '.directory'
	puts item
	folder = './newSong/'+clean_filename(item)
	FileUtils.mkpath folder
	out = ""
	metadata = {}
	File.open($from+'/'+item, 'r:UTF-8').each do |line|
		if line.start_with? '---'
			out += "\n\n" if out != ""
		elsif line.start_with? '#'
			line = line.unpack('C*').pack('U*')
			puts line
			line.sub!('#','')
			d = line.split('=')
			metadata[d[0]] = d[1].chomp
		else
			out += line
		end
    end

    File.open(folder +'/text.txt', 'w:UTF-8') { |file| file.write(out) }
    File.open(folder +'/metadata.json', 'w:UTF-8') { |file| file.write(metadata.to_json) }
end
