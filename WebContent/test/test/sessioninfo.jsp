<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
	request.setAttribute("sessinons", foren.framework.sessionpool.SessionPool.getSessinInfo());
%>
<html>
<head>
<META http-equiv="Pragma" content="no-cache" />z
<META HTTP-EQUIV="Expires" CONTENT="0" />
<META HTTP-EQUIV="Cache-Control" CONTENT="no-store" />
<META http-equiv="content-type" content="text/html; charset=UTF-8" />
<title>Session Information</title>
<SCRIPT type="text/javascript" src="/caisStatic/common/js/prototype.js"></script>
<script>
//enter refresh time in "minutes:seconds" Minutes should range from 0 to inifinity. 
// Seconds should range from 0 to 59
var limit="0:30"

if (document.images){
    var parselimit=limit.split(":")
    parselimit=parselimit[0]*60+parselimit[1]*1
}
function beginrefresh(){
    if (!document.images){
        return
    }
    if (parselimit==1) {
        window.location.reload()
    } else{ 
        parselimit-=1
        curmin=Math.floor(parselimit/60)
        cursec=parselimit%60
        if (curmin!=0) {
            curtime=curmin+" minutes and "+cursec+" seconds left until page refresh!"
        }else {
            curtime=cursec+" seconds left until page refresh!"
        }
        //window.status=curtime
        $("leftTime").update(curtime);
        setTimeout("beginrefresh()",1000)
    }
}

window.onload=beginrefresh
</script>

<script>
/*
 * Date Format 1.2.3 (http://blog.stevenlevithan.com/archives/date-time-format)
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */

var dateFormat = function () {
    var token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
        timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
        timezoneClip = /[^-+\dA-Z]/g,
        pad = function (val, len) {
            val = String(val);
            len = len || 2;
            while (val.length < len) val = "0" + val;
            return val;
        };

    // Regexes and supporting functions are cached through closure
    return function (date, mask, utc) {
        var dF = dateFormat;

        // You can't provide utc if you skip other args (use the "UTC:" mask prefix)
        if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
            mask = date;
            date = undefined;
        }

        // Passing date through Date applies Date.parse, if necessary
        date = date ? new Date(date) : new Date;
        if (isNaN(date)) throw SyntaxError("invalid date");

        mask = String(dF.masks[mask] || mask || dF.masks["default"]);

        // Allow setting the utc argument via the mask
        if (mask.slice(0, 4) == "UTC:") {
            mask = mask.slice(4);
            utc = true;
        }

        var _ = utc ? "getUTC" : "get",
            d = date[_ + "Date"](),
            D = date[_ + "Day"](),
            m = date[_ + "Month"](),
            y = date[_ + "FullYear"](),
            H = date[_ + "Hours"](),
            M = date[_ + "Minutes"](),
            s = date[_ + "Seconds"](),
            L = date[_ + "Milliseconds"](),
            o = utc ? 0 : date.getTimezoneOffset(),
            flags = {
                d:    d,
                dd:   pad(d),
                ddd:  dF.i18n.dayNames[D],
                dddd: dF.i18n.dayNames[D + 7],
                m:    m + 1,
                mm:   pad(m + 1),
                mmm:  dF.i18n.monthNames[m],
                mmmm: dF.i18n.monthNames[m + 12],
                yy:   String(y).slice(2),
                yyyy: y,
                h:    H % 12 || 12,
                hh:   pad(H % 12 || 12),
                H:    H,
                HH:   pad(H),
                M:    M,
                MM:   pad(M),
                s:    s,
                ss:   pad(s),
                l:    pad(L, 3),
                L:    pad(L > 99 ? Math.round(L / 10) : L),
                t:    H < 12 ? "a"  : "p",
                tt:   H < 12 ? "am" : "pm",
                T:    H < 12 ? "A"  : "P",
                TT:   H < 12 ? "AM" : "PM",
                Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
                o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
                S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
            };

        return mask.replace(token, function ($0) {
            return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
        });
    };
}();

// Some common format strings
dateFormat.masks = {
    "default":      "ddd mmm dd yyyy HH:MM:ss",
    shortDate:      "m/d/yy",
    mediumDate:     "mmm d, yyyy",
    longDate:       "mmmm d, yyyy",
    fullDate:       "dddd, mmmm d, yyyy",
    shortTime:      "h:MM TT",
    mediumTime:     "h:MM:ss TT",
    longTime:       "h:MM:ss TT Z",
    isoDate:        "yyyy-mm-dd",
    isoTime:        "HH:MM:ss",
    isoDateTime:    "yyyy-mm-dd'T'HH:MM:ss",
    isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
    dayNames: [
        "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ],
    monthNames: [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ]
};

// For convenience...
Date.prototype.format = function (mask, utc) {
    return dateFormat(this, mask, utc);
};
//-->
</script>

</head>
<body>
<table width="100%">
    <tr>
        <td align="left"><script language="JavaScript">
    var now = new Date();    
    document.write("Page Refreshed : " + now.format("mmmm dd,yyyy h:MM:ss TT Z") );
</script></td>
        <td align="right">
        <div id="leftTime"></div>
        </td>
        </tr>
</table>
<table width="100%" border="1" cellspacing="1" cellpadding="2">
    <tr>
        <th class="th">#</th>
        <th class="th">User Info</th>
        <th class="th">Login IP</th>
        <th class="th">SID</th>
    </tr>
    <c:set var="cnt_p" value="0" />
    <c:set var="cnt_s" value="0" />
    <c:set var="cnt_e" value="0" />

    <c:forEach var="s" items="${sessinons}" varStatus="status">
        <tr onMouseOver="tr_over(this)" onMouseOut="tr_out(this)">
            <th class="th" align="center">${status.count} / ${size}</th>
            <td class="td" align="center">${s.value.usn}</td>
            <td class="td" align="center">${s.value.key}</td>
            <td class="td" align="center">${s.value}</td>
        </tr>
    </c:forEach>

</table>
<br>
</body>
</html>