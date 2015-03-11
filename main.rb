require 'json'

$main_info = {};

settings_dir = "#{ENV['HOME']}/.soron-tools/ckan-info"
settings_file = "#{settings_dir}/config.json"

settings = (File.exists?(settings_file)) ? JSON.parse(File.read(settings_file)) : {}

if !settings['ckan-dir'] then
	# TODO have this support path relative to cwd, and then convert to absolute before save
	puts 'Where do you have the CKAN-meta git directory? (absolute path preferred)'
	# TODO figure out best way to trim a trailing newline
	settings['ckan-dir'] = readline.split[0]
end

proj_list = Dir["#{settings['ckan-dir']}/*"]

# sweet! "split" on a string handles blank lines in exactly the way I want :)
files = `cd #{settings['ckan-dir']}; git log --name-only --format='format:' HEAD~5..HEAD`.split

files.each do |f|
	path = "#{settings['ckan-dir']}/#{f}"
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

# TODO handle mkdir
File.write(settings_file, JSON.pretty_generate(settings))
