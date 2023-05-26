//@charset UTF-8

/*
 * Format      Description                                                               Example returned values
------      -----------------------------------------------------------------------   -----------------------
  d         Day of the month, 2 digits with leading zeros                             01 to 31
  D         A short textual representation of the day of the week                     Mon to Sun
  j         Day of the month without leading zeros                                    1 to 31
  l         A full textual representation of the day of the week                      Sunday to Saturday
  N         ISO-8601 numeric representation of the day of the week                    1 (for Monday) through 7 (for Sunday)
  S         English ordinal suffix for the day of the month, 2 characters             st, nd, rd or th. Works well with j
  w         Numeric representation of the day of the week                             0 (for Sunday) to 6 (for Saturday)
  z         The day of the year (starting from 0)                                     0 to 364 (365 in leap years)
  W         ISO-8601 week number of year, weeks starting on Monday                    01 to 53
  F         A full textual representation of a month, such as January or March        January to December
  m         Numeric representation of a month, with leading zeros                     01 to 12
  M         A short textual representation of a month                                 Jan to Dec
  n         Numeric representation of a month, without leading zeros                  1 to 12
  t         Number of days in the given month                                         28 to 31
  L         Whether it's a leap year                                                  1 if it is a leap year, 0 otherwise.
  o         ISO-8601 year number (identical to (Y), but if the ISO week number (W)    Examples: 1998 or 2004
            belongs to the previous or next year, that year is used instead)
  Y         A full numeric representation of a year, 4 digits                         Examples: 1999 or 2003
  y         A two digit representation of a year                                      Examples: 99 or 03
  a         Lowercase Ante meridiem and Post meridiem                                 am or pm
  A         Uppercase Ante meridiem and Post meridiem                                 AM or PM
  g         12-hour format of an hour without leading zeros                           1 to 12
  G         24-hour format of an hour without leading zeros                           0 to 23
  h         12-hour format of an hour with leading zeros                              01 to 12
  H         24-hour format of an hour with leading zeros                              00 to 23
  i         Minutes, with leading zeros                                               00 to 59
  s         Seconds, with leading zeros                                               00 to 59
  u         Decimal fraction of a second                                              Examples:
            (minimum 1 digit, arbitrary number of digits allowed)                     001 (i.e. 0.001s) or
                                                                                      100 (i.e. 0.100s) or
                                                                                      999 (i.e. 0.999s) or
                                                                                      999876543210 (i.e. 0.999876543210s)
  O         Difference to Greenwich time (GMT) in hours and minutes                   Example: +1030
  P         Difference to Greenwich time (GMT) with colon between hours and minutes   Example: -08:00
  T         Timezone abbreviation of the machine running the code                     Examples: EST, MDT, PDT ...
  Z         Timezone offset in seconds (negative if west of UTC, positive if east)    -43200 to 50400
  c         ISO 8601 date
            Notes:                                                                    Examples:
            1) If unspecified, the month / day defaults to the current month / day,   1991 or
               the time defaults to midnight, while the timezone defaults to the      1992-10 or
               browser's timezone. If a time is specified, it must include both hours 1993-09-20 or
               and minutes. The "T" delimiter, seconds, milliseconds and timezone     1994-08-19T16:20+01:00 or
               are optional.                                                          1995-07-18T17:21:28-02:00 or
            2) The decimal fraction of a second, if specified, must contain at        1996-06-17T18:22:29.98765+03:00 or
               least 1 digit (there is no limit to the maximum number                 1997-05-16T19:23:30,12345-0400 or
               of digits allowed), and may be delimited by either a '.' or a ','      1998-04-15T20:24:31.2468Z or
            Refer to the examples on the right for the various levels of              1999-03-14T20:24:32Z or
            date-time granularity which are supported, or see                         2000-02-13T21:25:33
            http://www.w3.org/TR/NOTE-datetime for more info.                         2001-01-12 22:26:34
  U         Seconds since the Unix Epoch (January 1 1970 00:00:00 GMT)                1193432466 or -2138434463
  MS        Microsoft AJAX serialized dates                                           \/Date(1238606590509)\/ (i.e. UTC milliseconds since epoch) or
                                                                                      \/Date(1238606590509+0800)\/
  time      A javascript millisecond timestamp                                        1350024476440
  timestamp A UNIX timestamp (same as U)                                              1350024866     
 * 
 */
