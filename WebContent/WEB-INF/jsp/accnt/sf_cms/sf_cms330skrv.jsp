<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sf_cms330skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sf_cms330skrv"  />             <!-- 사업장 -->
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
            {name : 'SEQ_NO',   			text : '순번',      	 type: 'int'},
            {name : 'BANK_CD',        		text : '카드사코드',    type: 'string'},
            {name : 'BANK_NM',        		text : '카드사',       type: 'string'},
            {name : 'CPR_CARD_NO',        	text : '카드번호',     type: 'string'},
            {name : 'CMS_CARD_NM',        	text : '카드별칭',     type: 'string'},
            {name : 'LMT_AMT',   			text : '한도금액',     type: 'float',  format:'0,000'},
            {name : 'LMT_USE_AMT',   		text : '이용금액',     type: 'float',  format:'0,000'},
            {name : 'LMT_BLCE_AMT',   		text : '잔여금액',     type: 'float',  format:'0,000'},
            {name : 'SETT_DATE',        	text : '결제일',      type: 'string'}
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
            api: {read: 'sf_cms330skrvService.selectDetail'}
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
/*        
        ,
        grouper: {
       	property: 'BANK_NM',
        	groupFn: function (item) {
				return item.get('BANK_NM') + ', 계좌번호: ' + item.get('ACNUT_NO');
         	}
        }*/
    });
    
	var panelSearch = Unilite.createSearchForm('panelSearch', {
        region: 'north',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        items: [{
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
            {dataIndex : 'BANK_CD',                 width : 100, hidden:true},
            {dataIndex : 'BANK_NM',                 width : 100},
            {dataIndex : 'CPR_CARD_NO',             width : 150, align:'center'},
            {dataIndex : 'CMS_CARD_NM',             width : 150},
            
            {dataIndex : 'LMT_AMT',        width : 120, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            	
            {dataIndex : 'LMT_USE_AMT',    width : 120, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            	
            {dataIndex : 'LMT_BLCE_AMT',   width : 120, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            				
			{dataIndex : 'SETT_DATE',                width : 80, align:'center', hidden:true}
            
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
                panelSearch, detailGrid
            ]   
        }],
        id  : 'sf_cms330skrvApp',
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