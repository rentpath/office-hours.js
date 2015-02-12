define(['jquery', 'flight/lib/component', 'moment-timezone', 'strftime'], function($, defineComponent, Moment) {
  return defineComponent(function() {
    this._timezoneFullNameToAbbrev = function(timezoneId) {
      return Moment().tz(timezoneId).format('z');
    };
    this._calcUtcDiff = function(listingUtcOffsetInHours, browserUtcOffset) {
      var listingUtcOffset;
      listingUtcOffset = listingUtcOffsetInHours / 3600;
      return browserUtcOffset - listingUtcOffset;
    };
    this._calcFromHour = function(hour, listingUtcOffsetInHours, browserUtcOffset) {
      var isPM, localHour;
      localHour = parseInt(hour.split(':')[0], 10) + this._calcUtcDiff(listingUtcOffsetInHours, browserUtcOffset);
      isPM = hour.match(/PM$/);
      if (isPM) {
        return localHour += 12;
      } else {
        return localHour;
      }
    };
    this._officeClosed = function(openingHour, closingHour, localHour, listingUtcOffsetInHours, browserUtcOffset) {
      var localClosingHour, localOpeningHour;
      localOpeningHour = this._calcFromHour(openingHour, listingUtcOffsetInHours, browserUtcOffset);
      localClosingHour = this._calcFromHour(closingHour, listingUtcOffsetInHours, browserUtcOffset);
      return (localHour < localOpeningHour) || (localHour >= localClosingHour);
    };
    this._timezoneMessage = function(listingTimezoneId, browserTZ) {
      var listingTZ;
      listingTZ = this._timezoneFullNameToAbbrev(listingTimezoneId);
      if (browserTZ === listingTZ) {
        return '';
      } else {
        return " (" + listingTZ + ")";
      }
    };
    this._formatHour = function(hour) {
      return hour.replace(/0([1-9]):/, "$1" + ':').replace(/:00 ?/, '').toLowerCase();
    };
    this._officeOpenMessage = function(closingHour, suffix) {
      return "Office open until " + closingHour + " today" + suffix;
    };
    this._officeAvailabilityMessage = function() {
      var browser, closingHour, listingTimezone, messageSuffix, openingHour;
      closingHour = this.$node.attr('data-office-closing-hour');
      openingHour = this.$node.attr('data-office-opening-hour');
      listingTimezone = {
        offset: this.$node.attr('data-office-tz-offset'),
        timezoneId: this.$node.attr('data-office-tz')
      };
      browser = {
        hour: strftime('%H'),
        timezone: strftime('%z').slice(0, 3)
      };
      if ((closingHour === void 0) || (openingHour === 'N/A') || (closingHour === 'N/A')) {
        return '';
      } else if (listingTimezone.offset === '_MISSING_DATA_') {
        closingHour = this._formatHour(closingHour);
        return this._officeOpenMessage(closingHour, '');
      } else if (this._officeClosed(openingHour, closingHour, browser.hour, listingTimezone.offset, browser.timezone)) {
        return 'Office closed. Leave a message.';
      } else {
        messageSuffix = this._timezoneMessage(listingTimezone.timezoneId, strftime('%Z'));
        closingHour = this._formatHour(closingHour);
        return this._officeOpenMessage(closingHour, messageSuffix);
      }
    };
    this.showTimezone = function() {
      return this.$node.text(this._officeAvailabilityMessage());
    };
    return this.after('initialize', function() {
      return this.showTimezone();
    });
  });
});
