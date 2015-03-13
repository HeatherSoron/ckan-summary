require 'json'

# side note: coding in an unfamiliar language on the train (no wifi) is a REALLY interesting experience.
# I feel sorta like I'm back in the days when you'd learn a language with an actual book, or manpages, or something,
# as opposed to the modern approach of just googling trivial questions and ending up on StackOverflow.

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

if !settings['last-check'] then
	# default to unix epoch, explicitly. I'm PRETTY sure that'll predate all CKAN-meta commits by a good 40+ years.
	settings['last-check'] = 0
end

proj_list = Dir["#{settings['ckan-dir']}/*"]

# we'll be using this basic command twice with a few different args, let's just collect the start of it into a variable
git_log_preamble = "cd #{settings['ckan-dir']}; git log --since=\"$(date -d @#{settings['last-check']})\""

# sweet! "split" on a string handles blank lines in exactly the way I want :)
files = `#{git_log_preamble} --name-only --format='format:'`.split

last_date = `#{git_log_preamble} --format='%ct'`.split.max

# TODO filter out non-JSON files
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

puts "\nLast timestamp was #{last_date}. Do you want to save that as the starting point for future searches? (y/n)"
# there are probably better ways of handling a y/n prompt. Actually, maybe even a built-in library?
if readline == "y\n" then
	settings['last-check'] = last_date
end

# TODO handle mkdir
File.write(settings_file, JSON.pretty_generate(settings))
