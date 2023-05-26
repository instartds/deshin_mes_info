<%@page language="java" contentType="text/html; charset=utf-8"%>
<meta name="decorator" content="calendar_body"/>
<t:appConfig pgmId="abh010ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 													<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B011" /> <!-- 집계항목-->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

function appMain() {
    var createCalendarWindow;       //달력생성 윈도우
    var inputWindow;                //휴/평일 및 비고 입력할 윈도우

	
//	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
//		api: {
//			read	: 'abh010ukrService.selectList'//,
//			update	: 'abh010ukrService.updateDetail',
//			create	: 'abh010ukrService.insertDetail',
//			destroy	: 'abh010ukrService.deleteDetail',
//			syncAll	: 'abh010ukrService.saveAll'
//		}
//	});	

	// 달력에 표시할 데이타 Store
	var eventStore = Ext.create('Extensible.store.DirectEventStore',{
		proxy	: {
			type	: 'direct',
		    api		: {
		        read: abh010ukrService.read
		    }		
		},/*,
		
		 * 기본 내장 Data field
		    {name: 'id'				, mapping: 'id'				, type: 'String'},							//EventId
			{name: 'calendarId'		, mapping: 'calendarId'		, type: 'String'},							//calendarId
			{name: 'title'			, mapping: 'title'			, type: 'string'},							//Title
			{name: 'startDate'		, mapping: 'startDate'		, type: 'date'		, dateFormat: 'Ymd'},	//StartDate
			{name: 'endDate'		, mapping: 'endDate'		, type: 'date'		, dateFormat: 'Ymd'},	//EndDate
		*/
		 
		//추가 필드
		fields	: [
			{name: 'DIV_CODE'		, mapping: 'DIV_CODE'		, type: 'string'},
			{name: 'HOLY_TYPE'		, mapping: 'HOLY_TYPE'		, type: 'string'}
		]
	});
	
	//데이타 상태 표시 ( 전체 // 계획/ 진행 등)
	var calendarStore = Ext.create('Extensible.store.DirectCalendarStore',{
    	proxy : {
			type	: 'direct',
			directFn: abh010ukrService.readCalendars
		}
	});
	
    var cp =  {
    	xtype			: 'extensible.uniCalendarPanel',
    	id				: 'uniCalendarPanel01',
        eventStore		: eventStore,
        calendarStore	: calendarStore,
		readOnly		: false,				//false 일 경우만 item 클릭 이벤트 발생 됨. 다른 페이지로 연계될 경우 false로 설정
		showDayView		: false,				//달력 view 버튼 show/hide
		showNavJump		: false,
		showNavBar		: true,
		howTodayText	: true,
		showTime		: false,
		editModal		: true,
		enableEditDetails: false,
         //showMultiDayView: true,
         //showWeekView: false,
         //showMultiWeekView: false,
         //showMonthView: false,
        viewConfig		: {
			enableFx		: false,
			showTime		: true,
			showEventEditorType: 'link',
			//(link: onEventEditor 호출  /  popup : uniPopupUrl 호출   /  editor : 카렌더 기본 에디터)
//             onEventEditor	: function(rec){
//                 var param = {
//        			'DIV_CODE'	: rec.get('id'),
//					'startData'	: rec.get('startData'),
//					'endtData'	: rec.get('startData')
//        		};
//        		alert(param);
//             }
			onEventEditor	: function(rec){
		         dayclick :{
					openInputWindow(rec);
		         }
          /*  	var param = {
        			'MAIN_CODE'	: rec.get('id'),
					'startData'	: rec.get('startData'),
					'endtData'	: rec.get('startData')
        		};
            	var rec1 = {data : {prgID : 'agb110skr', 'text':''}};							
				parent.openTab(rec1, '/base/bsa100ukrv.do', param);*/
			}
         },
            
         monthViewCfg: {
             showHeader		: true,
             showWeekLinks	: true,
             showWeekNumbers: true
         },
            
         multiWeekViewCfg: {
         }
    };
    
    var panelSearch = Unilite.createForm('abh010UkrForm', {
//		defaultType	: 'uniTextfield',
		region		: 'north',
		padding		: '1 1 1 1',
    	layout		: {type	: 'uniTable'	, columns : 3	, tableAttrs: {width: '100%'}},
		border		: true,
    	disabled	: false,
//		height		: 35,
		items		: [{
			fieldLabel	: '작성년월',
			name		: 'CAL_DATE',
			xtype		: 'uniMonthfield',
    		value		: UniDate.get('today'),
	        tdAttrs		: {width: 380},  
			allowBlank	: false,
			listeners	: {
				blur: function(field, eOpt) {
					// 선택된 날짜가 달력이동 되기 위해 set
					var cpanel = Ext.getCmp("uniCalendarPanel01");
					cpanel.activeView.setExtParams({'CAL_DATE': UniDate.getDbDateStr(field.getValue())});
					cpanel.activeView.setExtParams({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					cpanel.setStartDate(field.getValue());
				}
			}
	     },{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox', 
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
	        tdAttrs		: {width: 380}, 
			listeners	: {
				change:function(field, newValue, oldValue, eOpt) {
					var cpanel = Ext.getCmp("uniCalendarPanel01");
					cpanel.activeView.setExtParams({'DIV_CODE':field.getValue()});
					cpanel.setStartDate(panelSearch.getValue('CAL_DATE'));
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'	, tdAttrs: {width: '100%',align : 'right'}},
			items	: [{
		     	xtype	: 'button',
		     	text	: '조회',
		     	name	: 'SEARCH_BUTTON',
				width	: 80,
		     	handler	: function()	{
					var cpanel = Ext.getCmp("uniCalendarPanel01");
                    cpanel.activeView.setExtParams({'CAL_DATE':UniDate.getDbDateStr(panelSearch.getValue('CAL_DATE'))});
                    cpanel.activeView.setExtParams({'DIV_CODE':panelSearch.getValue('DIV_CODE')});
					cpanel.setStartDate(panelSearch.getValue('CAL_DATE'));
		     	}
			},{
		     	xtype	: 'button',
		     	text	: '달력생성',
		     	name	: 'MAKE_CAL',
				width	: 80,
		     	handler	: function()	{
                    openCreateCalendarWindow();
//		     		var o = {        			
//		     			'CAL_DATE'	: UniDate.getDbDateStr(panelSearch.getValue('CAL_DATE')),
//						'DIV_CODE'	: panelSearch.getValue('DIV_CODE')
//					};
//		     		cp.eventStore.load(o);
		     	}
			}]
		}]
	});


	Ext.create('Ext.Viewport', {
		layout	: 'border',
		title	: '',
		items	: [
			panelSearch,
			{
				region	: 'center',
				flex	: 1,
				layout	: {type:'fit'}, 
				items	: [cp]
			}
		],
		renderTo: Ext.getBody()
	})

	
	
	
    //create Calendar
    var createCalendarForm = Unilite.createSearchForm('createCalendarForm', {
        padding: '0 0 0 0',
        disabled :false,        
        layout: {type: 'uniTable', columns :1},
                width: 300,                             
                height:150,
        trackResetOnLoad: true,
        items: [{
            xtype       : 'radiogroup',                         
            fieldLabel  : '작업선택',
            id          : 'rdoSelect',
//            labelWidth  : 140,
            items       : [{
                boxLabel    : '신규생성', 
                width       : 80, 
                name        : 'rdoMakeCalendar',
                inputValue  : 'N',
                checked     : true
            },{
                boxLabel    : '복사생성', 
                width       : 80,
                name        : 'rdoMakeCalendar',
                inputValue  : 'C'
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                	if(newValue.rdoMakeCalendar == 'C') {
                		createCalendarForm.getField('COPY_DIV_CODE').setReadOnly(false);
                	} else {
                        createCalendarForm.setValue('COPY_DIV_CODE', '');
                        createCalendarForm.getField('COPY_DIV_CODE').setReadOnly(true);
                	}
//                    panelResult.getField('rdoSelect2').setValue(newValue.rdoSelect2);
                }
            }
        },{ 
            fieldLabel  : '생성사업장',
            name        : 'NEW_DIV_CODE',
            xtype       : 'uniCombobox', 
            comboType   : 'BOR120',
            value       : UserInfo.divCode,
            allowBlank  : false,
            listeners   : {
                change:function(field, newValue, oldValue, eOpt) {
                }
            }
        },{ 
            fieldLabel  : '복사대상 사업장',
            name        : 'COPY_DIV_CODE',
            xtype       : 'uniCombobox', 
            comboType   : 'BOR120',
            readOnly    : true,
//            value       : UserInfo.divCode,
            allowBlank  : true,
            listeners   : {
                change:function(field, newValue, oldValue, eOpt) {
                }
            }
        },{
            fieldLabel  : '달력년도',
            xtype       : 'uniYearField',
            name        : 'YEAR',
            value       : new Date().getFullYear(),
            allowBlank  : false,
            listeners   : {
                change: function(field, newValue, oldValue, eOpts) {                        
                }
            }
        }]
    });
    
    function openCreateCalendarWindow() {
        var me = this;
        if(!createCalendarWindow) {
        	createCalendarWindow = Ext.create('widget.uniDetailWindow', {
                title       : '달력생성',
                resizable   : false,
                layout      : {type:'uniTable', columns: 1}, 
                width       : 300,                             
                height      : 200,                 
                items       : [createCalendarForm],
                bbar        :  [ '->',
                        {   itemId  : 'saveBtn',
                            text    : '생성',
//                            margin  : '0 5 0 0',
                            disabled: false,
                            handler : function() {
                            	//작업선택에 따른 로직 구분
                            	var workDivi = Ext.getCmp('rdoSelect').getChecked()[0].inputValue
                            	if (workDivi == 'N') {                     //신규생성일 경우,
                            		var param = {
                                        CAL_DATE_FR  : UniDate.getDbDateStr(createCalendarForm.getValue('YEAR'))+'01',
                                        CAL_DATE_TO  : UniDate.getDbDateStr(createCalendarForm.getValue('YEAR'))+'12',
                            			DIV_CODE     : createCalendarForm.getValue('NEW_DIV_CODE')/*,
                            			DIV_CODE_C   : createCalendarForm.getValue('COPY_DIV_CODE')*/
                            		};
                            		abh010ukrService.checkCalendarData (param, function(provider, response) {
                            			if ( provider.length > 0 ) {     //기존 데이터 존재할 경우, 삭제하고 재생성 할지 여부 확인
                            				if (confirm(Msg.sMA0389 + "\n" + Msg.sMA0390))  {
                                                fnNewMakeCalendar(param);
                                                
                            				} else {
                            					return false;
                            				}
                            				
                            			} else {
                                            fnNewMakeCalendar(param);
                            			}
                            		});
                                    createCalendarWindow.hide();
                            	
                            	
                            	} else {                               //복사생성일 경우.
                            		if (Ext.isEmpty(createCalendarForm.getValue('COPY_DIV_CODE'))) {
                            			alert ('복사대상 사업장은 필수 입력사항 입니다.');
                            		}
                                    var param = {
                                        YEAR         : UniDate.getDbDateStr(createCalendarForm.getValue('YEAR')),
                                        CAL_DATE_FR  : UniDate.getDbDateStr(createCalendarForm.getValue('YEAR'))+'01',
                                        CAL_DATE_TO  : UniDate.getDbDateStr(createCalendarForm.getValue('YEAR'))+'12',
                                        DIV_CODE     : createCalendarForm.getValue('NEW_DIV_CODE'),
                                        DIV_CODE_C   : createCalendarForm.getValue('COPY_DIV_CODE')
                                    };
                                    abh010ukrService.checkCalendarData (param, function(provider, response) {
                                        if ( provider.length > 0 ) {     //기존 데이터 존재할 경우, 삭제하고 재생성 할지 여부 확인
                                            if (confirm(Msg.sMA0389 + "\n" + Msg.sMA0390))  {
                                                fnCopyMakeCalendar(param);
                                                
                                            } else {
                                                return false;
                                            }
                                            
                                        } else {
                                            fnCopyMakeCalendar(param);
                                        }
                                    });
                                    createCalendarWindow.hide();
                            	}
                            }
                        }, {
                            itemId  : 'deleteBtn',
                            text    : '삭제',
                            disabled: false,
                            handler : function() {
                                createCalendarWindow.hide();
                            }
                        },{
                            itemId  : 'closeBtn',
                            text    : '닫기',
                            disabled: false,
                            handler : function() {
                                createCalendarWindow.hide();
                            }
                        },'->'
                ],
                listeners : {
//                    beforeshow: function(me, eOpt)  {
//                        createCalendarWindow.clearForm(); 
//                        if (!Ext.isEmpty(rec.HOLY_TYPE)) {
//                          createCalendarWindow.setValue('HOLLY_TYPE', rec.HOLY_TYPE)
//                        }
//                    },
//                    beforehide: function(me, eOpt)  {
//                        createCalendarWindow.clearForm(); 
//                    },
//                    beforeclose: function( panel, eOpts )   {
//                        createCalendarWindow.clearForm();
//                    },
//                    show: function( panel, eOpts )  {                               
//                        
//                    }
                }  
            });
        createCalendarWindow.center();
        createCalendarWindow.show();
        }
    };
    
    
    
    
    //input day_plan
    var inputForm = Unilite.createSearchForm('inputForm', {
        padding: '0 0 0 0',
        disabled :false,        
        layout: {type: 'uniTable', columns :1},
                width: 300,                             
                height:150,
        trackResetOnLoad: true,
        items: [{
            fieldLabel  : '휴무구분',
            xtype       : 'uniCombobox',
            name        : 'HOLLY_TYPE',
            comboType   : 'AU',
            comboCode   : 'B011',
            allowBlank  : false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                }
            }
         },{
            fieldLabel  : '적요',
            xtype       : 'uniTextfield',
            name        : 'REMARK',
            listeners   : {
                change: function(field, newValue, oldValue, eOpts) {                        
                }
            }
        }]
    });

    function openInputWindow(rec) {
        var me = this;
        if(!inputWindow) {
			inputWindow = Ext.create('widget.uniDetailWindow', {
                title: '휴무일 설정',
                resizable:false,
                width: 300,				                
                height:150,
                layout: {type:'uniTable', columns: 1},	                
                items: [inputForm],
                bbar:  [ '->',
				        {	itemId : 'searchBtn',
							text: '저장',
							margin: '0 5 0 0',
							handler: function() {
								
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '취소',
							handler: function() {
								inputWindow.hide();
							},
							disabled: false
						},'->'
				],
				listeners : {
					beforeshow: function(me, eOpt)	{
						inputForm.clearForm(); 
						if (!Ext.isEmpty(rec.HOLY_TYPE)) {
						  inputForm.setValue('HOLLY_TYPE', rec.HOLY_TYPE)
						}
					},
					beforehide: function(me, eOpt)	{
						inputForm.clearForm(); 
					},
					beforeclose: function( panel, eOpts )	{
						inputForm.clearForm();
					},
					show: function( panel, eOpts )	{                			 	
					 	
					}
                }		
			})
		}
        inputWindow.center();
        inputWindow.show();
	};
	
	
    function fnNewMakeCalendar(param) {
        abh010ukrService.createCalendarData (param, function(provider, response) {
            createCalendarForm.getEl().mask(/*Msg.fsbMsgH0245,*/'loading-indicator');
            if (provider != 0){
                Ext.Msg.alert('확인', Msg.sMB006);
                
            } else {
                Ext.Msg.alert('확인', Msg.sMM389);
//              panelSearch.getField('SEARCH_BUTTON').handler();
                
            }
            createCalendarForm.getEl().unmask();
        });
    };
    
    function fnCopyMakeCalendar(param) {
        abh010ukrService.copyCalendarData (param, function(provider, response) {
            createCalendarForm.getEl().mask(/*Msg.fsbMsgH0245,*/'loading-indicator');
            if (provider != 0){
                Ext.Msg.alert('확인', Msg.sMB006);
                
            } else {
                Ext.Msg.alert('확인', Msg.sMM389);
//              panelSearch.getField('SEARCH_BUTTON').handler();
                
            }
            createCalendarForm.getEl().unmask();
        });
    };
};

	function refresh() {
		var cp = Ext.getCmp('uniCalendarPanel01');
		cp._refresh();
	}
	</script>
    
	<div id="uni-legends" class="x-hide-display" style="border:none; background-color:transparent;">
		<!-- 데이타의 상태 표시를 위한 레전드 -->
		<img src='<c:url value="/resources/css/icons/icon-cal-MR.png" />' /> <t:message code="extensible.cal.calType.RE"	default="비고" />
	</div>
	<div id="uni-filter" class="x-hide-display" style="border:none; background-color:transparent;">
	</div>
</script>