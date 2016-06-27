require 'rubygems'
require 'google_calendar'

SCHEDULER.every '1m', first_in: 0 do |job|
  cal = Google::Calendar.new client_id: '41120792274-bocmk76thk9u4f1i8sld42uqash5od18.apps.googleusercontent.com',
    client_secret: 'deE9UU1MAGmWVlFD-mGXjU30',
    calendar: 'singularityu.org_e50qge7pe338nnpqj62k90v8f4@group.calendar.google.com',
    redirect_url: "urn:ietf:wg:oauth:2.0:oob"

  send_event('widget_id', { })
end
