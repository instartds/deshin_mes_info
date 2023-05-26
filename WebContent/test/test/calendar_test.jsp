<%@page language="java" contentType="text/html; charset=utf-8"%>
<meta name="decorator" content="calendar_body"/>
<t:appConfig pgmId="cmd101skr"   >
	<t:ExtComboStore comboType="BOR120"  /> 
</t:appConfig>
<script type="text/javascript" >

function appMain() {
			// 달력에 표시할 데이타 Store
        	var eventStore = Ext.create('Extensible.store.DirectEventStore',{
        		proxy: {
					type: 'direct',
				    api: {
				        read: calendarService.read2
				    }		
				},
				/*
				 * 기본 내장 Data field
				    {name:    'id',        	mapping: 'id',        	type:    'String'}, //EventId
    				{name:    'calendarId',	mapping: 'calendarId',  type:    'String'},	//calendarId
    				{name:    'title',      mapping: 'title',       type:    'string'},	//Title
    				{name:    'startDate',  mapping: 'startDate',   type:    'date', dateFormat: 'Ymd' },//StartDate
    				{name:    'endDate',    mapping:    'endDate',  type:    'date',  dateFormat: 'Ymd'  },//EndDate
    			 */
				//추가 필드
				fields:[
					{name:'ref_code1', type:'string'}
				]
        	});
        	
        	//데이타 상태 표시 ( 전체 // 계획/ 진행 등)
        	var calendarStore = Ext.create('Extensible.store.DirectCalendarStore',{
	        	proxy : {
						type : 'direct',
						directFn : calendarService.readCalendars
					}
        	});
        	
            var cp =  {
            	xtype:'extensible.uniCalendarPanel',
            	id:'uniCalendarPanel01',
                eventStore: eventStore,
                calendarStore: calendarStore,
                viewConfig: {
                     enableFx: false,
                     showTime: true,
                     showEventEditorType:'link' , //(link:onEventEditor 호출/popup : uniPopupUrl 호출 /editor : 카렌더 기본 에디터)
                     onEventEditor: function(rec){
	                     var param = {
	            			'MAIN_CODE'		: rec.get('id'),
							'startData'		: rec.get('startData'),
							'endtData'		: rec.get('startData')
						
	            		};
	                    var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
						parent.openTab(rec1, '/base/bsa100ukrv.do', param);
                     }
                 },
                    
                 monthViewCfg: {
                     showHeader: true,
                     showWeekLinks: true,
                     showWeekNumbers: true
                 },
                    
                 multiWeekViewCfg: {

                 },
                 
                 readOnly: false,				//false 일 경우만 item 클릭 이벤트 발생 됨. 다른 페이지로 연계될 경우 false로 설정
                 showDayView: false,			// 달력 view 버튼 show/hide
                 //showMultiDayView: true,
                 //showWeekView: false,
                 //showMultiWeekView: false,
                 //showMonthView: false,
                 showNavJump:false,
                 showNavBar: true,
                 howTodayText: true,
                 showTime: false,
                 editModal: true,
                 enableEditDetails: false//,
            };
            
            var panelSearch = Unilite.createSearchForm('agb100rkrForm', {
				region: 'north',
				padding:'1 1 1 1',
				border:true,
				height:35,
		    	disabled :false,
		    	layout: {
			    	type: 'uniTable',
					columns:3
			    },
			    defaults:{
					labelWidth:90
			    },
				defaultType: 'uniTextfield',
				
				width:400,
				items : [{ 
					fieldLabel: '사업장',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					value : UserInfo.divCode,
					comboType: 'BOR120',
					listeners:{
						change:function(field, newValue, oldValue, eOpt) {
							var cpanel = Ext.getCmp("uniCalendarPanel01");
							cpanel.activeView.setExtParams({'DIV_CODE':field.getValue()});
						}
					}
				},{
					fieldLabel: '조회일',
					xtype: 'uniDatefield',
					name:'endDate',
					allowBlank:false,
					listeners:{
						blur:function(field, eOpt) {
							// 선택된 날짜가 달력이동 되기 위해 set
							var cpanel = Ext.getCmp("uniCalendarPanel01");
							cpanel.setStartDate(field.getValue());
						}
					}
			     },{
			     	xtype:'button',
			     	text:'조회',
			     	tdAttrs:{'width':100, 'align':'center'},
			     	handler:function()	{
			     		var o = {};
			     		cp.eventStore.load(o);
			     	}
			     }
				]
			});
	
            
            Ext.create('Ext.Viewport', {
				layout : 'border',
				title : '',
				items : [
					panelSearch ,
					{
						region:'center',
						flex:1,
						layout:{type:'fit'}, 
						items:[cp]
					}],
				renderTo : Ext.getBody()
			})
            
} 
	 function refresh() {
        	var cp = Ext.getCmp('uniCalendarPanel01');
        	cp._refresh();
        }
    </script>
    
     <div id="uni-legends" class="x-hide-display" style="border:none; background-color:transparent;">
       <!-- 데이타의 상태 표시를 위한 레전드 -->
    	<img src='<c:url value="/resources/css/icons/icon-cal-MP.png" />' /> <t:message code="extensible.cal.calType.MP" default="계획" />
    	<img src='<c:url value="/resources/css/icons/icon-cal-MR.png" />' /> <t:message code="extensible.cal.calType.MR" default="결과" />
    	<img src='<c:url value="/resources/css/icons/icon-cal-MPR.png" />' /> <t:message code="extensible.cal.calType.MPR" default="전체(계획+결과)" />
    </div>
    <div id="uni-filter" class="x-hide-display" style="border:none; background-color:transparent;">
    </div>