<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agc870ukr_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_agc870ukr_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="B019" /> 		<!-- 국내수출계정구분-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	
	var ynStore = Unilite.createStore('ynStore', {  // 조합원 여부
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'Y'},
			        {'text':'아니오'	, 'value':'N'}
	    		]
	});
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_agc870ukr_mitService.selectList',
			update: 's_agc870ukr_mitService.updateList',
			create: 's_agc870ukr_mitService.insertList',
			destroy: 's_agc870ukr_mitService.deleteList',
			syncAll: 's_agc870ukr_mitService.saveAll'
		}
	});	
	//계정	창고	구분	품목	품명	규격	단위	Lot No. 	비고	폐기수량	반품수량	폐기수량-반품수량	단가	금액
	Unilite.defineModel('s_agc870ukr_mitModel', {
	    fields: [  	    
	    	  {name : 'DIV_CODE'                    , text : '사업장'                        	, type : 'string'             , allowBlank : false           , comboType : 'BOR120'}
	    	, {name : 'BASIS_DATE'                  , text : '조회기준일'                      	, type : 'uniDate'            , allowBlank : false}
	    	, {name : 'RISK_YN'                     , text : '부실여부'                        	, type : 'string' }
	    	, {name : 'CUSTOM_CODE'                 , text : '거래처'                         	, type : 'string'             , editable :false }
	    	, {name : 'CUSTOM_NAME'                 , text : '거래처명'                        	, type : 'string'             , editable :false }
	    	, {name : 'NATION_INOUT'                , text : '구분'                          	, type : 'string'             , editable :false , comboType : 'AU' , comboCode :'B019'}
	    	, {name : 'ITEM_DIV'                    , text : '품목군'                         	, type : 'string' }
	    	, {name : 'RESPONSIBILITY'              , text : '담당자'                         	, type : 'string'             , editable :false }
	    	, {name : 'RECEIVTURNOVER'              , text : '채권회수주기'                    	, type : 'int'                , editable :false }
	    	, {name : 'OVERAYEAR'                   , text : '1년초과'                        	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_12'                    , text : '12개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_11'                    , text : '19개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_10'                    , text : '10개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_09'                    , text : '09개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_08'                    , text : '08개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_07'                    , text : '07개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_06'                    , text : '06개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_05'                    , text : '05개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_04'                    , text : '04개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_03'                    , text : '03개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_02'                    , text : '02개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'MONTH_01'                    , text : '01개월전'                       	, type : 'uniPrice'           , editable :false }
	    	, {name : 'BALANCE_SUM'                 , text : '잔액'                        	  	, type : 'uniPrice'           , editable :false }
	    	, {name : 'AGEDRECEIVABLE'              , text : '결제일 초과 미입금액'              	, type : 'uniPrice'           , editable :false }
	    	, {name : 'EXPECTTORECEIV'              , text : '입금예정금액'                    	, type : 'uniPrice' }
	    	, {name : 'ALLOWANCE'                   , text : '대손충당금'                      	, type : 'uniPrice' }
	    	, {name : 'PAWN_AMOUNT'                 , text : '담보금액'                       	, type : 'uniPrice' }
	    	, {name : 'REMARKS'                     , text : '비고(회수계획 등)'                	, type : 'string'   }
	    	, {name : 'REMARK'                      , text : '신규여부'                        	, type : 'string'             , editable : false }
	        , {name : 'FLAG'                        , text : ' '                         	    , type : 'string'             , editable : false }
		         
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_agc870ukr_mitMasterStore',{
		model: 's_agc870ukr_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
            allDeletable: true,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
        	this.clearFilter(); 
        	if(panelResult.getInvalidMessage())	{
    			panelResult.setDisablekeys(true);
				var param= Ext.getCmp('resultForm').getValues();			
				this.load({
					params : param,
					callback: function(records, operation, success) {
						if(success){
							Ext.each(records, function(record, idx)	{
								if(record.get("FLAG") == "S")	{
									record.set("REMARK", "신규");
								}
							});
						}
					}
				});
        	}
		},
		saveStore : function()	{	
			this.clearFilter();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				var config = {}
				this.syncAllDirect({});
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
		
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel		: '조회일',
			xtype			: 'uniDatefield',
			name	        : 'BASIS_DATE',
			value			: UniDate.get('today'),
			allowBlank	: false,
			listeners : {
				change : function(field, newValue, oldValue) {
					if(newValue != oldValue)	{
						if(Ext.isDate(newValue))	{
							UniAppManager.app.setColumnsText(newValue);	
						}
					}
				}
			}
		},{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			multiSelect : true, 
			typeAhead   : false,
			value       : UserInfo.divCode,
			allowBlank	: false
		}],
		setDisablekeys: function(disable) {
			var me = this;
			me.getField("BASIS_DATE").setReadOnly(disable);
			me.getField("DIV_CODE").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_agc870ukr_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt : {
    		expandLastColumn: false
    	},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  [     
        	  {dataIndex : 'DIV_CODE'                         , width : 110                  }
        	, {dataIndex : 'BASIS_DATE'                       , width : 80           , hidden : true}
        	, {dataIndex : 'RISK_YN'                          , width : 100                  }
        	, {dataIndex : 'CUSTOM_CODE'                      , width : 80                   }
        	, {dataIndex : 'CUSTOM_NAME'                      , width : 120                  }
        	, {dataIndex : 'NATION_INOUT'                     , width : 100                  }
        	, {dataIndex : 'ITEM_DIV'                         , width : 100                  }
        	, {dataIndex : 'RESPONSIBILITY'                   , width : 100                  }
        	, {dataIndex : 'RECEIVTURNOVER'                   , width : 130                  }
        	, {dataIndex : 'OVERAYEAR'                        , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_12'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_11'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_10'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_09'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_08'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_07'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_06'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_05'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_04'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_03'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_02'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'MONTH_01'                         , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'BALANCE_SUM'                      , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'AGEDRECEIVABLE'                   , width : 130                 , summaryType : 'sum'}
        	, {dataIndex : 'EXPECTTORECEIV'                   , width : 130                 , summaryType : 'sum'}
        	, {dataIndex : 'ALLOWANCE'                        , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'PAWN_AMOUNT'                      , width : 100                 , summaryType : 'sum'}
        	, {dataIndex : 'REMARKS'                          , width : 150                 }
        	, {dataIndex : 'REMARK'                           , flex : 1                    }
	         
		]
    });  
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_agc870ukr_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("BASIS_DATE", UniDate.get('today'));
			this.setColumnsText(new Date());
			panelResult.setDisablekeys(false);
			
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			if(panelResult.getInvalidMessage())	{
				if(confirm("저장된 데이터가 삭제됩니다. 그래도 하시겠습니까?’"))	{
					var param = panelResult.getValues();
					s_agc870ukr_mitService.deleteAll(param, function(responseText, response){
						if(responseText)	{
							UniAppManager.updateStatus("삭제되었습니다.");
							UniAppManager.app.onResetButtonDown();
						}
				    })
				}
			}
		},
		setColumnsText : function(newValue){
			var dt ;
			for(var i = 1; i <= 12 ; i++)	{
				var column ;
				if(i < 10)	{
					column = masterGrid.getColumn('MONTH_0'+i);
				} else {
					column = masterGrid.getColumn('MONTH_'+i);
				}

				if(Ext.isEmpty(column))  {
					return ;
				}
				var increments = (parseInt(i)-1)*parseInt(-1);
				dt = UniDate.add(newValue, {'months' : increments })
				column.setText(Ext.Date.format(dt, 'Y.m'));
				
			}
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}			
			
			var rv = true;			
			switch(fieldName) {			
				case "ALLOWANCE" :	
					if( newValue >= record.get("BALANCE_SUM")) {
						record.set("RISK_YN", "부실");
					} else {
						if(record.get("RISK_YN") == "부실")	{
							record.set("RISK_YN", "");
						}
					}
					break;
				default:
					break;
			}
			return rv;
		}
	});
};


</script>
