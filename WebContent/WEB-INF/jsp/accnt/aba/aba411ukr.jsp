<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba411ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A004" />	<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" />	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="A129" />	<!-- 통제계산 -->
	<t:ExtComboStore comboType="AU" comboCode="A130" />	<!-- 통제기간 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A015" />	<!-- 계정특성 -->
	<t:ExtComboStore comboType="AU" comboCode="A016" />	<!-- 자산부채특성 -->
	<t:ExtComboStore comboType="AU" comboCode="A017" />	<!-- 매출원가특성 -->
	<t:ExtComboStore comboType="AU" comboCode="A019" />	<!-- 비용구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A008" />	<!-- 계정과목유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A079" />	<!-- 회계부서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A123" />	<!-- 직/간접비구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A131" />	<!-- 실적집계대상단위 -->
	<t:ExtComboStore items="${PEND_LIST}" storeId="pendList" /><!--미결항목-->
	
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var gsFvalue= Array();
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aba411ukrModel', {
	   fields: [{name: 'ACCNT'				, text: '계정코드'				, type: 'string', allowBlank: false, editable: false, maxLength: 16},	    		
	    		{name: 'ACCNT_NAME'			, text: '계정과목명'			, type: 'string', editable: false},	 	  		
	    		{name: 'BUDG_YN'			, text: '예산사용여부'			, type: 'boolean' },    		
	    		{name: 'BUDGCTL_YN'			, text: '예산통제여부'			, type: 'boolean' },	    		
	    		{name: 'CTL_CAL_UNIT'		, text: '예산통제계산단위'		, type: 'string', comboType: 'AU', comboCode: 'A129'},	    		
	    		{name: 'CTL_TERM_UNIT'		, text: '예산통제기간단위'		, type: 'string', comboType: 'AU', comboCode: 'A130'},	    		
	    		{name: 'BUDGADD_YN'			, text: '추가예산사용여부'		, type: 'boolean' },
	    		{name: 'BUDGCHG_YN'			, text: '전용예산사용여부'		, type: 'boolean' },
	    		{name: 'BUDGCAR_YN'			, text: '이월예산사용여부'		, type: 'boolean' },	 
	    		{name: 'SLIP_SW'			, text: '전표사용여부'			, type: 'string' },
	    		{name: 'GROUP_YN'			, text: '그룹구분'				, type: 'string'},
	    		{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'		, type: 'string', defaultValue: UserInfo.userID},
	    		{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'		, type: 'string'},
	    		{name: 'COMP_CODE'	 		, text: 'COMP_CODE'				, type: 'string'}
	    		
	    		
	    ]
	});	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aba411ukrService.selectDetailList',
			update: 'aba411ukrService.updateDetail',
