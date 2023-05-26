<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afs200skr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐유형-->
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afs200skrModel', {
	    fields: [  	  
		    {name: 'SAVE_CODE'				, text: '계좌코드' 	,type: 'string'},
		    {name: 'SAVE_NAME'				, text: '계좌명' 		,type: 'string'},
		    {name: 'BANK_ACCOUNT'			, text: '계좌번호' 	,type: 'string'},
            {name: 'AAA'                    , text: '잔액'        ,type: 'uniPrice'}
		]          
	});
	
	
	Unilite.defineModel('Afs200skrModel2', {
	    fields: [  	  
		    {name: 'AC_DATE'				, text: '일자' 			,type: 'string'},
		    {name: 'SLIP_NUM'				, text: '지출/수입번호' 	,type: 'string'},
		    {name: 'CR_AMT_I'				, text: '출금금액(현지화)' 	,type: 'uniPrice'},
		    {name: 'DR_AMT_I'				, text: '입금금액(현지화)' 	,type: 'uniPrice'},
		    {name: 'BLN_AMT_I'				, text: '잔액' 			,type: 'uniPrice'},
		    {name: 'AAA'                    , text: '발생금액'         ,type: 'uniPrice'},
            {name: 'REMARK'                 , text: '적요'            ,type: 'string'},
			{name: 'MONEY_UNIT'             , text: '화폐단위'         ,type: 'string'},
            {name: 'EXCHG_RATE_O'           , text: '환율'            ,type: 'uniER'},
            {name: 'BBB'                    , text: '발생금액(외화)'     ,type: 'uniPrice'}
		]          
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afs200skrMasterStore1',{
		model: 'Afs200skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,				// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_afs200skrService_KOCIS.selectList1'                	
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
	
	
	var directDetailStore = Unilite.createStore('afs200skrMasterStore2',{
		model: 'Afs200skrModel2',
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
                read: 's_afs200skrService_KOCIS.selectList2'                	
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
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
        //region : 'west',
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },{
                xtype: 'uniYearField',
                fieldLabel: '지급/수입 년',
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '지급/수입 월',
                name: 'AC_MONTH',
                comboType: 'AU',
                comboCode: 'HE24',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_MONTH', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            },
            Unilite.popup('BUDG', {
                fieldLabel: '예산과목', 
                valueFieldName: 'BUDG_CODE',
                textFieldName: 'BUDG_NAME', 
                autoPopup:true,
                listeners: { 
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);                
                    },
                    applyextparam: function(popup) {/*                            
                        popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4)});
                        popup.setExtParam({'DEPT_CODE' : detailForm.getValue('DEPT_CODE')});
                        popup.setExtParam({'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
                                    "AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"});
                    */}
                
                }
            })]				
		}]
	});	  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout: {type: 'uniTable', columns: 3},
		padding:'1 1 1 1',
		border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },{
            xtype: 'uniYearField',
            fieldLabel: '지급/수입 년',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '지급/수입 월',
            name: 'AC_MONTH',
            comboType: 'AU',
            comboCode: 'HE24',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_MONTH', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },
        Unilite.popup('BUDG', {
            fieldLabel: '예산과목', 
            valueFieldName: 'BUDG_CODE',
            textFieldName: 'BUDG_NAME', 
            autoPopup:true,
            listeners: { 
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);                
                },
                applyextparam: function(popup) {/*                            
                    popup.setExtParam({'AC_YYYY': UniDate.getDbDateStr(detailForm.getValue('SLIP_DATE')).substring(0, 4)});
                    popup.setExtParam({'DEPT_CODE' : detailForm.getValue('DEPT_CODE')});
                    popup.setExtParam({'ADD_QUERY' : gsCommonA171_Ref6 == '1' ? "GROUP_YN = 'N' " +
                                "AND USE_YN = 'Y'" : "BUDG_TYPE = '2' AND GROUP_YN = 'N' AND USE_YN = 'Y'"});
                */}
            
            }
        })]
	});	 
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afs200skrGrid1', {
    	layout : 'fit',
        region : 'center',
        uniOpt:{
			useMultipleSorting	: false,
    		useLiveSearch		: false,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [       
            {dataIndex: 'SAVE_CODE'		              , width: 100,hidden:true },
            {dataIndex: 'SAVE_NAME'		              , width: 110 },
            {dataIndex: 'BANK_ACCOUNT'              , width: 150 },
            {dataIndex: 'AAA'                       , width: 100 }
		],
		listeners: {									
        	select: function(grid, record, index, eOpts ){		
/*//        	selectionchange:function( model1, selected, eOpts ){
        		//var record = selected[0];
        		var record = masterGrid.getSelectedRecord();
        		this.returnCell(record);  
        		directDetailStore.loadData({})
				directDetailStore.loadStoreRecords(record);*/
          	}
		},
       	returnCell: function(record) {
        	var account			= record.get("ACCNT");
        	var saveCode		= record.get("SAVE_CODE");
        	var moneyUnit 		= record.get("MONEY_UNIT");
        	var stDt			= panelSearch.getValue("ST_DATE");
        	var frDate			= panelSearch.getValue("FR_DATE");   
        	var toDate			= panelSearch.getValue("TO_DATE");
        	var divCode			= panelSearch.getValue("ACCNT_DIV_CODE");
        	var refCode			= record.get("REF_CODE1");
            panelSearch.setValues({'ACCNT_TEMP':account});
            panelSearch.setValues({'SAVE_CODE_TEMP':saveCode});
            panelSearch.setValues({'MONEY_UNIT_TEMP':moneyUnit});
            panelSearch.setValues({'ST_DT_TEMP':stDt});
            panelSearch.setValues({'FR_DATE_TEMP':frDate});
            panelSearch.setValues({'TO_DATE_TEMP':toDate});
            panelSearch.setValues({'ACCNT_DIV_CODE_TEMP':divCode});
            panelSearch.setValues({'REF_CODE1':refCode});
        }
    });
    
        /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('afs200skrGrid2', {    	
    	layout : 'fit',
        region : 'east',
        uniOpt:{
			useMultipleSorting	: false,
    		useLiveSearch		: false,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directDetailStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		selModel : 'rowmodel',
        columns: [        
        	{dataIndex: 'AC_DATE'							, width: 100}, 	
            {dataIndex: 'SLIP_NUM'		                  , width: 100}, 
            {dataIndex: 'CR_AMT_I'		                  , width: 150}, 
            {dataIndex: 'DR_AMT_I'		                  , width: 150}, 
            {dataIndex: 'BLN_AMT_I'		                  , width: 100}, 
            {dataIndex: 'AAA'                             , width: 100}, 
            {dataIndex: 'REMARK'                          , width: 200}, 
            {dataIndex: 'MONEY_UNIT'                      , width: 100}, 
            {dataIndex: 'EXCHG_RATE_O'                    , width: 100}, 
            {dataIndex: 'BBB'                             , width: 150}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				var params = {
					action:'select',
					'PGM_ID'		: 's_afs200skr_KOCIS',
					'DIV_CODE' : record.data['DIV_CODE'],
					'AC_DATE' : record.data['AC_DATE'],
					'INPUT_PATH' : record.data['INPUT_PATH'],
					'SLIP_NUM' : record.data['SLIP_NUM'],
					'SLIP_SEQ' : record.data['SLIP_SEQ']
				}
				if(record.data['INPUT_PATH'] == 'Z3') {
					var rec1 = {data : {prgID : 'dgj100ukr', 'text':''}};							
					parent.openTab(rec1, '/accnt/dgj100ukr.do', params);
  				} else {
  					var rec2 = {data : {prgID : 'agj200ukr', 'text':''}};							
					parent.openTab(rec2, '/accnt/agj200ukr.do', params);
  				}
			}
		}           			
    });
    
    Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				{
					region : 'west',
					xtype : 'container',
					width : 404,
					layout : 'fit',
					items : [ masterGrid ]
				},{
					region : 'center',
					xtype : 'container',
					width : 700,
					layout : 'fit',
					items : [ detailGrid ]
				},panelResult
			]
		},
			panelSearch  	
		], 
		id : 'afs200skrApp',
		fnInitBinding : function(params) {
			
//			this.processParams(params);
			
			this.setDefault(params);
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params && params.BANK_CODE) {
				panelSearch.setValue('ACCNT_DIV_CODE'	,params.DIV_CODE);
				panelSearch.setValue('FR_DATE'			,params.AC_DATE_FR);
				panelSearch.setValue('TO_DATE'			,params.AC_DATE_TO);
				panelSearch.setValue('BANK_BOOK_CODE'	,params.BANK_BOOK_CODE);
				panelSearch.setValue('BANK_BOOK_NAME'	,params.BANK_BOOK_NAME);
				panelSearch.setValue('BANK_CODE'		,params.BANK_CODE);
				panelSearch.setValue('BANK_NAME'		,params.BANK_NAME);
				panelSearch.setValue('MONEY_UNIT'		,params.MONEY_UNIT);
				
				panelResult.setValue('ACCNT_DIV_CODE'	,params.DIV_CODE);
				panelResult.setValue('FR_DATE'			,params.AC_DATE_FR);
				panelResult.setValue('TO_DATE'			,params.AC_DATE_TO);
				panelResult.setValue('BANK_BOOK_CODE'	,params.BANK_BOOK_CODE);
				panelResult.setValue('BANK_BOOK_NAME'	,params.BANK_BOOK_NAME);
				panelResult.setValue('BANK_CODE'		,params.BANK_CODE);
				panelResult.setValue('BANK_NAME'		,params.BANK_NAME);
				panelResult.setValue('MONEY_UNIT'		,params.MONEY_UNIT);

				panelSearch.setValue('ST_DATE'			,params.ST_DATE);
				masterGrid.getStore().loadStoreRecords();
			}
		},
		setDefault: function(params){
            this.onResetButtonDown();
            if(!Ext.isEmpty(params.ELEC_SLIP_NO)){
//                UniAppManager.app.fnInitInputFields();
                searchForm.getField("APPR_DATE_FR").setConfig('allowBlank',true);
                searchForm.getField("APPR_DATE_TO").setConfig('allowBlank',true);
                this.processParams(params);
            }
		},
		onQueryButtonDown : function()	{	
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            
            detailGrid.reset();
            directDetailStore.clearData();
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
            this.fnInitInputFields();
        },
        fnInitInputFields: function(){
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            } else {
                activeSForm = panelResult;
            }
//            activeSForm.onLoadSelectText('FR_DATE');
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
            panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
            panelSearch.setValue('TO_DATE',UniDate.get('today'));
            panelResult.setValue('TO_DATE',UniDate.get('today'));
            
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
            }
            
            UniAppManager.setToolbarButtons('save',false);
            UniAppManager.setToolbarButtons('reset',true);
        }
	});
};


</script>
