<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="aep700ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="J697" /> <!-- 계정그룹 -->      
	<t:ExtComboStore comboType="AU" comboCode="J693" /> <!-- 과세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="J642" /> <!-- 국가 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

var SAVE_FLAG = '';

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'aep700ukrService.selectList'/*,
        	update: 'aep700ukrService.updateDetail',
			create: 'aep700ukrService.insertDetail',
			destroy: 'aep700ukrService.deleteDetail',
			syncAll: 'aep700ukrService.saveAll'*/
        }
	});
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Aep700ukrModel', {		
	    fields: [
	    		 {name: 'BANK_TYPE'				,text: '계좌구분' 			,type: 'string'},			 // 사업자번호	 	
				 {name: 'BANK_CODE'		    	,text: '개설은행' 			,type: 'string'},			 // 은행코드	 	
				 {name: 'BANKBOOK_NUM'	    	,text: '계좌정보' 			,type: 'string'},			 // 계좌번호
				 {name: 'CUSTOM_FULL_NAME'	    ,text: '비고' 			,type: 'string'}		 	 	
		]
	});		
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('aep700ukrMasterStore1',{
			model: 'Aep700ukrModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
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
			saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
		    items : [	    
	    	Unilite.popup('CUST',{
	    		extParam : {'CUSTOM_TYPE': ['1','2','3']},
		    	fieldLabel: '거래처명',
				autoPopup   : true ,
				allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
		    })]		
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2/*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [  
    	Unilite.popup('CUST',{
    		extParam : {'CUSTOM_TYPE': ['1','2','3']},
	    	fieldLabel: '거래처명',
			autoPopup   : true ,
			allowBlank:false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
	    })]
	}); 
	
	var inputTable = Unilite.createForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 2},
		disabled: false,
        border:true,
        padding:'1 1 1 1',
        masterGrid: masterGrid,
		region: 'north',
		items: [{
				fieldLabel: '거래처코드',
				name:'CUSTOM_CODE', 
				xtype: 'uniTextfield',
				colspan:2,
				readOnly:true
			},{
	            xtype: 'container',
	            layout: {type : 'uniTable', columns : 2},
	            width:325,
	            items :[{
		    		fieldLabel: '계정그룹',
		    		name: 'VENDOR_GROUP_CODE',
		    		xtype: 'uniCombobox',
		    		comboType: 'AU',
		    		comboCode: 'J697',
		    		allowBlank:false
	            }]
	    	},{
				fieldLabel: '법인등록번호',
				name:'VENDOR_CORP_NO', 
				xtype: 'uniTextfield',
				listeners : { 
					blur: function( field, The, eOpts )	{
						var newValue = field.getValue().replace(/-/g,'');
						if(!Ext.isEmpty(newValue) && field.originalValue != field.getValue())	{
							if(Ext.isNumeric(newValue) == true) {
								var a = newValue;
								var i = (a.substring(0,6)+ "-"+ a.substring(6,13));
								inputTable.setValue('VENDOR_CORP_NO',i);
						 	}
		  					if(Ext.isNumeric(newValue) != true)	{
						 		if(!confirm(Msg.sMB074)) {									 		 
						 			inputTable.setValue('VENDOR_CORP_NO', field.originalValue);
						 		}
						 	}
						}
					}
				}
	    	},{
				fieldLabel: '사업자번호',
				name:'COMPANY_NUM', 
				xtype: 'uniTextfield',
				listeners : { 
					blur: function( field, The, eOpts )	{
	  					var newValue = field.getValue().replace(/-/g,'');		
	  					if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{	
	  						alert(Msg.sMB074);
				 			inputTable.setValue('COMPANY_NUM', field.originalValue);
				 			return;
						 }
	  					if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )	{
		  					if(Ext.isNumeric(newValue)) {
								var a = newValue;
								var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
								if(a.length == 10){
									inputTable.setValue('COMPANY_NUM',i);
								}else{
									inputTable.setValue('COMPANY_NUM',a);
								}
								
						 	}
		  					if(Unilite.validate('bizno', newValue) != true)	{
						 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{									 		 
						 			inputTable.setValue('COMPANY_NUM', field.originalValue);
						 		}
						 	}
	  					}
	  				}
	  			 }
	    	},{
	            xtype: 'container',
	            layout: {type : 'uniTable', columns : 2},
	            tdAttrs: {width:400/*align : 'center'*/},
	            items :[{
		            xtype: 'container',
		            layout: {type : 'vbox'},
		            items :[{
						fieldLabel: '주민번호',
						name:'TOP_NUM', 
						xtype: 'uniTextfield',
						id:'topNum',
						itemId:'topNum',
						listeners : { 
							blur: function(  field, The, eOpts  )	{
			  					var newValue = field.getValue().replace(/-/g,'');
			  					if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
			  						alert(Msg.sMB074);
								 	inputTable.setValue('TOP_NUM', field.originalValue);
								 	return;
								}
			  					if(!Ext.isEmpty(newValue) && field.originalValue != field.getValue())	{
			  						if(Unilite.validate('residentno',newValue) !== true)	{
								 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{									 		 
								 			inputTable.setValue('TOP_NUM', field.originalValue);
								 			return;
								 		}
								 	}
				  					if(Ext.isNumeric(newValue)) {
										var a = newValue;
										var i = (a.substring(0,6)+ "-"+ a.substring(6,13));
										inputTable.setValue('TOP_NUM',i);
								 	}
				  				}
				  			}
			  			}
			    	},{
						fieldLabel: '외국인번호',
						name:'FOREIGN_NUM', 
						xtype: 'uniTextfield',
						id:'foreignNum',
						itemId:'foreignNum',
						listeners : { 
							blur: function(  field, The, eOpts  )	{
			  					var newValue = field.getValue().replace(/-/g,'');
			  					if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
			  						alert(Msg.sMB074);
								 	inputTable.setValue('FOREIGN_NUM', field.originalValue);
								 	return;
								 	
								}
			  					if(!Ext.isEmpty(newValue) && field.originalValue != field.getValue())	{
			  						if(Unilite.validate('residentno',newValue) !== true)	{
								 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{									 		 
								 			inputTable.setValue('FOREIGN_NUM', field.originalValue);
								 			return;
								 		}
								 	}
				  					if(Ext.isNumeric(newValue)) {
										var a = newValue;
										var i = (a.substring(0,6)+ "-"+ a.substring(6,13));
										inputTable.setValue('FOREIGN_NUM',i);
								 	}
				  				}
				  			}
			  			}
			    	}]
			    },{
		    		xtype: 'uniCheckboxgroup',		            		
		    		fieldLabel: '외국인여부',
		    		items: [{
		    			name: 'FOREIGN_YN',			//////////
		    			inputValue: 'Y',
		    			uncheckedValue: 'N',
		    			listeners:{
		    				change: function(field, newValue, oldValue, eOpts) {
		    					if(newValue == true){
		    						inputTable.setValue('TOP_NUM' ,'');
		    						Ext.getCmp('topNum').setHidden(true);
		    						Ext.getCmp('foreignNum').setHidden(false);
		    					}else{
		    						inputTable.setValue('FOREIGN_NUM' ,'');
		    						Ext.getCmp('topNum').setHidden(false);
		    						Ext.getCmp('foreignNum').setHidden(true);
		    					}
							}
		    			}
		    		}]
		        }]      
        	},{
				fieldLabel: '거래처명',
				name:'CUSTOM_FULL_NAME',
				xtype: 'uniTextfield',
	    		allowBlank:false,
	    		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						inputTable.setValue('CUSTOM_NAME', newValue);
					}
				}
	    	},{
				fieldLabel: '거래처약칭',
				name:'CUSTOM_NAME', 
				xtype: 'uniTextfield'
	    	},{
				fieldLabel: '영문명',
				name:'CUSTOM_NAME1', 
				xtype: 'uniTextfield',
				colspan:2
	    	},{
				fieldLabel: '대표이사',
				name:'TOP_NAME', 
				xtype: 'uniTextfield',
	    		allowBlank:false
	    	},{
				fieldLabel: '주민번호',			// 대표이사 주민번호
				name:'VENDOR_CEO_PSN_NO', 
				xtype: 'uniTextfield',
				listeners : { 
					blur: function(  field, The, eOpts  )	{
	  					var newValue = field.getValue().replace(/-/g,'');
	  					if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
	  						alert(Msg.sMB074);
						 	inputTable.setValue('VENDOR_CEO_PSN_NO', field.originalValue);
						 	return;
						 	
						}
	  					if(!Ext.isEmpty(newValue) && field.originalValue != field.getValue())	{
	  						if(Unilite.validate('residentno',newValue) !== true)	{
						 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{									 		 
						 			inputTable.setValue('VENDOR_CEO_PSN_NO', field.originalValue);
						 			return;
						 		}
						 	}
		  					if(Ext.isNumeric(newValue)) {
								var a = newValue;
								var i = (a.substring(0,6)+ "-"+ a.substring(6,13));
								inputTable.setValue('VENDOR_CEO_PSN_NO',i);
						 	}
		  				}
		  			}
	  			}
	    	},{
				fieldLabel: '업종',		
				name:'COMP_CLASS', 
				xtype: 'uniTextfield',
	    		allowBlank:false
	    	},{
				fieldLabel: '업태',		
				name:'COMP_TYPE', 
				xtype: 'uniTextfield',
	    		allowBlank:false
	    	},{
	    		fieldLabel: '과세유형',
	    		name: 'TAX_TYPE_CODE',
	    		xtype: 'uniCombobox',
	    		comboType: 'AU',
	    		comboCode: 'J693',
	    		allowBlank:false,
	    		colspan:2
	    	},{
				fieldLabel: '전화번호',			
				name:'TELEPHON', 
				xtype: 'uniTextfield'
	    	},{
				fieldLabel: '팩스번호',		
				name:'FAX_NUM', 
				xtype: 'uniTextfield'
	    	},{
				fieldLabel: '담당자',		
				name:'VENDOR_MANAGER', 
				xtype: 'uniTextfield'
	    	},{
				fieldLabel: '이메일',		
				name:'MAIL_ID', 
				xtype: 'uniTextfield'
	    	},{
				fieldLabel: '홈페이지',			
				name:'HTTP_ADDR', 
				xtype: 'uniTextfield',
				colspan:2,
				width:570
	    	},{
	            xtype: 'container',
	            layout: {type : 'uniTable', columns : 4},
	            colspan:2,
	            items :[
	                Unilite.popup('ZIP',{
	                    fieldLabel: '주소',
	                    showValue:false,
	                    textFieldWidth:130, 
	                    textFieldName:'ZIP_CODE',
	                    DBtextFieldName:'ZIP_CODE',
	                    validateBlank:false,
	                    allowBlank:false,
	                    popupHeight:570,
//	                    tdAttrs: {style: 'border : 1px solid #ced9e7;'},
	                    listeners: { 
	                        'onSelected': {
	                            fn: function(records, type  ){
	                            	inputTable.setValue('ZIP_CODE', records[0]['ZIP_CODE']);
	                                inputTable.setValue('ADDR1', records[0]['ZIP_NAME']+records[0]['ADDR2']);
	                            },
	                        scope: this
	                        },
	                        'onClear' : function(type)  {
	                            inputTable.setValue('ADDR1', '');
	                        }
	                    }
	                }),
	            {
	                xtype:'uniTextfield',
	                name:'ADDR1',
	                width:345
	            },{
		    		fieldLabel: '',
		    		name: 'NATION_CODE',
		    		xtype: 'uniCombobox',
		    		comboType: 'AU',
		    		comboCode: 'J642'
		    	}]      
        	}
	    ],
	    api: {
	 		load: 'aep700ukrService.selectForm'	,
	 		submit: 'aep700ukrService.syncMaster'	
		},
		listeners : {
			uniOnChange:function( basicForm, field, newValue, oldValue ) {
				console.log("onDirtyChange");
				if(basicForm.isDirty()/* && validateFlag == "1"*/ && newValue != oldValue)	{
					UniAppManager.setToolbarButtons('save', true);
					
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
//				validateFlag = '1';
			}
		}
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aep700ukrGrid1', {
        layout : 'fit',
        region:'center',
        //flex:1,
    	store: directMasterStore1,
    	uniOpt : {
			useMultipleSorting	: true,			 
		    useLiveSearch		: false,			
		    onLoadSelectFirst	: false,		
		    dblClickToEdit		: false,		
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
		    filter: {
				useFilter	: false,		
				autoCreate	: true		
			}
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        		   { dataIndex: 'BANK_TYPE'			 	,	width:200 },
        		   { dataIndex: 'BANK_CODE'			 	,	width:350},
        		   { dataIndex: 'BANKBOOK_NUM'	 		,	width:200 },
        		   { dataIndex: 'CUSTOM_FULL_NAME'	  	,	width:300 }
        		   
        ],
        listeners: {
        	/*selectionchange:function( model1, selected, eOpts ){
        		var record = masterGrid.getSelectedRecord();
        		var count = masterGrid.getStore().getCount();
        		inputTable.loadForm(selected);
          	}*/
        }
    });   		
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, inputTable, masterGrid
			]
		},
			panelSearch	
		],
		id  : 'aep700ukrApp',
		fnInitBinding : function(params) {
			
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('CUSTOM_CODE');
			
			Ext.getCmp('topNum').setHidden(false);
			Ext.getCmp('foreignNum').setHidden(true);			
			inputTable.setValue('NATION_CODE', 'KR');
			
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('delete',false);
			UniAppManager.setToolbarButtons('reset', true);
			
			if(params && params.PGM_ID) {
				this.processParams(params);
			}
		},
		onResetButtonDown: function() {		// 초기화
			panelSearch.clearForm();
			panelResult.clearForm();
			
			inputTable.clearForm();
			masterGrid.reset();
			SAVE_FLAG = '';			// Save_flag 초기화
			
			this.fnInitBinding();
			directMasterStore1.clearData();
			UniAppManager.setToolbarButtons(['delete','save'],false);
		},
		onQueryButtonDown : function()	{		
			if(!panelResult.getInvalidMessage()){
				return;	// 필수체크
			}else{
				var param= panelSearch.getValues();
				
				inputTable.getForm().load({
					params: param,
					success: function(form, action) {
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						
						if(!Ext.isEmpty(inputTable.getValue('VENDOR_CORP_NO'))){		// 법인번호
							var a = inputTable.getValue('VENDOR_CORP_NO');
							var i = (a.substring(0,6) + "-"+ a.substring(6,13));
							inputTable.setValue('VENDOR_CORP_NO',i);
							inputTable.getField('VENDOR_CORP_NO').originalValue = i;
						}
						if(!Ext.isEmpty(inputTable.getValue('COMPANY_NUM'))){			// 사업장번호
							var a = inputTable.getValue('COMPANY_NUM');
							var i = (a.substring(0,3) + "-"+ a.substring(3,5) + "-" + a.substring(5,10));
							inputTable.setValue('COMPANY_NUM',i);
							inputTable.getField('COMPANY_NUM').originalValue = i;
						}
						
						if(SAVE_FLAG == 'U'){
							directMasterStore1.loadStoreRecords();
							UniAppManager.setToolbarButtons('delete',true);	
						}

					},
					failure: function(form, action) {
					}
				});
				UniAppManager.setToolbarButtons('reset',true);
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onSaveDataButtonDown: function() {	// 저장 버튼
			if(!inputTable.getInvalidMessage()){
				return;
			}else{
				var param = inputTable.getValues();
				param.SAVE_FLAG = SAVE_FLAG;
				
				inputTable.getForm().submit({
				params : param,
					success : function(form, action) {
		 				inputTable.getForm().wasDirty = false;
						inputTable.resetDirtyStatus();											
						UniAppManager.setToolbarButtons('save', false);	
		            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
		            	
		            	/*if(SAVE_FLAG == ''){
		            		panelSearch.setValue('CUSTOM_CODE',action.result.CUSTOM_CODE);
		            	}*/
		            	
		            	//UniAppManager.app.onQueryButtonDown();
					}	
				});
			}
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var param = inputTable.getValues();
				param.SAVE_FLAG = 'D';
				inputTable.getForm().submit({
					params : param,
					success : function(form, action) {
						inputTable.clearForm();
						panelSearch.clearForm();
		            	panelResult.clearForm();
		 				inputTable.getForm().wasDirty = false;
						inputTable.resetDirtyStatus();	
						UniAppManager.setToolbarButtons(['delete','save'],false);
		            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다

						masterGrid.reset();
						directMasterStore1.clearData();
					}	
				});
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'aep700skr') {
				panelSearch.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
				panelResult.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
				
				panelSearch.setValue('CUSTOM_NAME',params.CUSTOM_NAME);
				panelResult.setValue('CUSTOM_NAME',params.CUSTOM_NAME);
				
				this.onQueryButtonDown();
			}
		}
	});
	
	Unilite.createValidator('validator01', {
		store : directMasterStore1,
		grid: masterGrid,
		//forms: {'formA:':Table},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			return rv;
		}
	});
	
	
/*	Unilite.createValidator('validator02', {
		forms: {'formA:':inputTable},
		validate: function( type, fieldName, newValue, oldValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					UniAppManager.setToolbarButtons('save',true);
					
					break;
			}
			return rv;
		}
	});	*/
};


</script>
