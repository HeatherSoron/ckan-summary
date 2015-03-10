require 'json'

main_info = {};

proj_list = Dir['/home/ethan/games/kerbal/CKAN-meta/*']

# TODO once I can access docs, see if ruby would normally use a foreach here instead of a map
proj_list.map { |proj|
	versions = Dir["#{proj}/*.ckan"]
	versions.map { |v|
		puts "Reading #{v}"
		info = JSON.parse(File.read(v))
		main_info[info['identifier']] = info['version']
	}
}

puts main_info
