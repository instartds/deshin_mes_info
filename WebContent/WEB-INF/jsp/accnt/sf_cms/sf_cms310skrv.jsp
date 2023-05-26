<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sf_cms310skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sf_cms310skrv"  />      <!-- 사업장 -->
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
            {name : 'CPR_CARD_CONFM_DT',   	text : '승인일',      type: 'string'},
            {name : 'CPR_CARD_CONFM_TM',    text : '승인시간',     type: 'string'},
            {name : 'BANK_CD',        		text : '카드사코드',   type: 'string'},
            {name : 'BANK_NM',        		text : '카드사',      type: 'string'},
            {name : 'CPR_CARD_NO',        	text : '카드번호',     type: 'string'},
            {name : 'CMS_CARD_NM',        	text : '카드별칭',     type: 'string'},
            
            {name : 'MRHST_NM',        		text : '가맹점명',     type: 'string'},
            {name : 'MRHST_REG_NO',        	text : '사업자등록번호', type: 'string'},
            
            {name : 'CPR_CARD_CONFM_AMT',   text : '승인금액',      type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name : 'CPR_CARD_CONFM_VAT',   text : '부가세',       type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name : 'CPR_CARD_CANCEL_DT',   text : '취소일자',     type: 'string'},
            {name : 'SUMRY_CD',        		text : '적요',        type: 'string'}
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
            api: {read: 'sf_cms310skrvService.selectDetail'}
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
*/
        
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
            api: {read: 'sf_cms310skrvService.selectMaster'}
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
            fieldLabel: '조회기간',
            xtype: 'uniDateRangefield',
            startFieldName: 'CPR_CARD_CONFM_DT_FR',
            endFieldName: 'CPR_CARD_CONFM_DT_TO',
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
	            //store:Ext.data.StoreManager.lookup("getBankCode")      
                comboType: 'AU',
                comboCode: 'AC02'
	        },{
	            fieldLabel: '',
	            name: 'CMS_CARD_NM',
	            xtype: 'uniTextfield'
	        }]
			
        },
        {
			xtype: 'radiogroup',		            		
			fieldLabel: '조회구분',
			items: [{
				boxLabel: '전체', 
				width: 70, 
				name: 'CANCEL_YN',
				inputValue: '',
				checked: true 
			},{
				boxLabel : '승인', 
				width: 70,
				name: 'CANCEL_YN',
				inputValue: 'N'
			},{
				boxLabel : '취소', 
				width: 70,
				name: 'CANCEL_YN',
				inputValue: 'Y'
			}]
		}]
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
            {dataIndex : 'CPR_CARD_CONFM_DT',       width : 110, align:'center',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
            },
            {dataIndex : 'CPR_CARD_CONFM_TM',       width : 100, hidden:false, align:'center'},
            {dataIndex : 'BANK_CD',                 width : 100, hidden:true},
            {dataIndex : 'BANK_NM',                 width : 100},
            {dataIndex : 'CPR_CARD_NO',             width : 150, align:'center'},
            {dataIndex : 'CMS_CARD_NM',             width : 150},
            {dataIndex : 'MRHST_NM',                width : 100},
            {dataIndex : 'MRHST_REG_NO',            width : 130, align:'center'},
            {dataIndex : 'CPR_CARD_CONFM_AMT',      width : 120, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
            {dataIndex : 'CPR_CARD_CONFM_VAT',      width : 120, summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000.00')+'</div>');
            	}},
			{dataIndex : 'CPR_CARD_CANCEL_DT',      width : 110, align:'center'},
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
        id  : 'sf_cms310skrvApp',
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
        	panelSearch.setValue('CANCEL_YN', '');
        	
        	if(Ext.isEmpty(params)){
	            panelSearch.setValue('CPR_CARD_CONFM_DT_FR', UniDate.get('startOfMonth'));
	            panelSearch.setValue('CPR_CARD_CONFM_DT_TO', UniDate.get('today'));
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