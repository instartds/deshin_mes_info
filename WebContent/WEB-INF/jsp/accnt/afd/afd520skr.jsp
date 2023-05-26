<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd520skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A031" opts='1'/> <!-- 어음수표구분 조건 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="A064" /> <!-- 어음처리구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var getStDt = ${getStDt};
function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afd520skrModel', {
	    fields: [  	  
	    	{name: 'ACCNT'				, text: '계정과목' 		,type: 'string'},
		    {name: 'ACCNT_NAME'			, text: '예적금종류'		,type: 'string'},
		    {name: 'BANK_CODE'			, text: '금융기관코드' 		,type: 'string'},
		    {name: 'BANK_NAME'		 	, text: '금융기관' 		,type: 'string'},
		    {name: 'BANK_ACCOUNT'		, text: '계좌' 			,type: 'string'},
		    {name: 'SAVE_DESC'			, text: '예적금명' 		,type: 'string'},
		    {name: 'PUB_DATE'			, text: '계약일' 			,type: 'uniDate'},
		    {name: 'EXP_DATE'			, text: '만기일' 			,type: 'uniDate'},
		    {name: 'TOT_CNT'			, text: '총불입수'			,type: 'string'},
		    {name: 'NOW_CNT'			, text: '현불입수' 		,type: 'string'},
		    {name: 'DISP_INT_RATE'		, text: '이자율' 			,type: 'string'},
		    {name: 'EXP_AMT_I'			, text: '약정금액' 		,type: 'uniPrice'},
		    {name: 'TOTRATE_AMT_I'		, text: '총이자' 			,type: 'uniPrice'},
		    {name: 'FULLCLOSE_AMT_I'	, text: '만기해약금액' 		,type: 'uniPrice'},
		    {name: 'NOW_AMT_I'			, text: '현불입금액' 		,type: 'uniPrice'},
		    {name: 'RCV_BENEFIT'		, text: '미수수익'			,type: 'uniPrice'},
		    {name: 'MONEY_UNIT'			, text: '화폐단위' 		,type: 'string'},
		    {name: 'EXP_FOR_AMT_I'		, text: '외화약정금액' 		,type: 'uniFC'},
		    {name: 'TOTRATE_FOR_AMT_I'	, text: '외화총이자' 		,type: 'uniFC'},
		    {name: 'FULLCLOSE_FOR_AMT_I', text: '외화만기해약금액' 	,type: 'uniFC'},
		    {name: 'NOW_FOR_AMT_I'		, text: '외화현불입금액' 	,type: 'uniFC'},
		    {name: 'RCV_BENEFIT_FOR'	, text: '외화미수수익'			,type: 'uniPrice'}
		    
		    
		]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afd520skrMasterStore1',{
		model: 'Afd520skrModel',
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
                read: 'afd520skrService.selectMasterList'                	
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
			 	fieldLabel: '기준일',
			 	xtype: 'uniDatefield',
			 	name: 'AC_DATE',
			 	value: UniDate.get('today'),
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_DATE', newValue);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '이자적용방법',	
				items: [{
					boxLabel: '예적금이율', 
					width: 100, 
					name: 'APPLY_RATE',
					inputValue: 'int_rate',
					checked: true  
				},{
					boxLabel : '기준이율', 
					width: 100,
					name: 'APPLY_RATE',
					inputValue: 'std_rate'
				}],
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('APPLY_RATE').setValue(newValue.APPLY_RATE);
						if(newValue.APPLY_RATE == "std_rate")	{
							panelResult.getField("STD_RATE").setReadOnly(false);
							panelSearch.getField("STD_RATE").setReadOnly(false);
						} else {
							panelResult.setValue("STD_RATE","");
							panelSearch.setValue("STD_RATE","");
							panelResult.getField("STD_RATE").setReadOnly(true);
							panelSearch.getField("STD_RATE").setReadOnly(true);
						}
					}
				}
			},{
			 	fieldLabel: ' ',
			 	xtype: 'uniNumberfield',
			 	name: 'STD_RATE',
			 	suffixTpl: '%',
			 	readOnly:true,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('STD_RATE', newValue);
					}
				}
			},
				Unilite.popup('BANK',{ 
			    	fieldLabel: '계정과목', 
			    	popupWidth: 500,
			    	valueFieldName: 'ACCNT',
					textFieldName: 'ACCNT_NUM',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ACCNT', panelSearch.getValue('ACCNT'));
								panelResult.setValue('ACCNT_NUM', panelSearch.getValue('ACCNT_NUM'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ACCNT', '');
							panelResult.setValue('ACCNT_NUM', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('BANK',{ 
			    	fieldLabel: '금융기관',  
			    	popupWidth: 500,
			    	valueFieldName: 'BANK_CD',
					textFieldName: 'BANK_NUM',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('BANK_CD', panelSearch.getValue('BANK_CD'));
								panelResult.setValue('BANK_NUM', panelSearch.getValue('BANK_NUM'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('BANK_CD', '');
							panelResult.setValue('BANK_NUM', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
			 	fieldLabel: '당기시작년월',
			 	xtype: 'uniDatefield',
			 	name: 'ST_DATE',
			 	allowBlank:false,
			 	value:getStDt.STDT,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ST_DATE', newValue);
					}
				}
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				value : UserInfo.divCode,
		        multiSelect: true, 
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
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
				}
	  		}
			return r;
  		}
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [		    
	    	{
			 	fieldLabel: '기준일',
			 	xtype: 'uniDatefield',
			 	name: 'AC_DATE',
			 	value: UniDate.get('today'),
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_DATE', newValue);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '이자적용방법',	
				items: [{
					boxLabel: '예적금이율', 
					width: 100, 
					name: 'APPLY_RATE',
					inputValue: 'int_rate',
					checked: true  
				},{
					boxLabel : '기준이율', 
					width: 100,
					name: 'APPLY_RATE',
					inputValue: 'std_rate'
				}],
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {		
						panelSearch.getField('APPLY_RATE').setValue(newValue.APPLY_RATE);
						if(newValue.APPLY_RATE == "std_rate")	{
							panelResult.getField("STD_RATE").setReadOnly(false);
							panelSearch.getField("STD_RATE").setReadOnly(false);
						} else {
							panelResult.setValue("STD_RATE","");
							panelSearch.setValue("STD_RATE","");
							panelResult.getField("STD_RATE").setReadOnly(true);
							panelSearch.getField("STD_RATE").setReadOnly(true);
						}
					}
				}
			},{
			 	hideLabel: true,
			 	xtype: 'uniNumberfield',
			 	name: 'STD_RATE',
			 	suffixTpl: '%',
			 	readOnly:true,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('STD_RATE', newValue);
					}
				}
			},
				Unilite.popup('BANK',{ 
			    	fieldLabel: '계정과목',  
			    	popupWidth: 500,
			    	valueFieldName: 'ACCNT',
					textFieldName: 'ACCNT_NUM',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ACCNT', panelResult.getValue('ACCNT'));
								panelSearch.setValue('ACCNT_NUM', panelResult.getValue('ACCNT_NUM'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ACCNT', '');
							panelSearch.setValue('ACCNT_NUM', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('BANK',{ 
			    	fieldLabel: '금융기관', 
			    	popupWidth: 500,
			    	valueFieldName: 'BANK_CD',
					textFieldName: 'BANK_NUM',
					colsapn:2,
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BANK_CD', panelResult.getValue('BANK_CD'));
								panelSearch.setValue('BANK_NUM', panelResult.getValue('BANK_NUM'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BANK_CD', '');
							panelSearch.setValue('BANK_NUM', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
			 	fieldLabel: '당기시작년월',
			 	xtype: 'uniDatefield',
			 	name: 'ST_DATE',
			 	allowBlank:false,
			 	value:getStDt.STDT,
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ST_DATE', newValue);
					}
				}
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				value : UserInfo.divCode,
				comboType: 'BOR120',
		        multiSelect: true, 
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afd520skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: [        
        	{dataIndex: 'ACCNT'					, width: 66 , hidden: true}, 				
			{dataIndex: 'ACCNT_NAME'			, width: 86 , locked: true
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
			{dataIndex: 'BANK_CODE'				, width: 80 , hidden: true}, 				
			{dataIndex: 'BANK_NAME'				, width: 106 , locked: true}, 				
			{dataIndex: 'BANK_ACCOUNT'			, width: 106 , locked: true}, 				
			{dataIndex: 'SAVE_DESC'				, width: 133}, 				
			{dataIndex: 'PUB_DATE'				, width: 73}, 				
			{dataIndex: 'EXP_DATE'				, width: 73},
			{dataIndex: 'TOT_CNT'				, width: 65}, 				
			{dataIndex: 'NOW_CNT'				, width: 65}, 				
			{dataIndex: 'DISP_INT_RATE'			, width: 65}, 				
			{dataIndex: 'EXP_AMT_I'				, width: 100 , summaryType: 'sum'}, 				
			{dataIndex: 'TOTRATE_AMT_I'			, width: 93  , summaryType: 'sum'}, 				
			{dataIndex: 'FULLCLOSE_AMT_I'		, width: 100 , summaryType: 'sum'}, 				
			{dataIndex: 'NOW_AMT_I'				, width: 100 , summaryType: 'sum'}, 		
			{dataIndex: 'RCV_BENEFIT'			, width: 100 , summaryType: 'sum'}, 				
			{dataIndex: 'MONEY_UNIT'			, width: 65  }, 				
			{dataIndex: 'EXP_FOR_AMT_I'			, width: 100 , summaryType: 'sum'}, 				
			{dataIndex: 'TOTRATE_FOR_AMT_I'		, width: 93  , summaryType: 'sum'}, 				
			{dataIndex: 'FULLCLOSE_FOR_AMT_I'	, width: 110 , summaryType: 'sum'}, 				
			{dataIndex: 'NOW_FOR_AMT_I'			, width: 100 , summaryType: 'sum'},
			{dataIndex: 'RCV_BENEFIT_FOR'		, width: 100 , summaryType: 'sum'} 
			
		]                 
    });
    
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
		items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'afd520skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{					
			directMasterStore.loadStoreRecords();				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
