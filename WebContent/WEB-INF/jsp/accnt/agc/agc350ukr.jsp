<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc350ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

var BsaCodeInfo = {	
	gsGubunA093: '${gsGubunA093}'
};
var getStDt = ${getStDt};

var dAmt7000 = 0;

var saveFlag = '';
var actionFlag = '';

var SEARCH = '';

var agc350ukrRef1Window; // 검색팝업 관련

function appMain() {  

	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'agc350ukrService.insertDetail1',
			syncAll: 'agc350ukrService.saveAll1'
		}
	});	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'agc350ukrService.insertDetail2',
			syncAll: 'agc350ukrService.saveAll2'
		}
	});	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'agc350ukrService.selectList3',
			update: 'agc350ukrService.updateDetail3', 
			syncAll: 'agc350ukrService.saveAll3'
		}
	});	

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc340ukrModel1', {
	   fields: [
			{name: 'ACCNT_CD'      	, text: 'ACCNT_CD'		, type: 'string'},
			{name: 'ACCNT_NAME'    	, text: '항목명'			, type: 'string'},
			{name: 'AMT_I'         	, text: '금액'			, type: 'uniPrice'},
			{name: 'OPT_DIVI'      	, text: 'OPT_DIVI'		, type: 'string'},
			{name: 'CAL_DIVI'       , text: 'CAL_DIVI'		, type: 'string'},
			{name: 'UPPER_ACCNT'   	, text: 'UPPER_ACCNT'	, type: 'string'}
	    ]
	});		// End of Ext.define('Agc340ukrModel', {
	
	Unilite.defineModel('Agc340ukrModel2', {
	   fields: [
			{name: 'ACCNT_CD'      	, text: 'ACCNT_CD'		, type: 'string'},
			{name: 'ACCNT_NAME'    	, text: '항목명'			, type: 'string'},
			{name: 'AMT_I'         	, text: '금액'			, type: 'uniPrice'},
			{name: 'OPT_DIVI'      	, text: 'OPT_DIVI'		, type: 'string'},
			{name: 'CAL_DIVI'       , text: 'CAL_DIVI'		, type: 'string'},
			{name: 'UPPER_ACCNT'   	, text: 'UPPER_ACCNT'	, type: 'string'}
	    ]
	});
	
	Unilite.defineModel('Agc340ukrModel3', {
	   fields: [
			{name: 'ACCNT'          , text: 'ACCNT'			, type: 'string'},
			{name: 'CHK'           	, text: '선택'			, type: 'string'},
			{name: 'ACCNT_NAME'     , text: '계정과목명'		, type: 'string'},
			{name: 'OCCU_AMT_I'     , text: '발생금액'			, type: 'uniPrice'},
			{name: 'RPLC_AMT_I'     , text: '대체금액'			, type: 'uniPrice'},
			{name: 'ACCNT_CD'       , text: 'ACCNT_CD'		, type: 'string'}
	    ]
	});
	
	Unilite.defineModel('Agc340ukrRef1Model', {	//검색팝업관련
		// uniMonth 필요 당기시작,시작,종료일 파라미터 받을때 YYYY.MM 으로 받아오기 때문에 오류 있음
	    fields: [
			{name: 'AC_YYYYMM'			,text: '당기시작년월'		,type: 'string'},
			{name: 'FR_AC_DATE'			,text: '시작일'			,type: 'string'},
			{name: 'TO_AC_DATE'			,text: '종료일'			,type: 'string'},
			{name: 'EX_DIV_CODE'		,text: '(사업장)'			,type: 'string'},
			{name: 'PJT_CODE'			,text: '(프로젝트)'		,type: 'string'},
			{name: 'EX_NUM'				,text: '결의일자'			,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string'},
			{name: 'INPUT_USER_ID'		,text: '입력자'			,type: 'string'},
			{name: 'INPUT_DATE'			,text: '입력일자'			,type: 'string'},
			{name: 'AP_STS'				,text: '승인여부'			,type: 'string'}
	    ]
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore1 = Unilite.createStore('agc350ukrMasterStore1',{
		model: 'Agc340ukrModel1',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc350ukrService.selectList1'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			param.dAmt7000 = dAmt7000;
			param.SEARCH = SEARCH;
			console.log( param );
			this.load({
				params : param
			});
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				directDetailStore3.loadStoreRecords();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(saveFlag != 'Y'){
					if(actionFlag != 'N'){
						UniAppManager.app.fnReCalculation(store, record, record.previousValues.AMT_I, 'grd1');
					}
				}
           	}
		}
	});
	
	var directDetailStore2 = Unilite.createStore('agc350ukrMasterStore1',{
		model: 'Agc340ukrModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc350ukrService.selectList2'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();	
			param.SEARCH = SEARCH;
			console.log( param );
			this.load({
				params : param
			});
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				Ext.each(records,function(record,i){
					if(record.get('ACCNT_CD') == '7000'){
						dAmt7000 = record.get('AMT_I');
					}
				});
				directDetailStore1.loadStoreRecords();	
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(saveFlag != 'Y'){
					if(actionFlag != 'N'){
						UniAppManager.app.fnReCalculation(store, record, record.previousValues.AMT_I, 'grd2');
					}
				}
           	}
		}
	});
	
	var directDetailStore3 = Unilite.createStore('agc350ukrMasterStore1',{
		model: 'Agc340ukrModel3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy3,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.SEARCH = SEARCH;
			console.log( param );
			this.load({
				params : param
			});
			
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{	
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						directDetailStore3.loadStoreRecords();
						saveFlag = '';
					}
				};
				this.syncAllDirect(config);
			}else {
				detailGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {		
				detailGrid1.getEl().unmask();		
				detailGrid2.getEl().unmask();		
				detailGrid3.getEl().unmask();
				if(SEARCH == 'SEARCH'){
					var param= Ext.getCmp('searchForm').getValues();		
					agc350ukrService.costInformation(param, function(provider, response){
						if(Ext.isEmpty(provider) && directDetailStore2.getCount() == 0 && directDetailStore3.getCount() == 0){
							Ext.Msg.alert(Msg.sMB099,Msg.sMB015);	
						}else{
							
							if(Ext.isEmpty(provider)){
								Ext.getCmp('btnAutoSlip').setDisabled(true);
								panelResult.down('#btnAutoSlip').setHtml(Msg.sMAW034);	
								UniAppManager.setToolbarButtons(['deleteAll'],true);
								UniAppManager.setToolbarButtons(['query'],false);
							}else{
								
								detailGrid3.getSelectionModel().selectAll();    
								
								UniAppManager.app.fnReplaceCostAmt(provider);
								
								if(!Ext.isEmpty(provider.EX_DATE)){
									panelResult.down('#btnAutoSlip').setHtml(Msg.sMAW026);	
									UniAppManager.setToolbarButtons(['query','deleteAll'],false);
								}else{
									UniAppManager.setToolbarButtons(['deleteAll'],true);
									UniAppManager.setToolbarButtons(['query'],false);
								}
								
								/*if(provider.AGREE_YN == 'Y'){
									Ext.getCmp('btnAutoSlip').setDisabled(true);	
								}else{
									Ext.getCmp('btnAutoSlip').setDisabled(false);	
								}*/
							}	
						}
						panelResult.getField('FR_DATE').setReadOnly(true);
						panelSearch.getField('FR_DATE').setReadOnly(true);
						
						panelResult.getField('TO_DATE').setReadOnly(true);
						panelSearch.getField('TO_DATE').setReadOnly(true);
						
						panelResult.getField('ACCNT_DIV_CODE').setReadOnly(true);
						panelSearch.getField('ACCNT_DIV_CODE').setReadOnly(true);
						
						panelSearch.getField('ST_DATE').setReadOnly(true);
						
						panelSearch.getField('AC_PROJECT_CODE').setReadOnly(true);
						panelSearch.getField('AC_PROJECT_NAME').setReadOnly(true);
						
						
						if(Ext.isEmpty(panelResult.getValue('AC_DATE'))){
							panelResult.getField('AC_DATE').setReadOnly(false);
							panelSearch.getField('AC_DATE').setReadOnly(false);	
//							txtAcDate.className = "cssEssInput"
						}else{
							panelResult.getField('AC_DATE').setReadOnly(true);
							panelSearch.getField('AC_DATE').setReadOnly(true);		
//							txtAcDate.className = "cssLockInput"
						}
						
						if(Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
							panelResult.getField('DIV_CODE').setReadOnly(false);
							panelSearch.getField('DIV_CODE').setReadOnly(false);	
//							txtDivCode.className = "cssEssInput"
						}else{
							panelResult.getField('DIV_CODE').setReadOnly(true);
							panelSearch.getField('DIV_CODE').setReadOnly(true);		
//							txtDivCode.className = "cssLockInput"
						}
						SEARCH = '';
					})
				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
//				alert("ㅇㅇㅇ");
//				UniAppManager.app.fnChangeGrid1();
           	}
		}
	});
	
	var agc350ukrRef1Store = Unilite.createStore('agc350ukrRef1Store', {//검색팝업관련
		model: 'Agc340ukrRef1Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read: 'agc350ukrService.selectRef1'                	
            }
        },
       
        loadStoreRecords : function()	{
			var param= agc350ukrRef1Search.getValues();	
//			param.CHARGE_DIVI = gsChargeDivi;
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {		
				var count = agc350ukrRef1Grid.getStore().getCount();
				if(count == 0){
					alert(Msg.sMB015); //해당 자료가 없습니다.
				}
			}
		}
	});
	
	var grid1SaveStore = Unilite.createStore('agc350ukrgrid1SaveStore',{  // 이익상태

		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy1,
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						directDetailStore1.commitChanges();  
						grid2SaveStore.saveStore();
					}
				};
				this.syncAllDirect(config);
			}else {
				detailGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	
	var grid2SaveStore = Unilite.createStore('agc350ukrgrid2SaveStore',{ // 생산비용

		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						directDetailStore2.commitChanges();
						directDetailStore3.saveStore();	
						UniAppManager.setToolbarButtons('deleteAll',true);
					}
				};
				this.syncAllDirect(config);
			}else {
				detailGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var cancSlipStore = Unilite.createStore('Agc340ukrCancSlipStore',{		//기표취소 관련
		proxy: {
           type: 'direct',
            api: {			
                read: 'agc350ukrService.cancSlip'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var today = new Date();
        	var inputDate = '';
        	inputDate = UniDate.getDbDateStr(today);
			param.INPUT_DATE = inputDate;
			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

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
    			fieldLabel: '전표일',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_DATE',
		        endFieldName: 'TO_DATE',
		        allowBlank : false,
		        holdable: 'hold',
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_DATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        //value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
	        },{ 
    			fieldLabel: '전표일자',
    			name:'AC_DATE',
				xtype: 'uniDatefield',
//				value: UniDate.get('today'),
//				allowBlank:false,
				width: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_DATE', newValue);
					}
				}
			},{					
    			fieldLabel: '귀속사업장',
    			name:'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType:'BOR120',
//    			allowBlank:false,
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		}]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{ 
    			fieldLabel: '당기시작년월',
    			name:'ST_DATE',
				xtype: 'uniMonthfield',
//				value: UniDate.get('today'),
				allowBlank:false,
				holdable: 'hold',
				width: 200
			},
		    Unilite.popup('AC_PROJECT',{
		    	fieldLabel: '프로젝트',
		    	valueFieldName:'AC_PROJECT_CODE',			    
			    textFieldName: 'AC_PROJECT_NAME',
			    holdable: 'hold'
//		    	allowBlank:false,
//				holdable: 'hold'
//		    	textFieldWidth:170
		   	}),{
    			fieldLabel: '재무제표</br>양식차수',
    			name:'GUBUN', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A093',
    			allowBlank:false
    		}]
		}],
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: 500/*,align : 'left'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '전표일',
			labelWidth:150,
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_DATE',
	        endFieldName: 'TO_DATE',
	        allowBlank : false,
	        holdable: 'hold',
//	        tdAttrs: {width:1000},
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE',newValue);
					UniAppManager.app.fnSetStDate(newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE',newValue);
		    	}
		    }
        },{
			fieldLabel: '사업장',
			labelWidth:150,
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        //value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 385,
//		        tdAttrs: {width:'100%',align : 'left'}, 
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
			}
	    },{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			tdAttrs: {align : 'right'/*,width:'100%'*/},
			items :[{
		    	xtype: 'button',
	    		text: '검색(M)',	
	    		id: 'btnLinkDtl',
	    		name: 'LINKDTL',
	    		width: 80,	
				handler : function() {
					openAgc340ukrRef1Window();
				}
		    }]
    	},{ 
			fieldLabel: '전표일자',
			labelWidth:150,
			name:'AC_DATE',
			xtype: 'uniDatefield',
//				value: UniDate.get('today'),
//			allowBlank:false,
//			tdAttrs: {width:1000},
//			width: 350,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AC_DATE', newValue);
				}
			}
		},{					
			fieldLabel: '귀속사업장',
			labelWidth:150,
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
//			tdAttrs: {width:'100%',align : 'left'}, 
//			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
//			width:120,
			defaults : {enforceMaxLength: true},
			tdAttrs: {align : 'right'/*,width:'100%'*/},
			items :[{
				xtype:'component',
				html:'원가대체기표',
	    		id: 'btnAutoSlip',
//	    		name: 'LINKSLIP',
	    		width: 80,	
	    		tdAttrs: {align : 'center'},
	    		componentCls : 'component-text_first',
	    		disabled: true,
				listeners:{
					render: function(component) {
		                component.getEl().on('click', function( event, el ) {
		                	
		                	if(Ext.isEmpty(panelResult.getValue('AC_DATE'))){
		                		Ext.Msg.alert(Msg.sMB099, Msg.sMA0041);
		                		panelResult.getField('AC_DATE').focus();
		                		
		                		return false;
		                	}
		                	
		                	if(Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
		                		Ext.Msg.alert(Msg.sMB099, Msg.sMA0120);
		                		panelResult.getField('DIV_CODE').focus();
		                		
		                		return false;
		                	}
		                	
		                	if(Ext.getCmp('btnAutoSlip').getEl().dom.innerHTML == Msg.sMAW034){
				                var params = {
								//				action:'select', 
									'PGM_ID' : 'agc350ukr',
									'sGubun' : '50',
									'AC_DATE': panelResult.getValue('AC_DATE'),
									'FR_DATE': panelResult.getValue('FR_DATE'),
									'TO_DATE': panelResult.getValue('TO_DATE'),
									'ST_DATE': panelSearch.getValue('ST_DATE'),
									'AC_PROJECT_CODE': panelSearch.getValue('AC_PROJECT_CODE'),
									'DIV_CODE': panelResult.getValue('DIV_CODE')
								}
								var rec1 = {data : {prgID : 'agj260ukr', 'text':''}};							
								parent.openTab(rec1, '/accnt/agj260ukr.do', params);
		                	
		                	}else{
		                		var param= Ext.getCmp('searchForm').getValues();
								var today = new Date();
					        	var inputDate = '';
					        	inputDate = UniDate.getDbDateStr(today);
								param.INPUT_DATE = inputDate;
								cancSlipStore.load({
									params : param,
									callback : function(records, operation, success) {
										if(success)	{
											UniAppManager.setToolbarButtons(['deleteAll'],true);
											Ext.Msg.alert(Msg.sMB099,Msg.sMA0204);	
											
											panelResult.down('#btnAutoSlip').setHtml(Msg.sMAW034);
											panelResult.getField('AC_DATE').setReadOnly(true);
											panelSearch.getField('AC_DATE').setReadOnly(true);		
										}else{
											return false;
										}
									}
								});	
		                	}
//		                	UniAppManager.app.fnOpenSlip();
		                });
		            }
				}
			}]
    	}],
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
	
    var agc350ukrRef1Search = Unilite.createSearchForm('agc350ukrRef1Form', {//검색팝업관련
		layout :  {type : 'uniTable', columns : 2
//			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
    	items :[{ 
			fieldLabel: '전표일',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_AC_DATE',
	        endFieldName: 'TO_AC_DATE',
	        allowBlank : false,
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(agc350ukrRef1Search) {
					if(newValue == null){
						return false;
					}else{
				    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
							agc350ukrRef1Search.setValue('ST_AC_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
						}else{
							agc350ukrRef1Search.setValue('ST_AC_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
						}
					}
            	}
		    }
        },{
			xtype: 'radiogroup',		            		
			fieldLabel: '',
			items: [{
				boxLabel: '시작일', 
				width: 60, 
				name: 'DATE_OPT', 
				inputValue: 'FR_DATE',
				checked:true
			},{
				boxLabel: '종료일', 
				width: 60, 
				name: 'DATE_OPT', 
				inputValue: 'TO_DATE' 
//					checked: true
			}]
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
//	        multiSelect: true, 
//	        typeAhead: false,
//	        value:UserInfo.divCode,
	        comboType:'BOR120'
//			width: 325
		},
        Unilite.popup('AC_PROJECT',{
	    	fieldLabel: '프로젝트',
	    	valueFieldName:'AC_PROJECT_CODE',			    
		    textFieldName: 'AC_PROJECT_NAME'
//		    	allowBlank:false,
//				holdable: 'hold'
//		    	textFieldWidth:170
	   	}),	
        { 
			fieldLabel: '당기시작년월',
			name:'ST_AC_DATE',
			xtype: 'uniMonthfield',
//				value: UniDate.get('today'),
			allowBlank:false,
			width: 200
		}]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid1 = Unilite.createGrid('agc350ukrGrid1', {
    	title: '손익현황',
    	excelTitle: '손익현황',
    	layout : 'fit',
        region : 'west',
        split:true,
		store: directDetailStore1,
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {			// Grid 상단 검색조건
				useState: false,			
				useStateList: false		
			}
        },
    	features: [ {id : 'detailGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'detailGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
//				if(record.get('OPT_DIVI') == '8'){
//					return record.get('AMT_I') == 'x-change-cell_Background_essRow';	
//	        	}
	        	
	        	var cls = '';
	        	
	          	if(record.get('OPT_DIVI') == '8'){
					cls = 'x-change-cell_Background_essRow';
				}
				return cls;
	        }
	    },           	
        columns: [        
        	{ dataIndex: 'ACCNT_CD'	              , width:66, hidden: true},    
       		{ dataIndex: 'ACCNT_NAME'	          , width:200,
       			renderer:function(value){
					return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>";
				}},
       		{ dataIndex: 'AMT_I'		          , flex:1,/*width:250,*/editor:{xtype:'uniNumberfield',type : 'float', decimalPrecision:2, format:'0,000.00'}
       			/*renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if (record.get('OPT_DIVI') == '8'){
        				metaData.tdCls = 'x-change-cell_Background_essRow';
//                        return '<div style= "background-color:' + '#FAF4C0' + '">' + Ext.util.Format.number(val,'0,000') + '</div>';
                    }
                    return Ext.util.Format.number(val,'0,000');
                }*/

       		},
       		{ dataIndex: 'OPT_DIVI'	              , width:66, hidden: true},
       		{ dataIndex: 'CAL_DIVI'	              , width:66, hidden: true},
       		{ dataIndex: 'UPPER_ACCNT'            , width:66, hidden: true}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['AMT_I'])){
					if(e.record.data.OPT_DIVI != '8'){
						return false;
					}else{
						return true;	
					}
				}else{
					return false;	
				}
			}
		}
    });  
    
    var detailGrid2 = Unilite.createGrid('agc350ukrGrid2', {
    	title: '용역원가',
    	excelTitle: '용역원가',
    	layout : 'fit',
        region : 'center',
        //split:true,
		store: directDetailStore2,
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {			// Grid 상단 검색조건
				useState: false,			
				useStateList: false		
			}
        },
    	features: [ {id : 'detailGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'detailGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
//				if(record.get('OPT_DIVI') == '8'){
//					return record.get('AMT_I') == 'x-change-cell_Background_essRow';	
//	        	}
	        	
	        	var cls = '';
	        	
	          	if(record.get('OPT_DIVI') == '8'){
					cls = 'x-change-cell_Background_essRow';
				}
				return cls;
	        }
	    },           	
        columns:  [        
       		{ dataIndex: 'ACCNT_CD'	              , width:66, hidden: true},
       		{ dataIndex: 'ACCNT_NAME'	          , width:200,
       			renderer:function(value){
					return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>";
				}
       		},
       		{ dataIndex: 'AMT_I'		          , flex:1,/*width:250,*/editor:{xtype:'uniNumberfield',type : 'float', decimalPrecision:2, format:'0,000.00'}},
       		{ dataIndex: 'OPT_DIVI'	              , width:66, hidden: true},
       		{ dataIndex: 'CAL_DIVI'	              , width:66, hidden: true},
       		{ dataIndex: 'UPPER_ACCNT'            , width:66, hidden: true}
        ],
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['AMT_I'])){
					if(e.record.data.OPT_DIVI != '8'){
						return false;
					}else{
						return true;	
					}
				}else{
					return false;	
				}
			}
		}
    });
    
    var detailGrid3 = Unilite.createGrid('agc350ukrGrid3', {
    	title: '용역경비',
    	excelTitle: '용역경비',
    	layout : 'fit',
        region : 'east',
        split:true,
		store: directDetailStore3,
    	uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {			// Grid 상단 검색조건
				useState: false,			
				useStateList: false		
			}
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var dOccuAmt = 0;
					var dRplcAmt = 0;
					var dAmt = 0;
					
					dOccuAmt = selectRecord.get('OCCU_AMT_I');
					dRplcAmt = selectRecord.get('RPLC_AMT_I');
				
					dAmt = dOccuAmt;
					
					selectRecord.set('RPLC_AMT_I',dRplcAmt + dOccuAmt);
					selectRecord.set('OCCU_AMT_I',0);
					
					UniAppManager.app.fnChangeGrid2(selectRecord,dAmt);
					UniAppManager.app.fnChangeGrid1();
					
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var dOccuAmt = 0;
					var dRplcAmt = 0;
					var dAmt = 0;
					
					dRplcAmt = selectRecord.get('RPLC_AMT_I');
					dOccuAmt = selectRecord.get('OCCU_AMT_I');
					
					dAmt = (-1) * dRplcAmt;
					
					selectRecord.set('OCCU_AMT_I',dOccuAmt + dRplcAmt);
					selectRecord.set('RPLC_AMT_I',0);
					
					UniAppManager.app.fnChangeGrid2(selectRecord,dAmt);
					UniAppManager.app.fnChangeGrid1();
				}
			}
        }),
    	features: [ {id : 'detailGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'detailGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
       		{ dataIndex: 'ACCNT'		          , width:66, hidden: true},
       		{ dataIndex: 'ACCNT_NAME'	          , width:190},
       		{ dataIndex: 'OCCU_AMT_I'	          , width:150},
       		{ dataIndex: 'RPLC_AMT_I'	          , flex:1,/*width:150,*/editor:{xtype:'uniNumberfield',type : 'float', decimalPrecision:2, format:'0,000.00'}},
       		{ dataIndex: 'ACCNT_CD'	              , width:66, hidden: true}
        ],
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['RPLC_AMT_I'])){
					return true;	
				}else{
					return false;	
				}
			}
		}  
    });
    
    
    var agc350ukrRef1Grid = Unilite.createGrid('agc350ukrRef1Grid', {//검색팝업 관련
        layout : 'fit',
        excelTitle: '검색팝업',
    	store: agc350ukrRef1Store,
    	uniOpt: {
    		onLoadSelectFirst: true  
        },
        columns:  [  
			{ dataIndex: 'AC_YYYYMM'		, width:120},
			{ dataIndex: 'FR_AC_DATE'		, width:120},
			{ dataIndex: 'TO_AC_DATE'		, width:120},
			{ dataIndex: 'EX_DIV_CODE'		, width:120, hidden:true},
			{ dataIndex: 'PJT_CODE'			, width:120, hidden:true},
			{ dataIndex: 'EX_NUM'			, width:120},
			{ dataIndex: 'DIV_CODE'			, width:120, hidden:true},
			{ dataIndex: 'INPUT_USER_ID'	, width:120},
			{ dataIndex: 'INPUT_DATE'		, width:120},
			{ dataIndex: 'AP_STS'			, width:120}
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
				agc350ukrRef1Grid.returnData(record);
				agc350ukrRef1Window.hide();
				
				SEARCH = 'SEARCH';
				UniAppManager.app.onQueryButtonDown();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
      			record = this.getSelectedRecord();
      		}
      		
      		var textarray = new Array();  
			var divCodeRec = record.get('DIV_CODE');
			textarray = divCodeRec.split("-");
			
	      	panelSearch.setValues({
		  		'ST_DATE':record.get('AC_YYYYMM'),
		  		'FR_DATE':record.get('FR_AC_DATE'),
		  		'TO_DATE':record.get('TO_AC_DATE'),
		  		'ACCNT_DIV_CODE':textarray,
		  		
		  		'AC_PROJECT_CODE':record.get('PJT_CODE'),
//		  		'AC_PROJECT_NAME':record.get('AC_PROJECT_NAME'),
		  		'AC_DATE':record.get('EX_DATE'),
//		  		'':record.get('EX_NUM'),
		  		'DIV_CODE':record.get('EX_DIV_CODE')
	  		});
	        panelResult.setValues({
		  		'ST_DATE':record.get('AC_YYYYMM'),
		  		'FR_DATE':record.get('FR_AC_DATE'),
		  		'TO_DATE':record.get('TO_AC_DATE'),
		  		'ACCNT_DIV_CODE':textarray,
		  		
		  		'AC_DATE':record.get('EX_DATE'),
//		  		'':record.get('EX_NUM'),
		  		'DIV_CODE':record.get('EX_DIV_CODE')
	  		});
       	}
    });
    
    function openAgc340ukrRef1Window() {    		//검색팝업 관련
  		
		if(!agc350ukrRef1Window) {
			agc350ukrRef1Window = Ext.create('widget.uniDetailWindow', {
                title: '검색',
                width: 700,				                
                height: 500,
                layout:{type:'vbox', align:'stretch'},
                items: [agc350ukrRef1Search, agc350ukrRef1Grid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							if(!agc350ukrRef1Search.getInvalidMessage()) return;
							agc350ukrRef1Store.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							agc350ukrRef1Window.hide();
//							draftNoGrid.reset();
//							draftNoSearch.clearForm();
						},
						disabled: false
					}
				],
                listeners : {
                	beforehide: function(me, eOpt)	{

					},
		 			beforeclose: function( panel, eOpts )	{

		 			},
		 			
		 			show: function ( panel, eOpts )	{
		 				agc350ukrRef1Search.setValue('ST_AC_DATE',panelSearch.getValue('ST_DATE'));
		 				agc350ukrRef1Search.setValue('FR_AC_DATE',panelSearch.getValue('FR_DATE'));
		 				agc350ukrRef1Search.setValue('TO_AC_DATE',panelSearch.getValue('TO_DATE'));	
		 				agc350ukrRef1Search.setValue('AC_PROJECT_CODE',panelSearch.getValue('AC_PROJECT_CODE'));	
		 				agc350ukrRef1Search.setValue('AC_PROJECT_NAME',panelSearch.getValue('AC_PROJECT_NAME'));	
		 				
		 				panelResult.down('#btnAutoSlip').setHtml(Msg.sMAW034);
						if(!agc350ukrRef1Search.getInvalidMessage()) return;

						agc350ukrRef1Store.loadStoreRecords();
		 			}
				}
			})
		}
		agc350ukrRef1Window.center();
		agc350ukrRef1Window.show();
    }    
    
	  Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			flex: 3,
			items:[
				detailGrid1, detailGrid2, detailGrid3, panelResult
			]	
		}		
		,panelSearch
		],
		id : 'agc350ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('FR_DATE',UniDate.get('today'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FR_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			panelSearch.setValue('AC_DATE',UniDate.get('today'));
			panelResult.setValue('AC_DATE',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
			panelSearch.setValue('GUBUN',BsaCodeInfo.gsGubunA093);
		},
		onQueryButtonDown : function()	{		
			if(!this.checkForForm()) {
				return false;
			}else{
				detailGrid1.getEl().mask('조회 중...','loading-indicator');
				detailGrid2.getEl().mask('조회 중...','loading-indicator');
				detailGrid3.getEl().mask('조회 중...','loading-indicator');
			
				directDetailStore2.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
				Ext.getCmp('btnAutoSlip').setDisabled(true);
			}
		},
		
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid1.reset();
			detailGrid2.reset();
			detailGrid3.reset();
			directDetailStore1.clearData();
			directDetailStore2.clearData();
			directDetailStore3.clearData();
			UniAppManager.setToolbarButtons(['save','deleteAll'],false);
			UniAppManager.setToolbarButtons(['query'],true);
			Ext.getCmp('btnAutoSlip').setDisabled(true);
		},
		
		checkForForm:function() { 
			return panelSearch.setAllFieldsReadOnly(true);
        },
        
        onSaveDataButtonDown: function(config) {
        	
        	profitStatusRecords = directDetailStore1.data.items;
        	grid1SaveStore.clearData();
			Ext.each(profitStatusRecords, function(record1,i){
				record1.phantom = true;
				grid1SaveStore.insert(i, record1);
			});
			
        	produceCostRecords = directDetailStore2.data.items;
        	grid2SaveStore.clearData();
			Ext.each(produceCostRecords, function(record2,i){
				record2.phantom = true;
				grid2SaveStore.insert(i, record2);
			});

			saveFlag = 'Y';
			grid1SaveStore.saveStore();
			
			Ext.getCmp('btnAutoSlip').setDisabled(false);
		},
        
        onDeleteAllButtonDown: function() {
			
			if(!detailForm.getInvalidMessage()) return;   
				       
			if(confirm('전체삭제 하시겠습니까?')) {
				
				var param = panelSearch.getValues();
				detailGrid1.getEl().mask('전체삭제 중...','loading-indicator');
				detailGrid2.getEl().mask('전체삭제 중...','loading-indicator');
				detailGrid3.getEl().mask('전체삭제 중...','loading-indicator');
				agc350ukrService.agc350ukrDelA(param, function(provider, response)	{							
					if(provider){	
						UniAppManager.updateStatus(Msg.sMB013);
						
						UniAppManager.app.onResetButtonDown();		
					}
					detailGrid1.getEl().unmask();		
					detailGrid2.getEl().unmask();		
					detailGrid3.getEl().unmask();
					
				});
			}else{
				return false;	
			}
		},
		
		fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        },
		
        fnReCalculation: function(store, record, sLowerOldAmt, grdFlag){
        	var sUpperCD ='';
        	var sUpperOldAmt = 0;
        	var sLowerNewAmt = 0;
        	var sSign = 0;
        	
        	sUpperCD = record.get('UPPER_ACCNT');
        	sLowerNewAmt = record.get('AMT_I');
        	
        	if(Ext.isEmpty(sUpperCD)){
        		return false;	
        	}
        	Ext.each(store.data.items, function(item,i){
        		if(sUpperCD == item.get('ACCNT_CD')){
        			if(record.get('CAL_DIVI') == '1'){
        				sSign = 1;	
        			}else{
        				sSign = -1;	
        			}
        			
        			sUpperOldAmt = item.get('AMT_I');
        			
        			item.set('AMT_I',sUpperOldAmt - (sSign * sLowerOldAmt) + (sSign * sLowerNewAmt));
        			
        			if(i == store.getCount()-1){
        				if(grdFlag=='grd2'){
			        		UniAppManager.app.fnChangeGrid1();
			        	}
        			}
        		}
        	});
        },
        
        
        
        fnChangeGrid1: function(){
//        	var sOldEditVal1 = 0;
        	var sAccntCD = '';
        	
        	sAccntCD = '2050';  // 용역원가2
        	
        	var findAccnt = directDetailStore1.findBy( function( rec, id ) {
	            if ( rec.get('ACCNT_CD').toLowerCase() == sAccntCD ) {
	                return true;
	            }
	            return false;
	        });
	        
	        if(findAccnt == -1){
	        	
	        	var errCheck = "";
	        	
	        	var param = {"sAccntCD": sAccntCD};
				agc350ukrService.fnDispYN(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						if(provider.DIS_DIVI == '4'){
							errCheck = '-1';
						}else{
							errCheck = '0';	
						}
					}else{
						errCheck = '0';	
					}
					
					if(errCheck != '-1'){
						Ext.Msg.alert(Msg.sMB099,Msg.sMA0169);
						
						return false;
					}
				});
	        }else if(findAccnt != -1){
	        	var grd2AmtI = "";
	        	
	        	Ext.each(directDetailStore2.data.items, function(item2,i){
	        		if(i == directDetailStore2.getCount()-1){
	        			grd2AmtI = item2.get('AMT_I');
	        		}
	        	});
	        	
	        	Ext.each(directDetailStore1.data.items, function(item,i){
	        		if(sAccntCD == item.get('ACCNT_CD')){
//						sOldEditVal1 = item.get('AMT_I');
						item.set('AMT_I',grd2AmtI);
	        		}
	        	});
	        }
        },
        /**
         * "제조경비" 그리드에서 각 계정과목의 대체금액이 바뀔때
		 * 변동금액을 "제조원가" 그리드에 반영한다.
         */
        
		fnChangeGrid2: function(record, dAmt){
			var sOldEditVal2 = 0;
        	var sAccntCD = '';
        	
        	sAccntCD = record.get('ACCNT_CD');
        	
        	var findAccnt = directDetailStore2.findBy( function( rec, id ) {
	            if ( rec.get('ACCNT_CD').toLowerCase() == sAccntCD ) {
	                return true;
	            }
	            return false;
	        });	
	        
	        if(findAccnt == -1){
	        	Ext.Msg.alert(Msg.sMB099,msg.sMA0169);
	        	
	        	return false;
	        }else{
	        
		        Ext.each(directDetailStore2.data.items, function(item,i){
	        		if(sAccntCD == item.get('ACCNT_CD')){
						sOldEditVal2 = item.get('AMT_I');
						
						if(Ext.isEmpty(sOldEditVal2)){
				        	sOldEditVal2 = 0;
				        }
				        if(Ext.isEmpty(dAmt)){
				        	dAmt = 0;
				        }
				        
						item.set('AMT_I',sOldEditVal2 + dAmt);
	        		}
	        	});
			}
		},
		
		
		fnReplaceCostAmt: function(provider){

        	UniAppManager.app.fnSetCostAmt(directDetailStore2, '7000', provider.COST_PRPD); // 당기용역원가
        	
        	UniAppManager.app.fnSetCostAmt(directDetailStore1, '2050', provider.COST_PD);  // 용역매출원가2
        	
        },
        
        fnSetCostAmt: function(store, sAccntCd, lNewAmt){
        	Ext.each(store.data.items, function(record, i){
        		if(record.get('ACCNT_CD') == sAccntCd){
        			var lOldAmt = 0;
        			lOldAmt = record.get('AMT_I');
        			
        			record.set('AMT_I',lNewAmt);	
        			
        		/*	if(store.storeId == "agc310ukrDetailStore1"){
        				UniAppManager.app.fnReCalculation(store, record, lOldAmt, 'grd1');
        			}else if(store.storeId == "agc310ukrDetailStore2"){
        				UniAppManager.app.fnReCalculation(store, record, lOldAmt, 'grd2');
        			}*/
        			
        			UniAppManager.app.fnFinalStockAmt(store, record);
        		}
        	});
        	
        },
        /**
         * 각 비용을 이용하여 기말재고액을 역계산한다. 
         */
        fnFinalStockAmt: function(store, rec){
        	actionFlag = 'N';
        	
        	var sUpperCd = '';
        	var sSign = 0;
        	var dSumAmt = 0;
        	var dAmt = 0;
        	var dCostAmt = 0;
        	var dFinalStockAmt = 0;
        	
        	var findAccntCd = '';
        	
        	sUpperCd = rec.get('ACCNT_CD');
        	dCostAmt = rec.get('AMT_I');
        	
        	
        	Ext.each(store.data.items, function(record, i){
        		if(record.get('UPPER_ACCNT') == sUpperCd){
        			if(record.get('OPT_DIVI') == '8'){
        				findAccntCd = record.get('ACCNT_CD');
        			}else{
        				if(record.get('CAL_DIVI') == '2'){
		    				sSign = -1;
		    			}else{
		    				sSign = 1;	
		    			}
		    			
        				dAmt = record.get('AMT_I');
        				dSumAmt = dSumAmt + (sSign * dAmt);
        			}
        		}
        	});
        	
    		Ext.each(store.data.items, function(item, i){
        		if(item.get('ACCNT_CD') == findAccntCd){
        			
					if(item.get('CAL_DIVI') == '2'){
	    				sSign = -1;
	    			}else{
	    				sSign = 1;	
	    			}
    			
        			dFinalStockAmt = dCostAmt - dSumAmt;
        			item.set('AMT_I',sSign * dFinalStockAmt);
        		}
        	});
        	actionFlag = '';
        }
	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore1,
		grid: detailGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "AMT_I" :
					saveFlag = '';
					actionFlag = '';
