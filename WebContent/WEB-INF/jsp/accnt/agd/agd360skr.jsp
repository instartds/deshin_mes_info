<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd360skr"  >
    
    <t:ExtComboStore comboType="AU" comboCode="J653" /> <!-- 처리상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J519" /> <!-- 인터페이스 도메인ID -->
    
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

    Unilite.defineModel('agd360skrSearchModel', {
        fields: [
            {name: 'DOC_ID'             ,text: 'DOC_ID'                 ,type: 'string'},
            {name: 'COMP_CODE'          ,text: '회사코드'                  ,type: 'string'},
            {name: 'COMP_NAME'          ,text: '회사명'                   ,type: 'string'},
            {name: 'APP_ID'             ,text: 'APP_ID'                 ,type: 'string'},
            {name: 'APP_NAME'           ,text: 'APP_ID명'                 ,type: 'string'},
            {name: 'IF_DATE'            ,text: 'IF_DATE'                ,type: 'string'},
            {name: 'IF_TIME'            ,text: 'IF_TIME'                ,type: 'string'},
            {name: 'IF_NUM'             ,text: 'IF_NUM'                 ,type: 'string'},
            {name: 'IF_SEQ'             ,text: 'IF_SEQ'                 ,type: 'string'},
            {name: 'INDEX_NUM'          ,text: 'INDEX_NUM'              ,type: 'string'},
            {name: 'GUBUN_1'            ,text: 'GUBUN_1'                ,type: 'string'},
            {name: 'GUBUN_2'            ,text: 'GUBUN_2'                ,type: 'string'},
            {name: 'GUBUN_3'            ,text: 'GUBUN_3'                ,type: 'string'},
            {name: 'GUBUN_4'            ,text: 'GUBUN_4'                ,type: 'string'},
            {name: 'GUBUN_5'            ,text: 'GUBUN_5'                ,type: 'string'},
            {name: 'BILL_TYPE'          ,text: 'BILL_TYPE'              ,type: 'string'},
            {name: 'BASE_DATE'          ,text: 'BASE_DATE'              ,type: 'string'},
            {name: 'BILL_DATE'          ,text: 'BILL_DATE'              ,type: 'string'},
            {name: 'SALE_DATE'          ,text: 'SALE_DATE'              ,type: 'string'},
            {name: 'CUSTOM_CODE'        ,text: 'CUSTOM_CODE'            ,type: 'string'},
            {name: 'COMPANY_NUM'        ,text: 'COMPANY_NUM'            ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: 'CUSTOM_NAME'            ,type: 'string'},
            {name: 'DEPT_CODE'          ,text: 'DEPT_CODE'              ,type: 'string'},
            {name: 'DEPT_NAME'          ,text: 'DEPT_NAME'              ,type: 'string'},
            {name: 'DIV_CODE'           ,text: 'DIV_CODE'               ,type: 'string'},
            {name: 'SUPPLY_AMT'         ,text: 'SUPPLY_AMT'             ,type: 'string'},
            {name: 'TAX_AMT'            ,text: 'TAX_AMT'                ,type: 'string'},
            {name: 'FEE_AMT'            ,text: 'FEE_AMT'                ,type: 'string'},
            {name: 'NOPAY_AMT'          ,text: 'NOPAY_AMT'              ,type: 'string'},
            {name: 'REFUND_AMT'         ,text: 'REFUND_AMT'             ,type: 'string'},
            {name: 'AMT_1'              ,text: 'AMT_1'                  ,type: 'string'},
            {name: 'AMT_2'              ,text: 'AMT_2'                  ,type: 'string'},
            {name: 'REMARK'             ,text: 'REMARK'                 ,type: 'string'},
            {name: 'BIGO_1'             ,text: 'BIGO_1'                 ,type: 'string'},
            {name: 'BIGO_2'             ,text: 'BIGO_2'                 ,type: 'string'},
            {name: 'BANK_ACCOUNT'       ,text: 'BANK_ACCOUNT'           ,type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'	,text: 'BANK_ACCOUNT'		 	,type: 'string', defaultValue:'***************'},            
            {name: 'PJT_CODE'           ,text: 'PJT_CODE'               ,type: 'string'},
            {name: 'ITEM_CODE'          ,text: 'ITEM_CODE'             	,type: 'string'},
            {name: 'ITEM_NAME'          ,text: 'ITEM_NAME'            	,type: 'string'},
            {name: 'NOTE_NUM'           ,text: 'NOTE_NUM'               ,type: 'string'},
            {name: 'NOTE_PUB_DATE'      ,text: 'NOTE_PUB_DATE'          ,type: 'string'},
            {name: 'NOTE_DUE_DATE'      ,text: 'NOTE_DUE_DATE'          ,type: 'string'},
            {name: 'PUB_CUST_CD'        ,text: 'PUB_CUST_CD'            ,type: 'string'},
            {name: 'PUB_CUST_NAME'      ,text: 'PUB_CUST_NAME'          ,type: 'string'},
            {name: 'CRDT_NUM'         	,text: 'CRDT_NUM'               ,type: 'string'},
            {name: 'CRDT_NUM_EXPOS'     ,text: 'CRDT_NUM'             	,type: 'string', defaultValue:'***************'},
            {name: 'SEND_PNAME'         ,text: 'SEND_PNAME'             ,type: 'string'},
            {name: 'JOB_ID'             ,text: 'JOB_ID'                 ,type: 'string'},
            {name: 'INSERT_DB_USER'     ,text: 'INSERT_DB_USER'         ,type: 'string'},
            {name: 'INSERT_DB_TIME'     ,text: 'INSERT_DB_TIME'         ,type: 'string'},
            {name: 'AC_DATE'            ,text: 'AC_DATE'                ,type: 'string'},
            {name: 'SLIP_NUM'           ,text: 'SLIP_NUM'               ,type: 'string'},
            {name: 'ERROR_YN'           ,text: 'ERROR_YN'               ,type: 'string'},
            {name: 'ERROR_DESC'         ,text: 'ERROR_DESC'             ,type: 'string'}
        ]
    });
  

    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directSearchStore = Unilite.createStore('agd360skrSearchStore', {
        model: 'agd360skrSearchModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'agd360skrService.selectSearchList'                 
            }
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
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    
    var panelSearch = Unilite.createSearchPanel('searchForm', {     
        title: '검색조건',
        width: 360,
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
            items: [
            Unilite.popup('COMP',{
                fieldLabel: '회사명', 
                valueFieldName:'COMP_CODE',
                textFieldName:'COMP_NAME',
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('COMP_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('COMP_NAME', newValue);                
                    }
                }
            }),
            {
            	xtype:'uniTextfield',
                fieldLabel:'APP_ID',
            	name:'APP_ID',
            	xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'J519',
            	listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelResult.setValue('APP_ID', newValue);           
                    }
            	}
            },{
                xtype:'uniDatefield',
                fieldLabel:'IF_DATE',
                name:'IF_DATE',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelResult.setValue('IF_DATE', newValue);           
                    }
                }
            },{
                xtype:'uniTextfield',
                fieldLabel:'IF_TIME',
                name:'IF_TIME',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelResult.setValue('IF_TIME', newValue);           
                    }
                }
            },{
                xtype:'uniTextfield',
                fieldLabel:'IF_NUM',
                name:'IF_NUM',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelResult.setValue('IF_NUM', newValue);           
                    }
                }
            }]
        }]
    });
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        hidden: !UserInfo.appOption.collapseLeftSearch,
        layout : {type : 'uniTable', columns : 5
//        tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'/*width: '100%'/*,align : 'left'*/}
        
        },
        padding:'1 1 1 1',
        border:true,
        items: [
        Unilite.popup('COMP',{
            fieldLabel: '회사명', 
            valueFieldName:'COMP_CODE',
            textFieldName:'COMP_NAME',
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('COMP_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('COMP_NAME', newValue);                
                },
                applyextparam: function(popup){
                    popup.setExtParam({'ADD_QUERY': "USE_STATUS != 'C'"});           //WHERE절 추카 쿼리    
                }
            }
        }),
        {
            xtype:'uniTextfield',
            fieldLabel:'APP_ID',
            name:'APP_ID',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'J519',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {            
                    panelSearch.setValue('APP_ID', newValue);           
                }
            }
        },{
            xtype:'uniDatefield',
            fieldLabel:'IF_DATE',
            name:'IF_DATE',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {            
                    panelSearch.setValue('IF_DATE', newValue);           
                }
            }
        },{
            xtype:'uniTextfield',
            fieldLabel:'IF_TIME',
            name:'IF_TIME',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {            
                    panelSearch.setValue('IF_TIME', newValue);           
                }
            }
        },{
            xtype:'uniTextfield',
            fieldLabel:'IF_NUM',
            name:'IF_NUM',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {            
                    panelSearch.setValue('IF_NUM', newValue);           
                }
            }
        }]
    });
       
    var searchGrid = Unilite.createGrid('agd360skrSearchGrid', {
        layout: 'fit',
        region: 'center',
        excelTitle: '전표생성용 인터페이스정보조회',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: true,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: true,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false
        }],
        uniRowContextMenu:{
            items: [{ 
                text: '회계전표입력(전표번호별)',   
                id:'linkAgj205ukr',
                handler: function(menuItem, event) {
                    var param = menuItem.up('menu');
                    searchGrid.gotoAgj205ukr(param.record);
                }
            }]
        },
        store: directSearchStore,
        columns: [{
        	text:'인터페이스 수신정보',
        	columns:[
                { dataIndex: 'DOC_ID'                                  ,width:120,hidden:true},
                { dataIndex: 'COMP_CODE'                               ,width:70},
                { dataIndex: 'COMP_NAME'                               ,width:120},
                { dataIndex: 'APP_ID'                                  ,width:80},
                { dataIndex: 'APP_NAME'                                ,width:120},
                { dataIndex: 'IF_DATE'                                 ,width:80},
                { dataIndex: 'IF_TIME'                                 ,width:80},
                { dataIndex: 'IF_NUM'                                  ,width:120},
                { dataIndex: 'IF_SEQ'                                  ,width:60},
                { dataIndex: 'INDEX_NUM'                               ,width:120},
                { dataIndex: 'GUBUN_1'                                 ,width:80},
                { dataIndex: 'GUBUN_2'                                 ,width:80},
                { dataIndex: 'GUBUN_3'                                 ,width:80},
                { dataIndex: 'GUBUN_4'                                 ,width:80},
                { dataIndex: 'GUBUN_5'                                 ,width:80},
                { dataIndex: 'BILL_TYPE'                               ,width:80},
                { dataIndex: 'BASE_DATE'                               ,width:100},
                { dataIndex: 'BILL_DATE'                               ,width:100},
                { dataIndex: 'SALE_DATE'                               ,width:100},
                { dataIndex: 'CUSTOM_CODE'                             ,width:120},
                { dataIndex: 'COMPANY_NUM'                             ,width:120},
                { dataIndex: 'CUSTOM_NAME'                             ,width:120},
                { dataIndex: 'DEPT_CODE'                               ,width:120},
                { dataIndex: 'DEPT_NAME'                               ,width:120},
                { dataIndex: 'DIV_CODE'                                ,width:80},
                { dataIndex: 'SUPPLY_AMT'                              ,width:100},
                { dataIndex: 'TAX_AMT'                                 ,width:80},
                { dataIndex: 'FEE_AMT'                                 ,width:80},
                { dataIndex: 'NOPAY_AMT'                               ,width:88},
                { dataIndex: 'REFUND_AMT'                              ,width:100},
                { dataIndex: 'AMT_1'                                   ,width:80},
                { dataIndex: 'AMT_2'                                   ,width:80},
                { dataIndex: 'REMARK'                                  ,width:120},
                { dataIndex: 'BIGO_1'                                  ,width:120},
                { dataIndex: 'BIGO_2'                                  ,width:120},
                { dataIndex: 'BANK_ACCOUNT'                            ,width:120, 	hidden: true},
                { dataIndex: 'BANK_ACCOUNT_EXPOS'                      ,width:120},
                { dataIndex: 'PJT_CODE'                                ,width:120},
                { dataIndex: 'ITEM_CODE'                               ,width:120},
                { dataIndex: 'ITEM_NAME'                               ,width:120},
                { dataIndex: 'NOTE_NUM'                                ,width:120},
                { dataIndex: 'NOTE_PUB_DATE'                           ,width:120},
                { dataIndex: 'NOTE_DUE_DATE'                           ,width:120},
                { dataIndex: 'PUB_CUST_CD'                             ,width:120},
                { dataIndex: 'PUB_CUST_NAME'                           ,width:120},
                { dataIndex: 'CRDT_NUM'                                ,width:100, 	hidden: true},
                { dataIndex: 'CRDT_NUM_EXPOS'                          ,width:100},
                { dataIndex: 'SEND_PNAME'                              ,width:100},
                { dataIndex: 'JOB_ID'                                  ,width:120},
                { dataIndex: 'INSERT_DB_USER'                          ,width:120},
                { dataIndex: 'INSERT_DB_TIME'                          ,width:120},
                { dataIndex: 'TEMPC_01'                                ,width:80},
                { dataIndex: 'TEMPC_02'                                ,width:80},
                { dataIndex: 'TEMPC_03'                                ,width:80},
                { dataIndex: 'TEMPN_01'                                ,width:80},
                { dataIndex: 'TEMPN_02'                                ,width:80},
                { dataIndex: 'TEMPN_03'                                ,width:80}
        	]
        },{
            text:'결과정보',
            columns:[
                { dataIndex: 'AC_DATE'                                 ,width:80},
                { dataIndex: 'SLIP_NUM'                                ,width:80},
                { dataIndex: 'ERROR_YN'                                ,width:80},
                { dataIndex: 'ERROR_DESC'                              ,width:300}
            ]
        }], 
        listeners:{
            
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(!Ext.isEmpty(record.get('AC_DATE'))){
                	if(record.get('COMP_CODE') == UserInfo.compCode){
                        searchGrid.gotoAgj205ukr(record);
                	}else{
                	   Ext.Msg.alert("확인", "선택된 데이터의 회사정보와 현재 법인정보가 일치 하지 않습니다.");	
                	}
                }
            },
            itemmouseenter:function(view, record, item, index, e, eOpts )   {  
                if(!Ext.isEmpty(record.get('AC_DATE'))){
                    view.ownerGrid.setCellPointer(view, item);
                }
            },
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANK_ACCOUNT_EXPOS") {
					grid.ownerGrid.openCryptBankPopup(record);
				} else if (colName =="CRDT_NUM_EXPOS") {
					grid.ownerGrid.openCryptCardPopup(record);
				}	
			}            
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )   { 
            if(!Ext.isEmpty(record.get('AC_DATE'))){
            	if(record.get('COMP_CODE') == UserInfo.compCode){
                    return true;
                }else{
                    Ext.Msg.alert("확인", "선택된 데이터의 회사정보와 현재 법인정보가 일치 하지 않습니다."); 
                }
            }
        },
		openCryptBankPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
			}
				
		},   
		openCryptCardPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('CRDT_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'CRDT_NUM_EXPOS', 'CRDT_NUM', params);
			}
				
		},		
        gotoAgj205ukr:function(record)  {
            if(record)  {
                var params = {
                    action:'select', 
                    'PGM_ID' : 'agd360skr', 
                    'AC_DATE': record.data['AC_DATE'],
                    'SLIP_NUM': record.data['SLIP_NUM'],
                    'INPUT_PATH': '36'
                }
                var rec = {data : {prgID : 'agj205ukr', 'text':''}};                           
                parent.openTab(rec, '/accnt/agj205ukr.do', params);
            }
        }
    });   
 

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout : 'border',
            border: false,
            items:[
                searchGrid, panelResult
            ]
        },
            panelSearch     
        ], 
        id  : 'agd360skrApp',
        fnInitBinding: function(){
            UniAppManager.setToolbarButtons(['save'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            var activeSForm ;       
            if(!UserInfo.appOption.collapseLeftSearch)  {   
                activeSForm = panelSearch;  
            }else {     
                activeSForm = panelResult;  
            }       
            activeSForm.onLoadSelectText('COMP_CODE');       
            
        },
        onQueryButtonDown: function() {   
        	if(!panelResult.getInvalidMessage()) return;   //필수체크
        	directSearchStore.loadStoreRecords();   
 
        },
        onResetButtonDown: function() {
        	searchGrid.reset();
        	directSearchStore.clearData();
        	panelSearch.clearForm();
            panelResult.clearForm();
            UniAppManager.setToolbarButtons(['save'], false);
        }
    });
   
};

</script>