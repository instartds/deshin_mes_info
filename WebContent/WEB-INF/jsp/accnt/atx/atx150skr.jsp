<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx150skr"  >
    <t:ExtComboStore comboType="AU" comboCode="A003" /> <!--매입매출구분-->
</t:appConfig>
<script type="text/javascript" >
function appMain() {    
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('atx150skrModel', {
	    fields: [
            {name: 'COMP_CODE'                     ,text: 'COMP_CODE'     ,type: 'string'},
            {name: 'BILL_DIV_CODE'                 ,text: '신고사업장'      ,type: 'string'},
            {name: 'DIV_NAME'                      ,text: '신고사업장명'      ,type: 'string'},
            {name: 'INOUT_DIVI'                    ,text: '구분'           ,type: 'string', comboType: 'AU', comboCode:'A003' },
            {name: 'SUPPLY_AMT_I'                  ,text: '공급가액'        ,type: 'uniPrice'},
            {name: 'TAX_AMT_I'                     ,text: '세액'           ,type: 'uniPrice'},
            {name: 'DR_AMT_I'                      ,text: '차변금액'        ,type: 'uniPrice'},
            {name: 'CR_AMT_I'                      ,text: '대변금액'        ,type: 'uniPrice'},
            {name: 'JAN_AMT_I'                     ,text: '잔액'           ,type: 'uniPrice'},            
            {name: 'DIFFER_AMT_I'                  ,text: '세액차이'        ,type: 'uniPrice'}
		]
	});
	
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'atx150skrService.selectMasterList'
        }
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx150skrMasterStore',{
        model: 'atx150skrModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,            // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords: function() {
        	var startField = panelSearch.getField('AC_DATE_FR');
            var startDateValue = startField.getStartDate();           
            var endField = panelSearch.getField('AC_DATE_TO');
            var endDateValue = endField.getEndDate(); 
              
            var param= Ext.getCmp('searchForm').getValues();    
            param.AC_DATE_FR = startDateValue;
            param.AC_DATE_TO = endDateValue;
            
            this.load({
                params : param
            });
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
            items: [{
                fieldLabel: '부가세신고기간',
                width: 315,
                xtype: 'uniMonthRangefield',
                startFieldName: 'AC_DATE_FR',
                endFieldName: 'AC_DATE_TO',
                startDD:'first',
                endDD:'last',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),   
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('AC_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('AC_DATE_TO',newValue);
                    }
                }
            }]
        }]
    }); // end panelSearch
    
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '부가세신고기간',
            labelWidth: 120,
            xtype: 'uniMonthRangefield',
            startFieldName: 'AC_DATE_FR',
            endFieldName: 'AC_DATE_TO',
            startDD:'first',
            endDD:'last',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),   
            allowBlank: false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('AC_DATE_FR',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('AC_DATE_TO',newValue);
                }
            }
        }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('masterGrid', {    	
    	layout : 'fit',
    	region: 'center',
        store : directMasterStore, 
        uniOpt:{	
        	expandLastColumn: true,
		 	useRowNumberer: true,
		 	copiedRow: true
        },
    	features: [{
    		id: 'masterGridSubTotal1',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns: [
//            {dataIndex:'COMP_CODE'                     , width:120, },
            {dataIndex:'BILL_DIV_CODE'                 , width:90},
            {dataIndex:'DIV_NAME'                      , width:120},
            {dataIndex:'INOUT_DIVI'                    , width:100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
            {
                text: '부가세정보',
                columns: [
                    {dataIndex:'SUPPLY_AMT_I'                  , width:120, summaryType: 'sum'},
                    {dataIndex:'TAX_AMT_I'                     , width:120, summaryType: 'sum'}                
                ]
            },
            {
                text: '보조부정보',
                columns: [
                    {dataIndex:'DR_AMT_I'                      , width:120, summaryType: 'sum'},
                    {dataIndex:'CR_AMT_I'                      , width:120, summaryType: 'sum'},
                    {dataIndex:'JAN_AMT_I'                     , width:120, summaryType: 'sum'}               
                ]
            },            
            {dataIndex:'DIFFER_AMT_I'                  , width:120}
        ], 
        listeners: {
            itemmouseenter:function(view, record, item, index, e, eOpts )   {               
                view.ownerGrid.setCellPointer(view, item);
            },
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                masterGrid.gotoAgj(record, cellIndex);
            }
        },
/*          uniRowContextMenu:{                                             //마우스 오른 쪽 링크 삭제(20170110)
            items: [
                 {  text: '매출매입장 보기',  
                    itemId  : 'linkAgj100ukr',
                    handler: function(menuItem, event) {
                        var param = menuItem.up('menu');
                        masterGrid.gotoAgj(param.record);
                    }
                },{ text: '보조무 보기',  
                    itemId  : 'linkAgj110ukr', 
                    handler: function(menuItem, event) {
                        var param = menuItem.up('menu');
                        masterGrid.gotoAgj(param.record);
                    }
                }
            ]
        },
        onItemcontextmenu:function( menu, grid, record, item, index, event  )   {   
            if(panelSearch.getValue('SLIP_DIVI') == 1){ 
                if(record.get('INPUT_DIVI') == '2' || record.get('INPUT_DIVI') == '3') {
                    menu.down('#linkAgj100ukr').hide();
                    menu.down('#linkAgj110ukr').hide();

                } else {
                    menu.down('#linkAgj100ukr').hide();
                    menu.down('#linkAgj110ukr').hide();
                }
                return true;
            }
            else if(panelSearch.getValue('SLIP_DIVI') == 2){
                if(record.get('INPUT_DIVI') == '2') {
                    menu.down('#linkAgj100ukr').hide();
                    menu.down('#linkAgj110ukr').hide();
                
                } else {
                    menu.down('#linkAgj100ukr').show(); // 결의전표입력 보기
                    menu.down('#linkAgj110ukr').hide();
                }
                return true;
            }
        },
*/          
        gotoAgj:function(record, cellIndex)    {
        	//신고사업장 코드
        	var billDivCode = record.get('BILL_DIV_CODE');

        	var startField = panelSearch.getField('AC_DATE_FR');
            var startDateValue = startField.getStartDate();           
            var endField = panelSearch.getField('AC_DATE_TO');
            var endDateValue = endField.getEndDate(); 

        	
        	//매입매출장으로 이동
            if(cellIndex == 4 || cellIndex == 5){
                if(record)  {
                    var params = {
                        'PGM_ID'            : 'atx150skr',
                        'txtOrgCd'          : billDivCode,
                        'txtDivi'           : record.get('INOUT_DIVI'),
                        'txtFrDate'         : startDateValue,
                        'txtToDate'         : endDateValue
                    }
                    var rec1 = {data : {prgID : 'atx110skr', 'text':''}};                           
                    parent.openTab(rec1, '/accnt/atx110skr.do', params);
                }
                
            //보조부로 이동
            } else if(cellIndex == 6 || cellIndex == 7 || cellIndex == 8) {
                //사업장 코드
                var divCode;
                var accntCode;
                var accntName;
                
                if (record.get('INOUT_DIVI') == '1') {
                	accntCode = '1111300000';
                	accntName = '매입부가세대급금';
                	
                } else {
                    accntCode = '2100800000';
                    accntName = '매출부가세';
                }
                param = {
                    'BILL_DIV_CODE' : billDivCode
                };
                atx150skrService.getDivCode(param, function(provider, response){
                    if(provider.length != 0) {
                        divCode = provider;
                    }
                        
                    if(record)  {
                        var params = {
                            'PGM_ID'        : 'atx150skr',         
                            'DIV_CODE'      : divCode,
                            'FR_DATE'       : startDateValue,
                            'TO_DATE'       : endDateValue,
                            'ACCNT_CODE'    : accntCode,
                            'ACCNT_NAME'    : accntName
                        }
                        var rec1 = {data : {prgID : 'agb110skr', 'text':''}};                           
                        parent.openTab(rec1, '/accnt/agb110skr.do', params);
                    }
                });
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
                masterGrid, panelResult
            ]
        },
            panelSearch     
        ], 
		id : 'atx150skrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData'],false);
			UniAppManager.setToolbarButtons(['reset'],false);
			
			var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('AC_DATE_FR');
			
		},
		onQueryButtonDown : function()	{
			if(!panelResult.getInvalidMessage()){
                return false;
            }
			directMasterStore.loadStoreRecords();    
            var viewNormal = masterGrid.getView();
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		}
	});
};
</script>
