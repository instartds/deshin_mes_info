<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc360ukr"  >
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
var bBizrefYN = '${bBizrefYN}';

var dAmt7000 = 0;

var saveFlag = '';
var actionFlag = '';

var SEARCH = '';
var inLoading = false;
var agreeYn = '';
var agc360ukrRef1Window; // 검색팝업 관련


function appMain() {
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'agc360ukrService.insertDetail1',
			syncAll: 'agc360ukrService.saveAll1'
		}
	});	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'agc360ukrService.insertDetail2',
			syncAll: 'agc360ukrService.saveAll2'
		}
	});	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'agc360ukrService.produceBudget',
			update: 'agc360ukrService.updateDetail3',
			syncAll: 'agc360ukrService.saveAll3'
		}
	});	

	Unilite.defineModel('Agc360ukrModel1', {
		
		fields: [
	    	{name: 'ACCNT_CD'			, text: 'ACCNT_CD'		, type: 'string'},
			{name: 'ACCNT_NAME'			, text: '항목명'			, type: 'string'},
	    	{name: 'AMT_I'				, text: '금액'			, type: 'uniPrice'},
	    	{name: 'OPT_DIVI'			, text: 'OPT_DIVI'		, type: 'string'},
	    	{name: 'CAL_DIVI'			, text: 'CAL_DIVI'		, type: 'string'},
	    	{name: 'UPPER_ACCNT'		, text: 'UPPER_ACCNT'	, type: 'string'}
		]
	});
	
	Unilite.defineModel('Agc360ukrModel2', {
		fields: [
			{name: 'ACCNT_CD'			, text: 'ACCNT_CD'		, type: 'string'},
			{name: 'ACCNT_NAME'			, text: '항목명'			, type: 'string'},
	    	{name: 'AMT_I'				, text: '금액'			, type: 'uniPrice'},
	    	{name: 'OPT_DIVI'			, text: 'OPT_DIVI'		, type: 'string'},
	    	{name: 'CAL_DIVI'			, text: 'CAL_DIVI'		, type: 'string'},
	    	{name: 'UPPER_ACCNT'		, text: 'UPPER_ACCNT'	, type: 'string'}
		]
	});
	
	Unilite.defineModel('Agc360ukrModel3', {
		fields: [
	    	{name: 'ACCNT'			, text: 'ACCNT'		, type: 'string'},
			{name: 'ACCNT_NAME'		, text: '계정과목명'	, type: 'string'},
	    	{name: 'OCCU_AMT_I'		, text: '발생금액'		, type: 'uniPrice'},
	    	{name: 'RPLC_AMT_I'		, text: '대체금액'		, type: 'uniPrice'},
	    	{name: 'ACCNT_CD'		, text: 'ACCNT_CD'	, type: 'string'}
		]
	});
	
	Unilite.defineModel('Agc360ukrRef1Model', {	//검색팝업관련
	    fields: [
			{name: 'AC_YYYYMM'			,text: '당기시작년월'		,type: 'string'},
			{name: 'FR_AC_DATE'			,text: '시작일'			,type: 'string'},
			{name: 'TO_AC_DATE'			,text: '종료일'			,type: 'string'},
			{name: 'EX_DIV_CODE'		,text: '(사업장)'			,type: 'string'},
			{name: 'PJT_CODE'			,text: '(프로젝트)'		,type: 'string'},
			{name: 'EX_DATE'			,text: '결의일'			,type: 'uniDate'},
			{name: 'EX_NUM'				,text: '결의번호'			,type: 'int'},
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string', comboType:'BOR120'},
			{name: 'INPUT_USER_ID'		,text: '입력자'			,type: 'string'},
			{name: 'INPUT_DATE'			,text: '입력일'			,type: 'uniDate'},
			{name: 'J_EX_DATE'			,text: '차감전표일'			,type: 'uniDate'},
			{name: 'AP_STS'				,text: '승인여부'			,type: 'string'}
	    ]
	});
	
		/**
	 * 손익현황 저장관련
	 */
	var profitStatusSaveStore = Unilite.createStore('agc360ukrProfitStatusSaveStore',{

		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy1,
		saveStore : function()	{	
			var paramMaster= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						produceCostSaveStore.saveStore();
					}
				};
				this.syncAllDirect(config);
			}else {
				detailGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	/**
	 * 제조원가 저장관련
	 */
	var produceCostSaveStore = Unilite.createStore('agc360ukrProduceCostSaveStore',{

		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
		saveStore : function()	{	
			var paramMaster= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					useSavedMessage : false,
					params: [paramMaster],
					success: function(batch, option) {
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
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore1 = Unilite.createStore('agc360ukrDetailStore1',{
		model: 'Agc360ukrModel1',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc360ukrService.profitStatus'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());		
			param.dAmt7000 = dAmt7000;
			param.SEARCH = SEARCH;
			console.log( param );
			this.load({
				params : param
			});
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				dAmt7000 = 0;
				inLoading == true;
				var param= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
				agc310ukrService.costInformation(param,function(provider, response){
					if(provider && provider.COST_PRPD)	{
						UniAppManager.app.fnSetCostAmt(directDetailStore1, '2120', provider.COST_PRPD);
			        	UniAppManager.app.fnSetCostAmt(directDetailStore1, '2100', provider.COST_PD);
			        	UniAppManager.app.fnSetCostAmt(directDetailStore1, '2200', provider.COST_GD);
					}
					inLoading == false;
					directDetailStore3.loadStoreRecords();
				});
				
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(saveFlag != 'Y'){
					if(actionFlag != 'N'){
						UniAppManager.app.fnReCalculation(store, record, record.previousValues.AMT_I, 'grd1');
						
					}
					
				}
				if(SEARCH == 'SEARCH' || inLoading == true)	{
					record.commit(true);	
				}
           	}
		}
	});
	
	var directDetailStore2 = Unilite.createStore('agc360ukrDetailStore2',{
		model: 'Agc360ukrModel2',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'agc360ukrService.produceCost'      	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
			param.SEARCH = SEARCH;
			console.log( param );
			param.sDivi = "31";
			this.load({
				params : param
			});
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				/* Ext.each(records,function(record,i){
					if(record.get('ACCNT_CD') == '7000'){
						dAmt7000 = record.get('AMT_I');
					}
				}); */
				var param= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
				param.SEARCH = '' ;
				param.sDivi = "30";
				agc310ukrService.produceCost(param, function(responseText, response){
					Ext.each(responseText,function(record,i){
						if(record['ACCNT_CD'] == '7000'){
							dAmt7000 = record['AMT_I'];
						}
					});
					directDetailStore1.loadStoreRecords();
				} );
				
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(saveFlag != 'Y'){
					if(actionFlag != 'N'){
						UniAppManager.app.fnReCalculation(store, record, record.previousValues.AMT_I, 'grd2');
						
					}
					
				}
				if(SEARCH == 'SEARCH' || inLoading == true)	{
					record.commit(true);	
				}
           	}
		}
		
		
	});
	
	var directDetailStore3 = Unilite.createStore('agc360ukrDetailStore3',{
		model: 'Agc360ukrModel3',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy3,
        loadStoreRecords : function()	{
			var param= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
			param.SEARCH = SEARCH;
			console.log( param );
			this.load({
				params : param
			});
			
		},
		saveStore : function()	{	
			var paramMaster= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					useSavedMessage : false,
					params: [paramMaster],
					success: function(batch, option) {
//						directDetailStore3.loadStoreRecords();
						saveFlag = '';
						UniAppManager.app.activateSlipButtons();  
					}
				};
				this.syncAllDirect(config);
			}else {
				detailGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {		
				if(records.length > 0 && SEARCH == 'SEARCH' ){
					detailGrid3.getSelectionModel().selectAll();    
					UniAppManager.app.activateSlipButtons();  
				} else {
					UniAppManager.app.activateSlipButtons();  
					var autoSlipBtn = addResult.down('#btnAutoSlip');
					var cancelSlipBtn = addResult.down('#btnCancelSlip');
					var autoJSlipBtn = addResult.down('#btnAutoJSlip');
					var cancelJSlipBtn = addResult.down('#btnCancelJSlip');
					autoSlipBtn.setDisabled(false);
					cancelSlipBtn.setDisabled(false);
					autoJSlipBtn.setDisabled(false);
					cancelJSlipBtn.setDisabled(false);
				}
				
				inLoading = false;
				detailGrid1.getEl().unmask();		
				detailGrid2.getEl().unmask();		
				detailGrid3.getEl().unmask();
			}
		}
	});
	/**
	 * 검색팝업 관련
	 */
	var agc360ukrRef1Store = Unilite.createStore('agc360ukrRef1Store', {//검색팝업관련
		model: 'Agc360ukrRef1Model',
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
            	read: 'agc360ukrService.selectRef1'                	
            }
        },
       
        loadStoreRecords : function()	{
			var param= agc360ukrRef1Search.getValues();	
//			param.CHARGE_DIVI = gsChargeDivi;
			this.load({
				params : param
			});
		},
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '전표일',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_DATE',
	        endFieldName: 'TO_DATE',
	        allowBlank : false,
	        holdable: 'hold',
	        width: 325,
