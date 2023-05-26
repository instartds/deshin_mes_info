<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum305ukr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum305ukr" /> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H092" /> 				<!-- 외국어구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H093" /> 				<!-- 시험종류 -->
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
        	read : 'hum305ukrService.selectList',
        	update: 'hum305ukrService.updateDetail',
			create: 'hum305ukrService.insertDetail',
			destroy: 'hum305ukrService.deleteDetail',
			syncAll: 'hum305ukrService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum305ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'					,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			,type:'string' },
	    	{name: 'DIV_CODE'						,text:'<t:message code="system.label.human.division" default="사업장"/>'			,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'<t:message code="system.label.human.department" default="부서"/>'				,type:'string' },
	    	{name: 'POST_CODE'						,text:'<t:message code="system.label.human.postcode" default="직위"/>'				,type:'string' },
	    	{name: 'NAME'								,text:'<t:message code="system.label.human.name" default="성명"/>'				,type:'string' },
	    	{name: 'PERSON_NUMB'				,text:'<t:message code="system.label.human.personnumb" default="사번"/>'				,type:'string' ,allowBlank: false},
	    	{name: 'FOREIGN_KIND'				,text:'<t:message code="system.label.human.foreignkind" default="외국어구분"/>'			,type:'string'  ,allowBlank: false , comboType:'AU', comboCode:'H092'},
	    	{name: 'EXAM_KIND'						,text:'<t:message code="system.label.human.examkind" default="시험종류"/>'			,type:'string'  ,allowBlank: false , comboType:'AU', comboCode:'H093'},
	    	{name: 'GAIN_DATE'						,text:'<t:message code="system.label.human.gaindate" default="취득년월"/>'			,type:'string'  ,allowBlank: false}, // uniMonth 같은 xtype 이 필요함
	    	{name: 'GRADES'							,text:'<t:message code="system.label.human.grades" default="점수"/>'				,type:'string' ,maxLength:4},
	    	{name: 'CLASS'								,text:'<t:message code="system.label.human.grade" default="등급"/>'				,type:'string' ,maxLength:4},
	    	{name: 'VALI_DATE'						,text:'<t:message code="system.label.human.validate" default="유효일"/>'			,type:'uniDate'},
	    	{name: 'BIGO'									,text:'<t:message code="system.label.human.remark" default="비고"/>'				,type:'string' ,maxLength:100},
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
	var directMasterStore = Unilite.createStore('hum305ukrMasterStore',{
			model: 'hum305ukrModel',
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
			},
				Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
                validateBlank:true,
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
				fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: '',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.human.male" default="남"/>', 
					width: 70,
					name: 'SEX_CODE',
					inputValue: 'M'
				},{
					boxLabel: '<t:message code="system.label.human.female" default="여"/>', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: 'F'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('SEX_CODE').setValue(newValue.SEX_CODE);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.foreignkind" default="외국어구분"/>',
				name:'FOREIGN_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H092',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FOREIGN_KIND', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.examkind" default="시험종류"/>',
				name:'EXAM_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H093',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EXAM_KIND', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.grades" default="점수"/>',
				name:'GRADES',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('GRADES', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.grade" default="등급"/>',
				name:'CLASS',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CLASS', newValue);
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
			},
			Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				colspan:2,
                validateBlank:true,
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
				fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',
				colspan:2,
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: '',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.male" default="남"/>', 
					width: 70,
					name: 'SEX_CODE',
					inputValue: 'M'
				},{
					boxLabel: '<t:message code="system.label.human.female" default="여"/>', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: 'F'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('SEX_CODE').setValue(newValue.SEX_CODE);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.foreignkind" default="외국어구분"/>',
				name:'FOREIGN_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H092',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('FOREIGN_KIND', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.examkind" default="시험종류"/>',
				name:'EXAM_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H093',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('EXAM_KIND', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.grades" default="점수"/>',
				name:'GRADES',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('GRADES', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.grade" default="등급"/>',
				name:'CLASS',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CLASS', newValue);
					}
				}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum305ukrGrid1', {
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
			 								var grdRecord = Ext.getCmp('hum305ukrGrid1').uniOpt.currentRecord;
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
										var grdRecord = Ext.getCmp('hum305ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},
        		{ dataIndex: 'FOREIGN_KIND'					, width: 88},
        		{ dataIndex: 'EXAM_KIND'					, width: 88},
        		{ dataIndex: 'GAIN_DATE'					, width: 88},
        		
        		{ dataIndex: 'GRADES'						, width: 88},
        		{ dataIndex: 'CLASS'						, width: 88},
        		{ dataIndex: 'VALI_DATE'					, width: 88},
        		{ dataIndex: 'BIGO'							, width: 350}

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
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB', 'FOREIGN_KIND', 'EXAM_KIND', 'GAIN_DATE'])) {
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
		id  : 'hum305ukrApp',
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
				
			}
			return rv;
		}
	}); // validator
};

</script>
