<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep010ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="J520" />					<!-- 마감일자관리(10:OPEN, 20:CLOSE)-->
	<t:ExtComboStore items="${getSliipType}" storeId="getSliipType" />	<!-- 법인코드-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {     

	//마감현황
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'aep010ukrService.insertList',				
			read	: 'aep010ukrService.selectList',
			update	: 'aep010ukrService.updateList',
			destroy	: 'aep010ukrService.deleteList',
			syncAll	: 'aep010ukrService.saveAll'
		}
	});
	
	//부서별 마감현황
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'aep010ukrService.insertList1',				
			read	: 'aep010ukrService.selectList1',
			update	: 'aep010ukrService.updateList1',
			destroy	: 'aep010ukrService.deleteList1',
			syncAll	: 'aep010ukrService.saveAll1'
		}
	});
	
	//전표유형별 마감현황
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'aep010ukrService.insertList2',				
			read	: 'aep010ukrService.selectList2',
			update	: 'aep010ukrService.updateList2',
			destroy	: 'aep010ukrService.deleteList2',
			syncAll	: 'aep010ukrService.saveAll2'
		}
	});

	
	
	/** Model 정의 
	 * @type 
	 */
	//마감현황
	Unilite.defineModel('Aep010ukrModel', {
	   fields: [
			{name: 'COMP_CD'				, text: '회사구분'				, type: 'string' },
			{name: 'CLOS_YYMM'				, text: '마감년월'				, type: 'string' },
			{name: 'CLOS_STAT_CD'			, text: '마감상태'				, type: 'string'		, allowBlank: false		, comboType:'AU'	, comboCode:'J520'},
			{name: 'CHG_ID'					, text: '변경자'				, type: 'string' },
			{name: 'CHG_DT'					, text: '변경일시'				, type: 'string'}
	    ]
	});
	
	//부서별 마감현황
	Unilite.defineModel('Aep010ukrModel1', {
	   fields: [
			{name: 'COMP_CD'				, text: '회사구분'				, type: 'string' },
			{name: 'CCTR_CD'				, text: '비용부서코드'			, type: 'string' },
			{name: 'CCTR_NM'				, text: '비용부서'				, type: 'string'		, allowBlank: false},
			{name: 'CLOS_YYMM'				, text: '마감년월'				, type: 'string' },
			{name: 'CLOS_STAT_CD'			, text: '마감상태'				, type: 'string'		, allowBlank: false		, comboType:'AU'	, comboCode:'J520'},
			{name: 'CHG_ID'					, text: '변경자'				, type: 'string' },
			{name: 'CHG_DT'					, text: '변경일시'				, type: 'string'}
	    ]
	});
	
	//전표유형별 마감현황
	Unilite.defineModel('Aep010ukrModel2', {
	   fields: [
			{name: 'COMP_CD'				, text: '회사구분'				, type: 'string' },
			{name: 'CCTR_CD'				, text: '비용부서코드'			, type: 'string' },
			{name: 'CCTR_NM'				, text: '비용부서'				, type: 'string' },
//			{name: 'ELEC_SLIP_TYPE_CD'		, text: '전표유형코드'			, type: 'string' },
			{name: 'ELEC_SLIP_TYPE_CD'		, text: '전표유형'				, type: 'string'		, allowBlank: false		, store: Ext.data.StoreManager.lookup('getSliipType')},
			{name: 'CLOS_YYMM'				, text: '마감년월'				, type: 'string' },
			{name: 'CLOS_STAT_CD'			, text: '마감상태'				, type: 'string'		, allowBlank: false		, comboType:'AU'	, comboCode:'J520'},
			{name: 'CHG_ID'					, text: '변경자'				, type: 'string' },
			{name: 'CHG_DT'					, text: '변경일시'				, type: 'string'}
	    ]
	});

	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	//마감현황
	var masterStore = Unilite.createStore('aep010ukrMasterStore',{
		model	: 'Aep010ukrModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();				
			var toDelete = this.getRemovedRecords();

			if(inValidRecs.length == 0 )	{
					config = {
//					params: [paramMaster],
					success: function(batch, option) {
						masterStore.loadStoreRecords();
					} 
				};
				this.syncAllDirect(config);				
			} else {    				
				closingSetGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}				
		},
		
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save', true);    	
	    }, // onStoreUpdate

	    _onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save', false);
	    	}	    	
	    },
	    
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':false}});
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':true}});
       			}
       		}
       		
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save'], true);
       		}else {
       			this.setToolbarButtons(['sub_save'], false);
       		}	    	
    	},
    	
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = closingSetGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}		
	});
	
	//부서별 마감현황
	var masterStore1 = Unilite.createStore('aep010ukrMasterStore1',{
		model	: 'Aep010ukrModel1',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy1,
		loadStoreRecords : function(record)	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					config = {
//					params: [paramMaster],
					success: function(batch, option) {
						masterStore1.loadStoreRecords();
					} 
				};
				this.syncAllDirect(config);				
			} else {    				
				Dept_ClosingSetGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}				
		},
		
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save1', true);    	
	    }, // onStoreUpdate

	    _onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save1', false);
	    	}	    	
	    },
	    
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete1'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete1':false}});
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete1'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete1':true}});
       			}
       		}
       		
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save1'], true);
       		}else {
       			this.setToolbarButtons(['sub_save1'], false);
       		}	    	
    	},
    	
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = Dept_ClosingSetGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}
	});
	
	//전표유형별 마감현황
	var masterStore2 = Unilite.createStore('aep010ukrMasterStore2',{
		model	: 'Aep010ukrModel2',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: directProxy2,
		
		loadStoreRecords : function(record)	{
			var param= Ext.getCmp('searchForm').getValues();
			var upperRecord = Dept_ClosingSetGrid.getSelectedRecord();
			param.CCTR_CD   = upperRecord.get('CCTR_CD');
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					config = {
//					params: [paramMaster],
					success: function(batch, option) {
						masterStore2.loadStoreRecords();
					} 
				};
				this.syncAllDirect(config);				
			} else {    				
				SlipKind_ClosingSetGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
			}				
		},
		
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save2', true);    	
	    }, // onStoreUpdate

	    _onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save2', false);
	    	}	    	
	    },
	    
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete2'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete2':false}});
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete2'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete2':true}});
       			}
       		}
       		
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save2'], true);
       		}else {
       			this.setToolbarButtons(['sub_save2'], false);
       		}	    	
    	},
    	
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = SlipKind_ClosingSetGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}	
	});
	
	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand	: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title		: '기본정보', 	
	   		itemId		: 'search_panel1',
	        layout		: {type: 'uniTable', columns: 1},
	        defaultType	: 'uniTextfield',
			items		: [{ 
    			fieldLabel	: '마감년월',
		        name		: 'CLOS_YYMM',
		        xtype		: 'uniMonthfield',	
    			value		: UniDate.get('today'),
		        allowBlank	: false,
				listeners	: {
					change	: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CLOS_YYMM', newValue);
					}
				}
	        },{
				fieldLabel	: ' ',
				name		: '',
				xtype		: 'uniCheckboxgroup', 
				width		: 400, 
				items		: [{
		        	boxLabel		: '증빙일 통제',
		        	name			: 'PROOF_DAY_CONTROL',
					width			: 150,
					uncheckedValue	: 'N',
		        	inputValue		: 'Y',
	        		listeners: {
						change	: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PROOF_DAY_CONTROL', newValue);
						}
	        		}
		        }]
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
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel	: '마감년월',
	        name		: 'CLOS_YYMM',
	        xtype		: 'uniMonthfield',	
    		value		: UniDate.get('today'),
	        allowBlank	: false,
			listeners	: {
				change	: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CLOS_YYMM', newValue);
				}
			}
        },{
			fieldLabel	: ' ',
			name		: '',
			xtype		: 'uniCheckboxgroup', 
			width		: 400, 
			items		: [{
	        	boxLabel		: '증빙일 통제',
	        	name			: 'PROOF_DAY_CONTROL',
				width			: 150,
				uncheckedValue	: 'N',
	        	inputValue		: 'Y',
	    		listeners: {
					change	: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PROOF_DAY_CONTROL', newValue);
					}
	    		}
	        }]
		}]
	});

	

    /** Grid 정의(Grid Panel)
     * @type 
     */
	//마감현황
    var closingSetGrid = Unilite.createGrid('aep010Grid1', {
		title	: '마감현황',
		store	: masterStore,
    	layout	: 'fit',
        region	: 'center',
    	uniOpt	: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: true,	
		    useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
		
    	dockedItems	: [{    		
	        xtype	: 'toolbar',
	        dock	: 'top',
	        items	: [{
                xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData',
				handler	: function() { 
	            	var r = {
	            	 	COMP_CD		: UserInfo.compCode,
						CLOS_YYMM	: UniDate.getDbDateStr(panelSearch.getValue('CLOS_YYMM')).substring(0, 6),
						CHG_ID		: UserInfo.personNumb
			        };
					closingSetGrid.createRow(r);
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
		 		itemId	: 'sub_delete',
				handler	: function() { 
					var selRow = closingSetGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						closingSetGrid.deleteSelectedRow();
						
					} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						closingSetGrid.deleteSelectedRow();						
					}	
				}				
			},{
                xtype	: 'uniBaseButton',
				text	: '저장', 
				tooltip	: '저장', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_save',
				handler : function() {
					var inValidRecs = masterStore.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  		masterStore.saveStore();
						});
						saveTask.delay(500);
					} else {
						closingSetGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}]
	    }],
	    
        columns: [    
			{dataIndex: 'COMP_CD'				, width: 140}, 				
			{dataIndex: 'CLOS_YYMM'				, width: 120		, align: 'center'}, 				
			{dataIndex: 'CLOS_STAT_CD'			, width: 120}, 				
			{dataIndex: 'CHG_ID'				, width: 140}, 				
			{dataIndex: 'CHG_DT'				, width: 180		, align: 'center'}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['CLOS_STAT_CD'])) {	
					return true;
					
				} else {
					return false;
				}	
			},

			select: function(grid, record, index, rowIndex, eOpts ){
				if (record.phantom == false) {
        			masterStore1.loadStoreRecords(record);
//        			masterStore2.loadStoreRecords(record);
				}
          	},

          	deselect:  function(grid, record, index, rowIndex, eOpts ){
    		}
		}
    });    
    
	//부서별 마감현황
    var Dept_ClosingSetGrid = Unilite.createGrid('aep010Grid2', {
		title	: '부서별 마감현황',
		store	: masterStore1,
    	layout	: 'fit',
        region	: 'center',
    	uniOpt	: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: true,	
		    useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
		
    	dockedItems	: [{    		
	        xtype	: 'toolbar',
	        dock	: 'top',
	        items	: [{
                xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData1',
				handler	: function() { 
					var upperRecord = closingSetGrid.getSelectedRecord();
					if (upperRecord) {
		            	var r = {
		            	 	COMP_CD		: UserInfo.compCode,
							CLOS_YYMM	: upperRecord.get('CLOS_YYMM'),
							CHG_ID		: UserInfo.personNumb,
							CLOS_STAT_CD: upperRecord.get('CLOS_STAT_CD')
				        };
						Dept_ClosingSetGrid.createRow(r);
						
						
					} else {
						return false;
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
		 		itemId	: 'sub_delete1',
				handler	: function() { 
					var selRow = Dept_ClosingSetGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						Dept_ClosingSetGrid.deleteSelectedRow();
						
					} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						Dept_ClosingSetGrid.deleteSelectedRow();						
					}	
				}				
			},{
                xtype	: 'uniBaseButton',
				text	: '저장', 
				tooltip	: '저장', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_save1',
				handler : function() {
					var inValidRecs = masterStore1.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  		masterStore1.saveStore();
						});
						saveTask.delay(500);
					} else {
						Dept_ClosingSetGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}]
	    }],
	    
        columns: [    
			{dataIndex: 'COMP_CD'				, width: 140}, 				
			{dataIndex: 'CCTR_CD'				, width: 140		, hidden: true}, 				
			{dataIndex: 'CCTR_NM'				, width: 180,
				editor: Unilite.popup('DEPT_G', {
 	 				DBtextFieldName: 'TREE_NAME',
						listeners: {
							'onSelected': {
								fn: function(records, type) {
									var rtnRecord = Dept_ClosingSetGrid.uniOpt.currentRecord;	
									rtnRecord.set('CCTR_CD', records[0]['TREE_CODE']);
									rtnRecord.set('CCTR_NM', records[0]['TREE_NAME']);
								},
								scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = Dept_ClosingSetGrid.uniOpt.currentRecord;	
									rtnRecord.set('CCTR_CD', '');
									rtnRecord.set('CCTR_NM', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			}, 				
			{dataIndex: 'CLOS_YYMM'				, width: 120		, align: 'center'}, 				
			{dataIndex: 'CLOS_STAT_CD'			, width: 120}, 				
			{dataIndex: 'CHG_ID'				, width: 140}, 				
			{dataIndex: 'CHG_DT'				, width: 180		, align: 'center'}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
        		if(e.record.phantom){ 
					if (UniUtils.indexOf(e.field, ['CCTR_NM', 'CLOS_STAT_CD'])) {	
						return true;
						
					} else {
						return false;
					}	
        		} else {
					if (UniUtils.indexOf(e.field, ['CLOS_STAT_CD'])) {	
						return true;
						
					} else {
						return false;
					}	
        		}
			},

			select: function(grid, record, index, rowIndex, eOpts ){
				if (record.phantom == false) {
        			masterStore2.loadStoreRecords(record);
				}
          	},

          	deselect:  function(grid, record, index, rowIndex, eOpts ){
    		}
		}
    });  
    
	//전표유형별 마감현황
    var SlipKind_ClosingSetGrid = Unilite.createGrid('aep010Grid3', {
		title	: '전표유형별 마감현황',
		store	: masterStore2,
    	layout	: 'fit',
        region	: 'center',
    	uniOpt	: {				
			useMultipleSorting	: true,		
		    useLiveSearch		: false,	
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: true,	
		    useGroupSummary		: true,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: true,		
			useRowContext		: false,	
		    filter: {			
				useFilter		: false,	
				autoCreate		: true	
			}			
		},
		
    	dockedItems	: [{    		
	        xtype	: 'toolbar',
	        dock	: 'top',
	        items	: [{
                xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData2',
				handler	: function() { 
					var upperRecord = Dept_ClosingSetGrid.getSelectedRecord();
					if (upperRecord) {
		            	var r = {
		            	 	COMP_CD		: UserInfo.compCode,
							CCTR_CD		: upperRecord.get('CCTR_CD'),
							CCTR_NM		: upperRecord.get('CCTR_NM'),
							CLOS_YYMM	: upperRecord.get('CLOS_YYMM'),
							CHG_ID		: UserInfo.personNumb,
							CLOS_STAT_CD: upperRecord.get('CLOS_STAT_CD')
				        };
						SlipKind_ClosingSetGrid.createRow(r);
						
						
					} else {
						return false;
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
		 		itemId	: 'sub_delete2',
				handler	: function() { 
					var selRow = SlipKind_ClosingSetGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						SlipKind_ClosingSetGrid.deleteSelectedRow();
						
					} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						SlipKind_ClosingSetGrid.deleteSelectedRow();						
					}	
				}				
			},{
                xtype	: 'uniBaseButton',
				text	: '저장', 
				tooltip	: '저장', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_save2',
				handler : function() {
					var inValidRecs = masterStore2.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  		masterStore2.saveStore();
						});
						saveTask.delay(500);
					} else {
						SlipKind_ClosingSetGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}]
	    }],
	    
        columns: [    
			{dataIndex: 'COMP_CD'				, width: 140}, 				
			{dataIndex: 'CCTR_CD'				, width: 140		, hidden: true}, 				
			{dataIndex: 'CCTR_NM'				, width: 180}, 				
			{dataIndex: 'ELEC_SLIP_TYPE_CD'		, width: 120}, 				
			{dataIndex: 'CLOS_YYMM'				, width: 120		, align: 'center'}, 				
			{dataIndex: 'CLOS_STAT_CD'			, width: 120}, 				
			{dataIndex: 'CHG_ID'				, width: 140}, 				
			{dataIndex: 'CHG_DT'				, width: 180		, align: 'center'}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
        		if(e.record.phantom){ 
					if (UniUtils.indexOf(e.field, ['ELEC_SLIP_TYPE_CD', 'CLOS_STAT_CD'])) {	
						return true;
						
					} else {
						return false;
					}	
        		} else {
					if (UniUtils.indexOf(e.field, ['CLOS_STAT_CD'])) {	
						return true;
						
					} else {
						return false;
					}	
        		}
			},

			select: function(grid, record, index, rowIndex, eOpts ){
          	},

          	deselect:  function(grid, record, index, rowIndex, eOpts ){
    		}
		}
    });     
    
    
    
	Unilite.Main( {
		id				: 'aep010ukrApp',
		borderItems		: [{
			region		: 'center',
            layout		: {type:'vbox', align:'stretch'},
			border		: false,
            autoScroll	: true,
			items		: [
				panelResult
				,{
	                region		: 'north',
	                xtype		: 'container',
	                layout		: {type:'vbox', align:'stretch'},
	        		minHeight	: 200,
	                flex		: 4,
	                items		: [
	                    closingSetGrid
	                ]
	            },{
	                region		: 'center',
	                xtype		: 'container',
	                layout		: {type:'vbox', align:'stretch'},
	        		minHeight	: 200,
	                flex		: 8,
	                items		: [
	                    Dept_ClosingSetGrid
	                ]
	            },{
	                region		: 'south',
	                xtype		: 'container',
	                layout		: {type:'vbox', align:'stretch'},
	                minHeight	: 200,
	                flex		: 8,
	                items		: [
	                    SlipKind_ClosingSetGrid
	                ]
	            }
			]
		},
			panelSearch  	
		], 
		
		fnInitBinding : function() {
			panelSearch.setValue('CLOS_YYMM'	, UniDate.get('today'));
			panelResult.setValue('CLOS_YYMM'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset', 'save'], false);
			
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('CLOS_YYMM');		
		},
		
		onQueryButtonDown : function()	{	
			if(!this.isValidSearchForm()){
				return false;
			}
			closingSetGrid.getStore().loadData({});
			Dept_ClosingSetGrid.getStore().loadData({});
			SlipKind_ClosingSetGrid.getStore().loadData({});
			masterStore.clearData();
			masterStore1.clearData();
			masterStore2.clearData();
			masterStore.loadStoreRecords();

			UniAppManager.setToolbarButtons('reset',true);
		},
		
		onResetButtonDown: function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			closingSetGrid.getStore().loadData({});
			Dept_ClosingSetGrid.getStore().loadData({});
			SlipKind_ClosingSetGrid.getStore().loadData({});
			masterStore.clearData();
			masterStore1.clearData();
			masterStore2.clearData();
			
			this.fnInitBinding();
		}
	});
};
</script>
