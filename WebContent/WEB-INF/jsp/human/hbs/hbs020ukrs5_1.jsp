<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<meta name="decorator" content="calendar_body"/>
<t:appConfig pgmId="hbs020ukr"   >
	<t:ExtComboStore comboType="BOR120"  /> 
	<t:ExtComboStore comboType="AU" comboCode="H003"  /> 
</t:appConfig>
<script type="text/javascript" >

var regFormWin, editorWin;
function appMain() {
			// 달력에 표시할 데이타 Store
        	var eventStore = Ext.create('Extensible.store.DirectEventStore',{
        		proxy: {
					type: 'direct',
				    api: {
				        read   : hbs020ukrService.selectList5,//calendarService.read2//
				        create : hbs020ukrService.insertCalendar5
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
					 {name:'REMARK', type:'string'}
				 	,{name:'CAL_NO', type:'string'}
					,{name:'WEEK_DAY', type:'string'}
					,{name:'HOLY_TYPE', type:'string'}
					,{name:'DIV_CODE', type:'string'}
				],
				saveStore : function() {
					this.create();
				}
        	});
        	
            var cp =  {
            	xtype:'extensible.uniCalendarPanel',
            	id:'uniCalendarPanel01',
                eventStore: eventStore,
                viewConfig: {
                     enableFx: false,
                     showTime: false,
                     showEventEditorType:'link' , //(link:onEventEditor 호출/popup : uniPopupUrl 호출 /editor : 카렌더 기본 에디터)
                     onEventEditor: function(rec){
	                   
	                   openEditorWin(rec);
										
						
                     },
                     getEventBodyMarkup : function(){
				        // This is simplified, but shows the symtax for how you could add a
				        // custom placeholder that maps back to the templateData property created
				        // in getEventClass. Note that this is standard Ext template syntax.
				        if(!this.eventBodyMarkup){
				            this.eventBodyMarkup = '<div class="{calendarId}">{REMARK}</div>';
				        	//this.eventBodyMarkup = '{Title}';
				        }
				        return this.eventBodyMarkup;
				    }
                 },
                    
                 monthViewCfg: {
                     showHeader: true,
                     showWeekLinks: true,
                     showWeekNumbers: true,
                     showTime: false,
                     enableContextMenus:false
                 },
                    
                 multiWeekViewCfg: {

                 },
                 load: function(store, records) {
                		 eventStore.reload();
                 },
                 enableContextMenus: false,
                 readOnly: false,				//false 일 경우만 item 클릭 이벤트 발생 됨. 다른 페이지로 연계될 경우 false로 설정
                 showDayView: false,			// 달력 view 버튼 show/hide
                 //showMultiDayView: true,
                 showWeekView: false,
                 showMultiWeekView: false,
                 showMonthView: false,
                 showNavJump:false,
                 showNavBar: true,
                 howTodayText: true,
                 showTime: false,
                 editModal: false,
                 enableEditDetails: false//
            };
            
            var panelSearch = Unilite.createSearchForm('agb100rkrForm', {
				region: 'north',
				padding:'1 1 1 1',
				border:true,
				height:35,
		    	disabled :false,
		    	layout: {
			    	type: 'uniTable',
					columns:4
			    },
			    defaults:{
					labelWidth:90
			    },
				defaultType: 'uniTextfield',
				
				width:400,
				items : [{
					fieldLabel: '<t:message code="system.label.human.datecreated" default="작성년월"/>',
					xtype: 'uniMonthfield',
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
					fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					value : UserInfo.divCode,
					comboType: 'BOR120',
					allowBlank:false,
					listeners:{
						change:function(field, newValue, oldValue, eOpt) {
							var cpanel = Ext.getCmp("uniCalendarPanel01");
							cpanel.activeView.setExtParams({'DIV_CODE':field.getValue()});
						}
					}
				},{
			     	xtype:'button',
			     	text:'<t:message code="system.label.human.inquiry" default="조회"/>',
			     	tdAttrs:{'width':45, 'align':'center'},
			     	handler:function()	{
			     		var o = {params:{
			     			'DIV_CODE' : panelSearch.getValue('DIV_CODE'),
			     			'endDate' : Ext.Date.format(panelSearch.getValue('endDate'), 'Ym')
			     		}};
			     		cp.eventStore.load(o);
			     	}
			     },{
			     	xtype:'button',
			     	text:'<t:message code="system.label.human.cldcreate" default="달력생성"/>',
			     	tdAttrs:{'width':65, 'align':'center'},
			     	handler:function()	{
			     		openCreateCalendar();
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
			
			var o = {params:{
     			'DIV_CODE' : UserInfo.divCode,
     			'endDate' : Ext.Date.format(new Date(), 'Ym')
     		}};
     		cp.eventStore.load(o);
		function openCreateCalendar()	{
			regFormWin= Ext.create('widget.uniDetailWindow', {
		                title: '<t:message code="system.label.human.cldcreate" default="달력생성"/>',
		                width: 350,				                
		                height:220,
		            	
		                layout: {type:'vbox', align:'stretch'},	                
		                items: [{
			                	itemId:'search',
			                	xtype:'uniSearchForm',
			     				style:{
				            		'background':'#fff'
				            	},
			                	margine:'3 3 3 3',
			                	items:[
			                		{	    
										fieldLabel: '<t:message code="system.label.human.redkindselect" default="작업선택"/>',
										xtype: 'uniRadiogroup',
										name:'REG_KIND',
										items: [
						 					{boxLabel:'<t:message code="system.label.human.newcreate" default="신규생성"/>', name:'REG_KIND', inputValue:'1', checked:true},
						 					{boxLabel:'<t:message code="system.label.human.copycreate" default="복사생성"/>', name:'REG_KIND', inputValue:'2'},
						 					{boxLabel:'<t:message code="system.label.human.copyall" default="전체복사"/>', name:'REG_KIND', inputValue:'3'}
						  				],
                                        listeners:{
                                            change:function(field, newValue, oldValue, eOpt) {
                                            	var form = regFormWin.down('#search');
                                                if(newValue.REG_KIND == '1')    {
                                                    form.getField('COPY_DIV_CODE').setDisabled(true);
                                                }else{
                                                    form.getField('COPY_DIV_CODE').setDisabled(false);
                                                }
                                            }
                                        }
							            
									},{
										fieldLabel:' ', 
										labelWidth:90,
										xtype:'uniCheckboxgroup',
										name: 'SATURDAY_HOLIDAY',
										items:[
											{boxLabel:'<t:message code="system.label.human.sdayrestyn" default="토요일휴무여부"/>', name:'SATURDAY_HOLIDAY', inputValue:'1', checked:true}
										]
									}, {
                                        fieldLabel: '<t:message code="system.label.human.copydiv" default="기준사업장"/>',
                                        xtype: 'uniCombobox' ,
                                        name: 'COPY_DIV_CODE',
                                        comboType: 'BOR120',
                                        disabled:true
                                    },{
									    fieldLabel: '<t:message code="system.label.human.creatediv" default="생성사업장"/>',
										name: 'DIV_CODE',          
										xtype: 'uniCombobox' ,
										comboType: 'BOR120',
										value:UserInfo.divCode,
										allowBlank:false
									}, {
										fieldLabel: '<t:message code="system.label.human.cldyear" default="달력년도"/>',
										name: 'CREATE_YYYY',
										allowBlank:false,
										maxLength:4
									}
									
							]}
						],
		                tbar:  [
					         '->',{
								text: '<t:message code="system.label.human.create" default="생성"/>',
								handler: function() {
									var form = regFormWin.down('#search');
									if(form.getForm().isValid()){
										if(form.getValue('REG_KIND') == '2')	{
											if(Ext.isEmpty(form.getValue('COPY_DIV_CODE')))	{
												alert('<t:message code="system.message.human.message102" default="복사대상 사업장을 입력하세요."/>');
												form.getField('COPY_DIV_CODE').focus();
												return;
											}
										}
									
										hbs020ukrService.insertCalendar5(form.getValues(), function(responseText, response) {
											console.log("responseText : ", responseText);
											console.log("response : ", response);
											
											UniAppManager.updateStatus('<t:message code="system.message.human.message130" default="생성이 완료되었습니다."/>');
											regFormWin.hide();
										})
									} else {
										alert('<t:message code="system.message.human.message103" default="필수입력 값을 입력하세요."/>')
									}
								},
								disabled: false
							},{
								itemId : 'submitBtn',
								text: '<t:message code="system.label.human.delete" default="삭제"/>',
								handler: function() {
									var form = regFormWin.down('#search');
                                    if(form.getForm().isValid()){
                                    	Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message009" default="삭제 하시겠습니까?"/>', function(btn){
                                            if (btn == 'yes') {
                                                hbs020ukrService.deleteCalendar5(form.getValues(), function(responseText, response) {
                                                        console.log("responseText : ", responseText);
                                                        console.log("response : ", response);
                                                        
                                                        UniAppManager.updateStatus('<t:message code="system.message.human.message133" default="삭제 되었습니다."/>');
                                                        regFormWin.hide();
                                                        //삭제 되었습니다.
                                                })
                                            }
                                        });
    									
                                    }
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '<t:message code="system.label.human.close" default="닫기"/>',
								handler: function() {
									regFormWin.hide();
								},
								disabled: false
							}
					    ],
						listeners : {
							beforehide: function(me, eOpt)	{
								regFormWin.down('#search').clearForm();
                			},
                			beforeclose: function( panel, eOpts )	{
								regFormWin.down('#search').clearForm();
                			},
                			show: function( panel, eOpts )	{}
		                }		
					});
					regFormWin.show();
					regFormWin.center();
		}
		
		function openEditorWin(rec)	{
			editorWin= Ext.create('widget.uniDetailWindow', {
		                title: '<t:message code="system.label.human.holidayupdate" default="휴일등록"/>',
		                width: 350,				                
		                height:150,
		            	
		                layout: {type:'vbox', align:'stretch'},	                
		                items: [{
			                	itemId:'search',
			                	xtype:'uniSearchForm',
			     				style:{
				            		'background':'#fff'
				            	},
			                	margine:'3 3 3 3',
			                	items:[
			                		{
										fieldLabel: '<t:message code="system.label.human.date" default="날짜"/>',
										name: 'CAL_DATE',
										xtype:'uniDatefield',
										allowBlank:false
									},{
									    fieldLabel: '<t:message code="system.label.human.holytype" default="휴무구분"/>',
										name: 'HOLY_TYPE',          
										xtype: 'uniCombobox' ,
										comboType: 'AU',
										comboCode: 'H003'
									},  {
										fieldLabel: '<t:message code="system.label.human.holiday" default="휴일"/>',
										name: 'REMARK'
									}
									
							]}
						],
		                tbar:  [
					         '->',{
								text: '<t:message code="system.label.human.save" default="저장 "/>',
								handler: function() {
									var form = editorWin.down('#search');
									if(form.getForm().isValid()){
										var param = form.getValues();
										param.DIV_CODE = panelSearch.getValue('DIV_CODE');
										hbs020ukrService.updateCalendar5(param, function(responseText, response) {
											console.log("responseText : ", responseText);
											console.log("response : ", response);
											editorWin.hide();
											var o = {params:{
								     			'DIV_CODE' : panelSearch.getValue('DIV_CODE'),
								     			'endDate' : Ext.Date.format(panelSearch.getValue('endDate'), 'Ym')
								     		}};
								     		cp.eventStore.load(o);
										})
									} else {
										alert('<t:message code="system.message.human.message103" default="필수입력 값을 입력하세요."/>')
									}
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '<t:message code="system.label.human.close" default="닫기"/>',
								handler: function() {
									editorWin.hide();
								},
								disabled: false
							}
					    ],
						listeners : {
							beforehide: function(me, eOpt)	{
								editorWin.down('#search').clearForm();
                			},
                			beforeclose: function( panel, eOpts )	{
								editorWin.down('#search').clearForm();
                			},
                			show: function( panel, eOpts )	{
                				var form = editorWin.down('#search');
                				if(editorWin.record)	{
	                				form.setValue("CAL_DATE",editorWin.record.get('startDate'));
	                				form.setValue("HOLY_TYPE",editorWin.record.get('HOLY_TYPE'));
	                				form.setValue("REMARK",editorWin.record.get('REMARK'));
                				}else {
                					editorWin.hide();
                				}
                				
                			}
		                }		
					});
					if(rec.startDate)	{
						var record = eventStore.data.filterBy(function(record) {
								return UniDate.diffDays(record.get('startDate') , rec.startDate)==0;
							} ).items;		
					
						if(record && record.length > 0) editorWin.record = record[0];
					}
					editorWin.show();
					editorWin.center();
		}
		function onSaveDataButtonDown() {
			var cpPanel = Ext.getcmp('uniCalendarPanel01').getForm();
			if(cpPanel.isValid()) {
				if(eventStore.isDirty()) {
					eventStore.saveStore();
				}
			}
		}
            
} 
	 function refresh() {
        	var cp = Ext.getCmp('uniCalendarPanel01');
        	cp._refresh();
     }
    
    </script>
    
     <div id="uni-legends" class="x-hide-display" style="border:none; background-color:transparent;">
       <!-- 데이타의 상태 표시를 위한 레전드 -->
    	<span style="color:#ff0000">■</span> <t:message code="system.label.human.holiday" default="휴일"/>
    	<span style="color:#0000ff">■</span> <t:message code="system.label.human.halfday" default="반일"/>
    	<span style="color:#ffffff">■</span> <t:message code="system.label.human.allday" default="전일"/>
    	<span style="color:#FF00FF">■</span> <t:message code="system.label.human.rest" default="휴무"/>
    </div>
    <div id="uni-filter" class="x-hide-display" style="border:none; background-color:transparent;">
    </div>