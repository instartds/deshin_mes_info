<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum305ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="s_hum305ukr_KOCIS" /> 			<!-- 사업장  -->
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
        	read : 's_hum305ukrService_KOCIS.selectList',
        	update: 's_hum305ukrService_KOCIS.updateDetail',
			create: 's_hum305ukrService_KOCIS.insertDetail',
			destroy: 's_hum305ukrService_KOCIS.deleteDetail',
			syncAll: 's_hum305ukrService_KOCIS.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum305ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'					,text:'법인코드'			,type:'string' },
	    	{name: 'DIV_CODE'					,text:'기관'			,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'부서'				,type:'string' },
	    	{name: 'POST_CODE'					,text:'직위'				,type:'string' },
	    	{name: 'NAME'						,text:'성명'				,type:'string' ,allowBlank: false},
	    	{name: 'PERSON_NUMB'				,text:'사번'				,type:'string' },
	    	
	    	{name: 'FOREIGN_KIND'				,text:'외국어구분'			,type:'string'  ,allowBlank: false , comboType:'AU', comboCode:'H092'},
	    	{name: 'EXAM_KIND'					,text:'시험종류'			,type:'string'  ,allowBlank: false , comboType:'AU', comboCode:'H093'},
	    	{name: 'GAIN_DATE'					,text:'취득년월'			,type:'string'  ,allowBlank: false}, // uniMonth 같은 xtype 이 필요함
	    	{name: 'GRADES'						,text:'점수'				,type:'int'  ,allowBlank: false, maxLength:4},
	    	{name: 'CLASS_N'						,text:'등급'				,type:'string' ,maxLength:4},
	    	{name: 'VALI_DATE'					,text:'유효일'			,type:'uniDate'},
	    	{name: 'BIGO'						,text:'비고'				,type:'string' ,maxLength:100},
	    	
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
				fieldLabel: '기관',
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
			}/*,
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
			})*/,{
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
			},
				Unilite.popup('Employee',{
				fieldLabel: '직원',
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
				fieldLabel: '성별',
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: '',
					checked: true 
				},{
					boxLabel : '남', 
					width: 70,
					name: 'SEX_CODE',
					inputValue: 'M'
				},{
					boxLabel: '여', 
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
				fieldLabel: '외국어구분',
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
				fieldLabel: '시험종류',
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
				fieldLabel: '점수',
				name:'GRADES',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('GRADES', newValue);
					}
				}
			},{
				fieldLabel: '등급',
				name:'CLASS_N',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CLASS_N', newValue);
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
				}/*,{
					fieldLabel: '사원구분',
					name:'EMPLOY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H024'
				}*/,{
					fieldLabel: '급여지급방식',
					name:'PAY_CODE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H028'
				}/*,{
					fieldLabel: '사업명',
					name:'COST_POOL',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('getHumanCostPool')
				}*/,{
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
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '기관',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
                colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}/*,
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
			})*/,{
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
			},
			Unilite.popup('Employee',{
				fieldLabel: '직원',
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
				fieldLabel: '성별',
				colspan:2,
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: '',
					checked: true
				},{
					boxLabel : '남', 
					width: 70,
					name: 'SEX_CODE',
					inputValue: 'M'
				},{
					boxLabel: '여', 
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
				fieldLabel: '외국어구분',
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
				fieldLabel: '시험종류',
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
				fieldLabel: '점수',
				name:'GRADES',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('GRADES', newValue);
					}
				}
			},{
				fieldLabel: '등급',
				name:'CLASS_N',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CLASS_N', newValue);
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
        		{ dataIndex: 'DEPT_NAME'					, width: 160, hidden: true},
        		{ dataIndex: 'POST_CODE'					, width: 88},
        		{ dataIndex: 'NAME'							, width: 120,
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
        		{ dataIndex: 'PERSON_NUMB'					, width: 78, hidden: true,
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
        		{ dataIndex: 'CLASS_N'						, width: 88},
        		{ dataIndex: 'VALI_DATE'					, width: 88},
        		{ dataIndex: 'BIGO'							, minwidth: 350, flex : 1}

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
//			if(!Ext.isEmpty(gsCostPool)){
//				panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
//			}
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');
			
			panelSearch.getField('RDO_TYPE').setValue('A');
			panelResult.getField('RDO_TYPE').setValue('A');
            
            if(UserInfo.divCode == "01") {
                panelSearch.getField('DIV_CODE').setReadOnly(false);
                panelResult.getField('DIV_CODE').setReadOnly(false);
            }
            else {
                panelSearch.getField('DIV_CODE').setReadOnly(true);
                panelResult.getField('DIV_CODE').setReadOnly(true);
            }
			
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
			grdRecord.set('DIV_CODE', record.DIV_CODE);			
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
	}); // validator
};

</script>