//			create: 'aba411ukrService.insertDetail',
//			destroy: 'aba411ukrService.deleteDetail',
			syncAll: 'aba411ukrService.saveAll'
		}
	});
	
	var directMasterStore = Unilite.createStore('aba411MasterStore1',{
		model: 'Aba411ukrModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : true			// prev | next 버튼 사용
        },        
        proxy: directProxy        
        ,listeners: {
//	            write: function(proxy, operation){
//	                if (operation.action == 'destroy') {
//	                	Ext.getCmp('detailForm').reset();	
//	                }                
//            	}
        	load: function(store, records, successful, eOpts) {
//        		if(Ext.isEmpty(records)){
//        			directMasterStore.clearData();
//        		}        		
           		UniAppManager.setToolbarButtons('newData', false);
           	},
        	update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//				detailForm.setActiveRecord(record);
			},
			metachange:function( store, meta, eOpts ){
				
			}
        	
        } // listeners
        
		// Store 관련 BL 로직
        // 검색 조건을 통해 DB에서 데이타 읽어 오기 
		,loadStoreRecords : function()	{
			var param= panelSearch.getValues();			
			console.log( param );
			this.load({
				params : param,
					callback : function(records, operation, success) {
						if(success)	{
							
						}
					}
			});
		}
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		,saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			
//			joins프로젝트중 삭제 from.송은주팀장님 2016.09.07
//        	var toUpdate = this.getUpdatedRecords();
//        	var list = [].concat(toUpdate,toCreate);
//        	var isErr = false;
//        	Ext.each(list, function(record, index) {
//	        	if(record.get('PEND_YN') == "Y" && Ext.isEmpty(record.get('PEND_CODE'))){
//					alert('미결항목을 입력하십시오.');
//					isErr = true;
//					return false
//				}
//        	});
//        	if(isErr) return false;
			if(inValidRecs.length == 0 )	{					
//					Ext.each(list, function(record,i){	
//			        	if(Ext.isEmpty(record.get('MODIFY_REASON')) && !record.phantom){
//							alert('변경사유를 입력해 주세요.');
//							return false;
//						}
//						if(i+1 == list.length){
						directMasterStore.syncAllDirect(config);	
//						}
//				    }); 
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
        
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
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
			layout : {type : 'vbox', align : 'stretch'},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},
	    		items:[
	    			Unilite.popup('ACCNT',{
			    	fieldLabel: '계정과목',
			    	validateBlank:false,	    			
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_NAME', newValue);				
						},
						applyextparam: function(popup){
							popup.setExtParam({ 'ADD_QUERY': "BUDG_YN = 'Y' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'" });			//WHERE절 추카 쿼리	
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
						}											
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
//								panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));				 																							
//							},
//							scope: this
//						},
//						onClear: function(type)	{
//							panelResult.setValue('ACCNT_CODE', '');
//							panelResult.setValue('ACCNT_NAME', '');
//						}
					}
			    }),{
					fieldLabel: '사용여부'	,
					name:'USE_YN', 
					xtype: 'uniCombobox', 
					comboType:'AU',
					comboCode:'A004',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('USE_YN', newValue);
						}
					}
				}/*,{
				    xtype: 'radiogroup',
				    fieldLabel: ' ',
				    labelWidth: 30,
				    items : [{
				    	boxLabel: '자산',
				    	name: 'MOVE_SCROLL' ,
				    	inputValue: '1',				    	
				    	checked: true,
				    	width:60
				    }, {boxLabel: '부채',
				    	name: 'MOVE_SCROLL' ,
				    	inputValue: '2',
				    	width:60
				    }, {boxLabel: '자본',
				    	name: 'MOVE_SCROLL' ,
				    	inputValue: '3',
				    	width:60
				    }, {boxLabel: '손익',
				    	name: 'MOVE_SCROLL' ,
				    	inputValue: '4',
				    	width:60
				    }, {boxLabel: '제조',
				    	name: 'MOVE_SCROLL' ,
				    	inputValue: '5',
				    	width:60
				    }],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('MOVE_SCROLL').setValue(newValue.MOVE_SCROLL);
							var records = directMasterStore.data.items
							var focusIndex = 0;
							if(newValue.MOVE_SCROLL == "1"){
								Ext.each(records, function(record, index){
									if(record.get('ACCNT_DIVI') == '1'){
										focusIndex = index;
										return false;
									}								
								});
							}else if(newValue.MOVE_SCROLL == "2"){
								Ext.each(records, function(record, index){
									if(record.get('ACCNT_DIVI') == '2'){
										focusIndex = index;
										return false;
									}								
								});
							}else if(newValue.MOVE_SCROLL == "3"){
								Ext.each(records, function(record, index){
									if(record.get('ACCNT_DIVI') == '3'){
										focusIndex = index;
										return false;
									}								
								});
							}else if(newValue.MOVE_SCROLL == "4"){
								Ext.each(records, function(record, index){
									if(record.get('ACCNT_DIVI') == '4'){
										focusIndex = index;
										return false;
									}								
								});
							}else if(newValue.MOVE_SCROLL == "5"){
								Ext.each(records, function(record, index){
									if(record.get('ACCNT_DIVI') == '5'){
										focusIndex = index;
										return false;
									}								
								});
							}
							masterGrid.getNavigationModel().setPosition(focusIndex+29, 0);
							masterGrid.getNavigationModel().setPosition(focusIndex, 0);
							masterGrid.getSelectionModel().select(focusIndex);
						}
					}				
				}*/]	
			}]
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			Unilite.popup('ACCNT',{
	    	fieldLabel: '계정과목',
	    	validateBlank:false,	    			
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME', newValue);				
				},
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
//						panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
//					},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('ACCNT_CODE', '');
//					panelSearch.setValue('ACCNT_NAME', '');
//				},
				applyextparam: function(popup){
					popup.setExtParam({ 'ADD_QUERY': "BUDG_YN = 'Y' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'" });			//WHERE절 추카 쿼리	
//							popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)
				}
			}
	    }),{
			fieldLabel: '사용여부'	,
			name:'USE_YN', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A004',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('USE_YN', newValue);
				}
			}
		}/*,{
		    xtype: 'radiogroup',
		    fieldLabel: ' ',
		    labelWidth: 200,
		    items : [{
		    	boxLabel: '자산',
		    	name: 'MOVE_SCROLL' ,
		    	inputValue: '1',
		    	checked: true,
		    	width:60
		    }, {boxLabel: '부채',
		    	name: 'MOVE_SCROLL' ,
		    	inputValue: '2',
		    	width:60
		    }, {boxLabel: '자본',
		    	name: 'MOVE_SCROLL' ,
		    	inputValue: '3',
		    	width:60
		    }, {boxLabel: '손익',
		    	name: 'MOVE_SCROLL' ,
		    	inputValue: '4',
		    	width:60
		    }, {boxLabel: '제조',
		    	name: 'MOVE_SCROLL' ,
		    	inputValue: '5',
		    	width:60
		    }],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {				
					panelSearch.getField('MOVE_SCROLL').setValue(newValue.MOVE_SCROLL);
				}
			}				
		}*/]	
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aba411Grid', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
    	uniOpt: {
    		expandLastColumn: true,
		 	useRowNumberer: true
//		 	copiedRow: true
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
        columns: [{dataIndex: 'ACCNT'				, width: 83},				  
				  {dataIndex: 'ACCNT_NAME'			, width: 170 },				  
				  {dataIndex: 'BUDG_YN'				, width: 132, xtype : 'checkcolumn' },			  
				  {dataIndex: 'BUDGCTL_YN'			, width: 132, xtype : 'checkcolumn' },				  
				  {dataIndex: 'CTL_CAL_UNIT'		, width: 132 },				   
				  {dataIndex: 'CTL_TERM_UNIT'		, width: 132 },				  		  
				  {dataIndex: 'BUDGCHG_YN'			, width: 132, xtype : 'checkcolumn' },				  
				  {dataIndex: 'BUDGADD_YN'			, width: 132, xtype : 'checkcolumn' },
				  {dataIndex: 'BUDGCAR_YN'			, width: 132, xtype : 'checkcolumn' },			  
				  {dataIndex: 'GROUP_YN'			, width: 73, hidden: true},			  				  
				  {dataIndex: 'SLIP_SW'			  	, width: 63, hidden: true},			  
				  {dataIndex: 'UPDATE_DB_USER'		, width: 63, hidden: true},
				  {dataIndex: 'UPDATE_DB_TIME'		, width: 63, hidden: true},
				  {dataIndex: 'COMP_CODE'	 		, width: 63, hidden: true}
		], 
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {
      			if (UniUtils.indexOf(e.field, 'PEND_CODE')){
  					if(e.record.get('PEND_YN') == "N"){
						return false;
  					}
  				}
  				            
      		},	
        	selectionchange:function( model1, selected, eOpts ){       			
       			if(selected.length == 1)	{
       				if(selected[0].get('PEND_YN') == "N") return false;
	        		var param = {ACCNT_CD: selected[0].get('ACCNT')};
					accntCommonService.getBookCombo(param, function(provider, response)	{
						var bookCode1 = !Ext.isEmpty(provider[0].BOOK_CODE1) ? provider[0].BOOK_CODE1 : ''; 
						var bookCode2 = !Ext.isEmpty(provider[1].BOOK_CODE1) ? provider[1].BOOK_CODE1 : '';
						gsFvalue[0] = bookCode1
						gsFvalue[1] = bookCode2
					});
       			}
          	}
		} 
    });    
    
	 Unilite.Main( {
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
		id : 'aba411App',
		fnInitBinding : function(params) {			
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons(['save', 'newData' ], false);
			panelSearch.clearForm();
			panelResult.clearForm();
			
			panelSearch.setValue('USE_YN', 'Y');
			//this.processParams(params);			
		},
		onQueryButtonDown : function()	{			
			directMasterStore.loadStoreRecords();	
		},
		onResetButtonDown: function() {
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		 onDeleteDataButtonDown: function() {	
		 	var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}			
		},
		onSaveDataButtonDown: function () {
			directMasterStore.saveStore();
		}/*,
		processParams: function(params) {
//			this.uniOpt.appParams = params;			
			if(params && params.ACCNT_CODE) {
				panelSearch.setValue('ACCNT_CODE', params.ACCNT_CODE);
				panelSearch.setValue('ACCNT_NAME', params.ACCNT_NAME);
				panelResult.setValue('ACCNT_CODE', params.ACCNT_CODE);
				panelResult.setValue('ACCNT_NAME', params.ACCNT_NAME);
				directMasterStore.loadStoreRecords();
			}else if(params && params.autoLoad){
				directMasterStore.loadStoreRecords();
			}
		}*/
	});
	
	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
/*				case "PEND_YN" :
					if(newValue == 'N'){
						record.set('PEND_CODE', '');
						record.set('PEND_NAME', '');	
					}else{
						var param = {ACCNT_CD: record.get('ACCNT')};
						accntCommonService.getBookCombo(param, function(provider, response)	{
							var bookCode1 = !Ext.isEmpty(provider[0].BOOK_CODE1) ? provider[0].BOOK_CODE1 : ''; 
							var bookCode2 = !Ext.isEmpty(provider[1].BOOK_CODE1) ? provider[1].BOOK_CODE1 : '';
							gsFvalue[0] = bookCode1
							gsFvalue[1] = bookCode2
						});
					}					
					break;*/
				case "BUDGCTL_YN" :
					if(newValue == 'N'){
						record.set('CTL_CAL_UNIT', '');
						record.set('CTL_TERM_UNIT', '');	
					}					
					break;
			}
			return rv;
		}
	}); // validator
};


</script>
