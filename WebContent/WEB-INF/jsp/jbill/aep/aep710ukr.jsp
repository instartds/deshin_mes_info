<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="aep710ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="J627" /> <!-- 은행코드 --> 
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'aep710ukrService.selectList',
        	update: 'aep710ukrService.updateDetail',
			create: 'aep710ukrService.insertDetail',
			destroy: 'aep710ukrService.deleteDetail',
			syncAll: 'aep710ukrService.saveAll'
        }
	});
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('aep710ukrModel', {		
	    fields: [	
	    		 {name: 'BVTYP'				,text: '파트너유형' 		,type: 'string'},		
				 {name: 'DOCU_NUMC'  		,text: '생성차수' 			,type: 'string'},		
				 {name: 'STATUS'  			,text: '요청상태' 			,type: 'string'},		
				 {name: 'WORK_STAT'			,text: '결재상태' 			,type: 'string'},		
				 {name: 'CUSTOM_CODE'  		,text: '거래처' 			,type: 'string' ,allowBlank:false},		
				 {name: 'CUSTOM_NAME'  		,text: '거래처명' 			,type: 'string' ,allowBlank:false},
				 {name: 'KOINH'				,text: '예금주' 			,type: 'string' ,allowBlank:false},		
				 {name: 'BANKL'  			,text: '은행코드' 			,type: 'string' ,allowBlank:false , comboType:'AU', comboCode :'J627' },
				 {name: 'BANKN'	    		,text: '은행계좌번호'		,type: 'string' ,allowBlank:false},
				 {name: 'COMPANY_NUM'		,text: '사업자번호' 		,type: 'string'},		
				 {name: 'REG_DT'  			,text: '등록시간' 			,type: 'uniDate'},		
				 {name: 'REG_NM'  			,text: '등록자' 			,type: 'string'}
		]
	});		
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('aep710ukrMasterStore1',{
			model: 'aep710ukrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
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
		    }),{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				margin: '0 0 0 95',
				items :[{
					xtype: 'radiogroup',		            		
					//fieldLabel: '반영여부',
					items: [{
						boxLabel: '계좌', 
						width: 70,
						name: 'APPLY_YN',
						inputValue: 'A',
						checked: true  
					},{
						boxLabel: '요청현황', 
						width: 70,
						name: 'APPLY_YN',
						inputValue: 'B' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('APPLY_YN').setValue(newValue.APPLY_YN);					
						}
					}
				}
			]},{ 
	    		fieldLabel: '등록일자',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'REG_DT_FR',
			    endFieldName: 'REG_DT_TO',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('REG_DT_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('REG_DT_TO', newValue);				    		
			    	}
			    }
			},
			Unilite.popup('Employee',{
				fieldLabel: '성명',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
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
		items: [{
	            xtype: 'container',
	            layout: {type : 'uniTable', columns : 2},
	            items :[
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
		    	}),{
					xtype: 'container',
					layout: {type : 'uniTable', columns : 2},
					items :[{
						xtype: 'radiogroup',		            		
						//fieldLabel: '반영여부',
						items: [{
							boxLabel: '계좌', 
							width: 55,
							name: 'APPLY_YN',
							inputValue: 'A',
							checked: true  
						},{
							boxLabel: '요청현황', 
							width: 65,
							name: 'APPLY_YN',
							inputValue: 'B' 
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.getField('APPLY_YN').setValue(newValue.APPLY_YN);					
							}
						}
					}
				]}
		]},{ 
    		fieldLabel: '등록일자',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'REG_DT_FR',
		    endFieldName: 'REG_DT_TO',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('REG_DT_FR', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('REG_DT_TO', newValue);				    		
		    	}
		    }
		},
		Unilite.popup('Employee',{
			fieldLabel: '성명',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		})]
	}); 
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aep710ukrGrid1', {
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
        		   { dataIndex: 'BVTYP'						 	,	width:100 },
        		   { dataIndex: 'DOCU_NUMC'  				 	,	width:100 },
        		   { dataIndex: 'STATUS'  			 			,	width:100 },
        		   { dataIndex: 'WORK_STAT'					 	,	width:100 },
        		   { dataIndex: 'CUSTOM_CODE'  				 	,	width:120, 
        		   'editor' : Unilite.popup('CUST_G',{
        		   		extParam : {'CUSTOM_TYPE': ['1','2','3']},
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
		 								fn: function(records, type) {
		 									var grdRecord = Ext.getCmp('aep710ukrGrid1').uniOpt.currentRecord;
		 									grdRecord = masterGrid.getSelectedRecord();
		 									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
				                    		grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								var grdRecord = Ext.getCmp('aep710ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('CUSTOM_CODE','');
		  								grdRecord.set('CUSTOM_NAME','');
									}
			 				}
						})
					},
        		   { dataIndex: 'CUSTOM_NAME'  		 			,	width:200,
        		   'editor' : Unilite.popup('CUST_G',{
        		   		extParam : {'CUSTOM_TYPE': ['1','2','3']},
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
		 								fn: function(records, type) {
		 									var grdRecord = Ext.getCmp('aep710ukrGrid1').uniOpt.currentRecord;
		 									grdRecord = masterGrid.getSelectedRecord();
		 									grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
				                    		grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
		 								var grdRecord = Ext.getCmp('aep710ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('CUSTOM_CODE','');
		  								grdRecord.set('CUSTOM_NAME','');
									}
			 				}
						})
				   },
        		   { dataIndex: 'KOINH'						 	,	width:100 },
        		   { dataIndex: 'BANKL'  					 	,	width:120 },
        		   { dataIndex: 'BANKN'	    				 	,	width:120 },
        		   { dataIndex: 'COMPANY_NUM'				 	,	width:100 },
        		   { dataIndex: 'REG_DT'  			 			,	width:100 },
        		   { dataIndex: 'REG_NM'  					 	,	width:100 }   
        ],
        listeners: {
        	beforeedit: function( editor, e, eOpts ) {
	        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
	        		if(UniUtils.indexOf(e.field, ['BVTYP', 'DOCU_NUMC', 'STATUS' ,'WORK_STAT' ,'COMPANY_NUM' ,'REG_DT' ,'REG_NM'])) {
						return false;
					}
	        	}
	        } 	
        }
    });   		
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid
			]
		},
			panelSearch	
		],
		id  : 'aep710ukrApp',
		fnInitBinding : function(params) {
			
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('CUSTOM_CODE');
				
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('delete',false);
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('newData', true);
			
			panelSearch.setValue('REG_DT_FR'  , UniDate.get('startOfMonth'));
			panelSearch.setValue('REG_DT_TO'  , UniDate.get('today'));
			panelResult.setValue('REG_DT_FR'  , UniDate.get('startOfMonth'));
			panelResult.setValue('REG_DT_TO'  , UniDate.get('today'));
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			panelSearch.clearForm();
			panelResult.clearForm();
			
			masterGrid.reset();
			
			this.fnInitBinding();
			directMasterStore1.clearData();
			UniAppManager.setToolbarButtons(['delete','save'],false);
		},
		onNewDataButtonDown: function()	{
			var compCode	= UserInfo.compCode; 
	        var seq 		= masterGrid.getStore().max('SEQ');
        	if(!seq) seq 	= 1;
        	else  seq 		+= 1;
        	
        	var r ={
        		COMP_CODE		: compCode,
				SEQ				: seq
        	};
	        masterGrid.createRow(r);
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore1.saveStore(config);
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
