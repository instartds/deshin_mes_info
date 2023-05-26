<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bpr101rkrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="bpr101rkrv"  /> 			<!-- 사업장 -->
</t:appConfig>

<script type="text/javascript" >
var settingWindow;
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */	    			
	Unilite.defineModel('bpr101rkrvModel1', {
	    fields: [
	    	{name: 'PRINT_P_YN'	    ,text: '단가출력'			,type: 'boolean', defaultValue: true},
	    	{name: 'PRINT_P_YN_TEMP',text: '단가출력(값전달용)'	,type: 'boolean'},
	    	{name: 'ITEM_CODE'	    ,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'			,type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'	    ,text: '<t:message code="system.label.base.itemname" default="품목명"/>'			,type: 'string', allowBlank: false},
	    	{name: 'SALE_BASIS_P'	,text: '단가'				,type: 'string', defaultValue: '0'},
	    	{name: 'PRINT_Q'		,text: '출력수량'			,type: 'uniQty', allowBlank: false, defaultValue: 1}
		]
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bpr101rkrvMasterStore1',{
		model: 'bpr101rkrvModel1',
		uniOpt: {
        	isMaster: false,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable: true,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			UniApp.setToolbarButtons(['delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			UniApp.setToolbarButtons(['delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], true);
	    		}
       		}	    	
	    },
    
    /**
     * 
     * @param {} options
     * @return {}
     */
	    listeners: {
	    	datachanged: function(store){
	    		store.commitChanges();
	    	},
	    	update: function(store){
	    		store.commitChanges();
	    	}
	    }
	});
	var panelPrint = Unilite.createForm('printForm', {
		url: CPATH+'/base/printBarcode',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,  
		items:[{
			xtype: 'uniTextfield',
			name: 'data',
			hidden: true
		},{			
        	xtype: 'button',
			id: 'printBtn',
			width: 90,
			text: '바코드 출력',						   	
			handler : function() {
				if(directMasterStore.getCount() == 0) return false;
				var inValidRecs = directMasterStore.getInvalidRecords();
				if(inValidRecs.length == 0){
					var form = this.up('uniDetailForm');
					var data = new Array();
					Ext.each(directMasterStore.data.items, function(record, index){
						data.push({'PRINT_P_YN': record.get('PRINT_P_YN'),                  
								   'ITEM_CODE': record.get('ITEM_CODE'),                    
								   'ITEM_NAME': record.get('ITEM_NAME'),                      
								   'SALE_BASIS_P': record.get('SALE_BASIS_P'),
								   'PRINT_Q': record.get('PRINT_Q')})                       
					});
					//var jJsonData = JSON.stringify(data);
							
					form.setValue('data',Ext.encode(data)); // Ext.encode(jJsonData));
					
					form.submit();					
					setTimeout(function(){
							directMasterStore.commitChanges();
							Ext.Msg.show({
							    title:'바코드 출력',
							    message: '파일 다운로드가 완료되면 확인버튼을 클릭하세요',
							    buttons: Ext.Msg.OKCANCEL,
							    icon: Ext.Msg.QUESTION,
							    fn: function(btn) {
							        if (btn === 'ok') {
							            try{
											var WshShell = new ActiveXObject("WScript.Shell");
											WshShell.Run("C:\\OmegaPlusLabel\\Label.exe", 1);
										} catch(e) {
											Unilite.messageBox('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
										}
							        } else if (btn === 'cancel') {
							            Unilite.messageBox('바코드 출력이 취소되었습니다.');
							        } else {
							            console.log('Cancel pressed');
							        } 
							    }
							});
							/*
							if(confirm('파일 다운로드가 완료되면 확인버튼을 클릭하세요.'))	{
								try{
									var WshShell = new ActiveXObject("WScript.Shell");
									WshShell.Run("C:\\Windows\\System32\\notepad.exe", 1);
		//							WshShell.Run("C:\\OmegaPlusLabel\\Label.exe", 1);
								} catch(e) {
									Unilite.messageBox('바코드 버튼을 재실행하세요.')
								}
							}*/
							
						}
						, 2000						
					)
				}else{
					masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
				}				
			}
		}]
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
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
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{	
        		xtype: 'container',
        		layout: {type: 'uniTable', columns:2},
        		items: [{
					xtype: 'uniNumberfield',
					fieldLabel: '출력수량',
					width: 180,
					name: 'PRINT_Q',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {					
							panelResult.setValue('PRINT_Q', newValue);
						}
					}
				},{
		        	margin: '0 0 0 6',
					xtype: 'button',
					id: 'editBtn',
					width: 90,
					text: '수량 일괄수정',
		//	        	tdAttrs:{'align':'center'},							   	
					handler : function() {
						var printQ = panelSearch.getValue('PRINT_Q');
						if(Ext.isEmpty(printQ)) return false;
						var records = directMasterStore.data.items;
						Ext.each(records, function(record,i) {
							record.set('PRINT_Q', printQ);		
						});
					}
				},{
					fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>', 
					name: 'DIV_CODE', 
					xtype: 'uniCombobox', 
					comboType: 'BOR120', 
					allowBlank: false,
					holdable:'hold',
					value: UserInfo.divCode,
					colspan:2,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},panelPrint
				]
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
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})  
   				}
	  		} else {
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			xtype: 'uniNumberfield',
			fieldLabel: '출력수량',
			width: 180,
			name: 'PRINT_Q',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('PRINT_Q', newValue);
				}			}
		},{
        	margin: '0 0 0 6',
			xtype: 'button',
			id: 'editBtn2',
			width: 90,
			text: '수량 일괄수정',
//	        	tdAttrs:{'align':'center'},							   	
			handler : function() {
				var printQ = panelSearch.getValue('PRINT_Q');
				if(Ext.isEmpty(printQ)) return false;
				var records = directMasterStore.data.items;
				Ext.each(records, function(record,i) {
					record.set('PRINT_Q', printQ);		
				});
			}
		},{
			fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			holdable:'hold',
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},panelPrint/*,{
        	margin: '0 0 0 110',
        	xtype: 'button',
			id: 'printBtn2',
			width: 90,
			text: '바코드 출력',							   	
			handler : function() {
				var inValidRecs = directMasterStore.getInvalidRecords();
				if(inValidRecs.length == 0) {
					directMasterStore.print();
				}else{
					masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		}*/],
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
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})  
   				}
	  		} else {
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bpr101rkrvGrid1', {
    	layout: 'fit',
    	flex: 1,
    	title: '일반 바코드 출력',
		uniOpt: {
		 	expandLastColumn: false,
		 	useRowNumberer: false,
		 	useContextMenu: true
        }, 
    	store: directMasterStore,
        columns:  [        
               		{dataIndex: 'ITEM_CODE'         	,		 width: 140,
						editor: Unilite.popup('ITEM_G', {		
					 	 				textFieldName: 'ITEM_CODE',
					 	 				DBtextFieldName: 'ITEM_CODE',
					 	 				extParam: {SELMODEL: 'MULTI'},
			  							autoPopup: true,
						 				listeners: {'onSelected': {
						 								fn: function(records, type) {				 										
						 										Ext.each(records, function(record,i) {				 															
						 															if(i==0) {
						 																masterGrid1.setItemData(record,false, masterGrid1.uniOpt.currentRecord);
						 															} else {
						 																UniAppManager.app.onNewDataButtonDown();
						 																masterGrid1.setItemData(record,false, masterGrid1.getSelectedRecord());
						 															}
						 										}); 
						 								},
						 								scope: this
						 							},
						 							'onClear': function(type) {
						 								masterGrid1.setItemData(null,true, masterGrid1.uniOpt.currentRecord);
						 							}
						 				}
							 })
					},
					{dataIndex: 'ITEM_NAME'         	,		 width: 190,
						editor: Unilite.popup('ITEM_G', {
					 		  				extParam: {SELMODEL: 'MULTI'},
			  								autoPopup: true,
											listeners: {'onSelected': {
						 								fn: function(records, type) {				 										
						 										Ext.each(records, function(record,i) {				 															
						 															if(i==0) {
						 																masterGrid1.setItemData(record,false, masterGrid1.uniOpt.currentRecord);
						 															} else {
						 																UniAppManager.app.onNewDataButtonDown();
						 																masterGrid1.setItemData(record,false, masterGrid1.getSelectedRecord());
						 															}
						 										}); 
						 								},
						 								scope: this
						 							},
						 							'onClear': function(type) {
						 								masterGrid1.setItemData(null,true, masterGrid1.uniOpt.currentRecord);
						 							}
						 				}
							})
					}, 	
					{ dataIndex: 'SALE_BASIS_P'					,		   	width: 120, align: 'right'},
					{ dataIndex: 'PRINT_P_YN'					,		   	width: 70,  xtype : 'checkcolumn', align: 'center'},
					{ dataIndex: 'PRINT_Q'						,		   	width: 100}
					
        ],
		setItemData: function(record, dataClear, grdRecord) {
//	   		var grdRecord = this.uniOpt.currentRecord;
	   		if(dataClear) {
	   			grdRecord.set('ITEM_CODE'		,"");
	   			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SALE_BASIS_P'	,0);
	   		} else {	   			
	   			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
	   			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SALE_BASIS_P'	, Ext.util.Format.number(record['SALE_BASIS_P'],'0,000' )); 
	   		}
		}, 
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {
      			if (UniUtils.indexOf(e.field, 'SALE_BASIS_P')){
      				return false;
  				}
			}
		}
    }); 
    
    var masterGrid2 = Unilite.createGrid('bpr101rkrvGrid2', {
    	layout: 'fit',
    	flex: 1,
    	title: '임의 바코드 출력',
		uniOpt: {
		 	expandLastColumn: false,
		 	useRowNumberer: false,
		 	useContextMenu: true
        }, 
    	store: directMasterStore,
        columns:  [        
               		{dataIndex: 'ITEM_CODE'         			,		 width: 140},
					{dataIndex: 'ITEM_NAME'         			,		 width: 190}, 	
					{ dataIndex: 'SALE_BASIS_P'					,		   	width: 120, align: 'right'},
					{ dataIndex: 'PRINT_P_YN'					,		   	width: 70,  xtype : 'checkcolumn', align: 'center'},
					{ dataIndex: 'PRINT_Q'						,		   	width: 100}
					
        ]
    }); 
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'west',
	    items: [
	         masterGrid1,
	         masterGrid2
	    ]
    });
    
    var describedPanel = Unilite.createSearchForm('bpr101rkrvDescribedPanel',{
    	region: 'center',
    	padding: '1 1 1 1',
		layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
		defaults:{labelWidth: 100, margin:'5 0 0 20', width: 600},
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			margin:'15 0 0 20',
			xtype:'container',
			html: '<b>◆ 확인사항</b>',
			style: {
				color: 'blue'				
			}},{
				xtype:'container',
				margin: '10 0 10 20',
				html: '&nbsp;&nbsp;&nbsp;<b>바코드 라벨출력을 위해서는 다음과 같은 설정을 해야 합니다.</b>'	
			},{
				xtype:'container',
				layout: {type: 'uniTable', columns: 2},
				items:[{					
					xtype:'container',
					html: '&nbsp;&nbsp;&nbsp;1. Internet Explorer 보안설정 하기.'
				},{
		        	margin: '0 0 0 6',
					xtype: 'button',
					width: 90,
					text: '보안설정 방법',						   	
					handler : function() {
						openSettingWindow();
					}
				}]				
			},{
				xtype:'container',
				layout: {type: 'uniTable', columns: 2},
				items:[{					
					xtype:'container',
					html: '&nbsp;&nbsp;&nbsp;2.&nbsp;라벨출력프로그램을 C:\omegapluslabel 폴더에 압축을 푼다.'
				},{
		        	margin: '0 0 0 6',
					xtype: 'button',
					text: '출력 프로그램 다운로드',						   	
					handler : function() {
						
					}
				}]				
			},{
				xtype:'container',
				margin: '10 0 0 20',
				html: '&nbsp;&nbsp;&nbsp;3.&nbsp;위 사항이 준비되었으면 [바코드 출력] 버튼을 클릭하여 출력한다.'
			}]	
    });
    
	function openSettingWindow() {
	if(!settingWindow) {
		settingWindow = Ext.create('widget.uniDetailWindow', {
            title: '바코드 출력전 보안 설정',
            resizable:false,
            width: 1200,				                
            height:1000,
            autoScroll: true,
            layout: {type:'uniTable', columns: 1},	                
            items: [{ 
            	xtype: 'image',
            	src:CPATH+'/resources/images/barcodeSetting1.png',
            	overflow:'auto'
            }, { 
            	xtype: 'image',
            	src:CPATH+'/resources/images/barcodeSetting2.png',
            	overflow:'auto'
            }],
            tbar:  ['->',{
					itemId : 'closeBtn',
					text: '닫기',
					handler: function() {
						settingWindow.hide();
					},
					disabled: false
				}
			]})
		}
		settingWindow.show();
	}
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult, describedPanel
			]
		},
			panelSearch  	
		],
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('query', false);
			this.processParams(params);
		},
		onNewDataButtonDown : function(additemCode)	{
			if(!this.checkForNewDetail()) return false;
			if(additemCode){
				 var r = {
					SALE_BASIS_P: Ext.util.Format.number(additemCode.SALE_BASIS_P,'0,000' ),
					ITEM_CODE: additemCode.ITEM_CODE,
					ITEM_NAME: additemCode.ITEM_NAME				
		        };	        
				
			}
			masterGrid1.createRow(r);
			panelResult.setAllFieldsReadOnly(true);
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid1.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid1.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid1.deleteSelectedRow();				
			}
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		processParams: function(params) {	
			if(params && params.ITEM_CODE) {
				UniAppManager.app.onNewDataButtonDown(params);
			}
		},
		checkForNewDetail:function() { 
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});

};


</script>
