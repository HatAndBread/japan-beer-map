require 'json'
require "awesome_print"
last_line = ""
relevant = false

data = []
complete_data = []


%w[beer.js beer2.js beer3.js].each do |filename|
  File.foreach(filename) do |line|
    first_line = false
    if line.match?(/html_attributions/) && last_line.match?(/_xdc_/)
      relevant = true
      first_line = true
    elsif line.match?(/status/) && line.match?(/OK/)
      relevant = false
      data[data.size - 1] = "}"
      data = eval(data.join)
      complete_data << data

      data = []
    end

    if relevant
      new_line = line.gsub("result: ", "")
      data << new_line unless first_line
    end

    last_line = line
  end
end

json = complete_data.to_json


File.write("data.json", json)