/**
 * Some function from Extensible class
 */


Ext.define('Unilite.UniDate', {
    alternateClassName: 'UniDate',
    requires: [
    	'Unilite',
    	'Ext.Date'
	],
    
    singleton: true,
    dbDateFormat : Unilite.dbDateFormat,
    altFormats : Unilite.altFormats,
    mommentDBformat : "YYYYMMDD",    
    format : Unilite.dateFormat,
    /**
     * 
     * @param {} dt
     * @return {}
     */
	getDateStr: function (dt) {
		return Ext.Date.format(dt, 'Ymd');
	},
	getMonthStr: function (dt) {
		return Ext.Date.format(dt, 'Ym');
	},
	getHHMI: function (dt) {
		return Ext.Date.format(dt, 'Hi');
	},
	getDbDateStr: function (dt) {
        return Ext.isDate(dt) ? Ext.Date.format(dt, Unilite.dbDateFormat) : dt;
	},
    safeFormat : function(value) {
    	var me = this;
    	/*
    	if(!me.altFormatsArray) {
    		me.altFormatsArray =  me.altFormats.split('|');
    	}
    	if(value) {
    		return moment(value, me.altFormatsArray ).format(me.dateFormat);
    	} else {
    		return value;
    	}*/
    	
    	return me.extFormatDate(me.extParseDate(value));  //  formatDate
    },
    extParseDate : function(value) {
        if(!value || Ext.isDate(value)){
            return value;
        }
		if(Ext.isString(value)) value =value.replace(/[.]/g, '');
        var me = this,
            val = me.extSafeParse(value, Unilite.dateFormat),
            altFormats = Unilite.altFormats,
            altFormatsArray = me.altFormatsArray,
            i = 0,
            len;

        if (!val && altFormats) {
            altFormatsArray = altFormatsArray || altFormats.split('|');
            len = altFormatsArray.length;
            for (; i < len && !val; ++i) {
                val = me.extSafeParse(value, altFormatsArray[i]);
            }
        }
        return val;
    },
    extSafeParse : function(value, format) {
        var me = this,
            utilDate = Ext.Date,
            result = null,
            strict = undefined,
            parsedDate;

        if (utilDate.formatContainsHourInfo(format)) {
            // if parse format contains hour information, no DST adjustment is necessary
            result = utilDate.parse(value, format, strict);
        } else {
            // set time to 12 noon, then clear the time
            parsedDate = utilDate.parse(value + ' ' + '12', format + ' ' + 'H', strict);
            if (parsedDate) {
                result = utilDate.clearTime(parsedDate);
            }
        }
        return result;
    },   
    
    
    // private
    extFormatDate : function(date){
        return Ext.isDate(date) ? Ext.Date.format(date, Unilite.dateFormat) : date;
    },
    extFormatMonth : function(date){
        return Ext.isDate(date) ? Ext.Date.format(date, Unilite.monthFormat) : date;
    },
    /**
     * 
     * @param {} type
     * @param {} basisDate (날자 문자열 또는 Date, moment)
     * @return {}
     */
	get:function(type, basisDate) {
		var rv = "";
		var dt = null;
		if(basisDate) {
			if(moment.isMoment(basisDate)) {
				dt = basisDate;
			} else {
			 	dt =moment(this.extParseDate(basisDate));
			}
		} else {
			dt = moment();
		}
		var format = this.mommentDBformat;
		 if(type == 'today'){
		 	rv = dt.format(format);
		 }else if(type == 'yesterday'){
		 	rv = dt.add('day',-1).format(format);
		 }else if(type == 'tomorrow'){
		 	rv = dt.add('day',1).format(format);
		 }else if(type == 'nextWeek'){
		 	rv = dt.add('day',7).format(format);
		 }else if(type == 'todayOfLastWeek'){
		 	rv = dt.add('week',-1).format(format);
		 }else if(type == 'mondayOfWeek'){						/* 현재 날짜의 월요일 */
		 	rv = dt.startOf("week").add('day',1).format(format);
	 	 }else if(type == 'sundayOfNextWeek'){					/* 현재 날짜 이후에 오는 일요일 */
	 		rv = dt.startOf("week").add('day',7).format(format);
		 }else if(type == 'startOfWeek'){
		 	rv = dt.startOf("week").format(format);
		 }else if(type == 'endOfWeek'){
		 	rv = dt.endOf("week").format(format);
		 }else if(type == 'startOfNextWeek'){
		 	rv = dt.add('week',1).startOf("week").format(format);
		 }else if(type == 'startOfMonth'){
		 	rv = dt.startOf("month").format(format);
		 }else if(type == 'endOfMonth'){
		 	rv = dt.endOf("month").format(format);
		 }else if(type == 'startOfLastMonth'){
		 	rv = dt.add('month',-1).startOf("month").format(format);
		 }else if(type == 'startOfNextMonth'){
		 	rv = dt.add('month',1).startOf("month").format(format);
		 }else if(type == 'endOfLastMonth'){
		 	rv = dt.add('month',-1).endOf("month").format(format);
		 }else if(type == 'endOfMonth'){
		 	rv = dtendOf('month').format(format);
		 }else if(type == 'endOfYear'){
		 	rv = dt.endOf('year').format(format);
		 }else if(type == 'todayForMonth'){
		 	rv = dt.add('month',1).format(format);
		 }else if(type == 'startOfLastYear'){
		 	rv = dt.add('year',-1).startOf("year").format(format);
		 }else if(type == 'endOfLastYear'){
		 	rv = dt.add('year',-1).endOf('year').format(format);
		 }else if(type == 'startOfYear'){
		 	//rv = Ext.Date.format(new Date(), 'Y') + "0101";
		 	rv = dt.startOf("year").format(format);
		 }else if(type == 'endOfYear'){
		 	rv = dt.endOf('year').format(format);
		 }else if(type == 'aMonthAgo'){
            rv = dt.add('month',-1).format(format);
		 }else if(type == 'twoMonthsAgo'){
            rv = dt.add('month',-2).format(format);
         }else if(type == 'threeMonthsAgo'){
            rv = dt.add('month',-3).format(format);
         }else if(type == 'fourMonthsAgo'){
            rv = dt.add('month',-4).format(format);
         }else if(type == 'fiveMonthsAgo'){
            rv = dt.add('month',-5).format(format);
         }else if(type == 'sixMonthsAgo'){
            rv = dt.add('month',-6).format(format);
         }else if(type == 'twoWeeksLater'){
            rv = dt.add('week', 2).format(format);
         }
		 
		 console.log(type + ":" + rv + "," + Unilite.dbDateFormat);
		 return rv;
	},
	getC: function(m) {
		var format = this.mommentDBformat;
		return m.format(format);
	},
	/**
     * Returns the time duration between two dates in the specified units. For finding the number of
     * calendar days (ignoring time) between two dates use {@link Extensible.Date.diffDays diffDays} instead.
     * @param {Date} start The start date
     * @param {Date} end The end date
     * @param {String} unit (optional) The time unit to return. Valid values are 'ms' (milliseconds,
     * the default), 's' (seconds), 'm' (minutes) or 'h' (hours).
     * @return {Number} The time difference between the dates in the units specified by the unit param
     */
    diff : function(start, end, unit){
        var denom = 1,
            diff = end.getTime() - start.getTime();
        
        if(unit == 's'){ 
            denom = 1000;
        }
        else if(unit == 'm'){
            denom = 1000*60;
        }
        else if(unit == 'h'){
            denom = 1000*60*60;
        }
        return Math.round(diff/denom);
    },
    
    /**
     * Calculates the number of calendar days between two dates, ignoring time values. 
     * A time span that starts at 11pm (23:00) on Monday and ends at 1am (01:00) on Wednesday is 
     * only 26 total hours, but it spans 3 calendar days, so this function would return 3. For the
     * exact time difference, use {@link Extensible.Date.diff diff} instead.
     * @param {Date} start The start date
     * @param {Date} end The end date
     * @return {Number} The number of calendar days difference between the dates
     */
    diffDays : function(start, end){
        var day = 1000*60*60*24,
            clear = Ext.Date.clearTime,
            diff = clear(end, true).getTime() - clear(start, true).getTime();
        
        return Math.ceil(diff/day);
    },
    
    /**
     * Copies the time value from one date object into another without altering the target's 
     * date value. This function returns a new Date instance without modifying either original value.
     * @param {Date} fromDt The original date from which to copy the time
     * @param {Date} toDt The target date to copy the time to
     * @return {Date} The new date/time value
     */
    copyTime : function(fromDt, toDt){
        var dt = Ext.Date.clone(toDt);
        dt.setHours(
            fromDt.getHours(),
            fromDt.getMinutes(),
            fromDt.getSeconds(),
            fromDt.getMilliseconds());
        
        return dt;
    },
    
    /**
     * Compares two dates and returns a value indicating how they relate to each other.
     * @param {Date} dt1 The first date
     * @param {Date} dt2 The second date
     * @param {Boolean} precise (optional) If true, the milliseconds component is included in the comparison,
     * else it is ignored (the default).
     * @return {Number} The number of milliseconds difference between the two dates. If the dates are equal
     * this will be 0.  If the first date is earlier the return value will be positive, and if the second date
     * is earlier the value will be negative.
     */
    compare : function(dt1, dt2, precise){
        var d1 = dt1, d2 = dt2;
        if(precise !== true){
            d1 = Ext.Date.clone(dt1);
            d1.setMilliseconds(0);
            d2 = Ext.Date.clone(dt2);
            d2.setMilliseconds(0);
        }
        return d2.getTime() - d1.getTime();
    },

    // private helper fn
    maxOrMin : function(max){
        var dt = (max ? 0 : Number.MAX_VALUE), i = 0, args = arguments[1], ln = args.length;
        for(; i < ln; i++){
            dt = Math[max ? 'max' : 'min'](dt, args[i].getTime());
        }
        return new Date(dt);
    },
    
    /**
     * Returns the maximum date value passed into the function. Any number of date 
     * objects can be passed as separate params.
     * @param {Date} dt1 The first date
     * @param {Date} dt2 The second date
     * @param {Date} dtN (optional) The Nth date, etc.
     * @return {Date} A new date instance with the latest date value that was passed to the function
     */
	max : function(){
        return this.maxOrMin.apply(this, [true, arguments]);
    },
    
    /**
     * Returns the minimum date value passed into the function. Any number of date 
     * objects can be passed as separate params.
     * @param {Date} dt1 The first date
     * @param {Date} dt2 The second date
     * @param {Date} dtN (optional) The Nth date, etc.
     * @return {Date} A new date instance with the earliest date value that was passed to the function
     */
	min : function(){
        return this.maxOrMin.apply(this, [false, arguments]);
    },
    
    isInRange : function(dt, rangeStart, rangeEnd) {
        return  (dt >= rangeStart && dt <= rangeEnd);
    },
    
    /**
     * Returns true if two date ranges overlap (either one starts or ends within the other, or one completely
     * overlaps the start and end of the other), else false if they do not.
     * @param {Date} start1 The start date of range 1
     * @param {Date} end1   The end date of range 1
     * @param {Date} start2 The start date of range 2
     * @param {Date} end2   The end date of range 2
     * @return {boolean} True if the ranges overlap, else false
     */
    rangesOverlap : function(start1, end1, start2, end2){
        var startsInRange = (start1 >= start2 && start1 <= end2),
            endsInRange = (end1 >= start2 && end1 <= end2),
            spansRange = (start1 <= start2 && end1 >= end2);
        
        return (startsInRange || endsInRange || spansRange);
    },
    
    /**
     * Returns true if the specified date is a Saturday or Sunday, else false.
     * @param {Date} dt The date to test
     * @return {Boolean} True if the date is a weekend day, else false 
     */
    isWeekend : function(dt){
        return dt.getDay() % 6 === 0;
    },
    
    /**
     * Returns true if the specified date falls on a Monday through Friday, else false.
     * @param {Date} dt The date to test
     * @return {Boolean} True if the date is a week day, else false 
     */
    isWeekday : function(dt){
        return dt.getDay() % 6 !== 0;
    },
    
    /**
     * Returns true if the specified date's time component equals 00:00, ignoring
     * seconds and milliseconds.
     * @param {Object} dt The date to test
     * @return {Boolean} True if the time is midnight, else false
     */
    isMidnight : function(dt) {
        return dt.getHours() === 0 && dt.getMinutes() === 0;
    },
    
    /**
     * Returns true if the specified date is the current browser-local date, else false.
     * @param {Object} dt The date to test
     * @return {Boolean} True if the date is today, else false
     */
    isToday : function(dt) {
        return this.diffDays(dt, this.today()) === 0;
    },
    
    /**
     * Convenience method to get the current browser-local date with no time value.
     * @return {Date} The current date, with time 00:00
     */
    today : function() {
        return Ext.Date.clearTime(new Date());
    },
    
    /**
     * Add time to the specified date and returns a new Date instance as the result (does not
     * alter the original date object). Time can be specified in any combination of milliseconds
     * to years, and the function automatically takes leap years and daylight savings into account.
     * Some syntax examples:<code><pre>
		var now = new Date();
		
		// Add 24 hours to the current date/time:
		var tomorrow = Extensible.Date.add(now, { days: 1 });
		
		// More complex, returning a date only with no time value:
		var futureDate = Extensible.Date.add(now, {
		    weeks: 1,
		    days: 5,
		    minutes: 30,
		    clearTime: true
		});
		</pre></code>
     * @param {Date} dt The starting date to which to add time
     * @param {Object} o A config object that can contain one or more of the following
     * properties, each with an integer value: <ul>
     * <li>millis</li>
     * <li>seconds</li>
     * <li>minutes</li>
     * <li>hours</li>
     * <li>days</li>
     * <li>weeks</li>
     * <li>months</li>
     * <li>years</li></ul>
     * You can also optionally include the property "clearTime: true" which will perform all of the
     * date addition first, then clear the time value of the final date before returning it.
     * @return {Date} A new date instance containing the resulting date/time value
     */
    add : function(dt, o) {
        if (!o) {
            return dt;
        }
        var ExtDate = Ext.Date,
            dateAdd = ExtDate.add,
            newDt = ExtDate.clone(dt);
        
        if (o.years) {
            newDt = dateAdd(newDt, ExtDate.YEAR, o.years);
        }
        if (o.months) {
            newDt = dateAdd(newDt, ExtDate.MONTH, o.months);
        }
        if (o.weeks) {
            o.days = (o.days || 0) + (o.weeks * 7);
        }
        if (o.days) {
            newDt = dateAdd(newDt, ExtDate.DAY, o.days);
        }
        if (o.hours) {
            newDt = dateAdd(newDt, ExtDate.HOUR, o.hours);
        }
        if (o.minutes) {
            newDt = dateAdd(newDt, ExtDate.MINUTE, o.minutes);
        }
        if (o.seconds) {
            newDt = dateAdd(newDt, ExtDate.SECOND, o.seconds);
        }
        if (o.millis) {
            newDt = dateAdd(newDt, ExtDate.MILLI, o.millis);
        }
         
        return o.clearTime ? ExtDate.clearTime(newDt) : newDt;
    }
});