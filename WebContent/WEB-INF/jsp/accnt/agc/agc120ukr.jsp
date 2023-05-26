<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc120ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A076" /> <!-- 이익처분구분 -->      
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
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'agc120ukrService.selectList',
			update	: 'agc120ukrService.updateDetail',
			create	: 'agc120ukrService.insertDetail',
			destroy	: 'agc120ukrService.deleteDetail',
			syncAll	: 'agc120ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Agc120ukrModel', {
	    fields: [
	    	{name: 'AC_YYYYMM'		      ,text: '당기시작년월' 			,type: 'string',allowBlank:false},
    		{name: 'PROFIT_DIVI'	      ,text: '이익처분구분' 			,type: 'string',allowBlank:false},
    		{name: 'DEAL_DATE'	          ,text: '처분확정일' 				,type: 'uniDate'},
    		{name: 'EX_DATE'		      ,text: '결의전표일자' 			,type: 'uniDate'},
    		{name: 'EX_NUM'			  	  ,text: '결의전표번호' 			,type: 'string'},
    		{name: 'AGREE_YN'		      ,text: '승인여부' 				,type: 'string'},
    		{name: 'UPPER_ACCNT_CD'       ,text: '상위코드' 				,type: 'string'},
    		{name: 'OPT_DIVI'		      ,text: '집계구분' 				,type: 'string'},
    		{name: 'DIS_DIVI'		      ,text: '출력구분' 				,type: 'string'},
    		{name: 'CAL_DIVI'		      ,text: '계산구분' 				,type: 'string'},
    		{name: 'UPDATE_DB_USER'       ,text: 'UPDATE_DB_USER' 		,type: 'string'},
    		{name: 'UPDATE_DB_TIME'       ,text: 'UPDATE_DB_TIME' 		,type: 'string'},
    		{name: 'COMP_CODE'	          ,text: 'COMP_CODE' 			,type: 'string',allowBlank:false},
    		{name: 'ACCNT_CD'      	  	  ,text: '항목코드'		 		,type: 'string',allowBlank:false},
    		{name: 'ACCNT_NAME'      	  ,text: '항목명'					,type: 'string'},
    		{name: 'AMT_I'	              ,text: '금액' 					,type: 'uniPrice'},
    		{name: 'SAVE_FLAG'   	  	  ,text: 'SAVE_FLAG' 			,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agc120ukrMasterStore',{
		model: 'Agc120ukrModel',
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
						directMasterStore.loadStoreRecords();
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
//				    		var newRecord = records;
//				    		store.newData(newRecord)})
				    	
				    	/*store.uniOpt.isMaster = false;
				    	var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
				        UniAppManager.updateStatus(msg, true);
				    	UniAppManager.setToolbarButtons('save',true);*/
					}/*else{
						store.uniOpt.isMaster = true;
					}
				}else{
//					store.uniOpt.isMaster = true;*/
					UniAppManager.app.fnSetProfitLoss();
				}
				if(!isNew && directMasterStore.getTotalCount() > 0)
					UniAppManager.setToolbarButtons(['deleteAll'],true);
           	},
           	add: function(store, records, index, eOpts) {
//           		store.uniOpt.isMaster = true;
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
//           		store.uniOpt.isMaster = true;
           	},
           	remove: function(store, record, index, isMove, eOpts) {
//           		store.uniOpt.isMaster = true;
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
			items: [{ 
    			fieldLabel: '당기시작년월',
    			name:'ST_DATE',
				xtype: 'uniMonthfield',
//				value: UniDate.get('today'),
				allowBlank:false,
				holdable: 'hold',
				width: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ST_DATE', newValue);
					}
				}
			},{
    			fieldLabel: '구분',
    			name:'PROFIT_DIVI_F', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A076',
    			allowBlank:false,
    			holdable: 'hold',
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PROFIT_DIVI_F', newValue);
					}
				}
    		},{ 
    			fieldLabel: '처분확정일',
    			name:'DEAL_DATE',
				xtype: 'uniDatefield',
//				value: UniDate.get('today'),
				allowBlank:false,
				holdable: 'hold',
				width: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DEAL_DATE', newValue);
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
					var param = {
						"ST_DATE": UniDate.getDbDateStr(panelSearch.getValue('ST_DATE')).substring(0,6),
						"PROFIT_DIVI_F": panelSearch.getValue('PROFIT_DIVI_F'),
						"FN_DATE": panelSearch.getValue('FN_DATE'),
						"TO_DATE": panelSearch.getValue('TO_DATE'),
						"GUBUN": panelSearch.getValue('GUBUN')
					};
					agc120ukrService.reReference(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							Ext.each(provider, function(record,i){
								UniAppManager.app.onNewDataButtonDown();
				        		masterGrid.setNewDataGUBUNTABLE(record);	
							});
						}
					});
				}
			},{
				fieldLabel:'당시시작년월일FN',
				xtype:'uniTextfield',
				name:'FN_DATE',
				hidden:true
			},{
				fieldLabel:'당시시작년월일TO',
				xtype:'uniTextfield',
				name:'TO_DATE',
				hidden:true
			}]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
    			fieldLabel: '재무제표</br>양식차수',
    			name:'GUBUN', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A093',
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
		layout : {type : 'uniTable', columns : 4,
			tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'},
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'left'}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '당기시작년월',
			name:'ST_DATE',
			xtype: 'uniMonthfield',
