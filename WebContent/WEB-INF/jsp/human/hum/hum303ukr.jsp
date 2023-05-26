<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum303ukr"  >
	<t:ExtComboStore comboType="BOR120"	/> 								<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H088" /> 				<!-- 비자구분 -->
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
        	read : 'hum303ukrService.selectList',
        	update: 'hum303ukrService.updateDetail',
			create: 'hum303ukrService.insertDetail',
			destroy: 'hum303ukrService.deleteDetail',
			syncAll: 'hum303ukrService.saveAll'
        }
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hum303ukrService.selectList2',
        	update: 'hum303ukrService.updateDetail2',
			create: 'hum303ukrService.insertDetail2',
			destroy: 'hum303ukrService.deleteDetail2',
			syncAll: 'hum303ukrService.saveAll2'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum303ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'					,text:'법인코드'				,type:'string'},
	    	{name: 'DIV_CODE'					,text:'사업장'				,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'부서'					,type:'string' },
	    	{name: 'POST_CODE'					,text:'직위'					,type:'string' ,comboType:'AU' , comboCode:'H005'},
	    	{name: 'NAME'						,text:'성명'					,type:'string' },
	    	{name: 'PERSON_NUMB'				,text:'사번'					,type:'string' ,allowBlank: false},
	    	
	    	{name: 'PASS_NO'					,text:'여권번호'				,type:'string' ,maxLength:40 ,allowBlank: false},
	    	{name: 'PASS_KIND'					,text:'여권구분'				,type:'string' ,comboType:'AU' , comboCode:'H088'},
	    	{name: 'PASS_NATION_NAME'			,text:'여권발행국가'			,type:'string' },
	    	{name: 'PASS_ISSUE_DATE'			,text:'발급일'				,type:'uniDate'},
	    	{name: 'PASS_TERMI_DATE'			,text:'만료일'				,type:'uniDate'},
	    	
	    	{name: 'INSERT_DB_USER'				,text:'입력자'				,type:'string'},
	    	{name: 'INSERT_DB_TIME'				,text:'입력일'				,type:'uniDate'},
	    	{name: 'UPDATE_DB_USER'				,text:'수정자'				,type:'string'},
	    	{name: 'UPDATE_DB_TIME'				,text:'수정일'				,type:'uniDate'}
		]
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum303ukrModel2', {
	    fields: [
	    	{name: 'COMP_CODE'					,text:'법인코드'				,type:'string'},
	    	{name: 'DIV_CODE'					,text:'사업장'				,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'부서'					,type:'string' },
	    	{name: 'POST_CODE'					,text:'직위'					,type:'string' ,comboType:'AU' , comboCode:'H005'},
	    	{name: 'NAME'						,text:'성명'					,type:'string' },
	    	{name: 'PERSON_NUMB'				,text:'사번'					,type:'string' ,allowBlank: false},
	    	
	    	{name: 'PASS_NO'					,text:'여권번호'				,type:'string' ,maxLength:40 ,allowBlank: false},
	    	{name: 'VISA_NO'					,text:'비자번호'				,type:'string' ,allowBlank: false ,maxLength:40},
	    	{name: 'VISA_NATION_NAME'			,text:'비자발행국가'			,type:'string' },
	    	{name: 'VISA_GUBUN'					,text:'비자구분'		 		,type:'string' ,comboType:'AU' , comboCode:'H088'},
	    	{name: 'VISA_KIND'					,text:'비자종류'				,type:'string' },
	    	{name: 'VALI_DATE'					,text:'유효일'				,type:'uniDate'},
	    	{name: 'DURATION_STAY'				,text:'체류가능일'				,type:'uniNumber',maxLength:4},
	    	{name: 'VISA_TERMI_DATE'			,text:'만료일'				,type:'uniDate'}, 
	    	{name: 'VISA_ISSUE_DATE'			,text:'발급일'				,type:'uniDate'},
	    	{name: 'ISSUE_AT'					,text:'발급지'				,type:'string' ,maxLength:40},
	    	
	    	{name: 'INSERT_DB_USER'				,text:'입력자'				,type:'string'},
	    	{name: 'INSERT_DB_TIME'				,text:'입력일'				,type:'uniDate'},
	    	{name: 'UPDATE_DB_USER'				,text:'수정자'				,type:'string'},
	    	{name: 'UPDATE_DB_TIME'				,text:'수정일'				,type:'uniDate'},
	    	
	    	{name: 'VISA_CHECK'					,text:'비자확인'				,type:'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum303ukrMasterStore',{
			model: 'hum303ukrModel',
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
			saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			
    			var isErro = false;
    			var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords(); 
	       		
	       		var list = [].concat(toUpdate, toCreate);
				console.log("list:", list);
	
				Ext.each(list, function(record, index) {			// 저장 하기전 비자기간 비교
					if(record.data['PASS_ISSUE_DATE'] >= record.data['PASS_TERMI_DATE']) {
						alert('발급일이 만료일보다 클 수 없습니다.');
						isErro = true;
						return false;								// 값이 클 경우 저장 안함
					}
				});			
    			if(!isErro){										 
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
            }
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore2 = Unilite.createStore('hum303ukrMasterStore2',{
			model: 'hum303ukrModel2',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy2							
			,loadStoreRecords : function()	{
				var param= panelSearch.getValues();			
				console.log( param );
				this.load({ params : param});
			},
			
			saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			
    			var isErro = false;
    			var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords(); 
	       		
	       		var list = [].concat(toUpdate, toCreate);
				console.log("list:", list);
	
				Ext.each(list, function(record, index) {			// 저장 하기전 과세표준 값 비교
					if(record.data['ENTR_DATE'] >= record.data['GRAD_DATE']) {
						alert('시작일이 종료일보다 큽니다.');
						isErro = true;
						return false;								// 값이 클 경우 저장 안함
					}
				});			
    			if(!isErro){										 
	    			if(inValidRecs.length == 0 )	{
	    				config = {
							success: function(batch, option) {		
								panelResult.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);		
							 } 
						};	
	    				this.syncAllDirect(config);		
	    			}else {
	    				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
	    			}
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
				fieldLabel: '여권발행국가',
				name:'PASS_NATION',
				xtype: 'uniTextfield',
				itemId : 'viewPass1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PASS_NATION', newValue);
					}
				}
			},{ 
    			fieldLabel: '만료일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_PASS_TERMI_DATE',
		        endFieldName: 'TO_PASS_TERMI_DATE',
		        itemId : 'viewPass2',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_PASS_TERMI_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PASS_TERMI_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel: '비자발행국가',
				name:'VISA_NATION',
				xtype: 'uniTextfield',
				itemId : 'viewVisa1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('VISA_NATION', newValue);
					}
				}
			},{ 
    			fieldLabel: '비자유효일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_VALI_DATE',
		        endFieldName: 'TO_VALI_DATE',
		        itemId : 'viewVisa2',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_VALI_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_VALI_DATE',newValue);
			    	}
			    }
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
					//comboType:'CBM600'
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
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
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
    			colspan:3,
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
				fieldLabel: '여권발행국가',
				name:'PASS_NATION',
				xtype: 'uniTextfield',
				itemId : 'viewPass1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PASS_NATION', newValue);
					}
				}
			},{ 
    			fieldLabel: '여권만료일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_PASS_TERMI_DATE',
		        endFieldName: 'TO_PASS_TERMI_DATE',
		        itemId : 'viewPass2',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('FR_PASS_TERMI_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_PASS_TERMI_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel: '비자발행국가',
				name:'VISA_NATION',
				xtype: 'uniTextfield',
				itemId : 'viewVisa1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('VISA_NATION', newValue);
					}
				}
			},{ 
    			fieldLabel: '비자유효일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_VALI_DATE',
		        endFieldName: 'TO_VALI_DATE',
		        itemId : 'viewVisa2',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('FR_VALI_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_VALI_DATE',newValue);
			    	}
			    }
	        }]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum303ukrGrid1', {
    	title : '여권',
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
        		//{ dataIndex: 'COMP_CODE'					, width: 100}, 
        		{ dataIndex: 'DIV_CODE'						, width: 120}, 
        		{ dataIndex: 'DEPT_NAME'					, width: 160}, 
        		{ dataIndex: 'POST_CODE'					, width: 100},
        		{ dataIndex: 'NAME'							, width: 100,
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
			 								var grdRecord = Ext.getCmp('hum303ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								
			  								grdRecord.set('DIV_CODE','');
			  								grdRecord.set('DEPT_NAME','');
			  								grdRecord.set('POST_CODE','');			
 										}
			 				}
						})
				},
        		{ dataIndex: 'PERSON_NUMB'					, width: 100,
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
										var grdRecord = Ext.getCmp('hum303ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},
        		{ dataIndex: 'PASS_NO'					, width: 120},
        		{ dataIndex: 'PASS_KIND'				, width: 100},
        		{ dataIndex: 'PASS_NATION_NAME'			, width: 200},
        		{ dataIndex: 'PASS_ISSUE_DATE'			, width: 100},
        		{ dataIndex: 'PASS_TERMI_DATE'			, width: 100}
        	],
        	listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	if(!e.record.phantom == true) { // 신규가 아닐 때
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB' , 'PASS_NO'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
		        		if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_NAME', 'POST_CODE'])) {
							return false;
						}
		        	}
		        } 	
		    }
    });   
    
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid2 = Unilite.createGrid('hum303ukrGrid2', {
    	title : '비자',
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
        store: directMasterStore2,
        columns:  [  
        		//{ dataIndex: 'COMP_CODE'					, width: 100}, 
        		{ dataIndex: 'DIV_CODE'						, width: 120}, 
        		{ dataIndex: 'DEPT_NAME'					, width: 160}, 
        		{ dataIndex: 'POST_CODE'					, width: 100},
        		{ dataIndex: 'NAME'							, width: 100,
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
			  			autoPopup: true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnHumanCheck(records);	
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum303ukrGrid2').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								
			  								grdRecord.set('DIV_CODE','');
			  								grdRecord.set('DEPT_NAME','');
			  								grdRecord.set('POST_CODE','');			
 										}
			 				}
						})
				},
        		{ dataIndex: 'PERSON_NUMB'					, width: 100,
        		'editor' : Unilite.popup('Employee_G',{
						textFieldName:'PERSON_NUMB',
						DBtextFieldName: 'PERSON_NUMB', 
						validateBlank : true,
			  			autoPopup: true,
	   					listeners: {'onSelected': {
		 								fn: function(records, type) {
		 									UniAppManager.app.fnHumanCheck(records);	
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
										var grdRecord = Ext.getCmp('hum303ukrGrid2').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},
        		{ dataIndex: 'PASS_NO'					, width: 120},
        		{ dataIndex: 'VISA_NO'					, width: 120},
        		{ dataIndex: 'VISA_NATION_NAME'			, width: 200},
        		{ dataIndex: 'VISA_GUBUN'				, width: 100},
        		{ dataIndex: 'VISA_KIND'				, width: 100},
        		{ dataIndex: 'VALI_DATE'				, width: 100},
        		{ dataIndex: 'DURATION_STAY'			, width: 95},
        		{ dataIndex: 'VISA_TERMI_DATE'			, width: 100},
        		{ dataIndex: 'VISA_ISSUE_DATE'			, width: 100},
        		{ dataIndex: 'ISSUE_AT'					, width: 200}
        	],
        	listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
		        	/*if(e.record.phantom == true) {		// 신규일 때
		        		if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
							return false;
						}
		        	}*/
		        	if(!e.record.phantom == true) { // 신규가 아닐 때
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB' , 'PASS_NO' , 'VISA_NO'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
		        		if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_NAME', 'POST_CODE'])) {
							return false;
						}
		        	}
		        } 	
		    }
    });   
    
    
    var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab:  0,
	    region: 'center',
	    items:  [
	         masterGrid,
	         masterGrid2
	    ],
	    listeners:{
	    	beforetabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			if(newCard.getItemId() == 'hum303ukrGrid1')	{  				
    				panelSearch.down('#viewPass1').setVisible(true);
					panelResult.down('#viewPass1').setVisible(true);
					panelSearch.down('#viewPass2').setVisible(true);
					panelResult.down('#viewPass2').setVisible(true);
					
					panelSearch.down('#viewVisa1').setVisible(false);
					panelResult.down('#viewVisa1').setVisible(false);
					panelSearch.down('#viewVisa2').setVisible(false);
					panelResult.down('#viewVisa2').setVisible(false);
    				
    			}else if(newCard.getItemId() == 'hum303ukrGrid2') {
    				panelSearch.down('#viewPass1').setVisible(false);
					panelResult.down('#viewPass1').setVisible(false);
					panelSearch.down('#viewPass2').setVisible(false);
					panelResult.down('#viewPass2').setVisible(false);
					
					panelSearch.down('#viewVisa1').setVisible(true);
					panelResult.down('#viewVisa1').setVisible(true);
					panelSearch.down('#viewVisa2').setVisible(true);
					panelResult.down('#viewVisa2').setVisible(true);
    			}
    		},
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			if(newCard.getItemId() == 'hum303ukrGrid1')	{
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'hum303ukrGrid2') {
    				UniAppManager.app.onQueryButtonDown();
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
            	tab, panelResult
	     	]
	     },
	         panelSearch
	    ], 
		id  : 'hum303ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);

			panelSearch.down('#viewPass1').setVisible(true);
			panelResult.down('#viewPass1').setVisible(true);
			panelSearch.down('#viewPass2').setVisible(true);
			panelResult.down('#viewPass2').setVisible(true);	
			
			panelSearch.down('#viewVisa1').setVisible(false);
			panelResult.down('#viewVisa1').setVisible(false);
			panelSearch.down('#viewVisa2').setVisible(false);
			panelResult.down('#viewVisa2').setVisible(false);
			
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
			var activeTabId = tab.getActiveTab().getId();		
			
			if(activeTabId == 'hum303ukrGrid1'){				
				directMasterStore.loadStoreRecords();
			}
			else if(activeTabId == 'hum303ukrGrid2'){
				directMasterStore2.loadStoreRecords();
			}		
		},
		onNewDataButtonDown: function()	{
			
			var activeTabId = tab.getActiveTab().getId();	
			var compCode		 = UserInfo.compCode; 
			
        	var r ={
        		COMP_CODE			: compCode
        	};
        	
        	if(activeTabId == 'hum303ukrGrid1'){
        		masterGrid.createRow(r , 'NAME');
        	}
        	else if(activeTabId == 'hum303ukrGrid2'){
        		masterGrid2.createRow(r , 'NAME');
        	}
		},
		onResetButtonDown:function() {
			var activeTabId = tab.getActiveTab().getId();	
			if(activeTabId == 'hum303ukrGrid1'){
				panelSearch.clearForm();
				panelResult.clearForm();
				masterGrid.getStore().loadData({});
	
				this.fnInitBinding();
			}
			else if(activeTabId == 'hum303ukrGrid2'){
				panelSearch.clearForm();
				panelResult.clearForm();
				masterGrid2.getStore().loadData({});
	
				this.fnInitBinding();
			}
		},
		onSaveDataButtonDown: function (config) {
			var activeTabId = tab.getActiveTab().getId();	
			if(activeTabId == 'hum303ukrGrid1'){
				directMasterStore.saveStore(config);
			}
			else if(activeTabId == 'hum303ukrGrid2'){
				directMasterStore2.saveStore(config);
			}
		},
		onDeleteDataButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();	
			if(activeTabId == 'hum303ukrGrid1'){
				masterGrid.deleteSelectedRow();	
			}
			if(activeTabId == 'hum303ukrGrid2'){
				masterGrid2.deleteSelectedRow();	
			}
		},
        fnHumanCheck: function(records) {
        	var activeTabId = tab.getActiveTab().getId();
        	if(activeTabId == 'hum303ukrGrid1'){
				grdRecord = masterGrid.getSelectedRecord();
        	}
			if(activeTabId == 'hum303ukrGrid2'){
				grdRecord = masterGrid2.getSelectedRecord();
        	}
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);
			
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.SECT_CODE);
			}
			
			if(Ext.isEmpty(grdRecord.get('DEPT_NAME'))){
				grdRecord.set('DEPT_NAME', record.DEPT_NAME);
			}
			
			if(Ext.isEmpty(grdRecord.get('POST_CODE_NAME'))){
				grdRecord.set('POST_CODE', record.POST_CODE);
			}
			
			if(Ext.isEmpty(grdRecord.get('NAME'))){
				grdRecord.set('NAME', record.NAME);
			}
		}
	});
	
	/*여권*/
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {	
				case "PASS_TERMI_DATE" : // 만료일
				if( 18891231 > UniDate.getDbDateStr(newValue) ){
					rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
					break;
				}
				if ( UniDate.getDbDateStr(newValue) > 30000101){
					rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
					break;
				}
				break;
				
				case "PASS_ISSUE_DATE" : // 발급일
				if( 18891231 > UniDate.getDbDateStr(newValue) ){
					rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
					break;
				}
				if ( UniDate.getDbDateStr(newValue) > 30000101){
					rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
					break;
				}
				break;	
			}
			return rv;
		}
	});
	
	
	/*비자*/
	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				case "VISA_TERMI_DATE" : // 만료일
				if( 18891231 > UniDate.getDbDateStr(newValue) ){
					rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
					break;
				}
				if ( UniDate.getDbDateStr(newValue) > 30000101){
					rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
					break;
				}
				break;
				
				case "VISA_ISSUE_DATE" : // 발급일
				if( 18891231 > UniDate.getDbDateStr(newValue) ){
					rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
					break;
				}
				if ( UniDate.getDbDateStr(newValue) > 30000101){
					rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
					break;
				}
				break;
			}
			return rv;
		}
	});
};

</script>