//	        tdAttrs: {width:1000},
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.fnSetStDate(newValue);
		    }
        },{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
			tdAttrs:{width: 325},
	        value:UserInfo.divCode,
	        comboType:'BOR120',
//		        tdAttrs: {width:'100%',align : 'left'}, 
			width : 325,
			holdable: 'hold'
	    },{ 
			fieldLabel: '당기시작년월',
			name:'ST_DATE',
			labelWidth:130,
			tdAttrs:{width: '100%'},
	        width: 325,
			xtype: 'uniMonthfield',
//			value: UniDate.get('today'),
			allowBlank:false,
			holdable: 'hold',
			listeners:{
				specialkey: function( field, e, eOpts ) {
					if(e.getKey() == Ext.EventObjectImpl.ENTER)	{
                	
	                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
	                		Unilite.focusPrevField(field, true, e);
	                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
	                		Unilite.focusNextField(field, true, e);
	                	}
                	}
				} 
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			tdAttrs: {align : 'right'/*,width:'100%'*/, style:'padding-right:10px;'},
			items :[{
		    	xtype: 'button',
	    		text: '검색(M)',	
	    		id: 'btnLinkDtl',
	    		name: 'LINKDTL',
	    		width: 100,	
				handler : function(field, newValue, oldValue, eOpts) {
					if(UniAppManager.app._needSave())	{
			  			if(confirm("저장할 내용이 있습니다. 저장 하시겠습니까?"))	{
			  				UniAppManager.app.onSaveDataButtonDown();
			  			} else {
			  				openAgc360ukrRef1Window();
			  			}
			  		} else {
						openAgc360ukrRef1Window();
			  		}
				}
		    }]
    	},
	    Unilite.popup('AC_PROJECT',{
	    	fieldLabel: '프로젝트',
			tdAttrs:{width: 325},
	    	valueFieldName:'AC_PROJECT_CODE',			    
		    textFieldName: 'AC_PROJECT_NAME',
		    holdable: 'hold'
//	    	allowBlank:false,
//			holdable: 'hold'
//	    	textFieldWidth:170
	   	}),
	   	{
			xtype: 'radiogroup',		            		
			fieldLabel: '외주재고 포함여부',
			labelWidth:130,
			items: [{
				boxLabel: '포함안함', 
				width: 80, 
				name: 'BIZRE', 
				inputValue: 'N'
			},{
				boxLabel: '포함', 
				width: 60, 
				name: 'BIZRE', 
				inputValue: 'Y'
			}]
		},{
			fieldLabel: '재무제표 양식차수',
			labelWidth:130,
			name:'GUBUN', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A093',
			colspan:2
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
	
	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%', style:'padding-bottom:5px'}
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		disabled: false,
		border:true,
		padding: '1',
		region: 'north',
		items: [{ 
			fieldLabel: '전표일',
			name:'AC_DATE',
			xtype: 'uniDatefield',
			tdAttrs:{width: 325},
			listeners:{
				specialkey: function( field, e, eOpts ) {
					if(e.getKey() == Ext.EventObjectImpl.ENTER)	{
                	
	                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
	                		Unilite.focusPrevField(field, true, e);
	                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
	                		Unilite.focusNextField(field, true, e);
	                	}
                	}
				} 
			}
		},{					
			fieldLabel: '귀속사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			tdAttrs:{width: 325},
			listeners:{
				specialkey: function( field, e, eOpts ) {
					if(e.getKey() == Ext.EventObjectImpl.ENTER)	{
                	
	                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
	                		Unilite.focusPrevField(field, true, e);
	                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
	                		Unilite.focusNextField(field, true, e);
	                	}
                	}
				} 
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			tdAttrs: {align : 'right'/*,width:'100%'*/, style:'padding-right:10px;'},
			items :[{
				xtype:'button',
				//html:'도급원가대체기표',
				text:'도급원가대체기표',
	    		id: 'btnAutoSlip',
	    		itemId: 'btnAutoSlip',
//	    		name: 'LINKSLIP',
	    		width: 150,	
	    		tdAttrs: {align : 'center'},
	    		disabled: true,
				listeners:{
					render: function(component) {
		                component.getEl().on('click', function( event, el ) {
		                	if(UniAppManager.app._needSave()){						
								Unilite.messageBox("저장할 내용이 있습니다. 저장 후에 자동기표를 실행 하세요.");
								return false;
							}
		                	if(addResult.getInvalidMessage() )	{
			                	if(Ext.isEmpty(addResult.getValue('AC_DATE'))){
			                		Ext.Msg.alert("확인", "전표일을 입력하세요.");
			                		addResult.getField('AC_DATE').focus();
			                		
			                		return false;
			                	}
			                	
			                	if(Ext.isEmpty(addResult.getValue('DIV_CODE'))){
			                		Ext.Msg.alert("확인", "귀속사업장을 입력하세요.");
			                		addResult.getField('DIV_CODE').focus();
			                		
			                		return false;
			                	}
			                	
		                	} else {
		                		return false;
		                	}
		                	
			                var params = {
								'PGM_ID' : 'agc360ukr',
								'sGubun' : '76',
								'COST_DATE': UniDate.getDbDateStr(addResult.getValue('AC_DATE')),	//결의전표일
								'FR_AC_DATE': UniDate.getMonthStr(panelResult.getValue('FR_DATE')),	//전표시작월
								'TO_AC_DATE': UniDate.getMonthStr(panelResult.getValue('TO_DATE')),	//전표종료월
								'AC_YYYYMM': UniDate.getMonthStr(panelResult.getValue('ST_DATE')),	//당기시작년월
								'DIV_CODEQ':panelResult.getValue('ACCNT_DIV_CODE'),
								'PJT_CODE': Ext.isEmpty(panelResult.getValue('AC_PROJECT_CODE')) ? "":panelResult.getValue('AC_PROJECT_CODE'),	
								'DIV_CODE': addResult.getValue('DIV_CODE')
							}
							var rec1 = {data : {prgID : 'agj260ukr', 'text':''}};							
							parent.openTab(rec1, '/accnt/agj260ukr.do', params);
		                	
		                });
		            }
				}
			},{
				xtype:'button',
				text:'대체기표취소',
	    		itemId: 'btnCancelSlip',
//	    		name: 'LINKSLIP',
	    		width: 130,	
	    		tdAttrs: {align : 'center'},
	    		disabled: true,
				listeners:{
					render: function(component) {
		                component.getEl().on('click', function( event, el ) {
		                	if(addResult.getInvalidMessage() )	{
			                	if(Ext.isEmpty(addResult.getValue('AC_DATE'))){
			                		Ext.Msg.alert("확인", "전표일을 입력하세요.");
			                		addResult.getField('AC_DATE').focus();
			                		
			                		return false;
			                	}
			                	
			                	if(Ext.isEmpty(addResult.getValue('DIV_CODE'))){
			                		Ext.Msg.alert("확인", "귀속사업장을 입력하세요.");
			                		addResult.getField('DIV_CODE').focus();
			                		
			                		return false;
			                	}
			                	
		                	} else {
		                		return false;
		                	}
		              
							var params = {
								'COST_DATE': UniDate.getDbDateStr(addResult.getValue('AC_DATE')),	//결의전표일
								'FR_AC_DATE': UniDate.getMonthStr(panelResult.getValue('FR_DATE')),	//전표시작월
								'TO_AC_DATE': UniDate.getMonthStr(panelResult.getValue('TO_DATE')),	//전표종료월
								'AC_YYYYMM': UniDate.getMonthStr(panelResult.getValue('ST_DATE')),	//당기시작년월
								'DIV_CODEQ':panelResult.getValue('ACCNT_DIV_CODE'),
								'PJT_CODE': panelResult.getValue('AC_PROJECT_CODE'),	
								'DIV_CODE': addResult.getValue('DIV_CODE')
							}
							agj260ukrService.cancelAutoSlip76(
								params,function(provider,response) {
									if(provider && Ext.isEmpty(provider.ERROR_DESC) )	{
										UniAppManager.setToolbarButtons(['deleteAll'],true);
										Ext.Msg.alert('확인','자동기표를 취소하였습니다.');	
										
										addResult.down('#btnAutoSlip').setDisabled(false);
										//panelResult.getField('AC_DATE').setReadOnly(true);	
									}else{
										return false;
									}
								}
							);	
		                	
		                });
		            }
				}
			}]
    	},{
			fieldLabel	: '차감전표일',
            xtype		: 'uniDatefield',
		 	name		: 'J_EX_DATE',
	        value		: UniDate.get('today'),
			listeners:{
				specialkey: function( field, e, eOpts ) {
					if(e.getKey() == Ext.EventObjectImpl.ENTER)	{
                	
	                	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
	                		Unilite.focusPrevField(field, true, e);
	                	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
	                		Unilite.focusNextField(field, true, e);
	                	}
                	}
				} 
			}
     	},{
		//컬럼 맞춤용
			xtype	: 'component',
			html : '&nbsp;'
		},{
		xtype	: 'container',
		layout	: {type : 'uniTable', column:2},
		tdAttrs	: {align: 'right', style:'padding-right:10px;'},
		width	: 320,
		items	: [{				   
				xtype	: 'button',
				text	: '도급원가대체차감기표',
				itemId  : 'btnAutoJSlip',
	    		disabled: true,
		 		tdAttrs	: {align: 'right'},
				width	: 150,
				handler : function() {
					if(UniAppManager.app._needSave()){						
						Unilite.messageBox("저장할 내용이 있습니다. 저장 후에 자동기표를 실행 하세요.");
						return false;
					}
					if(!addResult.getInvalidMessage()){						//조회전 필수값 입력 여부 체크
						return false;
					}
					if(Ext.isEmpty(addResult.getValue("J_EX_DATE")))	{
						Unilite.messageBox("차감전표일은 필수 입력입니다.");
						return;
					}
					var params = {
							'FR_AC_DATE': UniDate.getMonthStr(panelResult.getValue('FR_DATE')),	//전표시작월
							'TO_AC_DATE': UniDate.getMonthStr(panelResult.getValue('TO_DATE')),	//전표종료월
							'AC_YYYYMM': UniDate.getMonthStr(panelResult.getValue('ST_DATE')),	//당기시작년월
							'DIV_CODEQ':panelResult.getValue('ACCNT_DIV_CODE'),
							'PJT_CODE': Ext.isEmpty(panelResult.getValue('AC_PROJECT_CODE')) ? "":panelResult.getValue('AC_PROJECT_CODE'),	
							'DIV_CODE': addResult.getValue('DIV_CODE'),
							'EX_DATE' : UniDate.getDbDateStr(addResult.getValue("J_EX_DATE"))
						}
					Ext.getBody().mask();
					agj260ukrService.spAutoSlip77(params, function(provider, response){
						if(provider && Ext.isEmpty(provider.ERROR_DESC) )	{	
							UniAppManager.updateStatus("자동기표가 생성 되었습니다.");
						}
						Ext.getBody().unmask();
					})						
		            
				}
			},{				   
				xtype	: 'button',
				text	: '차감기표취소',
				itemId  : 'btnCancelJSlip',
	    		disabled: true,
		 		tdAttrs	: {align: 'right'},
				width	: 130,
				handler : function() {
					if(!addResult.getInvalidMessage() ){						//조회전 필수값 입력 여부 체크
						return false;
					}
					if(Ext.isEmpty(addResult.getValue("J_EX_DATE")))	{
						Unilite.messageBox("차감전표일은 필수 입력입니다.");
						return;
					}
					var params = {
						'PGM_ID' : 'agc360ukr',
						'sGubun' : '76',
						'FR_AC_DATE': UniDate.getMonthStr(panelResult.getValue('FR_DATE')),	//전표시작월
						'TO_AC_DATE': UniDate.getMonthStr(panelResult.getValue('TO_DATE')),	//전표종료월
						'AC_YYYYMM': UniDate.getMonthStr(panelResult.getValue('ST_DATE')),	//당기시작년월
						'DIV_CODEQ':panelResult.getValue('ACCNT_DIV_CODE'),
						'PJT_CODE': Ext.isEmpty(panelResult.getValue('AC_PROJECT_CODE')) ? "":panelResult.getValue('AC_PROJECT_CODE'),	
						'DIV_CODE': addResult.getValue('DIV_CODE'),
						'EX_DATE' : UniDate.getDbDateStr(addResult.getValue("J_EX_DATE"))
					}
					
					agj260ukrService.spAutoSlip77cancel(params, function (provider,response) {
						if(provider && Ext.isEmpty(provider.ERROR_DESC) )	{
							UniAppManager.setToolbarButtons(['deleteAll'],true);
							UniAppManager.updateStatus('자동기표를 취소하였습니다.');	
							
						}else{
							return false;
						}
					
		            	
		            });	
					
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
    var agc360ukrRef1Search = Unilite.createSearchForm('agc360ukrRef1Form', {//검색팝업관련
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
            	if(agc360ukrRef1Search) {
					if(newValue == null){
						return false;
					}else{
				    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
							agc360ukrRef1Search.setValue('ST_AC_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
						}else{
							agc360ukrRef1Search.setValue('ST_AC_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
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
    
    var detailGrid1 = Unilite.createGrid('agc360ukrGrid1', {
    	title: '손익현황',
    	region:'west',
    	titleAlign: 'center',
        layout : 'fit',
        split:true,
        excelTitle: '손익현황',
        uniOpt: {
            userToolbar:false,
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directDetailStore1,
        columns:  [    
       		{ dataIndex: 'ACCNT_CD'	              , width:66, hidden: true},    
       		{ dataIndex: 'ACCNT_NAME'	          , width:200,
       			renderer:function(value){
					return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>";
				}},
       		{ dataIndex: 'AMT_I'		          , flex:1,
       		  editor:{xtype:'uniNumberfield',type : 'float', decimalPrecision:2, format:'0,000.00'}
       		},
       		{ dataIndex: 'OPT_DIVI'	              , width:66, hidden: true},
       		{ dataIndex: 'CAL_DIVI'	              , width:66, hidden: true},
       		{ dataIndex: 'UPPER_ACCNT'            , width:66, hidden: true}
        ],
        
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				
					return false;	
			}
		} 
    });
    
	var detailGrid2 = Unilite.createGrid('agc360ukrGrid2', {
		title: '도급원가',
		region:'center',
    	titleAlign: 'center',
        layout : 'fit',
//        split:true,
        excelTitle: '도급원가',
        uniOpt: {
            userToolbar:false,
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directDetailStore2,
    	features: [ {id : 'detailGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'detailGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){        	
	        	var cls = '';
	          	if(record.get('ACCNT_CD') == '1160'){
					cls = 'x-change-cell_Background_essRow';
				}
				return cls;
	        }
	    },
        columns:  [        
       		{ dataIndex: 'ACCNT_CD'	              , width:66, hidden: true},
       		{ dataIndex: 'ACCNT_NAME'	          , width:200},
       		{ dataIndex: 'AMT_I'		          , flex:1,
			  editor:{xtype:'uniNumberfield',type : 'float', decimalPrecision:2, format:'0,000.00'}},
       		{ dataIndex: 'OPT_DIVI'	              , width:66, hidden: true},
       		{ dataIndex: 'CAL_DIVI'	              , width:66, hidden: true},
       		{ dataIndex: 'UPPER_ACCNT'            , width:66, hidden: true}
        ],
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['AMT_I'])  && agreeYn == ''){
					if(e.record.data.ACCNT_CD != '1160'){
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
	
	var detailGrid3 = Unilite.createGrid('agc360ukrGrid3', {
		title: '도급경비',
		region:'east',
    	titleAlign: 'center',
    	split:true,
        layout : 'fit',
        excelTitle: '도급경비',
        uniOpt: {
            userToolbar:false,
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
			}
        },
        store: directDetailStore3,
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
					//directDetailStore1 directDetailStore2
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
    
    var agc360ukrRef1Grid = Unilite.createGrid('agc360ukrRef1Grid', {//검색팝업 관련
        layout : 'fit',
        excelTitle: '검색팝업',
    	store: agc360ukrRef1Store,
    	uniOpt: {
    		onLoadSelectFirst: true  
        },
        selModel:'rowmodel',
        columns:  [  
			{ dataIndex: 'AC_YYYYMM'		, width:110, align:'center'},
			{ dataIndex: 'FR_AC_DATE'		, width:80, align:'center'},
			{ dataIndex: 'TO_AC_DATE'		, width:80, align:'center'},
			{ dataIndex: 'EX_DIV_CODE'		, width:80, hidden:true},
			{ dataIndex: 'PJT_CODE'			, width:80, hidden:true},
			{ dataIndex: 'EX_DATE'			, width:80},
			{ dataIndex: 'EX_NUM'			, width:80},
			{ dataIndex: 'J_EX_DATE'		, width:100},
			{ dataIndex: 'DIV_CODE'			, width:80, hidden:false},
			{ dataIndex: 'INPUT_USER_ID'	, width:100},
			{ dataIndex: 'INPUT_DATE'		, width:80},
			{ dataIndex: 'AP_STS'			, width:80, align:'center'}
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
				agc360ukrRef1Grid.returnData(record);
				agc360ukrRef1Window.hide();
				actionFlag='';
				saveFlag = '';
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
			
	  		panelResult.setValue('ST_DATE', UniDate.getDbDateStr(record.get('AC_YYYYMM').replace(/[./|]/gi, ""))+'01') ;
	  		panelResult.setValue('FR_DATE', UniDate.getDbDateStr(record.get('FR_AC_DATE').replace(/[./|]/gi, ""))+'01') ;
	  		panelResult.setValue('TO_DATE', UniDate.getDbDateStr(record.get('TO_AC_DATE').replace(/[./|]/gi, ""))+'01') ;
	  		panelResult.setValue('ACCNT_DIV_CODE',textarray);
	  		panelResult.setValue('AC_PROJECT_CODE',record.get('PJT_CODE'));
			
	  		if(!Ext.isEmpty(record.get('EX_DATE'))) addResult.setValue('AC_DATE',record.get('EX_DATE'));
	  		if(!Ext.isEmpty(record.get('J_EX_DATE'))) addResult.setValue('J_EX_DATE',record.get('J_EX_DATE'));
	  		
       	}
    });
    
    function openAgc360ukrRef1Window() {    		//검색팝업 관련
//  		if(!UniAppManager.app.checkForNewDetail()) return false;
  	
		if(!agc360ukrRef1Window) {
			agc360ukrRef1Window = Ext.create('widget.uniDetailWindow', {
                title: '검색',
                width: 700,				                
                height: 500,
                layout:{type:'vbox', align:'stretch'},
                items: [agc360ukrRef1Search, agc360ukrRef1Grid],
                tbar:  ['->',
					{	
						itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							if(!agc360ukrRef1Search.getInvalidMessage()) return;
							agc360ukrRef1Store.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							agc360ukrRef1Window.hide();
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
		 				agc360ukrRef1Search.setValue('ST_AC_DATE',panelResult.getValue('ST_DATE'));
		 				agc360ukrRef1Search.setValue('FR_AC_DATE',panelResult.getValue('FR_DATE'));
		 				agc360ukrRef1Search.setValue('TO_AC_DATE',panelResult.getValue('TO_DATE'));	
		 				agc360ukrRef1Search.setValue('AC_PROJECT_CODE',panelResult.getValue('AC_PROJECT_CODE'));	
		 				agc360ukrRef1Search.setValue('AC_PROJECT_NAME',panelResult.getValue('AC_PROJECT_NAME'));	
		 				
		 				addResult.down('#btnAutoSlip').setDisabled(false);
		 				addResult.down('#btnCancelSlip').setDisabled(false);
						if(!agc360ukrRef1Search.getInvalidMessage()) return;
						
						agc360ukrRef1Store.loadStoreRecords();
		 			}
		 			
				}
			})
		}
		agc360ukrRef1Window.center();
		agc360ukrRef1Window.show();
    }    
    
    Unilite.Main( {
		borderItems:[
				panelResult, addResult, detailGrid1, detailGrid2, detailGrid3
		],
		id  : 'agc360ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			/*var param = {COMP_CODE: UserInfo.compCode}
			accntCommonService.fnGetStDt(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('THIS_ST_DATE',provider['STDT']);
					
					providerSTDT = provider['STDT'];
				}
			})*/
			panelResult.setValue('FR_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			addResult.setValue('AC_DATE',UniDate.get('today'));
			addResult.setValue('J_EX_DATE',UniDate.get('today'));
			addResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('GUBUN',BsaCodeInfo.gsGubunA093);
			panelResult.setValue('ST_DATE',getStDt[0].STDT);
			if(bBizrefYN == '1'){
				panelResult.setValue('BIZRE','N');
			}else{
				panelResult.setValue('BIZRE','Y');
			}

			SEARCH = '';
		},
		onQueryButtonDown : function()	{
			if( !this.checkForForm2()) {
				return false;
			}else{
	/*		var param= Ext.getCmp('searchForm').getValues();		
			agc360ukrService.fnGetBaseInfo(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					alert(provider[0].MATRL_YN);
				}
				
			})*/
			detailGrid1.getEl().mask('조회 중...','loading-indicator');
			detailGrid2.getEl().mask('조회 중...','loading-indicator');
			detailGrid3.getEl().mask('조회 중...','loading-indicator');
			inLoading = true;
			directDetailStore2.loadStoreRecords();
			panelResult.setAllFieldsReadOnly(true);
			//addResult.down('#btnAutoSlip').setDisabled(true);
			}
			
		},
		onResetButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			addResult.setAllFieldsReadOnly(false);
			addResult.clearForm();
			directDetailStore1.loadData({});
			directDetailStore2.loadData({});
			directDetailStore3.loadData({});
			UniAppManager.setToolbarButtons(['save','deleteAll'],false);
			UniAppManager.setToolbarButtons(['query'],true);
			//Ext.getCmp('btnAutoSlip').setDisabled(true);
			SEARCH = '';
			agreeYn = '';
			inLoading = false;
			saveFlag = '';
			actionFlag = '';
			
			var autoSlipBtn = addResult.down('#btnAutoSlip');
			var cancelSlipBtn = addResult.down('#btnCancelSlip');
			var autoJSlipBtn = addResult.down('#btnAutoJSlip');
			var cancelJSlipBtn = addResult.down('#btnCancelJSlip');
			autoSlipBtn.setDisabled(true);
			cancelSlipBtn.setDisabled(true);
			autoJSlipBtn.setDisabled(true);
			cancelJSlipBtn.setDisabled(true);
			
			this.fnInitBinding();
		},
		checkForForm2:function() { 
			return panelResult.setAllFieldsReadOnly(true);
        },
        onSaveDataButtonDown: function(config) {
     	
        	profitStatusRecords = directDetailStore1.data.items;
        	profitStatusSaveStore.clearData();
			Ext.each(profitStatusRecords, function(record1,i){
				record1.phantom = true;
				profitStatusSaveStore.insert(i, record1);
			});
			
        	produceCostRecords = directDetailStore2.data.items;
        	produceCostSaveStore.clearData();
			Ext.each(produceCostRecords, function(record2,i){
				record2.phantom = true;
				produceCostSaveStore.insert(i, record2);
			});
        	
			
			saveFlag = 'Y';
			profitStatusSaveStore.saveStore();
			
			Ext.getCmp('btnAutoSlip').setDisabled(false);
		},
		onDeleteAllButtonDown: function() {
			
			if(confirm('전체삭제 하시겠습니까?')) {
				var param= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());		
				agc360ukrService.costInformation(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						if(provider.AGREE_YN != 'Y' && Ext.isEmpty(provider.EX_DATE) && Ext.isEmpty(provider.J_EX_DATE)) {
							detailGrid1.getEl().mask('전체삭제 중...','loading-indicator');
							detailGrid2.getEl().mask('전체삭제 중...','loading-indicator');
							detailGrid3.getEl().mask('전체삭제 중...','loading-indicator');
							agc360ukrService.agc360ukrDelA(param, function(provider, response)	{							
								if(provider){	
									UniAppManager.updateStatus(Msg.sMB013);
									
									UniAppManager.app.onResetButtonDown();		
								}
								detailGrid1.getEl().unmask();		
								detailGrid2.getEl().unmask();		
								detailGrid3.getEl().unmask();
								
							});
						} else {
							if(provider.AGREE_YN == 'Y' ) {
								Unilite.messageBox("승인된 전표입니다.");
							} else if(!Ext.isEmpty(provider.EX_DATE) ) {
								Unilite.messageBox("생성된 전표가 있습니다.");
							} else if(!Ext.isEmpty(provider.J_EX_DATE)) {
								Unilite.messageBox("생성된 차감전표가 있습니다.");
							}
						}
					}
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
		    		panelResult.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelResult.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        },
        /**
         * 항목값(기말재고액/비용)이 수정되면 그 항목을 포함하는
		 * 상위항목의 값을 연쇄적으로 변경한다.
         */
        
        fnReCalculation: function(store, record, sLowerOldAmt, grdFlag){
        	var sUpperCD ='';
        	var sUpperOldAmt = 0;
        	var sLowerNewAmt = 0;
        	var sSign = 0;
        	
        	sUpperCD = record.get('UPPER_ACCNT');
        	sLowerNewAmt = parseInt(record.get('AMT_I'));
        	
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
        			
        			sUpperOldAmt = parseInt(item.get('AMT_I'));
        			
        			item.set('AMT_I',sUpperOldAmt - (sSign * sLowerOldAmt) + (sSign * sLowerNewAmt));
        			
        			if(i == store.getCount()-1){
        				if(grdFlag=='grd2'){
			        		UniAppManager.app.fnChangeGrid1();
			        	}
        			}
        		}
        	});
        },
        /**
         * "제조원가" 그리드에서 각 항목의 금액의 변동에 의해 당기제품제조원가 바뀔때
		 * 변동금액을 "손익현황" 그리드에 반영한다.
         */
        
        fnChangeGrid1: function(){
        	var sAccntCD = '2280';
//        	var sOldEditVal1 = 0;
        	/* var sAccntCD = '';
        	
        	sAccntCD = '2280';
        	
        	var findAccnt = directDetailStore1.findBy( function( rec, id ) {
	            if ( rec.get('ACCNT_CD').toLowerCase() == sAccntCD ) {
	                return true;
	            }
	            return false;
	        });
	        
	        if(findAccnt == -1){
	        	
	        	var errCheck = "";
	        	
	        	var param = {"sAccntCD": sAccntCD};
				agc360ukrService.fnDispYN(param, function(provider, response)	{
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
	        }else if(findAccnt != -1){ */
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
	        	
	        //}
	        if(directDetailStore1.isDirty())	{
        		UniAppManager.setToolbarButtons('save',true)    		
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
	        	Ext.Msg.alert(Msg.sMB099,Msg.sMA0169);
	        	
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
						directDetailStore2.uniOpt.isMaster = true;
	        		}
	        	});
	        	
			}
	        if(directDetailStore2.isDirty())	{
        		UniAppManager.setToolbarButtons('save',true)    		
        	}
		},
		
		/**
		 * 현재 그리드에 셋팅되어있는 기말재고액은 agb100t/agb200t에서 가져온 데이터이다.
		 * 이것을 사용자에 의해 수정된 기말재고액(agc300t)으로 replace 한다.
		 */
        fnReplaceCostAmt: function(provider){
        	UniAppManager.app.fnSetCostAmt(directDetailStore2, '1000', provider.COST_MT);
        	UniAppManager.app.fnSetCostAmt(directDetailStore2, '2000', provider.COST_HR);
        	UniAppManager.app.fnSetCostAmt(directDetailStore2, '3000', provider.COST_EX);
        	UniAppManager.app.fnSetCostAmt(directDetailStore2, '2800', provider.COST_OS);
        	UniAppManager.app.fnSetCostAmt(directDetailStore2, '2900', provider.COST_HT);
        	UniAppManager.app.fnSetCostAmt(directDetailStore2, '7000', provider.COST_PRCD);
        	
        	UniAppManager.app.fnSetCostAmt(directDetailStore1, '2280', provider.COST_CD);
        	
        },
        
        fnSetCostAmt: function(store, sAccntCd, lNewAmt){
        	Ext.each(store.data.items, function(record, i){
        		if(record.get('ACCNT_CD') == sAccntCd){
        			var lOldAmt = 0;
        			lOldAmt = record.get('AMT_I');
        			
        			record.set('AMT_I',lNewAmt);	
        			
        			
        			/*  if(store.storeId == "agc360ukrDetailStore1"){
        				UniAppManager.app.fnReCalculation(store, record, lOldAmt, 'grd1');
        			}else if(store.storeId == "agc360ukrDetailStore2"){
        				UniAppManager.app.fnReCalculation(store, record, lOldAmt, 'grd2');
        			} */
        			
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
        },
        activateSlipButtons:function(useMessage, itemId)	{
        	var param= Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());		
			agc360ukrService.costInformation(param, function(provider, response){
				agreeYn = '';
				if(Ext.isEmpty(provider) && directDetailStore2.getCount() == 0 && directDetailStore3.getCount() == 0){
					Unilite.messageBox("해당자료가 없습니다.");	
					UniAppManager.setToolbarButtons(['deleteAll'],false);
					UniAppManager.setToolbarButtons(['query'],true);
				}else{
					
					if(!Ext.isEmpty(provider)  && SEARCH == 'SEARCH') {
						UniAppManager.app.fnReplaceCostAmt(provider);
					}
					var autoSlipBtn = addResult.down('#btnAutoSlip');
					var cancelSlipBtn = addResult.down('#btnCancelSlip');
					var autoJSlipBtn = addResult.down('#btnAutoJSlip');
					var cancelJSlipBtn = addResult.down('#btnCancelJSlip');
					autoSlipBtn.setDisabled(false);
					cancelSlipBtn.setDisabled(false);
					autoJSlipBtn.setDisabled(false);
					cancelJSlipBtn.setDisabled(false);
					
					UniAppManager.setToolbarButtons(['query'],false);
					if(Ext.isEmpty(provider)){
						//도급원가대체정보가 없을 경우
						//autoSlipBtn.setDisabled(true);
						//cancelSlipBtn.setDisabled(true);
						//autoJSlipBtn.setDisabled(true);
						//cancelJSlipBtn.setDisabled(true);
						UniAppManager.setToolbarButtons(['query'],true);
					}else{
						if(provider.AGREE_YN == 'Y'){
							//autoSlipBtn.setDisabled(true);
							//cancelSlipBtn.setDisabled(true);
							//autoJSlipBtn.setDisabled(true);
							//cancelJSlipBtn.setDisabled(true);
							UniAppManager.setToolbarButtons(['deleteAll'],false);
							if(useMessage){
								if(itemId == 'btnCancelSlip' || itemId == 'btnCancelJSlip')	{
									Unilite.messageBox('이미 승인된 전표입니다.');
								}
							}
							agreeYn = 'Y';
						}else if(!Ext.isEmpty(provider.EX_DATE) && !Ext.isEmpty(provider.J_EX_DATE) ){
							//autoSlipBtn.setDisabled(true);
							//cancelSlipBtn.setDisabled(false);
							//autoJSlipBtn.setDisabled(true);
							//cancelJSlipBtn.setDisabled(false);
							UniAppManager.setToolbarButtons(['deleteAll'],false);
							if(useMessage){
								if(itemId == 'btnAutoSlip')	{
									Unilite.messageBox('이미 생성된 전표가 있습니다.');
								}
								if(itemId == 'btnAutoJSlip')	{
									Unilite.messageBox('이미 생성된 차감전표가 있습니다.');
								}
							}
						}else if(!Ext.isEmpty(provider.EX_DATE) && Ext.isEmpty(provider.J_EX_DATE) ){
							//autoSlipBtn.setDisabled(true);
							//cancelSlipBtn.setDisabled(false);
							//autoJSlipBtn.setDisabled(false);
							//cancelJSlipBtn.setDisabled(true);
							UniAppManager.setToolbarButtons(['deleteAll'],false);
							if(useMessage){
								if(itemId == 'btnCancelSlip')	{
									Unilite.messageBox('생성된 전표가 없습니다.');
								}
								if(itemId == 'btnCancelJSlip')	{
									Unilite.messageBox('생성된 차감전표가 없습니다.');
								}
							}
						}else if(!Ext.isEmpty(provider.J_EX_DATE) ){
							UniAppManager.setToolbarButtons(['deleteAll'],false);
						}else{
							//autoSlipBtn.setDisabled(false);
							//cancelSlipBtn.setDisabled(true);
							//autoJSlipBtn.setDisabled(true);
							//cancelJSlipBtn.setDisabled(true);
							UniAppManager.setToolbarButtons(['deleteAll'],true);
							if(useMessage){
								if(itemId == 'btnCancelSlip' || itemId == 'btnCancelJSlip')	{
									Unilite.messageBox('생성된 전표가 없습니다.');
								}
							}
						}
						
						
					}	
				}
				SEARCH = '';
			});
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
						rv="대체금액은 발생금액을 초과할 수 없습니다.";	
						
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
