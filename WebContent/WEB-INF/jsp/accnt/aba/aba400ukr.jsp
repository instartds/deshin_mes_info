<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba400ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A001" />	<!-- 차대구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A005" />	<!-- 입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" />	<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" />	<!-- 예, 아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="A013" />	<!-- 과목구분 -->
	<t:ExtComboStore items="${AC_ITEM_LIST}" storeId="acItemList" /><!--관리항목-->
	<t:ExtComboStore comboType="AU" comboCode="A008" />	<!-- 계정과목유형 -->
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aba400ukrModel', {
	   fields: [{name: 'ACCNT'			, text: '계정코드'		, type: 'string', allowBlank: false, maxLength: 16},
	    		{name: 'ACCNT_NAME'		, text: '계정과목명'		, type: 'string', allowBlank: false, maxLength: 50},
	    		{name: 'AC_CODE1'		, text: '항목명'		, type: 'string', store: Ext.data.StoreManager.lookup('acItemList')},
	    		{name: 'DR_CTL1'		, text: '차'			, type: 'boolean'},
	    		{name: 'CR_CTL1'		, text: '대'			, type: 'boolean'},
	    		{name: 'AC_CODE2'		, text: '항목명'		, type: 'string', store: Ext.data.StoreManager.lookup('acItemList')},
	    		{name: 'DR_CTL2'		, text: '차'			, type: 'boolean'},
	    		{name: 'CR_CTL2'		, text: '대'			, type: 'boolean'},
	    		{name: 'AC_CODE3'		, text: '항목명'		, type: 'string', store: Ext.data.StoreManager.lookup('acItemList')},
	    		{name: 'DR_CTL3'		, text: '차'			, type: 'boolean'},
	    		{name: 'CR_CTL3'		, text: '대'			, type: 'boolean'},
	    		{name: 'AC_CODE4'		, text: '항목명'		, type: 'string', store: Ext.data.StoreManager.lookup('acItemList')},
	    		{name: 'DR_CTL4'		, text: '차'			, type: 'boolean'},
	    		{name: 'CR_CTL4'		, text: '대'			, type: 'boolean'},
	    		{name: 'AC_CODE5'		, text: '항목명'		, type: 'string', store: Ext.data.StoreManager.lookup('acItemList')},
	    		{name: 'DR_CTL5'		, text: '차'			, type: 'boolean'},
	    		{name: 'CR_CTL5'		, text: '대'			, type: 'boolean'},
	    		{name: 'AC_CODE6'		, text: '항목명'		, type: 'string', store: Ext.data.StoreManager.lookup('acItemList')},
	    		{name: 'DR_CTL6'		, text: '차'			, type: 'boolean'},
	    		{name: 'CR_CTL6'		, text: '대'			, type: 'boolean'},
	    		{name: 'BOOK_CODE1'		, text: '계정잔액1'		, type: 'string', store: Ext.data.StoreManager.lookup('acItemList')},
	    		{name: 'BOOK_CODE2'		, text: '계정잔액2'		, type: 'string', store: Ext.data.StoreManager.lookup('acItemList')},
	    		{name: 'SUBJECT_DIVI'	, text: '과목'		, type: 'string', comboType: 'AU', comboCode:'A013', allowBlank: false},
	    		{name: 'JAN_DIVI'		, text: '잔액'		, type: 'string', comboType: 'AU', comboCode:'A001', allowBlank: false},
	    		{name: 'SLIP_SW'		, text: '사용여부'		, type: 'string', comboType: 'AU', comboCode:'A004'},
	    		{name: 'AC_FULL_NAME'	, text: '과목정식명'		, type: 'string'},
	    		{name: 'ACCNT_NAME2'	, text: '계정과목2'		, type: 'string'},
	    		{name: 'ACCNT_NAME3'	, text: '계정과목3'		, type: 'string'},	    		
	    		{name: 'OLD_ACCNT'		, text: 'OLD_ACCNT'	, type: 'string'},
	    		{name: 'GROUP_YN'		, text: 'GROUP_YN'	, type: 'string'},
	    		{name: 'ACCNT_SPEC'		, text: 'ACCNT_SPEC', type: 'string'},
	    		{name: 'SPEC_DIVI'		, text: 'SPEC_DIVI'	, type: 'string'},
	    		{name: 'PROFIT_DIVI'	, text: 'PROFIT_DIVI', type: 'string'},
	    		{name: 'PEND_YN'		, text: 'PEND_YN'	, type: 'string'},
	    		{name: 'PEND_CODE'		, text: 'PEND_CODE'	, type: 'string'},
	    		{name: 'BUDG_YN'		, text: 'BUDG_YN'	, type: 'string'},
	    		{name: 'BUDGCTL_YN'		, text: 'BUDGCTL_YN', type: 'string'},
	    		{name: 'BUDGCTL_SUM_UNIT', text: 'BUDGCTL_SUM_UNIT'	, type: 'string'},
	    		{name: 'DR_FUND'		, text: 'DR_FUND'	, type: 'string'},
	    		{name: 'CR_FUND'		, text: 'CR_FUND'	, type: 'string'},
	    		{name: 'COST_DIVI'		, text: 'COST_DIVI'	, type: 'string'},
	    		{name: 'FOR_YN'			, text: 'FOR_YN'	, type: 'string'},
	    		{name: 'ACCNT_DIVI'		, text: 'ACCNT_DIVI'	, type: 'string'},
	    		{name: 'AUTHO_DIVI'		, text: 'AUTHO_DIVI'	, type: 'string'},
	    		//{name: 'SLIP_SW'		, text: 'SLIP_SW'	, type: 'string'},
	    		{name: 'SYSTEM_YN'		, text: 'SYSTEM_YN'	, type: 'string'},
	    		{name: 'ACCNT_CD'		, text: 'ACCNT_CD'	, type: 'string'},
	    		{name: 'DIRECT_DIVI'	, text: 'DIRECT_DIVI'	, type: 'string'},
	    		{name: 'TF_ACCNT'		, text: 'TF_ACCNT'	, type: 'string'},
	    		{name: 'IF_ACCNT'		, text: 'IF_ACCNT'	, type: 'string'},
	    		{name: 'UPDATE_DB_USER'	, text: 'UPDATE_DB_USER'	, type: 'string', defaultValue: UserInfo.userID},
	    		{name: 'UPDATE_DB_TIME'	, text: 'UPDATE_DB_TIME'	, type: 'string'},
	    		{name: 'COMP_CODE'		, text: 'COMP_CODE'	, type: 'string'},
	    		{name: 'DIRECT_DIVI'	, text: 'DIRECT_DIVI'	, type: 'string'},
	    		{name: 'DIRECT_DIVI'	, text: 'DIRECT_DIVI'	, type: 'string'}
	    ]
	});	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aba400ukrService.selectDetailList',
			update: 'aba400ukrService.updateDetail',
			create: 'aba400ukrService.insertDetail',
			destroy: 'aba400ukrService.deleteDetail',
			syncAll: 'aba400ukrService.saveAll'
		}
	});
	
	var directMasterStore = Unilite.createStore('aba400MasterStore1',{
		model: 'Aba400ukrModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
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
           		UniAppManager.setToolbarButtons('newData', true);
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
			if(inValidRecs.length == 0 )	{		
						directMasterStore.syncAllDirect(config);
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
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
//								panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
//	                    	},
//							scope: this
//						},
						onClear: function(type)	{
							panelResult.setValue('ACCNT_CODE', '');
							panelResult.setValue('ACCNT_NAME', '');
							panelSearch.setValue('ACCNT_CODE', '');
                            panelSearch.setValue('ACCNT_NAME', '');
						},
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ACCNT_NAME', newValue);				
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
//					store: Ext.data.StoreManager.lookup('acItemList'),
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
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
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
				}]	
			}]
		}]/*,		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}*/
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
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
//						panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));
//                	},
//					scope: this
//				},
				onClear: function(type)	{
					panelSearch.setValue('ACCNT_CODE', '');
					panelSearch.setValue('ACCNT_NAME', '');
					panelResult.setValue('ACCNT_CODE', '');
                    panelResult.setValue('ACCNT_NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME', newValue);				
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
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {				
					panelSearch.getField('MOVE_SCROLL').setValue(newValue.MOVE_SCROLL);
				}
			}				
		}/*,
		Unilite.popup('ACCNT',{ allowBlank: false,
	    	fieldLabel: '계정과목',
//	    	validateBlank: false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){							
						popup.setExtParam({'ADD_QUERY': ''});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': ''});			//bParam(3)			
					}
				}
	    }),		    
	    	Unilite.popup('MANAGE',{ allowBlank: false,
	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){							
							
					}
				}
	    }),		    
	    	Unilite.popup('USER_MANAGE',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){							
								
					}
				}
	    }),		    
	    	Unilite.popup('REMARK',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){							
						
					}
				}
	    }),		    
	    	Unilite.popup('COST',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){							
								
					}
				}
	    }),		    
	    	Unilite.popup('ACCNT_PRSN',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){							
						popup.setExtParam({'TRADE_DIV': 'I'});				//무역구분
						popup.setExtParam({'CHARGE_TYPE': 'P'});			//진행구분			
					}
				}
	    }),		    
	    	Unilite.popup('ALLOW',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DED_TYPE': ''});				//소득자타입(1사업,2기타,10이자,20배당)
						popup.setExtParam({'BILL_DIV_CODE': ''});			//신고사업장
					}
				}
	    }),		    
	    	Unilite.popup('EXPENSE',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'BILL_DIV_CODE': ''});			//신고사업장
					}
				}
	    }),		    
	    	Unilite.popup('EARNER',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    })
	    
	    
	    
	    
	    
	    
	    
	    
	    ,		    
	    	Unilite.popup('REALTY',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('ASSET',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('COST_POOL',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('UNIT',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('NOTE_TYPE',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('NOTE_NUM',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('CHECK_NUM',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('MONEY',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('EX_LCNO',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('IN_LCNO',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('EX_BLNO',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('IN_BLNO',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('AC_PROJECT',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('FUND',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('CREDIT_NO',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('PUR_SALE_TYPE',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('PROOF',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('EMISSION',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT', '');
						panelSearch.setValue('DIV_CODE', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('BANK_BOOK',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('DEBT_NO',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('BANK_ACCNT',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('BUSINESS_BANK',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('MONEY_UNIT',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('BUDG',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('Employee',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('ITEM',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('DIV_PUMOK',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': '01'});
					}
				}
	    }),		    
	    	Unilite.popup('CUST',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    }),		    
	    	Unilite.popup('AGENT_CUST',{ allowBlank: false,
//	    	validateBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
					applyextparam: function(popup){
						
					}
				}
	    })	*/    
	    ]	
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aba400Grid', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
        tbar: [{
        	itemId : 'refBtn',
    		text:'과목상세등록',
    		handler: function() {
    			var params = {
					appId: UniAppManager.getApp().id,
					action: 'new',
					autoLoad : true
				}
				var rec = {data : {prgID : 'aba410ukr', 'text':''}};
				parent.openTab(rec, '/accnt/aba410ukr.do', params);
			}
   		 }],
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [{dataIndex: 'ACCNT'			, 		width: 100 },
				  {dataIndex: 'ACCNT_NAME'		, 		width: 170 },
				  {
					text: '관리항목1',
				   	columns:[{dataIndex: 'AC_CODE1', 	width: 80 },
				 		    {dataIndex: 'DR_CTL1', 		width: 26, xtype : 'checkcolumn' },
				            {dataIndex: 'CR_CTL1', 		width: 26, xtype : 'checkcolumn' }
				   ]},
				  {
					text: '관리항목2',
				   	columns:[{dataIndex: 'AC_CODE2',	width: 80 },
				 		    {dataIndex: 'DR_CTL2', 		width: 26, xtype : 'checkcolumn' },
				            {dataIndex: 'CR_CTL2', 		width: 26, xtype : 'checkcolumn' }
				   ]},{
					text: '관리항목3',
				   	columns:[{dataIndex: 'AC_CODE3', 	width: 80 },
				 		    {dataIndex: 'DR_CTL3', 		width: 26, xtype : 'checkcolumn' },
				            {dataIndex: 'CR_CTL3', 		width: 26, xtype : 'checkcolumn' }
				   ]},{
					text: '관리항목4',
				   	columns:[{dataIndex: 'AC_CODE4', 	width: 80 },
				 		    {dataIndex: 'DR_CTL4', 		width: 26, xtype : 'checkcolumn' },
				            {dataIndex: 'CR_CTL4', 		width: 26, xtype : 'checkcolumn' }
				   ]},{
					text: '관리항목5',
				   	columns:[{dataIndex: 'AC_CODE5', 	width: 80 },
				 		    {dataIndex: 'DR_CTL5', 		width: 26, xtype : 'checkcolumn' },
				            {dataIndex: 'CR_CTL5', 		width: 26, xtype : 'checkcolumn' }
				   ]},{
					text: '관리항목6',
				   	columns:[{dataIndex: 'AC_CODE6', 	width: 80 },
				 		    {dataIndex: 'DR_CTL6', 		width: 26, xtype : 'checkcolumn' },
				            {dataIndex: 'CR_CTL6', 		width: 26, xtype : 'checkcolumn' }
				   ]},
				  {dataIndex: 'BOOK_CODE1'		, 		width: 100 },
				  {dataIndex: 'BOOK_CODE2'		, 		width: 100 },
				  {dataIndex: 'SUBJECT_DIVI'	, 		width: 70 },
				  {dataIndex: 'JAN_DIVI'		, 		width: 70 },
				  {dataIndex: 'SLIP_SW'			, 		width: 50 },
				  {dataIndex: 'AC_FULL_NAME'	, 		width: 170 },
				  {dataIndex: 'ACCNT_NAME2'		, 		width: 100 },
				  {dataIndex: 'ACCNT_NAME3'		, 		minWidth: 133, flex: 1 },
				  {dataIndex: 'UPDATE_DB_USER'  ,       width: 100, hidden: true },
                  {dataIndex: 'UPDATE_DB_TIME'  ,       width: 100, hidden: true }
//				  {dataIndex: 'OLD_ACCNT'		, 		width: 100, hidden: true },
//				  {dataIndex: 'GROUP_YN'		, 		width: 100, hidden: true },
//				  {dataIndex: 'ACCNT_SPEC'		, 		width: 100, hidden: true },
//				  {dataIndex: 'SPEC_DIVI'		, 		width: 100, hidden: true },
//				  {dataIndex: 'PROFIT_DIVI'		, 		width: 100, hidden: true },
//				  {dataIndex: 'PEND_YN'			, 		width: 100, hidden: true },
//				  {dataIndex: 'PEND_CODE'		, 		width: 100, hidden: true },
//				  {dataIndex: 'BUDG_YN'			, 		width: 100, hidden: true },
//				  {dataIndex: 'BUDGCTL_YN'		, 		width: 100, hidden: true },
//				  {dataIndex: 'BUDGCTL_SUM_UNIT', 		width: 100, hidden: true },
//				  {dataIndex: 'DR_FUND'			, 		width: 100, hidden: true },
//				  {dataIndex: 'CR_FUND'			, 		width: 100, hidden: true },
//				  {dataIndex: 'COST_DIVI'		, 		width: 100, hidden: true },
//				  {dataIndex: 'FOR_YN'			, 		width: 100, hidden: true },
//				  {dataIndex: 'ACCNT_DIVI'		, 		width: 100, hidden: true },
//				  {dataIndex: 'AUTHO_DIVI'		, 		width: 100, hidden: true },
//				  {dataIndex: 'SLIP_SW'			, 		width: 100, hidden: true },
//				  {dataIndex: 'SYSTEM_YN'		, 		width: 100, hidden: true },
//				  {dataIndex: 'ACCNT_CD'		, 		width: 100, hidden: true },
//				  {dataIndex: 'DIRECT_DIVI'		, 		width: 100, hidden: true },
//				  {dataIndex: 'TF_ACCNT'		, 		width: 100, hidden: true },
//				  {dataIndex: 'IF_ACCNT'		, 		width: 100, hidden: true },
//				  {dataIndex: 'COMP_CODE'		, 		width: 100, hidden: true },
//				  {dataIndex: 'DIRECT_DIVI'		, 		width: 100, hidden: true },
//				  {dataIndex: 'DIRECT_DIVI'		, 		width: 100, hidden: true }
		], 
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {
      			if (UniUtils.indexOf(e.field, 'ACCNT')){
  					if(!e.record.phantom){						
						return false;
  					}
  				} 
      		},
      		onGridDblClick: function(grid, record, cellIndex, colName) {
				var params = {
					appId: UniAppManager.getApp().id,
					sender: this,
					action: 'new',
					ACCNT_CODE: record.get('ACCNT'),
					ACCNT_NAME: record.get('ACCNT_NAME')
				}
				var rec = {data : {prgID : 'aba410ukr', 'text':''}};									
				parent.openTab(rec, '/accnt/aba410ukr.do', params);		
          	}
