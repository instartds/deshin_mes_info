<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_aga110ukr_mit"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A049" /> <!-- 예적금구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B001" /> <!-- ? -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 예/아니오 -->
    <t:ExtComboStore comboType="AU" comboCode="A392" />            <!-- 가수금 IN_GUBUN -->
	<t:ExtComboStore comboType="AU" comboCode="BS25" /> <!-- 계좌집금 유형 (통합계좌서비스 대상)-->
	<t:ExtComboStore comboType="AU" comboCode="BS26" /> <!-- CMS 계좌 유형 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_aga110ukr_mitService.selectList',
			update: 's_aga110ukr_mitService.updateDetail',
			create: 's_aga110ukr_mitService.insertDetail',
			destroy: 's_aga110ukr_mitService.deleteDetail',
			syncAll: 's_aga110ukr_mitService.saveAll'
		}
	});	
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	 Unilite.defineModel('s_aga110ukr_mitModel', {
		    fields: [{name: 'PAY_GUBUN'				,text:'기표구분'				,type : 'string' ,comboType:"AU", comboCode:"A045", allowBlank: false},
					 {name: 'DIVI'					,text:'고용형태'				,type : 'string' ,comboType:"AU", comboCode:"H011" },
					 {name: 'ALLOW_TAG_A043'   		,text:'구분'			,type : 'string' ,comboType:"AU", comboCode:"A043" },
					 {name: 'ALLOW_TAG_A066'   		,text:'구분'			,type : 'string' ,comboType:"AU", comboCode:"A066" },
					 {name: 'ALLOW_CODE'  			,text:'수당/공제코드'			,type : 'string' , allowBlank: false},
					 {name: 'ALLOW_NAME' 			,text:'수당/공제코드명'			,type : 'string'},
					 {name: 'SALE_DIVI'  			,text:'판관제조구분'			,type : 'string' ,comboType:"AU", comboCode:"B027" , allowBlank: false},
					 {name: 'EMPLOY_DIVI'  			,text:'임직원구분'				,type : 'string' ,comboType:"AU", comboCode:"H227"},
					 {name: 'ACCNT'  				,text:'계정코드'				,type : 'string' , allowBlank: false},
					 {name: 'ACCNT_NAME' 			,text:'계정과목'				,type : 'string'},
					 {name: 'DEPT_CODE' 			,text:'부서코드'				,type : 'string'},
					 {name: 'DEPT_NAME' 			,text:'부서명'				,type : 'string'},
					 {name: 'CUSTOM_CODE' 			,text:'거래처코드'				,type : 'string'},
					 {name: 'CUSTOM_NAME' 			,text:'거래처명'				,type : 'string'},
					 {name: 'PROJECT_CODE' 			,text:'프로젝트코드'			,type : 'string'},
					 {name: 'PROJECT_NAME' 			,text:'프로젝트명'				,type : 'string'},
					 {name: 'UPDATE_DB_USER'		,text:'UPDATE_DB_USER'		,type : 'string'},
					 {name: 'UPDATE_DB_TIME'		,text:'UPDATE_DB_TIME'		,type : 'string'},
					 {name: 'COMP_CODE'				,text:'COMP_CODE'			,type : 'string'}
					 
				]
		});	
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	 var directMasterStore = Unilite.createStore('directMasterStore',{
			model: 's_aga110ukr_mitModel',
         autoLoad: false,
         uniOpt : {
         	isMaster: true,			// 상위 버튼 연결
         	editable: true,			// 수정 모드 사용
         	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
         },
         
         proxy: directProxy,    
         
         saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					var allowTag = true;
					var row = 0;
					if(panelResult.getValue('PAY_GUBUN') == 1 ){
			 			Ext.each(this.getData().items, function(record, idx){
			 				if(Ext.isEmpty(record.get("ALLOW_TAG_A043")))	{
			 					allowTag = false;
			 					row = idx+1;
			 					return ;
			 				}
			 			});
					}
			 		else{
			 			Ext.each(this.getData().items, function(record, idx){
			 				if(Ext.isEmpty(record.get("ALLOW_TAG_A066")))	{
			 					allowTag = false;
			 					row = idx+1;
			 					return ;
			 				}
			 			});
			 		}
			 		if(allowTag)	{
						this.syncAll();			 //syncAllDirect	
			 		} else {
			 			alert(row +"행의 입력값을 확인해 주세요."+"\n"+"구분: 필수 입력값 입니다.");
			 		}
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
	        loadStoreRecords : function(){
	        	var param1 = Ext.getCmp('PAY_GUBUN3').getValue();
         	var param2 = Ext.getCmp('SALE_DIVI3').getValue();
         	var param= { PAY_GUBUN : param1, SALE_DIVI : param2};    
		        this.load({
		           params: param
		        });
		    }  
	});	
	
	
	var panelResult = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '기표구분',
			name: 'PAY_GUBUN',
			id:'PAY_GUBUN3',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'A045',
			allowBlank: false,
			value: '1'
		}, {
			fieldLabel: '판관제조구분',
			name: 'SALE_DIVI',
			id:'SALE_DIVI3',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B027'
		},
		{
			margin:'0 0 0 100',
        	xtype:'button',
        	text:'전체복사',
        	width: 130,
        	tdAttrs:{'align':'center'},
        	handler: function()	{
				var param = {
        			'PAY_GUBUN' 		: Ext.getCmp('PAY_GUBUN3').getValue(),
        			'SALE_DIVI' : Ext.getCmp('SALE_DIVI3').getValue()
        		}
				s_aga110ukr_mitService.checkCount(param, function(provider, response) {
        			if(!Ext.isEmpty(provider)){			
        				if(provider[0].CNT > 0 ){	
		        			//if(confirm(Msg.sMA0092 + "\n" + Msg.sMA0093 + "\n" + Msg.sMA0094)){
			        		if(confirm('이미 데이터가 존재합니다.' + "\n" + '다시 생성하시면 기존 데이터가 삭제됩니다.' + "\n" + '그래도 생성하시겠습니까?')){	
				        		var param = {
				        			'PAY_GUBUN' 		: Ext.getCmp('PAY_GUBUN3').getValue(),
        							'SALE_DIVI' : Ext.getCmp('SALE_DIVI3').getValue(),
				        			'ALL_COPY'	: 'C'
				        		}
				        		
				        		directMasterStore.loadData({});
				        		masterGrid.mask('로딩중...','loading-indicator');
				        		s_aga110ukr_mitService.selectList(param, function(provider, response) {
									if(!Ext.isEmpty(provider)){
										
										
										Ext.each(provider, function(record,i){
											UniAppManager.app.onNewDataButtonDown();
							        		masterGrid.setNewDataProvider(record);	
										});
									}
									masterGrid.unmask();
				        		});
				        	}
	        			}
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
				//	this.mask();		    
   				}
	  		} else {
					this.unmask();
				}
			return r;
			}
	});	
		
    var masterGrid = Unilite.createGrid('atx425ukrGrid1', {
        region:'center',
        store : directMasterStore,
	    uniOpt : {
	    	copiedRow           : true,
			useMultipleSorting	: true,			 
	    	useLiveSearch		: false,			
	    	onLoadSelectFirst	: true,	
	    	dblClickToEdit		: true,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: false,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
		    	filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},     
		columns: [{dataIndex: 'DIVI'		,		width:80 },				  
				  {dataIndex: 'PAY_GUBUN'			,		width:80 , hidden: true},			  
				  {dataIndex: 'ALLOW_TAG_A043'  ,		width:60 },	
				  {dataIndex: 'ALLOW_TAG_A066'  ,		width:60 },
				  {dataIndex: 'ALLOW_CODE'  	,		width:100 
					,'editor' : Unilite.popup('ALLOW_G',{
				 	 		DBtextFieldName: 'ALLOW_CODE',
				 	 		autoPopup:true,
	  						listeners: {
									'onSelected': {
	 								fn: function(records, type) {
	 									grdRecord = masterGrid.getSelectedRecord();
										record = records[0];
										grdRecord.set('ALLOW_CODE',  record.ALLOW_CODE);
										grdRecord.set('ALLOW_NAME', record.ALLOW_NAME);
	 								},
	 								scope: this
	 							},
	 							'onClear': function(type) {
	 								grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('ALLOW_CODE', '');
									grdRecord.set('ALLOW_NAME', '');
	 							},
	 							applyextparam: function(popup){	
	 								grdRecord = masterGrid.getSelectedRecord();
	 								
									if(Ext.getCmp('PAY_GUBUN3').getValue() == '1' ){
										popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG_A043});
									}else if(Ext.getCmp('PAY_GUBUN3').getValue() == '2' ){
										popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG_A066});
									}
	 							}
	 						}
						})
				  },
				  {dataIndex: 'ALLOW_NAME' 		,		width:130 
					,'editor' : Unilite.popup('ALLOW_G',{ 
				 	 		autoPopup:true,
	  						listeners: {
									'onSelected': {
	 								fn: function(records, type) {
	 									grdRecord = masterGrid.getSelectedRecord();
										record = records[0];
										grdRecord.set('ALLOW_CODE',  record.ALLOW_CODE);
										grdRecord.set('ALLOW_NAME', record.ALLOW_NAME);
	 								},
	 								scope: this
	 							},
	 							'onClear': function(type) {
	 								grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('ALLOW_CODE', '');
									grdRecord.set('ALLOW_NAME', '');
	 							},
	 							applyextparam: function(popup){	
	 								grdRecord = masterGrid.getSelectedRecord();
	 								
									if(Ext.getCmp('PAY_GUBUN3').getValue() == '1' ){
										popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG_A043});
									}else if(Ext.getCmp('PAY_GUBUN3').getValue() == '2' ){
										popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG_A066});
									}
	 							}
	 						}
						})
				  },	
				  {dataIndex: 'SALE_DIVI'  		,		width:100 },	
				  {dataIndex: 'EMPLOY_DIVI' 		,		width:100 },			  
				  {dataIndex: 'ACCNT'  			,		width:80 
				 	 ,'editor' : Unilite.popup('ACCNT_G',{
				 	 		DBtextFieldName: 'ACCNT_CODE',
				 	 		autoPopup:true,
//				 	 		extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//	    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
	  						listeners: {
									'onSelected': {
	 								fn: function(records, type) {
	 									grdRecord = masterGrid.getSelectedRecord();
										record = records[0];
										grdRecord.set('ACCNT',  record.ACCNT_CODE);
										grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
	 								},
	 								scope: this
	 							},
	 							'onClear': function(type) {
	 								grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
	 							},
								'applyextparam': function(popup){							
									popup.setExtParam({
//										'CHARGE_CODE': getChargeCode[0].SUB_CODE,
	    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
    								});
								}
	 						}
						})
				  },				  
				  {dataIndex: 'ACCNT_NAME' 		,		width:220 
				  	,'editor' : Unilite.popup('ACCNT_G',{
				  			autoPopup:true,
//				  			extParam: {'CHARGE_CODE': getChargeCode[0].SUB_CODE,
//	    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"}, 
	  						listeners: {
									'onSelected': {
	 								fn: function(records, type) {
	 									grdRecord = masterGrid.getSelectedRecord();
										record = records[0];
										grdRecord.set('ACCNT',  record.ACCNT_CODE);
										grdRecord.set('ACCNT_NAME', record.ACCNT_NAME);
	 								},
	 								scope: this
	 							},
	 							'onClear': function(type) {
	 								grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
	 							},
								'applyextparam': function(popup){							
									popup.setExtParam({
//										'CHARGE_CODE': getChargeCode[0].SUB_CODE,
	    								'ADD_QUERY': "(SLIP_SW = 'Y' AND GROUP_YN = 'N')"
    								});
								}
	 						}
						})
				  },	
				  {dataIndex: 'DEPT_CODE'  			,		width:80 
					 	 ,'editor' : Unilite.popup('DEPT_G',{
					 			valueFieldName:'DEPT_CODE',
					 	 		DBtextFieldName: 'TREE_CODE',
					 	 		autoPopup:true,
		  						listeners: {
										'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = masterGrid.getSelectedRecord();
											record = records[0];
											grdRecord.set('DEPT_CODE',  record.TREE_CODE);
											grdRecord.set('DEPT_NAME', record.TREE_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('DEPT_CODE', '');
										grdRecord.set('DEPT_NAME', '');
		 							}
		 						}
							})
					  },				  
					  {dataIndex: 'DEPT_NAME' 		,		width:100 
					  	,'editor' : Unilite.popup('DEPT_G',{
					  			autoPopup:true,
		  						listeners: {
										'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = masterGrid.getSelectedRecord();
											record = records[0];
											grdRecord.set('DEPT_CODE',  record.TREE_CODE);
											grdRecord.set('DEPT_NAME', record.TREE_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('DEPT_CODE', '');
										grdRecord.set('DEPT_NAME', '');
		 							}
		 						}
							})
				  },	
				  {dataIndex: 'CUSTOM_CODE'  			,		width:80 
					 	 ,'editor' : Unilite.popup('CUST_G',{
					 			valueFieldName:'CUSTOM_CODE',
					 	 		DBtextFieldName: 'CUSTOM_CODE',
					 	 		autoPopup:true,
		  						listeners: {
										'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = masterGrid.getSelectedRecord();
											record = records[0];
											grdRecord.set('CUSTOM_CODE',  record.CUSTOM_CODE);
											grdRecord.set('CUSTOM_NAME', record.CUSTOM_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('CUSTOM_CODE', '');
										grdRecord.set('CUSTOM_NAME', '');
		 							}
		 						}
							})
					  },				  
					  {dataIndex: 'CUSTOM_NAME' 		,		width:100 
					  	,'editor' : Unilite.popup('CUST_G',{
					  			autoPopup:true,
		  						listeners: {
										'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = masterGrid.getSelectedRecord();
											record = records[0];
											grdRecord.set('CUSTOM_CODE',  record.CUSTOM_CODE);
											grdRecord.set('CUSTOM_NAME', record.CUSTOM_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('CUSTOM_CODE', '');
										grdRecord.set('CUSTOM_NAME', '');
		 							}
		 						}
							})
				  },	
				  {dataIndex: 'PROJECT_CODE'  			,		width:100 
					 	 ,'editor' : Unilite.popup('PROJECT_G',{
					 			valueFieldName:'PROJECT_CODE',
					 	 		DBtextFieldName: 'PJT_CODE',
					 	 		autoPopup:true,
		  						listeners: {
										'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = masterGrid.getSelectedRecord();
											record = records[0];
											grdRecord.set('PROJECT_CODE', record.PJT_CODE);
											grdRecord.set('PROJECT_NAME', record.PJT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('PROJECT_CODE', '');
										grdRecord.set('PROJECT_NAME', '');
		 							}
		 						}
							})
					  },				  
					  {dataIndex: 'PROJECT_NAME' 		,		width:120 
					  	,'editor' : Unilite.popup('PROJECT_G',{
					  			autoPopup:true,
		  						listeners: {
										'onSelected': {
		 								fn: function(records, type) {
		 									grdRecord = masterGrid.getSelectedRecord();
											record = records[0];
											grdRecord.set('PROJECT_CODE',  record.PJT_CODE);
											grdRecord.set('PROJECT_NAME', record.PJT_NAME);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('PROJECT_CODE', '');
										grdRecord.set('PROJECT_NAME', '');
		 							}
		 						}
							})
				  },	
				  {dataIndex: 'UPDATE_DB_USER'	,		width:66 , hidden: true},				  
				  {dataIndex: 'UPDATE_DB_TIME'	,		width:66 , hidden: true}				  
				  //{dataIndex: 'COMP_CODE'		,		width:66 , hidden: true}	
		],
		listeners: {
    		beforeedit: function( editor, e, eOpts ) {
    			if(e.record.phantom == false) {
    				if(UniUtils.indexOf(e.field, ['ACCNT', 'ACCNT_NAME', 'CUSTOM_CODE','CUSTOM_NAME', 'PROJECT_CODE','PROJECT_NAME'])) {
						return true;
					} else {
						return false;
					}
    			}
    			return true;
        	},
        	edit: function(editor, e) {
        		if(editor.context.field == 'PAY_GUBUN')	{
        			masterGrid.getSelectedRecord().set('ALLOW_CODE' , '');
        			masterGrid.getSelectedRecord().set('ALLOW_NAME' , '');
        		}
        	}
		},	
    	setNewDataProvider:function(record){
			var grdRecord = this.getSelectedRecord();
	
			grdRecord.set('PAY_GUBUN'	 			,record['PAY_GUBUN']);
			grdRecord.set('DIVI'	 				,record['DIVI']);
			if(Ext.getCmp('PAY_GUBUN3').getValue() == '1'){
				grdRecord.set('ALLOW_TAG_A043'	 		,record['ALLOW_TAG_A043']);
			}
			else{
				grdRecord.set('ALLOW_TAG_A066'	 		,record['ALLOW_TAG_A066']);
			}
			grdRecord.set('ALLOW_CODE'		 		,record['ALLOW_CODE']);
			grdRecord.set('ALLOW_NAME'				,record['ALLOW_NAME']);
			grdRecord.set('SALE_DIVI'				,record['SALE_DIVI']);
			grdRecord.set('ACCNT'					,record['ACCNT']);
			grdRecord.set('ACCNT_NAME'				,record['ACCNT_NAME']);
			
			grdRecord.set('DEPT_CODE'				,record['DEPT_CODE']);
			grdRecord.set('DEPT_NAME'				,record['DEPT_NAME']);
			grdRecord.set('CUSTOM_CODE'					,record['ACCNT']);
			grdRecord.set('ACCNT_NAME'				,record['ACCNT_NAME']);
			grdRecord.set('ACCNT'					,record['ACCNT']);
			grdRecord.set('ACCNT_NAME'				,record['ACCNT_NAME']);
			
			grdRecord.set('UPDATE_DB_USER'			,record['UPDATE_DB_USER']);
			grdRecord.set('UPDATE_DB_TIME'			,record['UPDATE_DB_TIME']);
        }
    });  

    
	Unilite.Main( {
		borderItems:[
			 masterGrid
			,panelResult
		],
		id: 's_aga110ukr_mitApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['query' ,'newData'],true);
		},
		onQueryButtonDown: function()	{
			if(!panelResult.setAllFieldsReadOnly(true))	{
				return false;
			} else {
				panelResult.getField('PAY_GUBUN').setReadOnly(true);
				if(panelResult.getValue('PAY_GUBUN') == 1 ){
					masterGrid.getColumn('ALLOW_TAG_A043').setVisible(true);
					masterGrid.getColumn('ALLOW_TAG_A066').setVisible(false);
				}
		 		else{
		 			masterGrid.getColumn('ALLOW_TAG_A043').setVisible(false);
		 			masterGrid.getColumn('ALLOW_TAG_A066').setVisible(true);
		 		}
				
				UniAppManager.setToolbarButtons(['reset', 'newData', 'delete','query'],true);
				directMasterStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.setAllFieldsReadOnly(true)) {
				return false;
				
			}else{
				panelResult.getField('PAY_GUBUN').setReadOnly(true);
				
				if(panelResult.getValue('PAY_GUBUN') == 1 ){
					masterGrid.getColumn('ALLOW_TAG_A043').setVisible(true);
					masterGrid.getColumn('ALLOW_TAG_A066').setVisible(false);
				}
		 		else{
		 			masterGrid.getColumn('ALLOW_TAG_A043').setVisible(false);
		 			masterGrid.getColumn('ALLOW_TAG_A066').setVisible(true);
		 		}

			
				var param =  panelResult.getValues();
				var compCode = UserInfo.compCode
				var payGubun     = param.PAY_GUBUN
				var r = {
					COMP_CODE : compCode,
					PAY_GUBUN      : payGubun
				}
				masterGrid.createRow(r , 'DIVI');
				
				UniAppManager.setToolbarButtons(['reset'],true);
			}
				
		},
		onResetButtonDown: function() {		
			panelResult.clearForm();
			
			directMasterStore.loadData({});
			panelResult.getField('PAY_GUBUN').setReadOnly(false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		}
	});
	
};



</script>
