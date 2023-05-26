<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="bcm110ukrv"  >
	<t:ExtComboStore comboType= "BOR120"  /> 		 <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S063" /> 		 <!-- 주문유형 -->
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
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm110ukrvService.selectMaster',
			update: 'bcm110ukrvService.updateDetail',
			create: 'bcm110ukrvService.insertDetail',
			destroy: 'bcm110ukrvService.deleteDetail',
			syncAll: 'bcm110ukrvService.saveAll'
		}
	});
	
	
	Unilite.defineModel('bcm110ukrvModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'     			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
		    {name: 'SO_TYPE'       			,text: '주문유형'				,type: 'string', comboType: 'AU', comboCode: 'S063'},
		    {name: 'CUSTOMER_ID'   			,text: '고객ID'				,type: 'string'},
		    {name: 'CUSTOMER_NAME' 			,text: '고객명'				,type: 'string'},
		    {name: 'TELEPHONE_NUM1'			,text: '전화번호1'				,type: 'string'},
		    {name: 'TELEPHONE_NUM2'			,text: '전화번호2'				,type: 'string'},
		    {name: 'FAX_NUM'       			,text: '팩스번호'				,type: 'string'},
		    {name: 'ZIP_NUM'       			,text: '우편번호'				,type: 'string'},
		    {name: 'ADDRESS1'      			,text: '주소'					,type: 'string'},
		    {name: 'ADDRESS2'      			,text: '상세주소'				,type: 'string'},
		    {name: 'CUSTOM_CODE'   			,text: '거래처코드'				,type: 'string'},
		    {name: 'CUSTOM_NAME'   			,text: '거래처명'				,type: 'string'},
		    {name: 'REMARK'        			,text: '<t:message code="system.label.base.remarks" default="비고"/>'					,type: 'string'}
		]
	}); //End of Unilite.defineModel('bcm110ukrvModel', {

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '고객ID', 
        		name:'CUSTOMER_ID', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TYPE_LEVEL', newValue);
					}
				}        		
            },{
        		fieldLabel: '고객명', 
        		name:'CUSTOMER_NAME', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOMER_NAME', newValue);
					}
				}          		
            },{
				fieldLabel: '주문유형',
				name:'SO_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S063',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SO_TYPE', newValue);
					}
				}  				
			},{
        		fieldLabel: '전화번호1', 
        		name:'TELEPHONE_NUM1', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TELEPHONE_NUM1', newValue);
					}
				}          		
            },{
        		fieldLabel: '전화번호2', 
        		name:'TELEPHONE_NUM2', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TELEPHONE_NUM2', newValue);
					}
				}          		
            },{
        		fieldLabel: '주소', 
        		name:'ADDRESS1', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ADDRESS1', newValue);
					}
				}          		
            }]
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
		
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
    
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
        		fieldLabel: '고객ID', 
        		name:'CUSTOMER_ID', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TYPE_LEVEL', newValue);
					}
				}        		
            },{
        		fieldLabel: '고객명', 
        		name:'CUSTOMER_NAME', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CUSTOMER_NAME', newValue);
					}
				}          		
            },{
				fieldLabel: '주문유형',
				name:'SO_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S063',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SO_TYPE', newValue);
					}
				}  				
			},{
        		fieldLabel: '전화번호1', 
        		name:'TELEPHONE_NUM1', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TELEPHONE_NUM1', newValue);
					}
				}          		
            },{
        		fieldLabel: '전화번호2', 
        		name:'TELEPHONE_NUM2', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('TELEPHONE_NUM2', newValue);
					}
				}          		
            },{
        		fieldLabel: '주소', 
        		name:'ADDRESS1', 
        		xtype: 'uniTextfield',
		 		//allowBlank:false
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ADDRESS1', newValue);
					}
				}          		
            
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
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bcm110ukrvMasterStore1',{
		model: 'bcm110ukrvModel',
        autoLoad: false,
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
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
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
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
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			}	
		},
		groupField: ''
			
	});
	
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bcm110ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
//        tbar: [{
//        	text:'상세보기',
//        	handler: function() {
//        		var record = masterGrid.getSelectedRecord();
//	        	if(record) {
//	        		openDetailWindow(record);
//	        	}
//        	}
//        }],
        columns: [        			 
			{dataIndex: 'COMP_CODE'     					, width: 53 , hidden: true}, 
			{dataIndex: 'SO_TYPE'       	 				, width: 66},
			{dataIndex: 'CUSTOMER_ID'   	 				, width: 53},
			{dataIndex: 'CUSTOMER_NAME' 					, width: 80}, 
			{dataIndex: 'TELEPHONE_NUM1'	 				, width: 100},
			{dataIndex: 'TELEPHONE_NUM2'	 				, width: 100},
			{dataIndex: 'FAX_NUM'       					, width: 66}, 
			{dataIndex: 'ZIP_NUM'       	 				, width: 66},
			{dataIndex: 'ADDRESS1'      	 				, width: 133},
			{dataIndex: 'ADDRESS2'      					, width: 213}, 
	   		 { dataIndex: 'CUSTOM_CODE'		  			  				     , 	width:96,
				'editor' : Unilite.popup('CUST_G', {		
					 		textFieldName: 'CUSTOM_CODE',
					 		DBtextFieldName: 'CUSTOM_CODE',	
			  				autoPopup: true,						
							listeners: {'onSelected': {
									fn: function(records, type) {									
				                    	var grdRecord;
				                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
										if(selectedRecords && selectedRecords.length > 0 ) {
											grdRecord= selectedRecords[0];
										}		                    	
										grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
										grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
									},
									scope: this
								},
								'onClear': function(type) {
			                  		var grdRecord;
			                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
									if(selectedRecords && selectedRecords.length > 0 ) {
										grdRecord= selectedRecords[0];
									}
									grdRecord.set('CUSTOM_CODE','');
									grdRecord.set('CUSTOM_NAME','');
								},
								applyextparam: function(popup){							
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								}
							}
				})                		 
	   		 },
	   		 { dataIndex: 'CUSTOM_NAME'		  			  				     , 	width:160,
				'editor' : Unilite.popup('CUST_G', {		
			  				autoPopup: true,						
							listeners: {'onSelected': {
			                    fn: function(records, type  ){
			                    	var grdRecord;
			                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
									if(selectedRecords && selectedRecords.length > 0 ) {
										grdRecord= selectedRecords[0];
									}		                    	
									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
									grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
							},
							'onClear': function(type) {
		                  		var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}		                    	
								grdRecord.set('CUSTOM_CODE','');
								grdRecord.set('CUSTOM_NAME','');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				})  
	   		 },				
//			{dataIndex: 'CUSTOM_CODE'   	 				, width: 100},
//			{dataIndex: 'CUSTOM_NAME'   	 				, width: 166},
			{dataIndex: 'REMARK'        					, width: 66}
			
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bcm110ukrvGrid1', {

    Unilite.Main( {
		borderItems:[{
			border: false,
			region: 'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]
		}	 
		,panelSearch
		],
		id: 'bcm110ukrvApp',
		fnInitBinding : function() {
//			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
		},
		onQueryButtonDown : function() {		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			beforeRowIndex = -1;
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true);
		},
		setDefault: function() {		// 기본값
        	//panelSearch.setValue('TYPE_LEVEL',UserInfo.divCode);
        	panelSearch.getForm().wasDirty = false;
         	panelSearch.resetDirtyStatus();                            
         	UniAppManager.setToolbarButtons('save', false); 
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			//panelSearch.setValue('TYPE_LEVEL',UserInfo.divCode);
			//panelResult.setValue('TYPE_LEVEL',UserInfo.divCode);
			masterGrid.reset();
			this.fnInitBinding();
			directMasterStore1.clearData();
		},		
		onNewDataButtonDown: function()	{		// 행추가
			//if(containerclick(masterGrid)) {		
				var soType				=	'';   
				var customerId      	=	'';
				var customerName     	=	'';
				var telephoneNum1       =	'';
				var telephoneNum2     	=	'';
				var faxNum         		=	'';
				var zipNum    			=	'';
				var address1  			=	'';
				var address2 			=	'';
				var customCode  		=	'';
				var customName 			=	'';
				var remark 				=	'';	
				var updateDbUser 		=	'';
				var updateDbTime 		=	'';					
				var compCode			= 	UserInfo.compCode; 
				
				var r = {
					SO_TYPE:				soType,	
					CUSTOMER_ID:			customerId,
					CUSTOMER_NAME:			customerName,
					TELEPHONE_NUM1:			telephoneNum1,
					TELEPHONE_NUM2:			telephoneNum2,
					FAX_NUM:				faxNum,
					ZIP_NUM:				zipNum,
					ADDRESS1:				address1,
					ADDRESS2:				address2,
					CUSTOM_CODE:			customCode,
					CUSTOM_NAME:			customName,
					REMARK:					remark,					
					UPDATE_DB_USER:			updateDbUser,
					UPDATE_DB_TIME:			updateDbTime,					
					COMP_CODE:			compCode
				};
				masterGrid.createRow(r);
			/*} else {
				//var compCode		=	  
				var divCode   		= masterGrid.getSelectedRecord('TYPE_LEVEL');
				var whCode       	= masterGrid.getSelectedRecord('TREE_CODE');
				var whCellCode   	= '';
				var whCellName   	= '';
				var useYn        	= 'Y';
				var validYn      	= 'Y';
				var whCellBarcode	= '';
				var Remark       	= '';
				var insertDbUser 	= '';
				var insertDbTime 	= '';
				var updateDbUser 	= '';
				var updateDbTime	= '';
				
				var r = {
					//COMP_CODE:			compCode,	
					DIV_CODE:				divCode,
					WH_CODE:				whCode,
					WH_CELL_CODE:			whCellCode,
					WH_CELL_NAME:			whCellName,
					USE_YN:					useYn,
					VALID_YN:				validYn,
					WH_CELL_BARCODE:		whCellBarcode,
					REMARK:					Remark,
					INSERT_DB_USER:			insertDbUser,
					INSERT_DB_TIME:			insertDbTime,
					UPDATE_DB_USER:			updateDbUser,
					UPDATE_DB_TIME:			updateDbTime
				};
				masterGrid2.createRow(r);
			}*/
		},		
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		rejectSave: function() {	// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();
			
			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();
				
				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {															
					}
				);
			}
			directMasterStore1.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('bcm110ukrvFileUploadPanel');
        	if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	}); //End of Unilite.Main( {
};

</script>
