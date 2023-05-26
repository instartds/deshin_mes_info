<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx540ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A024" /> 	<!-- 의제매입세액공제율 -->
	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

function appMain(){
	
	var SAVE_FLAG;
	var PERIOD_FLAG;
	var bIsInit = false;
	
	Unilite.defineModel('Atx540ukrModel1', {
	    fields: [
	    	{name: 'SUB_CODE'			   	,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var refStore1 = Unilite.createStore('atx540ukrRefStore1',{
		model: 'Atx540ukrModel1',
		uniOpt : {
        	isMaster: false,		// 상위 버튼 연결 
        	editable: false,		// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'atx540ukrService.selectSubList'                	
			}
		},
		loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();
			
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();

			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)){
					PERIOD_FLAG = '';
				}else{
					PERIOD_FLAG = records[0].data.SUB_CODE;
					UniAppManager.app.fnSetReadOnlyAmtForm();
				}
			}
		}
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
	        	fieldLabel: '계산서일',
				xtype: 'uniMonthRangefield',  
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        startDD: 'first',
		        endDD: 'last',
		        width: 470,
		        allowBlank: false,
		        holdable:'hold',
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_PUB_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PUB_DATE',newValue);
			    	}
			    }
			},{
				fieldLabel: '신고사업장', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				width:315,
				comboCode: 'BILL',
				allowBlank: false,
				holdable:'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '작성일자',
	 		    width: 315,
	            xtype: 'uniDatefield',
	            name: 'WRITE_DATE',
	            value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WRITE_DATE', newValue);
					}
				}
	     	},{
		    	xtype: 'container',
		    	margin: '0 0 0 60', 
		    	layout: {type : 'uniTable', columns : 2},
		    	items:[{
		    		xtype: 'button',
		    		text: '이전자료복사',
		    		width: 100,
		    		margin: '0 0 0 0',   
		    		id:'search_ReCompute',
		    		handler : function() {
	    			
	    			}
		    	},{
		    		xtype: 'button',
		    		text: '출력',
		    		width: 100,
		    		margin: '0 0 0 0',  
	    			id:'search_Preview',
		    		handler : function() {
						var me = this;
						if(!panelSearch.checkFormValidate(true)){
							return false;
						}else{
							UniAppManager.app.onPrintButtonDown();
						}
						
	   				}
		    	}]
		    }]		
		}],
		checkFormValidate: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
		}
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
        	fieldLabel: '계산서일',
			xtype: 'uniMonthRangefield',  
	        startFieldName: 'FR_PUB_DATE',
	        endFieldName: 'TO_PUB_DATE',
	        startDD: 'first',
	        endDD: 'last',
	        width: 470,
	        allowBlank: false,
	        holdable:'hold',
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_PUB_DATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_PUB_DATE',newValue);
		    	}
		    }
		},{
			fieldLabel: '신고사업장', 
			name: 'BILL_DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode: 'BILL',
			allowBlank: false,
			width:315,
			holdable:'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		},{
	    	xtype: 'container',
	    	margin: '0 0 0 60', 
	    	layout: {type : 'uniTable', columns : 2},
	    	items:[{
	    		xtype: 'button',
	    		text: '이전자료복사',
	    		width: 100,
	    		margin: '0 0 0 120',    
	    		id:'result_ReCompute',
	    		handler : function() {
	    			
				}
	    	 
	    	},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 120', 
	    		id:'result_Preview',
	    		handler : function() {
					var me = this;
					if(!panelResult.checkFormValidate(true)){
						return false;
					}else{
						UniAppManager.app.onPrintButtonDown();
					}
   				}
	    	}]
	    },{
			fieldLabel: '작성일자',
 		    width: 315,
            xtype: 'uniDatefield',
            name: 'WRITE_DATE',
            value: UniDate.get('today'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WRITE_DATE', newValue);
				}
			}
		}],
     	checkFormValidate: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
		},
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});
	
	var tableView = Unilite.createForm('detailForm', { //createForm
	    title:'&nbsp;',
		disabled: false,
		flex: 1.6,
		xtype: 'container',
		bodyPadding: 0,
		margin:-5,
		region: 'center',
	    layout: {type: 'uniTable', columns: 1 },
	    items: [
	    		{ xtype: 'container', padding: 1, margin: 0,
	    		  layout: {	type:'uniTable', columns:3 },
	    		  items: [
				    		{ xtype: 'component',  html:'기본사항 (', width: 60 },
				    		{ 
								xtype: 'radiogroup',
								fieldLabel: '',
								id: 'rdoHomeGubun',
								width: 100,
								padding: '3 0 -3 0',
								readOnly: true,
								items: [
										{ boxLabel: '자가',	width: 50,	name: 'HOME_GUBUN',	inputValue: '01' },
										{ boxLabel: '타가',	width: 70,	name: 'HOME_GUBUN',	inputValue: '02' }
								]
							},
				    		{ xtype: 'component',  html:')&nbsp;②~⑤란은 음식점업자 및 숙박업자만 적습니다.', width:300}
	    		  ]
	    		},
	    		{ xtype: 'container', padding: 1, margin: 0,
	    		  layout: {	type:'uniTable', columns:10,
	    		  			tableAttrs: {style: 'border : 1px solid #ced9e7;'},
	    		  			tdAttrs: {style: 'border : 1px solid #ced9e7;',align : 'center'},
	    		  			trAttrs: {style: 'height:29px;'}
	    		  },
	    		  items: [
	    		  			{ xtype: 'component',  html:'① 사업장', 	colspan: 3 },
	    		  			{ xtype: 'component',  html:'② 객실 수', 	rowspan: 4 },
	    		  			{ xtype: 'component',  html:'③ 탁자 수', 	rowspan: 4 },
	    		  			{ xtype: 'component',  html:'④ 의자 수', 	rowspan: 4 },
	    		  			{ xtype: 'component',  html:'⑤ 주차장', 	rowspan: 4 },
	    		  			{ xtype: 'component',  html:'⑥ 종업원 수', 	rowspan: 4 },
	    		  			{ xtype: 'component',  html:'⑦ 차량', 		rowspan: 2, colspan: 2 },
	    		  			
	    		  			{ xtype: 'component',  html:'대지',		rowspan: 3 },
	    		  			{ xtype: 'container',  					rowspan: 2, colspan:2,
				    		  layout: {	type:'uniTable', columns:3 },
				    		  items: [
				    		  			{ xtype: 'component',		html:'건물(지하&nbsp;'	, tdAttrs: {align:'right'} },
				    		  			{ xtype: 'uniNumberfield',	id:'BLDG_UNDER'		, name:'BLDG_UNDER'	, value:'0', readOnly:true	, width:60 },
				    		  			{ xtype: 'component',		html:'&nbsp;층,'},
				    		  			{ xtype: 'component',		html:'지상&nbsp;'		, tdAttrs: {align:'right'} },
				    		  			{ xtype: 'uniNumberfield',	id:'BLDG_UP'		, name:'BLDG_UP'		, value:'0', readOnly:true	, width:60 },
				    		  			{ xtype: 'component',		html:'&nbsp;층)'}
				    		  ]
	    		  			
	    		  			},
	    		  			
	    		  			{ xtype: 'component',  html:'승용차'	, rowspan: 2 },
	    		  			{ xtype: 'component',  html:'화물차'	, rowspan: 2 },
	    		  			{ xtype: 'component',  html:'바닥면적' },
	    		  			{ xtype: 'component',  html:'연면적' },
	    		  			
	    		  			{ xtype: 'uniNumberfield',	id:'GROUND'				, name:'GROUND'			, value:'0', readOnly:true	, width:112, suffixTpl: '㎡', decimalPrecision: 2 },
	    		  			{ xtype: 'uniNumberfield',	id:'FLOOR_AREA'			, name:'FLOOR_AREA'		, value:'0', readOnly:true	, width:112, suffixTpl: '㎡', decimalPrecision: 2 },
	    		  			{ xtype: 'uniNumberfield',	id:'TOT_FLOOR_AREA'		, name:'TOT_FLOOR_AREA'	, value:'0', readOnly:true	, width:112, suffixTpl: '㎡', decimalPrecision: 2 },
	    		  			{ xtype: 'uniNumberfield',	id:'ROOM_CNT'			, name:'ROOM_CNT'			, value:'0', readOnly:true	, width:112, suffixTpl: '개' },
	    		  			{ xtype: 'uniNumberfield',	id:'DESK_CNT'			, name:'DESK_CNT'			, value:'0', readOnly:true	, width:112, suffixTpl: '개' },
	    		  			{ xtype: 'uniNumberfield',	id:'CHAIR_CNT'			, name:'CHAIR_CNT'		, value:'0', readOnly:true	, width:112, suffixTpl: '개' },
	    		  			{ xtype: 'uniRadiogroup',
	    		  			  width:100,
	    		  			  padding: '0 3 0 10',
	    		  			  id: 'rdoParkingYn',
	    		  			  readOnly: true,
							  items: [
									{boxLabel: '유'	, width: 50, name: 'PARKING_YN', inputValue: 'Y'},
									{boxLabel: '무'	, width: 50, name: 'PARKING_YN', inputValue: 'N'}
							  ] 
							},
	    		  			{ xtype: 'uniNumberfield',	id:'EMPLOYEE_CNT'		, name:'EMPLOYEE_CNT'		, value:'0', readOnly:true	, width:112, suffixTpl: '명' },
	    		  			{ xtype: 'uniNumberfield',	id:'CAR_CNT'			, name:'CAR_CNT'			, value:'0', readOnly:true	, width:112, suffixTpl: '대' },
	    		  			{ xtype: 'uniNumberfield',	id:'TRUCK_CNT'			, name:'TRUCK_CNT'		, value:'0', readOnly:true	, width:112, suffixTpl: '대' }
	    		  ]
	    		},
	    		{ xtype: 'component',  html:'&nbsp;' },
	    		{ xtype: 'container', padding: 1, margin: 0,
	    		  layout: {	type:'uniTable', columns:3 },
	    		  items: [
				    		{ xtype: 'component',  html:'기본경비 (6월, 12월 기준) (', width: 150 },
				    		{ 
								xtype: 'radiogroup',
								fieldLabel: '',
								id: 'rdoMonthBase',
								width: 100,
								padding: '3 0 -3 0',
								items: [
										{ boxLabel: '6월',	width: 50,	name: 'MONTH_BASE',	inputValue: '01' },
										{ boxLabel: '12월',	width: 70,	name: 'MONTH_BASE',	inputValue: '02' }
								]
							},
				    		{ xtype: 'component',  html:')', width:300 }
	    		  ]
	    		},
	    		{ xtype: 'container', padding: 1, margin: 0, 
	    		  layout: {	type:'uniTable', columns:7,
	    		  			tableAttrs: {style: 'border : 1px solid #ced9e7;'},
	    		  			tdAttrs: {style: 'border : 1px solid #ced9e7;',align : 'center'},
	    		  			trAttrs: {style: 'height:29px;'}
	    		  },
	    		  items: [
	    		  			{ xtype: 'component',  html:'⑧ 임차료', colspan: 2 },
	    		  			{ xtype: 'component',  html:'⑨ 전기·가스료', rowspan: 2 },
	    		  			{ xtype: 'component',  html:'⑩ 수도료', rowspan: 2 },
	    		  			{ xtype: 'component',  html:'⑪ 인건비', rowspan: 2 },
	    		  			{ xtype: 'component',  html:'⑫ 기타', rowspan: 2 },
	    		  			{ xtype: 'component',  html:'⑬ 월 기본경비 합계', rowspan: 2 },
	    		  			
	    		  			{ xtype: 'component',  html:'보증금'},
	    		  			{ xtype: 'component',  html:'월세'},
	    		  			
	    		  			{ xtype: 'uniNumberfield',	id:'GUARANTY'			, name:'GUARANTY'		, value:'0', readOnly:true	, width:161 },
	    		  			{ xtype: 'uniNumberfield',	id:'MONTHLY_RENT'		, name:'MONTHLY_RENT'	, value:'0', readOnly:true	, width:161 },
	    		  			{ xtype: 'uniNumberfield',	id:'ELEC_GAS'			, name:'ELEC_GAS'		, value:'0', readOnly:true	, width:161 },
	    		  			{ xtype: 'uniNumberfield',	id:'WATER_RATE'			, name:'WATER_RATE'		, value:'0', readOnly:true	, width:161 },
	    		  			{ xtype: 'uniNumberfield',	id:'LABOR_COST'			, name:'LABOR_COST'		, value:'0', readOnly:true	, width:161 },
	    		  			{ xtype: 'uniNumberfield',	id:'ETC_EXPENSE'		, name:'ETC_EXPENSE'	, value:'0', readOnly:true	, width:161 },
	    		  			{ xtype: 'uniNumberfield',	id:'TOT_COST_AMT'		, name:'TOT_COST_AMT'	, value:'0', readOnly:true	, width:161 }
	    		  ]
	    		}
	    ],
	    api: {
	    	load: 'atx540ukrService.selectFormData',
	    	submit: 'atx540ukrService.saveFormData'
	    }
	});
	
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				panelResult,
				tableView
			]	
		},
			panelSearch
		],
		id  : 'atx540ukrApp',
		fnInitBinding : function() {
			bIsInit = true;
			
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('newData',false);
			
			panelSearch.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
        	panelSearch.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
        	panelSearch.setValue('BILL_DIV_CODE',UserInfo.divCode);
        	
        	panelResult.setValue('FR_PUB_DATE',UniDate.get('startOfMonth'));
        	panelResult.setValue('TO_PUB_DATE',UniDate.get('endOfMonth'));
        	panelResult.setValue('BILL_DIV_CODE',UserInfo.divCode);
        	
        	panelSearch.down('#search_ReCompute').setDisabled(true);
        	panelResult.down('#result_ReCompute').setDisabled(true);
        	
        	UniAppManager.app.fnClearForm();
        	
        	//bIsInit = false;
		},
		onQueryButtonDown : function()	{
			bIsInit = false;
			
			var param = panelSearch.getValues();
			
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();

			tableView.mask('loading...');
			
			tableView.getForm().load({
				params: param,
				success: function(form, action) {
					tableView.unmask();
					
					SAVE_FLAG = action.result.data.SAVE_FLAG;
					if(SAVE_FLAG == 'U'){
						UniAppManager.setToolbarButtons('delete',true);
						UniAppManager.setToolbarButtons('save',false);
					}else if(SAVE_FLAG == 'N'){
						UniAppManager.setToolbarButtons('save',true);
					}
					
					UniAppManager.app.fnSetReadOnly(false);
				},
				failure: function(form, action) {
					SAVE_FLAG = 'N'
					UniAppManager.setToolbarButtons('save',true);
					tableView.unmask();
					
					UniAppManager.app.fnSetReadOnly(false);
				}
			});
			refStore1.loadStoreRecords();
			
			UniAppManager.setToolbarButtons('reset',true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			
			tableView.clearForm();
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('delete',false);
			UniAppManager.app.fnSetReadOnly(true);
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var param = tableView.getValues();
			
			param.SAVE_FLAG = SAVE_FLAG;
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			param.BILL_DIV_CODE = panelSearch.getValue('BILL_DIV_CODE');
			
			tableView.getForm().submit({
				params : param,
				success : function(form, action) {
					tableView.getForm().wasDirty = false;
					tableView.resetDirtyStatus();
					
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
					
					if(SAVE_FLAG == 'D') {
						SAVE_FLAG == '';
					}else {
						UniAppManager.app.onQueryButtonDown();
					}
				}
			});
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				UniAppManager.app.fnClearForm();
				UniAppManager.setToolbarButtons('delete',false);
				UniAppManager.setToolbarButtons('save',true);
				
				SAVE_FLAG = 'D';
			}
		},
		onPrintButtonDown: function() {
			var billDiviCode = panelSearch.getValue('BILL_DIV_CODE');
			var temp		 = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + '01';
			var lastDay		 = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
			var from_date	 = UniDate.getDbDateStr(panelSearch.getValue('FR_PUB_DATE')).substring(0, 6) + '01';
			var to_date		 = UniDate.getDbDateStr(panelSearch.getValue('TO_PUB_DATE')).substring(0, 6) + lastDay;
			var param = {
				FR_PUB_DATE : from_date,
				TO_PUB_DATE : to_date,
				BILL_DIV_CODE : billDiviCode,
				WRITE_DATE : UniDate.getDateStr(panelSearch.getValue("WRITE_DATE"))
			};
			param.ACCNT_DIV_NAME = panelSearch.getField('BILL_DIV_CODE').getRawValue();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/atx/atx540ukrPrint.do',
				prgID: 'atx540ukr',
				extParam: param
				});
			win.center();
			win.show();   				
		},
        fnSetReadOnly:function(boolean){
			if(boolean == true){
				Ext.getCmp('GROUND').setReadOnly(true);
				Ext.getCmp('FLOOR_AREA').setReadOnly(true);
				Ext.getCmp('TOT_FLOOR_AREA').setReadOnly(true);
				Ext.getCmp('BLDG_UNDER').setReadOnly(true);
				Ext.getCmp('BLDG_UP').setReadOnly(true);
				
				Ext.getCmp('ROOM_CNT').setReadOnly(true);
				Ext.getCmp('DESK_CNT').setReadOnly(true);
				Ext.getCmp('CHAIR_CNT').setReadOnly(true);
				Ext.getCmp('rdoParkingYn').setReadOnly(true);
				Ext.getCmp('EMPLOYEE_CNT').setReadOnly(true);
				Ext.getCmp('CAR_CNT').setReadOnly(true);
				Ext.getCmp('TRUCK_CNT').setReadOnly(true);
				
				Ext.getCmp('GUARANTY').setReadOnly(true);
				Ext.getCmp('MONTHLY_RENT').setReadOnly(true);
				Ext.getCmp('ELEC_GAS').setReadOnly(true);
				Ext.getCmp('WATER_RATE').setReadOnly(true);
				Ext.getCmp('LABOR_COST').setReadOnly(true);
				Ext.getCmp('ETC_EXPENSE').setReadOnly(true);
				Ext.getCmp('TOT_COST_AMT').setReadOnly(true);
			}else{
				Ext.getCmp('GROUND').setReadOnly(false);
				Ext.getCmp('FLOOR_AREA').setReadOnly(false);
				Ext.getCmp('TOT_FLOOR_AREA').setReadOnly(false);
				Ext.getCmp('BLDG_UNDER').setReadOnly(false);
				Ext.getCmp('BLDG_UP').setReadOnly(false);
				
				Ext.getCmp('ROOM_CNT').setReadOnly(false);
				Ext.getCmp('DESK_CNT').setReadOnly(false);
				Ext.getCmp('CHAIR_CNT').setReadOnly(false);
				Ext.getCmp('rdoParkingYn').setReadOnly(false);
				Ext.getCmp('EMPLOYEE_CNT').setReadOnly(false);
				Ext.getCmp('CAR_CNT').setReadOnly(false);
				Ext.getCmp('TRUCK_CNT').setReadOnly(false);
				
				//Ext.getCmp('GUARANTY').setReadOnly(false);
				//Ext.getCmp('MONTHLY_RENT').setReadOnly(false);
				//Ext.getCmp('ELEC_GAS').setReadOnly(false);
				//Ext.getCmp('WATER_RATE').setReadOnly(false);
				//Ext.getCmp('LABOR_COST').setReadOnly(false);
				//Ext.getCmp('ETC_EXPENSE').setReadOnly(false);
				//Ext.getCmp('TOT_COST_AMT').setReadOnly(true);
			}
		},
        fnSetReadOnlyAmtForm:function(){
			if(PERIOD_FLAG != '2'){
				tableView.getField('rdoMonthBase').setValue('01');
				
				Ext.getCmp('GUARANTY').setReadOnly(true);
				Ext.getCmp('MONTHLY_RENT').setReadOnly(true);
				Ext.getCmp('ELEC_GAS').setReadOnly(true);
				Ext.getCmp('WATER_RATE').setReadOnly(true);
				Ext.getCmp('LABOR_COST').setReadOnly(true);
				Ext.getCmp('ETC_EXPENSE').setReadOnly(true);
				Ext.getCmp('TOT_COST_AMT').setReadOnly(true);
			}else{
				var toPubDate = panelSearch.getField('TO_PUB_DATE').getEndDate();
				
				if(toPubDate.substring(4, 6) == '06')
					tableView.getField('rdoMonthBase').setValue('01');
				else
					tableView.getField('rdoMonthBase').setValue('02');
				
				Ext.getCmp('GUARANTY').setReadOnly(false);
				Ext.getCmp('MONTHLY_RENT').setReadOnly(false);
				Ext.getCmp('ELEC_GAS').setReadOnly(false);
				Ext.getCmp('WATER_RATE').setReadOnly(false);
				Ext.getCmp('LABOR_COST').setReadOnly(false);
				Ext.getCmp('ETC_EXPENSE').setReadOnly(false);
				Ext.getCmp('TOT_COST_AMT').setReadOnly(true);
			}
		},
		fnClearForm: function() {
			
			tableView.clearForm();
			
        	tableView.getField('rdoHomeGubun').setValue('01');
        	tableView.getField('rdoMonthBase').setValue('01');
        	
        	tableView.setValue('GROUND', 0);
        	tableView.setValue('FLOOR_AREA', 0);
        	tableView.setValue('TOT_FLOOR_AREA', 0);
        	tableView.setValue('BLDG_UNDER', 0);
        	tableView.setValue('BLDG_UP', 0);
        	tableView.setValue('ROOM_CNT', 0);
        	tableView.setValue('DESK_CNT', 0);
        	tableView.setValue('CHAIR_CNT', 0);
        	tableView.setValue('EMPLOYEE_CNT', 0);
        	tableView.setValue('CAR_CNT', 0);
        	tableView.setValue('TRUCK_CNT', 0);
        	tableView.setValue('GUARANTY', 0);
        	tableView.setValue('MONTHLY_RENT', 0);
        	tableView.setValue('ELEC_GAS', 0);
        	tableView.setValue('WATER_RATE', 0);
        	tableView.setValue('LABOR_COST', 0);
        	tableView.setValue('ETC_EXPENSE', 0);
        	tableView.setValue('TOT_COST_AMT', 0);
        	tableView.getField('rdoParkingYn').setValue('Y');
        	//tableView.setValue('', 0);

		}
	});
	
	Unilite.createValidator('validator01', {
		forms: {'formA:':tableView
		},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					if(!bIsInit)
						UniAppManager.setToolbarButtons('save', true);
					else
						UniAppManager.setToolbarButtons('save', false);
					
					break;
			}
			return rv;
		}
	})
}

</script>