//			value: UniDate.get('today'),
			allowBlank:false,
			holdable: 'hold',
			width: 200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ST_DATE', newValue);
				}
			}
		},{
			fieldLabel: '구분',
			name:'PROFIT_DIVI_F', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A076',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PROFIT_DIVI_F', newValue);
				}
			}
		},{ 
			fieldLabel: '처분확정일',
			name:'DEAL_DATE',
			xtype: 'uniDatefield',
//			value: UniDate.get('today'),
			allowBlank:false,
			holdable: 'hold',
//			labelWidth: 100,
			width: 200,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DEAL_DATE', newValue);
				}
			}
		},{
			xtype: 'button',
			text: '재참조',
			width: 100,
			margin: '0 0 0 0',
			handler:function()	{
				masterGrid.reset();
				directMasterStore.clearData();
				var param = {
					"ST_DATE": UniDate.getDbDateStr(panelSearch.getValue('ST_DATE')).substring(0,6),
					"PROFIT_DIVI_F": panelSearch.getValue('PROFIT_DIVI_F'),
					"FN_DATE": panelSearch.getValue('FN_DATE'),
					"TO_DATE": panelSearch.getValue('TO_DATE'),
					"GUBUN": panelSearch.getValue('GUBUN')
				};
				agc120ukrService.reReference(param, function(provider, response)	{
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
    
    var masterGrid = Unilite.createGrid('agc120ukrGrid', {
        layout : 'fit',
        region:'center',
        excelTitle: '이익잉여금처분등록',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false , enableGroupingMenu:false},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
			{ dataIndex: 'AC_YYYYMM'		     , 	width: 100, hidden: true},
			{ dataIndex: 'PROFIT_DIVI'	  		 , 	width: 100, hidden: true},
			{ dataIndex: 'DEAL_DATE'	         , 	width: 100, hidden: true},
			{ dataIndex: 'EX_DATE'		    	 , 	width: 100, hidden: true},
			{ dataIndex: 'EX_NUM'			     , 	width: 100, hidden: true},
			{ dataIndex: 'AGREE_YN'		     	 , 	width: 100, hidden: true},
			{ dataIndex: 'UPPER_ACCNT_CD'   	 , 	width: 100, hidden: true},
			{ dataIndex: 'OPT_DIVI'		     	 , 	width: 100, hidden: true},
			{ dataIndex: 'DIS_DIVI'		     	 , 	width: 100, hidden: true},
			{ dataIndex: 'CAL_DIVI'		     	 , 	width: 100, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'   	 , 	width: 100, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'    	 , 	width: 100, hidden: true},
			{ dataIndex: 'COMP_CODE'	         , 	width: 100, hidden: true},
			{ dataIndex: 'ACCNT_CD'      		 , 	width: 133},
			{ dataIndex: 'ACCNT_NAME'       	 , 	width: 533},
			{ dataIndex: 'AMT_I'	             , 	width: 200},
			{ dataIndex: 'SAVE_FLAG'	         , 	width: 100, hidden: true}
        ],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['AMT_I'])){	
					if(e.record.data.DIS_DIVI == '2' || e.record.data.DIS_DIVI == '3'){
						return false;
					}
					
					return UniAppManager.app.fnChkEditable(e);
				}else{
					return false;	
				}
				
			}
		},
		setNewDataGUBUNTABLE:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('AC_YYYYMM'			,record['AC_YYYYMM']);		
			grdRecord.set('PROFIT_DIVI'			,record['PROFIT_DIVI']);		
			grdRecord.set('DEAL_DATE'	    	,record['DEAL_DATE']);		    
			grdRecord.set('EX_DATE'				,record['EX_DATE']);			
			grdRecord.set('EX_NUM'				,record['EX_NUM']);				
			grdRecord.set('AGREE_YN'			,record['AGREE_YN']);			
			grdRecord.set('UPPER_ACCNT_CD' 		,record['UPPER_ACCNT_CD']);	 
			grdRecord.set('OPT_DIVI'			,record['OPT_DIVI']);			
			grdRecord.set('DIS_DIVI'			,record['DIS_DIVI']);			
			grdRecord.set('CAL_DIVI'			,record['CAL_DIVI']);			
			grdRecord.set('UPDATE_DB_USER' 		,record['UPDATE_DB_USER']);	 
			grdRecord.set('UPDATE_DB_TIME' 		,record['UPDATE_DB_TIME']);	 
			grdRecord.set('COMP_CODE'	    	,record['COMP_CODE']);		    
			grdRecord.set('ACCNT_CD'      		,record['ACCNT_CD']);	      	
			grdRecord.set('ACCNT_NAME'     		,record['ACCNT_NAME']);	     
			grdRecord.set('AMT_I'	        	,record['AMT_I']); 	
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
		id  : 'agc120ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','deleteAll'],false);
			
			
			
			var param = {COMP_CODE: UserInfo.compCode}
			accntCommonService.fnGetStDt(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('ST_DATE',provider[0].STDT);
					panelResult.setValue('ST_DATE',provider[0].STDT);
					panelSearch.setValue('FN_DATE',provider[0].STDT);
					panelSearch.setValue('TO_DATE',provider[0].TODT);
					
				}
			})
			panelSearch.setValue('DEAL_DATE',UniDate.get('today'));
			panelResult.setValue('DEAL_DATE',UniDate.get('today'));
			panelSearch.setValue('GUBUN',BsaCodeInfo.gsGubunA093);
			
			
			
					
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ST_DATE');
		},
		onQueryButtonDown : function()	{			
			if(!this.checkForForm()) {
				return false;
			}else{
				directMasterStore.loadStoreRecords();	
				
				UniAppManager.setToolbarButtons(['reset'],true);
				
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForForm()) return false;
//        	UniAppManager.setToolbarButtons('save',true);
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
							UniAppManager.setToolbarButtons(['deleteAll'],false);
							
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
        fnReCalculation: function(record, newValue, oldValue){
        	if(newValue == oldValue){
        		return false;
        	}else{
	        	var sUpperCD;
	        	var sUpperOldAmt = 0;
	        	var sSign = 0;
	        	
	        	
	        	sUpperCD = record.get('UPPER_ACCNT_CD');
	        	
	        	if(Ext.isEmpty(sUpperCD)){
	        		return false;
	        	}
	        	
	        	
	        	if(record.get('CAL_DIVI') == '1'){
	        		sSign = 1;	
	        	}else{
	        		sSign = -1;
	        	}
	        	
	        	var records = directMasterStore.data.items;
	        	Ext.each(records, function(item, i){
	        		if(sUpperCD == item.get('ACCNT_CD')  ){
	        			sUpperOldAmt = item.get('AMT_I');
	        			
	        			item.set('AMT_I', sUpperOldAmt - (sSign * oldValue) + (sSign * newValue));
	        			
	        			UniAppManager.app.fnReCalculation(item, (sUpperOldAmt - (sSign * oldValue) + (sSign * newValue)),sUpperOldAmt);	
	        		}
	        	});
        	}
        },
        
        fnSetProfitLoss: function(){//추후개발 진행  20160106개발중 중단
        	var sDivi;
        	var sPositCd, sNegCd;
        	var lPositRow;
        	var lNegRow;
        	var dAmtI = 0;
        	
        	if(panelSearch.getValue('PROFIT_DIVI_F') == '1'){
        		sDivi = '40';	
        	}else{
        		sDivi = '45';	
        	}
        	
        	var param = {
        		COMP_CODE: UserInfo.compCode,
        		DIVI: sDivi,
        		OPT_DIVI: '1'
        	}
			accntCommonService.fnGetProfitCode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					sPositCd = provider['ACCNT_CD'];
				}
			});
        	var param = {
        		COMP_CODE: UserInfo.compCode,
        		DIVI: sDivi,
        		OPT_DIVI: '2'
        	}
			accntCommonService.fnGetProfitCode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					sNegCd = provider['ACCNT_CD'];
				}
				var records = directMasterStore.data.items;
				Ext.each(records, function(record,i){
					if(sPositCd == record.get('ACCNT_CD')){
						dAmtI = record.get('AMT_I');
					}
					if(dAmtI >= 0){
						if(sPositCd == record.get('ACCNT_CD')){
							record.set('AMT_I',dAmtI);
						}
						if(sNegCd == record.get('ACCNT_CD')){
							record.set('AMT_I','');
						}
					}else{
						if(sPositCd == record.get('ACCNT_CD')){
							record.set('AMT_I','');
						}
						if(sNegCd == record.get('ACCNT_CD')){
							record.set('AMT_I',dAmtI);
						}	
					}
				});
			});
			
        },
        fnChkEditable : function(e){
        	var sEditVal, sOpt, dAmt;
        	
        	sEditVal = e.record.data.OPT_DIVI;
        	
        	if(sEditVal == '1'){
        		sOpt = directMasterStore.data.items[e.rowIdx + 1].data.OPT_DIVI;
        		dAmt = directMasterStore.data.items[e.rowIdx + 1].data.AMT_I;
        	}
        	if(sEditVal == '2'){
        		sOpt = directMasterStore.data.items[e.rowIdx - 1].data.OPT_DIVI;
        		dAmt = directMasterStore.data.items[e.rowIdx - 1].data.AMT_I;
        	}
        	if(Ext.isEmpty(dAmt)){
        		dAmt = 0;	
        	}
        	
        	if(sEditVal != sOpt && dAmt != 0){
				return false;
        	}else{
				return true;
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
				case "AMT_I" : 
					
				UniAppManager.app.fnReCalculation(record, newValue,oldValue);
//				
//				
//				
//					if(Ext.isEmpty(sUpperCD)){
//						return false;
//					}
//        	
					
				
//				var sSign;
//        	
//        	
//        		if(!Ext.isEmpty(record.get('UPPER_ACCNT_CD'))){
//        		
//        			if(record.get('CAL_DIVI') == '1'){
//		        		sSign = 1;	
//		        	}else{
//		        		sSign = -1;
//		        	}
//		        	
//		        	
//		        	
//		        
//		        	var records = directMasterStore.data.items;
//		        	Ext.each(records, function(item, i){
//		        		if(record.get('UPPER_ACCNT_CD') == item.get('ACCNT_CD')  ){
//		        			sUpperOldAmt = item.get('AMT_I');
//		        			
//		        			item.set('AMT_I', sUpperOldAmt - (sSign * oldValue/*item.get('AMT_I')*/) + (sSign * newValue));
//		        			
////		        			UniAppManager.app.fnReCalculation(item, sUpperOldAmt - (sSign * oldValue/*item.get('AMT_I')*/) + (sSign * newValue));	
//		        		}/*else{
//		        			return false;
//		        		}*/
//		        		
//		        	});
//		        	
//        			
//        		}
//        	
        	
        	
			}
				return rv;
		}
	});	
	

};


</script>
