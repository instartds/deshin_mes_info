<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sf_cms200skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sf_cms200skrv"  />             <!-- 사업장 -->
    	

</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
    var statusStore = Unilite.createStore('statusComboStore', {  
	    fields: ['text', 'value'],
		data :  [
	        {'text':'거래처', 'value':'01'},
	        {'text':'대표자'	, 'value':'02'},
			{'text':'사업자등록번호'	, 'value':'03'},
			{'text':'품목명'	, 'value':'04'}
		]
	});
	var statusStore2 = Unilite.createStore('statusComboStore2', {  
	    fields: ['text', 'value'],
		data :  [
	        {'text':'기간', 'value':'01'},
	        {'text':'년도'	, 'value':'02'},
			{'text':'반기'	, 'value':'03'},
			{'text':'분기'	, 'value':'04'},
			{'text':'월'	, 'value':'05'}
		]
	});
	var statusStore3 = Unilite.createStore('statusComboStore3', {  
	    fields: ['text', 'value'],
		data :  [
	        {'text':'상반기', 'value':'01'},
	        {'text':'하반기'	, 'value':'02'}
		]
	});
	var statusStore4 = Unilite.createStore('statusComboStore4', {  
	    fields: ['text', 'value'],
		data :  [
	        {'text':'1분기', 'value':'01'},
	        {'text':'2분기'	, 'value':'02'},
	        {'text':'3분기'	, 'value':'03'},
	        {'text':'4분기'	, 'value':'04'}
		]
	});
	

	
	
	



    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('detailModel', {
        fields: [
        	
            {name : 'COMPANY_NO'			,text : '기업번호'		,type: 'string'},
            {name : 'CONFIRM_NO'			,text : '승인번호'		,type: 'string'},
            {name : 'ISSUE_DT'			 	,text : '발급일자'		,type: 'uniDate'},
            {name : 'RECIPTER_REG_NO'    	,text : '사업자등록번호'	,type: 'string'},		//공급받는자
            {name : 'RECIPTER_COMPANY_NM'	,text : '상호'		,type: 'string'},
            {name : 'RECIPTER_CEO_NM'    	,text : '대표자'		,type: 'string'},
            {name : 'ITEM_NM'            	,text : '품목'		,type: 'string'},
            {name : 'TOT_AMT'            	,text : '합계금액'		,type: 'float'	,decimalPrecision: 0, format:'0,000'},
            {name : 'SUPPLY_AMT'         	,text : '공급가액'		,type: 'float'	,decimalPrecision: 0, format:'0,000'},
            {name : 'TAX_AMT'            	,text : '세액'		,type: 'float'	,decimalPrecision: 0, format:'0,000'},
            {name : 'TAX_KIND'          	,text : '매입/매출'		,type: 'string'},
            {name : 'REMARK'            	,text : '적요'		,type: 'string'}
        
        
        ]
    }); 

    var detailStore = Unilite.createStore('detailStore', {
        model: 'detailModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,           // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 'sf_cms200skrvService.selectDetail'}
        },
        loadStoreRecords : function()   {
            var param = panelSearch.getValues();
            this.load({
                  params : param
            });         
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            	if(!Ext.isEmpty(records)){
            		subForm.setValue('SUM_RCPMNY_AMT_N',records[0].get('SUM_RCPMNY_AMT_N'));
            		subForm.setValue('SUM_DEFRAY_AMT_N',records[0].get('SUM_DEFRAY_AMT_N'));
            		subForm.setValue('SUM_BLCE_AMT_N',records[0].get('SUM_BLCE_AMT_N'));
            		
            		subForm.setValue('CALC_RCPMNY_AMT',records[0].get('CALC_RCPMNY_AMT'));
            		subForm.setValue('CALC_DEFRAY_AMT',records[0].get('CALC_DEFRAY_AMT'));
            		subForm.setValue('CALC_BLCE_AMT',records[0].get('CALC_BLCE_AMT'));
            	}
            }
        }
    });
    
	var panelSearch = Unilite.createSearchForm('panelSearch', {
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
			xtype: 'radiogroup',		            		
			fieldLabel: '조회구분',
			items: [{
				boxLabel: '전체', 
				width: 70, 
				name: 'WORK_TYPE',
				inputValue: '',
				checked: true 
			},{
				boxLabel : '매출', 
				width: 70,
				name: 'WORK_TYPE',
				inputValue: '01'
			},{
				boxLabel : '매입', 
				width: 70,
				name: 'WORK_TYPE',
				inputValue: '02'
			}]
		},{
			xtype: 'container',
			layout: { type: 'hbox'},
			width:500,
			items:[{
	            fieldLabel: '조회기간',
	            name: 'SEARCH_GUBUN1',
	            xtype: 'uniCombobox',
	            store: Ext.data.StoreManager.lookup('statusComboStore2'),
	            allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue == '01'){
							panelSearch.down('#issueDt').setHidden(false);
							panelSearch.getField('ISSUE_YYYY').setHidden(true);
							panelSearch.getField('ISSUE_SEMIANNUAL').setHidden(true);
							panelSearch.getField('ISSUE_QUARTER').setHidden(true);
							panelSearch.getField('ISSUE_YYYYMM').setHidden(true);
						}else if(newValue == '02'){
							
							panelSearch.down('#issueDt').setHidden(true);
							panelSearch.getField('ISSUE_YYYY').setHidden(false);
							panelSearch.getField('ISSUE_SEMIANNUAL').setHidden(true);
							panelSearch.getField('ISSUE_QUARTER').setHidden(true);
							panelSearch.getField('ISSUE_YYYYMM').setHidden(true);
						}else if(newValue == '03'){
							panelSearch.down('#issueDt').setHidden(true);
							panelSearch.getField('ISSUE_YYYY').setHidden(false);
							panelSearch.getField('ISSUE_SEMIANNUAL').setHidden(false);
							panelSearch.getField('ISSUE_QUARTER').setHidden(true);
							panelSearch.getField('ISSUE_YYYYMM').setHidden(true);
							
						}else if(newValue == '04'){
							panelSearch.down('#issueDt').setHidden(true);
							panelSearch.getField('ISSUE_YYYY').setHidden(false);
							panelSearch.getField('ISSUE_SEMIANNUAL').setHidden(true);
							panelSearch.getField('ISSUE_QUARTER').setHidden(false);
							panelSearch.getField('ISSUE_YYYYMM').setHidden(true);
						}else if(newValue == '05'){
							panelSearch.down('#issueDt').setHidden(true);
							panelSearch.getField('ISSUE_YYYY').setHidden(true);
							panelSearch.getField('ISSUE_SEMIANNUAL').setHidden(true);
							panelSearch.getField('ISSUE_QUARTER').setHidden(true);
							panelSearch.getField('ISSUE_YYYYMM').setHidden(false);
						}
					}
				}
	        },{
	            fieldLabel: '',
	            itemId:'issueDt',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'ISSUE_DT_FR',
	            endFieldName: 'ISSUE_DT_TO',
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today')
	        },{
                fieldLabel: '',
                xtype: 'uniYearField',
                name: 'ISSUE_YYYY'
            },{
	            fieldLabel: '',
	            name: 'ISSUE_SEMIANNUAL',
	            xtype: 'uniCombobox',
	            store: Ext.data.StoreManager.lookup('statusComboStore3')
	        },{
	            fieldLabel: '',
	            name: 'ISSUE_QUARTER',
	            xtype: 'uniCombobox',
	            store: Ext.data.StoreManager.lookup('statusComboStore4')
	        },{
				fieldLabel: '',
				xtype: 'uniMonthfield',
				name: 'ISSUE_YYYYMM',
				tdAttrs: {width: 10}
	        }]
			
        },{
			xtype: 'radiogroup',		            		
			fieldLabel: '기간구분',
			items: [{
				boxLabel: '작성일자', 
				width: 70, 
				name: 'PERIOD_GUBUN',
				inputValue: 'WT_DT',
				checked: true 
			},{
				boxLabel : '발급일자', 
				width: 70,
				name: 'PERIOD_GUBUN',
				inputValue: 'ISU_DT'
			},{
				boxLabel : '전송일자', 
				width: 70,
				name: 'PERIOD_GUBUN',
				inputValue: 'TRNS_DT'
			}]
		},{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 3},
			items:[{
	            fieldLabel: '조회조건',
	            name: 'SEARCH_GUBUN2',
	            xtype: 'uniCombobox',
	            store: Ext.data.StoreManager.lookup('statusComboStore')
	        },{
	            fieldLabel: '',
	            name: 'SEARCH_CONT',
	            xtype: 'uniTextfield'
	        }]
			
        }
        	
