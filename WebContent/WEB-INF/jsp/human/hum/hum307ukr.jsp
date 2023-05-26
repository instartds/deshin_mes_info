<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum307ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum307ukr"/> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H185" /> 				<!-- 휴직산재구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H186" /> 				<!-- 휴직산재원인 -->
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
        	read : 'hum307ukrService.selectList',
        	update: 'hum307ukrService.updateDetail',
			create: 'hum307ukrService.insertDetail',
			destroy: 'hum307ukrService.deleteDetail',
			syncAll: 'hum307ukrService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum307ukrModel', {
	    fields: [
	    
	    	{name: 'DOC_ID'							,text:'DOC_ID'			,type:'string' },
	    	{name: 'COMP_CODE'					,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			,type:'string' },
	    	{name: 'DIV_CODE'						,text:'<t:message code="system.label.human.division" default="사업장"/>'				      ,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'<t:message code="system.label.human.department" default="부서"/>'					,type:'string' },
	    	{name: 'POST_CODE'						,text:'<t:message code="system.label.human.postcode" default="직위"/>'				,type:'string' },//, comboType:'AU', comboCode:'H005'},
	    	{name: 'NAME'								,text:'<t:message code="system.label.human.name" default="성명"/>'					,type:'string' },
	    	{name: 'PERSON_NUMB'				,text:'<t:message code="system.label.human.personnumb" default="사번"/>'				,type:'string'  ,allowBlank: false},
	    	{name: 'OFF_CODE1'						,text:'<t:message code="system.label.human.offcode" default="휴직산재구분"/>'		   ,type:'string'  , comboType:'AU', comboCode:'H185' , allowBlank: false},
	    	{name: 'FROM_DATE'					,text:'<t:message code="system.label.human.startdate" default="시작일"/>'			 ,type:'uniDate' , allowBlank: false},
	    	{name: 'TO_DATE'							,text:'<t:message code="system.label.human.enddate" default="종료일"/>'			   ,type:'uniDate' ,allowBlank: false},
	    	{name: 'YEAR_APPLY_YN'                          ,text:'연차포함여부'                                                            ,type:'boolean'},
	    	{name: 'OFF_CODE2'						,text:'<t:message code="system.label.human.offcode2" default="휴직산재원인 명칭"/>'		,type:'string'  , comboType:'AU', comboCode:'H186' , allowBlank: false },
	    	{name: 'SLRY_APLC_YM'				,text:'<t:message code="system.label.human.slryaplcym" default="급여적용년월"/>'		,type:'string' },
	    	{name: 'DS_TITLE'							,text:'<t:message code="system.label.human.dstitle" default="휴직산재 내역"/>'		,type:'string'  ,maxLength:500},
	    	{name: 'MEMO'								,text:'<t:message code="system.label.human.remark" default="비고"/>'				,type:'string'  ,maxLength:1000},
	    	{name: 'INSERT_DB_USER'			,text:'<t:message code="system.label.human.accntperson" default="입력자"/>'			,type:'string' },
	    	{name: 'INSERT_DB_TIME'				,text:'<t:message code="system.label.human.inputdate" default="입력일"/>'			,type:'uniDate'},
	    	{name: 'UPDATE_DB_USER'			,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type:'string' },
	    	{name: 'UPDATE_DB_TIME'			,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type:'uniDate'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum307ukrMasterStore',{
			model: 'hum307ukrModel',
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
    			
    			var isErro = false;
    			var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords(); 
	       		
	       		var list = [].concat(toUpdate, toCreate);
				console.log("list:", list);
	
				Ext.each(list, function(record, index) {			// 저장 하기전 일자 확인
					if(record.data['FROM_DATE'] > record.data['TO_DATE']) {
						alert('<t:message code="system.message.human.message024" default="시작일이 종료일보다 큽니다."/>');
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
								//masterGrid.getStore().loadStoreRecords();
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
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout : {type : 'uniTable', columns : 1},
			items:[{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
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
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: '' 
				},{
					boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
					width: 70,
					name: 'RDO_TYPE',
					inputValue: 'A',
					checked: true
					
				},{
					boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
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
				fieldLabel: '<t:message code="system.label.human.offcode" default="휴직산재구분"/>',
				name:'OFF_CODE1',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H185',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('OFF_CODE1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.offcodename2" default="휴직산재원인"/>',
				name:'OFF_CODE2',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H186',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('OFF_CODE2', newValue);
					}
				}
			},{ 
    			fieldLabel: '<t:message code="system.label.human.leavedisastertime" default="휴직/산재기간"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FROM_DATE',
		        endFieldName: 'TO_DATE',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FROM_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
	        }]
		},{
				fieldLabel: '      ',
				xtype: 'radiogroup',
				items: [{
					boxLabel: '<t:message code="system.label.human.startdate" default="시작일"/>', 
					width: 70, 
					name: 'DATE_TYPE',
					inputValue: 'FR',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.enddate" default="종료일"/>', 
					width: 70,
					name: 'DATE_TYPE',
					inputValue: 'TO'
					
					
				},{
					boxLabel: '<t:message code="system.label.human.range" default="범위"/>', 
					width: 70, 
					name: 'DATE_TYPE',
					inputValue: 'ALL'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('DATE_TYPE').setValue(newValue.DATE_TYPE);
					}
				}
			},{
				title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		
        		items:[{
					fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
					name:'PAY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H011'
				},{
					fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
					name:'EMPLOY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H024'
				},{
					fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
					name:'PAY_CODE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H028'
				},{
					fieldLabel: '<t:message code="system.label.human.pjtname" default="사업명"/>',
					name:'COST_POOL',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('getHumanCostPool')
				},{
					fieldLabel: '<t:message code="system.label.human.payprovflag3" default="급여차수"/>',
					name:'PAY_PROV_FLAG',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H031'
				},{
					fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
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
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				colspan:2,
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
						panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
					}
					
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
				colspan:2,
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: '' 
				},{
					boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
					width: 70,
					name: 'RDO_TYPE',
					inputValue: 'A',
					checked: true
					
				},{
					boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
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
				fieldLabel: '<t:message code="system.label.human.offcode" default="휴직산재구분"/>',
				name:'OFF_CODE1',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H185',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('OFF_CODE1', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.offcodename2" default="휴직산재원인"/>',
				name:'OFF_CODE2',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H186',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('OFF_CODE2', newValue);
					}
				}
			},{ 
    			fieldLabel: '<t:message code="system.label.human.leavedisastertime" default="휴직/산재기간"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FROM_DATE',
		        endFieldName: 'TO_DATE',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('FROM_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}
			    }
	        },{
				xtype: 'radiogroup',		            		
				colspan:2,
				items: [{
					boxLabel: '<t:message code="system.label.human.startdate" default="시작일"/>', 
					width: 70, 
					name: 'DATE_TYPE',
					inputValue: 'FR' ,
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.enddate" default="종료일"/>', 
					width: 70,
					name: 'DATE_TYPE',
					inputValue: 'TO'					
				},{
					boxLabel: '<t:message code="system.label.human.range" default="범위"/>', 
					width: 70, 
					name: 'DATE_TYPE',
					inputValue: 'ALL'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('DATE_TYPE').setValue(newValue.DATE_TYPE);
					}
				}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum307ukrGrid1', {
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
        		{ dataIndex: 'DEPT_NAME'					, width: 160},
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
			 								var grdRecord = Ext.getCmp('hum307ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								
			  								grdRecord.set('DIV_CODE','');
			  								grdRecord.set('DEPT_NAME','');
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
										var grdRecord = Ext.getCmp('hum307ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},
        		{ dataIndex: 'OFF_CODE1'			, width: 100},
        		{ dataIndex: 'FROM_DATE'			, width: 100},
        		{ dataIndex: 'TO_DATE'				, width: 100},
        		{ dataIndex: 'YEAR_APPLY_YN'        , width: 100  , xtype: 'checkcolumn',align:'center'
//                        listeners:{
//                            checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
//                                var grdRecord = masterGrid.getStore().getAt(rowIndex);
//                                if(checked == true){
//                                    if(grdRecord.get('EX_CLOSE_FG') == 'N'){
//                                        grdRecord.set('EX_CLOSE_FG','Y');
//                                    }else{
//                                        grdRecord.set('EX_CLOSE_FG','N');
//                                    }
//                                }else{
//                                    grdRecord.set('EX_CLOSE_FG',grdRecord.get('EX_CLOSE_FG_DUMMY'));
//                                }
//                            }
//                        }
        		},
        		{ dataIndex: 'OFF_CODE2'			, width: 150,
                    listeners:{
                        render:function(elm)    {
                            var tGrid = elm.getView().ownerGrid;
                            elm.editor.on('beforequery',function(queryPlan, eOpts)  {
                                
                                var grid = tGrid;
                                var record = grid.uniOpt.currentRecord;
                                
                                var store = queryPlan.combo.store;
                                store.clearFilter();
                                store.filterBy(function(item){
                                    return item.get('refCode3') == record.get('OFF_CODE1');
                                })
                            });
                            elm.editor.on('collapse',function(combo,  eOpts )   {
                                var store = combo.store;
                                store.clearFilter();
                            });
                        }
                    }
        		},
        		
        		{ dataIndex: 'SLRY_APLC_YM'          , width: 100, align:'center'},

        		{ dataIndex: 'DS_TITLE'				, width: 300},
        		{ dataIndex: 'MEMO'					, width: 300}
        		
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
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB', 'OUT_FROM_DATE'])) {
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
		id  : 'hum307ukrApp',
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
			grdRecord.set('DEPT_NAME', record.DEPT_NAME);
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
				case "OFF_CODE1" : //휴직산재구분
				    record.set('OFF_CODE2', '');
				    break;
				    
				case "FROM_DATE" : // 시작일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					break;
				
				case "TO_DATE" : // 종료일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					break;
				
			}
			return rv;
		}
	}); // validator
};

</script>
