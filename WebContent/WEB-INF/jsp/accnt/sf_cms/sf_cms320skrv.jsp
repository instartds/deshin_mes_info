<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sf_cms320skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sf_cms320skrv"  />             <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" 	comboCode="AC02" /> 			<!-- 급여지급방식 -->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('detailModel', {
        fields: [
            {name : 'COMP_CODE',   			text : '법인코드',     type: 'string'},
            {name : 'CPR_CARD_USE_DT',   	text : '이용일자',     type: 'string'},
            {name : 'BANK_CD',        		text : '카드사코드',    type: 'string'},
            {name : 'BANK_NM',        		text : '카드사',       type: 'string'},
            {name : 'CPR_CARD_NO',        	text : '카드번호',     type: 'string'},
            {name : 'CMS_CARD_NM',        	text : '카드별칭',     type: 'string'},
            {name : 'CPR_CARD_USE_AMT',   	text : '이용금액',     type: 'float', format:'0,000'},
            {name : 'CPR_CARD_REQ_AMT',   	text : '청구금액',     type: 'float', format:'0,000'},
            {name : 'CPR_CARD_BLCE_AMT',   	text : '수수료',       type: 'float', format:'0,000'},
            {name : 'CPR_CARD_SETT_DT',     text : '결제일',       type: 'string'},
            {name : 'CPR_CARD_PRE_DT',      text : '출금예정일',    type: 'string'},
            {name : 'MRHST_NM',        		text : '가맹점명',     type: 'string'},
            {name : 'MRHST_REG_NO',        	text : '사업자등록번호', type: 'string'},
            {name : 'MRHST_INDUTY',        	text : '업종', 		type: 'string'},
            {name : 'MRHST_TEL_NO',        	text : '전화번호', 	type: 'string'},
            {name : 'MRHST_CEO_NM',        	text : '대표자', 		type: 'string'},
            {name : 'SUMRY_CD',        		text : '적요',       type: 'string'}
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
            api: {read: 'sf_cms320skrvService.selectDetail'}
        },
        loadStoreRecords : function()   {
            var param = panelSearch.getValues();
            this.load({
                  params : param
            });         
        }
/*        ,
        listeners: {
            load: function(store, records, successful, eOpts) {
            	if(!Ext.isEmpty(records)){
            		subForm.setValue('SUM_LMT_AMT',records[0].get('SUM_LMT_AMT'));
            		subForm.setValue('SUM_LMT_USE_AMT',records[0].get('SUM_LMT_USE_AMT'));
            		subForm.setValue('SUM_LMT_BLCE_AMT',records[0].get('SUM_LMT_BLCE_AMT'));
            		
            	}
            }
        }*/
/*        ,
        grouper: {
        	property: 'BANK_NM',
        	groupFn: function (item) {
				return item.get('BANK_NM') + ', 계좌번호: ' + item.get('ACNUT_NO');
         	}
        }*/
    });
    
    Unilite.defineModel('masterModel', {
        fields: [
            {name : 'COMP_CODE',   			text : '법인코드',    type: 'string'},
            {name : 'SUM_LMT_AMT',   		text : '한도금액',    type: 'string'},
            {name : 'SUM_LMT_USE_AMT',    	text : '이용금액',    type: 'string'},
            {name : 'SUM_LMT_BLCE_AMT',     text : '한도잔액',    type: 'string'}
        ]
    }); 

    var masterStore = Unilite.createStore('masterStore', {
        model: 'masterModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 'sf_cms320skrvService.selectMaster'}
        },
        loadStoreRecords : function()   {
            var param = panelSearch.getValues();
            this.load({
                  params : param
            });         
        }
     ,
        listeners: {
            load: function(store, records, successful, eOpts) {
            	if(!Ext.isEmpty(records)){
            		subForm.setValue('SUM_LMT_AMT', records[0].get('SUM_LMT_AMT'));
            		subForm.setValue('SUM_LMT_USE_AMT', records[0].get('SUM_LMT_USE_AMT'));
            		subForm.setValue('SUM_LMT_BLCE_AMT', records[0].get('SUM_LMT_BLCE_AMT'));
            		
            	} else {
            		subForm.setValue('SUM_LMT_AMT', '');
            		subForm.setValue('SUM_LMT_USE_AMT', '');
            		subForm.setValue('SUM_LMT_BLCE_AMT', '');
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
            fieldLabel: '조회월',
            xtype: 'uniMonthfield',
            name:'CPR_CARD_CONFM_DT',
            value: UniDate.get('today'),
            allowBlank:false
        },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			items:[{
	            fieldLabel: '조회조건',
	            name: 'BANK_CD',
	            xtype: 'uniCombobox',
	            //store:Ext.data.StoreManager.lookup("getBankCode")      
                comboType: 'AU',
                comboCode: 'AC02'
	        },{
	            fieldLabel: '',
	            name: 'CMS_CARD_NM',
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
          	defaults:{
          		readOnly: true
          		
          	},
			items:[{
                fieldLabel: '한도금액',
				name:'SUM_LMT_AMT',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
			}
			,{
                fieldLabel: '이용금액',
				name:'SUM_LMT_USE_AMT',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000'
//				suffixTpl:'%'
			}
			,{
                fieldLabel: '한도잔액',
				name:'SUM_LMT_BLCE_AMT',
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
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
        selModel: 'rowmodel',
        columns:  [
        	{dataIndex : 'COMP_CODE',               width : 100, hidden:true},
            {dataIndex : 'CPR_CARD_USE_DT',         width : 110, align:'center',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            },
            {dataIndex : 'BANK_CD',                 width : 100, hidden:true},
            {dataIndex : 'BANK_NM',                 width : 100},
            {dataIndex : 'CPR_CARD_NO',             width : 150, align:'center'},
            {dataIndex : 'CMS_CARD_NM',             width : 150},
            
            {dataIndex : 'CPR_CARD_USE_AMT',        width : 120, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            	
            {dataIndex : 'CPR_CARD_REQ_AMT',        width : 120, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            	
            {dataIndex : 'CPR_CARD_BLCE_AMT',       width : 120, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            	
            {dataIndex : 'CPR_CARD_SETT_DT',        width : 80, align:'center'},
            {dataIndex : 'CPR_CARD_PRE_DT',         width : 110, align:'center'},
            
            {dataIndex : 'MRHST_NM',                width : 200},
            {dataIndex : 'MRHST_REG_NO',            width : 130, align:'center'},            
            {dataIndex : 'MRHST_INDUTY',            width : 100},
            {dataIndex : 'MRHST_TEL_NO',            width : 200},
            {dataIndex : 'MRHST_CEO_NM',            width : 110},			
			{dataIndex : 'SUMRY_CD',                width : 120}
            
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
        id  : 'sf_cms320skrvApp',
        fnInitBinding : function(params) {
        	
            this.setDefault(params);
        },
        onQueryButtonDown : function()  {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            detailStore.loadStoreRecords();
            masterStore.loadStoreRecords();
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
					//return item.get('BANK_NM') + ', 계좌번호: ' + item.get('CPR_CARD_NO');
					return item.get('BANK_NM');
	         	}
	        });
        	
        	if(Ext.isEmpty(params)){
	            panelSearch.setValue('CPR_CARD_CONFM_DT', UniDate.get('today'));
        	}/*else{
        		this.processParams(params)
        	}*/
            UniAppManager.setToolbarButtons(['save'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
			
        }
/*        ,
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
		}*/
    });
}
</script>