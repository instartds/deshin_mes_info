<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//운영자 공통코드 등록
request.setAttribute("PKGNAME","Unilite_app_cpa310ukrv");
%>
<t:appConfig pgmId="cpa310ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="YP11"/>	<!-- 조합원구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP15" />	<!-- 변동구분 	-->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
		
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'cpa310ukrvService.selectMaster',
				create 	: 'cpa310ukrvService.insertDetail',
				update 	: 'cpa310ukrvService.updateDetail',
				destroy	: 'cpa310ukrvService.deleteDetail',
				syncAll	: 'cpa310ukrvService.saveAll'
			}
		});
		
		var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'cpa310ukrvService.selectMaster2',
				create 	: 'cpa310ukrvService.insertDetail',
				update 	: 'cpa310ukrvService.updateDetail',
				destroy	: 'cpa310ukrvService.deleteDetail',
				syncAll	: 'cpa310ukrvService.saveAll'
			}
		});

		Unilite.defineModel('MasterModel', {
			fields : [ 	  
				{name : 'AMT_TYPE_NAME'			,		text : '출자금지급/배당금지급구분',		type : 'string'},
				{name : 'RETIRE_YN_NAME'		,		text : '재직 재학/퇴직 졸업 구분',		type : 'string'},
				{name : 'COOPTOR_TYPE'			,		text : '조합원 구분코드',				type : 'string'},
				{name : 'COOPTOR_TYPE_NAME'		,		text : '조합원 구분명',				type : 'string'},
				{name : 'COOPTOR_CNT'			,		text : '인원',					type : 'uniQty'},
				{name : 'ACCOUNT_CNT'			,		text : '구좌수',					type : 'uniQty'},
				{name : 'COOP_AMT'				,		text : '출자금',					type : 'uniPrice'},
				{name : 'INVEST_AMT'			,		text : '배당금',					type : 'uniPrice'}
				
			]
		});
		
		Unilite.defineModel('MasterModel2', {
			fields : [ 	  
				{name : 'COMP_CODE'				,		text : '법인코드',					type : 'string'},
				{name : 'COOP_YEAR'				,		text : '작업년도',					type : 'string'},
				{name : 'COOP_SEQ'				,		text : '년도차수',					type : 'uniDate'},
				{name : 'COOP_SEQ_NAME'			,		text : '년도차수',					type : 'string'},
				{name : 'COOPTOR_ID'			,		text : '조합원 아이디',				type : 'string'},
				{name : 'COOPTOR_NAME'			,		text : '조합원명',					type : 'string'},
				{name : 'COOPTOR_TYPE'			,		text : '조합원 구분코드',				type : 'string'},
				{name : 'RETIRE_YN'				,		text : '재직 재학/퇴직 졸업 구분',		type : 'string'},
				{name : 'COOPTOR_TYPE_NAME'		,		text : '조합원 구분명',				type : 'string'},
				{name : 'CONFIRM_DATE'			,		text : '확정일자',					type : 'uniDate'},
				{name : 'AMT_TYPE_NAME'			,		text : '출자금지급/배당금지급구분',		type : 'string'},
				{name : 'COOP_AMT'				,		text : '출자금',					type : 'uniPrice'},
				{name : 'INOUT_Q'				,		text : '출자구좌수',				type : 'uniQty'},
				{name : 'INVEST_ATM'			,		text : '배당금',					type : 'uniPrice'}
			]
		});
		
		var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore', { 
			model : 'MasterModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable:false,		// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxy,
            saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       			var paramMaster= panelSearch.getValues();	//syncAll 수정
            	config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			},
			loadStoreRecords : function()	{
				var param= panelSearch.getValues();			
				console.log(param);
				this.load({
					params : param
				});
			},
			_onStoreDataChanged: function( store, eOpts )	{
		    	if(this.uniOpt.isMaster) {
		       		console.log("_onStoreDataChanged store.count() : ", store.count());
		       		if(store.isDirty())	{
		       			UniApp.setToolbarButtons(['save', 'print'], true);
		       		}else {											//조회후 저장버튼 살리기위해 override
		       			UniApp.setToolbarButtons(['save'], false);
		       			UniApp.setToolbarButtons(['save', 'print'], true);
		       		}
		    	}
		    },
		    _onStoreLoad: function ( store, records, successful, eOpts ) {
		    	if(this.uniOpt.isMaster) {
			    	console.log("onStoreLoad");
			    	if (records) {
						var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
				    	UniAppManager.updateStatus(msg, true);	
			    	}
		    	}
		    },
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		Ext.each(records, function(record, i) {
						console.log('record',record);
						records[0].set('TEMP_DATE', UniDate.get('today'));
					});
	           	}
			},
			groupField: 'AMT_TYPE_NAME'
		});
		
		var directMasterStore2 = Unilite.createStore('${PKGNAME}MasterStore2', { 
			model : 'MasterModel2',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable:false,		// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxy2,
            saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       			var paramMaster= panelSearch.getValues();	//syncAll 수정
       			config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			},
			loadStoreRecords : function()	{
				var param= panelSearch.getValues();			
				console.log(param);
				this.load({
					params : param
				});
			},
			_onStoreDataChanged: function( store, eOpts )	{
		    	if(this.uniOpt.isMaster) {
		       		console.log("_onStoreDataChanged store.count() : ", store.count());
		       		if(store.isDirty())	{
		       			UniApp.setToolbarButtons(['save'], true);
		       		}else {											//조회후 저장버튼 살리기위해 override
		       			UniApp.setToolbarButtons(['save'], false);
		       		}
		    	}
		    },
		    _onStoreLoad: function ( store, records, successful, eOpts ) {
		    	if(this.uniOpt.isMaster) {
			    	console.log("onStoreLoad");
			    	if (records) {
						var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
				    	UniAppManager.updateStatus(msg, true);	
			    	}
		    	}
		    },
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		Ext.each(records, function(record, i) {
						console.log('record',record);
						records[0].set('TEMP_DATE', UniDate.get('today'));
					});
	           	}
			},
			groupField: 'AMT_TYPE_NAME'
		});
		
		// create the Grid
		var masterGrid = Unilite.createGrid('cpa310masterGrid', {
			enableColumnMove: false,
			store: directMasterStore, 	
	        layout : 'fit',
	        region:'center',
        	title: '현황',
			uniOpt: {
			 	expandLastColumn: false,
			 	useRowNumberer: false,
			 	useContextMenu: false
		    },
	    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
	    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
			columns : [   
				{dataIndex : 'AMT_TYPE_NAME'			,			width : 170,
	        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
	            	}
	            },
				{dataIndex : 'RETIRE_YN_NAME'			,			width : 160},
				{dataIndex : 'COOPTOR_TYPE'				,			width : 110},
				{dataIndex : 'COOPTOR_TYPE_NAME'		,			width : 95},
				{dataIndex : 'COOPTOR_CNT'				,			width : 90, summaryType: 'sum'},
				{dataIndex : 'ACCOUNT_CNT'				,			width : 90, summaryType: 'sum'},
				{dataIndex : 'COOP_AMT'					,			width : 110, summaryType: 'sum'},
				{dataIndex : 'INVEST_AMT'				,			width : 110, summaryType: 'sum'}		
			]			
		});
		
		var masterGrid2 = Unilite.createGrid('cpa310masterGrid2', {
			enableColumnMove: false,
			store: directMasterStore2, 	
	        layout : 'fit',
        	title: '상세',
	        region:'center',
			uniOpt: {
			 	expandLastColumn: false,
			 	useRowNumberer: false,
			 	useContextMenu: false
		    },
		    features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           		{id : 'masterGridTotal2', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
			columns : [   
				{dataIndex : 'COMP_CODE'				,			width : 80, hidden: true},
				{dataIndex : 'COOP_YEAR'				,			width : 80,
	        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '총계', '총계');
	            	}
	            },
				{dataIndex : 'COOP_SEQ'					,			width : 80, hidden: true},
				{dataIndex : 'COOP_SEQ_NAME'			,			width : 80},
				{dataIndex : 'COOPTOR_ID'				,			width : 100},
				{dataIndex : 'COOPTOR_NAME'				,			width : 80},
				{dataIndex : 'COOPTOR_TYPE'				,			width : 80, hidden: true},
				{dataIndex : 'RETIRE_YN'				,			width : 80, hidden: true},
				{dataIndex : 'COOPTOR_TYPE_NAME'		,			width : 100},
				{dataIndex : 'CONFIRM_DATE'				,			width : 80},
				{dataIndex : 'AMT_TYPE_NAME'			,			width : 170},
				{dataIndex : 'COOP_AMT'					,			width : 110, summaryType: 'sum'},
				{dataIndex : 'INOUT_Q'					,			width : 80, summaryType: 'sum'},
				{dataIndex : 'INVEST_ATM'				,			width : 110, summaryType: 'sum'}	
			]			
		});
		
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
		items:[{
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{
				fieldLabel: '배당년도',
				width: 170,
				name: 'COOP_YYYY',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
				//holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOP_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '차수',
				name: 'COOP_SEQ' ,
				xtype: 'uniCombobox' ,
	    		//holdable: 'hold',
				comboType: 'AU',
				comboCode: 'YP32',
				value: '1',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOP_SEQ', newValue);
					}
				}
			},{	
				fieldLabel: '확정일자',
				xtype: 'uniDatefield',
				name: 'CONFIRM_DATE',
				value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CONFIRM_DATE', newValue);
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '배당년도',
				width: 170,
				name: 'COOP_YYYY',
				xtype: 'uniYearField',
				value: new Date().getFullYear(),
				//holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COOP_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '차수',
				name: 'COOP_SEQ' ,
				xtype: 'uniCombobox' ,
	    		//holdable: 'hold',
				comboType: 'AU',
				comboCode: 'YP32',
				value: '1',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COOP_SEQ', newValue);
					}
				}
			},{	
				fieldLabel: '확정일자',
				xtype: 'uniDatefield',
				name: 'CONFIRM_DATE',
				value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CONFIRM_DATE', newValue);
					}
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
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid,
	         masterGrid2
	    ]
    });
		
    Unilite.Main({
			borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					tab, panelResult
				]
			},
				panelSearch  	
			]
			, fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'save' ,'print'],false);
			}
			, onQueryButtonDown:function(record) {
				UniAppManager.setToolbarButtons(['reset', 'save','print'],true);
				if(panelSearch.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
				var activeTabId = tab.getActiveTab().getId();
				if(activeTabId == 'cpa310masterGrid'){				
					directMasterStore.loadStoreRecords();
				}
				else if(activeTabId == 'cpa310masterGrid2'){
					directMasterStore2.loadStoreRecords();
				} 						
				UniAppManager.setToolbarButtons('save', true);	
			}
			, onSaveDataButtonDown: function () {	
				var activeTabId = tab.getActiveTab().getId();
				var param = {
					"COOP_YYYY":		panelSearch.getValue('COOP_YYYY'),
					"COOP_SEQ":			panelSearch.getValue('COOP_SEQ')
				}
				if(activeTabId == 'cpa310masterGrid') {	// 작업지시별 등록
					cpa310ukrvService.selectMaster3(param, function(provider, response)	{
						if(Ext.isEmpty(provider)) {
							if(Ext.isEmpty(panelSearch.getValue('CONFIRM_DATE'))) {
								alert("확정일자는 필수 입력값 입니다.");
							} else {
								directMasterStore.saveStore();
							}
						} else {
							alert('이미 확정된 자료 입니다.');
						}
					});
				}
				if(activeTabId == 'cpa310masterGrid2') {	// 작업지시별 등록
					cpa310ukrvService.selectMaster3(param, function(provider, response)	{
						if(Ext.isEmpty(provider)) {
							if(Ext.isEmpty(panelSearch.getValue('CONFIRM_DATE'))) {
								alert("확정일자는 필수 입력값 입니다.");
							} else {
								directMasterStore2.saveStore();
							}
						} else {
							alert('이미 확정된 자료 입니다.');
						}
					});
				}
			}
			, rejectSave: function()	{
				directMasterStore.rejectChanges();
			} 	
			, confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
            }
			, onResetButtonDown: function() {
				panelSearch.reset();
				panelResult.reset();
				panelSearch.setAllFieldsReadOnly(false);
				panelResult.setAllFieldsReadOnly(false);
				masterGrid.reset();
				masterGrid2.reset();
				this.fnInitBinding();
				directMasterStore.clearData();
				directMasterStore2.clearData();
			},
			
			onPrintButtonDown: function() {
		         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
		         var param= Ext.getCmp('searchForm').getValues();
		
		         var win = Ext.create('widget.PDFPrintWindow', {
		            url: CPATH+'/cpa/cpa310rkrPrint.do',
		            prgID: 'cpa310rkr',
		               extParam: {
		                  COOP_YYYY 	: param.COOP_YYYY,
		                  COOP_SEQ  	: param.COOP_SEQ,
		                  CONFIRM_DATE  : param.CONFIRM_DATE
		               }
		            });
		            win.center();
		            win.show();
		               
		      }
		});
};
</script>