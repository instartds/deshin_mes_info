<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<meta name="decorator" content="calendar_body"/>
<t:appConfig pgmId="pbs070ukr"   >
	<t:ExtComboStore comboType="AU" comboCode="B011"  />  
	<t:ExtComboStore comboType="AU" comboCode="B062"  /> 
</t:appConfig>
<script type="text/javascript" >

var regFormWin, editorWin;
function appMain() {
			// 달력에 표시할 데이타 Store
    	var eventStore = Ext.create('Extensible.store.DirectEventStore',{
        proxy: {
            type: 'direct',
            api: {
                read: pbs070ukrvsService.getEventList
            }
        },
        /*
         * 기본 내장 Data field
            {name:    'id',         mapping: 'id',          type:    'String'}, //EventId
            {name:    'calendarId', mapping: 'calendarId',  type:    'String'}, //calendarId
            {name:    'title',      mapping: 'title',       type:    'string'}, //Title
            {name:    'startDate',  mapping: 'startDate',   type:    'date', dateFormat: 'Ymd' },//StartDate
            {name:    'endDate',    mapping:    'endDate',  type:    'date',  dateFormat: 'Ymd'  },//EndDate
         */
        //추가 필드
        fields:[            
            {name: 'CAL_TYPE',   type:'string'},    
            {name: 'CAL_DATE',   type:'string'},    //날짜
            {name: 'CAL_NO',   type:'string'},      //주차
            {name: 'WEEK_DAY',   type:'string'},
            {name: 'HOLY_TYPE',   type:'string'},   //근무타입 2:전일 1:반일 0:휴일
            {name: 'JULIAN',   type:'string'},      //쥴리안
            {name: 'WORK_DAY',   type:'string'},    //누계근무
            {name: 'REMARK',   type:'string'}
        ],
//              remoteSort: true,
        loadStoreRecords: function() {
            var param = panelSearch.getValues();
            this.load({
                params : param
            });
        }
    });
    var calendarStore = Ext.create('Extensible.store.DirectCalendarStore',{
        proxy : {
            type : 'direct',
            directFn : pbs070ukrvsService.readCalendars
        }
    }); 
        	
	var cp = {
		flex:.8,
        xtype:'extensible.uniCalendarPanel',
        id:'uniCalendarPanel01',
        eventStore: eventStore,
        calendarStore: calendarStore,
        viewConfig: {
             enableFx: false,
             showTime: true,
             showEventEditorType:'link' , //(link:onEventEditor 호출/popup : uniPopupUrl 호출 /editor : 카렌더 기본 에디터)
             onEventEditor: function(rec){
                if(Ext.isEmpty(rec.data)) return false;
                Ext.getCmp('calNo').setValue(rec.get('CAL_NO'));
                Ext.getCmp('julian').setValue(rec.get('JULIAN'));
                Ext.getCmp('workDay').setValue(rec.get('WORK_DAY'));
                Ext.getCmp('holyType').setValue(rec.get('HOLY_TYPE'));
                Ext.getCmp('remark').setValue(rec.get('REMARK'));
                Ext.getCmp('exDate').setValue(UniDate.getDbDateStr(rec.get('startDate')));
                //오늘 이전 내역 수정 불가
                if(UniDate.getDbDateStr(rec.get('startDate')) >= UniDate.get('today')){
                    Ext.getCmp('saveButton').setDisabled(false);
                }else{
                    Ext.getCmp('saveButton').setDisabled(true);
                }
                

             }
         },
            
         monthViewCfg: {
             showHeader: true,
             showWeekLinks: true,
             showWeekNumbers: true
         },
            
         multiWeekViewCfg: {

         },
          // private
        onPrevClick: function(){
            this.startDate = this.layout.activeItem.movePrev(true);
            this.updateNavState();
            this.fireViewChange();
            var view = this.layout.getActiveItem()
            Ext.getCmp('startDate').setValue(UniDate.add(view.getStartDate(), {days:+7}));
            Ext.getCmp('calNo').setValue('');
            Ext.getCmp('julian').setValue('');
            Ext.getCmp('workDay').setValue('');
            Ext.getCmp('holyType').setValue('');
            Ext.getCmp('remark').setValue('');
            Ext.getCmp('exDate').setValue('');
            Ext.getCmp('saveButton').setDisabled(true);
        },
        
        // private
        onNextClick: function(){
            this.startDate = this.layout.activeItem.moveNext(true);
            this.updateNavState();
            this.fireViewChange();
            var view = this.layout.getActiveItem()
            Ext.getCmp('startDate').setValue(UniDate.add(view.getStartDate(), {days:+7}));
            Ext.getCmp('calNo').setValue('');
            Ext.getCmp('julian').setValue('');
            Ext.getCmp('workDay').setValue('');
            Ext.getCmp('holyType').setValue('');
            Ext.getCmp('remark').setValue('');
            Ext.getCmp('exDate').setValue('');
            Ext.getCmp('saveButton').setDisabled(true);
        },
         readOnly: false,               //false 일 경우만 item 클릭 이벤트 발생 됨. 다른 페이지로 연계될 경우 false로 설정
         showDayView: false,            // 달력 view 버튼 show/hide
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
					
		 enableContextMenus: false,
         showWeekView: false,
         showMultiWeekView: false,
         showMonthView: false
	}
    var panelSearch = Unilite.createSearchForm('pbs070ukrs3Form', {
		   region: 'north',
		   xtype: 'container',
		   layout: {type: 'uniTable', columns: 3},
		   
    		padding:'0 0 0 0',
		   items:[{ 
                fieldLabel: '카렌더타입',
                allowBlank:false,
                id: 'calType',
                name: 'CAL_TYPE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B062',
                valueWidth: 60,
                listeners:{
                    blur:function(field, eOpt) {
                        var cpanel = Ext.getCmp("uniCalendarPanel01");
                        cpanel.activeView.setExtParams({'CAL_TYPE':field.getValue()});
//                                    cpanel.setStartDate(panelSearch.getValue('startDate'));
//                                    me.setDefaultCloseInfoForm();
                    }
                }
            },{
                fieldLabel: '조회월',
                xtype: 'uniMonthfield',
                id: 'startDate',
                name:'startDate',
                allowBlank:false,
                listeners:{
                    blur:function(field, eOpt) {
                        // 선택된 날짜가 달력이동 되기 위해 set
//                            var cpanel = Ext.getCmp("uniCalendarPanel01");
//                            cpanel.setStartDate(field.getValue());
//                            me.setDefaultCloseInfoForm();
                    }
                }
             },{
                xtype: 'button',
                text: '&nbsp;&nbsp;&nbsp;조회&nbsp;&nbsp;&nbsp;',
                name:'startDate',
                allowBlank:false,
                margin: '0 0 0 30',
                handler: function() {
                    var cpanel = Ext.getCmp("uniCalendarPanel01");
                    cpanel.setStartDate(Ext.getCmp('startDate').getValue());
                    Ext.getCmp('calNo').setValue('');
                    Ext.getCmp('julian').setValue('');
                    Ext.getCmp('workDay').setValue('');
                    Ext.getCmp('holyType').setValue('');
                    Ext.getCmp('remark').setValue('');
                    Ext.getCmp('exDate').setValue('');
                    Ext.getCmp('saveButton').setDisabled(true);
                }
             }]
			
	});
	
            var eastForm = Unilite.createForm('pbs070ukrs3Form2', {
            	flex:.2,
                   xtype: 'container',
                   disabled:false,
                   layout: {type: 'uniTable', columns: 1},
                   items:[{ 
                        fieldLabel: '<t:message code="system.label.product.workday" default="작업일"/>',                            
                        id: 'exDate',
                        xtype: 'uniDatefield',
                        margin: '0 20 0 0',
                        readOnly: true
                    },{ 
                        fieldLabel: '주차',                            
                        id: 'calNo',
                        xtype: 'uniTextfield',
                        margin: '0 20 0 0',
                        suffixTpl: '주',
                        readOnly: true
                    },{ 
                        fieldLabel: '쥴리안',              
                        id: 'julian',
                        xtype: 'uniTextfield',
                        margin: '0 20 0 0',
                        suffixTpl: '일',
                        readOnly: true
                    },{ 
                        fieldLabel: '누계근무',                            
                        id: 'workDay',
                        xtype: 'uniTextfield',
                        margin: '0 20 0 0',
                        suffixTpl: '일',
                        readOnly: true
                    },{                 
                    	fieldLabel: '휴무구분',
                        id: 'holyType',
                        xtype: 'uniCombobox',
                        comboType: 'AU',
                        comboCode: 'B011',
                        listeners:{
                            blur:function(field, eOpt) {
                                var cpanel = Ext.getCmp("uniCalendarPanel01");
                            
                            }
                        }                        
                    },{ 
                    	fieldLabel: '<t:message code="system.label.product.remarks" default="비고"/>', 
                        id: 'remark',
                        xtype: 'textarea',
                        margin: '0 20 0 0'
                    },{
                        margin: '12 0 0 93',
                        xtype: 'button',
                        id: 'saveButton',
                        text: '저장', 
                        width: 80,
                        disabled: true,
                        handler : function() {
                        	Ext.getBody().mask('<t:message code="system.label.product.loading" default="로딩중..."/>','loading-indicator');
                            var param = {EX_DATE: UniDate.getDbDateStr(Ext.getCmp('exDate').getValue()), HOLY_TYPE: Ext.getCmp('holyType').getValue(), REMARK: Ext.getCmp('remark').getValue()}
                            pbs070ukrvsService.updateDetail3(param, function(provider, response)  {
                                if(provider){
                                    UniAppManager.updateStatus(Msg.sMB011); 
                                    var cpanel = Ext.getCmp("uniCalendarPanel01");
                                    cpanel.setStartDate(Ext.getCmp('startDate').getValue()); 
                                    Ext.getCmp('calNo').setValue('');
                                    Ext.getCmp('julian').setValue('');
                                    Ext.getCmp('workDay').setValue('');
                                    Ext.getCmp('holyType').setValue('');
                                    Ext.getCmp('remark').setValue('');
                                    Ext.getCmp('exDate').setValue('');
                                }
                                Ext.getBody().unmask();
                            });
                        }
                    }/*,{
                        xtype: 'uniTextfield',
                        fieldLabel: '실행일',
                        id: 'exDate',
                        hidden: true
                    }*/],
                    setAllFieldsReadOnly: function(b) {
						var r= true
						if(b) {
							var invalid = this.getForm().getFields().filterBy(function(field) {
																				return !field.validate();
																			});
		   	
			   				if(invalid.length > 0) {
								r=false;
			   					var labelText = ''
			   	
								if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
			   						var labelText = invalid.items[0]['fieldLabel']+' : ';
			   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
			   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
			   					}
			
							   	alert(labelText+Msg.sMB083);
							   	invalid.items[0].focus();
							} else {
							//	this.mask();		    
			   				}
				  		} else {
		  					this.unmask();
		  				}
						return r;
		  			}
                    
            });
            
            Ext.create('Ext.Viewport', {
				layout : 'border',
				title : '',
				items : [
					panelSearch ,
					{
						region:'center',
						flex:1,
						layout:{type:'hbox',align: 'stretch'},
						items:[cp, eastForm]
					}
					],
				renderTo : Ext.getBody()
			})
			
			var o = {params:{
     			'DIV_CODE' : UserInfo.divCode,
     			'endDate' : Ext.Date.format(new Date(), 'Ym')
     		}};
     		cp.eventStore.load(o);
            
} 
	 function refresh() {
        	var cp = Ext.getCmp('uniCalendarPanel01');
        	cp._refresh();
     }
    
    </script>
    
     <div id="uni-legends" class="x-hide-display" style="border:none; background-color:transparent;">
       <!-- 데이타의 상태 표시를 위한 레전드 -->
    	<span style="color:#ff0000">■</span> 휴일
    	<span style="color:#0000ff">■</span> 반일
    	<span style="color:#ffffff">■</span> 전일
    	<span style="color:#FF00FF">■</span> 휴무
    </div>
    <div id="uni-filter" class="x-hide-display" style="border:none; background-color:transparent;">
    </div>