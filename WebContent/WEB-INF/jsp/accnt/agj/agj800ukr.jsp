<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj800ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A005" /> <!-- 입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> <!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 예/아니오 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var foreignWindow;
function appMain() {     
	var baseInfo = {
		gsChargeCD : '${gsChargeCD}',
		gsSTDT : '${gsSTDT}',
		gsAmtPoint : ${gsAmtPoint}
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'agj800ukrService.selectList1',
        	update: 'agj800ukrService.updateDetail1',
			create: 'agj800ukrService.insertDetail1',
			destroy: 'agj800ukrService.deleteDetail1',
			syncAll: 'agj800ukrService.saveAll1'
        }
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'agj800ukrService.selectList2',
        	update: 'agj800ukrService.updateDetail2',
			create: 'agj800ukrService.insertDetail2',
			destroy: 'agj800ukrService.deleteDetail2',
			syncAll: 'agj800ukrService.saveAll2'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agj800ukrModel', {
	    fields: [  	  
	    	{name: 'AC_DATE'				, text: 'AC_DATE' 			,type: 'string', allowBlnak:false},
		    {name: 'DIV_CODE'			  	, text: 'DIV_CODE'			,type: 'string', defaultValue:UserInfo.divCode, allowBlnak:false},
		    {name: 'SEQ'					, text: '순번' 				,type: 'string', defaultValue:0, allowBlnak:false},
		    {name: 'CUSTOM_CODE'		  	, text: '거래처코드'		,type: 'string'},
		    {name: 'EXPIRE_DATE'			, text: 'EXPIRE_DATE' 		,type: 'uniDate'},
		    {name: 'INPUT_DIVI'				, text: 'INPUT_DIVI' 		,type: 'string'},
		    {name: 'SPEC_DIVI'			  	, text: 'SPEC_DIVI'			,type: 'string'},
		    {name: 'FOR_YN'					, text: 'FOR_YN' 			,type: 'string'},
		    {name: 'ACCNT'					, text: '계정과목' 			,type: 'string', allowBlnak:false},
		    {name: 'ACCNT_NAME' 		  	, text: '계정과목명'		,type: 'string', allowBlnak:false},
		    {name: 'ACCNT_SPEC'				, text: 'ACCNT_SPEC' 		,type: 'string'},
		    {name: 'JAN_DIVI'				, text: 'JAN_DIVI' 			,type: 'string'},
		    {name: 'MONEY_UNIT'		  		, text: 'MONEY_UNIT'		,type: 'string'},
		    {name: 'DR_FOR_AMT_I'			, text: 'DR_FOR_AMT_I' 		,type: 'uniPrice'},
		    {name: 'CR_FOR_AMT_I'			, text: 'CR_FOR_AMT_I' 		,type: 'uniPrice'},
		    {name: 'EXCHG_RATE_O'		  	, text: 'EXCHG_RATE_O'		,type: 'uniPercent'},
		    {name: 'DR_AMT_I'				, text: '차변금액' 			,type: 'uniPrice', defaultValue:0},
		    {name: 'CR_AMT_I'				, text: '대변금액' 			,type: 'uniPrice', defaultValue:0},
		    {name: 'BOOK_CODE1'		  		, text: 'BOOK_CODE1'		,type: 'string', editable:false},
		    {name: 'BOOK_CODE_NAME1'		, text: '계정잔액1' 		,type: 'string', editable:false},
		    {name: 'BOOK_TYPE1'				, text: 'BOOK_TYPE1' 		,type: 'string', defaultValue:'A'},
		    {name: 'BOOK_LEN1'			  	, text: 'BOOK_LEN1'			,type: 'string', defaultValue:0},
		    {name: 'BOOK_POPUP1'			, text: 'BOOK_POPUP1' 		,type: 'string', defaultValue:'N'},
		    {name: 'BOOK_DATA1'				, text: '코드1' 			,type: 'string'},
		    {name: 'BOOK_DATA_NAME1' 		, text: '계정잔액명1'		,type: 'string'},
		    {name: 'BOOK_CODE2'				, text: 'BOOK_CODE2' 		,type: 'string', editable:false},
		    {name: 'BOOK_CODE_NAME2'		, text: '계정잔액2' 		,type: 'string', editable:false},
		    {name: 'BOOK_TYPE2'		  		, text: 'BOOK_TYPE2'		,type: 'string', defaultValue:'A'},
		    {name: 'BOOK_LEN2'				, text: 'BOOK_LEN2' 		,type: 'string', defaultValue:0},
		    {name: 'BOOK_POPUP2'			, text: 'BOOK_POPUP2' 		,type: 'string', defaultValue:'N'},
		    {name: 'BOOK_DATA2'		  		, text: '코드2'				,type: 'string'},
		    {name: 'BOOK_DATA_NAME2'     	, text: '계정잔액명2' 		,type: 'string'},
		    {name: 'DEPT_CODE'				, text: '부서코드' 			,type: 'string'},
		    {name: 'DEPT_NAME'    		  	, text: '부서명'			,type: 'string'},
		    {name: 'PROC_YN'		    	, text: '반영여부' 			,type: 'string',	comboType:'AU', comboCode:'A020', defaultValue:'N'},
		    {name: 'COMP_CODE'				, text: 'COMP_CODE' 		,type: 'string'}   
		]          
	});
	
	Unilite.defineModel('Agj800ukrMode2', {
	    fields: [  	  
	    	{name: 'AC_DATE'				, text: 'AC_DATE' 			,type: 'string', allowBlnak:false},
		    {name: 'DIV_CODE'			  	, text: '사업장'				,type: 'string', defaultValue:UserInfo.divCode, allowBlnak:false},
		    {name: 'SEQ'					, text: '순번' 				,type: 'string', defaultValue:0, allowBlnak:false},
		    {name: 'CUSTOM_CODE'		  	, text: '거래처코드'			,type: 'string'},
		    {name: 'EXPIRE_DATE'			, text: 'EXPIRE_DATE' 		,type: 'string'},
		    {name: 'INPUT_DIVI'				, text: 'INPUT_DIVI' 		,type: 'string'},
		    {name: 'SPEC_DIVI'			  	, text: 'SPEC_DIVI'			,type: 'string'},
		    {name: 'FOR_YN'					, text: 'FOR_YN' 			,type: 'string'},
		    {name: 'ACCNT'					, text: '계정과목' 			,type: 'string', allowBlnak:false},
		    {name: 'ACCNT_NAME' 		  	, text: '계정과목명'			,type: 'string', allowBlnak:false},
		    {name: 'ACCNT_SPEC'				, text: 'ACCNT_SPEC' 		,type: 'string'},
		    {name: 'JAN_DIVI'				, text: 'JAN_DIVI' 			,type: 'string'},
		    {name: 'MONEY_UNIT'		  		, text: 'MONEY_UNIT'		,type: 'string'},
		    {name: 'DR_FOR_AMT_I'			, text: 'DR_FOR_AMT_I' 		,type: 'string'},
		    {name: 'CR_FOR_AMT_I'			, text: 'CR_FOR_AMT_I' 		,type: 'string'},
		    {name: 'EXCHG_RATE_O'		  	, text: 'EXCHG_RATE_O'		,type: 'string'},
		    {name: 'DR_AMT_I'				, text: '차변금액' 			,type: 'uniPrice', defaultValue:0},
		    {name: 'CR_AMT_I'				, text: '대변금액' 			,type: 'uniPrice', defaultValue:0},
		    {name: 'BOOK_CODE1'		  		, text: 'BOOK_CODE1'		,type: 'string', editable:false},
		    {name: 'BOOK_CODE_NAME1'		, text: '계정잔액1' 			,type: 'string', editable:false},
		    {name: 'BOOK_TYPE1'				, text: 'BOOK_TYPE1' 		,type: 'string', defaultValue:'A'},
		    {name: 'BOOK_LEN1'			  	, text: 'BOOK_LEN1'			,type: 'string', defaultValue:0},
		    {name: 'BOOK_POPUP1'			, text: 'BOOK_POPUP1' 		,type: 'string', defaultValue:'N'},
		    {name: 'BOOK_DATA1'				, text: '코드1' 				,type: 'string'},
		    {name: 'BOOK_DATA_NAME1'  		, text: '계정잔액명1'			,type: 'string'},
		    {name: 'BOOK_CODE2'				, text: 'BOOK_CODE2' 		,type: 'string', editable:false},
		    {name: 'BOOK_CODE_NAME2'		, text: '계정잔액2' 			,type: 'string', editable:false},
		    {name: 'BOOK_TYPE2'		  		, text: 'BOOK_TYPE2'		,type: 'string', defaultValue:'A'},
		    {name: 'BOOK_LEN2'				, text: 'BOOK_LEN2' 		,type: 'string', defaultValue:0},
		    {name: 'BOOK_POPUP2'			, text: 'BOOK_POPUP2' 		,type: 'string', defaultValue:'N'},
		    {name: 'BOOK_DATA2'		  		, text: '코드2'				,type: 'string'},
		    {name: 'BOOK_DATA_NAME2'		, text: '계정잔액명2' 			,type: 'string'},
		    {name: 'DEPT_CODE'				, text: '부서코드' 			,type: 'string'},
		    {name: 'DEPT_NAME'    		  	, text: '부서명'				,type: 'string'},
		    {name: 'PROC_YN'		    	, text: '반영여부' 			,type: 'string',	comboType:'AU', comboCode:'A020', defaultValue:'N'},
		    {name: 'COMP_CODE'				, text: 'COMP_CODE' 		,type: 'string'}   
		]          
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agj800ukrMasterStore1',{
		model: 'Agj800ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore:function(config)	{
				var insertRecords=this.getNewRecords( );
				var updateRecords=this.getUpdatedRecords( );
				var removedRecords=this.getRemovedRecords( );

				
				var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
				var paramMaster= panelResult.getValues();
				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				var checkValid = true
				Ext.each(changedRec, function(cRec){
					
					if(!Ext.isEmpty(cRec.get("BOOK_CODE1")) && Ext.isEmpty(cRec.get("BOOK_DATA1")))	{
						//inValidRecs.push(cRec) ;
						checkValid = false;
						Unilite.messageBox("계정잔액1 코드를 입력하세요.");
						return;
					}
					
					if(!Ext.isEmpty(cRec.get("BOOK_CODE2")) && Ext.isEmpty(cRec.get("BOOK_DATA2")))	{
						//inValidRecs.push(cRec) ;
						checkValid = false;
						Unilite.messageBox("계정잔액2 코드를 입력하세요.");
						return;
					}
					
					if(Ext.isEmpty(cRec.get("MONEY_UNIT"))) cRec.set("MONEY_UNIT", UserInfo.currency);
					
					if(cRec.get("BOOK_CODE1") == "A4")  cRec.set("CUSTOM_CODE", cRec.get("BOOK_DATA1"));
					else if(cRec.get("BOOK_CODE2") == "A4")  cRec.set("CUSTOM_CODE", cRec.get("BOOK_DATA2"));
				})
				if(!checkValid)	{
					return;
				}
				if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								//UniAppManager.app.fnSetBtnDisabled(option.params[0].bal_divi, option.params[0].act_divi, bal_divi, option.params[0].sal_divi, option.params[0].sal_flag)
							}
					}
					this.syncAllDirect(config);
				}else {
					Unilite.messageBox(Msg.sMB083);
				}
		},           
        listeners:{
            load: function(store, records, successful, eOpts) {
            	if(!Ext.isEmpty(records)){
            	   UniAppManager.app.fnCalculation();
            	  // UniAppManager.setToolbarButtons('delete',true);
            	}
//            	else{
//                   //UniAppManager.setToolbarButtons('delete',false);
//                }
//            	if(records != null && records.length > 0){
//                    UniAppManager.setToolbarButtons('delete', true);
//                } else {
//                    if(directMasterStore1.isDirty()) {
//                        UniAppManager.setToolbarButtons('save', true);  
//                    }else {
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                }
            }/*,
            update: function( store, record, operation, modifiedFieldNames, details, eOpts ) {
                if(record.dirty == true ) {
                        UniAppManager.setToolbarButtons('save', true);  
                	
                }else {
                        UniAppManager.setToolbarButtons('save', false);
                	
                }
            }*/
        }
	});
	
	var directMasterStore2 = Unilite.createStore('agj800ukrMasterStore2',{
		model: 'Agj800ukrMode2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore:function(config)  {
                var insertRecords=this.getNewRecords( );
                var updateRecords=this.getUpdatedRecords( );
                var removedRecords=this.getRemovedRecords( );

                
                var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
                var paramMaster= panelResult.getValues();
                
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);
                var checkValid = true
                Ext.each(changedRec, function(cRec){
                    
                    if(!Ext.isEmpty(cRec.get("BOOK_CODE1")) && Ext.isEmpty(cRec.get("BOOK_DATA1"))) {
                        //inValidRecs.push(cRec) ;
                        checkValid = false;
                        Unilite.messageBox("계정잔액1 코드를 입력하세요.");
                        return;
                    }
                    
                    if(!Ext.isEmpty(cRec.get("BOOK_CODE2")) && Ext.isEmpty(cRec.get("BOOK_DATA2"))) {
                        //inValidRecs.push(cRec) ;
                        checkValid = false;
                        Unilite.messageBox("계정잔액2 코드를 입력하세요.");
                        return;
                    }
                    
                    if(Ext.isEmpty(cRec.get("MONEY_UNIT"))) cRec.set("MONEY_UNIT", UserInfo.currency);
                    
                    if(cRec.get("BOOK_CODE1") == "A4")  cRec.set("CUSTOM_CODE", cRec.get("BOOK_DATA1"));
                    else if(cRec.get("BOOK_CODE2") == "A4")  cRec.set("CUSTOM_CODE", cRec.get("BOOK_DATA2"));
                })
                if(!checkValid) {
                    return;
                }
                if(inValidRecs.length == 0 )    {
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                //UniAppManager.app.fnSetBtnDisabled(option.params[0].bal_divi, option.params[0].act_divi, bal_divi, option.params[0].sal_divi, option.params[0].sal_flag)
                            }
                    }
                    this.syncAllDirect(config);
                }else {
                    Unilite.messageBox(Msg.sMB083);
                }
		},
        listeners:{
            load: function(store, records, successful, eOpts) {
                if(!Ext.isEmpty(records)){
                   UniAppManager.app.fnCalculation();
                  // UniAppManager.setToolbarButtons('delete',true);
                }
//                else{
//                   UniAppManager.setToolbarButtons('delete',false);
//                }
            }
//            datachanged : function(store,  eOpts) {
//                if( directMasterStore2.isDirty() || store.isDirty()) {
//                    UniAppManager.setToolbarButtons('save', true);  
//                }else {
//                    UniAppManager.setToolbarButtons('save', false);
//                }
//            }
        }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
	       	layout: {type: 'uniTable', columns: 1},
	       	defaultType: 'uniTextfield',
		    items: [{
		 		fieldLabel: '기초년월',
		 		xtype: 'uniMonthfield',
		 		name: 'AC_DATE',
		 		holdable  :'hold',
		 		allowBlank:false,
		 		value:baseInfo.gsSTDT,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AC_DATE', newValue);
					}
				}
			},{ 
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				value : UserInfo.divCode,
				comboType: 'BOR120',
				holdable  : 'hold', //TODO : 사업장권한에 따라 적용 필요 
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},	
				Unilite.popup('ACCNT',{ 
			    	fieldLabel: '계정코드', 
			    	popupWidth: 600,
			    	valueFieldName: 'ACCOUNT_CODE',
					textFieldName: 'ACCOUNT_NAME',
					holdable  : 'hold',
					autoPopup : true,
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ACCOUNT_CODE', panelSearch.getValue('ACCOUNT_CODE'));
								panelResult.setValue('ACCOUNT_NAME', panelSearch.getValue('ACCOUNT_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ACCOUNT_CODE', '');
							panelResult.setValue('ACCOUNT_NAME', '');
						},
						applyextparam: function(popup){							
							//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),
			{
				xtype: 'uniTextfield',
				name: 'TERM_DIVI',
				fieldLabel:'구분',	// 1:기초잔액, 2:거래합계
				value:'1',
				hidden:true		,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TERM_DIVI', newValue);
					}
				}
			}
		]},{	
			title: '잔액합계정보', 	
			//collapsed: true,
			itemId: 'search_panel2',
	       	layout: {type: 'uniTable', columns: 1},
	       	defaultType: 'uniTextfield',
		    items: [{
				xtype: 'uniNumberfield',
				name: 'TOT_CD',
				fieldLabel:'과목소계',
				value : 0.0,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TOT_CD', newValue);
					}
				}
			},{
				xtype: 'uniNumberfield',
				name: 'TOT_DR',
				fieldLabel:'차변합계',
				value : 0.0,
				decimalPrecision: UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TOT_DR', newValue);
					}
				}
			},{
				xtype: 'uniNumberfield',
				name: 'TOT_CR',
				fieldLabel:'대변합계',
				decimalPrecision: UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
				value : 0.0,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TOT_CR', newValue);
					}
				}
			},{
				xtype: 'uniNumberfield',
				name: 'TOT_BL',
				fieldLabel:'차액',
				decimalPrecision: UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
				value : 0.0,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TOT_BL', newValue);
					}
				}
			}]				
		}]		
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
	 		fieldLabel: '기초년월',
	 		xtype: 'uniMonthfield',
	 		name: 'AC_DATE',
		 	value:baseInfo.gsSTDT,
	 		allowBlank:false,
	 		colspan:2,
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AC_DATE', newValue);
				}
			}
		},{ 
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			value : UserInfo.divCode,
			comboType: 'BOR120',
			holdable  : 'hold', //TODO : 사업장권한에 따라 적용 필요 
			allowBlank:false,
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},	
			Unilite.popup('ACCNT',{ 
		    	fieldLabel: '계정코드', 
		    	popupWidth: 600,
		    	valueFieldName: 'ACCOUNT_CODE',
				textFieldName: 'ACCOUNT_NAME',
				colspan:4,
				holdable  : 'hold',
				autoPopup : true,
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCOUNT_CODE', panelResult.getValue('ACCOUNT_CODE'));
							panelSearch.setValue('ACCOUNT_NAME', panelResult.getValue('ACCOUNT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCOUNT_CODE', '');
						panelSearch.setValue('ACCOUNT_NAME', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		}),{
			xtype: 'uniTextfield',
			name: 'TERM_DIVI',
			fieldLabel:'구분',	// 1:기초잔액, 2:거래합계
			value:'1',
			hidden:true		,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TERM_DIVI', newValue);
				}
			}
		},{
			xtype: 'uniNumberfield',
			name: 'TOT_CD',
			fieldLabel:'과목소계',
			value : 0.0,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TOT_CD', newValue);
				}
			}
		},{
			xtype: 'uniNumberfield',
			name: 'TOT_DR',
			fieldLabel:'차변합계',
			decimalPrecision: UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
			value : 0.0,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TOT_DR', newValue);
				}
			}
		},{
			xtype: 'uniNumberfield',
			name: 'TOT_CR',
			fieldLabel:'대변합계',
			decimalPrecision: UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
			value : 0.0,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TOT_CR', newValue);
				}
			}
		},{
			xtype: 'uniNumberfield',
			name: 'TOT_BL',
			fieldLabel:'차액',
			decimalPrecision: UniFormat.Price.indexOf('.') > -1 ? UniFormat.Price.length-1 - UniFormat.Price.indexOf('.') : 0,
			value : 0.0,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TOT_BL', newValue);
				}
			}
		}]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var btnTbar = [
         '->',{
			itemId : 'btnMake',
			text: '잔액반영',
			handler: function() {
				var params = Ext.getCmp('resultForm').getValues();
				var activeTabId = UniAppManager.app.getActiveTab().getId();          
                    if(activeTabId == 'agj800ukrGrid1'){                
                        params.TERM_DIVI = '1';               
                    }else if(activeTabId == 'agj800ukrGrid2'){
                    	params.TERM_DIVI = '2';
                    }
                console.log(params);
                agj800ukrService.balanceSet(params, function(provider, response){
                  if(!Ext.isEmpty(provider)){
                       	Unilite.messageBox('잔액반영이 완료되었습니다.');
                  }
                });
                UniAppManager.app.onQueryButtonDown();
			}
		},{
			itemId : 'btnCancel',
			text: '잔액취소',
			handler: function() {
				var params = Ext.getCmp('resultForm').getValues();
                var activeTabId = UniAppManager.app.getActiveTab().getId();          
                    if(activeTabId == 'agj800ukrGrid1'){                
                        params.TERM_DIVI = '1';               
                    }else if(activeTabId == 'agj800ukrGrid2'){
                        params.TERM_DIVI = '2';
                    }
                console.log(params);
                agj800ukrService.balanceCancel(params, function(provider, response){
                  if(!Ext.isEmpty(provider)){
                       	Unilite.messageBox('잔액반영이 취소되었습니다.');
                  }
                });
                UniAppManager.app.onQueryButtonDown();
			}
		},{
			itemId : 'btnYear',
			text: '전년실적반영',
			hidden: true,
			handler: function() {
				
			},
			disabled: false
		},{
			itemId : 'btnSale',
			text: '영업실적반영',
			hidden: true,
			handler: function() {
				
			},
			disabled: false
		}
    ]
    var masterGrid = Unilite.createGrid('agj800ukrGrid1', {
    	layout : 'fit',
        title : '기초잔액',
        tbar : btnTbar,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: false
        },
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	//{dataIndex: 'AC_DATE'				, width: 60 , hidden: false}, 				
			//{dataIndex: 'DIV_CODE'				, width: 60 , hidden: false}, 				
			{dataIndex: 'SEQ'					, width: 60 , hidden: true},				
			{dataIndex: 'CUSTOM_CODE'			, width: 60 , hidden: true},
			//{dataIndex: 'EXPIRE_DATE'			, width: 60 , hidden: false},
			//{dataIndex: 'INPUT_DIVI'			, width: 60 , hidden: false}, 				
			//{dataIndex: 'SPEC_DIVI'				, width: 60 , hidden: true},
			//{dataIndex: 'FOR_YN'				, width: 60 , hidden: true},
			{dataIndex: 'ACCNT'					, width: 65,
			 editor:Unilite.popup('ACCNT_G',{
			 	valueFieldName:'ACCNT_NAME',
			    textFieldName:'ACCNT',
			    DBvalueFieldName: 'ACCNT_NAME',
			    DBtextFieldName: 'ACCNT_CODE',
                autoPopup: true,
			 	extParam:{
					'CHARGE_CODE':baseInfo.gsChargeCD,
					//'ADD_QUERY':"SLIP_SW = N'Y' AND ACCNT_DIVI IN ('1', '2', '3') And GROUP_YN = N'N'"
					'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
			 	},
			 	listeners:{
			 		onSelected:{
			 			fn:function(records, type){
			 				var eRecord = masterGrid.uniOpt.currentRecord; 
			 				var accnt =  records[0]["ACCNT_CODE"]
			 				eRecord.set('ACCNT', accnt);
			 				eRecord.set('ACCNT_NAME', records[0]["ACCNT_NAME"]);
			 				
			 				UniAppManager.app.setAccntInfo(eRecord, accnt);
			 				UniAppManager.app.fnCalculation();
			 			}, 
			 			scope: this
			 		},
			 		onClear:function(type)	{
			 			var eRecord = masterGrid.uniOpt.currentRecord; 
			 				
		 				eRecord.set('ACCNT', '');
		 				eRecord.set('ACCNT_NAME', '');
			 			UniAppManager.app.clearAccntInfo(eRecord);
			 			UniAppManager.app.fnCalculation();
			 		}
			 	}
			 })
			}, 				
			{dataIndex: 'ACCNT_NAME' 			, width: 133,
			 editor:Unilite.popup('ACCNT_G',{
			 	valueFieldName:'ACCNT',
			    textFieldName:'ACCNT_NAME',
			    DBvalueFieldName: 'ACCNT_CODE',
			    DBtextFieldName: 'ACCNT_NAME',
                autoPopup: true,
			 	extParam:{
					'CHARGE_CODE':baseInfo.gsChargeCD,
					//'ADD_QUERY':"SLIP_SW = N'Y' AND ACCNT_DIVI IN ('1', '2', '3') And GROUP_YN = N'N'"
					'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
			 	},
			 	listeners:{
			 		onSelected:{
			 			fn:function(records, type){
			 				var eRecord = masterGrid.uniOpt.currentRecord; 
			 				var accnt =  records[0]["ACCNT_CODE"]
			 				eRecord.set('ACCNT', accnt);
			 				eRecord.set('ACCNT_NAME', records[0]["ACCNT_NAME"]);
			 				
			 				UniAppManager.app.setAccntInfo(eRecord, accnt);
			 				UniAppManager.app.fnCalculation();
			 			}, 
			 			scope: this
			 		},
			 		onClear:function(type)	{
			 			var eRecord = masterGrid.uniOpt.currentRecord; 
			 				
		 				eRecord.set('ACCNT', '');
		 				eRecord.set('ACCNT_NAME', '');
			 			UniAppManager.app.clearAccntInfo(eRecord);
			 			UniAppManager.app.fnCalculation();
			 		}
			 	}
			 })
			},
//			{dataIndex: 'ACCNT_SPEC'			, width: 60 , hidden: false},
			//{dataIndex: 'JAN_DIVI'				, width: 60 , hidden: true}, 				
//			{dataIndex: 'MONEY_UNIT'			, width: 60 , hidden: false},
//			{dataIndex: 'DR_FOR_AMT_I'			, width: 60 , hidden: false},
//			{dataIndex: 'CR_FOR_AMT_I'			, width: 60 , hidden: false}, 				
//			{dataIndex: 'EXCHG_RATE_O'			, width: 60 , hidden: false},
			{dataIndex: 'DR_AMT_I'				, width: 93},
			{dataIndex: 'CR_AMT_I'				, width: 93}, 				
			{dataIndex: 'BOOK_CODE1'			, width: 80 , hidden: true},
			{dataIndex: 'BOOK_CODE_NAME1'		, width: 80},
			//{dataIndex: 'BOOK_TYPE1'			, width: 80 , hidden: false}, 				
			//{dataIndex: 'BOOK_LEN1'				, width: 80 , hidden: false},
			//{dataIndex: 'BOOK_POPUP1'			, width: 80 , hidden: false},
			{dataIndex: 'BOOK_DATA1'			, width: 66,
			 getEditor: function(record) {
			 	if(!Ext.isEmpty(record.get('BOOK_CODE_NAME1')) && !Ext.isEmpty(record.get('BOOK_CODE_NAME1'))){
			 	   return UniAccnt.getAcCodeEditor(record, {name:'BOOK_DATA1', isDataField:true, isNameField:false, fieldInfo:{'prefix':'BOOK', 'index':'1', 'popup' : 'BOOK_POPUP1'}});
			 	}
			 }
			}, 				
			{dataIndex: 'BOOK_DATA_NAME1'			, width: 126,
			 getEditor: function(record) {
			 	if(!Ext.isEmpty(record.get('BOOK_CODE_NAME1')) && !Ext.isEmpty(record.get('BOOK_CODE_NAME1'))){
			 	   return UniAccnt.getAcCodeEditor(record, {name:'BOOK_DATA_NAME1', isDataField:true, isNameField:false, fieldInfo:{'prefix':'BOOK', 'index':'1', 'popup' : 'BOOK_POPUP1'}});
			 	}
			 }
			},
			//{dataIndex: 'BOOK_CODE2'			, width: 80 , hidden: true},
			{dataIndex: 'BOOK_CODE_NAME2'		, width: 80}, 				
			//{dataIndex: 'BOOK_TYPE2'			, width: 80 , hidden: false},
			//{dataIndex: 'BOOK_LEN2'				, width: 80 , hidden: false},
			//{dataIndex: 'BOOK_POPUP2'			, width: 80 , hidden: false}, 				
			{dataIndex: 'BOOK_DATA2'			, width: 66,
			 getEditor: function(record) {
			 	if(!Ext.isEmpty(record.get('BOOK_CODE_NAME2')) && !Ext.isEmpty(record.get('BOOK_CODE_NAME2'))){
			 	   return UniAccnt.getAcCodeEditor(record, {name:'BOOK_DATA2', isDataField:true, isNameField:false, fieldInfo:{'prefix':'BOOK', 'index':'2', 'popup' : 'BOOK_POPUP2'}});
			 	}
			 }
			},
			{dataIndex: 'BOOK_DATA_NAME2'			, width: 126,
			 getEditor: function(record) {
			 	if(!Ext.isEmpty(record.get('BOOK_CODE_NAME2')) && !Ext.isEmpty(record.get('BOOK_CODE_NAME2'))){
			 	   return UniAccnt.getAcCodeEditor(record, {name:'BOOK_DATA_NAME2', isDataField:true, isNameField:false, fieldInfo:{'prefix':'BOOK', 'index':'2', 'popup' : 'BOOK_POPUP2'}});
			 	}
			 }
			},
			{dataIndex: 'DEPT_CODE'				, width: 73 , hidden: true,
			 editor:Unilite.popup('DEPT_G',{
			    textFieldName:'DEPT_CODE',
			    DBtextFieldName: 'TREE_CODE',
                autoPopup: true,
			 	listeners:{
			 		onSelected:{
			 			fn:function(records, type){
			 				var eRecord = masterGrid.uniOpt.currentRecord; 
			 				eRecord.set('DEPT_CODE', records[0]["TREE_CODE"]);
			 				eRecord.set('DEPT_NAME', records[0]["TREE_NAME"]);			 				
			 			}, 
			 			scope: this
			 		},
			 		onClear:function(type)	{
			 			var eRecord = masterGrid.uniOpt.currentRecord; 
			 				
		 				eRecord.set('DEPT_CODE', '');
		 				eRecord.set('DEPT_NAME', '');
			 		}
			 	}
			 })
			},
			{dataIndex: 'DEPT_NAME'    			, width: 133,hidden: true,
			 editor:Unilite.popup('DEPT_G',{
                autoPopup: true,
			 	listeners:{
			 		onSelected:{
			 			fn:function(records, type){
			 				var eRecord = masterGrid.uniOpt.currentRecord; 
			 				eRecord.set('DEPT_CODE', records[0]["TREE_CODE"]);
			 				eRecord.set('DEPT_NAME', records[0]["TREE_NAME"]);			 				
			 			}, 
			 			scope: this
			 		},
			 		onClear:function(type)	{
			 			var eRecord = masterGrid.uniOpt.currentRecord; 
			 				
		 				eRecord.set('DEPT_CODE', '');
		 				eRecord.set('DEPT_NAME', '');
			 		}
			 	}
			 })
			}, 				
			{dataIndex: 'PROC_YN'		    	, width: 65, editable:false}
			//{dataIndex: 'COMP_CODE'				, width: 33 , hidden: false}
		],           
		listeners:{
		    selectionChange: function( grid, selected, eOpts ) {
		    	if(selected.length == 1){
                    UniAppManager.app.fnCalculation();
		    	}
            },
			beforeedit:function( editor, context, eOpts )	{
    			if(context.field == "CR_AMT_I" && context.record.get("JAN_DIVI") == '1')	{
    				return false;
    			}
    			if(context.field == "DR_AMT_I" && context.record.get("JAN_DIVI") != '1')	{
    				return false;
    			}
    			if(UniUtils.indexOf(context.field, ["BOOK_DATA1","BOOK_DATA_NAME1"]))	{
    				if(Ext.isEmpty(context.record.get("BOOK_CODE1")))	{
    					return false;
    				}
    			}
    			if(UniUtils.indexOf(context.field, ["BOOK_DATA2","BOOK_DATA_NAME2"]))	{
    				if(Ext.isEmpty(context.record.get("BOOK_CODE2")))	{
    					return false;
    				}
    			}
			},
			onGridDblClick:function(grid, record, cellIndex, colName)    {
				if(colName == "CR_AMT_I" && record.get("JAN_DIVI") == "2" &&  record.get("FOR_YN") == "Y")  {
                    UniAppManager.app.openForeignCur(record, "CR_AMT_I", "CR_FOR_AMT_I");
                }
                
                if(colName == "DR_AMT_I" && record.get("JAN_DIVI") == "1" && record.get("FOR_YN") == "Y")   {
                    UniAppManager.app.openForeignCur(record, "DR_AMT_I", "DR_FOR_AMT_I");
                }
			}
		}
    });      
    
    var masterGrid2 = Unilite.createGrid('agj800ukrGrid2', {
    	layout : 'fit',
        title: '거래합계',
        tbar : btnTbar,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: false
        },
		store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	//{dataIndex: 'AC_DATE'				, width: 60 , hidden: true}, 				
			{dataIndex: 'DIV_CODE'				, width: 60 , hidden: true}, 				
			{dataIndex: 'SEQ'					, width: 60 , hidden: true},			
			{dataIndex: 'CUSTOM_CODE'			, width: 60 , hidden: true},
			//{dataIndex: 'EXPIRE_DATE'			, width: 60 , hidden: true},
			//{dataIndex: 'INPUT_DIVI'			, width: 60 , hidden: true}, 				
			//{dataIndex: 'SPEC_DIVI'				, width: 60 , hidden: true},
			//{dataIndex: 'FOR_YN'				, width: 60 , hidden: true},
			{dataIndex: 'ACCNT'					, width: 65,
			 editor:Unilite.popup('ACCNT_G',{
			 	valueFieldName:'ACCNT_NAME',
			    textFieldName:'ACCNT',
			    DBvalueFieldName: 'ACCNT_NAME',
			    DBtextFieldName: 'ACCNT_CODE',
			 	extParam:{
					'CHARGE_CODE':baseInfo.gsChargeCD,
					//'ADD_QUERY':"SLIP_SW = N'Y' AND ACCNT_DIVI IN ('1', '2', '3') And GROUP_YN = N'N'"
					'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
			 	},
                autoPopup: true,
			 	listeners:{
			 		onSelected:{
			 			fn:function(records, type){
			 				var eRecord = masterGrid2.uniOpt.currentRecord; 
			 				var accnt =  records[0]["ACCNT_CODE"]
			 				eRecord.set('ACCNT', accnt);
			 				eRecord.set('ACCNT_NAME', records[0]["ACCNT_NAME"]);
			 				
			 				UniAppManager.app.setAccntInfo(eRecord, accnt);
			 				UniAppManager.app.fnCalculation();
			 			}, 
			 			scope: this
			 		},
			 		onClear:function(type)	{
			 			var eRecord = masterGrid2.uniOpt.currentRecord; 
			 				
		 				eRecord.set('ACCNT', '');
		 				eRecord.set('ACCNT_NAME', '');
			 			UniAppManager.app.clearAccntInfo(eRecord);
			 			UniAppManager.app.fnCalculation();
			 		}
			 	}
			 })
			}, 				
			{dataIndex: 'ACCNT_NAME' 			, width: 133,
			 editor:Unilite.popup('ACCNT_G',{
			 	valueFieldName:'ACCNT',
			    textFieldName:'ACCNT_NAME',
			    DBvalueFieldName: 'ACCNT_CODE',
			    DBtextFieldName: 'ACCNT_NAME',
                autoPopup: true,
			 	extParam:{
					'CHARGE_CODE':baseInfo.gsChargeCD,
					//'ADD_QUERY':"SLIP_SW = N'Y' AND ACCNT_DIVI IN ('1', '2', '3') And GROUP_YN = N'N'"
					'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
			 	},
			 	listeners:{
			 		onSelected:{
			 			fn:function(records, type){
			 				var eRecord = masterGrid2.uniOpt.currentRecord; 
			 				var accnt =  records[0]["ACCNT_CODE"]
			 				eRecord.set('ACCNT', accnt);
			 				eRecord.set('ACCNT_NAME', records[0]["ACCNT_NAME"]);
			 				
			 				UniAppManager.app.setAccntInfo(eRecord, accnt);
			 				UniAppManager.app.fnCalculation();
			 			}, 
			 			scope: this
			 		},
			 		onClear:function(type)	{
			 			var eRecord = masterGrid2.uniOpt.currentRecord; 
			 				
		 				eRecord.set('ACCNT', '');
		 				eRecord.set('ACCNT_NAME', '');
			 			UniAppManager.app.clearAccntInfo(eRecord);
			 			UniAppManager.app.fnCalculation();
			 		}
			 	}
			 })
			},
			//{dataIndex: 'ACCNT_SPEC'			, width: 60 , hidden: true},
			//{dataIndex: 'JAN_DIVI'				, width: 60 , hidden: true}, 				
			//{dataIndex: 'MONEY_UNIT'			, width: 60 , hidden: true},
			//{dataIndex: 'DR_FOR_AMT_I'			, width: 60 , hidden: true},
			//{dataIndex: 'CR_FOR_AMT_I'			, width: 60 , hidden: true}, 				
			//{dataIndex: 'EXCHG_RATE_O'			, width: 60 , hidden: true},
			{dataIndex: 'DR_AMT_I'				, width: 93},
			{dataIndex: 'CR_AMT_I'				, width: 93}, 				
			//{dataIndex: 'BOOK_CODE1'			, width: 80 , hidden: true},
			{dataIndex: 'BOOK_CODE_NAME1'		, width: 80},
			//{dataIndex: 'BOOK_TYPE1'			, width: 80 , hidden: true}, 				
			//{dataIndex: 'BOOK_LEN1'				, width: 80 , hidden: true},
			//{dataIndex: 'BOOK_POPUP1'			, width: 80 , hidden: true},
			{dataIndex: 'BOOK_DATA1'			, width: 66,
			 getEditor: function(record) {
			 	if(!Ext.isEmpty(record.get('BOOK_CODE_NAME1')) && !Ext.isEmpty(record.get('BOOK_CODE_NAME1'))){
			 	   return UniAccnt.getAcCodeEditor(record, {name:'BOOK_DATA1', isDataField:true, isNameField:false, fieldInfo:{'prefix':'BOOK', 'index':'1', 'popup' : 'BOOK_POPUP1'}});
			 	}
			 }
			}, 				
			{dataIndex: 'BOOK_DATA_NAME1'			, width: 126,
			 getEditor: function(record) {
			 	if(!Ext.isEmpty(record.get('BOOK_CODE_NAME1')) && !Ext.isEmpty(record.get('BOOK_CODE_NAME1'))){
			 	   return UniAccnt.getAcCodeEditor(record, {name:'BOOK_DATA_NAME1', isDataField:true, isNameField:false, fieldInfo:{'prefix':'BOOK', 'index':'1', 'popup' : 'BOOK_POPUP1'}});
			 	}
			 }
			},
			//{dataIndex: 'BOOK_CODE2'			, width: 80 , hidden: true},
			{dataIndex: 'BOOK_CODE_NAME2'		, width: 80}, 				
			//{dataIndex: 'BOOK_TYPE2'			, width: 80 , hidden: true},
			//{dataIndex: 'BOOK_LEN2'				, width: 80 , hidden: true},
			//{dataIndex: 'BOOK_POPUP2'			, width: 80 , hidden: true}, 				
			{dataIndex: 'BOOK_DATA2'			, width: 66,
			 getEditor: function(record) {
			 	if(!Ext.isEmpty(record.get('BOOK_CODE_NAME2')) && !Ext.isEmpty(record.get('BOOK_CODE_NAME2'))){
			 	   return UniAccnt.getAcCodeEditor(record, {name:'BOOK_DATA2', isDataField:true, isNameField:false, fieldInfo:{'prefix':'BOOK', 'index':'2', 'popup' : 'BOOK_POPUP2'}});
			 	}
			 }
			},
			{dataIndex: 'BOOK_DATA_NAME2'			, width: 126,
			 getEditor: function(record) {
			 	if(!Ext.isEmpty(record.get('BOOK_CODE_NAME2')) && !Ext.isEmpty(record.get('BOOK_CODE_NAME2'))){
			 	   return UniAccnt.getAcCodeEditor(record, {name:'BOOK_DATA_NAME2', isDataField:true, isNameField:false, fieldInfo:{'prefix':'BOOK', 'index':'2', 'popup' : 'BOOK_POPUP2'}});
			 	}
			 }
			},
			{dataIndex: 'DEPT_CODE'				, width: 73 , hidden: true,
			 editor:Unilite.popup('DEPT_G',{
			    textFieldName:'DEPT_CODE',
			    DBtextFieldName: 'TREE_CODE',
                autoPopup: true,
			 	listeners:{
			 		onSelected:{
			 			fn:function(records, type){
			 				var eRecord = masterGrid2.uniOpt.currentRecord; 
			 				eRecord.set('DEPT_CODE', records[0]["TREE_CODE"]);
			 				eRecord.set('DEPT_NAME', records[0]["TREE_NAME"]);			 				
			 			}, 
			 			scope: this
			 		},
			 		onClear:function(type)	{
			 			var eRecord = masterGrid2.uniOpt.currentRecord; 
			 				
		 				eRecord.set('DEPT_CODE', '');
		 				eRecord.set('DEPT_NAME', '');
			 		}
			 	}
			 })
			},
			{dataIndex: 'DEPT_NAME'    			, width: 133,hidden: true,
			 editor:Unilite.popup('DEPT_G',{
                autoPopup: true,
			 	listeners:{
			 		onSelected:{
			 			fn:function(records, type){
			 				var eRecord = masterGrid2.uniOpt.currentRecord; 
			 				eRecord.set('DEPT_CODE', records[0]["TREE_CODE"]);
			 				eRecord.set('DEPT_NAME', records[0]["TREE_NAME"]);			 				
			 			}, 
			 			scope: this
			 		},
			 		onClear:function(type)	{
			 			var eRecord = masterGrid2.uniOpt.currentRecord; 
			 				
		 				eRecord.set('DEPT_CODE', '');
		 				eRecord.set('DEPT_NAME', '');
			 		}
			 	}
			 })
			}, 				
			{dataIndex: 'PROC_YN'		    	, width: 65, editable:false}
			//{dataIndex: 'COMP_CODE'				, width: 33 , hidden: true}
		],           
        listeners:{
            selectionChange: function( grid, selected, eOpts ) {
                if(selected.length == 1){
                    UniAppManager.app.fnCalculation();
                }
            },
            beforeedit:function( editor, context, eOpts )   {
                if(context.field == "CR_AMT_I" && context.record.get("JAN_DIVI") == '1')    {
                    return false;
                }
                if(context.field == "DR_AMT_I" && context.record.get("JAN_DIVI") != '1')    {
                    return false;
                }
                if(UniUtils.indexOf(context.field, ["BOOK_DATA1","BOOK_DATA_NAME1"]))	{
    				if(Ext.isEmpty(context.record.get("BOOK_CODE1")))	{
    					return false;
    				}
    			}
    			if(UniUtils.indexOf(context.field, ["BOOK_DATA2","BOOK_DATA_NAME2"]))	{
    				if(Ext.isEmpty(context.record.get("BOOK_CODE2")))	{
    					return false;
    				}
    			}
            },
            onGridDblClick:function(grid, record, cellIndex, colName)    {
                if(colName == "CR_AMT_I" && record.get("JAN_DIVI") == "2" &&  record.get("FOR_YN") == "Y")  {
                    UniAppManager.app.openForeignCur(record, "CR_AMT_I", "CR_FOR_AMT_I");
                }
                
                if(colName == "DR_AMT_I" && record.get("JAN_DIVI") == "1" && record.get("FOR_YN") == "Y")   {
                    UniAppManager.app.openForeignCur(record, "DR_AMT_I", "DR_FOR_AMT_I");
                }
            }
        }
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2
	    ],
        listeners:{
            tabchange: function( tabPanel, newCard, oldCard, eOpts )    {
                if(newCard == oldCard) {
                    return false;
                }
                UniAppManager.app.fnCalculation();
               	UniAppManager.setToolbarButtons(['newData', 'reset'], true);
               	var activeGrid = this.getActiveTab();
               	var selRecord = activeGrid.getSelectedRecord();
               	if(activeGrid.getStore().getCount() == 0){
               		panelResult.setValue('AC_DATE', UniDate.get('today'));
                    panelSearch.setValue('AC_DATE', UniDate.get('today'));
               		UniAppManager.setToolbarButtons('delete', false);
               	}else{
               		panelResult.setValue('AC_DATE', selRecord.get('AC_DATE'));
               		panelSearch.setValue('AC_DATE', selRecord.get('AC_DATE'));
               		UniAppManager.setToolbarButtons('delete', true);
               	}
               	
            }
        }
    });
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
					tab, panelResult
				]
			},
			panelSearch  	
		],
		id : 'agj800ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
		 	value:baseInfo.gsSTDT,
			panelResult.setValue('AC_DATE', !Ext.isEmpty(baseInfo.gsSTDT) ? baseInfo.gsSTDT : UniDate.get('today'));
			panelSearch.setValue('AC_DATE', !Ext.isEmpty(baseInfo.gsSTDT) ? baseInfo.gsSTDT : UniDate.get('today'));
			panelResult.setValue('ACCOUNT_CODE','');
			panelResult.setValue('ACCOUNT_NAME','');
            panelSearch.setValue('ACCOUNT_CODE','');
            panelSearch.setValue('ACCOUNT_NAME','');
			
			
			//UniAppManager.setToolbarButtons(['newData','detail', 'reset', 'save','delete'],false);
            UniAppManager.setToolbarButtons(['save', 'newData'],false);
            
            
		},
        onResetButtonDown:function() {
            panelResult.reset();            
            panelSearch.reset();
            
            masterGrid.reset();
            masterGrid2.reset(); 
            directMasterStore.clearData();
            directMasterStore2.clearData();
            UniAppManager.app.fnCalculation();
            this.fnInitBinding();
        },
		onNewDataButtonDown : function(bDivi)	{
			var activeGrid = this.getActiveTab();
			var selRecord = activeGrid.getSelectedRecord();
			var r = {
				"DIV_CODE" : panelSearch.getValue('DIV_CODE'),
				"AC_DATE" : UniDate.getMonthStr(panelSearch.getValue("AC_DATE")),
				"INPUT_DIVI" : activeGrid.getId() == 'agj800ukrGrid1' ? "1" : "2",
				"DR_FOR_AMT_I" : 0,
				"CR_FOR_AMT_I" : 0,
				"EXCHG_RATE_O" : 0,
				"DEPT_CODE" : (bDivi && selRecord )? selRecord.get("DEPT_CODE") : UserInfo.deptCode,
				"DEPT_NAME" : (bDivi && selRecord )? selRecord.get("DEPT_NAME") : UserInfo.deptName
			}
			activeGrid.createRow(r, "ACCNT");
			
		},
		onQueryButtonDown : function()	{		
			
			if(!this.isValidSearchForm()){
                return false;
            }
			
			var activeTabId = this.getActiveTab().getId();			
			if(activeTabId == 'agj800ukrGrid1'){				
				directMasterStore.loadStoreRecords();				
			}
			if(activeTabId == 'agj800ukrGrid2'){             
                directMasterStore2.loadStoreRecords();               
            }
			
			UniAppManager.setToolbarButtons(['newData', 'reset'], true);
		},
		onSaveDataButtonDown: function (config) {
			var activeGrid = this.getActiveTab();
			activeGrid.getStore().saveStore(config);
			UniAppManager.app.fnCalculation();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onDeleteDataButtonDown : function()	{
			var activeGrid = this.getActiveTab();
			var selRow = activeGrid.getSelectedRecord();
			if(!Ext.isEmpty(selRow)){
    			if(selRow.get('PROC_YN') == 'Y'){
                	Unilite.messageBox('반영된 데이터는 삭제 할 수 없습니다.');
                }else{
                	if(selRow.phantom == true)  {
                     activeGrid.deleteSelectedRow();
                    // UniAppManager.setToolbarButtons('save',false);
                     UniAppManager.app.fnCalculation();
                    }
        			else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        activeGrid.deleteSelectedRow();
                      //  UniAppManager.setToolbarButtons('save',true);
                        UniAppManager.app.fnCalculation();
                    }
                }
			}else{
				//UniAppManager.setToolbarButtons('delete',false);
			}
			
		},
		getActiveTab:function()	{
			return tab.getActiveTab();
		},
		fnSetTxtDisabled: function (bOption)	{
			panelSearch.setAllFieldsReadOnly(bOption);
			panelResult.setAllFieldsReadOnly(bOption)
			
			if(!bOption )	{
				panelSearch.setValue("AC_DATE", UniDate.extFormatMonth(new Date()));
				panelResult.setValue("AC_DATE", UniDate.extFormatMonth(new Date()));
			}
		},
		