//					UniAppManager.app.fnReCalculation(directDetailStore1, record, oldValue);
					
					break;
			}
				return rv;
		}
	});	
	Unilite.createValidator('validator02', {
		store: directDetailStore2,
		grid: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "AMT_I" :
					saveFlag = '';
					actionFlag = '';
//					UniAppManager.app.fnReCalculation(directDetailStore1, record, oldValue);
					break;
			}
				return rv;
		}
	});	
	Unilite.createValidator('validator03', {
		store: directDetailStore3,
		grid: detailGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "RPLC_AMT_I" :
					saveFlag = '';
					actionFlag = '';
					var dOccuAmt = 0;
					var dRplcAmt = 0;
					
					dOccuAmt = record.get('OCCU_AMT_I');
					dRplcAmt = newValue;
					
					if(dOccuAmt + oldValue < dRplcAmt){
						rv = Msg.sMA0305; // 대체금액은 발생금액을 초과할 수 없습니다.	
						break;
					}else{
						record.set('OCCU_AMT_I',dOccuAmt + oldValue - dRplcAmt);	
					}
					
					if(dRplcAmt == 0){
						dAmt = (-1) * oldValue;	
					}else{
						dAmt = dRplcAmt - oldValue;	
					}
					
					UniAppManager.app.fnChangeGrid2(record,dAmt);
//					UniAppManager.app.fnChangeGrid1();
					
					break;
					
			}
				return rv;
		}
	});	
};


</script>
