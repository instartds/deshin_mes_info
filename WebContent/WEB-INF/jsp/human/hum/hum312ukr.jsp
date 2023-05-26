<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum312ukr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum312ukr"/> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H096" /> 				<!-- 상벌종류 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
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
        	read : 'hum312ukrService.selectList',
        	update: 'hum312ukrService.updateDetail',
			create: 'hum312ukrService.insertDetail',
			destroy: 'hum312ukrService.deleteDetail',
			syncAll: 'hum312ukrService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum312ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'					,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type:'string'},
	    	{name: 'DIV_CODE'						,text:'<t:message code="system.label.human.division" default="사업장"/>'				,type:'string' ,allowBlank: false , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'<t:message code="system.label.human.department" default="부서"/>'					,type:'string' ,allowBlank: false},
	    	{name: 'POST_CODE'						,text:'<t:message code="system.label.human.postcode" default="직위"/>'				,type:'string' ,allowBlank: false},
	    	{name: 'NAME'								,text:'<t:message code="system.label.human.name" default="성명"/>'					,type:'string' ,allowBlank: false},
	    	{name: 'PERSON_NUMB'				,text:'<t:message code="system.label.human.personnumb" default="사번"/>'				,type:'string' ,allowBlank: false},
	    	{name: 'OCCUR_DATE'					,text:'<t:message code="system.label.human.occurdate" default="발생일자"/>'			,type:'uniDate',allowBlank: false},
	    	{name: 'KIND_PRIZE_PENALTY'	,text:'<t:message code="system.label.human.kindprizepenalty" default="상벌종류"/>'			,type:'string' ,allowBlank: false , comboType: 'AU', comboCode:'H096'},
	    	{name: 'SLRY_APLC_YM'			    ,text:'<t:message code="system.label.human.slryaplcym" default="급여적용년월"/>'	    ,type:'string'},
	    	{name: 'NAME_PRIZE_PENALTY'	,text:'<t:message code="system.label.human.nameprizepenalty" default="상벌명"/>'			,type:'string' , maxLength:20},
	    	{name: 'REASON'							,text:'<t:message code="system.label.human.reason" default="사유"/>'				,type:'string' , maxLength:100},
	    	{name: 'VALIDITYFR_DATE'			,text:'<t:message code="system.label.human.validityfrdate" default="징계기간 시작일"/>'		,type:'uniDate'},
	    	{name: 'VALIDITY_DATE'				,text:'<t:message code="system.label.human.validitydate1" default="징계기간 종료일"/>'		,type:'uniDate'},
	    	{name: 'VALIDITYTO_DATE'			,text:'<t:message code="system.label.human.validitytodate" default="징계기간 승급제한일"/>'	,type:'uniDate'},
	    	{name: 'EX_DATE'							,text:'<t:message code="system.label.human.punishabodate" default="징계말소일자"/>'		,type:'uniDate'},
	    	{name: 'ADDITION_POINT'			,text:'<t:message code="system.label.human.additionpoint" default="가산점"/>'			,type:'string' , maxLength:5},
	    	{name: 'RELATION_ORGAN'			,text:'<t:message code="system.label.human.relationorgan" default="관련기관"/>'			,type:'string' , maxLength:20},
		    {name: 'INSERT_DB_USER'			,text:'<t:message code="system.label.human.accntperson" default="입력자"/>'				,type:'string'},
	    	{name: 'INSERT_DB_TIME'				,text:'<t:message code="system.label.human.inputdate" default="입력일"/>'				,type:'uniDate'},
	    	{name: 'UPDATE_DB_USER'			,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type:'string'},
	    	{name: 'UPDATE_DB_TIME'			,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type:'uniDate'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum312ukrMasterStore',{
			model: 'hum312ukrModel',
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
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기
			,saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{										
					config = {
							success: function(batch, option) {								
								panelResult.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);								
								//directMasterStore.loadStoreRecords();	
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
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.rewardtype" default="상벌구분"/>',
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'SANCTION_TYPE',
					inputValue: '',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.human.paving" default="포상"/>', 
					width: 70,
					name: 'SANCTION_TYPE',
					inputValue: 'A'
				},{
					boxLabel: '<t:message code="system.label.human.validity" default="징계"/>', 
					width: 70, 
					name: 'SANCTION_TYPE',
					inputValue: 'B'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('SANCTION_TYPE').setValue(newValue.SANCTION_TYPE);
					}
				}
			},
				Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
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
					boxLabel: '<t:message code="system.label.human.retr" default="퇴사"/>', 
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
    			fieldLabel: '<t:message code="system.label.human.occurdate1" default="발생기간"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'CUR_FR_DATE',
		        endFieldName: 'CUR_TO_DATE',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('CUR_FR_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('CUR_TO_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel: '<t:message code="system.label.human.kindprizepenalty" default="상벌종류"/>',
				name:'KIND_PRIZE_PENALTY',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H096',
				hidden : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('KIND_PRIZE_PENALTY', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.nameprizepenalty" default="상벌명"/>',
				name:'NAME_PRIZE_PENALTY',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('NAME_PRIZE_PENALTY', newValue);
					}
				}
			},{ 
    			fieldLabel: '<t:message code="system.label.human.disciplinedate" default="징계기간"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_DATE',
		        endFieldName: 'TO_DATE',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
	        }]
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
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.rewardtype" default="상벌구분"/>',
				colspan:2,
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'SANCTION_TYPE',
					inputValue: '',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.paving" default="포상"/>', 
					width: 70,
					name: 'SANCTION_TYPE',
					inputValue: 'A'
				},{
					boxLabel: '<t:message code="system.label.human.validity" default="징계"/>', 
					width: 70, 
					name: 'SANCTION_TYPE',
					inputValue: 'B'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('SANCTION_TYPE').setValue(newValue.SANCTION_TYPE);
					}
				}
			},
			Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
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
                fieldLabel: '<t:message code="system.label.human.nameprizepenalty" default="상벌명"/>',
                name:'NAME_PRIZE_PENALTY',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('NAME_PRIZE_PENALTY', newValue);
                    }
                }
			},
            {
				xtype: 'radiogroup',		            		
				colspan:2,
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
						panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			},{ 
    			fieldLabel: '<t:message code="system.label.human.occurdate1" default="발생기간"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'CUR_FR_DATE',
		        endFieldName: 'CUR_TO_DATE',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('CUR_FR_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('CUR_TO_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel: '<t:message code="system.label.human.kindprizepenalty" default="상벌종류"/>',
				name:'KIND_PRIZE_PENALTY',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H096',
				hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('KIND_PRIZE_PENALTY', newValue);
					}
				}
			},{ 
    			fieldLabel: '<t:message code="system.label.human.disciplinedate1" default="징계기간"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_DATE',
		        endFieldName: 'TO_DATE',
		        width: 315,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('FR_DATE',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}
			    }
	        }]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum312ukrGrid1', {
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
//        tbar:[
//        	'->',
//        	{
//	        	xtype:'button',
//	        	text:'표창대장 출력',
//	        	handler:function()	{
//	        		if(masterGrid.getSelectedRecords().length > 0 ){
//	        				alert("표창대장 레포트를 만들어주세요.");
//			    		}
//			    		else{
//			    			alert("선택된 자료가 없습니다.");
//			    		}
//	        		}
//        	},{
//	        	xtype:'button',
//	        	text:'징계대장 출력',
//	        	handler:function()	{
//	        		if(masterGrid.getSelectedRecords().length > 0 ){
//		    			alert("징계대장 레포트를 만들어주세요.");
//		    		}
//		    		else{
//		    			alert("선택된 자료가 없습니다.");
//		    		}
//        		}
//        	}
//        	
//        ],
        store: directMasterStore,
        columns:  [  
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
			 								var grdRecord = Ext.getCmp('hum312ukrGrid1').uniOpt.currentRecord;
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
										var grdRecord = Ext.getCmp('hum312ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},
        		{ dataIndex: 'OCCUR_DATE'					, width: 88},
        		{ dataIndex: 'KIND_PRIZE_PENALTY'			, width: 88},
        		
        		{ dataIndex: 'SLRY_APLC_YM'				, width: 130, align:'center'},
        		
        		{ dataIndex: 'NAME_PRIZE_PENALTY'			, width: 120},
        		{ dataIndex: 'REASON'						, width: 230},
        		
        		{ dataIndex: 'VALIDITYFR_DATE'				, width: 110},
        		{ dataIndex: 'VALIDITY_DATE'				, width: 110},
        		{ dataIndex: 'VALIDITYTO_DATE'				, width: 130},
        		
        		{ dataIndex: 'EX_DATE'						, width: 88},
        		{ dataIndex: 'ADDITION_POINT'				, width: 88 , align:'right'},
        		{ dataIndex: 'RELATION_ORGAN'				, width: 200}
        		
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
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB', 'OCCUR_DATE', 'KIND_PRIZE_PENALTY'])) {
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
		id  : 'hum312ukrApp',
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
			var kindPrizePenalty = panelSearch.getValue('KIND_PRIZE_PENALTY');
        	
        	var r ={
        		COMP_CODE			: compCode,
        		KIND_PRIZE_PENALTY  : kindPrizePenalty

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
				case "VALIDITYFR_DATE" : // 징계기간 시작일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					break;
				
				case "VALIDITY_DATE" : // 징계기간 종료일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					break;
				
				case "VALIDITYTO_DATE" : // 징계기간 승급제한일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv='<t:message code="system.message.human.message023" default="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다."/>';
						break;
					}
					break;
				
				case "EX_DATE" : // 징계말소일자
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
