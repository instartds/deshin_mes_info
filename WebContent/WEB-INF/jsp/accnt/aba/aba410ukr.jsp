<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba410ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A004" />	<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A015" />	<!-- 계정특성 -->
	<t:ExtComboStore comboType="AU" comboCode="A016" />	<!-- 자산부채특성 -->
	<t:ExtComboStore comboType="AU" comboCode="A017" />	<!-- 매출원가특성 -->
	<t:ExtComboStore comboType="AU" comboCode="A019" />	<!-- 비용구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A008" />	<!-- 계정과목유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" />	<!-- 예/아니오 -->
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
	Unilite.defineModel('Aba410ukrModel', {
	   fields: [{name: 'ACCNT'				, text: '계정코드'		, type: 'string', allowBlank: false, editable: false, maxLength: 16},	    		
	    		{name: 'ACCNT_NAME'			, text: '계정과목명'	, type: 'string', editable: false},	 	  		
	    		{name: 'ACCNT_SPEC'			, text: '계정특성'		, type: 'string', comboType: 'AU', comboCode: 'A015'},	    		
	    		{name: 'SPEC_DIVI'			, text: '자산부채특성'	, type: 'string', comboType: 'AU', comboCode: 'A016'},	    		
	    		{name: 'PROFIT_DIVI'		, text: '손익특성'		, type: 'string', comboType: 'AU', comboCode: 'A017'},	    		
	    		{name: 'PEND_YN'			, text: '미결'		, type: 'string', comboType: 'AU', comboCode: 'A004'},	    		
	    		{name: 'PEND_CODE'			, text: '미결항목'		, type: 'string', store: Ext.data.StoreManager.lookup('pendList')},
	    		{name: 'PEND_NAME'			, text: 'PEND_NAME'	, type: 'string'},	    		
	    		{name: 'BUDG_YN'			, text: '예산'		, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A004'},	    		
	    		{name: 'BUDGCTL_YN'			, text: '통제여부'		, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A004'},
	    		{name: 'CTL_CAL_UNIT'		, text: '통제계산'		, type: 'string', comboType: 'AU', comboCode: 'A129'},
	    		{name: 'CTL_TERM_UNIT'		, text: '통제단위'		, type: 'string', comboType: 'AU', comboCode: 'A130'},	    		
	    		{name: 'BUDGCTL_SUM_UNIT'	, text: '실적집계대상'	, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A131'},	    		
	    		{name: 'COST_DIVI'			, text: '비용'		, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A019'},	    		
	    		{name: 'FOR_YN'				, text: '외화'		, type: 'string', comboType: 'AU', comboCode: 'A020'},	    		
	    		{name: 'ACCNT_DIVI'			, text: '과목'		, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A008'},	    		
	    		{name: 'AUTHO_DIVI'			, text: '사용부서'		, type: 'string', comboType: 'AU', comboCode: 'A079'},	    		
	    		{name: 'GROUP_YN'			, text: '그룹'		, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A020'},	    		
	    		{name: 'ACCNT_CD'			, text: '과목코드'		, type: 'string', allowBlank: false},	    		
	    		{name: 'SLIP_SW'			, text: '사용'		, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A004'},	    		
	    		{name: 'DIRECT_DIVI'		, text: '직간접비'		, type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A123'},	    		
	    		{name: 'TF_ACCNT'			, text: '이관계정코드'	, type: 'string', allowBlank: false, maxLength: 16},	    		
	    		{name: 'IF_ACCNT'			, text: 'IF계정코드'	, type: 'string', maxLength: 16},
	    		{name: 'DR_FUND'			, text: 'DR_FUND'	, type: 'string'},
	    		{name: 'CR_FUND'			, text: 'CR_FUND'	, type: 'string'},
	    		{name: 'SYSTEM_YN'			, text: 'SYSTEM_YN'	, type: 'string'},
	    		{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string', defaultValue: UserInfo.userID},
	    		{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'},
	    		{name: 'COMP_CODE'	 		, text: 'COMP_CODE'			, type: 'string'}
	    		
	    		
	    ]
	});	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aba410ukrService.selectDetailList',
			update: 'aba410ukrService.updateDetail',
//			create: 'aba410ukrService.insertDetail',
//			destroy: 'aba410ukrService.deleteDetail',
			syncAll: 'aba410ukrService.saveAll'
		}
	});
	
	var directMasterStore = Unilite.createStore('aba410MasterStore1',{
		model: 'Aba410ukrModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
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
	    			autoPopup:true,    			
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_NAME', newValue);				
						},
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
//								panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));				 																							
//							},
//							scope: this
//						},
						onClear: function(type)	{
							panelResult.setValue('ACCNT_CODE', '');
							panelResult.setValue('ACCNT_NAME', '');
							panelSearch.setValue('ACCNT_CODE', '');
                            panelSearch.setValue('ACCNT_NAME', '');
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
							panelResult.setValue('USE_YN', newValue);
						}
					}
				},{
				    xtype: 'uniCombobox',
				    fieldLabel: ' ',
				    name: 'MOVE_SCROLL' ,
				    comboType: 'AU', 
				    comboCode: 'A008',
				    value : '1',
				    /*
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
				    }],*/
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue)	{
								panelResult.getField('MOVE_SCROLL').setValue(newValue);
								var records = directMasterStore.data.items
								var focusIndex = 0;
								Ext.each(records, function(record, index){
									if(record.get('ACCNT_DIVI') == newValue){
										focusIndex = index;
										return false;
									}								
								});
								masterGrid.getNavigationModel().setPosition(focusIndex+29, 0);
								masterGrid.getNavigationModel().setPosition(focusIndex, 0);
								masterGrid.getSelectionModel().select(focusIndex);
							}
						}
					}				
				}]	
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
	    	autoPopup:true,	    			
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
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE', '');
					panelSearch.setValue('ACCNT_NAME', '');
					panelResult.setValue('ACCNT_CODE', '');
                    panelResult.setValue('ACCNT_NAME', '');
				},
				applyextparam: function(popup){							
					popup.setExtParam({'ADD_QUERY': ''});			//WHERE절 추카 쿼리
					popup.setExtParam({'CHARGE_CODE': ''});			//bParam(3)			
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
		},{
		    xtype: 'uniRadiogroup',
		    fieldLabel: ' ',
		    hideLabel: true,
		    labelWidth: 200,
		    name: 'MOVE_SCROLL' ,
		    comboType: 'AU', 
		    comboCode: 'A008',
		    width : 600,
		    allowBlank:false,
		    tdAttrs:{style:'padding-left:200px;'},
		    value : '1',
		    /*
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
		    }],*/
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {				
					panelSearch.setValue('MOVE_SCROLL',newValue.MOVE_SCROLL);
				}
			}				
		}]	
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aba410Grid', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
    	uniOpt: {
    		expandLastColumn: false,
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
				  {dataIndex: 'ACCNT_SPEC'			, width: 123},				  
				  {dataIndex: 'SPEC_DIVI'			, width: 123},				  
				  {dataIndex: 'PROFIT_DIVI'		  	, width: 132 },				   
				  {dataIndex: 'PEND_YN'			  	, width: 73},				  
				  {dataIndex: 'PEND_CODE'			, width: 123, 'editor':{ xtype: 'uniCombobox', type: 'string', store: Ext.data.StoreManager.lookup('pendList'),
				  	listeners: {
				  		beforequery: function(queryPlan, eOpts )	{
				  			var me = this
				  			var record = masterGrid.getSelectedRecord();						
							var store = queryPlan.combo.getStore();
							store.clearFilter(true);
							queryPlan.combo.queryFilter = null;	
							var count = 0;
							store.filterBy(function(record, id){
								if((!Ext.isEmpty(gsFvalue[0]) || !Ext.isEmpty(gsFvalue[1])) && gsFvalue.indexOf(record.get('value')) > -1  ){	
									count++;
									return record;
								}else{
									count++;
									return null;
								}									
							});
						}
				  	}}
				  },
				  {dataIndex: 'PEND_NAME'			, width: 63, hidden: true},				  
				  {dataIndex: 'BUDG_YN'			  	, width: 73},				  
				  {dataIndex: 'BUDGCTL_YN'			, width: 83},
				  {dataIndex: 'CTL_CAL_UNIT'			, width: 83},
				  {dataIndex: 'CTL_TERM_UNIT'			, width: 83},	
				  {dataIndex: 'BUDGCTL_SUM_UNIT'	, width: 110},				  
				  {dataIndex: 'COST_DIVI'			, width: 73},				  
				  {dataIndex: 'FOR_YN'				, width: 73},				  
				  {dataIndex: 'ACCNT_DIVI'			, width: 73},				  
				  {dataIndex: 'AUTHO_DIVI'			, width: 90},				  
				  {dataIndex: 'GROUP_YN'			, width: 73},				  
				  {dataIndex: 'ACCNT_CD'			, width: 83},				  
				  {dataIndex: 'SLIP_SW'			  	, width: 63},				  
				  {dataIndex: 'DIRECT_DIVI'		  	, width: 75},				  
				  {dataIndex: 'TF_ACCNT'			, width: 110},				  
				  {dataIndex: 'IF_ACCNT'			, flex: 1, minWidth: 110},				  
				  {dataIndex: 'DR_FUND'				, width: 63, hidden: true},
				  {dataIndex: 'CR_FUND'				, width: 63, hidden: true},
				  {dataIndex: 'SYSTEM_YN'			, width: 63, hidden: true},
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
		id : 'aba410App',
		fnInitBinding : function(params) {			
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons(['save', 'newData', 'reset' ], false);
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setValue('MOVE_SCROLL', '1')
			this.processParams(params);			
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
		},
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
		}
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
				case "PEND_YN" :
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
					break;
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