//		fnSetBtnDisabled: function(sBalDivi, sActDivi, sSalDivi, sSalFlag)	{
//			
//			switch(sBalDivi)	{
//				case "Y":
//					btnMake.setDisabled(true);
//					btnCancel.setDisabled(false);
//				case "N":
//					btnMake.setDisabled(false);
//					btnCancel.setDisabled(true);
//				case "YN":
//					btnMake.setDisabled(false);
//					btnCancel.setDisabled(false);
//				default :		//Data Not Exists
//					btnMake.setDisabled	(true);
//					btnCancel.setDisabled( true);
//					btnYear.setDisabled(true);
//					btnSale.setDisabled(true);
//					btnMake.setText(Msg.sMA0155);
//					btnCancel.setText(Msg.sMA0156);
//					btnYear.setText(Msg.sMA0157);
//					btnSale.setText(Msg.sMA0159);
//					return;
//			}
//			
//			//잔액취소 모두 반영되었을 때
//			var activeGridId = UniAppManager.app.getActiveTab.getId();
//			if(btnMake.isDisabled())	{					
//				if (activeGridId== "agj800ukrGrid1") {
//					btnYear.setDisabled = false
//					if(sActDivi == "Y")	{
//						btnYear.text	= Msg.sMA0158	//전년실적취소
//					}else {
//						btnYear.text	= Msg.sMA0157	//전년실적반영
//					}
//				}else {
//					btnYear.disabled	= true
//					btnYear.innerText	= Msg.sMA0157	//전년실적반영
//				}
//				
//				if (activeGridId == "agj800ukrGrid1" && sSalDivi == "Y")	{
//					btnSale.setDisabled(false);
//					if(sSalFlag == "Y")	{
//						btnSale.setText(Msg.sMA0160)	//영업기초취소
//					}else {
//						btnSale.setText(Msg.sMA0159)	//영업기초반영
//					}
//				} else {
//					btnSale.setDisabled(true);
//					btnSale.setText(Msg.sMA0159);
//				}
//			}else {
//				btnYear.setDisabled(true);
//				btnSale.setDisabled(true);
//				btnYear.setText(Msg.sMA0157);
//				btnSale.setText(Msg.sMA0159);
//			
//			}
//		
//		},
		
		//과목소계
		fnCalculation: function()	{
			var sCurAcntCD, lLoop;
			var dTotDR, dTotCR, dSubDR, dSubCR;
			
			panelSearch.setValue("TOT_CD", 0);
            panelResult.setValue("TOT_CD", 0);
            panelSearch.setValue("TOT_DR", 0);
            panelResult.setValue("TOT_DR", 0);
            panelSearch.setValue("TOT_CR", 0);
            panelResult.setValue("TOT_CR", 0);
            panelSearch.setValue("TOT_BL", 0);
            panelResult.setValue("TOT_BL", 0);
			
			//var activeGrid = UniAppManager.app.getActiveGrid();
			
			 var activeGrid = UniAppManager.app.getActiveTab();
             var store = activeGrid.getStore();
             var summaryField1 = panelSearch.getField("TOT_CD"); 
             var summaryField2 = panelResult.getField("TOT_CD"); 
             if(activeGrid.getStore().getCount() == 0)   {
                summaryField1.setFieldLabel(Msg.sMA0153)  // 과목소계
                summaryField2.setFieldLabel(Msg.sMA0153)  // 과목소계
               // UniAppManager.setToolbarButtons(['delete', 'seve'], false);
                return;
             } else {
                var selRecord = activeGrid.getSelectedRecord();
                if(!selRecord)  {
                    activeGrid.select(0);
                    selRecord = activeGrid.getStore().getAt(0);
                }
                summaryField1.setFieldLabel(selRecord.get("ACCNT_NAME") + Msg.sMAP026);  // 소계
                summaryField2.setFieldLabel(selRecord.get("ACCNT_NAME") + Msg.sMAP026);  // 소계
                panelResult.setValue("TOT_DR",store.sum("DR_AMT_I"));
                panelSearch.setValue("TOT_DR",store.sum("DR_AMT_I"));
                panelResult.setValue("TOT_CR",store.sum("CR_AMT_I"));
                panelSearch.setValue("TOT_CR",store.sum("CR_AMT_I"));
                panelResult.setValue("TOT_BL",store.sum("DR_AMT_I") - store.sum("CR_AMT_I"));
                panelSearch.setValue("TOT_BL",store.sum("DR_AMT_I") - store.sum("CR_AMT_I"));
                
                sCurAcntCD = selRecord.get("ACCNT");
                var data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('ACCNT')== sCurAcntCD) } ).items);
                var drSum = 0, crSum=0;
                //if(selRecord.get("JAN_DIVI") == '1'){
                    Ext.each(data, function(rec, idx){
                        if(Ext.isDefined(rec.data)) {
                            drSum += rec.get("DR_AMT_I");
                        }
                    })
              //  }
              //  if(selRecord.get("JAN_DIVI") == '2'){
                    Ext.each(data, function(rec, idx){
                        if(Ext.isDefined(rec.data)) {
                            crSum += rec.get("CR_AMT_I");
                        }
                    })
               // }
                if(drSum != 0){
                    panelResult.setValue("TOT_CD",drSum);
                    panelSearch.setValue("TOT_CD",drSum);
                }
                if(crSum != 0){
                    panelResult.setValue("TOT_CD",crSum);
                    panelSearch.setValue("TOT_CD",crSum);
                }
                //UniAppManager.setToolbarButtons('delete', true);
            }
		
		},
		setAccntInfo:function(rtnRecord, accnt)	{
    		Ext.getBody().mask();
    		
    		//UniAccnt.fnIsCostAccnt(accnt, true);
    		if(accnt)	{
    			accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
    				if(provider){
    					UniAppManager.app.loadDataAccntInfo(rtnRecord, provider)
    				}else {
    					Unilite.messageBox(Msg.sMA0006);
    					UniAppManager.app.clearAccntInfo(rtnRecord, provider)
    				}
    				Ext.getBody().unmask();
    				
    			})
    		}
    	},
    	loadDataAccntInfo:function(rtnRecord, provider)	{
    		var oldBooCd1 = rtnRecord.get("BOOK_CODE1");
    		var oldBooCd2 = rtnRecord.get("BOOK_CODE2");
    		
			rtnRecord.set("ACCNT_SPEC", provider.ACCNT_SPEC);
			rtnRecord.set("SPEC_DIVI", provider.SPEC_DIVI);
			rtnRecord.set("FOR_YN", provider.FOR_YN);
			rtnRecord.set("JAN_DIVI", provider.JAN_DIVI);
			rtnRecord.set("BOOK_CODE1", provider.BOOK_CODE1);
			rtnRecord.set("BOOK_CODE_NAME1", provider.BOOK_NAME1);
			rtnRecord.set("BOOK_CODE2", provider.BOOK_CODE2);
			rtnRecord.set("BOOK_CODE_NAME2", provider.BOOK_NAME2);
			
			
			rtnRecord.set("CR_AMT_I",0);
			rtnRecord.set("DR_AMT_I",0);
			
			var activeGrid = UniAppManager.app.getActiveTab();
			rtnRecord.set("INPUT_DIVI", activeGrid.getId() == 'agj800ukrGrid1'  ? '1':'2'); 
			
			rtnRecord.set("BOOK_TYPE1", provider.AC_TYPE1);
			rtnRecord.set("BOOK_LEN1", provider.AC_LEN1);
			rtnRecord.set("BOOK_POPUP1", provider.AC_POPUP1);

			rtnRecord.set("BOOK_TYPE2", provider.AC_TYPE2);
			rtnRecord.set("BOOK_LEN2", provider.AC_LEN2);
			rtnRecord.set("BOOK_POPUP2", provider.AC_POPUP2);

			if(oldBooCd1 != provider.BOOK_CODE1)	{
				rtnRecord.set("BOOK_DATA1", "");
				rtnRecord.set("BOOK_NAME1", "");
			}
			if(oldBooCd2 != provider.BOOK_CODE2)	{
				rtnRecord.set("BOOK_DATA2", "");
				rtnRecord.set("BOOK_NAME2", "");
			}
			if(rtnRecord.get("JAN_DIVI") == "2" &&  rtnRecord.get("FOR_YN") == "Y")  {
                    UniAppManager.app.openForeignCur(rtnRecord, "CR_AMT_I", "CR_FOR_AMT_I");
            }
                
            if(rtnRecord.get("JAN_DIVI") == "1" && rtnRecord.get("FOR_YN") == "Y")   {
                    UniAppManager.app.openForeignCur(rtnRecord, "DR_AMT_I", "DR_FOR_AMT_I");
            }
    	},
    	clearAccntInfo:function(rtnRecord) {
    		rtnRecord.set("ACCNT_SPEC", "");
			rtnRecord.set("SPEC_DIVI", "");
			rtnRecord.set("FOR_YN", "");
			rtnRecord.set("JAN_DIVI", "");
			rtnRecord.set("BOOK_CODE1", "");
			rtnRecord.set("BOOK_CODE_NAME1", "");
			rtnRecord.set("BOOK_CODE2", "");
			rtnRecord.set("BOOK_CODE_NAME2", "");
			
			rtnRecord.set("CR_AMT_I",0);
			rtnRecord.set("DR_AMT_I",0);
			
			rtnRecord.set("BOOK_TYPE1", "A");
			rtnRecord.set("BOOK_LEN1", 0);
			rtnRecord.set("BOOK_POPUP1","N");

			rtnRecord.set("BOOK_TYPE2", "A");
			rtnRecord.set("BOOK_LEN2", 0);
			rtnRecord.set("BOOK_POPUP2", "N");

			rtnRecord.set("BOOK_DATA1", "");
			rtnRecord.set("BOOK_NAME1", "");
			rtnRecord.set("BOOK_DATA2", "");
			rtnRecord.set("BOOK_NAME2", "");
    		
    	},
    	fnCheckNoteAmt:function(record, sNoteNum, newValue, oldValue, fieldName) {
		
			if(Ext.isEmpty(sNoteNum))	{
				return true;
			}
			UniAccnt.fnGetNoteAmt(UniAppManager.app.cbCheckNoteAmt ,sNoteNum, 0, 0, null, newValue, oldValue, record , fieldName);
		 },
		 cbCheckNoteAmt: function(rtn, newAmt,  oldAmt, record, fieldName)	{
	 		var dOcAmtI = rtn.OC_AMT_I, dJAmtI = rtn.J_AMT_I
	 			, dNoteAmtI = (rtn && rtn.length > 0) ? 1:0;
			var dCrAmtI, dDrAmtI;
			var sSpecDivi, sDrCr;
			
	 		dCrAmtI = record.get("CR_AMT_I");
			if(Ext.isEmpty(dCrAmtI))  dCrAmtI = 0;
			
			dDrAmtI = record.get("DR_AMT_I");
			if(Ext.isEmpty(dDrAmtI)) dDrAmtI = 0;
			
			if(dDrAmtI != 0)	{
				sDrCr = "1"
			}else if( dCrAmtI != 0) {
				sDrCr = "2"
			}
			var sSpecDivi = record.get("SPEC_DIVI");
			
			if(dOcAmtI != 0 && dJAmtI != 0){
				
    			if(Ext.isEmpty(rtn) || rtn.length == 0) {
    				if(sSpecDivi == "D1" && sDrCr == "1") {
    					sSpecDivi = true;
    				} else if(sSpecDivi == "D3" && sDrCr == "2") {
    					record.set(fieldName, newAmt);
    				} else {
    					record.set(fieldName, oldAmt);
    				}		
    			}
    			
    			if(sSpecDivi == "D1" && sDrCr == "1")	{
    				if(dOcAmtI != newAmt)	{
    					Unilite.messageBox(Msg.sMA0330);
    					record.set(fieldName, oldAmt);
    				}
    			}
    			
    			dNoteAmtI = dOcAmtI - dJAmtI;
    			
    			if((dNoteAmtI - newAmt) > 0 )	{ 
    				if(confirm(Msg.sMA0333))	{
    					record.set(fieldName, oldAmt);
    				} else {
    					record.set(fieldName, newAmt);
    				}
    			} else if((dNoteAmtI - newAmt) < 0 ) { 
    				Unilite.messageBox(Msg.sMA0332);
    				record.set(fieldName, oldAmt);
    			} else {
    				record.set(fieldName, newAmt);
    			}
			}
			UniAppManager.app.fnCalculation();
		},
		 openForeignCur: function(record, amtFieldNm, forAmtFieldNm)	{
			if(record){
			    if(!foreignWindow) {
						foreignWindow = Ext.create('widget.uniDetailWindow', {
			                title: '외화금액입력',
			                width: 300,				                
			                height: 150,
			            	returnField : amtFieldNm,
			            	aRecord : record,
			                layout: {type:'uniTable', columns:1, tableAttrs:{'width':'100%'}},	                
			                items: [{
				                	itemId:'foreignCurrency',
				                	xtype:'uniSearchForm',
				                	flex: 1,
				                	style:{'background-color':'#fff'},
				                	items:[
				                		{	
				                			fieldLabel:'화폐단위',
				                			name :'MONEY_UNIT',
				                			xtype:'uniCombobox',
				                			comboType:'AU',
				                			comboCode:'B004',
		 									displayField: 'value',
				                			listeners:{
				                				change:function(field, newValue, oldValue) {
				                					if(newValue != oldValue){
					                					var form = foreignWindow.down('#foreignCurrency');
					                					if(!Ext.isEmpty(newValue))	{
						                					foreignWindow.mask();
						                					accntCommonService.fnGetExchgRate(
						                						{
						                							'AC_DATE':	UniDate.getDbDateStr(form.getValue('AC_DATE')),
						                							'MONEY_UNIT':newValue			                							
						                						}, 
						                						function(provider, response){
						                							foreignWindow.unmask();
						                							var form = foreignWindow.down('#foreignCurrency');
						                							if(!Ext.isEmpty(provider['BASE_EXCHG'])) form.setValue('EXCHANGE_RATE',provider['BASE_EXCHG'])
						                						}
						                					)
					                					} else {
					                						if(!Ext.isEmpty(newValue))	{
					                							Unilite.messageBox('화폐단위를 입력해 주세요')
					                							return false;
					                						}
					                					}
				                					}
				                					return true;
				                				}
				                			}
				                		},
				                		{	
				                			fieldLabel:'환율',
				                			xtype:'uniNumberfield',
				                			name :'EXCHANGE_RATE',
				                			allowOnlyWhitespace : true,
				                			decimalPrecision: UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.'):0,
				                			minValue:0,
				                			value:1
				                		},
				                		{	
				                			fieldLabel:'외화금액',
				                			xtype:'uniNumberfield',
				                			name :'FOR_AMT_I',
				                			type:'uniFC',
				                			//decimalPrecision: baseInfo.gsAmtPoint,
				                			listeners:{
				                				specialkey:function(field, event)	{
				                					if(event.getKey() == event.ENTER)	{
				                						foreignWindow.onApply();
				                					}
				                				}
				                			}
				                		},
				                		{	
				                			hidden:true,
				                			fieldLabel:'일자',
				                			xtype:'uniDatefield',
				                			name :'AC_DATE'
				                		}
				                		
				                	]
			               		}
							],
			                tbar:  [
						         '->',{
									itemId : 'submitBtn',
									text: '확인',
									handler: function() {
										foreignWindow.onApply();
									},
									disabled: false
								},{
									itemId : 'closeBtn',
									text: '닫기',
									handler: function() {
										foreignWindow.hide();
									},
									disabled: false
								}
						    ],
							listeners : {
								beforehide: function(me, eOpt)	{
									foreignWindow.down('#foreignCurrency').clearForm();
			                	},
			                	 beforeclose: function( panel, eOpts )	{
									foreignWindow.down('#foreignCurrency').clearForm();
			                	},
			                	show: function( panel, eOpts )	{
			                	 	var selectedRec = foreignWindow.aRecord;
									var form = foreignWindow.down('#foreignCurrency');
									
									form.setValue('AC_DATE', selectedRec.get('AC_DATE'));
									form.setValue('EXCHANGE_RATE', selectedRec.get('EXCHG_RATE_O'));
									form.setValue('MONEY_UNIT', selectedRec.get('MONEY_UNIT'));
									if(!Ext.isEmpty(selectedRec.get('DR_FOR_AMT_I')) && selectedRec.get('DR_FOR_AMT_I') != 0){
									   form.setValue('FOR_AMT_I', selectedRec.get('DR_FOR_AMT_I'));
									}
									if(!Ext.isEmpty(selectedRec.get('CR_FOR_AMT_I')) && selectedRec.get('CR_FOR_AMT_I') != 0){
									   form.setValue('FOR_AMT_I', selectedRec.get('CR_FOR_AMT_I'));
									}
	                			}
			                },
			                onApply:function()	{
			                	var record = foreignWindow.aRecord;
								var form = foreignWindow.down('#foreignCurrency');
								var mUnit = form.getValue('MONEY_UNIT'), 
									forAmt = form.getValue('FOR_AMT_I'), 
									exRate = Ext.isEmpty(form.getValue('EXCHANGE_RATE')) ? 1:form.getValue('EXCHANGE_RATE') ;
								   
								if(!Ext.isEmpty(mUnit) && !Ext.isEmpty(forAmt) &&  !Ext.isEmpty(exRate)) {
									
									record.set('MONEY_UNIT',  	mUnit);
									record.set('EXCHG_RATE_O', 	exRate );
									var numDigit = 0;
	                                if(UniFormat.Price.indexOf(".") > -1) {
	                                	numDigit = (UniFormat.Price.length - (UniFormat.Price.indexOf(".")+1));
	                                }
									var amt = forAmt * exRate;
									amt = UniAccnt.fnAmtWonCalc(amt, baseInfo.gsAmtPoint, numDigit);
									record.set(foreignWindow.returnField, amt);
									record.set(foreignWindow.forAmtFieldNm, 	forAmt );
									record.set("AMT_I", amt);								
								}else {
									if(Ext.isEmpty(mUnit)) Unilite.messageBox("화폐단위를 입력해 주세요");
									if(Ext.isEmpty(exRate)) Unilite.messageBox("환율을 입력해 주세요"); 
									if(Ext.isEmpty(forAmt)) Unilite.messageBox("외화금액을 입력해 주세요"); 
								}
								foreignWindow.hide();
			                }
						});
			    }	
			    foreignWindow.returnField = amtFieldNm;
			    foreignWindow.forAmtFieldNm = forAmtFieldNm;
			    foreignWindow.aRecord = record;
				foreignWindow.center();
				foreignWindow.show();
			}
		}
	});
	
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			if(oldValue == newValue)	{
				return true;
			}
			var rv = true;
			
			var sDrCr
			var sAcData, sAcName, sCustCD, sCustNM
			var sSpecDV	
			var sNoteNum

			sSpecDV = record.get("SPEC_DIVI");
			
			sDrCr = record.get("JAN_DIVI");
			
			switch(fieldName)	{
				case 'DR_AMT_I' :
					var specDiv = record.get("SPEC_DIVI")
					if (specDiv && specDiv.substring(0,1)== "D") {
						if(record.get("BOOK_CODE1") == "C2") {
							sNoteNum = record.get("BOOK_DATA1");
						}else if(record.get("BOOK_CODE2") == "C2")	{
							sNoteNum = record.get("BOOK_DATA2");
						}
						UniAppManager.app.fnCheckNoteAmt(record, sNoteNum, newValue, oldValue, fieldName);
						UniAppManager.app.fnCalculation();
					}else {
						record.set("DR_AMT_I",newValue);
						UniAppManager.app.fnCalculation();
						rv = false;
					}
					break;
				case 'CR_AMT_I' :
					var specDiv = record.get("SPEC_DIVI")
					if (specDiv && specDiv.substring(0,1)== "D") {
						if(record.get("BOOK_CODE1") == "C2") {
							sNoteNum = record.get("BOOK_DATA1");
						}else if(record.get("BOOK_CODE2") == "C2")	{
							sNoteNum = record.get("BOOK_DATA2");
						}
						UniAppManager.app.fnCheckNoteAmt(record, sNoteNum, newValue, oldValue, fieldName);
						UniAppManager.app.fnCalculation();
					}else {
						record.set("CR_AMT_I",newValue);
						UniAppManager.app.fnCalculation();
						rv = false;
					}
					break;
//				case 'ACCNT' :
//                    if(newValue != oldValue){
//                    	UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                    	UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
//                case 'ACCNT_NAME' :
//                    if(newValue != oldValue){
//                        UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
//                case 'BOOK_CODE_NAME1' :
//                    if(newValue != oldValue){
//                        UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
//                case 'BOOK_DATA1' :
//                    if(newValue != oldValue){
//                        UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
//                case 'BOOK_DATA_NAME1' :
//                    if(newValue != oldValue){
//                        UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
//                case 'BOOK_CODE_NAME2' :
//                    if(newValue != oldValue){
//                        UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
//                case 'BOOK_DATA2' :
//                    if(newValue != oldValue){
//                        UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
//                case 'BOOK_DATA_NAME2' :
//                    if(newValue != oldValue){
//                        UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
//                case 'PROC_YN' :
//                    if(newValue != oldValue){
//                        UniAppManager.setToolbarButtons('save', true);
//                    }else{
//                        UniAppManager.setToolbarButtons('save', false);
//                    }
//                    break;
				default:
					break;
			}
			return rv;
			
		}
	});
};


</script>
