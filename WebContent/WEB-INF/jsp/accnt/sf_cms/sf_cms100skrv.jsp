<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sf_cms100skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="sf_cms100skrv"  />             <!-- 사업장 -->
    	<t:ExtComboStore items="${COMBO_BANK_CODE}" storeId="getBankCode" />  <!-- 은행코드 -->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('detailModel', {
        fields: [
        
//            {name : '',        text : '순번',      type: 'int'},
            {name : 'BANK_CD',        text : '은행',      type: 'string'},
            {name : 'BANK_NM',        text : '은행',      type: 'string'},
            {name : 'ACNUT_NO',        text : '계좌번호',      type: 'string'},
            {name : 'ACNUT_NM',        text : '계좌명',      type: 'string'},
            {name : 'DEPOSIT_NM',        text : '계좌별칭',      type: 'string'},
            {name : 'BLCE_AMT',        text : '잔액',      type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name : 'REMARK',        text : '적요',      type: 'string'}
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
            api: {read: 'sf_cms100skrvService.selectDetail'}
        },
        loadStoreRecords : function()   {
            var param = panelSearch.getValues();
            this.load({
                  params : param
            });         
        }
    });
    
	var panelSearch = Unilite.createSearchForm('panelSearch', {
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{
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
            useGroupSummary: false,
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
			showSummaryRow: false
		}],
        selModel: 'rowmodel',
        columns:  [
            {dataIndex : 'BANK_CD',                 width : 100, hidden:true},
            {dataIndex : 'BANK_NM',                 width : 100},
            {dataIndex : 'ACNUT_NO',                   width : 150},
            {dataIndex : 'ACNUT_NM',                   width : 150},
            {dataIndex : 'DEPOSIT_NM',                 width : 200},
            {dataIndex : 'BLCE_AMT',                   width : 150},
            {dataIndex : 'REMARK',                     width : 300},
            {
            	text: '계좌입출금현황',
				xtype: 'widgetcolumn',
				width: 120,
				widget: {
					xtype: 'button',
					text: '거래내역보기',
					listeners: {
						buffer:1,
						click: function(button, event, eOpts) {
							var record = event.record.data;
							detailGrid.returnCell(record);
						
						}
					}
				}
			}
        ],
        returnCell: function(record){
			var bankCd	= record.BANK_CD;
			var acnutNo	= record.ACNUT_NO;

			var params = {
				'PGM_ID' : 'sf_cms100skrv',
				'BANK_CD' : bankCd,
				'ACNUT_NO' : acnutNo
			}
			var rec1 = {data : {prgID : 'sf_cms110skrv', 'text':''}};
			parent.openTab(rec1, '/accnt/sf_cms110skrv.do', params);
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
        id  : 'sf_cms100skrvApp',
        fnInitBinding : function() {
        	
            this.setDefault();
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
        setDefault: function() {
            UniAppManager.setToolbarButtons(['save'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
        }
    });
}
</script>