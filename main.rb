require 'json'

$main_info = {};

ckan_dir = '/home/ethan/games/kerbal/CKAN-meta'

proj_list = Dir['#{ckan_dir}/*']

# sweet! "split" on a string handles blank lines in exactly the way I want :)
files = `cd #{ckan_dir}; git log --name-only --format='format:' HEAD~5..HEAD`.split

files.each do |f|
	path = "#{ckan_dir}/#{f}"
	if File.exists?(path) then
		puts "Reading #{f}"
		info = JSON.parse(File.read(path))
		$main_info[info['identifier']] = info
	else
		puts "No such file #{f}"
	end
end

puts "Done reading\n\n"

$main_info.keys.sort.each do |key|
	info = $main_info[key]
	puts "#{info['name']}: #{info['abstract']}"
end
