define(['common/time/calendar_date', 'common/time/strftime'], function(CalendarDate, strftime) {
  var RelativeTime;
  RelativeTime = (function() {
    function RelativeTime(_at_date) {
      this.date = _at_date;
      this.calendarDate = CalendarDate.fromDate(this.date);
    }

    RelativeTime.prototype.toString = function() {
      var ago, day;
      if (ago = this.timeElapsed()) {
        return ago + " ago";
      } else if (day = this.relativeWeekday()) {
        return day + " at " + (this.formatTime());
      } else {
        return "on " + (this.formatDate());
      }
    };

    RelativeTime.prototype.toTimeOrDateString = function() {
      if (this.calendarDate.isToday()) {
        return this.formatTime();
      } else {
        return this.formatDate();
      }
    };

    RelativeTime.prototype.timeElapsed = function() {
      var hr, min, ms, sec;
      ms = new Date().getTime() - this.date.getTime();
      sec = Math.round(ms / 1000);
      min = Math.round(sec / 60);
      hr = Math.round(min / 60);
      if (ms < 0) {
        return null;
      } else if (sec < 10) {
        return "a second";
      } else if (sec < 45) {
        return sec + " seconds";
      } else if (sec < 90) {
        return "a minute";
      } else if (min < 45) {
        return min + " minutes";
      } else if (min < 90) {
        return "an hour";
      } else if (hr < 24) {
        return hr + " hours";
      } else {
        return null;
      }
    };

    RelativeTime.prototype.relativeWeekday = function() {
      var daysPassed;
      daysPassed = this.calendarDate.daysPassed();
      if (daysPassed > 6) {
        return null;
      } else if (daysPassed === 0) {
        return "today";
      } else if (daysPassed === 1) {
        return "yesterday";
      } else {
        return strftime(this.date, "%A");
      }
    };

    RelativeTime.prototype.formatDate = function() {
      var format;
      format = "%b %e";
      if (!this.calendarDate.occursThisYear()) {
        format += ", %Y";
      }
      return strftime(this.date, format);
    };

    RelativeTime.prototype.formatTime = function() {
      return strftime(this.date, '%l:%M%P');
    };

    return RelativeTime;

  })();
  return RelativeTime;
});
