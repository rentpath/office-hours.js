define [
  'office-hours/common/time/calendar_date'
  'office-hours/common/time/strftime'
], (
  CalendarDate
  strftime
) ->

  # This code comes from https://github.com/basecamp/local_time/blob/master/app/assets/javascripts/local_time.js.coffee
  class RelativeTime
    constructor: (@date) ->
      @calendarDate = CalendarDate.fromDate @date

    toString: ->
      # Today: "Saved 5 hours ago"
      if ago = @timeElapsed()
        "#{ago} ago"

      # Yesterday: "Saved yesterday at 8:15am"
      # This week: "Saved Thursday at 8:15am"
      else if day = @relativeWeekday()
        "#{day} at #{@formatTime()}"

      # Older: "Saved on Dec 15"
      else
        "on #{@formatDate()}"

    toTimeOrDateString: ->
      if @calendarDate.isToday()
        @formatTime()
      else
        @formatDate()

    timeElapsed: ->
      ms  = new Date().getTime() - @date.getTime()
      sec = Math.round ms  / 1000
      min = Math.round sec / 60
      hr  = Math.round min / 60

      if ms < 0
        null
      else if sec < 10
        "a second"
      else if sec < 45
        "#{sec} seconds"
      else if sec < 90
        "a minute"
      else if min < 45
        "#{min} minutes"
      else if min < 90
        "an hour"
      else if hr < 24
        "#{hr} hours"
      else
        null

    relativeWeekday: ->
      daysPassed = @calendarDate.daysPassed()

      if daysPassed > 6
        null
      else if daysPassed is 0
        "today"
      else if daysPassed is 1
        "yesterday"
      else
        strftime @date, "%A"

    formatDate: ->
      format = "%b %e"
      format += ", %Y" unless @calendarDate.occursThisYear()
      strftime @date, format

    formatTime: ->
      strftime @date, '%l:%M%P'

  RelativeTime
