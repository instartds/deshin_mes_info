<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep860ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="J516" /> <!-- 결재유형 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var gsChargeCode = '${getChargeCode}';

var BsaCodeInfo = { 
    paySysGubun: '${paySysGubun}'      //MIS , SAP 구분관련
}
function appMain() {   
	var activeGridId = 'aba700MasterGrid';
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aep860ukrMasterModel', {
	   fields: [
			{name: 'FAVORITE_NO'        , text: 'FAVORITE_NO'  , type: 'string'},
			{name: 'EMPLOYEE_NO'        , text: '기안자사번'  , type: 'string', allowBlank: false},
			{name: 'NAME'               , text: '기안자명'       , type: 'string', editable: false},
            {name: 'DEPT_NAME'          , text: '부서명'          , type: 'string', editable: false},
			{name: 'FAVORITE_TITLE'		, text: '결재선명'	   , type: 'string', allowBlank: false, maxLength: 100},
			{name: 'DEFAULT_YN'			, text: '기본'	   , type: 'boolean'},
			{name: 'FAVORITE_DESC'		, text: '결재선내용'	       , type: 'string', maxLength: 200}
	    ]
	});
	
	Unilite.defineModel('Aep860ukrDetailModel', {
	   fields: [
			{name: 'FAVORITE_NO'        , text: 'FAVORITE_NO'  , type: 'string'},
			{name: 'EMPLOYEE_NO'        , text: 'EMPLOYEE_NO'  , type: 'string'},
		    {name: 'APPR_TYPE'			, text: '결재구분'			, type: 'string',comboType: 'AU', comboCode: 'J516', allowBlank: false},
			{name: 'APPR_EMP_NO'        , text: '결재자사번'       , type: 'string', allowBlank: false},
			{name: 'NAME'               , text: '결재자성명'       , type: 'string'},
			{name: 'DEPT_NAME'          , text: '부서명'          , type: 'string', editable: false}
	    ]
	});
	 
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aep860ukrService.selectMasterList',
			update: 'aep860ukrService.updateMaster',
			create: 'aep860ukrService.insertMaster',
			destroy: 'aep860ukrService.deleteMaster',
			syncAll: 'aep860ukrService.saveAll'
		}
	});
	
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aep860ukrService.selectDetailList',
			update: 'aep860ukrService.updateDetail',
			create: 'aep860ukrService.insertDetail',
			destroy: 'aep860ukrService.deleteDetail',
			syncAll: 'aep860ukrService.saveAll'
		}
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aba700MasterStore',{
		model: 'Aep860ukrMasterModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords: function() {
			var param = {COMP_CODE: UserInfo.compCode}			
			console.log(param);
			this.load({
				params : param
			});
			
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
//					params:[panelSearch.getValues()],
					success : function()	{
						directMasterStore.loadStoreRecords();
					}
				}
				this.syncAllDirect(config);			
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
				if( directDetailStore.isDirty() || store.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore = Unilite.createStore('aba700DetailStore',{
		model: 'Aep860ukrDetailModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy,
        loadStoreRecords: function(record) {
			var param = record;			
			console.log(param);
			this.load({
				params : param
			});
			
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
//					params:[panelSearch.getValues()],
					success : function()	{
						
					}
				}
				this.syncAllDirect(config);			
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
				if( directMasterStore.isDirty() || store.isDirty() )	{
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aba700MasterGrid', {
    	layout : 'fit',
        region : 'center',
        title: '기준정보',
		store: directMasterStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
    	features: [{
    		id: 'masterGridSubTotal1',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal1', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [
//            {dataIndex: 'FAVORITE_NO'               , width: 90},
            {dataIndex: 'EMPLOYEE_NO'               , width: 90,
                'editor' : Unilite.popup('Employee_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                rtnRecord.set('EMPLOYEE_NO', records[0]['PERSON_NUMB']);
                                rtnRecord.set('NAME', records[0]['NAME']);
                                rtnRecord.set('DEPT_NAME', records[0]['DEPT_NAME']);  
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('EMPLOYEE_NO','');
                            grdRecord.set('NAME','');
                            grdRecord.set('DEPT_NAME','');
                        },
                        applyextparam: function(popup){ 
                        }
                    }
                })
            },
            {dataIndex: 'NAME'                      , width: 100,
            'editor' : Unilite.popup('Employee_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                var rtnRecord = masterGrid.uniOpt.currentRecord;    
                                rtnRecord.set('EMPLOYEE_NO', records[0]['PERSON_NUMB']);
                                rtnRecord.set('NAME', records[0]['NAME']);
                                rtnRecord.set('DEPT_NAME', records[0]['DEPT_NAME']);  
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('EMPLOYEE_NO','');
                            grdRecord.set('NAME','');
                            grdRecord.set('DEPT_NAME','');
                        },
                        applyextparam: function(popup){ 
                        }   
                    }
                })
            },
            {dataIndex: 'DEPT_NAME'         , width: 120},
            
        	{dataIndex: 'FAVORITE_TITLE'		 , width: 160},
        	{ dataIndex:'DEFAULT_YN'             , width: 70, xtype : 'checkcolumn',  align: 'center'},
        	{dataIndex: 'FAVORITE_DESC'	         , minWidth: 100, flex: 1}
		],
        listeners: {
        	selectionchange:function( model1, selected, eOpts ){
        		directDetailStore.loadData({})
        		if(selected.length > 0)	{
	        		var record = selected[0].data;	
	        		if(!record.phantom){
	        			directDetailStore.loadStoreRecords(record);
	        		}
       			}
          	},
          	render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGridId = grid.getItemId();
			    	if( directDetailStore.isDirty() || directMasterStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
			    });
			 },	
			 beforedeselect : function ( gird, record, index, eOpts ){
				if(directDetailStore.isDirty())	{
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
						var inValidRecs = directDetailStore.getInvalidRecords();
						if(inValidRecs.length > 0 )	{
							alert(Msg.sMB083);
							return false;
						}else {
							directDetailStore.saveStore();
						}
					}
					
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
//          		if (UniUtils.indexOf(e.field,'REMARK_CD')) {
//					if(e.record.phantom){
//						return true;
//					}else{
//						return false;
//					}
//				}else if (UniUtils.indexOf(e.field, 'REMARK')) {
//					return true;
//				}else{
//					return false;
//				}
			}
        }
    });  
    
    var detailGrid = Unilite.createGrid('aba700DetailGrid', {
    	layout : 'fit',
        region : 'east',
        title: '결재선',
		store: directDetailStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true,
            onLoadSelectFirst: false
//		 	useContextMenu: true,
        },
    	features: [{
    		id: 'masterGridSubTotal2',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal2', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [
//            {dataIndex: 'FAVORITE_NO'       , width: 100, hidden: true},
//            {dataIndex: 'EMPLOYEE_NO'       , width: 100, hidden: true},
            {dataIndex: 'APPR_TYPE'			, width: 100},
            {dataIndex: 'APPR_EMP_NO'               , width: 90,
                'editor' : Unilite.popup('Employee_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                            	var mRec = masterGrid.getSelectedRecord();
                            	
                            	if(BsaCodeInfo.paySysGubun != '1'){
                            	
                                	if(records[0]['PERSON_NUMB'] == mRec.get('EMPLOYEE_NO')){
                                	   alert('기안자 사번과 결재자 사번이 같습니다.');
                                	   return false;
                                	}
                            	}
                            	
                            	
                            	
                            	
                                var rtnRecord = detailGrid.uniOpt.currentRecord;    
                                rtnRecord.set('APPR_EMP_NO', records[0]['PERSON_NUMB']);
                                rtnRecord.set('NAME', records[0]['NAME']);
                                rtnRecord.set('DEPT_NAME', records[0]['DEPT_NAME']);  
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('APPR_EMP_NO','');
                            grdRecord.set('NAME','');
                            grdRecord.set('DEPT_NAME','');
                        },
                        applyextparam: function(popup){ 
                        }
                    }
                })
            },
            {dataIndex: 'NAME'                      , width: 100,
            'editor' : Unilite.popup('Employee_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                            	var mRec = masterGrid.getSelectedRecord();
                            	
                            	if(BsaCodeInfo.paySysGubun != '1'){
                                	if(records[0]['PERSON_NUMB'] == mRec.get('EMPLOYEE_NO')){
                                       alert('기안자 사번과 결재자 사번이 같습니다.');
                                       return false;
                                    }
                            	}
                                var rtnRecord = detailGrid.uniOpt.currentRecord;    
                                rtnRecord.set('APPR_EMP_NO', records[0]['PERSON_NUMB']);
                                rtnRecord.set('NAME', records[0]['NAME']);
                                rtnRecord.set('DEPT_NAME', records[0]['DEPT_NAME']);  
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = detailGrid.uniOpt.currentRecord;
                            grdRecord.set('APPR_EMP_NO','');
                            grdRecord.set('NAME','');
                            grdRecord.set('DEPT_NAME','');
                        },
                        applyextparam: function(popup){ 
                        }   
                    }
                })
            },
            {dataIndex: 'DEPT_NAME'         , minWidth: 200, flex: 1}
        ],
		listeners : {
			render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGridId = grid.getItemId();
			    	if( directDetailStore.isDirty() || directMasterStore.isDirty())	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);		
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
			    });
			 },
			beforeedit  : function( editor, e, eOpts ) {
//          		if (UniUtils.indexOf(e.field,["DR_CR", "ACCNT", "ACCNT_NAME"])) {
//					if(e.record.phantom){
//						return true;
//					}else{
//						return false;
//					}
//				}else{
//					return false;
//				}
			}
		} 
    }); 
    
	 Unilite.Main( {
		borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					{
						region : 'west',
						xtype : 'container',
						layout : 'fit',
						width : 950,
						items : [ masterGrid ]
					}, {
						region : 'center',
						xtype : 'container',
						layout : 'fit',
						flex : 1,
						items : [ detailGrid ]
					}
				]	
			}
		], 
		id : 'aba700App',
		fnInitBinding : function() {
//			alert(gsChargeCode);
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['reset'],true);			
		},
		onQueryButtonDown : function()	{	
			directMasterStore.loadStoreRecords();
		}, 
		onNewDataButtonDown : function() {
			if(activeGridId == 'aba700MasterGrid' )	{
				var r = {
				    EMPLOYEE_NO: UserInfo.personNumb,
				    NAME: UserInfo.userName,
				    DEPT_NAME: UserInfo.deptName
				}				
				masterGrid.createRow(r, 'FAVORITE_TITLE');		    	
			}else{
				var pRecord = masterGrid.getSelectedRecord();
				if(directMasterStore.getCount() > 0 && !pRecord.phantom){
					if(pRecord != null)  {
                        var r = {
                            FAVORITE_NO: pRecord.get('FAVORITE_NO'),
                            EMPLOYEE_NO: pRecord.get('EMPLOYEE_NO')
                        }
                        detailGrid.createRow(r, 'APPR_TYPE');
                    }
//				    var param = {EMPLOYEE_NO: pRecord.get('EMPLOYEE_NO')};
//                    var personNm = '';
//                    aep860ukrService.getpersonName(param, function(provider, response)   {
//                       if(!Ext.isEmpty(provider)){
//                            personNm = provider.NAME
//                       }
//                       
//                    });
				}else{
				    alert('먼저 저장을 하셔야 추가가 가능합니다.');					
				}
			}
		},
		onSaveDataButtonDown: function () {
			var masterInValidRecs = directMasterStore.getInvalidRecords();
			var detailInValidRecs = directDetailStore.getInvalidRecords();
			
			if(masterInValidRecs.length != 0 || detailInValidRecs.length != 0)	{
				if(masterInValidRecs.length != 0){					
					masterGrid.uniSelectInvalidColumnAndAlert(masterInValidRecs);					
				}else if(detailInValidRecs.length != 0){
					detailGrid.uniSelectInvalidColumnAndAlert(detailInValidRecs);
				}		
			}else{
				if(directMasterStore.isDirty())	{
					directMasterStore.saveStore();			//Master 데이타 저장 성공 후 Detail 저장함.
				}else if(directDetailStore.isDirty()){
					directDetailStore.saveStore();
				}
			}			
		},
        onResetButtonDown:function() {
            directMasterStore.loadData({}); 
            directDetailStore.loadData({});
            this.fnInitBinding();            
        },
		onDeleteDataButtonDown : function()	{
			if(activeGridId == 'aba700MasterGrid')	{
				var selRow = masterGrid.getSelectedRecord();
				if(selRow.phantom === true)	{
					masterGrid.deleteSelectedRow();
				}else {
					var toDelete = directDetailStore.getRemovedRecords();
					if(toDelete.length > 0 || directDetailStore.getCount() > 0){						
						alert(Msg.sMB078);
						return false;												
					}
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid.deleteSelectedRow();
					}					
				}
			}else{
				var selRow = detailGrid.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailGrid.deleteSelectedRow();				
				}
			}			
		}
	});	
};


</script>
