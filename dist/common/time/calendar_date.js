define([], function() {
  var CalendarDate;
  CalendarDate = (function() {
    CalendarDate.fromDate = function(date) {
      return new this(date.getFullYear(), date.getMonth() + 1, date.getDate());
    };

    CalendarDate.today = function() {
      return this.fromDate(new Date);
    };

    function CalendarDate(year, month, day) {
      this.date = new Date(Date.UTC(year, month - 1));
      this.date.setUTCDate(day);
      this.year = this.date.getUTCFullYear();
      this.month = this.date.getUTCMonth() + 1;
      this.day = this.date.getUTCDate();
      this.value = this.date.getTime();
    }

    CalendarDate.prototype.equals = function(calendarDate) {
      return (calendarDate != null ? calendarDate.value : void 0) === this.value;
    };

    CalendarDate.prototype.is = function(calendarDate) {
      return this.equals(calendarDate);
    };

    CalendarDate.prototype.isToday = function() {
      return this.is(this.constructor.today());
    };

    CalendarDate.prototype.occursOnSameYearAs = function(date) {
      return this.year === (date != null ? date.year : void 0);
    };

    CalendarDate.prototype.occursThisYear = function() {
      return this.occursOnSameYearAs(this.constructor.today());
    };

    CalendarDate.prototype.daysSince = function(date) {
      if (date) {
        return (this.date - date.date) / (1000 * 60 * 60 * 24);
      }
    };

    CalendarDate.prototype.daysPassed = function() {
      return this.constructor.today().daysSince(this);
    };

    return CalendarDate;

  })();
  return CalendarDate;
});
