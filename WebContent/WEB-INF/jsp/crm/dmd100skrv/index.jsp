<%@page language="java" contentType="text/html; charset=utf-8"%>
<!doctype html> 
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Ext JS Calendar Sample</title>
	<link rel="stylesheet" type="text/css" href="resources/css/calendar.css" />
	<link rel="stylesheet" type="text/css" href="resources/css/examples.css" />
	<link rel="stylesheet" type="text/css" href='<c:url value="/extjs/resources/css/ext-all.css" />'>
	<script type="text/javascript" src='<c:url value="/extjs/ext-all-debug.js" />'></script>
	<script type="text/javascript" src='<c:url value="/app/Ext/lang/Date-ko.js" />'></script>
    <link rel="stylesheet" href="http://rasc.ch/extensible-1.5.2/resources/css/extensible-all.css">
    <script src="./extensible-all.js"></script>    
    <link rel="stylesheet" href="http://rasc.ch/extensible-1.5.2/resources/css/extensible-all.css">
	<script type="text/javascript" src='<c:url value="/api-debug.do" />'></script>   
     
    <script type="text/javascript">
        Ext.Loader.setConfig({
            enabled: true,
            paths: {
            	"Cal": "cal"
            }
        });

        Ext.onReady(function() {
        	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
        	
        	var M = Extensible.calendar.data.CalendarMappings;
        	M.Description.mapping = 'description';
        	Extensible.calendar.data.CalendarModel.reconfigure();
        	
        	M = Extensible.calendar.data.EventMappings;
        	M.EventId.name = 'id';
        	
        	M.CalendarId.name = 'calendarId';
        	M.CalendarId.mapping = 'calendarId';
        	
        	M.Title.name = 'title';

        	M.StartDate.name = 'startDate';
        	M.StartDate.mapping = 'startDate';
        	
        	M.EndDate.name = 'endDate';
        	M.EndDate.mapping = 'endDate';
        	
        	M.RRule.name = 'recurRule';
        	M.RRule.mapping = 'recurRule';
        	
        	M.Location.name = 'location';
        	M.Location.mapping = 'location';
        	
        	M.Notes.name = 'notes';
        	M.Url.name = 'url';
        	
        	M.IsAllDay.name = 'allDay';
        	M.IsAllDay.mapping = 'allDay';
        	
        	M.Reminder.name = 'reminder';
        	M.Reminder.mapping = 'reminder';                	
        	Extensible.calendar.data.EventModel.reconfigure();
        	
        	var eventStore = Ext.create('Cal.DirectEventStore');
        	var calendarStore = Ext.create('Cal.DirectCalendarStore');
        	
            Ext.create('Extensible.calendar.CalendarPanel', {
                eventStore: eventStore,
                calendarStore: calendarStore,
                renderTo: Ext.getBody(),
                title: 'Basic Calendar',
                width: 900,
                height: 600,
                // Any generic view options that should be applied to all sub views:
                    viewConfig: {
                        //enableFx: false,
                        //ddIncrement: 10, //only applies to DayView and subclasses, but convenient to put it here
                        //viewStartHour: 6,
                        //viewEndHour: 18,
                        //minEventDisplayMinutes: 15
                        showTime: false
                    },
                    
                    // View options specific to a certain view (if the same options exist in viewConfig
                    // they will be overridden by the view-specific config):
                    monthViewCfg: {
                        showHeader: true,
                        showWeekLinks: true,
                        showWeekNumbers: true
                    },
                    
                    multiWeekViewCfg: {
                        //weekCount: 3
                    },
                    // Some optional CalendarPanel configs to experiment with:
                    readOnly: false,
                    showDayView: false,
                    //showMultiDayView: true,
                    //showWeekView: false,
                    //showMultiWeekView: false,
                    //showMonthView: false,
                    //showNavBar: false,
                    //showTodayText: false,
                    //showTime: false,
                    //editModal: true,
                    enableEditDetails: true,
            });
        });
    </script>
</head>
<body>
    
</body>
</html>