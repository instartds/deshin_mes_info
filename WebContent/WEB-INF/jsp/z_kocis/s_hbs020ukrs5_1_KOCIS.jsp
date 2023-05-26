<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<meta name="decorator" content="calendar_body"/>
<t:appConfig pgmId="hbs020ukr"   >
	<t:ExtComboStore comboType="BOR120"  /> 
</t:appConfig>
<script type="text/javascript" >

var regFormWin;
function appMain() {
			// 달력에 표시할 데이타 Store
        	var eventStore = Ext.create('Extensible.store.DirectEventStore',{
        		proxy: {
					type: 'direct',
				    api: {
				        read: hbs020ukrService.selectList5//calendarService.read2//
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
                 showWeekView: false,
                 showMultiWeekView: false,
                 showMonthView: false,
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
					columns:4
			    },
			    defaults:{
					labelWidth:90
			    },
				defaultType: 'uniTextfield',
				
				width:400,
				items : [{
					fieldLabel: '작성년월',
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
			     	xtype:'button',
			     	text:'조회',
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
			     	text:'달력생성',
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
		function openCreateCalendar()	{
			regFormWin= Ext.create('widget.uniDetailWindow', {
		                title: '달력생성',
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
										fieldLabel: '작업선택',
										xtype: 'uniRadiogroup',
										name:'REG_KIND',
										items: [
						 					{boxLabel:'신규생성', name:'REG_KIND', inputValue:'1', checked:true},
						 					{boxLabel:'복사생성', name:'REG_KIND', inputValue:'2'},
						 					{boxLabel:'전체복사', name:'REG_KIND', inputValue:'3'}
						  				]
							            
									},{
										fieldLabel:' ', 
										labelWidth:90,
										xtype:'uniCheckboxgroup',
										name: 'SATURDAY_HOLIDAY',
										items:[
											{boxLabel:'토요일휴무여부', name:'SATURDAY_HOLIDAY', inputValue:'1', checked:true}
										]
									},{
									    fieldLabel: '생성사업장',
										name: 'DIV_CODE',          
										xtype: 'uniCombobox' ,
										comboType: 'BOR120',
										value:UserInfo.divCode,
										allowBlank:false
									}, {
										fieldLabel: '복사대상 사업장',
										xtype: '',
										xtype: 'uniCombobox' ,
										name: 'COPY_DIV_CODE',
										comboType: 'BOR120'
									}, {
										fieldLabel: '달력년도',
										name: 'CREATE_YYYY',
										allowBlank:false,
										maxLength:4
									}
									
							]}
						],
		                tbar:  [
					         '->',{
								text: '생성',
								handler: function() {
									var form = regFormWin.down('#search');
									if(form.getForm().isValid()){
										if(form.getValue('REG_KIND') == '2')	{
											if(Ext.isEmpty(form.getValue('COPY_DIV_CODE')))	{
												alert('복사대상 사업장을 입력하세요.');
												form.getField('COPY_DIV_CODE').focus();
												return;
											}
										}
									
										hbs020ukrService.insertCalendar5(form.getValues(), function(responseText, response) {
											console.log("responseText : ", responseText);
											console.log("response : ", response);
										})
									} else {
										alert('필수입력 값을 입력하세요.')
									}
								},
								disabled: false
							},{
								itemId : 'submitBtn',
								text: '삭제',
								handler: function() {
									var store = Ext.data.StoreManager.lookup('printStore') ;
									store.loadStoreRecords();
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '닫기',
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