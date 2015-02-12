define [
], (
) ->

  # This code comes from https://github.com/basecamp/local_time/blob/master/app/assets/javascripts/local_time.js.coffee
  weekdays = "Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split " "
  months   = "January February March April May June July August September October November December".split " "

  pad = (num) -> ('0' + num).slice -2

  strftime = (time, formatString) ->
    day    = time.getDay()
    date   = time.getDate()
    month  = time.getMonth()
    year   = time.getFullYear()
    hour   = time.getHours()
    minute = time.getMinutes()
    second = time.getSeconds()

    formatString.replace /%([%aAbBcdeHIlmMpPSwyYZ])/g, ([match, modifier]) ->
      switch modifier
        when '%' then '%'
        when 'a' then weekdays[day].slice 0, 3
        when 'A' then weekdays[day]
        when 'b' then months[month].slice 0, 3
        when 'B' then months[month]
        when 'c' then time.toString()
        when 'd' then pad date
        when 'e' then date
        when 'H' then pad hour
        when 'I' then pad strftime time, '%l'
        when 'l' then (if hour is 0 or hour is 12 then 12 else (hour + 12) % 12)
        when 'm' then pad month + 1
        when 'M' then pad minute
        when 'p' then (if hour > 11 then 'PM' else 'AM')
        when 'P' then (if hour > 11 then 'pm' else 'am')
        when 'S' then pad second
        when 'w' then day
        when 'y' then pad year % 100
        when 'Y' then year
        when 'Z' then time.toString().match(/\((\w+)\)$/)?[1] ? ''

  strftime
