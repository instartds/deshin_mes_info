<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_Afb400ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장				 -->  
	<t:ExtComboStore comboType="AU" comboCode="A128" /> <!-- 예산과목구분 			 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 그룹 				 -->
	<t:ExtComboStore comboType="AU" comboCode="A129" /> <!-- 예산통제계산단위 		 -->
	<t:ExtComboStore comboType="AU" comboCode="A130" /> <!-- 예산통제기간단위 		 -->
	<t:ExtComboStore comboType="AU" comboCode="A131" /> <!-- 예산과실적집계대상단위목구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" /> <!-- 수지구분 				 -->
	<t:ExtComboStore comboType="AU" comboCode="A199" /> <!-- 예산과목 Mapping항목 	 -->
	
    <t:ExtComboStore comboType="AU" comboCode="A390" />         <!-- 회계구분 -->
</t:appConfig>

<script type="text/javascript" >

var lastYearCopyWindow; // 전년도자료복사 버튼

function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */

	Unilite.defineTreeModel('Afb400Model', {
		// pkGen : user, system(default)
		//idProperty: 'TREE_CODE',
	    fields: [
			{name: 'BUDG_CODE'			, text: '예산과목'			, type: 'string', allowBlank: false, isPk:true, pkGen:'user' },
			{name: 'BUDG_NAME'			, text: '예산과목명'		, type: 'string', allowBlank: false, maxLength: 100},
			{name: 'GROUP_YN'			, text: '그룹'			, type: 'string', comboType: 'AU', comboCode:'A020', allowBlank: false, maxLength: 1},
//			{name: 'ACCNT'				, text: '계정코드'			, type: 'string', maxLength: 16},
//			{name: 'ACCNT_NAME'			, text: '계정코드명'		, type: 'string', maxLength: 50},
			{name: 'CTL_CAL_UNIT'		, text: '통제계산'			, type: 'string' , comboType: 'AU', comboCode:'A129', maxLength: 1},
			{name: 'CTL_TERM_UNIT'		, text: '통제기간'			, type: 'string' , comboType: 'AU', comboCode:'A130', maxLength: 1},
//			{name: 'BUDGCTL_SUM_UNIT'	, text: '집계대상'			, type: 'string' , comboType: 'AU', comboCode:'A131', maxLength: 1},
//			{name: 'PJT_CODE'			, text: '프로젝트코드'		, type: 'string', maxLength: 20},
//			{name: 'PJT_NAME'			, text: '프로젝트명'		, type: 'string', maxLength: 40},
			{name: 'BUDG_TYPE'			, text: '수지구분'			, type: 'string', comboType: 'AU', comboCode:'A132', allowBlank: false, maxLength: 1},
//			{name: 'IF_CODE'			, text: '예산 Mapping항목'	, type: 'string', comboType: 'AU', comboCode:'A199', maxLength: 30},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'AC_YYYY'			, text: '사업년도'			, type: 'string'},
			{name: 'LEVEL_TOP'			, text: '코드레벨수'		, type: 'int'},
			{name: 'CODE_LEVEL'			, text: '예산과목레벨'		, type: 'string'},
			{name: 'TREE_LEVEL'			, text: '상위예산과목'		, type: 'string'},
			{name: 'LEVEL_LEN'			, text: '자릿수'			, type: 'int'},
			{name: 'LEVEL_NUM1'			, text: '자리1'			, type: 'string'},
			{name: 'LEVEL_NUM2'			, text: '자리2'			, type: 'string'},
			{name: 'LEVEL_NUM3'			, text: '자리3'			, type: 'string'},
			{name: 'LEVEL_NUM4'			, text: '자리4'			, type: 'string'},
			{name: 'LEVEL_NUM5'			, text: '자리5'			, type: 'string'},
			{name: 'LEVEL_NUM6'			, text: '자리6'			, type: 'string'},
			{name: 'LEVEL_NUM7'			, text: '자리7'			, type: 'string'},
			{name: 'LEVEL_NUM8'			, text: '자리8'			, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: '작성자'			, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '작성일'			, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'			, type: 'string'},
			{name: 'parentId' 			, text: '상위부서코드' 		, type: 'string'}	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
	    ]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	 var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 's_Afb400ukrService_KOCIS.selectList'
        	,update : 's_Afb400ukrService_KOCIS.updateMulti'
			,create : 's_Afb400ukrService_KOCIS.insertMulti'
			,destroy: 's_Afb400ukrService_KOCIS.deleteMulti'
			,syncAll: 's_Afb400ukrService_KOCIS.saveAll'
		}
	});
	var directMasterStore = Unilite.createTreeStore('afb400ukrMasterStore',{
			model: 'Afb400Model',
            autoLoad: false,
            folderSort: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            
            proxy: directProxy,
            listeners: {
            	'load' : function( store, records, successful, operation, node, eOpts ) {
            		if(records) {
            			var root = this.getRootNode();
            			if(root) {
            				root.expandChildren();
            				/*
            				Ext.each(root.children, function(node, index) {
            					node
            				});// EACH
            				*/
            			}
//            			node.cascadeBy(function(n){
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
            		
					var paramMaster= panelSearch.getValues();
					
					console.log("list:", list);
					if(inValidRecs.length == 0 )	{
						
						
						
						
						Ext.each(list, function(node, index) {
							var pid = node.get('parentId');
							if(Ext.isEmpty(pid)) {
								node.set('parentId', node.parentNode.get('BUDG_CODE'));
							}
							console.log("list:", node.get('parentId') + " / " + node.parentNode.get('BUDG_CODE'));
						});
						config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                            	
                            }
                        };
						
						
						this.syncAllDirect(config);
					}else {
						masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
					/*this.syncAll({success : function()	{
										me.commitChanges();
									}
								  }
								);
					*/
					//UniAppManager.setToolbarButtons('save', false);
				
			}
            
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
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
		            name: 'BUDG_TYPE',
		            comboType:'AU',
					comboCode:'A132',
		            allowBlank:false,
	            	value: '2',
		            fieldLabel: '수지구분'
		         },{
                    xtype: 'uniCombobox',
                    name: 'AC_GUBUN',
                    comboType:'AU',
                    comboCode:'A390',
                    allowBlank:false,
                    fieldLabel: '회계구분',
                    listeners: {
                        /*specialKey: function(elm, e){
                            if (e.getKey() == e.ENTER) {
                                UniAppManager.app.onQueryButtonDown();  
                            }
                        }*/
                    	
                        change: function(field, newValue, oldValue, eOpts) {
                            UniAppManager.app.onQueryButtonDown();  
                        }
                    }
                 }]
    		},{
				xtype: 'button',
				text: '전년도자료복사',	
				name: '',
				width: 100,	
				tdAttrs: {align: 'right'},				   	
				handler : function(records) {
					openlastYearCopyWindow();
				}
			},{
				xtype:'container',
				padding: '10 0 10 30',
				html: '<b>※ 집계대상이 자동(계정)인 경우는 계정과목을 중복으로 입력할 수 없습니다.&nbsp&nbsp중복 입력을 원하면, 기초등록-계정과목등록 메뉴에서 집계대상을 관리항목으로 변경하십시오.</b>',
				style: {
					color: 'blue'				
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
								Ext.getCmp('AC_YYYY_THIS_ID').setReadOnly(false);
							} else {
								Ext.getCmp('AC_YYYY_THIS_ID').setReadOnly(true);
							}
						}
					}
				},{
					boxLabel: '삭제', 
					width: 70,
					name: 'RDO',
					inputValue: '2' 
				}]
			},{
	            xtype: 'uniYearField',
	            name: 'AC_YYYY_THIS',
	            id: 'AC_YYYY_THIS_ID',
	            fieldLabel: '원본사업년도',
	            fieldStyle: 'text-align: center;',
	            allowBlank:false
	         },{
	            xtype: 'uniYearField',
	            name: 'AC_YYYY_NEXT',
	            fieldLabel: '대상사업년도',
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
							if(Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue == '1') {
								var param = {
									"COMP_CODE": UserInfo.compCode,
									"AC_YYYY_NEXT": lastYearCopySearch.getValue('AC_YYYY_NEXT')
								};
								s_Afb400ukrService_KOCIS.selectAfb400t(param, 
									function(provider1, response) {
										s_Afb400ukrService_KOCIS.selectAfb410t(param, 
											function(provider2, response)	{
												if(!Ext.isEmpty(provider1) || !Ext.isEmpty(provider2)) {
													if(confirm(Msg.fsbMsgA0194)) {
														var param = {
															"COMP_CODE": UserInfo.compCode,
															"AC_YYYY_NEXT": lastYearCopySearch.getValue('AC_YYYY_NEXT'),
															"AC_YYYY_THIS": lastYearCopySearch.getValue('AC_YYYY_THIS')
														};
														s_Afb400ukrService_KOCIS.insertDataCopy(param, function(provider, response)	{ 
															alert("완료 되었습니다.");
														});
														lastYearCopyWindow.hide();
													}
												} else {
													var param = {
														"COMP_CODE": UserInfo.compCode,
														"AC_YYYY_NEXT": lastYearCopySearch.getValue('AC_YYYY_NEXT'),
														"AC_YYYY_THIS": lastYearCopySearch.getValue('AC_YYYY_THIS')
													};
													s_Afb400ukrService_KOCIS.insertDataCopy(param, function(provider, response)	{ 
														alert("완료 되었습니다.");
													});
													lastYearCopyWindow.hide();
												}
											}
										)
									}
								)
							} else {
								var param = {
									"COMP_CODE": UserInfo.compCode,
									"AC_YYYY_NEXT": lastYearCopySearch.getValue('AC_YYYY_NEXT')
								};
								s_Afb400ukrService_KOCIS.selectAfb400t(param, 
									function(provider1, response) {
										s_Afb400ukrService_KOCIS.selectAfb410t(param, 
											function(provider2, response)	{
												if(!Ext.isEmpty(provider1) || !Ext.isEmpty(provider2)) {
													if(confirm(Msg.fsbMsgA0194)) {
														var param = {
															"COMP_CODE": UserInfo.compCode,
															"AC_YYYY_NEXT": lastYearCopySearch.getValue('AC_YYYY_NEXT'),
															"AC_YYYY_THIS": lastYearCopySearch.getValue('AC_YYYY_THIS')
														};
														s_Afb400ukrService_KOCIS.deleteDataCopy(param, function(provider, response)	{ 
															alert("완료 되었습니다.");
														});
														lastYearCopyWindow.hide();
													}
												} else {
													var param = {
														"COMP_CODE": UserInfo.compCode,
														"AC_YYYY_NEXT": lastYearCopySearch.getValue('AC_YYYY_NEXT'),
														"AC_YYYY_THIS": lastYearCopySearch.getValue('AC_YYYY_THIS')
													};
													s_Afb400ukrService_KOCIS.deleteDataCopy(param, function(provider, response)	{ 
														alert("완료 되었습니다.");
													});
													lastYearCopyWindow.hide();
												}
											}
										)
									}
								)
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
		]
  	}); // createSearchForm
  	
  	function openlastYearCopyWindow() {    	// 전년도복사
  		if(!lastYearCopyWindow) {
  			lastYearCopySearch.setValue('AC_YYYY_THIS', panelSearch.getValue('AC_YYYY'));
  			lastYearCopySearch.setValue('AC_YYYY_NEXT', UniDate.add(panelSearch.getValue('AC_YYYY'))+1);
			lastYearCopyWindow = Ext.create('widget.uniDetailWindow', {
                title: '전년도자료복사',
                width: 300,				                
                height: 150,
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
                		lastYearCopySearch.setValue('AC_YYYY_THIS', panelSearch.getValue('AC_YYYY'));
  						lastYearCopySearch.setValue('AC_YYYY_NEXT', UniDate.add(panelSearch.getValue('AC_YYYY'))+1);
        			}
                }
			})
		}
		lastYearCopyWindow.show();
    }
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    
    var masterGrid = Unilite.createTreeGrid('afb400ukrGrid', {
    	store: directMasterStore,
		columns:[
        	{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                text: '예산과목명',
                width:510,
                sortable: true,
                dataIndex: 'BUDG_NAME', editable: false 
	        },
        	{dataIndex: 'BUDG_CODE'					, width: 133},
        	{dataIndex: 'BUDG_NAME'					, width: 250},
        	{dataIndex: 'GROUP_YN'					, width: 53},
       /* 	{dataIndex: 'ACCNT'						, width: 66,
				editor: Unilite.popup('ACCNT_G',{
		 				textFieldName: 'ACCNT_NAME',
 	 					DBtextFieldName: 'ACCNT_NAME',
				    	extParam: {'ADD_QUERY': "BUDG_YN = 'Y' AND GROUP_YN = 'N' AND SLIP_SW = 'Y'"},  
			 			listeners: { 
			 				'onSelected': {
		                    	fn: function(records, type  ){
		                    		var grdRecord;
		                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
									if(selectedRecords && selectedRecords.length > 0 ) {
										grdRecord= selectedRecords[0];
									}		                    	
									grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
									grdRecord.set('ACCNT_NAME',records[0]['ACCNT_NAME']);
		                    	},
		                    scope: this
                  	   		},
		                  	'onClear' : function(type)	{		                  		
		                  		var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}
								grdRecord.set('ACCNT','');
								grdRecord.set('ACCNT_NAME','');
		                  	}
						}
				})   
			},
        	{dataIndex: 'ACCNT_NAME'				, width: 133,
				editor: Unilite.popup('ACCNT_G',{
		 				textFieldName: 'ACCNT_NAME',
 	 					DBtextFieldName: 'ACCNT_NAME',
				    	extParam: {'ADD_QUERY': "BUDG_YN = 'Y' AND GROUP_YN = 'N' AND SLIP_SW = 'Y'"},  
			 			listeners: { 
			 				'onSelected': {
		                    	fn: function(records, type  ){
		                    		var grdRecord;
		                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
									if(selectedRecords && selectedRecords.length > 0 ) {
										grdRecord= selectedRecords[0];
									}		                    	
									grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
									grdRecord.set('ACCNT_NAME',records[0]['ACCNT_NAME']);
		                    	},
		                    scope: this
                  	   		},
		                  	'onClear' : function(type)	{		                  		
		                  		var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}
								grdRecord.set('ACCNT','');
								grdRecord.set('ACCNT_NAME','');
		                  	}
						}
				})   
			},*/
        	{dataIndex: 'CTL_CAL_UNIT'				, width: 66,hidden:true},
        	{dataIndex: 'CTL_TERM_UNIT'				, width: 66,hidden:true},
//        	{dataIndex: 'BUDGCTL_SUM_UNIT'			, width: 66},
        	/*{dataIndex: 'PJT_CODE'					, width: 93,
				editor: Unilite.popup('AC_PROJECT_G',{
		 				textFieldName: 'AC_PROJECT_NAME',
 	 					DBtextFieldName: 'AC_PROJECT_NAME',
			 			listeners: { 
			 				'onSelected': {
		                    	fn: function(records, type  ){
		                    		var grdRecord;
		                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
									if(selectedRecords && selectedRecords.length > 0 ) {
										grdRecord= selectedRecords[0];
									}		                    	
									grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
									grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
		                    	},
		                    scope: this
                  	   		},
		                  	'onClear' : function(type)	{		                  		
		                  		var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}
								grdRecord.set('PJT_CODE','');
								grdRecord.set('PJT_NAME','');
		                  	}
						}
				})   
			},
        	{dataIndex: 'PJT_NAME'					, width: 150,
				editor: Unilite.popup('AC_PROJECT_G',{
		 				textFieldName: 'AC_PROJECT_NAME',
 	 					DBtextFieldName: 'AC_PROJECT_NAME',
			 			listeners: { 
			 				'onSelected': {
		                    	fn: function(records, type  ){
		                    		var grdRecord;
		                    		var selectedRecords = masterGrid.getSelectionModel().getSelection();
									if(selectedRecords && selectedRecords.length > 0 ) {
										grdRecord= selectedRecords[0];
									}		                    	
									grdRecord.set('PJT_CODE',records[0]['AC_PROJECT_CODE']);
									grdRecord.set('PJT_NAME',records[0]['AC_PROJECT_NAME']);
		                    	},
		                    scope: this
                  	   		},
		                  	'onClear' : function(type)	{		                  		
		                  		var grdRecord;
		                    	var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}
								grdRecord.set('PJT_CODE','');
								grdRecord.set('PJT_NAME','');
		                  	}
						}
				})   
			},*/
//			{dataIndex: 'TREE_LEVEL'				, width: 66, hidden: true},
//			{dataIndex: 'CODE_LEVEL'				, width: 66, hidden: true},
        	{dataIndex: 'BUDG_TYPE'					, width: 120}
//        	{dataIndex: 'IF_CODE'					, width: 120}
        	
        	/*,
        	{dataIndex: 'COMP_CODE'					, width: 66, hidden: true},
        	{dataIndex: 'AC_YYYY'					, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_TOP'					, width: 66, hidden: true},
        	{dataIndex: 'CODE_LEVEL'				, width: 66, hidden: true},
        	{dataIndex: 'TREE_LEVEL'				, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_LEN'					, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_NUM1'				, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_NUM2'				, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_NUM3'				, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_NUM4'				, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_NUM5'				, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_NUM6'				, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_NUM7'				, width: 66, hidden: true},
        	{dataIndex: 'LEVEL_NUM8'				, width: 66, hidden: true},
        	{dataIndex: 'INSERT_DB_USER'			, width: 66, hidden: true},
        	{dataIndex: 'INSERT_DB_TIME'			, width: 66, hidden: true},
        	{dataIndex: 'UPDATE_DB_USER'			, width: 66, hidden: true},
        	{dataIndex: 'UPDATE_DB_TIME'			, width: 66, hidden: true}*/
        ],
        listeners : {
        	beforeedit  : function( editor, e, eOpts, records ) {
	        	if(!e.record.phantom) {
	        		//var record = masterGrid.getSelectedRecord();
	        		if(e.record.get('GROUP_YN') == 'Y') {
		        		if(UniUtils.indexOf(e.field, ['BUDG_CODE', 'BUDG_NAME', 'GROUP_YN', 'BUDG_TYPE'])) 
						{ 
							return true;
	      				} else {
      						return false;
	      				}
      				} else {
      					if(UniUtils.indexOf(e.field)) 
						{ 
							return true;
	      				}
      				}
	        	} else {
	        		if(e.record.get('GROUP_YN') == 'Y') {
		        		if(UniUtils.indexOf(e.field, ['BUDG_CODE', 'BUDG_NAME', 'GROUP_YN', 'BUDG_TYPE'])) 
						{ 
							return true;
	      				} else {
      						return false;
	      				}
      				} else {
      					if(UniUtils.indexOf(e.field)) 
						{ 
							return true;
	      				}
      				}
	        	}
	        }
        }
    });                                                           	
                                                                  	
  	Unilite.Main({                                                 
		items : [panelSearch, 	masterGrid],
		id  : 'afb400ukrApp',
		fnInitBinding : function() {
			
			panelSearch.onLoadSelectText('AC_YYYY');
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['newData'],false);
			// root visible이 false 일경우 자동으로 load됨.
			//directMasterStore.loadStoreRecords();	
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();
			//UniAppManager.app.groupCheck();
			UniAppManager.setToolbarButtons(['newData'/*, 'reset'*/],true);			
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		onNewDataButtonDown : function()	{
	        var selectNode = masterGrid.getSelectionModel().getLastSelected();
	        var newRecord = masterGrid.createRow();
	        if(newRecord) {
	        	newRecord.set('parentId','');
//	        	newRecord.set('ACCNT','');
	        	newRecord.set('CODE_LEVEL',selectNode.get('CODE_LEVEL'));
	        	newRecord.set('LEVEL_TOP','');
	        	newRecord.set('LEVEL_LEN','');
	        	newRecord.set('LEVEL_NUM1','');
	        	newRecord.set('LEVEL_NUM2','');
	        	newRecord.set('LEVEL_NUM3','');
	        	newRecord.set('LEVEL_NUM4','');
	        	newRecord.set('LEVEL_NUM5','');
	        	newRecord.set('LEVEL_NUM6','');
	        	newRecord.set('LEVEL_NUM7','');
	        	newRecord.set('LEVEL_NUM8','');
	        	newRecord.set('GROUP_YN','Y');
	        	newRecord.set('TREE_LEVEL',selectNode.get('TREE_LEVEL'));
	        	newRecord.set('BUDG_TYPE',panelSearch.getValue('BUDG_TYPE'));
	        	newRecord.set('AC_YYYY', panelSearch.getValue('AC_YYYY'));
//	        	newRecord.set('IF_CODE', '');
	        	
	        }
		},
		
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('afb400ukrGrid');
			directMasterStore.saveStore();				
		},
		onDeleteDataButtonDown : function()	{
			var record = masterGrid.getSelectionModel().getSelection();
			var params = {
				AC_YYYY		: record[0].data.AC_YYYY,	
				BUDG_CODE	: record[0].data.BUDG_CODE
			}
			s_Afb400ukrService_KOCIS.selectAfb410tBeforeSave(params, 
				function(provider, response) {
					if(!Ext.isEmpty(provider)) {	
						Ext.Msg.alert('확인',Msg.fSbMsgA0200);	
					} else {
						masterGrid.deleteSelectedRow();	
					}
				}
			)	
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('afb400ukrGrid');
			Ext.getCmp('searchForm').getForm().reset();
			masterGrid.reset();
			directMasterStore.clearData();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
			this.fnInitBinding();
		}
		
		
		/*,
        groupCheck: function() {
    		UniAppManager.app.fngroupCheckColorInitTrue();
        	var record = masterGrid.getSelectionModel().getSelection();
        	if(record[0].data.GROUP_YN == 'N') {
        		UniAppManager.app.fngroupCheckColorInitFalse();
        	} else {
        		UniAppManager.app.fngroupCheckColorInitTrue();
        	}
        },
        fngroupCheckColorInitTrue: function() {
        	masterGrid.getField("ACCNT").setConfig('allowBlank',true);
			masterGrid.getField("ACCNT").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			masterGrid.getField("ACCNT_NAME").setConfig('allowBlank',true);
			masterGrid.getField("ACCNT_NAME").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			masterGrid.getField("CTL_CAL_UNIT").setConfig('allowBlank',true);
			masterGrid.getField("CTL_CAL_UNIT").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
			masterGrid.getField("CTL_TERM_UNIT").setConfig('allowBlank',true);
			masterGrid.getField("CTL_TERM_UNIT").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
		},
        fngroupCheckColorInitFalse: function() {
        	masterGrid.getField("ACCNT").setConfig('allowBlank',false);
			masterGrid.getField("ACCNT").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
			masterGrid.getField("ACCNT_NAME").setConfig('allowBlank',false);
			masterGrid.getField("ACCNT_NAME").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
			masterGrid.getField("CTL_CAL_UNIT").setConfig('allowBlank',false);
			masterGrid.getField("CTL_CAL_UNIT").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
			masterGrid.getField("CTL_TERM_UNIT").setConfig('allowBlank',false);
			masterGrid.getField("CTL_TERM_UNIT").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
		}*/
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "GROUP_YN" :			// 그룹
					if(newValue == 'Y') {
						//UniAppManager.app.groupCheck();
//						record.set('ACCNT', '');
//						record.set('ACCNT_NAME', '');
						record.set('CTL_CAL_UNIT', '');
						record.set('CTL_TERM_UNIT', '');
//						record.set('BUDGCTL_SUM_UNIT', '');
//						record.set('PJT_CODE', '');
//						record.set('PJT_NAME', '');
//						record.set('IF_CODE', '');
						break;
					}/* else {
						UniAppManager.app.groupCheck();
					}*/
				break;
			}
			return rv;
		}
	})
	
}; 


</script>
