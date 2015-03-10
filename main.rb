require 'json'

$main_info = {};

proj_list = Dir['/home/ethan/games/kerbal/CKAN-meta/*']

proj_list.each { |proj|
	versions = Dir["#{proj}/*.ckan"]
	versions.each { |v|
		puts "Reading #{v}"
		info = JSON.parse(File.read(v))
		$main_info[info['identifier']] = info['version']
	}
}

puts $main_info
