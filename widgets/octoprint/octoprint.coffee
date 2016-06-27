class Dashing.Octoprint extends Dashing.Widget
  onData: (data) ->
    # Set the style
    if(data.state == 'Printing')
      $(@node).css('background-color', '#47bbb3')
    else
      $(@node).css('background-color', '#ec663c')

  @accessor 'percentComplete', ->
    completion = @get('completion')

    if completion
      prettyPercentage = Math.round(completion, 2)
      "#{prettyPercentage}%"

  @accessor 'niceTime', ->
    t = @get('print_time')

    if t && @get('percentComplete') != "100%"
      theDate = new Date(t * 1000)

      zeroPaddedMinutes = ('00' + theDate.getUTCMinutes()).slice(-2);

      "Elapsed: #{theDate.getUTCHours()}:#{zeroPaddedMinutes}"
  @accessor 'niceTimeLeft', ->
    t = @get('print_time_left')

    if t && @get('percentComplete') != "100%"
      theDate = new Date(t * 1000)

      zeroPaddedMinutes = ('00' + theDate.getUTCMinutes()).slice(-2);

      "Remaining: #{theDate.getUTCHours()}:#{zeroPaddedMinutes}"

