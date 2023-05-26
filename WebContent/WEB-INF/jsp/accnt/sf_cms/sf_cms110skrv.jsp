<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sf_cms110skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sf_cms110skrv"  />             <!-- 사업장 -->
    	<t:ExtComboStore items="${COMBO_BANK_CODE}" storeId="getBankCode" />  <!-- 은행코드 -->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var tempValue;
    var tempSum = 0;
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('detailModel', {
        fields: [
        
//            {name : '',        text : '순번',      type: 'int'},
        
        
            {name : 'DEALING_DTTM',   text : '입금일',      type: 'string'},
            {name : 'BANK_CD',        text : '은행',      type: 'string'},
            {name : 'BANK_NM',        text : '은행',      type: 'string'},
            {name : 'ACNUT_NO',        text : '계좌번호',      type: 'string'},
            {name : 'ACNUT_NM',        text : '계좌명',      type: 'string'},
            {name : 'DEPOSIT_NM',        text : '계좌별칭',      type: 'string'},
            {name : 'RCPMNY_AMT',        text : '입금',      type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name : 'DEFRAY_AMT',        text : '출금',      type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name : 'BLCE_AMT',        text : '잔액',      type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name : 'REMARK',        text : '적요',      type: 'string'},
            
            {name : 'SUM_RCPMNY_AMT_N',        text : 'SUM_RCPMNY_AMT_N',      type: 'string'},
            {name : 'SUM_DEFRAY_AMT_N',        text : 'SUM_DEFRAY_AMT_N',      type: 'string'},
            {name : 'SUM_BLCE_AMT_N',          text : 'SUM_BLCE_AMT_N',        type: 'string'},
            
            {name : 'SUM_RCPMNY_AMT_P',        text : 'SUM_RCPMNY_AMT_P',      type: 'string'},
            {name : 'SUM_DEFRAY_AMT_P',        text : 'SUM_DEFRAY_AMT_P',      type: 'string'},
            {name : 'SUM_BLCE_AMT_P',          text : 'SUM_BLCE_AMT_P',        type: 'string'}
        ]
    }); 

    var detailStore = Unilite.createStore('detailStore', {
        model: 'detailModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 'sf_cms110skrvService.selectDetail'}
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
            		tempSum = records[0].get('CALC_BLCE_AMT');
            		
            		subForm.setValue('SUM_RCPMNY_AMT_N',records[0].get('SUM_RCPMNY_AMT_N'));
            		subForm.setValue('SUM_DEFRAY_AMT_N',records[0].get('SUM_DEFRAY_AMT_N'));
            		subForm.setValue('SUM_BLCE_AMT_N',records[0].get('SUM_BLCE_AMT_N'));
            		
            		subForm.setValue('CALC_RCPMNY_AMT',records[0].get('CALC_RCPMNY_AMT'));
            		subForm.setValue('CALC_DEFRAY_AMT',records[0].get('CALC_DEFRAY_AMT'));
            		subForm.setValue('CALC_BLCE_AMT',records[0].get('CALC_BLCE_AMT'));
            	}
            }
        },
        grouper: {
        	property: 'BANK_NM',
        	groupFn: function (item) {
				return item.get('BANK_NM') + ', 계좌번호: ' + item.get('ACNUT_NO');
         	}
        }
    });
    
	var panelSearch = Unilite.createSearchForm('panelSearch', {
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
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
				boxLabel : '입금', 
				width: 70,
				name: 'WORK_TYPE',
				inputValue: '1'
			},{
				boxLabel : '출금', 
				width: 70,
				name: 'WORK_TYPE',
				inputValue: '2'
			}]
		},{
            fieldLabel: '조회기간',
            xtype: 'uniDateRangefield',
            startFieldName: 'DEALING_DT_FR',
            endFieldName: 'DEALING_DT_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank:false
        },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			items:[{
	            fieldLabel: '조회조건',
	            name: 'BANK_CD',
	            xtype: 'uniCombobox',
	            store:Ext.data.StoreManager.lookup("getBankCode")
	        },{
	            fieldLabel: '',
	            name: 'ACNUT_NO',
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
				inputValue: '1',
				checked: true 
			},{
				boxLabel : '계좌번호', 
				width: 100,
				name: 'WORK_TYPE2',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.WORK_TYPE2 = '1'){
						detailStore.setConfig('groupField','BANK_CD');
//						detailGrid.getStore().group('BANK_CD');
						
//            			detailGrid.getStore().loadData({});
					}else{
//						detailStore.setConfig('groupField', false);    
						detailStore.setConfig('groupField','ACNUT_NO');
//						detailGrid.getStore().group('ACNUT_NO');
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
                fieldLabel: '입금',
				name:'SUM_RCPMNY_AMT_N',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			},{
                fieldLabel: '',
				name:'CALC_RCPMNY_AMT',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			},{
                fieldLabel: '출금',
				name:'SUM_DEFRAY_AMT_N',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
//				suffixTpl:'%'
			},{
                fieldLabel: '',
				name:'CALC_DEFRAY_AMT',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			},{
                fieldLabel: '잔액',
				name:'SUM_BLCE_AMT_N',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			},{
                fieldLabel: '',
				name:'CALC_BLCE_AMT',
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
            {dataIndex : 'DEALING_DTTM',                 width : 120, align:'center',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            },
            {dataIndex : 'BANK_CD',                 width : 100, hidden:true},
            {dataIndex : 'BANK_NM',                 width : 100},
            {dataIndex : 'ACNUT_NO',                   width : 150},
            {dataIndex : 'ACNUT_NM',                   width : 150},
            {dataIndex : 'DEPOSIT_NM',                 width : 200},
            {dataIndex : 'RCPMNY_AMT',                 width : 150, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            {dataIndex : 'DEFRAY_AMT',                 width : 150, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            {dataIndex : 'BLCE_AMT',                   width : 150, summaryType:'sum',
				renderer:function(value, summaryData, dataIndex, metaData ) {
					tempValue = value;
					return Ext.util.Format.number(value, '0,000.00');
				},
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(tempValue, '0,000.00')+'</div>','<div align="right">'+Ext.util.Format.number(tempSum, '0,000.00')+'</div>');
				}
            },
            {dataIndex : 'REMARK',                     width : 300}
            
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
        id  : 'sf_cms110skrvApp',
        fnInitBinding : function(params) {
        	
            this.setDefault(params);
        },
        onQueryButtonDown : function()  {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            detailStore.loadStoreRecords();
//            UniAppManager.app.fnCalcFormTotal();
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
            subForm.clearForm();
            detailGrid.getStore().loadData({});
            this.setDefault();
        },
        setDefault: function(params) {
            detailStore.setGrouper({
	        	property: 'BANK_NM',
	        	groupFn: function (item) {
					return item.get('BANK_NM') + ', 계좌번호: ' + item.get('ACNUT_NO');
	         	}
	        });
        	panelSearch.setValue('WORK_TYPE', '');
        	
        	if(Ext.isEmpty(params)){
	            panelSearch.setValue('DEALING_DT_FR', UniDate.get('startOfMonth'));
	            panelSearch.setValue('DEALING_DT_TO', UniDate.get('today'));
        	}else{
        		this.processParams(params)
        	}
            UniAppManager.setToolbarButtons(['save'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
			
        },
		processParams: function(params) {
			if(!Ext.isEmpty(params)){
				this.uniOpt.appParams = params;
				if(params.PGM_ID == 'sf_cms100skrv') {
					if(!Ext.isEmpty(params.BANK_CD)){
						
			            panelSearch.setValue('DEALING_DT_FR', UniDate.get('startOfYear'));
			            panelSearch.setValue('DEALING_DT_TO', UniDate.get('today'));
			            
			        	panelSearch.setValue('BANK_CD', params.BANK_CD);
			        	panelSearch.setValue('ACNUT_NO', params.ACNUT_NO);
						
						
//						panelSearch.setValues({
//							'BANK_CD':		params.BANK_CD,
//							'ACNUT_NO':		params.ACNUT_NO
//						});
		   				detailStore.loadStoreRecords();
//
		   			}
				}
			}
		}
    });
}
</script>