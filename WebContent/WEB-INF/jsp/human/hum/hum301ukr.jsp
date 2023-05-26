<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum301ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum301ukr" /> 			<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	
	<t:ExtComboStore comboType="AU" comboCode="H080" /> 				<!-- 혈액형 -->
	<t:ExtComboStore comboType="AU" comboCode="H082" /> 				<!-- 주거형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H084" /> 				<!-- 보훈구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H086" /> 				<!-- 종교 -->
	<t:ExtComboStore comboType="AU" comboCode="H081" /> 				<!-- 색맹여부 -->
	<t:ExtComboStore comboType="AU" comboCode="H083" /> 				<!-- 생활수준 -->
	<t:ExtComboStore comboType="AU" comboCode="H085" /> 				<!-- 장애구분 -->
	
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
        	read : 'hum301ukrService.selectList',
        	update: 'hum301ukrService.updateDetail',
			create: 'hum301ukrService.insertDetail',
			destroy: 'hum301ukrService.deleteDetail',
			syncAll: 'hum301ukrService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum301ukrModel', {
	    fields: [
	    	
	    	{name: 'COMP_CODE'						,text:'법인코드'				,type:'string' },
	    	{name: 'DIV_CODE'						,text:'사업장'				,type:'string' ,comboType:'BOR120'},
	    	{name: 'DEPT_NAME'						,text:'부서'					,type:'string' },
	    	{name: 'POST_CODE'						,text:'직위'					,type:'string' ,comboType:'AU' , comboCode:'H005'},
	    	{name: 'NAME'							,text:'성명'					,type:'string' ,allowBlank: false},
	    	{name: 'PERSON_NUMB'					,text:'사번'					,type:'string' ,allowBlank: false},
	    	{name: 'HEIGHT'							,text:'신장'					,type:'int'    ,maxLength:3},
	    	{name: 'WEIGHT'							,text:'체중'					,type:'int'    ,maxLength:3},
	    	{name: 'SIGHT_LEFT'						,text:'시력(좌)'				,type:'string' ,maxLength:3},
	    	{name: 'SIGHT_RIGHT'					,text:'시력(우)'				,type:'string' ,maxLength:3},
	    	{name: 'BLOOD_KIND'						,text:'혈액형'				,type:'string' ,comboType:'AU' , comboCode:'H080'},
	    	{name: 'COLOR_YN'						,text:'색맹여부'				,type:'string' ,comboType:'AU' , comboCode:'H081'},
	    	{name: 'LIVE_KIND'						,text:'주거형태'				,type:'string' ,comboType:'AU' , comboCode:'H082'},
	    	{name: 'GROUND'							,text:'대지(㎡)'				,type:'int'    ,maxLength:12},
	    	{name: 'FLOOR_SPACE'					,text:'건물(㎡)'				,type:'int'    ,maxLength:12},
	    	{name: 'GARDEN'							,text:'동산(만원)'				,type:'int'    ,maxLength:12},
	    	{name: 'REAL_PROPERTY'					,text:'부동산(만원)'			,type:'int'    ,maxLength:12},
	    	{name: 'LIVE_LEVEL'						,text:'생활수준'				,type:'string' ,comboType:'AU' , comboCode:'H083'},
	    	{name: 'AGENCY_KIND'					,text:'보훈구분'				,type:'string' ,comboType:'AU' , comboCode:'H084'},
	    	{name: 'AGENCY_GRADE'					,text:'보훈번호'				,type:'string' },
	    	{name: 'HITCH_KIND'						,text:'장애구분'				,type:'string' ,comboType:'AU' , comboCode:'H085'},
	    	{name: 'HITCH_GRADE'					,text:'장애등급'				,type:'int' },
	    	{name: 'HITCH_DATE'						,text:'장애등록일'				,type:'uniDate'},
	    	{name: 'SPECIAL_ABILITY'				,text:'특기'					,type:'string' ,maxLength:10},
	    	{name: 'RELIGION'						,text:'종교'					,type:'string' ,maxLength:10   ,comboType:'AU' , comboCode:'H086'},
	    	{name: 'INSERT_DB_USER'					,text:'입력자'				,type:'string' },
	    	{name: 'INSERT_DB_TIME'					,text:'입력일'				,type:'uniDate'},
	    	{name: 'UPDATE_DB_USER'					,text:'수정자'				,type:'string' },
	    	{name: 'UPDATE_DB_TIME'					,text:'수정일'				,type:'uniDate'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum301ukrMasterStore',{
			model: 'hum301ukrModel',
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
				fieldLabel: '혈액형',
				name:'BLOOD_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H080',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BLOOD_KIND', newValue);
					}
				}
			},{
				fieldLabel: '주거형태',
				name:'LIVE_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H082',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('LIVE_KIND', newValue);
					}
				}
			},{
				fieldLabel: '보훈구분',
				name:'AGENCY_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H084',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENCY_KIND', newValue);
					}
				}
			},{
				fieldLabel: '종교',
				name:'RELIGION',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H086',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RELIGION', newValue);
					}
				}
			},{
				fieldLabel: '색맹여부',
				name:'COLOR_YN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H081',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COLOR_YN', newValue);
					}
				}
			},{
				fieldLabel: '생활수준',
				name:'LIVE_LEVEL',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H083',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('LIVE_LEVEL', newValue);
					}
				}
			},{
				fieldLabel: '장애구분',
				name:'HITCH_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H085',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('HITCH_KIND', newValue);
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
				fieldLabel: '혈액형',
				name:'BLOOD_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H080',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BLOOD_KIND', newValue);
					}
				}
			},{
				fieldLabel: '주거형태',
				name:'LIVE_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H082',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('LIVE_KIND', newValue);
					}
				}
			},{
				fieldLabel: '보훈구분',
				name:'AGENCY_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H084',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AGENCY_KIND', newValue);
					}
				}
			},{
				fieldLabel: '종교',
				name:'RELIGION',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H086',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('RELIGION', newValue);
					}
				}
			},{
				fieldLabel: '색맹여부',
				name:'COLOR_YN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H081',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COLOR_YN', newValue);
					}
				}
			},{
				fieldLabel: '생활수준',
				name:'LIVE_LEVEL',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H083',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('LIVE_LEVEL', newValue);
					}
				}
			},{
				fieldLabel: '장애구분',
				name:'HITCH_KIND',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H085',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('HITCH_KIND', newValue);
					}
				}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum301ukrGrid1', {
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
			 								var grdRecord = Ext.getCmp('hum301ukrGrid1').uniOpt.currentRecord;
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
										var grdRecord = Ext.getCmp('hum301ukrGrid1').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		  								
		  								grdRecord.set('DIV_CODE','');
		  								grdRecord.set('DEPT_NAME','');
		  								grdRecord.set('POST_CODE','');			
		 							}
		 				}
					})
				},
        		{ dataIndex: 'HEIGHT'          		, width: 88},
        		{ dataIndex: 'WEIGHT'          		, width: 88},
        		{ dataIndex: 'SIGHT_LEFT'      		, width: 88},
        		{ dataIndex: 'SIGHT_RIGHT'     		, width: 88},
        		{ dataIndex: 'BLOOD_KIND'      		, width: 88},
        		{ dataIndex: 'COLOR_YN'        		, width: 88},
        		{ dataIndex: 'LIVE_KIND'       		, width: 88},
        		{ dataIndex: 'GROUND'          		, width: 88},
        		{ dataIndex: 'FLOOR_SPACE'     		, width: 88},
        		{ dataIndex: 'GARDEN'          		, width: 88},
        		{ dataIndex: 'REAL_PROPERTY'   		, width: 100},
        		{ dataIndex: 'LIVE_LEVEL'      		, width: 88},
        		{ dataIndex: 'AGENCY_KIND'     		, width: 88},
        		{ dataIndex: 'AGENCY_GRADE'    		, width: 88},
        		{ dataIndex: 'HITCH_KIND'      		, width: 88},
        		{ dataIndex: 'HITCH_GRADE'     		, width: 88},
        		{ dataIndex: 'HITCH_DATE'      		, width: 88},
        		{ dataIndex: 'SPECIAL_ABILITY' 		, width: 88},
        		{ dataIndex: 'RELIGION'       		, width: 88}

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
		id  : 'hum301ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			if(!Ext.isEmpty(gsCostPool)){
				panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
			}
			
			panelSearch.getField('RDO_TYPE').setValue('A');
			panelResult.getField('RDO_TYPE').setValue('A');
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');
			
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
			grdRecord.set('POST_CODE', record.POST_CODE);
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
				case "HITCH_DATE" : // 입학년도
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
