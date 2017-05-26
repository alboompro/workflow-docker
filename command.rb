query = ARGV[0]

name, action = query.split '|'
msg = ''

action = ARGV[1] if ARGV[1]

if action == 'start'
	`/usr/local/bin/docker start #{name}`
	msg = 'Started'
end

if %w(stop remove).include? action
	`/usr/local/bin/docker stop #{name}`
	msg = 'Stopped'
end

if action == 'restart'
	`/usr/local/bin/docker restart #{name}`
	msg = 'Restarted'
end

if action == 'remove'
	`/usr/local/bin/docker rm #{name}`
	msg = 'Removed'
end

print "#{msg}! #{name}"