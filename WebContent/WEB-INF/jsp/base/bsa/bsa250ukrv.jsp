<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bsa250ukrv"  >
	<t:ExtComboStore comboType="BOR120"   pgmId="bsa250ukrv"/><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP06" /><!-- 장비구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 사용여부 --> 
	<t:ExtComboStore comboType="AU" comboCode="YP01" /> <!-- 매장코드 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="YP07" /> <!-- 브랜드 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('bsa250ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
			{name: 'COMP_CODE'				, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				, type: 'string'},
	    	{name: 'DIV_CODE'				, text: '<t:message code="system.label.base.division" default="사업장"/>'				, type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'SHOP_CODE'				, text: '매장코드'				, type: 'string', allowBlank: false},
	    	{name: 'SHOP_NAME'				, text: '매장명'				, type: 'string', allowBlank: false},
	    	{name: 'DEPT_CODE'				, text: '부서'				, type: 'string', allowBlank: false},
	    	{name: 'DEPT_NAME'				, text: '부서명'				, type: 'string', allowBlank: false},
	    	{name: 'WH_CODE'				, text: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>'				, type: 'string', allowBlank: false, store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
	    	{name: 'BRAND_CODE'				, text: '브랜드(분류)'			, type: 'string', comboType:'AU', comboCode:'YP07', allowBlank: false},
	    	{name: 'PHONE_NUMBER'			, text: '전화번호'				, type: 'string'},
	    	{name: 'STAFF_ID'				, text: '담당자'				, type: 'string', comboType: 'AU', comboCode: 'B024'},
	    	{name: 'USE_YN'					, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'				, type: 'string', comboType: 'AU', comboCode: 'B010'},
	    	{name: 'START_DATE'				, text: '시작일'				, type: 'uniDate'},
	    	{name: 'STOP_DATE'				, text: '종료일'				, type: 'uniDate'},
	    	{name: 'REMARK'					, text: '<t:message code="system.label.base.remarks" default="비고"/>'				, type: 'string'},
	    	{name: 'INSERT_DB_USER'			, text: 'INSERT_DB_USER'	, type: 'string'},
	    	{name: 'INSERT_DB_TIME'			, text: 'INSERT_DB_TIME'	, type: 'string'},
	    	{name: 'UPDATE_DB_USER'			, text: 'UPDATE_DB_USER'	, type: 'string'},
	    	{name: 'UPDATE_DB_TIME'			, text: 'UPDATE_DB_TIME'	, type: 'string'},
	    	{name: 'TEMPC_01'				, text: 'TEMPC_01'			, type: 'string'},
	    	{name: 'TEMPC_02'				, text: 'TEMPC_02'			, type: 'string'},
	    	{name: 'TEMPC_03'				, text: 'TEMPC_03'			, type: 'string'},
	    	{name: 'TEMPN_01'				, text: 'TEMPN_01'			, type: 'integer'},
	    	{name: 'TEMPN_02'				, text: 'TEMPN_02'			, type: 'integer'},
	    	{name: 'TEMPN_03'				, text: 'TEMPN_03'			, type: 'integer'}
		]
	});
	
  	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'bsa250ukrvService.selectDetailList',
        	update: 'bsa250ukrvService.updateDetail',
			create: 'bsa250ukrvService.insertDetail',
			destroy: 'bsa250ukrvService.deleteDetail',
			syncAll: 'bsa250ukrvService.saveAll'
        }
	});
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore = Unilite.createStore('bsa250ukrvMasterStore',{
			model: 'bsa250ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy,
            listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	Ext.getCmp('panelResult').reset();			         
	                }                
            	}
            
        	},
        	loadStoreRecords: function() {
				var param= panelResult.getValues();			
				console.log( param );
				this.load({
					params : param,
					callback : function(records, operation, success) {
						if(success)	{
    						
						}
					}
				});
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기
			saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				} else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		});
	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{					
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '매장명',
				name: 'SHOP_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SHOP_NAME', newValue);
					}
				}
			},
			Unilite.popup('DEPT',{ 
		        	fieldLabel: '부서',
		        	valueFieldName: 'DEPT_CODE', 
					textFieldName: 'DEPT_NAME', 
		        	textFieldWidth:	170,
		        	allowBlank: false,
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('DEPT_CODE', masterForm.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', masterForm.getValue('DEPT_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('DEPT_CODE', '');
							panelResult.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': masterForm.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
		    })] 
		}],
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
					Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	}); 
		
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{					
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '매장명',
				name: 'SHOP_NAME',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SHOP_NAME', newValue);
					}
				}
			},
			Unilite.popup('DEPT',{ 
		        	fieldLabel: '부서',
		        	valueFieldName: 'DEPT_CODE', 
					textFieldName: 'DEPT_NAME', 
		        	textFieldWidth:	170,
		        	allowBlank: false,
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('DEPT_CODE', '');
							panelSearch.setValue('DEPT_NAME', '');
						},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelResult.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
		    })],
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
					Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	}); 
	/**
	 * Master Grid 정의(Grid Panel)
	 * 
	 * @type
	 */
    var masterGrid = Unilite.createGrid('bsa250ukrvGrid', {
    	store: directMasterStore,
    	region: 'center' ,
        layout : 'fit',
    	uniOpt: {	
    		useRowNumberer: false
        },
		columns:[
			{dataIndex: 'COMP_CODE'				, width:100, hidden: true},
        	{dataIndex: 'DIV_CODE'				, width:100, hidden: true},
        	{dataIndex: 'SHOP_CODE'				, width:100},
        	{dataIndex: 'SHOP_NAME'				, width:170},
        	{dataIndex: 'DEPT_CODE'				, width:100	
				  ,'editor' : Unilite.popup('DEPT_G',{  textFieldName:'DEPT_CODE',  textFieldWidth:100, DBtextFieldName: 'TREE_CODE',
					  							autoPopup: true,
					  							listeners: {'onSelected': {
					 								fn: function(records, type) {
					 									UniAppManager.app.fnDeptChange(records);		
					 								},
					 								scope: this
					 							},
					 							'onClear': function(type) {
													var grdRecord = Ext.getCmp('bsa250ukrvGrid').uniOpt.currentRecord;
			                						grdRecord.set('DEPT_CODE','');
							                    	grdRecord.set('DEPT_NAME','');
					 							}
					 				}
								})
				},
			{dataIndex: 'DEPT_NAME'				, width:170	
				  ,'editor' : Unilite.popup('DEPT_G',{textFieldName:'DEPT_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
					  							autoPopup: true,
					  							listeners: {'onSelected': {
					 								fn: function(records, type) {
					 									UniAppManager.app.fnDeptChange(records);	
					 								},
					 								scope: this
					 							},
					 							'onClear': function(type) {
					 								var grdRecord = Ext.getCmp('bsa250ukrvGrid').uniOpt.currentRecord;
							                    	grdRecord.set('DEPT_CODE','');
							                    	grdRecord.set('DEPT_NAME','');
					 							}
					 				}
								})
				 },
        	{dataIndex: 'WH_CODE'				, width:120},
        	{dataIndex: 'BRAND_CODE'			, width:90},
        	{dataIndex: 'PHONE_NUMBER'			, width:115},
			{dataIndex: 'STAFF_ID'				, width:80},
        	{dataIndex: 'USE_YN'				, width:100},
        	{dataIndex: 'START_DATE'			, width:90},
        	{dataIndex: 'STOP_DATE'				, width:90},
        	{dataIndex: 'REMARK'				, width:200},
        	{dataIndex: 'INSERT_DB_USER'		, width:100, hidden: true},
        	{dataIndex: 'INSERT_DB_TIME'		, width:100, hidden: true},
        	{dataIndex: 'UPDATE_DB_USER'		, width:100, hidden: true},
        	{dataIndex: 'UPDATE_DB_TIME'		, width:100, hidden: true},
        	{dataIndex: 'TEMPC_01'				, width:100, hidden: true},
        	{dataIndex: 'TEMPC_02'				, width:100, hidden: true},
        	{dataIndex: 'TEMPC_03'				, width:100, hidden: true},
        	{dataIndex: 'TEMPN_01'				, width:100, hidden: true},
        	{dataIndex: 'TEMPN_02'				, width:100, hidden: true},
        	{dataIndex: 'TEMPN_03'				, width:100, hidden: true}
		],
		listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        		if(e.record.phantom == false) {
        		 	if(UniUtils.indexOf(e.field, ['SHOP_CODE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
        		} else {
        			return true;
        		}
        	} 	
        },
		setItemData: function(record, dataClear) {
       		var grdRecord = this.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set( 'COMP_CODE'			, record['']);                                                                            
       			grdRecord.set( 'DIV_CODE'		 	, record['']);                                                                            
       			grdRecord.set( 'SHOP_CODE'			, record['']);                                                                            
       			grdRecord.set( 'SHOP_NAME'			, record['']);                                                                            
       			grdRecord.set( 'DEPT_CODE'			, record['']);                                                                            
       			grdRecord.set( 'DEPT_NAME'			, record['']);                                                                            
       			grdRecord.set( 'WH_CODE'		 	, record['']);                                                                            
       			grdRecord.set( 'BRAND_CODE'			, record['']);                                                                            
       			grdRecord.set( 'PHONE_NUMBER'	 	, record['']);                                                                            
       			grdRecord.set( 'STAFF_ID'			, record['']);                                                                           
       			grdRecord.set( 'USE_YN'				, record['']);                                                                            
       			grdRecord.set( 'START_DATE'			, record['']);                                                                            
       			grdRecord.set( 'STOP_DATE'			, record['']);                                                                             
       			grdRecord.set( 'REMARK'				, record['']);                                                                            
       			grdRecord.set( 'INSERT_DB_USER'		, record['']);                                                                            	
       			grdRecord.set( 'INSERT_DB_TIME'		, record['']);                                                                            	
       			grdRecord.set( 'UPDATE_DB_USER'		, record['']);                                                                            	
       			grdRecord.set( 'UPDATE_DB_TIME'		, record['']);                                                                            	
       			grdRecord.set( 'TEMPC_01'		 	, record['']);                                                                            
       			grdRecord.set( 'TEMPC_02'		 	, record['']);                                                                            
       			grdRecord.set( 'TEMPC_03'		 	, record['']);                                                                            
       			grdRecord.set( 'TEMPN_01'		 	, record['']);                                                                            
       			grdRecord.set( 'TEMPN_02'		 	, record['']);                                                                            
				grdRecord.set( 'TEMPN_03'			, record['']); 			
			} else {  
       			grdRecord.set( 'COMP_CODE'			, record['COMP_CODE']);		
       			grdRecord.set( 'DIV_CODE'			, record['DIV_CODE']);		
       			grdRecord.set( 'SHOP_CODE'			, record['SHOP_CODE']);		
       			grdRecord.set( 'SHOP_NAME'			, record['SHOP_NAME']);		
       			grdRecord.set( 'DEPT_CODE'			, record['DEPT_CODE']);		
       			grdRecord.set( 'DEPT_NAME'			, record['DEPT_NAME']);		
       			grdRecord.set( 'WH_CODE'			, record['WH_CODE']);		
       			grdRecord.set( 'BRAND_CODE'			, record['BRAND_CODE']);		
       			grdRecord.set( 'PHONE_NUMBER'		, record['PHONE_NUMBER']);	
       			grdRecord.set( 'STAFF_ID'			, record['STAFF_ID']);		
       			grdRecord.set( 'USE_YN'				, record['USE_YN']);	
       			grdRecord.set( 'START_DATE'			, record['START_DATE']);		
       			grdRecord.set( 'STOP_DATE'			, record['STOP_DATE']);				
       			grdRecord.set( 'REMARK'				, record['REMARK']);			
       			grdRecord.set( 'INSERT_DB_USER'		, record['INSERT_DB_USER']);	
       			grdRecord.set( 'INSERT_DB_TIME'		, record['INSERT_DB_TIME']);	
       			grdRecord.set( 'UPDATE_DB_USER'		, record['UPDATE_DB_USER']);	
       			grdRecord.set( 'UPDATE_DB_TIME'		, record['UPDATE_DB_TIME']);	
       			grdRecord.set( 'TEMPC_01'			, record['TEMPC_01']);		
       			grdRecord.set( 'TEMPC_02'			, record['TEMPC_02']);		
       			grdRecord.set( 'TEMPC_03'			, record['TEMPC_03']);		
       			grdRecord.set( 'TEMPN_01'			, record['TEMPN_01']);		
       			grdRecord.set( 'TEMPN_02'			, record['TEMPN_02']);		
				grdRecord.set( 'TEMPN_03'			, record['TEMPN_03']);
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       		}
		}
    });
    
  	Unilite.Main({
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'bsa250ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
		},
		onQueryButtonDown : function() {
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}	
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding();
			panelResult.getField('SHOP_NAME').focus();
			directMasterStore.clearData();
		},
		onNewDataButtonDown : function()	{
			var divCode 	= panelResult.getValue('DIV_CODE');
        	var startDate	= UniDate.get('today');
        	var stopDate	= '';
        	var useYn		= 'Y';
        	var compCode	= UserInfo.compCode; 
			
        	var r ={
        		DIV_CODE: 	divCode,
        		START_DATE: startDate,
        		STOP_DATE:  stopDate,
        		USE_YN: 	useYn,
        		COMP_CODE:  compCode
        	};
	        masterGrid.createRow(r);
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();	
		},

		fnDeptChange: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('DEPT_CODE', record.TREE_CODE);
			grdRecord.set('DEPT_NAME', record.TREE_NAME);
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.DIV_CODE);
			}
		}
	});	
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "USE_YN" :	// 사용여부
					if(newValue == 'N') {
						record.set('STOP_DATE', UniDate.get('today'));
					}
					if(newValue == 'Y') {
						record.set('STOP_DATE', '');
						//Unilite.messageBox(record.get('STOP_DATE'));
					}
				break;
			}
			return rv;
		}
	})
}; 


</script>
