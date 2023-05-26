<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc125ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A096" /> <!-- 자본변동표구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var BsaCodeInfo = {	
	gsGubunA093: '${gsGubunA093}'
};

function appMain() {
	var providerSTDT ='';
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'agc125ukrService.selectList',
			update: 'agc125ukrService.updateDetail',
			create: 'agc125ukrService.insertDetail',
			destroy: 'agc125ukrService.deleteDetail',
			syncAll: 'agc125ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Agc125ukrModel', {
	    fields: [
			{name: 'AC_STDATE'	 		      ,text: '전표기간FR' 				,type: 'string'},
			{name: 'AC_TODATE'	 		      ,text: '전표기간TO' 				,type: 'string'},
			{name: 'CHG_DIVI'	 		      ,text: '자본변동표구분' 			,type: 'string'},
			{name: 'SEQ'		 		      ,text: 'SEQ' 					,type: 'int'},
			{name: 'ACCNT_CD'			      ,text: '코드' 					,type: 'string'},
			{name: 'ACCNT_NAME'			      ,text: '구분' 					,type: 'string'},
			{name: 'AMT_I1'				      ,text: '자본금' 				,type: 'uniPrice'},
			{name: 'AMT_I2'				      ,text: '자본잉여금' 				,type: 'uniPrice'},
			{name: 'AMT_I3'				      ,text: '자본조정' 				,type: 'uniPrice'},
			{name: 'AMT_I4'				      ,text: '기타포괄손익' 			,type: 'uniPrice'},
			{name: 'AMT_I5'				      ,text: '이익잉여금' 				,type: 'uniPrice'},
			{name: 'AMT_I6'				      ,text: '총계' 					,type: 'uniPrice'},
			{name: 'OPT_DIVI'				  ,text: 'OPT_DIVI' 			,type: 'string'},
			{name: 'KIND_DIVI'				  ,text: 'KIND_DIVI' 			,type: 'string'},
			{name: 'UPPER_ACCNT_CD'		      ,text: 'UPPER_ACCNT_CD' 		,type: 'string'},
			{name: 'UPDATE_DB_USER'		      ,text: 'UPDATE_DB_USER' 		,type: 'string'},
			{name: 'UPDATE_DB_TIME'		      ,text: 'UPDATE_DB_TIME' 		,type: 'string'},
			{name: 'COMP_CODE'	   		      ,text: 'COMP_CODE' 			,type: 'string'},
			{name: 'SAVE_FLAG'   	  		  ,text: 'SAVE_FLAG' 			,type: 'string'},
			{name: 'SAVE_FLAG2'   	  		  ,text: 'SAVE_FLAG2' 			,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agc125ukrMasterStore',{
		model: 'Agc125ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
				var recordsFirst = directMasterStore.data.items[0];	
				var isNew = false;
				if(!Ext.isEmpty(recordsFirst)){
					if(recordsFirst.data.SAVE_FLAG == 'N'){
						isNew = true;
						masterGrid.reset();
						directMasterStore.clearData();
						
						Ext.each(records, function(record,i){	
			        		UniAppManager.app.onNewDataButtonDown();
			        		masterGrid.setNewDataGUBUNTABLE(record.data);								        
				    	}); 
				    	setTimeout(function(){
				    		UniAppManager.setToolbarButtons('save',true);
				    	},50)
//				    	UniAppManager.setToolbarButtons('save',true);
					}
					
					if(!isNew && directMasterStore.getTotalCount() > 0)
						UniAppManager.setToolbarButtons(['deleteAll'],true);
				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
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
		    items : [{ 
    			fieldLabel: '전표기간',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'AC_STDATE',
		        endFieldName: 'AC_TODATE',
		        width: 315,
		        holdable:'hold',
		        allowBlank: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('AC_STDATE',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('AC_TODATE',newValue);
			    	}
			    }
	        },{
    			fieldLabel: '자본변동표구분',
    			name:'CHG_DIVI', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A096',
    			holdable:'hold',
    			allowBlank:false,
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CHG_DIVI', newValue);
					}
				}
    		},{
				xtype: 'button',
				text: '재참조',
				width: 150,
				margin: '20 0 0 100',
				handler:function()	{
					masterGrid.reset();
					directMasterStore.clearData();
					var param = {"AC_STDATE": UniDate.getDbDateStr(panelSearch.getValue('AC_STDATE')),
						"AC_TODATE": UniDate.getDbDateStr(panelSearch.getValue('AC_TODATE')),
						"CHG_DIVI": panelSearch.getValue('CHG_DIVI'),
						"THIS_ST_DATE": panelSearch.getValue('THIS_ST_DATE'),
						"GUBUN": panelSearch.getValue('GUBUN')
					};
					agc125ukrService.reReference(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							Ext.each(provider, function(record,i){
								UniAppManager.app.onNewDataButtonDown();
				        		masterGrid.setNewDataGUBUNTABLE(record);	
							});
						}
					});
				}
			}]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{ 
    			fieldLabel: '당기시작년월',
    			name:'THIS_ST_DATE',
				xtype: 'uniMonthfield',
//				value: UniDate.get('today'),
				holdable:'hold',
				allowBlank:false,
				width: 200
			},{
    			fieldLabel: '재무제표</br>양식차수',
    			name:'GUBUN', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A093',
    			holdable:'hold',
    			allowBlank:false
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
	});   
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '전표기간',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_STDATE',
	        endFieldName: 'AC_TODATE',
	        width: 315,
	        holdable:'hold',
	        allowBlank: false,
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('AC_STDATE',newValue);
					UniAppManager.app.fnSetStDate(newValue);
					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('AC_TODATE',newValue);
		    	}
		    }
        },{
			fieldLabel: '자본변동표구분',
			name:'CHG_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A096',
			labelWidth:150,
			holdable:'hold',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CHG_DIVI', newValue);
				}
			}
		},{
			xtype: 'button',
			text: '재참조',
			width: 100,
			margin: '0 0 0 120',
			handler:function()	{
				masterGrid.reset();
				directMasterStore.clearData();
				var param = {"AC_STDATE": UniDate.getDbDateStr(panelResult.getValue('AC_STDATE')),
					"AC_TODATE": UniDate.getDbDateStr(panelResult.getValue('AC_TODATE')),
					"CHG_DIVI": panelResult.getValue('CHG_DIVI'),
					"THIS_ST_DATE": panelSearch.getValue('THIS_ST_DATE'),
					"GUBUN": panelSearch.getValue('GUBUN')
				};
				agc125ukrService.reReference(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						Ext.each(provider, function(record,i){
							UniAppManager.app.onNewDataButtonDown();
			        		masterGrid.setNewDataGUBUNTABLE(record);	
						});
					}
				});
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
    });		
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agc125ukrGrid', {
        layout : 'fit',
        region:'center',
        excelTitle: '자본변동표등록',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			enterKeyCreateRow : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
			{ dataIndex: 'AC_STDATE'	 		 			 , 	width: 50, hidden: true},
			{ dataIndex: 'AC_TODATE'	 		 			 , 	width: 50, hidden: true},
			{ dataIndex: 'CHG_DIVI'	 		 			     , 	width: 50, hidden: true},
			{ dataIndex: 'SEQ'		 		 			     , 	width: 50, hidden: true},
			{ dataIndex: 'ACCNT_CD'			 			     , 	width: 66},
			{ dataIndex: 'ACCNT_NAME'			 			 , 	width: 166},
			{ dataIndex: 'AMT_I1'				 			 , 	width: 120},
			{ dataIndex: 'AMT_I2'				 			 , 	width: 120},
			{ dataIndex: 'AMT_I3'				 			 , 	width: 120},
			{ dataIndex: 'AMT_I4'				 			 , 	width: 120},
			{ dataIndex: 'AMT_I5'				 			 , 	width: 120},
			{ dataIndex: 'AMT_I6'				 			 , 	width: 200},
			{ dataIndex: 'OPT_DIVI'			 			     , 	width: 50, hidden: true},
			{ dataIndex: 'KIND_DIVI'			 			 , 	width: 50, hidden: true},
			{ dataIndex: 'UPPER_ACCNT_CD'	 			 	 , 	width: 50, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	 			  	 , 	width: 50, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'	 			 	 , 	width: 50, hidden: true},
			{ dataIndex: 'COMP_CODE'	   	 			 	 , 	width: 50, hidden: true},
			{ dataIndex: 'SAVE_FLAG'   	   					 , 	width: 66, hidden: true},
			{ dataIndex: 'SAVE_FLAG2'   	   				 , 	width: 66, hidden: true}
        ],
        listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.data.OPT_DIVI == '3' || e.record.data.OPT_DIVI == '5'){
					return false;
				}else{
					if(e.record.data.KIND_DIVI == '10'){
						if (UniUtils.indexOf(e.field,['AMT_I1'])){	
							return true;
						}else{
							return false;
						}
					}else if(e.record.data.KIND_DIVI == '20'){
						if (UniUtils.indexOf(e.field,['AMT_I2'])){	
							return true;
						}else{
							return false;
						}
					}else if(e.record.data.KIND_DIVI == '30'){
						if (UniUtils.indexOf(e.field,['AMT_I3'])){	
							return true;
						}else{
							return false;
						}
					}else if(e.record.data.KIND_DIVI == '40'){
						if (UniUtils.indexOf(e.field,['AMT_I4'])){	
							return true;
						}else{
							return false;
						}
					}else if(e.record.data.KIND_DIVI == '50'){
						if (UniUtils.indexOf(e.field,['AMT_I5'])){	
							return true;
						}else{
							return false;
						}
					}else{
						if (UniUtils.indexOf(e.field,['AMT_I1','AMT_I2','AMT_I3','AMT_I4','AMT_I5'])){	
							return true;
						}else{
							return false;
						}
					}
				}
			}
		},
		setNewDataGUBUNTABLE:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('AC_STDATE'	 			,record['AC_STDATE']);
			grdRecord.set('AC_TODATE'	 			,record['AC_TODATE']);
			grdRecord.set('CHG_DIVI'	 			,record['CHG_DIVI']);
			grdRecord.set('SEQ'		 				,record['SEQ']);
			grdRecord.set('ACCNT_CD'				,record['ACCNT_CD']);
			grdRecord.set('ACCNT_NAME'				,record['ACCNT_NAME']);
			grdRecord.set('AMT_I1'					,record['AMT_I1']);
			grdRecord.set('AMT_I2'					,record['AMT_I2']);
			grdRecord.set('AMT_I3'					,record['AMT_I3']);
			grdRecord.set('AMT_I4'					,record['AMT_I4']);
			grdRecord.set('AMT_I5'					,record['AMT_I5']);
			grdRecord.set('AMT_I6'					,record['AMT_I6']);
			grdRecord.set('OPT_DIVI'				,record['OPT_DIVI']);
			grdRecord.set('KIND_DIVI'				,record['KIND_DIVI']);
			grdRecord.set('UPPER_ACCNT_CD'			,record['UPPER_ACCNT_CD']);
			grdRecord.set('COMP_CODE'	 			,record['COMP_CODE']);
			
		}
    });   

    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'agc125ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('deleteAll',false);
			var param = {COMP_CODE: UserInfo.compCode}
			accntCommonService.fnGetStDt(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('AC_STDATE',provider[0].STDT);
					panelResult.setValue('AC_STDATE',provider[0].STDT);
					panelSearch.setValue('THIS_ST_DATE',provider[0].STDT);
					
					providerSTDT = provider[0].STDT;
				}
			})
			panelSearch.setValue('AC_TODATE',UniDate.get('today'));
			panelResult.setValue('AC_TODATE',UniDate.get('today'));
			panelSearch.setValue('CHG_DIVI','1');
			panelResult.setValue('CHG_DIVI','1');
			panelSearch.setValue('GUBUN',BsaCodeInfo.gsGubunA093);
		},
		onQueryButtonDown : function()	{			
			if(!this.checkForForm()) {
				return false;
			}else{
				directMasterStore.loadStoreRecords();	
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForForm()) return false;
        	
            var r = {
	        };
			masterGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							//UniAppManager.app.onSaveDataButtonDown();	
							UniAppManager.setToolbarButtons('deleteAll',false);
							
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
		checkForForm:function() { 
			return panelSearch.setAllFieldsReadOnly(true);
//				   panelResult.setAllFieldsReadOnly(true);
        },
        fnSetStDate:function(newValue) {
        	if(newValue == null){
				return false;
			}else{
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(providerSTDT).substring(4, 6))){
					panelSearch.setValue('THIS_ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(providerSTDT).substring(4, 6));
				}else{
					panelSearch.setValue('THIS_ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(providerSTDT).substring(4, 6));
				}
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
				case fieldName : 
					var records = directMasterStore.data.items;	
					Ext.each(records, function(record,i){	
						record.set('SAVE_FLAG2','N');
					})
				
				
					
			}
				return rv;
		}
	});	
};


</script>
