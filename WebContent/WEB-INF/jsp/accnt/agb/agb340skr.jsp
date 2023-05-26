<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agb340skr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb340skr" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"		comboCode="B004" />		<!-- 자사화폐 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb340skrModel', {
		fields: [
			{name: 'COMP_CODE' 			, text: '법인코드'		,type: 'string'},
			{name: 'DIV_CODE'   		, text: '사업장코드'		,type: 'string', comboType:'BOR120'},
			{name: 'ACCNT'   			, text: '계정코드'		,type: 'string'},
			{name: 'ACCNT_NAME'   		, text: '계정과목명'		,type: 'string'},
			{name: 'CUSTOM_CODE'   		, text: '거래처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME'   		, text: '거래처명'		,type: 'string'},
			{name: 'MONEY_UNIT'   		, text: '화폐단위'		,type: 'string'},
			{name: 'JAN_FOR_AMT'  		, text: '외화잔액'		,type: 'uniFC'},
			{name: 'EXCHG_RATE_O'		, text: '(발생시점)환율'	,type: 'uniER'},
			{name: 'JAN_AMT'			, text: '발생평가원화'	,type: 'uniPrice'},
			{name: 'EVAL_EXCHG_RATE'	, text: '평가환율'		,type: 'uniER'},
			{name: 'EVAL_JAN_AMT'		, text: '평가원화'		,type: 'uniPrice'},
			{name: 'EVAL_DIFF_AMT'  	, text: '평가차액'		,type: 'uniPrice'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agb340skrMasterStore', {
		model: 'Agb340skrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'agb340skrService.selectList'                	
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
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
				name: 'AC_DATE',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_DATE', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				//width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '통화코드',
				name:'MONEY_UNIT', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B004',
				//width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
			},
			Unilite.popup('ACCNT',{ 
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCNT_CODE',
				textFieldName: 'ACCNT_NAME',
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE', newValue);								
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
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm', {
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '평가년월',
			xtype: 'uniMonthfield',
			name: 'AC_DATE',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AC_DATE', newValue);
				}
			}
		},{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '통화코드',
			name:'MONEY_UNIT', 
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B004',
			//width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('MONEY_UNIT', newValue);
				}
			}
		},
		Unilite.popup('ACCNT',{ 
			fieldLabel: '계정과목', 
			valueFieldName: 'ACCNT_CODE',
			textFieldName: 'ACCNT_NAME',
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE', newValue);								
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
		})]
	});
	
	var panelEval = Unilite.createForm('detailForm', {
		layout : {type : 'uniTable', columns : 3},
		disabled: false,
        border:true,
        padding:'1 1 1 1',
		region: 'north',
		items: [{
			fieldLabel: '평가환율',
			name:'MONEY_UNIT_EVAL', 
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B004',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
		    		var moneyUnit = panelEval.getValue('MONEY_UNIT_EVAL');
		    		var acDate	  = panelSearch.getValues().AC_DATE;
		    		
		    		if(Ext.isEmpty(moneyUnit)) {
		    			panelEval.setValue('EXCHG_RATE_EVAL', 0.00);
		    			return;
		    		}
		    		
		    		if(moneyUnit == 'KRW') {
		    			panelEval.setValue('EXCHG_RATE_EVAL', 1);
		    		}
		    		else {
			    		var param = {
							'AC_DATE'	: acDate,
							'MONEY_UNIT': moneyUnit
						};
						
						agb340skrService.fnGetExchgRate(param, function(provider, response) {
							console.log("provider : ", provider);
							if(provider){
								panelEval.setValue('EXCHG_RATE_EVAL', provider[0].BASE_EXCHG);
							}
						});
		    		}
				}
			}
		},{
			fieldLabel: '',
			name:'EXCHG_RATE_EVAL', 
			xtype: 'uniNumberfield',
			type: 'uniER',
			value: 0
		},{
			xtype: 'button',
	    	text: '적용',
	    	width: 50,
	    	margin: '0 0 0 0',
	    	handler : function() {
	    		var grid = Ext.getCmp('agb340skrGrid');
	    		var moneyUnit = panelEval.getValue('MONEY_UNIT_EVAL');
	    		var exchgRate = panelEval.getValue('EXCHG_RATE_EVAL');
	    		
	    		if(Ext.isEmpty(moneyUnit) || Ext.isEmpty(exchgRate)) {
	    			Unilite.messageBox('평가를 위한 화폐단위와 환율을 확인하여주십시오.');
	    		}
	    		
	    		grid.fnApplyEvalExchgRate(moneyUnit, exchgRate);
	    	}
		}]
	});
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb340skrGrid', {
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
			{dataIndex: 'COMP_CODE'   		, width: 100	, hidden : true	},
			{dataIndex: 'DIV_CODE'   		, width: 100	},
			{dataIndex: 'ACCNT'   			, width: 100	, align : 'center'		},
			{dataIndex: 'ACCNT_NAME'   		, width: 200	},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	, align : 'center'		},
			{dataIndex: 'CUSTOM_NAME'  		, width: 200	},
			{dataIndex: 'MONEY_UNIT'  		, width:  80	},
			{dataIndex: 'JAN_FOR_AMT'   	, width: 130	},
			{dataIndex: 'EXCHG_RATE_O'		, width: 130	},
			{dataIndex: 'JAN_AMT'  			, width: 130	},
			{dataIndex: 'EVAL_EXCHG_RATE'	, width: 130	},
			{dataIndex: 'EVAL_JAN_AMT'  	, width: 130	},
			{dataIndex: 'EVAL_DIFF_AMT'  	, width: 130	}
		],
		fnApplyEvalExchgRate: function(moneyUnit, exchgRate) {
			Ext.each(directMasterStore.data.items, function(record, index) {
				if(record.get('MONEY_UNIT') == moneyUnit) {
					var janAmt		= Number(record.get('JAN_AMT'));
					var janEvalAmt	= Number(record.get('JAN_FOR_AMT'));
					var diffAmt		= janAmt;
					
					janEvalAmt	= janEvalAmt * Number(exchgRate);
					diffAmt		= janEvalAmt - janAmt;
					
					record.set('EVAL_EXCHG_RATE', exchgRate);
					record.set('EVAL_JAN_AMT'	, janEvalAmt);
					record.set('EVAL_DIFF_AMT'	, diffAmt);
				}
			});
			
			directMasterStore.commitChanges();
        }
	});
	
	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult, panelEval
			]
		},
			panelSearch  	
		],
		id : 'agb340skrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail', 'reset'], false);
			
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('AC_DATE',UniDate.get('today'));
			panelResult.setValue('AC_DATE',UniDate.get('today'));
			
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}
			else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE');
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}
			else {
				directMasterStore.loadStoreRecords();
			}
		}
	});
};
</script>
