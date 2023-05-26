<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum245ukr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum245ukr"/> 			<!-- 사업장  -->
	
	
	<t:ExtComboStore comboType="AU" comboCode="H174" /> 				<!-- 승급기준(갑을병정) -->
	<t:ExtComboStore comboType="AU" comboCode="H187" /> 				<!-- 승급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> 				<!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H174" /> 				<!-- 직책(갑을병정) -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'hum245ukrService.selectList',
        	update: 'hum245ukrService.updateDetail',
			create: 'hum245ukrService.insertDetail',
			destroy: 'hum245ukrService.deleteDetail',
			syncAll: 'hum245ukrService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hum245ukrModel', {
	    fields: [
	    	{name: 'CHOICE'						,text:'선택'				,type:'string' },
	    	{name: 'PAYSTEP_YYYYMMDD'			,text:'승급일자'			,type:'uniDate', allowBlank: false},
	    	{name: 'PAYSTEP_GUBUN'				,text:'승급구분'			,type:'string' , allowBlank: false , comboType:'AU', comboCode:'H187'},
	    	{name: 'DIV_CODE'					,text:'사업장'			,type:'string' , comboType: 'BOR120'},
	    	{name: 'DEPT_NAME'					,text:'부서'				,type:'string' },
	    	{name: 'POST_CODE'					,text:'직위'				,type:'string' , comboType:'AU', comboCode:'H005'},
	    	{name: 'PERSON_NUMB'				,text:'사번'				,type:'string' , allowBlank: false},
	    	{name: 'NAME'						,text:'성명'				,type:'string' , allowBlank: false},
	    	{name: 'JOIN_DATE'					,text:'입사일자'			,type:'uniDate'},
	    	{name: 'EMPLOY_TYPE'				,text:'사원구분'			,type:'string' , comboType:'AU', comboCode:'H024'},
	    	{name: 'ABIL_CODE'					,text:'직책'				,type:'string' , comboType:'AU', comboCode:'H006'},
	    	{name: 'AF_PAY_GRADE_01'			,text:'급'				,type:'string' , allowBlank: false , maxLength:2},
	    	{name: 'AF_PAY_GRADE_02'			,text:'호봉'				,type:'string' , allowBlank: false , maxLength:2},
	    	{name: 'AF_PAY_GRADE_BASE'			,text:'승급기준'			,type:'string' , allowBlank: false , comboType:'AU', comboCode:'H174'},
	    	{name: 'AF_YEAR_GRADE'				,text:'근속'				,type:'string' , allowBlank: false , maxLength:2},
	    	{name: 'AF_YEAR_GRADE_BASE'			,text:'년수기준'			,type:'string' , allowBlank: false , comboType:'AU', comboCode:'H174'},
	    	{name: 'AF_WAGES_STD_I'				,text:'기본급'			,type:'uniPrice'},
	    	{name: 'APPLY_YN'					,text:'반영여부'			,type:'string' },
	    	
	    	{name: 'PERIOD_DATE'				,text:'휴직산재기간 (원인)'		,type:'string' },
	    	//{name: 'OFF_CODE2'					,text:'휴직산재원인'		,type:'string' },

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
	var directMasterStore = Unilite.createStore('hum245ukrMasterStore',{
			model: 'hum245ukrModel',
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
			listeners: {
				load: function(store, records, successful, eOpts) {		
					var count = masterGrid.getStore().getCount();
					//QU:조회/NI:신규/NW:추가/DL:삭제/SV:저장/DA:전체삭제/SF:파일/PR:인쇄/PV:미리보기
					//CT:챠트/DP:이전/DN:이후/CQ:추가검색
					
					if(count == 0){
						alert(Msg.sMB015); //해당 자료가 없습니다.
						if(panelSearch.getValue('PAYSTEP_GUBUN') == '1'){
							//QU1:NI1:NW0:DL0:SV0:DA0:SF0:PR0:PV0:CT0:DP0:DN0:CQ0"
							UniAppManager.setToolbarButtons(['reset'], true);
							UniAppManager.setToolbarButtons(['newData', 'delete', 'save', 'print', 'deleteAll'], false);
						}else{	
							//QU1:NI1:NW1:DL0:SV0:DA0:SF0:PR0:PV0:CT0:DP0:DN0:CQ0")
							UniAppManager.setToolbarButtons(['reset', 'newData'], true);
							UniAppManager.setToolbarButtons(['delete', 'save', 'print', 'deleteAll'], false);
						}
					}
					else{	
						if(panelSearch.getValue('PAYSTEP_GUBUN') == '1'){
							//QU1:NI1:NW0:DL0:SV0:DA1:SF1:PR1:PV1:CT0:DP0:DN0:CQ0
							UniAppManager.setToolbarButtons(['reset', 'deleteAll', 'print'], true);
							UniAppManager.setToolbarButtons(['newData', 'delete', 'save'], false);
						}
						else{
							//QU1:NI1:NW1:DL1:SV0:DA1:SF1:PR1:PV1:CT0:DP0:DN0:CQ0
							UniAppManager.setToolbarButtons(['reset', 'newData', 'delete', 'deleteAll', 'print'], true);
							UniAppManager.setToolbarButtons(['save'], false);
						}
					}
				}
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기
			saveStore : function(config)	{
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
				layout: {type:'uniTable', column:2},
				xtype: 'container',
				items: [{
					fieldLabel: '승급일자',
				 	xtype: 'uniCombobox',
			        comboType:'AU',
			        comboCode:'H174',
				 	name: 'GRADE_CODE',	
				 	allowBlank: false,
				 	flex:2,
			    	width:200,
			    	listeners: {
			    		change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('GRADE_CODE', newValue);	
							
							var param = {"GRADE_CODE": panelSearch.getValue('GRADE_CODE')};
							hum245ukrService.fnSetPropertiesbyPayGradeBase(param, function(provider, response){
								if(!Ext.isEmpty(provider)){
									var year = new Date().getFullYear();
									var mmdd = provider.GRADE_MMDD;
									var date = year + mmdd; 
									
									panelSearch.setValue('PAYSTEP_YYYYMMDD', date);
									panelResult.setValue('PAYSTEP_YYYYMMDD', date);
								}	
							});
						}
			    	}
				},{
					fieldLabel:'호봉승급일자',
					hideLabel:true,
				 	xtype: 'uniDatefield',
				 	name: 'PAYSTEP_YYYYMMDD',	
				 	allowBlank: false,
				 	flex:1,
			    	width:125,
			    	listeners: {
			    		change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('PAYSTEP_YYYYMMDD', newValue)					
						}
			    	}
				}]
			},{
				fieldLabel: '승급구분',
				name:'PAYSTEP_GUBUN', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode:'H187',
		        allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAYSTEP_GUBUN', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        comboType:'BOR120',
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
			}),{
				fieldLabel: '사원구분',
				name:'EMPLOY_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EMPLOY_TYPE', newValue);
					}
				}
			},
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
			})]
		}]
	}); 
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				layout: {type:'uniTable', column:2},
				xtype: 'container',
				items: [{
					fieldLabel: '승급일자',
				 	xtype: 'uniCombobox',
			        comboType:'AU',
			        comboCode:'H174',
				 	name: 'GRADE_CODE',	
				 	allowBlank: false,
				 	flex:2,
			    	width:200,
			    	listeners: {
			    		change: function(combo, newValue, oldValue, eOpts) {
							panelSearch.setValue('GRADE_CODE', newValue);
							
							var param = {"GRADE_CODE": panelSearch.getValue('GRADE_CODE')};
							hum245ukrService.fnSetPropertiesbyPayGradeBase(param, function(provider, response){
								if(!Ext.isEmpty(provider)){
									var year = new Date().getFullYear();
									var mmdd = provider.GRADE_MMDD;
									var date = year + mmdd; 
									
									panelSearch.setValue('PAYSTEP_YYYYMMDD', date);
									panelResult.setValue('PAYSTEP_YYYYMMDD', date);
								}	
							});
						}
			    	}
				},{
					fieldLabel:'호봉승급일자',
					hideLabel:true,
				 	xtype: 'uniDatefield',
				 	name: 'PAYSTEP_YYYYMMDD',
				 	allowBlank: false,
				 	flex:1,
			    	width:125,
			    	listeners: {
			    		change: function(combo, newValue, oldValue, eOpts) {
							panelSearch.setValue('PAYSTEP_YYYYMMDD', newValue)					
						}
			    	}
				}]
			},{
				fieldLabel: '승급구분',
				name:'PAYSTEP_GUBUN', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode:'H187',
		        allowBlank: false,
		        colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PAYSTEP_GUBUN', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        comboType:'BOR120',
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
				colspan:2,
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
				fieldLabel: '사원구분',
				name:'EMPLOY_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('EMPLOY_TYPE', newValue);
					}
				}
			},
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
			})]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum245ukrGrid1', {
    	region: 'center',
        layout: 'fit',
        uniOpt: {
    		expandLastColumn: false,
		 	copiedRow: true,
//		 	useContextMenu: true,
		 	onLoadSelectFirst : false
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
    	selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false, toggleOnClick: false}),
        tbar: [{
			itemId: 'btnCreate',
			text: '승급대상자료생성',
        	handler: function(btn) {
        		if(Ext.isEmpty(panelSearch.getValue('PAYSTEP_YYYYMMDD'))){
        			//alert(Msg.fSbMsgH0386); // 호봉승급일자를 입력하십시오.
        			alert('호봉승급일자를 입력하십시오.');
        			return false;
        		}
        		if(Ext.isEmpty(panelSearch.getValue('PAYSTEP_GUBUN')) || panelSearch.getValue('PAYSTEP_GUBUN') != '1'){
        			//alert(Msg.fsbMsgH0416);	// 정기승급만 승급대상자료를 생성할 수 있습니다.
        			alert('정기승급만 승급대상자료를 생성할 수 있습니다.');
        			return false;
        		}
        		
        		Ext.Msg.confirm('확인', '승급대상자료가 생성되어 있으나 인사정보에 반영되지 않았으면 삭제 후 다시 생성됩니다, </br>계속 하시겠습니까?', function(btn){
					if (btn == 'yes') {		
						var param = panelSearch.getValues();
						var paystepYyyymmdd = panelSearch.getValue('PAYSTEP_YYYYMMDD');
						param.PAYSTEP_YYYYMMDD = UniDate.getDbDateStr(paystepYyyymmdd);
						
						Ext.getBody().mask('로딩중...','loading-indicator');
						hum245ukrService.fnHum245QStdCreate(param, function(provider, response)	{
							if(provider){
								UniAppManager.updateStatus(Msg.sMB011);
							}
							Ext.getBody().unmask();
							UniAppManager.app.onQueryButtonDown();
						});
					}else{
						return false;
					}
				});
	        }
		},{
			itemId: 'btnApply',
			text: '인사정보반영',
        	handler: function(btn) {
        		if(masterGrid.getSelectedRecords().length > 0 ){
        			Ext.Msg.confirm('확인', '승급결과를 인사정보에 반영하시겠습니까?', function(btn){
						if (btn == 'yes') {		
		        			var param = panelSearch.getValues();
		        			var paystepYyyymmdd = panelSearch.getValue('PAYSTEP_YYYYMMDD');
							param.PAYSTEP_YYYYMMDD = UniDate.getDbDateStr(paystepYyyymmdd);
							param.PROC = 'APPLY';
								
							var iPerson_Numb_array = new Array();
							
			    			var records = masterGrid.getSelectedRecords();
			    			Ext.each(records, function(record, i){
			    				iPerson_Numb_array[i] = record.get('PERSON_NUMB');
			    			});	
			    			param.iPERSON_NUMB = iPerson_Numb_array;
			    			
			    			Ext.getBody().mask('로딩중...','loading-indicator');
			    			hum245ukrService.fnHum245SaveApplyCancel(param, function(provider, response)	{
								if(!provider){
									UniAppManager.updateStatus(Msg.sMB011);
									UniAppManager.app.onQueryButtonDown();
								}
								Ext.getBody().unmask();
								
							});
						}
	        		});
	        	}
	    		else{
	    			alert("선택된 자료가 없습니다.");
	    		}
        	}
		},{
			itemId: 'btnCancel',
			text: '인사정보취소',
        	handler: function(btn) {
        		if(masterGrid.getSelectedRecords().length > 0 ){
        			Ext.Msg.confirm('확인', '승급결과에 대한 인사정보반영을 취소하시겠습니까?', function(btn){
						if (btn == 'yes') {		
			    			var param = panelSearch.getValues();
		        			var paystepYyyymmdd = panelSearch.getValue('PAYSTEP_YYYYMMDD');
							param.PAYSTEP_YYYYMMDD = UniDate.getDbDateStr(paystepYyyymmdd);
							param.PROC = 'CANCEL';
								
			    			var iPerson_Numb_array = new Array();
							
			    			var records = masterGrid.getSelectedRecords();
			    			Ext.each(records, function(record, i){
			    				iPerson_Numb_array[i] = record.get('PERSON_NUMB');
			    			});
			    			
			    			param.iPERSON_NUMB = iPerson_Numb_array;
			    			
			    			Ext.getBody().mask('로딩중...','loading-indicator');
			    			hum245ukrService.fnHum245SaveApplyCancel(param, function(provider, response)	{
								if(!provider){
									UniAppManager.updateStatus(Msg.sMB011);
									UniAppManager.app.onQueryButtonDown();
								}
								Ext.getBody().unmask();
								
							});
						}
	        		});
	        	}
	    		else{
	    			alert("선택된 자료가 없습니다.");
	    		}
	        }
		}],
        store: directMasterStore,
        columns:  [  
        		//{ dataIndex: 'CHOICE'						, width: 120},
        		{ dataIndex: 'PAYSTEP_YYYYMMDD'				, width: 100},
        		{ dataIndex: 'PAYSTEP_GUBUN'				, width: 88},
        		{ dataIndex: 'DIV_CODE'						, width: 140},
        		{ dataIndex: 'DEPT_NAME'					, width: 160},
        		{ dataIndex: 'POST_CODE'					, width: 88},
        		{ dataIndex: 'PERSON_NUMB'					, width: 100,
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									grdRecord = masterGrid.getSelectedRecord();
												record = records[0];
												grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
												grdRecord.set('NAME', record.NAME);
												grdRecord.set('DEPT_NAME', record.DEPT_NAME);
												grdRecord.set('POST_CODE', record.POST_CODE);
												grdRecord.set('JOIN_DATE', record.JOIN_DATE);
												grdRecord.set('EMPLOY_TYPE', record.EMPLOY_TYPE);
												grdRecord.set('ABIL_CODE', record.ABIL_CODE);	
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum245ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								grdRecord.set('DEPT_NAME','');
			  								grdRecord.set('POST_CODE','');
			  								grdRecord.set('JOIN_DATE','');
			  								grdRecord.set('EMPLOY_TYPE','');
			  								grdRecord.set('ABIL_CODE','');
 										}
			 				}
						})
				},
        		{ dataIndex: 'NAME'							, width: 100,
        		'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									grdRecord = masterGrid.getSelectedRecord();
												record = records[0];
												grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
												grdRecord.set('NAME', record.NAME);
												grdRecord.set('DEPT_NAME', record.DEPT_NAME);
												grdRecord.set('POST_CODE', record.POST_CODE);
												grdRecord.set('JOIN_DATE', record.JOIN_DATE);
												grdRecord.set('EMPLOY_TYPE', record.EMPLOY_TYPE);
												grdRecord.set('ABIL_CODE', record.ABIL_CODE);	
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum245ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			  								grdRecord.set('DEPT_NAME','');
			  								grdRecord.set('POST_CODE','');
			  								grdRecord.set('JOIN_DATE','');
			  								grdRecord.set('EMPLOY_TYPE','');
			  								grdRecord.set('ABIL_CODE','');
 										}
			 				}
						})
				},
        		{ dataIndex: 'JOIN_DATE'					, width: 100},
        		{ dataIndex: 'EMPLOY_TYPE'					, width: 100},
        		{ dataIndex: 'ABIL_CODE'					, width: 100},
        		{ dataIndex: 'AF_PAY_GRADE_01'				, width: 66,
        		'editor' : Unilite.popup('PAY_GRADE_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									grdRecord = masterGrid.getSelectedRecord();
												record = records[0];
												grdRecord.set('AF_PAY_GRADE_01', record.PAY_GRADE_01);
												grdRecord.set('AF_PAY_GRADE_02', record.PAY_GRADE_02);
												grdRecord.set('AF_WAGES_STD_I', record.STD100);			// 기본급
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum245ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('AF_PAY_GRADE_01','');
			  								grdRecord.set('AF_PAY_GRADE_02','');
			  								grdRecord.set('AF_WAGES_STD_I','');

 										}
			 				}
						})
				},
        		{ dataIndex: 'AF_PAY_GRADE_02'				, width: 66,
        		'editor' : Unilite.popup('PAY_GRADE_G',{
						validateBlank : true,
						autoPopup:true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									grdRecord = masterGrid.getSelectedRecord();
												record = records[0];
												grdRecord.set('AF_PAY_GRADE_01', record.PAY_GRADE_01);
												grdRecord.set('AF_PAY_GRADE_02', record.PAY_GRADE_02);
												grdRecord.set('AF_WAGES_STD_I', record.STD100);				// 기본급
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('hum245ukrGrid1').uniOpt.currentRecord;
			  								grdRecord.set('AF_PAY_GRADE_01','');
			  								grdRecord.set('AF_PAY_GRADE_02','');
			  								grdRecord.set('AF_WAGES_STD_I','');
 										}
			 				}
						})
				},
        		{ dataIndex: 'AF_PAY_GRADE_BASE'			, width: 100},
        		{ dataIndex: 'AF_YEAR_GRADE'				, width: 66},
        		{ dataIndex: 'AF_YEAR_GRADE_BASE'			, width: 100},
        		{ dataIndex: 'AF_WAGES_STD_I'				, width: 100},
        		{ dataIndex: 'APPLY_YN'						, width: 88},
						
        		{ dataIndex: 'PERIOD_DATE'					, width: 400}
        		//{ dataIndex: 'OFF_CODE2'					, width: 100}

        	],
        	listeners: {
	    		beforeedit: function( editor, e, eOpts ) {
	    			if(UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME'])){
	    				if(e.record.phantom == true) {
	    					return true;
	    				}else{
	    					return false
	    				}
	    			}
	    			if(UniUtils.indexOf(e.field, ['AF_PAY_GRADE_01', 'AF_PAY_GRADE_02', 'AF_PAY_GRADE_BASE' ,'AF_YEAR_GRADE' ,'AF_YEAR_GRADE_BASE'])){
	    				if(e.record.data.PAYSTEP_GUBUN== '1'){
	    					return false;
	    				}else{
	    					return true;
	    				}
	    			}
	    			if(UniUtils.indexOf(e.field, ['PAYSTEP_YYYYMMDD', 'PAYSTEP_GUBUN', 'DIV_CODE', 'DEPT_NAME', 'POST_CODE', 'JOIN_DATE', 'EMPLOY_TYPE', 'ABIL_CODE'
	    											, 'AF_WAGES_STD_I', 'APPLY_YN', 'PERIOD_DATE', 'OFF_CODE2'])){
	    				return false;									
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
		id  : 'hum245ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('GRADE_CODE');
			
			panelSearch.setValue('PAYSTEP_GUBUN', Ext.data.StoreManager.lookup('CBS_AU_H187').getAt(0).get('value'));
			panelResult.setValue('PAYSTEP_GUBUN', Ext.data.StoreManager.lookup('CBS_AU_H187').getAt(0).get('value'));
			 
			
			//QU:조회/NI:신규/NW:추가/DL:삭제/SV:저장/DA:전체삭제/SF:파일/PR:인쇄/PV:미리보기
			//CT:챠트/DP:이전/DN:이후/CQ:추가검색
			//"QU1:NI1:NW1:DL0:SV0:DA0:SF0:PR0:PV0:CT0:DP0:DN0:CQ0"
			
			UniAppManager.setToolbarButtons(['reset', 'newData'],true);
			UniAppManager.setToolbarButtons(['delete', 'save', 'print', 'deleteAll'], false);
			
			
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onNewDataButtonDown: function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			
			var compCode		 = UserInfo.compCode;
        	var paystepYyyymmdd  = panelSearch.getValue('PAYSTEP_YYYYMMDD');
        	var paystepGubun     = panelSearch.getValue('PAYSTEP_GUBUN');
        	var divCode          = panelSearch.getValue('DIV_CODE');
			
        	var r ={
        		COMP_CODE			: compCode,
        		PAYSTEP_YYYYMMDD    : paystepYyyymmdd,
        		PAYSTEP_GUBUN		: paystepGubun,
        		DIV_CODE			: divCode
        	};
	        masterGrid.createRow(r , 'PERSON_NUMB');
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
		
		onDeleteDataButtonDown: function() {
			if (masterGrid.getStore().getCount == 0) return;
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			} else {
				//자료가 입력되어있는 행이면 삭제메세지를 보낸 후
   				//저장버튼을 눌러 DB 삭제한다.
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						masterGrid.deleteSelectedRow();
						UniAppManager.setToolbarButtons('save', true);
					}
				});
			}
			if (masterGrid.getStore().getCount() == 0) {
				UniAppManager.setToolbarButtons('delete', false);
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						
						/*---------삭제전 로직 구현 끝----------*/
						
						if(deletable){		
							masterGrid.reset();		
							UniAppManager.app.onSaveDataButtonDown();	
						}													
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.setToolbarButtons('save',false);
				panelSearch.clearForm();
				panelResult.clearForm();
				masterGrid.getStore().loadData({});

			}
			this.fnInitBinding();
		},
		
		onPrintButtonDown: function() {
			if(masterGrid.getSelectedRecords().length > 0 ){
    			alert("출력 레포트를 만들어주세요.");
	    		}
    		else{
    			alert("선택된 자료가 없습니다.");
    		}
		}
	});
};

</script>
