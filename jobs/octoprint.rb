require 'rubygems'
require 'httparty'
require 'json'

SCHEDULER.every '1m', first_in: 0 do |job|
  file = File.read('printers.json')
  printer_list = JSON.parse(file)

  printer_list['printers'].each do |printer|
    name = printer['name']

    data = get_printer_data(printer['hostname'], printer['apiKey'])
    send_event(name, massaged_data(name, data))
  end
end


def get_printer_data(hostname, api_key)
  url = "http://#{hostname}/api/job?apikey=#{api_key}"

  response = HTTParty.get(url)

  response.parsed_response
end

def massaged_data(name, data)
  {
    printer_name: name,
    filename: data['job']['file']['name'],
    completion: data['progress']['completion'],
    print_time: data['progress']['printTime'],
    print_time_left: data['progress']['printTimeLeft'],
    state: data['state'],
  }
end


