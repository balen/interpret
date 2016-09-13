desc 'Setup initial files for the app'
task :setup do
  dir = "#{File.dirname(__FILE__)}/../../config/"
  stubs = Dir[dir + '*_example.yml']

  stubs.each do |file|
    file =~ /(\w*)_example/
    new_file = "#{dir}#{Regexp.last_match(1)}.yml"
    unless File.file?(new_file)
      `cp #{dir}#{File.basename(file)} #{new_file}`
      puts "Created file #{Regexp.last_match(1)}.yml"
    end
  end

  `mkdir -p log`
  `touch log/interpret.log`
end
