define([], function() {
  var months, pad, strftime, weekdays;
  weekdays = "Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(" ");
  months = "January February March April May June July August September October November December".split(" ");
  pad = function(num) {
    return ('0' + num).slice(-2);
  };
  strftime = function(time, formatString) {
    var date, day, hour, minute, month, second, year;
    day = time.getDay();
    date = time.getDate();
    month = time.getMonth();
    year = time.getFullYear();
    hour = time.getHours();
    minute = time.getMinutes();
    second = time.getSeconds();
    return formatString.replace(/%([%aAbBcdeHIlmMpPSwyYZ])/g, function(_arg) {
      var match, modifier, _ref, _ref1;
      match = _arg[0], modifier = _arg[1];
      switch (modifier) {
        case '%':
          return '%';
        case 'a':
          return weekdays[day].slice(0, 3);
        case 'A':
          return weekdays[day];
        case 'b':
          return months[month].slice(0, 3);
        case 'B':
          return months[month];
        case 'c':
          return time.toString();
        case 'd':
          return pad(date);
        case 'e':
          return date;
        case 'H':
          return pad(hour);
        case 'I':
          return pad(strftime(time, '%l'));
        case 'l':
          if (hour === 0 || hour === 12) {
            return 12;
          } else {
            return (hour + 12) % 12;
          }
        case 'm':
          return pad(month + 1);
        case 'M':
          return pad(minute);
        case 'p':
          if (hour > 11) {
            return 'PM';
          } else {
            return 'AM';
          }
        case 'P':
          if (hour > 11) {
            return 'pm';
          } else {
            return 'am';
          }
        case 'S':
          return pad(second);
        case 'w':
          return day;
        case 'y':
          return pad(year % 100);
        case 'Y':
          return year;
        case 'Z':
          return (_ref = (_ref1 = time.toString().match(/\((\w+)\)$/)) != null ? _ref1[1] : void 0) != null ? _ref : '';
      }
    });
  };
  return strftime;
});