//      		itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
//	        	view.ownerGrid.setCellPointer(view, item);
//        	},
//        onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
//      		menu.showAt(event.getXY());
//      	},
//      	uniRowContextMenu:{
//			items: [
//	            {	text	: '계정상세 등록',   
//	            	handler	: function(menuItem, event) {
//	            		var param = menuItem.up('menu');
//	            		masterGrid.gotoAgb410ukr(param.record);
//	            	}
//	        	}
//	        ]
//	    },
//	    gotoAgb410ukr:function(record)	{
//			if(record)	{
//		    	var params = {
//					appId: UniAppManager.getApp().id,
//					sender: this,
//					action: 'new',
//					ACCNT_CODE: record.get('ACCNT'),
//					ACCNT_NAME: record.get('ACCNT_NAME')
//				}
//				var rec = {data : {prgID : 'aba410ukr', 'text':''}};									
//				parent.openTab(rec, '/accnt/aba410ukr.do', params);		
//			}
//	  		var rec = {data : {prgID : 'aba410ukr', 'text':''}};									
//			parent.openTab(rec, '/accnt/aba410ukr.do', params);	
//    	}
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
		id : 'aba400App',
		fnInitBinding : function() {			
			UniAppManager.setToolbarButtons('reset', false);
//			UniAppManager.setToolbarButtons(['save', 'newData' ], false);
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setValue('MOVE_SCROLL','1')
			directMasterStore.loadStoreRecords();
//			var activeSForm ;
//			if(!UserInfo.appOption.collapseLeftSearch)	{
//				activeSForm = panelSearch;
//			}else {
//				activeSForm = panelResult;
//			}
//			activeSForm.onLoadSelectText('ACCNT_CODE');
		},
		onQueryButtonDown : function()	{	
//			if(!panelSearch.setAllFieldsReadOnly(true)){
//	    		return false;
//	    	}
//			var activeTabId = tab.getActiveTab().getId();			
//			if(activeTabId == 'aba400Grid'){				
				directMasterStore.loadStoreRecords();				
//			}
		},
		onResetButtonDown: function() {
//			panelSearch.setAllFieldsReadOnly(false);
//			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onNewDataButtonDown: function(deptData)	{
			var r;
			if(!Ext.isEmpty(directMasterStore.data.items[0])){
				var record = masterGrid.getSelectedRecord();
				if(record){
					r = {
						  ACCNT: record.get('ACCNT')			
						, ACCNT_NAME: record.get('ACCNT_NAME')		
						, AC_CODE1: record.get('AC_CODE1')		
						, DR_CTL1: record.get('DR_CTL1')		
						, CR_CTL1: record.get('CR_CTL1')		
						, AC_CODE2: record.get('AC_CODE2')		
						, DR_CTL2: record.get('DR_CTL2')		
						, CR_CTL2: record.get('CR_CTL2')		
						, AC_CODE3: record.get('AC_CODE3')		
						, DR_CTL3: record.get('DR_CTL3')		
						, CR_CTL3: record.get('CR_CTL3')		
						, AC_CODE4: record.get('AC_CODE4')		
						, DR_CTL4: record.get('DR_CTL4')		
						, CR_CTL4: record.get('CR_CTL4')		
						, AC_CODE5: record.get('AC_CODE5')		
						, DR_CTL5: record.get('DR_CTL5')		
						, CR_CTL5: record.get('CR_CTL5')		
						, AC_CODE6: record.get('AC_CODE6')		
						, DR_CTL6: record.get('DR_CTL6')		
						, CR_CTL6: record.get('CR_CTL6')		
						, BOOK_CODE1: record.get('BOOK_CODE1')		
						, BOOK_CODE2: record.get('BOOK_CODE2')		
						, SUBJECT_DIVI: record.get('SUBJECT_DIVI')	
						, JAN_DIVI: record.get('JAN_DIVI')		
						, AC_FULL_NAME: record.get('AC_FULL_NAME')	
						, ACCNT_NAME2: record.get('ACCNT_NAME2')	
						, ACCNT_NAME3: record.get('ACCNT_NAME3')	
						, OLD_ACCNT: record.get('OLD_ACCNT')		
						, GROUP_YN: record.get('GROUP_YN')		
						, ACCNT_SPEC: record.get('ACCNT_SPEC')		
						, SPEC_DIVI: record.get('SPEC_DIVI')		
						, PROFIT_DIVI: record.get('PROFIT_DIVI')	
						, PEND_YN: record.get('PEND_YN')		
						, PEND_CODE: record.get('PEND_CODE')		
						, BUDG_YN: record.get('BUDG_YN')		
						, BUDGCTL_YN: record.get('BUDGCTL_YN')		
						, BUDGCTL_SUM_UNIT: record.get('BUDGCTL_SUM_UNIT')
						, DR_FUND: record.get('DR_FUND')		
						, CR_FUND: record.get('CR_FUND')		
						, COST_DIVI: record.get('COST_DIVI')		
						, FOR_YN: record.get('FOR_YN')			
						, ACCNT_DIVI: record.get('ACCNT_DIVI')		
						, AUTHO_DIVI: record.get('AUTHO_DIVI')		
						, SLIP_SW: record.get('SLIP_SW')		
						, SYSTEM_YN: record.get('SYSTEM_YN')		
						, ACCNT_CD: record.get('ACCNT_CD')		
						, DIRECT_DIVI: record.get('DIRECT_DIVI')	
						, TF_ACCNT: record.get('TF_ACCNT')		
						, IF_ACCNT: record.get('IF_ACCNT')	
						, COMP_CODE: record.get('COMP_CODE')		
						, DIRECT_DIVI: record.get('DIRECT_DIVI')	
						, DIRECT_DIVI: record.get('DIRECT_DIVI')	
		        	};
				}
			}        			  			
			masterGrid.createRow(r, 'ACCNT');
//			panelSearch.setAllFieldsReadOnly(true);
//			panelResult.setAllFieldsReadOnly(true);
			
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
			if(confirm('관리항목, 계정잔액을 변경하면 변경전후의 장부 데이터가 일치하지 않을 수 있습니다.그래도 변경하시겠습니까?')){
				alert('차액이 발생하는 과목은 전표입력에서 직접 수정하십시오.');
				directMasterStore.saveStore();
			}
			
		},
		fnCheckBookCode: function(record, fieldName, nValue, sBookCode){
			if(Ext.isEmpty(sBookCode)){
				return false;
			}	
			var acCode1 = fieldName == 'AC_CODE1' 	? nValue : record.get('AC_CODE1');
			var acCode2 = fieldName == 'AC_CODE2' 	? nValue : record.get('AC_CODE2');
			var acCode3 = fieldName == 'AC_CODE3' 	? nValue : record.get('AC_CODE3');
			var acCode4 = fieldName == 'AC_CODE4' 	? nValue : record.get('AC_CODE4');
			var acCode5 = fieldName == 'AC_CODE5' 	? nValue : record.get('AC_CODE5');
			var acCode6 = fieldName == 'AC_CODE6' 	? nValue : record.get('AC_CODE6');
			var isSucess = true
			
			if(sBookCode == acCode1){
				record.set('DR_CTL1', true);
				record.set('CR_CTL1', true);
			}else if(sBookCode == acCode2){
				record.set('DR_CTL2', true);
				record.set('CR_CTL2', true);
			}else if(sBookCode == acCode3){
				record.set('DR_CTL3', true);
				record.set('CR_CTL3', true);
			}else if(sBookCode == acCode4){
				record.set('DR_CTL4', true);
				record.set('CR_CTL4', true);
			}else if(sBookCode == acCode5){
				record.set('DR_CTL5', true);
				record.set('CR_CTL5', true);
			}else if(sBookCode == acCode6){
				record.set('DR_CTL6', true);
				record.set('CR_CTL6', true);
			}else{
				isSucess = false;				
			}
			return isSucess;
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
				case "ACCNT" :
					if(record.get('SUBJECT_DIVI') == "1"){
						record.set('ACCNT_CD', newValue);
					}else{
						var preRec = directMasterStore.getAt(e.rowIdx - 1);
						record.set('ACCNT_CD', preRec.get('ACCNT_CD'));
					}					
					record.set('TF_ACCNT', newValue);
					break;

				case "ACCNT_NAME" :
				 	record.set('AC_FULL_NAME', newValue);			 	
					break;
					
				case "AC_CODE1" :					
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE1'))){
						record.set('BOOK_CODE1', '')
					}
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE2'))){
						record.set('BOOK_CODE2', '')
					}
					break;
				
				case "AC_CODE2" :
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE1'))){
						record.set('BOOK_CODE1', '')
					}
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE2'))){
						record.set('BOOK_CODE2', '')
					}
					break;			
				
				case "AC_CODE3" :
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE1'))){
						record.set('BOOK_CODE1', '')
					}
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE2'))){
						record.set('BOOK_CODE2', '')
					}
					break;
				
				case "AC_CODE4" :		
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE1'))){
						record.set('BOOK_CODE1', '')
					}
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE2'))){
						record.set('BOOK_CODE2', '')
					}
					break;
					
				case "AC_CODE5" :		
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE1'))){
						record.set('BOOK_CODE1', '')
					}
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE2'))){
						record.set('BOOK_CODE2', '')
					}
					break;
					
				case "AC_CODE6" :		
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE1'))){
						record.set('BOOK_CODE1', '')
					}
					if(!UniAppManager.app.fnCheckBookCode(record, fieldName, newValue, record.get('BOOK_CODE2'))){
						record.set('BOOK_CODE2', '')
					}
					break;	
				
				case "BOOK_CODE1" :	
					if(Ext.isEmpty(newValue)){
						record.set('BOOK_CODE1', '')
					}else if(!UniAppManager.app.fnCheckBookCode(record, fieldName, '', newValue)){
						rv = '계정잔액은 관리항목들 중에서 선택하여야 합니다.'
					}
					break;
				
				case "BOOK_CODE2" :		
					if(Ext.isEmpty(newValue)){
						record.set('BOOK_CODE2', '')
					}else if(!UniAppManager.app.fnCheckBookCode(record, fieldName, '', newValue)){
						rv = '계정잔액은 관리항목들 중에서 선택하여야 합니다.'
					}
					break;
				
				case "SUBJECT_DIVI" :	
					if(newValue == "1"){
						record.set('ACCNT_CD', record.get('ACCNT'));
					}else{
						var preRec = directMasterStore.getAt(e.rowIdx - 1);
						record.set('ACCNT_CD', preRec.get('ACCNT_CD'));
					}
					break	
			}
			
			return rv;
		}
	}); // validator
};


</script>
