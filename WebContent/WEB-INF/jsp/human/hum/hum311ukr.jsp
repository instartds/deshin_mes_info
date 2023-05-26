<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum311ukr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum311ukr"/> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H020" /> 				<!-- 가족관계 -->
	<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--사업명-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

function appMain() {
	var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hum311ukrService.selectList',
        	update: 'hum311ukrService.updateDetail',
			create: 'hum311ukrService.insertDetail',
			destroy: 'hum311ukrService.deleteDetail',
			syncAll: 'hum311ukrService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum311ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'					,text:'법인코드'			,type:'string' },
	    	{name: 'DIV_CODE'					,text:'사업장'			,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'부서'				,type:'string' },
	    	{name: 'POST_CODE'					,text:'직위'				,type:'string' },//, comboType:'AU', comboCode:'H005'},
	    	{name: 'NAME'						,text:'성명'				,type:'string' },
	    	{name: 'PERSON_NUMB'				,text:'사번'				,type:'string' , allowBlank: false},
			
	    	/* 보증보험 */
			{name: 'INSURANCE_NAME'				,text:'보험명'			,type:'string' , maxLength:20},
			{name: 'INSURANCE_NO'				,text:'보험번호'			,type:'string' , maxLength:20},
			{name: 'INSURANCE_COMPANY'			,text:'보험회사'			,type:'string' },
			{name: 'INSURANCE_FARE'				,text:'보험료'			,type:'uniPrice' , maxLength:15},
			{name: 'GUARANTEE_PERIOD_FR'		,text:'시작일'			,type:'uniDate'},
			{name: 'GUARANTEE_PERIOD_TO'		,text:'종료일'			,type:'uniDate'},

	    	/* 보증인1 */
			{name: 'GUARANTOR1_NAME'     		,text:'성명'				,type:'string' },
			{name: 'GUARANTOR1_RELATION'		,text:'관계'				,type:'string' , comboType:'AU', comboCode:'H020'},
			{name: 'GUARANTOR1_RES_NO'   		,text:'주민번호'			,type:'string' , maxLength:14},
			{name: 'GUARANTOR1_PERIOD_FR'		,text:'시작일'			,type:'uniDate'},
			{name: 'GUARANTOR1_PERIOD_TO'		,text:'종료일'			,type:'uniDate'},
			{name: 'GUARANTOR1_WORK_ZONE'		,text:'근무지'			,type:'string' , maxLength:20},
			{name: 'GUARANTOR1_CLASS'    		,text:'직위'				,type:'string' , maxLength:20},
			{name: 'GUARANTOR1_INCOMETAX'		,text:'세금'				,type:'uniPrice', maxLength:15},
			{name: 'GUARANTOR1_ZIP_CODE' 		,text:'우편번호'			,type:'string' },
			{name: 'GUARANTOR1_ADDR'     		,text:'주소'				,type:'string' , maxLength:50},
			{name: 'GUARANTOR1_ADDR_DE'  		,text:'상세주소'			,type:'string' , maxLength:50},
			
			/* 보증인2 */
			{name: 'GUARANTOR2_NAME'     		,text:'성명'				,type:'string' },
			{name: 'GUARANTOR2_RELATION' 		,text:'관계'				,type:'string' , comboType:'AU', comboCode:'H020'},
			{name: 'GUARANTOR2_RES_NO'  		,text:'주민번호'			,type:'string' , maxLength:14},
			{name: 'GUARANTOR2_PERIOD_FR'		,text:'시작일'			,type:'uniDate'},
			{name: 'GUARANTOR2_PERIOD_TO'		,text:'종료일'			,type:'uniDate'},
			{name: 'GUARANTOR2_WORK_ZONE'		,text:'근무지'			,type:'string' , maxLength:20},
			{name: 'GUARANTOR2_CLASS'    		,text:'직위'				,type:'string' , maxLength:20},
			{name: 'GUARANTOR2_INCOMETAX'		,text:'세금'				,type:'uniPrice', maxLength:15},
			{name: 'GUARANTOR2_ZIP_CODE' 		,text:'우편번호'			,type:'string' },
			{name: 'GUARANTOR2_ADDR'     		,text:'주소'				,type:'string' , maxLength:50},
			{name: 'GUARANTOR2_ADDR_DE'  		,text:'상세주소'			,type:'string' , maxLength:50},
	    	
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
	var directMasterStore = Unilite.createStore('hum311ukrMasterStore',{
			model: 'hum311ukrModel',
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
							masterGrid.getStore().loadStoreRecords();
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
				fieldLabel: '보증보험만료일',
				xtype: 'uniDateRangefield',
	            startFieldName: 'GUARANTEE_PERIOD_TO_FR',
	            endFieldName: 'GUARANTEE_PERIOD_TO_TO',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('GUARANTEE_PERIOD_TO_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('GUARANTEE_PERIOD_TO_TO', newValue);				    		
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
				fieldLabel: '보증보험만료일',
				xtype: 'uniDateRangefield',
	            startFieldName: 'GUARANTEE_PERIOD_TO_FR',
	            endFieldName: 'GUARANTEE_PERIOD_TO_TO',
	            width: 350,         	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('GUARANTEE_PERIOD_TO_FR', newValue);						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('GUARANTEE_PERIOD_TO_TO', newValue);				    		
			    	}
			    }
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum311ukrGrid1', {
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
			 								var grdRecord = Ext.getCmp('hum311ukrGrid1').uniOpt.currentRecord;
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
										var grdRecord = Ext.getCmp('hum311ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},{ text : '보증보험' ,
	        		columns: [
	        			{ dataIndex: 'INSURANCE_NAME'		     		, width: 110},
	        			{ dataIndex: 'INSURANCE_NO'	     				, width: 110},
	        			{ dataIndex: 'INSURANCE_COMPANY'	     		, width: 110},
	        			{ dataIndex: 'INSURANCE_FARE'		     		, width: 100},
	        			{ text : '보증기간' ,
			        		columns: [
			        			{ dataIndex: 'GUARANTEE_PERIOD_FR'		     	, width: 90},
			        			{ dataIndex: 'GUARANTEE_PERIOD_TO'	     		, width: 90}
				        	]
				        }
		        	]
		        },{ text : '보증인1' ,
	        		columns: [
	        			{ dataIndex: 'GUARANTOR1_NAME'		    		, width: 100},
	        			{ dataIndex: 'GUARANTOR1_RELATION'	    		, width: 88},
	        			{ dataIndex: 'GUARANTOR1_RES_NO'	    		, width: 110}, 
	        			{ text : '보증기간' ,
			        		columns: [
			        			{ dataIndex: 'GUARANTOR1_PERIOD_FR'		     	, width: 90},
			        			{ dataIndex: 'GUARANTOR1_PERIOD_TO'	     		, width: 90}
				        	]
				        },
	        			{ dataIndex: 'GUARANTOR1_WORK_ZONE'	    		, width: 110},
	        			{ dataIndex: 'GUARANTOR1_CLASS'		    		, width: 88},
	        			{ dataIndex: 'GUARANTOR1_INCOMETAX'		    	, width: 110},
			        	{ dataIndex: 'GUARANTOR1_ZIP_CODE'		    	, width: 88,
			        	'editor' : Unilite.popup('ZIP_G',{
							DBtextFieldName: 'ZIP_CODE', 
							validateBlank : true,
			  				autoPopup: true,
		   					listeners: {'onSelected': {
						                    fn: function(records, type  ){
						                    	masterGrid.getSelectedRecord().set('GUARANTOR1_ZIP_CODE', records[0]['ZIP_CODE']);
						                    	masterGrid.getSelectedRecord().set('GUARANTOR1_ADDR'	, records[0]['ZIP_NAME']);
						                    	masterGrid.getSelectedRecord().set('GUARANTOR1_ADDR_DE'	, records[0]['ADDR2']);
						                    },
						                    scope: this
						                  },
			 							'onClear' : function(type)	{
						                  	  masterGrid.getSelectedRecord().set('GUARANTOR1_ZIP_CODE', '');
						                      masterGrid.getSelectedRecord().set('GUARANTOR1_ADDR', '');
						                      masterGrid.getSelectedRecord().set('GUARANTOR1_ADDR_DE', '');
						                  }
			 					}
							})
						},
			        	{ dataIndex: 'GUARANTOR1_ADDR'		    		, width: 200},
			        	{ dataIndex: 'GUARANTOR1_ADDR_DE'		    	, width: 200}
		        	]
		        },{ text : '보증인2' ,
	        		columns: [
	        			{ dataIndex: 'GUARANTOR2_NAME'		    		, width: 100},
	        			{ dataIndex: 'GUARANTOR2_RELATION'	    		, width: 88},
	        			{ dataIndex: 'GUARANTOR2_RES_NO'	    		, width: 110}, 
	        			{ text : '보증기간' ,
			        		columns: [
			        			{ dataIndex: 'GUARANTOR2_PERIOD_FR'		     	, width: 90},
			        			{ dataIndex: 'GUARANTOR2_PERIOD_TO'	     		, width: 90}
				        	]
				        },
	        			{ dataIndex: 'GUARANTOR2_WORK_ZONE'	    		, width: 110},
	        			{ dataIndex: 'GUARANTOR2_CLASS'		    		, width: 88},
	        			{ dataIndex: 'GUARANTOR2_INCOMETAX'		    	, width: 110},
			        	{ dataIndex: 'GUARANTOR2_ZIP_CODE'		    	, width: 88,
			        	'editor' : Unilite.popup('ZIP_G',{
							DBtextFieldName: 'ZIP_CODE', 
							validateBlank : true,
			  				autoPopup: true,
		   					listeners: {'onSelected': {
						                    fn: function(records, type  ){
						                    	masterGrid.getSelectedRecord().set('GUARANTOR2_ZIP_CODE', records[0]['ZIP_CODE']);
						                    	masterGrid.getSelectedRecord().set('GUARANTOR2_ADDR'	, records[0]['ZIP_NAME']);
						                    	masterGrid.getSelectedRecord().set('GUARANTOR2_ADDR_DE'	, records[0]['ADDR2']);
						                    },
						                    scope: this
						                  },
			 							'onClear' : function(type)	{
						                  	  masterGrid.getSelectedRecord().set('GUARANTOR2_ZIP_CODE', '');
						                      masterGrid.getSelectedRecord().set('GUARANTOR2_ADDR', '');
						                      masterGrid.getSelectedRecord().set('GUARANTOR2_ADDR', '');
						                  }
			 					}
							})
						},
			        	{ dataIndex: 'GUARANTOR2_ADDR'		    		, width: 200},
			        	{ dataIndex: 'GUARANTOR2_ADDR_DE'		    	, width: 200}
		        	]
		        }
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
		        		if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB'])) {
							return false;
						}
		        	}
		        	if(!e.record.phantom == true || e.record.phantom == true) { 	// 신규이던 아니던
		        		if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_NAME', 'POST_CODE'])) {
							return false;
						}
		        	}
		        },
		        edit: function(editor, e) {
		        	
		        	var fieldName = e.field;  
					
				 	if(fieldName == 'GUARANTOR1_RES_NO' || fieldName == 'GUARANTOR2_RES_NO'){
				 		var resNo = e.value.replace(/-/g,'');
				 		
						if(!Ext.isNumeric(resNo) && !Ext.isEmpty(resNo))	{
					 		alert(Msg.sMB074);
					 		this.setValue('');
					 		return ;
					 	}
	  					if(Unilite.validate('residentno',resNo) != true && !Ext.isEmpty(resNo))	{
					 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176 + "\n"+'주민번호 :' + resNo.substring(0,6)+ "-"+ resNo.substring(6,13)))	{	
					 			var originalValue = (resNo.substring(0,6)+ "-"+ resNo.substring(6,13));
					 			e.record.set(fieldName, originalValue);
					 			return;
					 		}
					 	}
					 	if(Ext.isNumeric(resNo)) {
							var resultRepreNo = (resNo.substring(0,6)+ "-"+ resNo.substring(6,13));
							e.record.set(fieldName, resultRepreNo);
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
		id  : 'hum311ukrApp',
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
				case "GUARANTEE_PERIOD_FR" : // 보증보험 시작일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
				
				case "GUARANTEE_PERIOD_TO" : // 보증보험 종료일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
				
				case "GUARANTOR1_PERIOD_FR" : // 보증인1 보증기간 시작일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
				
				
				case "GUARANTOR1_PERIOD_TO" : // 보증인1 보증기간 종료일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
					
				case "GUARANTOR2_PERIOD_FR" : // 보증인2 보증기간 시작일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					break;
				
				case "GUARANTOR2_PERIOD_TO" : // 보증인2 보증기간 종료일
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
