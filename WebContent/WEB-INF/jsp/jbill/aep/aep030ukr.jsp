<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep030ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="aep030ukr"/> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />		 <!--증빙유형-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {	
	
   /**
    *   Model 정의 
    * @type 
    */

	Unilite.defineModel('Aep030ukrModel', {
		fields: [ 
			{name: 'PAY_TERM_CD',		text: '지급조건',			type: 'string', comboType: 'AU',  comboCode: 'J669', allowBlank: false},
			{name: 'PAY_METH_CD',		text: '지급방법',			type: 'string', comboType: 'AU',  comboCode: 'J668', allowBlank: false},
			{name: 'PRE_YN',			text: '가지급정산',			type: 'string', comboType: 'AU',  comboCode: 'A020'},
			{name: 'REAL_YN',			text: '실물증빙',			type: 'string', comboType: 'AU',  comboCode: 'A020'},
			{name: 'TAX_YN',			text: '세금계산서',			type: 'string', comboType: 'AU',  comboCode: 'A020'},
			{name: 'WHT_YN',			text: '원천세',			type: 'string', comboType: 'AU',  comboCode: 'A020'},
			{name: 'USE_YN',			text: '사용여부',			type: 'string', comboType: 'AU',  comboCode: 'A020'}
		]
	});
   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'aep030ukrService.insertList',				
			read: 'aep030ukrService.selectList',
			update: 'aep030ukrService.updateList',
			destroy: 'aep030ukrService.deleteList',
			syncAll: 'aep030ukrService.saveAll'
		}
	});
	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore = Unilite.createStore('aep030ukrMasterStore1',{
         model: 'Aep030ukrModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: true,         // 수정 모드 사용 
               deletable:true,         // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
            },
            autoLoad: false,
            proxy: directProxy,
    		listeners : {
    	        load : function(store) {
    	        	
    	        }
    	    },
    	    loadStoreRecords : function()   {
	            var param= {COMP_CODE: UserInfo.compCode}	
            	this.load({
	               params : param
	            });
	        },
	        saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					config = {
	//					params: [paramMaster],
						success: function(batch, option) {
							
						 } 
					};
					this.syncAllDirect(config);				
				}else {    				
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				load: function(store, records, successful, eOpts) {
					
	           	}				
			}			
   });
   


    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('aep030ukrGrid1', {
       region: 'center',
        layout: 'fit',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore,
        columns: [    		
        	{dataIndex: 'PAY_TERM_CD',									width: 300},
        	{dataIndex: 'PAY_METH_CD',									width: 120},
        	{dataIndex: 'PRE_YN',										width: 120},
        	{dataIndex: 'REAL_YN',										width: 120},
        	{dataIndex: 'TAX_YN',										width: 120},
        	{dataIndex: 'WHT_YN',										width: 120},
        	{dataIndex: 'USE_YN',										width: 120}
        ],
        listeners: {
        	beforeedit: function(editor, e){
        		if(!e.record.phantom){
        			if(e.field == 'PAY_TERM_CD' || e.field == 'PAY_METH_CD'){
	        			return false;
	        		}
        		}        		
        	}, 
        	edit: function(editor, e) {
        		
			}
    	}
    });
   
   
    Unilite.Main( {
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	masterGrid
	     	]
	     }
	    ], 
      id  : 'aep030ukrApp',
      fnInitBinding : function() {
      	UniAppManager.setToolbarButtons(['reset','newData'], true);
      	masterGrid.getStore().loadStoreRecords();
      },
      onQueryButtonDown : function()   {
         masterGrid.getStore().loadStoreRecords();
      },
		onNewDataButtonDown : function() {			
			var r = {
				USE_YN: 'Y'				
			};
			masterGrid.createRow(r, 'PAY_TERM_CD');
		},
		onSaveDataButtonDown : function() {
			if (masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();
			}
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown : function() {			
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
   });
};


</script>