define ['jquery'], ($) ->

  describeComponent 'office-hours/components/ui/open_office_hours', ->
    describe 'initialize with defaultAttrs', ->
      beforeEach ->
        @setupComponent()

      describe '#_officeClosed', ->
        describe 'in the same timezone', ->
          it 'is not closed when browser time is within the local hour', ->
            result = @component._officeClosed('09:00AM', '05:00PM', '10', -(5 * 3600), -5)
            expect(result).toEqual(false)

          it 'is not closed when browser time exactly the opening hour', ->
            result = @component._officeClosed('09:00AM', '05:00PM', '09', -(5 * 3600), -5)
            expect(result).toEqual(false)

          it 'is closed when browser time is not within the local hour', ->
            result = @component._officeClosed('09:00AM', '05:00PM', '19', -(5 * 3600), -5)
            expect(result).toEqual(true)

          it 'is closed when browser time is exactly the closing hour', ->
            result = @component._officeClosed('09:00AM', '05:00PM', '17', -(5 * 3600), -5)
            expect(result).toEqual(true)

          it 'is not closed when browser time is within the local :30 hour', ->
            result = @component._officeClosed('09:00AM', '05:30PM', '17', -(5 * 3600), -5)
            expect(result).toEqual(false)

        describe 'not in the same timezone', ->
          it 'is not closed when browser time is within the local hour', ->
            result = @component._officeClosed('09:00AM', '05:00PM', '17', -(5 * 3600), -4)
            expect(result).toEqual(false)

          it 'is not closed when browser time is within the local :30 hour', ->
            result = @component._officeClosed('09:00AM', '05:30PM', '17', -(5 * 3600), -4)
            expect(result).toEqual(false)

          it 'is not closed when browser time exactly the opening hour', ->
            result = @component._officeClosed('09:00AM', '05:00PM', '10', -(5 * 3600), -4)
            expect(result).toEqual(false)

          it 'is closed when browser time is not within the local hour', ->
            result = @component._officeClosed('09:00AM', '05:00PM', '09', -(5 * 3600), -4)
            expect(result).toEqual(true)

          it 'is closed when browser time is exactly the closing hour', ->
            result = @component._officeClosed('09:00AM', '05:00PM', '18', -(5 * 3600), -4)
            expect(result).toEqual(true)

        describe 'without a space before AM/PM', ->
          it 'matches when it is not closed', ->
            withoutSpace = @component._officeClosed('09:00AM', '05:00PM', '10', -(5 * 3600), -5)
            withSpace = @component._officeClosed('09:00 AM', '05:00 PM', '10', -(5 * 3600), -5)

            expect(withoutSpace).toEqual(withSpace)

      describe '#_calcFromHour', ->
        it 'returns the hours in the AM', ->
          hour = @component._calcFromHour '09:00 AM', -(5 * 3600), -5
          expect(hour).toEqual 9

        it 'returns the hours in the PM', ->
          hour = @component._calcFromHour '05:00 PM', -(5 * 3600), -5
          expect(hour).toEqual 17

        it 'adds minutes as decimals', ->
          hour = @component._calcFromHour '05:30 PM', -(5 * 3600), -5
          expect(hour).toEqual 17.5

        it 'adds minutes as decimals in the AM', ->
          hour = @component._calcFromHour '08:30 AM', -(5 * 3600), -5
          expect(hour).toEqual 8.5

      describe '#_calcUtcDiff', ->
        it 'converts minutes and returns the diff', ->
          expect(@component._calcUtcDiff(-(5 * 3600), -4)).toEqual(1)

      describe '#_timezoneMessage', ->
        it 'is the listing time zone abbv when they are different', ->
          listingTimezoneId = 'America/Chicago'
          browserTZ = 'EDT'

          expect(@component._timezoneMessage(listingTimezoneId, browserTZ)).toMatch(/\ \(CDT|CST\)/)

        it 'is blank when they are the same', ->
          # For testing, use a non-DST timezone make this spec less flaky
          listingTimezoneId = 'America/Phoenix'
          browserTZ = 'MST'

          expect(@component._timezoneMessage(listingTimezoneId, browserTZ)).toEqual('')

      describe '#_timezoneFullNameToAbbrev', ->
        it 'converts an id to a DST aware abbreviation', ->
          expect(@component._timezoneFullNameToAbbrev('America/New_York')).toMatch(/EDT|EST/)

      # Integration tests -- variations of dst/times should be accounted for above
      describe "#showTimezone", ->
        beforeEach ->
          @fixture = readFixtures('open_office_hours.html')

        it "is empty when there is no office hour data", ->
          fixture = readFixtures('current_office_availability_without_data.html')
          @setupComponent(fixture)

          expect($('.current-office-availability').text()).toEqual('')

        it "returns the office hours message without timezone when the listing tz offset is missing", ->
          fixture = readFixtures('current_office_availability_without_tz_offset.html')
          @setupComponent(fixture)

          expect($('.current-office-availability').text()).toMatch(/^Office open until 6pm today$/)

        it "returns the message or closed (depending on when the specs are run)", ->
          @setupComponent(@fixture)
          expect($('.current-office-availability').text()).toMatch(/^Office open until|Office closed/)

        it "returns the office is closed message when closed hours are N/A", ->
          @setupComponent(@fixture.replace(/06:00PM/, "N/A"))
          expect($('.current-office-availability').text()).toEqual('')

        it "returns the office is closed message when open hours are N/A", ->
          @setupComponent(@fixture.replace(/09:00AM/, "N/A"))
          expect($('.current-office-availability').text()).toEqual('')

        it "returns an office closed message", ->
          fixture = readFixtures('closed_office_availability.html')
          @setupComponent(fixture)

          expect($('.current-office-availability').text()).toEqual('Office closed. Leave a message.')

    describe 'initialize with custom defaultAttrs', ->
      describe "#_officeOpenMessage", ->
        it "returns a custom office open message", ->
          fixture = readFixtures('current_office_availability_without_tz_offset.html')
          @setupComponent(fixture, { 'officeOpenMessageTemplate': 'Happy hour after {closingHour} today!!' })

          expect($('.current-office-availability').text()).toMatch(/^Happy hour after 6pm today!!$/)

        it "returns a custom office closed message", ->
          fixture = readFixtures('closed_office_availability.html')
          @setupComponent(fixture, { 'officeClosedMessageTemplate': 'Happy hour all day!!' })

          expect($('.current-office-availability').text()).toMatch(/^Happy hour all day!!$/)

