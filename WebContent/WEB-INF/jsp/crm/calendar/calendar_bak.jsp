<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
    String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	
	boolean isDevelopServer = ConfigUtil.getBooleanValue("system.isDevelopServer", true);
	request.setAttribute("isDevelopServer", isDevelopServer);
    if(isDevelopServer) {
    	if(extjsVersion.equals("4.2.2")) {
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-dev.js");
    	}else{
    		request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all-debug.js");
    	}
    } else {
    	request.setAttribute("ext_url", "/extjs_"+extjsVersion+"/ext-all.js");
    }   
	
    request.setAttribute("css_url", "/extjs_"+extjsVersion+"/resources/ext-theme-classic-omega/ext-overrides.css");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
    request.setAttribute("ext_version", extjsVersion);
    	
%>
<!doctype html> 
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title><t:message code="extensible.cal.title" default="영업 현황 달력" /></title>
    

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
    <link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Extensible/resources/css/extensible-all_comp.css"/>' >
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_${ext_version}.css" />' />
    <script type="text/javascript">
	    var CPATH ='<%=request.getContextPath()%>';
	</script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/js/moment/moment-with-langs.min.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url}" />'></script> 
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-overrides.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-bug-overrides.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs/locale/ext-lang-${CUR_LANG}.js" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-${CUR_LANG}.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-${CUR_LANG}.js" />'> </script>

    <script type="text/javascript">
    	var EXT_ROOT = '${ext_root}';
    	
	    Ext.Loader.setConfig({
			enabled : true,
			scriptCharset : 'UTF-8',
			paths: {
	                "Ext": '${CPATH }/${ext_root}/src',
	            	"Ext.ux": '${CPATH }/${ext_root}/app/Ext/ux',
	            	"Unilite": '${CPATH }/${ext_root}/app/Unilite',
	            	"Extensible": '${CPATH }/${ext_root}/app/Extensible'
	        }
		});
	    Ext.require('*');
	</script>

    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/unilite.full.js" />'></script>     
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>  
    <% // ?group=Popup,base,crm,cm,Cmd %>
<c:choose>
<c:when test="${isDevelopServer }">
	

	
	
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/Extensible.js" />' ></script>   
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/CalendarMappings.js" />'  ></script>  
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/EventMappings.js" />'  ></script>    
    
        
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/template/BoxLayout.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/template/DayHeader.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/template/DayBody.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/template/Month.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/CalendarScrollManager.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/StatusProxy.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/DragZone.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/DropZone.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/DayDragZone.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/dd/DayDropZone.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/EventModel.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/EventStore.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/data/CalendarModel.js" />'  ></script>
    
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/util/WeekEventRenderer.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/form/field/ReminderCombo.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/form/field/CalendarCombo.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/util/ColorPicker.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/gadget/CalendarListMenu.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/gadget/CalendarListPanel.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/menu/Event.js" />'  ></script>
    
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/AbstractCalendar.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/MonthDayDetail.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/Month.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/DayHeader.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/DayBody.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/Day.js" />'  ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/MultiDay.js" />'  ></script> 
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/Week.js" />'  ></script> 
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/view/MultiWeek.js" />'  ></script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar/CalendarPanel.js" />'  ></script> 
    
    
</c:when>
<c:otherwise>    

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Extensible/calendar.full.js" />'></script> 
</c:otherwise>
</c:choose>




    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/BaseJSPopupApp.js" />'></script> 
    

    
	<c:set var="localUrl" value="/${ext_root}/app/Extensible/calendar/locale/extensible-lang-${CUR_LANG}.js"/>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="${localUrl}" />'></script> 
     
    <script type="text/javascript">


        Ext.onReady(function() {	
        	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);   
            Ext.direct.Manager.on("exception", uniDirectExceptionProcessor);
        
        	Ext.define('Extensible.store.DirectCalendarStore', {
				extend : 'Ext.data.Store',
				model : 'Extensible.calendar.data.CalendarModel',
				autoLoad : true,
				proxy : {
					type : 'direct',
					directFn : calendarService.readCalendars
				}
			});
			
        	Ext.define('Extensible.store.DirectEventStore', {
			    extend: 'Ext.data.Store',
			    model: 'Extensible.calendar.data.EventModel',
			    deferLoad: true,
			    
			    proxy: {
					type: 'direct',
				    api: {
				        read: calendarService.read,
				        create: calendarService.create,
				        update: calendarService.updatePlan,
				        destroy: calendarService.destroy
				    }		
				}
			
			});
        
        
        	var eventStore = Ext.create('Extensible.store.DirectEventStore');
        	var calendarStore = Ext.create('Extensible.store.DirectCalendarStore');
        	
            var cp =  {
            	xtype:'extensible.calendarpanel',
            	id:'uniCalendarPanel01',
                eventStore: eventStore,
                calendarStore: calendarStore,
                viewConfig: {
                     enableFx: false,
                     //ddIncrement: 10, //only applies to DayView and subclasses, but convenient to put it here
                     //viewStartHour: 6,
                     //viewEndHour: 18,
                     //minEventDisplayMinutes: 15
                     showTime: true
                 },
                    
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
                 showNavJump:false,
                 showNavBar: true,
                 howTodayText: true,
                 showTime: false,
                 editModal: true,
                 enableEditDetails: false,
                 uniPopupUrl : '<c:url value="/cm/cmd100ukrv.do" />'   // AbstractCalendar.js, CalendarPanel.js
            };
            Ext.create('Ext.Viewport', {
				layout : {
					type : 'fit'
				},
				title : '영업활동',
				items : [ cp ],
				renderTo : Ext.getBody()
			})
        });
        
        function refresh() {
        	var cp = Ext.getCmp('uniCalendarPanel01');
        	cp._refresh();
        }
    </script>
</head>
<body>
    <div id="uni-legends" class="x-hide-display" style="border:none; background-color:transparent;">
    	<img src='<c:url value="/resources/css/icons/icon-cal-MP.png" />' /> <t:message code="extensible.cal.calType.MP" default="계획" />
    	<img src='<c:url value="/resources/css/icons/icon-cal-MR.png" />' /> <t:message code="extensible.cal.calType.MR" default="결과" />
    	<img src='<c:url value="/resources/css/icons/icon-cal-MPR.png" />' /> <t:message code="extensible.cal.calType.MPR" default="전체(계획+결과)" />
    </div>
    <div id="uni-filter" class="x-hide-display" style="border:none; background-color:transparent;">
   		
	    일정유형  
	    <label><input type="radio" id="QRY_TYPE" name="QRY_TYPE" value="A" checked="false"><t:message code="extensible.cal.filter.private" default="개인" /></label>
	    <label><input type="radio" id="QRY_TYPE" name="QRY_TYPE" value="B" checked="false"><t:message code="extensible.cal.filter.department" default="부서" /></label>
	    <label><input type="radio" id="QRY_TYPE" name="QRY_TYPE" value="C" checked="true"><t:message code="extensible.cal.filter.all" default="전사" /></label>
    </div>
    <form id="exportform" method="get" target="_blank">
        <input type="hidden" id="fid" name="fid" value="" />
        <input type="hidden" name="inline" value="N" />
</form>
</body>
</html>