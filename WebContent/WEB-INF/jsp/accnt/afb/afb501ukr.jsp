<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="afb501ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A128" /> <!-- 예산과목구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb501ukrService.selectDetail',
			update: 'afb501ukrService.updateDetail',
			create: 'afb501ukrService.insertDetail',
			destroy: 'afb501ukrService.deleteDetail',
			syncAll: 'afb501ukrService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb501ukrService2.selectDetail',
			update: 'afb501ukrService2.updateDetail',
			create: 'afb501ukrService2.insertDetail',
			destroy: 'afb501ukrService2.deleteDetail',
			syncAll: 'afb501ukrService2.saveAll'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afb501Model', {
	   fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
			{name: 'BUDG_CODE'			, text: '예산코드'				, type: 'string'},
			{name: 'BUDG_NAME'			, text: '예산과목명'			, type: 'string'},
			{name: 'CODE_LEVEL'			, text: 'CODE_LEVEL'		, type: 'string'},
			{name: 'BUDG_I'				, text: '편성금액'				, type: 'uniPrice'},
			{name: 'REMARK'				, text: '비고'				, type: 'string'}
	    ]
	});		// End of Ext.define('Afb501ukrModel', {
	
	Unilite.defineModel('Afb501Model2', {
	   fields: [                                                                   
			{name: 'CAL_DETAIL'				, text: '산출내역'			, type: 'string'},             
			{name: 'CAL_BASE'				, text: '산출근거'			, type: 'string'},             
			{name: 'BUDG_CAL_I'				, text: '산출금액'			, type: 'string'},             
			{name: 'COMP_CODE'				, text: '법인코드'			, type: 'string'},             
			{name: 'AC_YYYY'				, text: '예산년도'			, type: 'string'},             
			{name: 'DIV_CODE'				, text: '사업장코드'		, type: 'string'},             
			{name: 'BUDG_CODE'				, text: '예산코드'			, type: 'string'},             
			{name: 'SEQ'					, text: '순번'			, type: 'string'},             
			{name: 'INSERT_DB_USER'			, text: '작성자'			, type: 'string'},             
			{name: 'INSERT_DB_TIME'			, text: '작성일'			, type: 'string'},             
			{name: 'UPDATE_DB_USER'			, text: '수정자'			, type: 'string'},             
			{name: 'UPDATE_DB_TIME'			, text: '수정일'			, type: 'string'}
	    ]
	});		// End of Ext.define('Afb501ukrModel', {
	
	var directMasterStore = Unilite.createStore('afb501MasterStore1',{
		model: 'Afb501Model',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			var billDiviCode = panelSearch.getValue('BILL_DIV_CODE');
			var param= {
				FR_PUB_DATE : startDateValue,
				TO_PUB_DATE : endDateValue,
				BILL_DIV_CODE : billDiviCode
			}
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
			load: function(store, records, successful, eOpts) {
	        	UniAppManager.app.setInputTable();
	        	var i= 0;
	        	for(var j=0; j<records.length; j++) {
					i++;
					records[j].data.SEQ2 = i; 
				}
				store.insert(0, records);
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
				UniAppManager.app.setInputTable();
			}	
		}
	});
	
	var directMasterStore2 = Unilite.createStore('afb501MasterStore2',{
		model: 'Afb501Model2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords: function() {
			var startField = panelSearch.getField('FR_PUB_DATE');
			var startDateValue = startField.getStartDate();
			var endField = panelSearch.getField('TO_PUB_DATE');
			var endDateValue = endField.getEndDate();
			var billDiviCode = panelSearch.getValue('BILL_DIV_CODE');
			var param= {
				FR_PUB_DATE : startDateValue,
				TO_PUB_DATE : endDateValue,
				BILL_DIV_CODE : billDiviCode
			}
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
			load: function(store, records, successful, eOpts) {
	        	UniAppManager.app.setInputTable();
	        	var i= 0;
	        	for(var j=0; j<records.length; j++) {
					i++;
					records[j].data.SEQ2 = i; 
				}
				store.insert(0, records);
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
				UniAppManager.app.setInputTable();
			}	
		}
	});
	
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
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
		            xtype: 'uniYearField',
		            name: 'AC_YYYY',
		            fieldLabel: '사업년도',
		            value: new Date().getFullYear(),
		            fieldStyle: 'text-align: center;',
		            allowBlank:false,
		            listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_YYYY', newValue);
						}
					}
		         },
		         Unilite.popup('BUDG',{
				        fieldLabel: '예산과목',
					    valueFieldName:'BUDG_CODE_FR',
					    textFieldName:'BUDG_NAME_FR',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE_FR'));
									panelResult.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_NAME_FR'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE_FR', '');
								panelResult.setValue('BUDG_NAME_FR', '');
								panelSearch.setValue('BUDG_CODE_FR', '');
								panelSearch.setValue('BUDG_NAME_FR', '');
							},
							applyextparam: function(popup) {							
								popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
//						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
							}
						}
			    }),
			      	Unilite.popup('BUDG',{
				        fieldLabel: '~',
					    valueFieldName:'BUDG_CODE_TO',
					    textFieldName:'BUDG_NAME_TO',
				        //validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('BUDG_CODE_FR', panelSearch.getValue('BUDG_CODE_FR'));
									panelResult.setValue('BUDG_NAME_FR', panelSearch.getValue('BUDG_NAME_FR'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('BUDG_CODE_FR', '');
								panelResult.setValue('BUDG_NAME_FR', '');
								panelSearch.setValue('BUDG_CODE_FR', '');
								panelSearch.setValue('BUDG_NAME_FR', '');
							},
							applyextparam: function(popup) {							
								popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
//						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
							}
						}
			    }),{
		            xtype: 'uniCombobox',
		            name: 'BUDG_TYPE',
		            comboType:'AU',
					comboCode:'A132',
	            	value: '2',
		            fieldLabel: '수지구분',
		            listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BUDG_TYPE', newValue);
						}
					}
		         },{
			        fieldLabel: '사업장',
				    name:'ACCNT_DIV_CODE', 
				    xtype: 'uniCombobox',
		            allowBlank:false,
					typeAhead: false,
					value:UserInfo.divCode,
					comboType:'BOR120',
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			    }
			]
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
					alert(labelText+Msg.sMB083);
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
		}
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{
	            xtype: 'uniYearField',
	            name: 'AC_YYYY',
	            fieldLabel: '사업년도',
	            value: new Date().getFullYear(),
	            fieldStyle: 'text-align: center;',
	            allowBlank:false,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_YYYY', newValue);
					}
				}
	         },
	         Unilite.popup('BUDG',{
			        fieldLabel: '예산과목',
				    valueFieldName:'BUDG_CODE_FR',
				    textFieldName:'BUDG_NAME_FR',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BUDG_CODE_FR', panelResult.getValue('BUDG_CODE_FR'));
								panelSearch.setValue('BUDG_NAME_FR', panelResult.getValue('BUDG_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BUDG_CODE_FR', '');
							panelSearch.setValue('BUDG_NAME_FR', '');
							panelResult.setValue('BUDG_CODE_FR', '');
							panelResult.setValue('BUDG_NAME_FR', '');
						},
						applyextparam: function(popup) {							
							popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
//						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
						}
					}
		    }),{
	            xtype: 'uniCombobox',
	            name: 'BUDG_TYPE',
	            comboType:'AU',
				comboCode:'A132',
            	value: '2',
	            fieldLabel: '수지구분',
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BUDG_TYPE', newValue);
					}
				}
	         },{
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
	            allowBlank:false,
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
		    },
		    Unilite.popup('BUDG',{
			        fieldLabel: '~',
				    valueFieldName:'BUDG_CODE_TO',
				    textFieldName:'BUDG_NAME_TO',
			        //validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('BUDG_CODE_FR', panelResult.getValue('BUDG_CODE_FR'));
								panelSearch.setValue('BUDG_NAME_FR', panelResult.getValue('BUDG_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('BUDG_CODE_FR', '');
							panelSearch.setValue('BUDG_NAME_FR', '');
							panelResult.setValue('BUDG_CODE_FR', '');
							panelResult.setValue('BUDG_NAME_FR', '');
						},
						applyextparam: function(popup) {							
							popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
//						   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
						}
					}
		    })
		],
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
		}
	});
	
	var masterGrid = Unilite.createGrid('afb501Grid1', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	
    		dock: 'top',
    		showSummaryRow: true
    	}],
        columns: [
        	{dataIndex: 'COMP_CODE'				, width: 66, hidden: true},
        	{dataIndex: 'BUDG_CODE'				, width: 133},
        	{dataIndex: 'BUDG_NAME'				, width: 533},
        	{dataIndex: 'CODE_LEVEL'			, width: 66, hidden: true},
        	{dataIndex: 'BUDG_I'				, width: 166},
        	{dataIndex: 'REMARK'				, width: 200}
        ]
    });
    
    var masterGrid2 = Unilite.createGrid('afb501Grid2', {
    	layout : 'fit',
        region : 'south',
		store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	
    		dock: 'top',
    		showSummaryRow: true
    	}],
        columns: [
        	{dataIndex: 'CAL_DETAIL'					, width: 366},
        	{dataIndex: 'CAL_BASE'						, width: 366},
        	{dataIndex: 'BUDG_CAL_I'					, width: 133},
        	{dataIndex: 'COMP_CODE'						, width: 66, hidden: true},
        	{dataIndex: 'AC_YYYY'						, width: 66, hidden: true},
        	{dataIndex: 'DIV_CODE'						, width: 66, hidden: true},
        	{dataIndex: 'BUDG_CODE'						, width: 133, hidden: true},
        	{dataIndex: 'SEQ'							, width: 66, hidden: true},
        	{dataIndex: 'INSERT_DB_USER'				, width: 66, hidden: true},
        	{dataIndex: 'INSERT_DB_TIME'				, width: 66, hidden: true},
        	{dataIndex: 'UPDATE_DB_USER'				, width: 66, hidden: true},
        	{dataIndex: 'UPDATE_DB_TIME'				, width: 66, hidden: true}
        ]
    });
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, masterGrid2, panelResult
			]	
		}		
		, panelSearch
		],
		id  : 'afb501ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('AC_YYYY',new Date().getFullYear());
