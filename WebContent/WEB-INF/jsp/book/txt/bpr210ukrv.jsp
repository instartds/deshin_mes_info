<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr210ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="bpr210ukrv" /> 			<!-- 사업장 -->
	
</t:appConfig>
<script type="text/javascript" >


/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

function appMain() {   
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr210ukrvService.selectList',
			update: 'bpr210ukrvService.updateDetail',
			create: 'bpr210ukrvService.insertDetail',
			destroy: 'bpr210ukrvService.deleteDetail',
			syncAll: 'bpr210ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Bpr210ukrvModel', {
	    fields: [  	 	
	    	{name: 'COMP_CODE'		,text: '법인코드'			,type: 'string'},  	 	
	    	{name: 'DIV_CODE'		,text: '사업장'			,type: 'string',comboType:'BOR120'},  	 	
	    	{name: 'DOC_GUBUN'		,text: '문헌구분코드'		,type: 'string'},  	 	
	    	{name: 'DOC_COL'		,text: '순번값'			,type: 'string'},  	 	
	    	{name: 'BIN_NUM'		,text: '진열대번호'			,type: 'string'},  	 	
	    	{name: 'DOC_NAME'		,text: '진열대명(국문)'		,type: 'string'},  	 	
	    	{name: 'DOC_NAME_EN'	,text: '진열대명(영문)'		,type: 'string'}
			
		]  
	});		//End of Unilite.defineModel('Bpr210ukrvModel', {
	

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('bpr210ukrvMasterStore1',{
		model: 'Bpr210ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
           	allDeletable: true,
	        useNavi: false				// prev | newxt 버튼 사용
		},
			autoLoad: false,
			
		proxy: directProxy,
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			
			var paramMaster= masterForm.getValues();
			
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster]
					};
				this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});		// End of var directMasterStore1 = Unilite.createStore('bpr210ukrvMasterStore1',{
	
	

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var masterForm = Unilite.createSearchPanel('searchForm', {		
		title: '진열대정보조건',
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
			items:[{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value: UserInfo.divCode,
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
					xtype: 'radiogroup',		            		
					fieldLabel: '구분',
					items: [{
						boxLabel: '서가', 
						width: 60, 
						name: 'GUBUN', 
						inputValue: 'DOC', 
						checked: true
					},{
						boxLabel: '진열대', 
						width :60, 
						name: 'GUBUN', 
						inputValue: 'FAN'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('GUBUN').setValue(newValue.GUBUN);
								directMasterStore1.loadStoreRecords();
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
    });		// End of var masterForm = Unilite.createSearchForm('searchForm',{    
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				value: UserInfo.divCode,
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{
					xtype: 'radiogroup',		            		
					fieldLabel: '구분',
					items: [{
						boxLabel: '서가', 
						width: 60, 
						name: 'GUBUN', 
						inputValue: 'DOC', 
						checked: true
					},{
						boxLabel: '진열대', 
						width :60, 
						name: 'GUBUN', 
						inputValue: 'FAN'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.getField('GUBUN').setValue(newValue.GUBUN);
								directMasterStore1.loadStoreRecords();
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
	
					   	alert(labelText+Msg.sMB083);
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid= Unilite.createGrid('bpr210ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },  
    	store: directMasterStore1,
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
        	{dataIndex:'COMP_CODE'			, width: 88 ,hidden: true},
        	{dataIndex:'DIV_CODE'			, width: 88, align:'center'},		
        	{dataIndex:'DOC_GUBUN'			, width: 88, align:'center'},	
        	{dataIndex:'DOC_COL'			, width: 88, align:'center'},	
        	{dataIndex:'BIN_NUM'			, width: 88, align:'center'},	
        	{dataIndex:'DOC_NAME'			, width: 200},	
        	{dataIndex:'DOC_NAME_EN'		, width: 300}
        	
        ],
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom == false){
					if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','BIN_NUM','DOC_GUBUN','DOC_COL'])){
						return false;
					}else{
						return true;
					}
				}else{
					
					if(UniUtils.indexOf(e.field, ['BIN_NUM'])){
						return false;
					}else{
						return true;
					}
					
				}
			}
		}
	
    });		// End of masterGrid= Unilite.createGrid('bpr210ukrvGrid', {

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			masterForm  	
		],	
		id: 'bpr210ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('newData', true);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				directMasterStore1.loadStoreRecords();	
				return panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				
				 var compCode = UserInfo.compCode; 
				 var divCode = masterForm.getValue('DIV_CODE')
		        
		     var r = {
		        COMP_CODE:		compCode,
		        DIV_CODE:		divCode
		     };
				masterGrid.createRow(r);
				masterForm.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			if(!directMasterStore1.isDirty())	{
				if(masterForm.isDirty())	{
					masterForm.saveForm();
				}
			}else {
				directMasterStore1.saveStore();
			}
			
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 
			return masterForm.setAllFieldsReadOnly(true);

		}      
		
		
	});		// End of Unilite.Main({
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "DOC_GUBUN" :
						record.set('BIN_NUM',newValue + record.get('DOC_COL'));
					break;
				case "DOC_COL" :
						record.set('BIN_NUM',record.get('DOC_GUBUN') + newValue);		
						
					break;
		
					
			}
				return rv;
						}
			});
};
</script>
