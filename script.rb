require "json"

query = ARGV[0]

def all
	content = `/usr/local/bin/docker ps -a --format '{{.ID}}|{{.Names}}|{{.Status}}'`
	content = content.split "\n"
	content.map! do |node|
		splited = node.split '|'
		if splited[2][0..5] == 'Exited'
			splited[2] = 'Exited'
			splited[3] = 9
		else
			splited[3] = 1
		end
		splited
	end

	content.sort { |a, b| a[3] <=> b[3]  }
end

def find_from_name(query)
	a = all
	a.select { |node| node[1].include? query }
end


if query == ''
	content = all
else
	content = find_from_name(query)
end

result = {items: []}
content.each do |node|
	command = node[2] == "Exited" ? 'start' : 'stop'
	data = {
		uid: node[0],
		type: "default",
		title: node[1],
		subtitle: node[2],
		arg: "#{node[1]}|#{command}",
		autocomplete: node[1],
		icon: {
            path: command == "start" ? "./icons/stop.png" : "./icons/ok.png"
        }
	}
	result[:items] << data
end

print result.to_json

=begin
{"items": [
    {
        "uid": "desktop",
        "type": "file",
        "title": "Desktop",
        "subtitle": "~/Desktop",
        "arg": "~/Desktop",
        "autocomplete": "Desktop",
        "icon": {
            "type": "fileicon",
            "path": "~/Desktop"
        }
    }
]}
=end



#`/usr/local/bin/docker ps -a --format "{{.ID}}|{{.Names}}"`