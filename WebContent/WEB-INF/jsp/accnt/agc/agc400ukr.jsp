<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agc400ukr">
	<t:ExtComboStore comboType="BOR120" pgmId="agc400ukr" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"		comboCode="B004" />		<!-- 자사화폐 -->
	<t:ExtComboStore comboType="AU"		comboCode="A242" />		<!-- 구분 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">
var agc400ukrRef1Window ;

function appMain() {
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'agc400ukrService.selectList',
			update: 'agc400ukrService.updateList',
			create: 'agc400ukrService.insertList',
			destroy: 'agc400ukrService.deleteList',
			syncAll: 'agc400ukrService.saveAll'
		}
	});	
	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('agc400ukrModel', {
		fields: [
			{name: 'COMP_CODE' 			, text: '법인코드'			,type: 'string', editable:false},
			{name: 'AC_YYYYMM' 			, text: '평가년월  '		,type: 'string', editable:false},
			{name: 'DIV_CODE'   		, text: '사업장코드'		,type: 'string', comboType:'BOR120', editable:false},
			{name: 'GUBUN' 				, text: '구분 '			,type: 'string', editable:false},
			{name: 'MONEY_UNIT' 		, text: '화폐단위 '		,type: 'string', editable:false},
			{name: 'ACCNT'   			, text: '계정코드'			,type: 'string', editable:false},
			{name: 'ACCNT_NAME'   		, text: '계정과목명'		,type: 'string', editable:false},
			{name: 'D_DIV_CODE'   		, text: '사업장코드'		,type: 'string', comboType:'BOR120', editable:false},
			{name: 'D_MONEY_UNIT' 		, text: '화폐단위 '		,type: 'string', editable:false},
			{name: 'D_ACCNT'   			, text: '계정코드'			,type: 'string', editable:false},
			{name: 'D_ACCNT_NAME'   	, text: '계정과목명'		,type: 'string', editable:false},
			{name: 'SEQ'   				, text: '순번'			,type: 'int'   , editable:false},
			{name: 'D_CUSTOM_CODE'   	, text: '거래처코드'		,type: 'string', editable:false},
			{name: 'D_CUSTOM_NAME'   	, text: '거래처명'			,type: 'string', editable:false},
			{name: 'JAN_FOR_AMT'  		, text: '외화잔액'			,type: 'uniFC', editable:false},
			{name: 'EXCHG_RATE_O'		, text: '(발생시점)환율'	,type: 'uniER'},
			
			{name: 'JAN_AMT'			, text: '발생평가원화'		,type: 'uniPrice'},
			{name: 'EVAL_EXCHG_RATE'	, text: '평가환율'			,type: 'uniER'},
			{name: 'EVAL_JAN_AMT'		, text: '평가원화'			,type : 'float', format:'0,000.00'	, decimalPrecision : 2},
			{name: 'EVAL_DIFF_AMT'  	, text: '평가차액'			,type: 'uniPrice'},
			
			{name: 'EX_DATE' 			, text: 'EX_DATE  '		,type: 'uniDate', editable:false},
			{name: 'J_EX_DATE' 			, text: 'J_EX_DATE  '	,type: 'uniDate', editable:false},
			{name: 'ORG_AC_DATE' 		, text: '전표일  '			,type: 'uniDate', editable:false},
			{name: 'ORG_SLIP_NUM' 		, text: '전표번호  '		,type: 'int', editable:false}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agc400ukrMasterStore', {
		model: 'agc400ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			allDeletable: true,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		// 신규데이터 가져오기
		loadStoreRecords: function() {
			var checkParam = Ext.getCmp('searchForm').getValues();	
			checkParam.FLAG = "SEARCH";
			directMasterStore.loadData({});
			directMasterStore.commitChanges();
			// 저장된 데이터가 있는지 체크
			agc400ukrService.selectList(checkParam, function(responseText){
				if(responseText && responseText.length > 0)	{  
					// 저장된 데어터가 있으모로 검색팝업을 띄운다.
					Ext.getCmp('btnLinkDtl').handler();
				} else {
					 // 저장된 데어터가 없으모로 신규데이터를 조회한다.
					var param= Ext.getCmp('searchForm').getValues();			
					directMasterStore.load({
						params : param,
						callback: function(records, operation, success) {
							if(records && records.length > 0 )	{
								directMasterStore.setFlag(records);
							}
						}
					});
				}
			})
		},
		//검색 창에서 호출됨 (저장된 데이터 조회)
		loadStoreSearchRecords: function(param) {	
			panelResult.setDisableForm(true);
			panelSearch.setDisableForm(true);
			console.log( param );
			this.load({
				params : param.data,
				callback: function(records, operation, success) {
					if(records && records.length > 0 )	{
						addResult.down('#btnAutoSlip').setDisabled(false);
		 				addResult.down('#btnCancelSlip').setDisabled(false);
		 				addResult.down('#btnAutoJSlip').setDisabled(false);
		 				addResult.down('#btnCancelJSlip').setDisabled(false);
					} else {
						addResult.down('#btnAutoSlip').setDisabled(true);
		 				addResult.down('#btnCancelSlip').setDisabled(true);
		 				addResult.down('#btnAutoJSlip').setDisabled(true);
		 				addResult.down('#btnCancelJSlip').setDisabled(true);
					}
				}
			});
		},
		saveStore : function()	{	
			var paramMaster = panelResult.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				config = {
						useSavedMessage : false,
						params: [paramMaster],
						success: function(batch, option) {
							addResult.down('#btnAutoSlip').setDisabled(false);
			 				addResult.down('#btnCancelSlip').setDisabled(false);
			 				addResult.down('#btnAutoJSlip').setDisabled(false);
			 				addResult.down('#btnCancelJSlip').setDisabled(false);
						}
					};
					this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		setFlag : function(records) {
			if(records && records.length > 0)	{
				Ext.each(records, function(record, idx){
					if(record.get("FLAG") == "S")	{
						record.set("FLAG", "N");
					}
				});
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
		collapsed:true,
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
			items: [{
				fieldLabel: '평가년월',
				xtype: 'uniMonthfield',
				name: 'AC_YYYYMM',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_YYYYMM', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
				value:UserInfo.divCode,
				allowBlank:false,
				comboType:'BOR120',
				//width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '구분',
				name:'GUBUN', 
				xtype: 'uniCombobox',
				allowBlank:false,
				comboType:'AU',
				comboCode:'A242',
				//width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('GUBUN', newValue);
					}
				}
			},
			{
				xtype : 'container',
				layout : {type :'uniTable', columns:2},
				items:[
					{
						fieldLabel: '통화코드',
						name:'MONEY_UNIT', 
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'B004',
						allowBlank:false,
						colspan:2,
						//width: 325,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('MONEY_UNIT', newValue);
								var moneyUnit = newValue;
					    		var acDate	  = UniDate.get('endOfMonth', panelSearch.getValue("AC_YYYYMM"));
					    		
					    		if(Ext.isEmpty(moneyUnit)) {
					    			panelResult.setValue('EXCHG_RATE_EVAL', 0.00);
					    			return;
					    		}
					    		
					    		if(moneyUnit == 'KRW') {
					    			panelResult.setValue('EXCHG_RATE_EVAL', 1);
					    		}
					    		else {
						    		var param = {
										'AC_DATE'	: UniDate.getDbDateStr(acDate),
										'MONEY_UNIT': moneyUnit
									};
									
									agc400ukrService.fnGetExchgRate(param, function(provider, response) {
										console.log("provider : ", provider);
										if(provider){
											panelResult.setValue('EXCHG_RATE_EVAL', provider[0].BASE_EXCHG);
											panelSearch.setValue('EXCHG_RATE_EVAL', provider[0].BASE_EXCHG);
										}
									});
					    		}
							}
						}
					},{
						fieldLabel: ' ',
						labelWidth : 90,
						width: 250,
						name:'EXCHG_RATE_EVAL', 
						xtype: 'uniNumberfield',
						type: 'uniER',
						value: 0,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('EXCHG_RATE_EVAL', newValue);
							}
						}
					},{
						xtype: 'button',
				    	text: '적용',
				    	width: 50,
				    	margin: '0 0 0 0',
				    	handler : function() {
				    		var grid = Ext.getCmp('agc400ukrGrid');
				    		var moneyUnit = panelResult.getValue('MONEY_UNIT');
				    		var exchgRate = panelResult.getValue('EXCHG_RATE_EVAL');
				    		
				    		if(Ext.isEmpty(moneyUnit) || Ext.isEmpty(exchgRate)) {
				    			Unilite.messageBox('평가를 위한 화폐단위와 환율을 확인하여주십시오.');
				    		}
				    		
				    		grid.fnApplyEvalExchgRate(moneyUnit, exchgRate);
				    	}
					}
				]
			},
			Unilite.popup('ACCNT',{ 
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCNT',
				textFieldName: 'ACCNT_NAME',
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME', newValue);				
					},
					applyExtParam:{
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : 'FOR_YN = \'Y\'',
								'CHARGE_CODE': ''
							}
							popup.setExtParam(param);
						}
					}
				}
			})]
		}],
		setDisableForm : function(disable) {
			var me = this;
			me.getField("AC_YYYYMM").setReadOnly(disable);
			me.getField("DIV_CODE").setReadOnly(disable);
			me.getField("GUBUN").setReadOnly(disable);
			me.getField("MONEY_UNIT").setReadOnly(disable);
			me.getField("ACCNT").setReadOnly(disable);
			me.getField("ACCNT_NAME").setReadOnly(disable);
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm', {
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '평가년월',
			xtype: 'uniMonthfield',
			name: 'AC_YYYYMM',
			width: 250,
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AC_YYYYMM', newValue);
				}
			}
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
			allowBlank:false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			width: 250,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '구분',
			name:'GUBUN', 
			xtype: 'uniCombobox',
			width: 250,
			allowBlank:false,
			comboType:'AU',
			comboCode:'A242',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('GUBUN', newValue);
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			tdAttrs: {align : 'right',width:'100%', style:'padding-right:10px;'},
			items :[{
		    	xtype: 'button',
	    		text: '검색',	
	    		id: 'btnLinkDtl',
	    		name: 'LINKDTL',
	    		width: 100,	
				handler : function(field, newValue, oldValue, eOpts) {
					if(UniAppManager.app._needSave())	{
			  			if(confirm("저장할 내용이 있습니다. 저장 하시겠습니까?"))	{
			  				UniAppManager.app.onSaveDataButtonDown();
			  			} else {
			  				openAgc400ukrRef1Window();
			  			}
			  		} else {
						openAgc400ukrRef1Window();
			  		}
				}
		    }]
    	},{
			fieldLabel: '통화코드',
			name:'MONEY_UNIT', 
			xtype: 'uniCombobox',
			comboType:'AU',
			allowBlank:false,
			comboCode:'B004',
			width: 250,
			//width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('MONEY_UNIT', newValue);
					var moneyUnit = newValue;
		    		var acDate	  = UniDate.get('endOfMonth', panelSearch.getValue("AC_YYYYMM"));
		    		
		    		if(Ext.isEmpty(moneyUnit)) {
		    			panelResult.setValue('EXCHG_RATE_EVAL', 0.00);
		    			return;
		    		}
		    		
		    		if(moneyUnit == 'KRW') {
		    			panelResult.setValue('EXCHG_RATE_EVAL', 1);
		    		}
		    		else {
			    		var param = {
							'AC_DATE'	: UniDate.getDbDateStr(acDate),
							'MONEY_UNIT': moneyUnit
						};
						
						agc400ukrService.fnGetExchgRate(param, function(provider, response) {
							console.log("provider : ", provider);
							if(provider){
								panelResult.setValue('EXCHG_RATE_EVAL', provider[0].BASE_EXCHG);
								panelSearch.setValue('EXCHG_RATE_EVAL', provider[0].BASE_EXCHG);
							}
						});
		    		}
				}
			}
		},
		Unilite.popup('ACCNT',{ 
			fieldLabel: '계정과목', 
			valueFieldName: 'ACCNT',
			textFieldName: 'ACCNT_NAME',
			autoPopup:true,
			colspan : 3,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME', newValue);				
				},
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : 'FOR_YN = \'Y\'',
							'CHARGE_CODE': ''
						}
						popup.setExtParam(param);
					}
				}
			}
		}),{
			fieldLabel: ' ',
			labelWidth : 90,
			width: 250,
			name:'EXCHG_RATE_EVAL', 
			xtype: 'uniNumberfield',
			type: 'uniER',
			value: 0,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('EXCHG_RATE_EVAL', newValue);
				}
			}
		},{
			xtype: 'button',
	    	text: '적용',
	    	tdAttrs:{style:'padding-left : 3px;padding-bottom : 1px;'},
	    	width: 50,
	    	colspan :3,
	    	margin: '0 0 0 0',
	    	handler : function() {
	    		var grid = Ext.getCmp('agc400ukrGrid');
	    		var moneyUnit = panelResult.getValue('MONEY_UNIT');
	    		var exchgRate = panelResult.getValue('EXCHG_RATE_EVAL');
	    		
	    		if(Ext.isEmpty(moneyUnit) || Ext.isEmpty(exchgRate)) {
	    			Unilite.messageBox('평가를 위한 화폐단위와 환율을 확인하여주십시오.');
	    		}
	    		
	    		grid.fnApplyEvalExchgRate(moneyUnit, exchgRate);
	    	}
		}],
		setDisableForm : function(disable) {
			var me = this;
			me.getField("AC_YYYYMM").setReadOnly(disable);
			me.getField("DIV_CODE").setReadOnly(disable);
			me.getField("GUBUN").setReadOnly(disable);
			me.getField("MONEY_UNIT").setReadOnly(disable);
			me.getField("ACCNT").setReadOnly(disable);
			me.getField("ACCNT_NAME").setReadOnly(disable);
		}
	});
	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 6, tableAttrs: {width: '100%', style:'padding-bottom:5px'}
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
			//tdAttrs:{width: 325},
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
			fieldLabel: '귀속사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value : UserInfo.divCode,
			//tdAttrs:{width: 225},
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
			xtype:'component',
			html :'&nbsp;',
			tdAttrs :{width : 300}
		},{ 
			fieldLabel: '전표일',
			name:'S_AC_DATE',
			xtype: 'uniDatefield',
			readOnly : true,
			tdAttrs:{width: 325}
		},{ 
			fieldLabel: '전표번호',
			name:'S_EX_NUM',
			xtype: 'uniNumberfield',
			readOnly : true,
			width : 200,
			labelWidth :70,
			tdAttrs:{width: 200}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			tdAttrs: {align : 'right'/*,width:'100%'*/, style:'padding-right:10px;'},
			items :[{
				xtype:'button',
				text:'환평가기표',
	    		id: 'btnAutoSlip',
	    		itemId: 'btnAutoSlip',
	    		width: 130,	
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
								'PGM_ID' : 'agc400ukr',
								'sGubun' : '92',
								'AC_YYYYMM': UniDate.getMonthStr(panelResult.getValue('AC_YYYYMM')),	//평가월
								'GUBUN':panelResult.getValue('GUBUN'),
								'MONEY_UNIT':panelResult.getValue('MONEY_UNIT'),
								'ACCNT' : panelResult.getValue('ACCNT'),
								'AC_DATE': UniDate.getDbDateStr(addResult.getValue('AC_DATE')),	//결의전표일
								'DIV_CODE': addResult.getValue('DIV_CODE')
							}
							var rec1 = {data : {prgID : 'agj260ukr', 'text':''}};							
							parent.openTab(rec1, '/accnt/agj260ukr.do', params);
		                	
		                });
		            }
				}
			},{
				xtype:'button',
				text:'환평가기표취소',
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
									'AC_YYYYMM': UniDate.getMonthStr(panelResult.getValue('AC_YYYYMM')),	//평가월
									'GUBUN':panelResult.getValue('GUBUN'),
									'MONEY_UNIT':panelResult.getValue('MONEY_UNIT'),
									'ACCNT' : panelResult.getValue('ACCNT'),
									'AC_DATE': UniDate.getDbDateStr(addResult.getValue('AC_DATE')),	//결의전표일
									'DIV_CODE': addResult.getValue('DIV_CODE')
							}
							agj260ukrService.cancelAutoSlip92(
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
			xtype:'component',
			html :'&nbsp;',
			tdAttrs :{width : 300}
		},{ 
			fieldLabel: '전표일',
			name:'S_J_EX_DATE',
			xtype: 'uniDatefield',
			readOnly : true,
			tdAttrs:{width: 325}
		},{ 
			fieldLabel: '전표번호',
			name:'S_J_EX_NUM',
			xtype: 'uniNumberfield',
			readOnly : true,
			width : 200,
			labelWidth :70,
			tdAttrs:{width: 200}
		},{
		xtype	: 'container',
		layout	: {type : 'uniTable', column:2},
		tdAttrs	: {align: 'right', style:'padding-right:10px;'},
		width	: 320,
		items	: [{				   
				xtype	: 'button',
				text	: '환평가차감기표',
				itemId  : 'btnAutoJSlip',
	    		disabled: true,
		 		tdAttrs	: {align: 'right'},
				width	: 130,
				handler : function() {
					if(UniAppManager.app._needSave()){						
						Unilite.messageBox("저장할 내용이 있습니다. 저장 후에 자동기표를 실행 하세요.");
						return false;
					}
					if(Ext.isEmpty(addResult.getValue("J_EX_DATE")))	{
						Unilite.messageBox("차감전표일은 필수 입력입니다.");
						return;
					}
					var params = {							
							'AC_YYYYMM': UniDate.getMonthStr(panelResult.getValue('AC_YYYYMM')),	//평가월
							'GUBUN':panelResult.getValue('GUBUN'),
							'MONEY_UNIT':panelResult.getValue('MONEY_UNIT'),
							'ACCNT' : panelResult.getValue('ACCNT'),
							'AC_DATE': UniDate.getDbDateStr(addResult.getValue('AC_DATE')),	//결의전표일
							'DIV_CODE': addResult.getValue('DIV_CODE'),
							'EX_DATE' : UniDate.getDbDateStr(addResult.getValue("J_EX_DATE"))
						}
					Ext.getBody().mask();
					agj260ukrService.spAutoSlip93(params, function(provider, response){
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
						'PGM_ID' : 'agc400ukr',
						'sGubun' : '93',
						'AC_YYYYMM': UniDate.getMonthStr(panelResult.getValue('AC_YYYYMM')),	//평가월
						'GUBUN':panelResult.getValue('GUBUN'),
						'MONEY_UNIT':panelResult.getValue('MONEY_UNIT'),
						'ACCNT' : panelResult.getValue('ACCNT'),
						'AC_DATE': UniDate.getDbDateStr(addResult.getValue('AC_DATE')),	//결의전표일
						'DIV_CODE': addResult.getValue('DIV_CODE'),
						'EX_DATE' : UniDate.getDbDateStr(addResult.getValue("J_EX_DATE"))
					}
					
					agj260ukrService.spAutoSlip93cancel(params, function (provider,response) {
						if(provider && Ext.isEmpty(provider.ERROR_DESC) )	{
							UniAppManager.setToolbarButtons(['deleteAll'],true);
							UniAppManager.updateStatus('자동기표를 취소하였습니다.');	
							
						}else{
							return false;
						}
					
		            	
		            });	
					
				}
			}]
		}]
	});


	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agc400ukrGrid', {
		layout : 'fit',
		region : 'center',
		uniOpt : {	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		store: directMasterStore,
//		features: [{
//			id: 'masterGridSubTotal',
//			ftype: 'uniGroupingsummary', 
//			showSummaryRow: false 
//		},{
//			id: 'masterGridTotal', 	
//			ftype: 'uniSummary', 	  
//			showSummaryRow: true
//		}],
		selModel:'rowmodel',
		columns: [
			{dataIndex: 'DIV_CODE'   		, width: 100	},
			{dataIndex: 'D_ACCNT'   			, width: 100	, align : 'center'		},
			{dataIndex: 'D_ACCNT_NAME'   		, width: 200	},
			{dataIndex: 'D_CUSTOM_CODE'		, width: 100	, align : 'center'		},
			{dataIndex: 'D_CUSTOM_NAME'  		, width: 200	},
			{dataIndex: 'D_MONEY_UNIT'  		, width:  80	},
			{dataIndex: 'ORG_AC_DATE'  			, width:  80	},
			{dataIndex: 'ORG_SLIP_NUM'  		, width:  80	},
			{dataIndex: 'JAN_FOR_AMT'   	, width: 130	},
			{dataIndex: 'EXCHG_RATE_O'		, width: 130	},
			{dataIndex: 'JAN_AMT'  			, width: 130	},
			{dataIndex: 'EVAL_EXCHG_RATE'	, width: 130	},
			{dataIndex: 'EVAL_JAN_AMT'  	, width: 130	},
			{dataIndex: 'EVAL_DIFF_AMT'  	, width: 130	}
		],
		fnApplyEvalExchgRate: function(moneyUnit, exchgRate) {
			Ext.each(directMasterStore.data.items, function(record, index) {
				if(record.get('MONEY_UNIT') == moneyUnit && Ext.isEmpty(record.get('EX_DATE')) && Ext.isEmpty(record.get('J_EX_DATE')) ) {
					var janAmt		= Number(record.get('JAN_AMT'));
					var janEvalAmt	= Number(record.get('JAN_FOR_AMT'));
					var diffAmt		= janAmt;
					
					janEvalAmt	= janEvalAmt * Number(exchgRate);
					diffAmt		= janEvalAmt - janAmt;
					
					record.set('EVAL_EXCHG_RATE', exchgRate);
					record.set('EVAL_JAN_AMT'	, janEvalAmt);
					record.set('EVAL_DIFF_AMT'	, Math.round(diffAmt));
				}
			});
			
        }
	});
	
    var agc400ukrRef1Search = Unilite.createSearchForm('agc400ukrRef1Form', {//검색팝업관련
		layout :  {type : 'uniTable', columns : 3
//			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
		},
    	items :[{ 
			fieldLabel: '평가월',
	        xtype: 'uniMonthfield',
	        name: 'AC_YYYYMM',
	        allowBlank : false
        },{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
//	        multiSelect: true, 
//	        typeAhead: false,
//	        value:UserInfo.divCode,
	        comboType:'BOR120'
//			width: 325
		},{
			fieldLabel: '통화코드',
			name:'MONEY_UNIT', 
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B004'
		}]
    });
    Unilite.defineModel('Agc400ukrRef1Model', {	//검색팝업관련
	    fields: [
	    	{name: 'DIV_CODE'			,text: '사업장'			,type: 'string', comboType:'BOR120'},
			{name: 'AC_YYYYMM'			,text: '평가월'			,type: 'string'},
			{name: 'GUBUN'				,text: '구분'				,type: 'string'},
			{name: 'MONEY_UNIT'			,text: '평가통화'			,type: 'string' ,comboType:'AU', comboCode:'B004' },
			{name: 'ACCNT'				,text: '계정코드'			,type: 'string'},
			{name: 'ACCNT_NAME'			,text: '계정명'			,type: 'string'},
			{name: 'EVAL_DIFF_AMT'		,text: '평가차액'			,type: 'uniPrice'},
			{name: 'EX_DATE'			,text: '결의일'			,type: 'uniDate'},
			{name: 'EX_NUM'				,text: '결의번호'			,type: 'int'},
			{name: 'AGREE_YN'			,text: '환평가전표승인여부'	,type: 'string'},
			{name: 'J_EX_DATE'			,text: '차감결의일'		,type: 'uniDate'},
			{name: 'J_EX_NUM'			,text: '차감결의번호'		,type: 'int'},
			{name: 'INPUT_USER_NAME'	,text: '입력자'			,type: 'string'},
			{name: 'INPUT_DATE'			,text: '입력일'			,type: 'uniDate'},
			{name: 'FLAG'				,text: 'FLAG'			,type: 'string', defaultValue : 'SEARCH'}
	    ]
	});
	var agc400ukrRef1Store = Unilite.createStore('agc400ukrRef1Store', {//검색팝업관련
		model: 'Agc400ukrRef1Model',
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
            	read: 'agc400ukrService.selectRef1'                	
            }
        },
       
        loadStoreRecords : function()	{
			var param= agc400ukrRef1Search.getValues();	
//			param.CHARGE_DIVI = gsChargeDivi;
			this.load({
				params : param
			});
		},
	});
    var agc400ukrRef1Grid = Unilite.createGrid('agc400ukrRef1Grid', {//검색팝업 관련
        layout : 'fit',
        excelTitle: '검색팝업',
    	store: agc400ukrRef1Store,
    	uniOpt: {
    		onLoadSelectFirst: true  
        },
        selModel:'rowmodel',
        columns:  [  
        	
        	{ dataIndex: 'AC_YYYYMM'		, width:110, align:'center'},
			{ dataIndex: 'MONEY_UNIT'		, width:80},
			{ dataIndex: 'ACCNT'			, width:80},
        	{ dataIndex: 'ACCNT_NAME'		, width:110},
			{ dataIndex: 'EVAL_DIFF_AMT'	, width:120},
			{ dataIndex: 'EX_DATE'			, width:80},
			{ dataIndex: 'EX_NUM'			, width:80},
			{ dataIndex: 'J_EX_DATE'		, width:100},
			{ dataIndex: 'J_EX_NUM'			, width:100},
			{ dataIndex: 'DIV_CODE'			, width:100},
			{ dataIndex: 'INPUT_USER_NAME'	, width:100},
			{ dataIndex: 'INPUT_DATE'		, width:80},
			{ dataIndex: 'AGREE_YN'			, width:80, align:'center'}
		], 
		listeners: {	
			onGridDblClick:function(grid, record, cellIndex, colName) {
				agc400ukrRef1Grid.returnData(record);
				agc400ukrRef1Window.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
      			record = this.getSelectedRecord();
      		}
			
			var acYYYYMM = record.get('AC_YYYYMM').replace(".","");
	  		panelResult.setValue('AC_YYYYMM', acYYYYMM) ;
	  		panelResult.setValue('DIV_CODE',record.get('DIV_CODE'));
	  		panelResult.setValue('MONEY_UNIT',record.get('MONEY_UNIT')); 
	  		panelResult.setValue('GUBUN',record.get('GUBUN'));
	  		panelResult.setValue('ACCNT',record.get('ACCNT'));
	  		panelResult.setValue('ACCNT_NAME',record.get('ACCNT_NAME'));
	  		
	  		panelSearch.setValue('AC_YYYYMM', acYYYYMM) ;
	  		panelSearch.setValue('DIV_CODE',record.get('DIV_CODE'));
	  		panelSearch.setValue('MONEY_UNIT',record.get('MONEY_UNIT')); 
	  		panelSearch.setValue('GUBUN',record.get('GUBUN'));
	  		panelSearch.setValue('ACCNT',record.get('ACCNT'));
	  		panelSearch.setValue('ACCNT_NAME',record.get('ACCNT_NAME'));
	  		
	  		if(!Ext.isEmpty(record.get('EX_DATE'))) {
	  			addResult.setValue('AC_DATE',record.get('EX_DATE'));
	  			addResult.setValue('S_AC_DATE',record.get('EX_DATE'));
	  			addResult.setValue('S_EX_NUM',record.get('EX_NUM'));
	  		}
	  		if(!Ext.isEmpty(record.get('J_EX_DATE'))) {
	  			addResult.setValue('J_EX_DATE',record.get('J_EX_DATE'));
	  			addResult.setValue('S_J_EX_DATE',record.get('J_EX_DATE'));
	  			addResult.setValue('S_J_EX_NUM',record.get('J_EX_NUM'));
	  		}
	  		setTimeout(directMasterStore.loadStoreSearchRecords(record), 500);
       	}
    });
    
    function openAgc400ukrRef1Window() {    		//검색팝업 관련
//		if(!UniAppManager.app.checkForNewDetail()) return false;
	
	if(!agc400ukrRef1Window) {
		agc400ukrRef1Window = Ext.create('widget.uniDetailWindow', {
            title: '검색',
            width: 1000,				                
            height: 500,
            layout:{type:'vbox', align:'stretch'},
            items: [agc400ukrRef1Search, agc400ukrRef1Grid],
            tbar:  ['->',
				{	
					itemId : 'saveBtn',
					text: '조회',
					handler: function() {
						if(!agc400ukrRef1Search.getInvalidMessage()) return;
						agc400ukrRef1Store.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '닫기',
					handler: function() {
						agc400ukrRef1Window.hide();
					},
					disabled: false
				}
			],
            listeners : {
	 			show: function ( panel, eOpts )	{
	 				agc400ukrRef1Search.setValue('AC_YYYYMM',panelResult.getValue('AC_YYYYMM'));
	 				agc400ukrRef1Search.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
	 				agc400ukrRef1Search.setValue('MONEY_UNIT',panelResult.getValue('MONEY_UNIT'));	
	 				
	 				addResult.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
	 				/* addResult.down('#btnAutoSlip').setDisabled(false);
	 				addResult.down('#btnCancelSlip').setDisabled(false);
	 				addResult.down('#btnAutoJSlip').setDisabled(false);
	 				addResult.down('#btnCancelJSlip').setDisabled(false); */
					if(!agc400ukrRef1Search.getInvalidMessage()) return;
					
					agc400ukrRef1Store.loadStoreRecords();
	 			}
	 			
			}
		})
	}
	agc400ukrRef1Window.center();
	agc400ukrRef1Window.show();
}    
	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult,  addResult
			]
		},
			panelSearch  	
		],
		id : 'agc400ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail'], false);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('AC_YYYYMM',UniDate.get('today'));
			panelResult.setValue('AC_YYYYMM',UniDate.get('today'));
			
			panelSearch.setValue('GUBUN',"1");
			panelResult.setValue('GUBUN',"1");
			
			addResult.setValue('AC_DATE', UniDate.today())
			addResult.setValue('J_EX_DATE', UniDate.today())
			addResult.setValue('DIV_CODE', UserInfo.divCode)
			
			addResult.down('#btnAutoSlip').setDisabled(true);
			addResult.down('#btnCancelSlip').setDisabled(true);
			addResult.down('#btnAutoJSlip').setDisabled(true);
			addResult.down('#btnCancelJSlip').setDisabled(true);
				
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}
			else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_YYYYMM');
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}
			else {
				directMasterStore.loadStoreRecords();
			}
		},
		onDeleteDataButtonDown: function() {
			
			var selRow = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow.get("EX_DATE")) || !Ext.isEmpty(selRow.get("J_EX_DATE")))	{
				Unilite.messageBox("생성된 전표가 있어 삭제 할 수 없습니다.");
				return;
			}
			masterGrid.deleteSelectedRow();
			
		},
		onDeleteAllButtonDown : function()	{
			if(panelSearch.getInvalidMessage())	{
				if(confirm("저장된 데이터가 삭제됩니다. 그래도 하시겠습니까?’"))	{
					var param = panelSearch.getValues();
					agc400ukrService.deleteAll(param, function(responseText, response){
						if(responseText)	{
							UniAppManager.updateStatus("삭제되었습니다.");
							UniAppManager.app.onResetButtonDown();
						}
				    })
				}
			}
		} ,
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onResetButtonDown : function() {
			panelResult.setDisableForm(false);
			panelSearch.setDisableForm(false);
			panelResult.clearForm();
			panelSearch.clearForm();
			addResult.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
		}
	});
};
</script>
