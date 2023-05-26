<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mro010ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


function appMain() {   

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		
		api: {
			read: 'mro010ukrvService.selectDetailList',
			update: 'mro010ukrvService.updateDetail',
			create: 'mro010ukrvService.insertDetail',
			destroy: 'mro010ukrvService.deleteDetail',
			syncAll: 'mro010ukrvService.saveAll'
		}
	});
	
	/**
	 * main Model 정의 
	 * @type  
	 */
	Unilite.defineModel('mro010ukrvModel', {
	    fields: [  	 
			{name:'TREE_CODE'     		,text: '<t:message code="system.label.product.treecode" default="공구코드"/>'		,type:'string'	, allowBlank: false},
			{name:'TREE_NAME'      		,text: '<t:message code="system.label.product.treename" default="공구명"/>'			,type:'string'	, allowBlank: false},
			{name:'SPEC'       			,text: '<t:message code="system.label.product.spec" default="규격"/>'			,type:'string'		},
			{name:'BASE_P'				,text: '<t:message code="system.label.product.basisprice" default="기준단가"/>'		,type: 'uniUnitPrice'},
			{name: 'USE_YN'				,text:'<t:message code="system.label.product.useyn" default="사용여부"/>'		,type : 'string',	comboType: "AU", comboCode: "A004"},
			{name:'REMARK'     			,text: '<t:message code="system.label.product.remark" default="적요"/>'			,type:'string'}
		]            
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mro010ukrvMasterStore1',{
		model: 'mro010ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
			
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		

					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('mro010ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
//				 alert(Msg.sMB083);
			}
		}
	});
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
    	defaultType: 'uniSearchSubPanel',
    	listeners: {
        	collapse: function () {
            	panelResult.show();
        	},
        	expand: function() {
        		panelResult.hide();
        	}
    	},
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
		        fieldLabel: '<t:message code="system.label.product.treecode" default="공구코드"/>',
		        name: 'TREE_CODE',
				xtype: 'uniTextfield',  
				holdable: 'hold',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('TREE_CODE', newValue);
			     	}
			    }
				
			},{
		 		fieldLabel: '<t:message code="system.label.product.treename" default="공구명"/>',
		 		xtype: 'uniTextfield',
		 		name: 'TREE_NAME',
		        holdable: 'hold',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('TREE_NAME', newValue);
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
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 3},
	        items: [{ 
		        fieldLabel: '<t:message code="system.label.product.treecode" default="공구코드"/>',
		        name: 'TREE_CODE',
				xtype: 'uniTextfield',  
				holdable: 'hold',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('TREE_CODE', newValue);
			     	}
			    }
				
			},{
		 		fieldLabel: '<t:message code="system.label.product.treename" default="공구명"/>',
		 		xtype: 'uniTextfield',
		 		name: 'TREE_NAME',
		        holdable: 'hold',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('TREE_NAME', newValue);
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
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
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
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('mro010ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: directMasterStore1,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [        			
			{dataIndex: 'TREE_CODE'      	, width: 120}, 							 							
			{dataIndex: 'TREE_NAME'      	, width: 150}, 							 							
			{dataIndex: 'SPEC'      		, width: 150}, 							 							
			{dataIndex: 'BASE_P'      		, width: 90}, 							 							
			{dataIndex: 'USE_YN'      		, width: 90}, 							 							
			{dataIndex: 'REMARK'        	, width: 150}												
		],
        listeners: {
        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
					
			    });
			}
           ,beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom) 
				{
					if (UniUtils.indexOf(e.field,['TREE_CODE'])) {
						return false;
					}
				}
			},
        	selectionchange:function( model1, selected, eOpts ){
          	}
        },
       	returnCell: function(record){
        }
    });
    
    Unilite.Main( {
    	borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[panelResult,
					{
						region : 'west',
						xtype : 'container',
						layout : 'fit',
//						width : 1000, 
						flex : 200,
						items : [ masterGrid1 ]
					}
				]	
			}		
			,panelSearch 
		], 
		id: 'mro010ukrvApp',
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['newData'], true);
			this.onQueryButtonDown();
		},
		onQueryButtonDown : function()	{		
			directMasterStore1.loadStoreRecords();	
			UniAppManager.setToolbarButtons('reset',true);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();		
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();										
			UniAppManager.setToolbarButtons('save', false);	
			
			
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore1.loadData({});
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onNewDataButtonDown: function()	{
                 var TREE_CODE       =  '';
                 var TREE_NAME     	 =  '';
                 var SPEC     		 =  '';
                 var BASE_P      	 =   0;
                 var USE_YN          =  'Y';
                 var remark          =  '';
                 var r = {
                		 TREE_CODE       : TREE_CODE,
                		 TREE_NAME       : TREE_NAME,
                		 SPEC      		 : SPEC,
                		 BASE_P      	 : BASE_P,
                		 USE_YN       	 : USE_YN,
                   		 REMARK          : remark
                };
                masterGrid1.createRow(r, masterGrid1.getStore().getCount() - 1);
		},
        checkForNewDetail:function() { 
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onSaveDataButtonDown: function(config) {
			//총인원 체크
			var selected = masterGrid1.getSelectedRecord();
			if(directMasterStore1.isDirty()){
			 directMasterStore1.saveStore();
			}
		},
		rejectSave: function() {
			var rowIndex = masterGrid1.getSelectedRowIndex();
				masterGrid1.select(rowIndex);
				directMasterStore1.rejectChanges();
				
				if(rowIndex >= 0){
					masterGrid1.getSelectionModel().select(rowIndex);
					var selected = masterGrid1.getSelectedRecord();
				}
				directMasterStore1.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('mro010ukrvFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {
			
    		if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
        		masterGrid1.deleteSelectedRow();
    		}
			
			if(masterGrid1.getStore().getCount() >0){
    			UniAppManager.setToolbarButtons('save', true);
			}
		}
	});
	
	
};

</script>
