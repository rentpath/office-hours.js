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

    @_timezoneFullNameToAbbrev = (timezoneId) ->
      Moment().tz(timezoneId).format('z')

    @_calcUtcDiff = (listingUtcOffsetInHours, browserUtcOffset) ->
      listingUtcOffset = listingUtcOffsetInHours / 3600
      browserUtcOffset - listingUtcOffset

    # Note: Handles whole hours (e.g. 9:00 - 5:00) and not partials (e.g. 9:30 - 5:30)
    @_calcFromHour = (hour, listingUtcOffsetInHours, browserUtcOffset) ->
      localHour = parseInt(hour.split(':')[0], 10) + @_calcUtcDiff(listingUtcOffsetInHours, browserUtcOffset)
      isPM = hour.match(/PM$/)

      if isPM
        localHour += 12
      else
        localHour

    @_officeClosed = (openingHour, closingHour, localHour, listingUtcOffsetInHours, browserUtcOffset) ->
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
      "Office open until #{closingHour} today#{suffix}"

    @_officeAvailabilityMessage = ->
      closingHour = @$node.attr('data-office-closing-hour')
      openingHour = @$node.attr('data-office-opening-hour')

      listingTimezone =
        offset:     @$node.attr('data-office-tz-offset')
        timezoneId: @$node.attr('data-office-tz')

      browser =
        hour:     strftime('%H')
        timezone: strftime('%z')[0..2]

      if (closingHour == undefined) or (openingHour == 'N/A') or (closingHour == 'N/A')
        ''

      else if listingTimezone.offset == '_MISSING_DATA_'
        closingHour = @_formatHour(closingHour)
        @_officeOpenMessage(closingHour, '')

      else if @_officeClosed(openingHour, closingHour, browser.hour, listingTimezone.offset, browser.timezone)
        'Office closed. Leave a message.'

      else
        messageSuffix = @_timezoneMessage(listingTimezone.timezoneId, strftime('%Z'))
        closingHour = @_formatHour(closingHour)
        @_officeOpenMessage(closingHour, messageSuffix)

    @showTimezone = ->
      @$node.text(@_officeAvailabilityMessage())

    @after 'initialize', ->
      @showTimezone()
