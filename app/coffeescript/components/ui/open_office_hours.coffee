define [
  'jquery',
  'flight/lib/component',
  'moment-timezone'
  'strftime'
], (
  $,
  defineComponent,
  Moment
) ->

  defineComponent ->

    @defaultAttrs
      timezoneSuffix: true
      officeOpenMessageTemplate: 'Office open until {closingHour} today'
      officeClosedMessageTemplate: 'Office closed. Leave a message.'

    @_timezoneFullNameToAbbrev = (timezoneId) ->
      Moment().tz(timezoneId).format('z')

    @_calcUtcDiff = (listingUtcOffsetInHours, browserUtcOffset) ->
      listingUtcOffset = listingUtcOffsetInHours / 3600
      browserUtcOffset - listingUtcOffset

    @_calcFromHour = (hourString, listingUtcOffsetInHours, browserUtcOffset) ->
      [hours, minutes] = hourString.split(':')
      localHour = parseInt(hours, 10) + @_calcUtcDiff(listingUtcOffsetInHours, browserUtcOffset)

      localHour += 12 if hourString.match(/PM$/)

      localMinute = parseInt(minutes, 10) or 0
      localHour += localMinute / 60

      localHour

    @_officeClosed = (openingHour, closingHour, localHour, localMinute, listingUtcOffsetInHours, browserUtcOffset) ->
      localHour = parseInt(localHour, 10) + (parseInt(localMinute, 10) / 60)

      localOpeningHour = @_calcFromHour(openingHour, listingUtcOffsetInHours, browserUtcOffset)
      localClosingHour = @_calcFromHour(closingHour, listingUtcOffsetInHours, browserUtcOffset)

      (localHour < localOpeningHour) or (localHour >= localClosingHour)

    @_timezoneMessage = (listingTimezoneId, browserTZ) ->
      return '' unless @attr.timezoneSuffix
      listingTZ = @_timezoneFullNameToAbbrev(listingTimezoneId)

      if (browserTZ == listingTZ)
        ''
      else
        " (#{listingTZ})"

    # EG(05:00PM -> 5pm, 05:30PM -> 5:30pm, 05:00 PM -> 5pm)
    @_formatHour = (hour) ->
      hour.replace(/0([1-9]):/,"$1" + ':').replace(/:00 ?/,'').toLowerCase()

    @_officeOpenMessage = (closingHour, suffix) ->
      "#{@attr.officeOpenMessageTemplate.replace(/{closingHour}/, closingHour)}#{suffix}"

    @_officeAvailabilityMessage = ->
      closingHour = @$node.attr('data-office-closing-hour')
      openingHour = @$node.attr('data-office-opening-hour')

      listingTimezone =
        offset:     @$node.attr('data-office-tz-offset')
        timezoneId: @$node.attr('data-office-tz')

      browser =
        hour:     strftime('%H')
        minute:   strftime('%M')
        timezone: strftime('%z')[0..2]

      if (closingHour == undefined) or (openingHour == 'N/A') or (closingHour == 'N/A')
        ''

      else if listingTimezone.offset == '_MISSING_DATA_'
        closingHour = @_formatHour(closingHour)
        @_officeOpenMessage(closingHour, '')

      else if @_officeClosed(openingHour, closingHour, browser.hour, browser.minute, listingTimezone.offset, browser.timezone)
        @attr.officeClosedMessageTemplate

      else
        messageSuffix = @_timezoneMessage(listingTimezone.timezoneId, strftime('%Z'))
        closingHour = @_formatHour(closingHour)
        @_officeOpenMessage(closingHour, messageSuffix)

    @showTimezone = ->
      @$node.text(@_officeAvailabilityMessage())

    @after 'initialize', ->
      @showTimezone()