/*       {
			xtype: 'radiogroup',		            		
			fieldLabel: '소계조건',
			items: [{
				boxLabel: '은행', 
				width: 100, 
				name: 'WORK_TYPE2',
				inputValue: '01',
				checked: true 
			},{
				boxLabel : '계좌번호', 
				width: 100,
				name: 'WORK_TYPE2',
				inputValue: '02'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.WORK_TYPE2 = '01'){
						detailStore.setConfig('groupField','BANK_CD');
//						detailGrid.getStore().group('BANK_CD');
						
//            			detailGrid.getStore().loadData({});
					}else{
//						detailStore.setConfig('groupField', false);    
						detailStore.setConfig('groupField','search_cont');
//						detailGrid.getStore().group('search_cont');
//            			detailGrid.getStore().loadData({});
					}
				}
			}
		}
		*/
		
		
		]
    });
    
    var subForm = Unilite.createSearchForm('subForm', {
        region: 'north',
        layout : {type : 'uniTable', columns : 1/*, tableAttrs: {width: '99.5%'}*/},
        padding:'1 1 1 1',
        border:true,
        items: [{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 6},
          	padding: '0 0 0 0',
          	tdAttrs: {align: 'right'},
//      		margin: '0 10 0 50',
          	defaults:{
//          		rowspan:2
//	          	padding: '0 0 20 0'
//          		labelAlign: 'top',
            	readOnly: true
//            	width:100
          		
          	},
			items:[{
                fieldLabel: '매출',
				name:'SUM_TOT_AMT_1',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			},{
                fieldLabel: '',
				name:'CALC_TOT_AMT_1',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			},{
                fieldLabel: '매입',
				name:'SUM_TOT_AMT_2',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
//				suffixTpl:'%'
			},{
                fieldLabel: '',
				name:'CALC_TOT_AMT_2',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			},{
                fieldLabel: '매출 - 매입',
				name:'SUM_TOT_AMT_3',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			},{
                fieldLabel: '',
				name:'CALC_TOT_AMT_3',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			}]
        }]
    });
    
    var detailGrid = Unilite.createGrid('detailGrid', { 
        layout : 'fit',
        region: 'center', 
        store: detailStore,
        uniOpt: {
            expandLastColumn: false,
            onLoadSelectFirst : false, //조회시 첫번째 레코드 select 사용여부
            useMultipleSorting: false,
            useGroupSummary: true,
//            useContextMenu: true,
            useRowNumberer: true
//            filter: {
//                useFilter: true,
//                autoCreate: true
//            }
        },
        features: [{		
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
        selModel: 'rowmodel',
        columns:  [
        
            {dataIndex : 'COMPANY_NO'		,                 width : 100,hidden:true},
            {dataIndex : 'CONFIRM_NO'		,                 width : 100,hidden:true},
            {dataIndex : 'ISSUE_DT'			,                 width : 100,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            },
            {dataIndex : 'RECIPTER_REG_NO'   ,                 width : 150},
            {dataIndex : 'RECIPTER_COMPANY_NM',                width : 120},
            {dataIndex : 'RECIPTER_CEO_NM'   ,                 width : 80},
            {dataIndex : 'ITEM_NM'           ,                 width : 250},
            {dataIndex : 'TOT_AMT'           ,                 width : 150, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            {dataIndex : 'SUPPLY_AMT'        ,                 width : 150, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            {dataIndex : 'TAX_AMT'           ,                 width : 150, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            {dataIndex : 'TAX_KIND'          ,                 width : 80},
            {dataIndex : 'REMARK'            ,                 width : 300}
            
        ],
        listeners: {
        }
    });
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border : false,
	        items:[
                panelSearch,subForm, detailGrid
            ]   
        }],
        id  : 'sf_cms200skrvApp',
        fnInitBinding : function() {
        	
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            
            
            var param = panelSearch.getValues();
            sf_cms200skrvService.selectSumList(param, function(provider, response) {
            	if(!Ext.isEmpty(provider)){
            		
        			var sumTotAmt1N = 0;	// 현 기간 매출
        			var sumTotAmt1P = 0;	// 현대비 작년기간 매출
        			var calcTotAmt1 = 0;	// 현 기간 매출 - 현대비 작년기간 매출
        			
        			var sumTotAmt2N = 0;	// 현 기간 매입
        			var sumTotAmt2P = 0;	// 현대비 작년기간 매입
        			var calcTotAmt2 = 0;	// 현 기간 매출 - 현대비 작년기간 매입
        			
        			var sumTotAmt3 = 0;		// 현 기간 매출 - 현 기간 매입
        			var calcTotAmt3 = 0;	// (현 기간 매출 - 현대비 작년기간 매출) - (현 기간 매출 - 현대비 작년기간 매입)
        			
            		Ext.each(provider, function(record){
            			
            			if(record.TAX_KIND == '01'){ // 매출
            				if(record.GUBUN == 'N'){
            					sumTotAmt1N = record.TOT_AMT;
            				}else{
            					sumTotAmt1P = record.TOT_AMT;
            				}
            				
            			}else{	//매입
            				if(record.GUBUN == 'N'){
            					sumTotAmt2N = record.TOT_AMT;
            				}else{
            					sumTotAmt2P = record.TOT_AMT;
            				}
            			}
            		})
            		
            		calcTotAmt1 = sumTotAmt1N - sumTotAmt1P;
					calcTotAmt2 = sumTotAmt2N - sumTotAmt2P;
					sumTotAmt3 = sumTotAmt1N - sumTotAmt2N;
					calcTotAmt3 = calcTotAmt1 - calcTotAmt2;
					
					subForm.setValue('SUM_TOT_AMT_1',sumTotAmt1N);
					subForm.setValue('CALC_TOT_AMT_1',calcTotAmt1);
					subForm.setValue('SUM_TOT_AMT_2',sumTotAmt2N);
					subForm.setValue('CALC_TOT_AMT_2',calcTotAmt2);
					subForm.setValue('SUM_TOT_AMT_3',sumTotAmt3);
					subForm.setValue('CALC_TOT_AMT_3',calcTotAmt3);
					
					
            	}
            });
            
            
            detailStore.loadStoreRecords();
//            UniAppManager.app.fnCalcFormTotal();
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
            subForm.clearForm();
            detailGrid.getStore().loadData({});
            this.setDefault();
        },
        setDefault: function() {
        	
        	panelSearch.setValue('WORK_TYPE', '');  
        	panelSearch.setValue('SEARCH_GUBUN1', '01');
            panelSearch.setValue('ISSUE_DT_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('ISSUE_DT_TO', UniDate.get('today'));
            panelSearch.setValue('ISSUE_YYYY', UniDate.getDbDateStr(UniDate.get('today')).substring(0,4));
            panelSearch.setValue('ISSUE_SEMIANNUAL', '01');
            panelSearch.setValue('ISSUE_QUARTER', '01');
            panelSearch.setValue('ISSUE_YYYYMM', UniDate.get('today'));
            
			panelSearch.down('#issueDt').setHidden(false);
			panelSearch.getField('ISSUE_YYYY').setHidden(true);
			panelSearch.getField('ISSUE_SEMIANNUAL').setHidden(true);
			panelSearch.getField('ISSUE_QUARTER').setHidden(true);
			panelSearch.getField('ISSUE_YYYYMM').setHidden(true);
			
			//필드 히든관련 문제 있음 확인필요 
            
            UniAppManager.setToolbarButtons(['save'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
			
        }
    });
}
</script>