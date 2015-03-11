require 'json'

$main_info = {};

proj_list = Dir['/home/ethan/games/kerbal/CKAN-meta/*']

proj_list.each do |proj|
	versions = Dir["#{proj}/*.ckan"]
	versions.each do |v|
		puts "Reading #{v}"
		info = JSON.parse(File.read(v))
		$main_info[info['identifier']] = info
	end
end

puts "Done reading\n\n"

$main_info.keys.sort.each do |key|
	info = $main_info[key]
	puts "#{info['name']}: #{info['abstract']}"
end
