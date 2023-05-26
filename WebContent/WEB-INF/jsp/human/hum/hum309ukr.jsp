<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum309ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum309ukr"	/> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H095" /> 				<!-- 고과구분 -->
	<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--사업명-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hum309ukrService.selectList',
        	update: 'hum309ukrService.updateDetail',
			create: 'hum309ukrService.insertDetail',
			destroy: 'hum309ukrService.deleteDetail',
			syncAll: 'hum309ukrService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum309ukrModel', {
	    fields: [
	    
	    	{name: 'DOC_ID'						,text:'DOC_ID'			,type:'string' },
	    	{name: 'COMP_CODE'					,text:'법인코드'			,type:'string' },
	    	{name: 'DIV_CODE'					,text:'사업장'			,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME_EX'				,text:'부서'				,type:'string' },
	    	{name: 'POST_CODE'					,text:'직위'				,type:'string' },//, comboType:'AU', comboCode:'H005'},
	    	{name: 'NAME'						,text:'성명'				,type:'string' },
	    	{name: 'PERSON_NUMB'				,text:'사번'				,type:'string' , allowBlank: false},

	    	{name: 'MERITS_YEARS'				,text:'고과년도'			,type:'string' ,maxLength:4 , allowBlank: false},
	    	{name: 'MERITS_GUBUN'				,text:'고과구분'			,type:'string' , comboType:'AU' , comboCode:'H095', allowBlank: false},
	    	{name: 'DEPT_NAME'					,text:'근무부서'			,type:'string'},
	    	{name: 'MERITS_CLASS'				,text:'고과등급'			,type:'string' ,maxLength:4},
	    	{name: 'MERITS_GRADE'				,text:'고과점수'			,type:'string' ,maxLength:5},
	    	{name: 'GRADE_PERSON_NUMB'			,text:'평가자사번'			,type:'string' , allowBlank: false},
	    	{name: 'GRADE1_NAME'				,text:'평가자'			,type:'string' , allowBlank: false},
	    	{name: 'GRADE_PERSON_NUMB2'			,text:'평가자2사번'			,type:'string' },
	    	{name: 'GRADE2_NAME'				,text:'평가자2'			,type:'string' },
	    	{name: 'SYNTHETIC_EVAL'				,text:'통합평가'			,type:'string' ,maxLength:50},
	    	
	    	{name: 'INSERT_DB_USER'				,text:'입력자'			,type:'string' },
	    	{name: 'INSERT_DB_TIME'				,text:'입력일'			,type:'uniDate'},
	    	{name: 'UPDATE_DB_USER'				,text:'수정자'			,type:'string' },
	    	{name: 'UPDATE_DB_TIME'				,text:'수정일'			,type:'uniDate'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum309ukrMasterStore',{
			model: 'hum309ukrModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy							
			,loadStoreRecords : function()	{
				var param= panelSearch.getValues();			
				console.log( param );
				this.load({ params : param});
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기
			saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			
    			var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords(); 
	       		
	       		var list = [].concat(toUpdate, toCreate);
				console.log("list:", list);
										 
    			if(inValidRecs.length == 0 )	{
    				config = {
						success: function(batch, option) {		
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);		
							//masterGrid.getStore().loadStoreRecords();
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
			layout : {type : 'uniTable', columns : 1},
			items:[{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
        	Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),
				Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}*/
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '재직구분',
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: '' 
				},{
					boxLabel : '재직', 
					width: 70,
					name: 'RDO_TYPE',
					inputValue: 'A',
					checked: true
					
				},{
					boxLabel: '퇴사', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: 'B'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'고과년도', 
					xtype: 'uniTextfield',
					name: 'MERITS_YEARS_FR', 
					width:195,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('MERITS_YEARS_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'MERITS_YEARS_TO', 
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('MERITS_YEARS_TO', newValue);
						}
					}
				}]
			},{
				fieldLabel: '고과구분',
				name:'MERITS_GUBUN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H095',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MERITS_GUBUN', newValue);
					}
				}
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'고과점수', 
					xtype: 'uniTextfield',
					name: 'MERITS_GRADE_FR', 
					width:195,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('MERITS_GRADE_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'MERITS_GRADE_TO', 
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('MERITS_GRADE_TO', newValue);
						}
					}
				}]
			}]
		},{
				title:'추가정보',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		
        		items:[{
					fieldLabel: '고용형태',
					name:'PAY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H011'
				},{
					fieldLabel: '사원구분',
					name:'EMPLOY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H024'
				},{
					fieldLabel: '급여지급방식',
					name:'PAY_CODE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H028'
				},{
					fieldLabel: '사업명',
					name:'COST_POOL',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('getHumanCostPool')
				},{
					fieldLabel: '급여차수',
					name:'PAY_PROV_FLAG',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H031'
				},{
					fieldLabel: '사원그룹',
					name:'PERSON_GROUP',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H181'
				}]				
		}]
	}); 
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},
        	Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				selectChildren:true,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				colspan:2,
				listeners: {
					
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelSearch.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelSearch.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelSearch.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),
			Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				colspan:2,
				validateBlank:false,
				autoPopup:true,
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					}*/
					
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '재직구분',
				colspan:2,
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: '' 
				},{
					boxLabel : '재직', 
					width: 70,
					name: 'RDO_TYPE',
					inputValue: 'A',
					checked: true
					
				},{
					boxLabel: '퇴사', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: 'B'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'고과년도', 
					xtype: 'uniTextfield',
					name: 'MERITS_YEARS_FR', 
					width:195,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('MERITS_YEARS_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'MERITS_YEARS_TO', 
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('MERITS_YEARS_TO', newValue);
						}
					}
				}]
			},{
				fieldLabel: '고과구분',
				name:'MERITS_GUBUN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H095',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MERITS_GUBUN', newValue);
					}
				}
			},{
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:325,
			items :[{
				fieldLabel:'고과점수', 
				xtype: 'uniTextfield',
				name: 'MERITS_GRADE_FR', 
				width:195,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MERITS_GRADE_FR', newValue);
					}
				}
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'MERITS_GRADE_TO', 
				width: 110,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MERITS_GRADE_TO', newValue);
					}
				}
			}]
		}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum309ukrGrid1', {
    	region: 'center',
        layout: 'fit',
        uniOpt: {
    		expandLastColumn: false,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
        features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        store: directMasterStore,
        columns:  [  
       		 	//{ dataIndex: 'DOC_ID'						, width: 120},
        		//{ dataIndex: 'COMP_CODE'					, width: 100},
        
        		{ dataIndex: 'DIV_CODE'						, width: 120},
        		{ dataIndex: 'DEPT_NAME_EX'					, width: 160},
        		{ dataIndex: 'POST_CODE'					, width: 88},
        		{ dataIndex: 'NAME'							, width: 78,
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnHumanCheck(records);	
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								
			  								grdRecord.set('DIV_CODE','');
			  								grdRecord.set('DEPT_NAME_EX','');
			  								grdRecord.set('POST_CODE','');			
 										}
			 				}
						})
				},
        		{ dataIndex: 'PERSON_NUMB'					, width: 78,
        		'editor' : Unilite.popup('Employee_G',{
						textFieldName:'PERSON_NUMB',
						DBtextFieldName: 'PERSON_NUMB', 
						validateBlank : true,
						autoPopup:true,
	   					listeners: {'onSelected': {
		 								fn: function(records, type) {
		 									UniAppManager.app.fnHumanCheck(records);	
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
										var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME_EX','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},
        		{ dataIndex: 'MERITS_YEARS'					, width: 88 , align: 'center'},
        		{ dataIndex: 'MERITS_GUBUN'					, width: 120},
        		{ dataIndex: 'DEPT_NAME'					, width: 120,
        		'editor' : Unilite.popup('DEPT_G',{
						validateBlank : true,
			  			autoPopup: true,
		  				listeners: {'onSelected':   function(records, type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
					                    	grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('DEPT_NAME','');
 										}
			 				}
						})
				},
        		{ dataIndex: 'MERITS_CLASS'					, width: 120},
        		{ dataIndex: 'MERITS_GRADE'					, width: 120},
        		{ dataIndex: 'GRADE_PERSON_NUMB'			, width: 120,
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected':   function(records, type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
					                    	grdRecord.set('GRADE_PERSON_NUMB',records[0]['PERSON_NUMB']);
					                    	grdRecord.set('GRADE1_NAME'      ,records[0]['NAME']);
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('GRADE_PERSON_NUMB','');
			  								grdRecord.set('GRADE1_NAME','');			
 										}
			 				}
						})
				},
        		{ dataIndex: 'GRADE1_NAME'					, width: 120,
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected':  function(records, type  ){
					                    	var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
					                    	grdRecord.set('GRADE_PERSON_NUMB',records[0]['PERSON_NUMB']);
					                    	grdRecord.set('GRADE1_NAME'      ,records[0]['NAME']);
						                },
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('GRADE_PERSON_NUMB','');
			  								grdRecord.set('GRADE1_NAME','');		
 										}
			 				}
						})
				},
        		{ dataIndex: 'GRADE_PERSON_NUMB2'			, width: 120,
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected':   function(records, type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
					                    	grdRecord.set('GRADE_PERSON_NUMB2',records[0]['PERSON_NUMB']);
					                    	grdRecord.set('GRADE2_NAME'      ,records[0]['NAME']);
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('GRADE_PERSON_NUMB2','');
			  								grdRecord.set('GRADE2_NAME','');			
 										}
			 				}
						})
				},
        		{ dataIndex: 'GRADE2_NAME'					, width: 120,
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected':   function(records, type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
					                    	grdRecord.set('GRADE_PERSON_NUMB2',records[0]['PERSON_NUMB']);
					                    	grdRecord.set('GRADE2_NAME'      ,records[0]['NAME']);
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum309ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('GRADE_PERSON_NUMB2','');
			  								grdRecord.set('GRADE2_NAME','');			
 										}
			 				}
						})
				},
        		{ dataIndex: 'SYNTHETIC_EVAL'				, width: 120}
        		
        		//{ dataIndex: 'INSERT_DB_USER'				, width: 120},
        		//{ dataIndex: 'INSERT_DB_TIME'				, width: 120},
        		//{ dataIndex: 'UPDATE_DB_USER'				, width: 120},
        		//{ dataIndex: 'UPDATE_DB_TIME'				, width: 120}
        	],
        	listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	/*if(e.record.phantom == true) {		// 신규일 때
		        		if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
							return false;
						}
		        	}*/
		        	if(!e.record.phantom == true) { // 신규가 아닐 때
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB', 'MERITS_YEARS', 'MERITS_GUBUN'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
		        		if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_NAME_EX', 'POST_CODE'])) {
							return false;
						}
		        	}
		        } 	
		    }
    });   
	
    Unilite.Main({
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
		id  : 'hum309ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			if(!Ext.isEmpty(gsCostPool)){
				panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
			}
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');
			
			panelSearch.getField('RDO_TYPE').setValue('A');
			panelResult.getField('RDO_TYPE').setValue('A');
			
			UniAppManager.setToolbarButtons(['reset', 'newData'],true);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onNewDataButtonDown: function()	{
			var compCode		 = UserInfo.compCode;
        	
        	var r ={
        		COMP_CODE			: compCode
        	};
            //param = {'SEQ':seq}
	        masterGrid.createRow(r , 'NAME');
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();	
		},
        fnHumanCheck: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);	
			grdRecord.set('DIV_CODE', record.SECT_CODE);
			grdRecord.set('DEPT_NAME_EX', record.DEPT_NAME);	
			grdRecord.set('POST_CODE', record.POST_CODE_NAME);
			grdRecord.set('NAME', record.NAME);
		}
	});
	
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				case "MERITS_YEARS" : // 시작일
				
				if(newValue.length == '4'){
				
					if( 1889 > newValue ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( newValue > 3000){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
				}
				else if(newValue.length > '4'){
					rv="연도는 4자리 숫자만 입력 할 수 있습니다.";
				}
			}
			return rv;
		}
		
	});
	Unilite.createValidator('validator02', {
		forms: {'formA:':panelSearch , 'formB:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				
				case "MERITS_YEARS_FR" : // 고과년도
				
				if(newValue.length == '4'){
				
					if( 1889 > newValue ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( newValue > 3000){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
				}
				else if(newValue.length > '4'){
					rv="연도는 4자리 숫자만 입력 할 수 있습니다.";
				}
				break;
				
				case "MERITS_YEARS_TO" : // 고과년도
				
				if(newValue.length == '4'){
				
					if( 1889 > newValue ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( newValue > 3000){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
				}
				else if(newValue.length > '4'){
					rv="연도는 4자리 숫자만 입력 할 수 있습니다.";
				}
				break;
			}
			return rv;
		}
	});	
};

</script>
