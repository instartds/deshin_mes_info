<%@page language="java" contentType="text/html; charset=utf-8"%> 
	<t:appConfig pgmId="s_afb410ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장				 -->  
	<t:ExtComboStore comboType="AU" comboCode="A128" /> <!-- 예산과목구분 			 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 그룹 				 -->
	<t:ExtComboStore comboType="AU" comboCode="A129" /> <!-- 예산통제계산단위 		 -->
	<t:ExtComboStore comboType="AU" comboCode="A130" /> <!-- 예산통제기간단위 		 -->
	<t:ExtComboStore comboType="AU" comboCode="A131" /> <!-- 예산과실적집계대상단위목구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" /> <!-- 수지구분 				 -->
	<t:ExtComboStore comboType="AU" comboCode="A199" /> <!-- 예산과목 Mapping항목 	 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부 	 -->
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
	
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	
var lastYearCopyWindow; // 전년도자료복사 버튼

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_Afb410ukrService_KOCIS.selectList',
			update: 's_Afb410ukrService_KOCIS.updateMulti',
			//create: 's_Afb410ukrService_KOCIS.insertDetail',
			destroy: 's_Afb410ukrService_KOCIS.deleteMulti',
			syncAll: 's_Afb410ukrService_KOCIS.saveAll'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineTreeModel('Afb410Model', {
	   fields: [
			{name: 'BUDG_CODE'			, text: '예산과목'			, type: 'string'},
			{name: 'BUDG_NAME'			, text: '예산과목명'		, type: 'string'},
			{name: 'GROUP_YN'			, text: '그룹'			, type: 'string', comboType: 'AU', comboCode:'A020'},
			{name: 'CODE_LEVEL'			, text: '예산과목레벨'		, type: 'string'},
			{name: 'TREE_LEVEL'			, text: '상위예산과목'		, type: 'string'},
//			{name: 'ACCNT'				, text: '계정코드'			, type: 'string', allowBlank: false, maxLength: 16},
//			{name: 'ACCNT_NAME'			, text: '계정코드명'		, type: 'string', allowBlank: false, maxLength: 50},
//			{name: 'PJT_CODE'			, text: '프로젝트코드'		, type: 'string', maxLength: 20},
//			{name: 'PJT_NAME'			, text: '프로젝트명'		, type: 'string', maxLength: 40},
			{name: 'BUDG_TYPE'			, text: '수지구분'			, type: 'string', comboType: 'AU', comboCode:'A132'},
			{name: 'USE_YN'				, text: '사용여부'			, type: 'string', allowBlank: false, comboType: 'AU', comboCode:'A004'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'AC_YYYY'			, text: '사업년도'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서'			, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: '작성자'			, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '작성일'			, type: 'uniDate'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'			, type: 'uniDate'},
			{name: 'parentId' 			, text: '상위부서코드' 		, type: 'string'}	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
	    ]
	});		
	
	var masterStore = Unilite.createTreeStore('afb410ukrMasterStore',{
			model: 'Afb410Model',
            autoLoad: false,
//            expanded: true,
            folderSort: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
//            root: {
//        		expanded: true,
//        		children: [
//        			{text: '예산과목명', expanded: true}
//        		]
//            },
            proxy: directProxy,
            listeners: {
            	'load' : function( store, records, successful, operation, node, eOpts ) {
            		if(records) {
            			var root = this.getRootNode();
            			if(root) {
            				root.expandChildren();
            			}
//	            		node.cascadeBy(function(n){
//							if(n.hasChildNodes())	{
//								n.expand();
//							}
//						})
            		}
            	}
            },
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			saveStore : function()	{		
				var me = this;
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				
				// 상위 부서 코드 정리
				var toCreate = me.getNewRecords();
        		var toUpdate = me.getUpdatedRecords();
        		
        		var toDelete = me.getRemovedRecords();
        		var list = [].concat( toUpdate, toCreate   );
				
				console.log("list:", list);
				if(inValidRecs.length == 0 )	{
					Ext.each(list, function(node, index) {
						var pid = node.get('parentId');
						if(Ext.isEmpty(pid)) {
							node.set('parentId', node.parentNode.get('BUDG_CODE'));
						}
						console.log("list:", node.get('parentId') + " / " + node.parentNode.get('BUDG_CODE'));
					});
					this.syncAllDirect();
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}				
			}
            
	});		
	
	var panelSearch = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable' , columns: 2, tableAttrs: {width: '100%'}},
        items: [{
            	xtype: 'container',
    			defaultType: 'uniTextfield',
    			layout: {type: 'uniTable'},
    			items: [{
		            xtype: 'uniYearField',
		            name: 'AC_YYYY',
		            fieldLabel: '사업년도',
		            value: new Date().getFullYear(),
		            fieldStyle: 'text-align: center;',
		            allowBlank:false
		         },{
                    xtype: 'uniCombobox',
                    name: 'AC_GUBUN',
                    comboType:'AU',
                    comboCode:'A390',
                    fieldLabel: '회계구분'
                  /*  listeners: {
                        specialKey: function(elm, e){
                            if (e.getKey() == e.ENTER) {
                                UniAppManager.app.onQueryButtonDown();  
                            }
                        }
                        
                        change: function(field, newValue, oldValue, eOpts) {
                            UniAppManager.app.onQueryButtonDown();  
                        }
                    }*/
                 },{
                    xtype: 'uniCombobox',
                    fieldLabel: '기관',
                    name: 'DEPT_CODE',
                    store: Ext.data.StoreManager.lookup('deptKocis')
                }]
        	},{
        		xtype:'component'
        	},/*{
				xtype: 'button',
				text: '타부서 복사',	
				name: '',
				width: 100,	
				tdAttrs: {align: 'right'},				   	
				handler : function(records) {
					openlastYearCopyWindow();
				}
			},*/{
            	xtype: 'container',
    			defaultType: 'uniTextfield',
    			layout: {type: 'uniTable'},
    			items: [{
			            xtype: 'uniCombobox',
			            name: 'BUDG_TYPE',
			            comboType:'AU',
						comboCode:'A132',
			            allowBlank:false,
		            	value: '2',
			            fieldLabel: '수지구분'
			        },
					Unilite.popup('BUDG', {
							fieldLabel: '예산과목', 
							valueFieldName: 'BUDG_CODE',
				    		textFieldName: 'BUDG_NAME',
							listeners: {
								onSelected: {
									fn: function(records, type) {
										var name = "BUDG_NAME_L"+records[0]["CODE_LEVEL"] ;
										panelSearch.setValue('BUDG_NAME', records[0][name]);
									}
								},
								onClear: function(type)	{
									panelSearch.setValue('BUDG_CODE', '');
									panelSearch.setValue('BUDG_NAME', '');
								},
								applyextparam: function(popup) {							
									popup.setExtParam({'AC_YYYY': panelSearch.getValue('AC_YYYY')});
//							   		popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')});
							   		popup.setExtParam({'ADD_QUERY' : "BUDG_TYPE = '2' AND USE_YN = 'Y'"});
								}
							}
					})
				]
			},{
				xtype: 'button',
				text: '전체사용',	
				name: '',
				width: 100,	
				tdAttrs: {align: 'right'},				   	
				handler : function(records) {
					var count = masterGrid.getStore().getCount();
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					if(count > 0) {
						var records = masterStore.data.items;
						Ext.each(records, function(record,i) {
							if(record.get('GROUP_YN') == 'N' && record.get('USE_YN') == 'N') {
								record.set('USE_YN', 'Y');
							}						
						});
					} else {
                        panelSearch.getEl().unmask();
						return false;
					}
					panelSearch.getEl().unmask();
				}
			}
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
	});	//end panelSearch  
	
	var lastYearCopySearch = Unilite.createSearchForm('lastYearCopySearchForm', {		// 전년도복사
		layout: {type: 'uniTable', columns : 1},
	    items: [
	    	{
				xtype: 'radiogroup',		            		
				fieldLabel: '작업선택',
				id: 'RDO_SELECT',
				items: [{
					boxLabel: '복사', 
					width: 50,
					name: 'RDO',
					inputValue: '1',
					checked: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							if(Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue == '1') {
								Ext.getCmp('DEPT_CODE_FR_ID').setReadOnly(false);
							} else {
								Ext.getCmp('DEPT_CODE_FR_ID').setReadOnly(true);
							}
						}
					}
				},{
					boxLabel: '삭제', 
					width: 70,
					name: 'RDO',
					inputValue: '2' 
				}]
			},
			Unilite.popup('DEPT', {
						fieldLabel: '원본부서', 
		        		allowBlank:false,
	           		 	id: 'DEPT_CODE_FR_ID',
						valueFieldName: 'DEPT_CODE_FR',
			    		textFieldName: 'DEPT_NAME_FR'
			}),
			Unilite.popup('DEPT', {
						fieldLabel: '대상부서', 
		        		allowBlank:false,
						valueFieldName: 'DEPT_CODE_TO',
			    		textFieldName: 'DEPT_NAME_TO'
			}),
			{
	            xtype: 'uniYearField',
	            name: 'AC_YYYY',
	            id: 'AC_YYYY_THIS_ID',
	            fieldLabel: '사업년도',
	            fieldStyle: 'text-align: center;',
	            allowBlank:false
            },{
            	xtype: 'container',
				tdAttrs: {align: 'center'},
            	items: [{
						xtype: 'button',
						text: '실행',	
						name: '',
						width: 70,					   	
						handler : function(records) {
							if(!UniAppManager.app.checkForNewDetail()) {
								return false;
							} else {
								if(Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue == '1') {
									var param = {
										"COMP_CODE"		: UserInfo.compCode,
										"AC_YYYY"		: lastYearCopySearch.getValue('AC_YYYY'),
										"DEPT_CODE_FR"	: lastYearCopySearch.getValue('DEPT_CODE_FR'),
										"DEPT_CODE_TO"	: lastYearCopySearch.getValue('DEPT_CODE_TO')
									};
									s_Afb410ukrService_KOCIS.insertDataCopy(param, function(provider, response)	{ 
										alert("완료 되었습니다.");
									});
									lastYearCopyWindow.hide();
								} else {
									var param = {
										"COMP_CODE"		: UserInfo.compCode,
										"AC_YYYY"		: lastYearCopySearch.getValue('AC_YYYY'),
										"DEPT_CODE_FR"	: lastYearCopySearch.getValue('DEPT_CODE_FR'),
										"DEPT_CODE_TO"	: lastYearCopySearch.getValue('DEPT_CODE_TO')
									};
									s_Afb410ukrService_KOCIS.deleteDataCopy(param, function(provider, response)	{ 
										alert("완료 되었습니다.");
									});
									lastYearCopyWindow.hide();
								}
							}
						}
					},{
						xtype: 'button',
						//margin: '0, 50, 0, 0',
						text: '닫기',
						width: 70,	
						handler: function() {
							lastYearCopyWindow.hide();
						}
					}
	         	]
	         }
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
  	}); // createSearchForm
  	
  	function openlastYearCopyWindow() {    	// 전년도복사
  		if(!lastYearCopyWindow) {
  			lastYearCopySearch.setValue('AC_YYYY', panelSearch.getValue('AC_YYYY'));
  			lastYearCopySearch.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE'));
  			lastYearCopySearch.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME'));
			lastYearCopyWindow = Ext.create('widget.uniDetailWindow', {
                title: '타부서 복사',
                width: 350,				                
                height: 177,
                layout:{type:'vbox', align:'stretch'},
                
                items: [lastYearCopySearch],
                listeners : {
                	beforehide: function(me, eOpt)	{
                		lastYearCopySearch.clearForm();
                	},
                	beforeclose: function(panel, eOpts) {
						lastYearCopySearch.clearForm();
                	},
                	beforeshow: function (me, eOpts)	{
			  			lastYearCopySearch.setValue('AC_YYYY', panelSearch.getValue('AC_YYYY'));
			  			lastYearCopySearch.setValue('DEPT_CODE_FR', panelSearch.getValue('DEPT_CODE'));
			  			lastYearCopySearch.setValue('DEPT_NAME_FR', panelSearch.getValue('DEPT_NAME'));
        			}
                }
			})
		}
		lastYearCopyWindow.show();
    }
	
	var masterGrid = Unilite.createTreeGrid('afb410ukrGrid', {
    	store: masterStore,
		uniOpt: {
			expandLastColumn	: true
		},
		columns:[
        	{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                text: '예산과목명',
                width:510,
                sortable: true,
                dataIndex: 'BUDG_NAME', 
                editable: false
	        },
        	{dataIndex: 'BUDG_CODE'				, width: 133},
        	{dataIndex: 'BUDG_NAME'				, width: 266},
//       	{dataIndex: 'GROUP_YN'				, width: 53, hidden: false},
//        	{dataIndex: 'CODE_LEVEL'			, width: 53, hidden: true},
//        	{dataIndex: 'TREE_LEVEL'			, width: 53, hidden: true},
//        	{dataIndex: 'ACCNT'					, width: 86,
//				editor: Unilite.popup('ACCNT_G',{
//		 				textFieldName: 'ACCNT_NAME',
// 	 					DBtextFieldName: 'ACCNT_NAME',
//				    	extParam: {'ADD_QUERY': "BUDG_YN = 'Y' AND GROUP_YN = 'N' AND SLIP_SW = 'Y'"},  
//			 			listeners: { 
//			 				'onSelected': {
//		                    	fn: function(records, type  ){
//		                    		var grdRecord;
//		                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
//									if(selectedRecords && selectedRecords.length > 0 ) {
//										grdRecord= selectedRecords[0];
//									}		                    	
//									grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
//									grdRecord.set('ACCNT_NAME',records[0]['ACCNT_NAME']);
//		                    	},
//		                    scope: this
//                  	   		},
//		                  	'onClear' : function(type)	{		                  		
//		                  		var grdRecord;
//		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
//								if(selectedRecords && selectedRecords.length > 0 ) {
//									grdRecord= selectedRecords[0];
//								}
//								grdRecord.set('ACCNT','');
//								grdRecord.set('ACCNT_NAME','');
//		                  	}
//						}
//				})   
//			},
//        	{dataIndex: 'ACCNT_NAME'				, width: 133,
//				editor: Unilite.popup('ACCNT_G',{
//		 				textFieldName: 'ACCNT_NAME',
// 	 					DBtextFieldName: 'ACCNT_NAME',
//				    	extParam: {'ADD_QUERY': "BUDG_YN = 'Y' AND GROUP_YN = 'N' AND SLIP_SW = 'Y'"},  
//			 			listeners: { 
//			 				'onSelected': {
//		                    	fn: function(records, type  ){
//		                    		var grdRecord;
//		                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
//									if(selectedRecords && selectedRecords.length > 0 ) {
//										grdRecord= selectedRecords[0];
//									}		                    	
//									grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
//									grdRecord.set('ACCNT_NAME',records[0]['ACCNT_NAME']);
//		                    	},
//		                    scope: this
//                  	   		},
//		                  	'onClear' : function(type)	{		                  		
//		                  		var grdRecord;
//		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
//								if(selectedRecords && selectedRecords.length > 0 ) {
//									grdRecord= selectedRecords[0];
//								}
//								grdRecord.set('ACCNT','');
//								grdRecord.set('ACCNT_NAME','');
//		                  	}
//						}
//				})   
//			},
//        	{dataIndex: 'PJT_CODE'				, width: 90,
//				editor: Unilite.popup('AC_PROJECT_G',{
//		 				textFieldName: 'AC_PROJECT_NAME',
// 	 					DBtextFieldName: 'AC_PROJECT_NAME',
//			 			listeners: { 
//			 				'onSelected': {
//		                    	fn: function(records, type  ){
//		                    		var grdRecord;
//		                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
//									if(selectedRecords && selectedRecords.length > 0 ) {
//										grdRecord= selectedRecords[0];
//									}		                    	
//									grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
//									grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
//		                    	},
//		                    scope: this
//                  	   		},
//		                  	'onClear' : function(type)	{		                  		
//		                  		var grdRecord;
//		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
//								if(selectedRecords && selectedRecords.length > 0 ) {
//									grdRecord= selectedRecords[0];
//								}
//								grdRecord.set('PJT_CODE','');
//								grdRecord.set('PJT_NAME','');
//		                  	}
//						}
//				})   
//			},
//        	{dataIndex: 'PJT_NAME'					, width: 150,
//				editor: Unilite.popup('AC_PROJECT_G',{
//		 				textFieldName: 'AC_PROJECT_NAME',
// 	 					DBtextFieldName: 'AC_PROJECT_NAME',
//			 			listeners: { 
//			 				'onSelected': {
//		                    	fn: function(records, type  ){
//		                    		var grdRecord;
//		                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
//									if(selectedRecords && selectedRecords.length > 0 ) {
//										grdRecord= selectedRecords[0];
//									}		                    	
//									grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
//									grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
//		                    	},
//		                    scope: this
//                  	   		},
//		                  	'onClear' : function(type)	{		                  		
//		                  		var grdRecord;
//		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
//								if(selectedRecords && selectedRecords.length > 0 ) {
//									grdRecord= selectedRecords[0];
//								}
//								grdRecord.set('PJT_CODE','');
//								grdRecord.set('PJT_NAME','');
//		                  	}
//						}
//				})   
//			},
        	{dataIndex: 'BUDG_TYPE'				, width: 120},
        	{dataIndex: 'USE_YN'				, width: 85}
//        	{dataIndex: 'COMP_CODE'				, width: 66, hidden: true},
//        	{dataIndex: 'AC_YYYY'				, width: 66, hidden: true},
//        	{dataIndex: 'DEPT_CODE'				, width: 66, hidden: true},
//        	{dataIndex: 'INSERT_DB_USER'		, width: 66, hidden: true},
//        	{dataIndex: 'INSERT_DB_TIME'		, width: 66, hidden: true},
//        	{dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true},
//        	{dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true}
        ],
		setNewData:function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('USE_YN'				,'Y');
		},
        listeners : {
        	beforeedit  : function( editor, e, eOpts, records ) {
//	        	if(e.record.get('GROUP_YN') == 'Y') {
//	        		if(UniUtils.indexOf(e.field)) {
//	        			return false;
//	        		}
//  				} else {
//  					if(UniUtils.indexOf(e.field, ['ACCNT', 'ACCNT_NAME', 'PJT_CODE', 'PJT_NAME', 'USE_YN'])) 
//					{ 
//						return true;
//      				} else {
//      					return false;
//      				}
//  				}
        		if(e.record.get('GROUP_YN') == 'N') {
        			if(UniUtils.indexOf(e.field, [/*'ACCNT', 'ACCNT_NAME', 'PJT_CODE', 'PJT_NAME',*/ 'USE_YN'])) { 
						return true;
      				} else {
      					return false;
      				}
        		} else {
        			if(UniUtils.indexOf(e.field, ['BUDG_CODE', 'BUDG_NAME', /*'ACCNT', 'ACCNT_NAME', 'PJT_CODE', 'PJT_NAME',*/ 'BUDG_TYPE', 'USE_YN'])) { 
						return false;
      				}
        		}
	        }
        }
    });
	
    Unilite.Main( {
		items : [panelSearch, 	masterGrid],
		id  : 'afb410ukrApp',
		fnInitBinding : function() {
            UniAppManager.app.fnInitInputFields();
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['newData'],false);			
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('afb410ukrGrid');
			masterStore.saveStore();				
		},
		onDeleteDataButtonDown : function()	{
			var record = masterGrid.getSelectionModel().getSelection();
			var params = {
				DEPT_CODE	: record[0].data.DEPT_CODE,	
				BUDG_CODE	: record[0].data.BUDG_CODE,
				BUDG_YYYYMM	: record[0].data.AC_YYYY
			}
			s_Afb410ukrService_KOCIS.selectAfb500tBeforeSave(params, 
				function(provider1, response) {
					s_Afb410ukrService_KOCIS.selectAfb510tBeforeSave(params, 
						function(provider2, response) {
							if(!Ext.isEmpty(provider1) || !Ext.isEmpty(provider2)) {	
								Ext.Msg.alert('확인',Msg.fSbMsgA0207);	
							} else {
								masterGrid.deleteSelectedRow();	
							}
						}
					)
				}
			)	
		},
	/*	onResetButtonDown: function() {
            panelSearch.clearForm();
			masterGrid.reset();
            masterStore.clearData();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
            UniAppManager.app.fnInitInputFields();
		},*/
		checkForNewDetail:function() { 			
			return lastYearCopySearch.setAllFieldsReadOnly(true);
        },
        fnInitInputFields: function(){
        	
        	
        	
        	
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
            }
            
            UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
            
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