//			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
//			if(!UniAppManager.app.checkForNewDetail()){
//				return false;
//			}else{
				panelSearch.mask('loading...');
				var param= panelSearch.getValues();
				
				panelSearch.getForm().load({
					params: param,
					success: function(form, action) {
						panelSearch.unmask();
					},
					failure: function(form, action) {
						panelSearch.unmask();
					}
				});
				UniAppManager.setToolbarButtons('reset',true);
//				panelSearch.setAllFieldsReadOnly(true);
				
//			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {				
			var param = panelSearch.getValues();
			
			param.SAVE_FLAG = SAVE_FLAG;
			
			param.txtFrPubDate = UniDate.getDbDateStr(panelSearch.getValue("txtFrPubDate"));
			param.txtToPubDate = UniDate.getDbDateStr(panelSearch.getValue("txtToPubDate"));
	
			
			panelSearch.getForm().submit({
			params : param,
				success : function(form, action) {
	 				panelSearch.getForm().wasDirty = false;
					panelSearch.resetDirtyStatus();											
					UniAppManager.setToolbarButtons('save', false);	
	            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
	            	UniAppManager.app.onQueryButtonDown();
				}	
			});
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				panelSearch.clearForm();
			 	UniAppManager.app.setAllSumTableDefaultValue();
				UniAppManager.setToolbarButtons('delete',false);
				UniAppManager.setToolbarButtons('save',true);
				SAVE_FLAG = 'D';
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setFieldsReadOnly(true);
        }

	});

	Unilite.createValidator('validator01', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
			
			}
			return rv;
		}
	});	
};


</script>
