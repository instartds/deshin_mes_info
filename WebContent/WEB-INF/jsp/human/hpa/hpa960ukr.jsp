<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa960ukr">
	<t:ExtComboStore comboType="AU" comboCode="H028" />		<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" />		<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" />		<!-- 직위코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" />		<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" />		<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" />		<!-- 사용여부 -->
	<t:ExtComboStore comboType="BOR120" />					<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var gsEmployRate = Ext.isEmpty(${getEmployRate}) ? []: ${getEmployRate} ;	//고용보험율 가져오기

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa960ukrService.selectList1',
			update	: 'hpa960ukrService.updateList1',
			create	: 'hpa960ukrService.insertList1',
			destroy	: 'hpa960ukrService.deleteList1',
			syncAll	: 'hpa960ukrService.saveAll1'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa960ukrService.selectList2',
			update	: 'hpa960ukrService.updateList2',
			create	: 'hpa960ukrService.insertList2',
			destroy	: 'hpa960ukrService.deleteList2',
			syncAll	: 'hpa960ukrService.saveAll2'
		}
	});
	
	/*  Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpa960ukrModel1', {
	    fields: [
			{name: 'COMP_CODE'          		, text: 'COMP_CODE'			, type: 'string'},
			{name: 'PERSON_NUMB'        		, text: '사번'				, type: 'string'	, allowBlank: false},
			{name: 'NAME'               		, text: '성명'				, type: 'string'},
			{name: 'DEPT_NAME'          		, text: '부서명'				, type: 'string'},
			{name: 'POST_CODE'		    		, text: '직위'				, type: 'string'	, comboType:'AU'	, comboCode:'H005'},
			{name: 'PAY_YYYYMM'		    		, text: '귀속년월'				, type: 'string'	, allowBlank: false},
			{name: 'SUPP_DATE'		    		, text: '지급일자'				, type: 'uniDate'	, allowBlank: false},
			{name: 'GIVE_DATE'		    		, text: '부여일자'				, type: 'uniDate'	, allowBlank: false},
			{name: 'STOCK_QTY'		    		, text: '행사수량'				, type: 'uniPrice'	, allowBlank: false},
			{name: 'ORGIN_I'		    		, text: '행사시가'				, type: 'uniPrice'	, allowBlank: false},
			{name: 'BUYING_I'		    		, text: '실제매수가액'			, type: 'uniPrice'	, allowBlank: false},
			{name: 'PROFIT_I'		    		, text: '행사이익'				, type: 'uniPrice'	, allowBlank: false},
			{name: 'TAX_EXEMPTION_I'    		, text: '비과세금액'				, type: 'uniPrice'	},
			{name: 'TAX_AMOUNT_I'	    		, text: '과세금액'				, type: 'uniPrice'	, allowBlank: true},
			{name: 'IN_TAX_I'		    		, text: '소득세'				, type: 'uniPrice'	, allowBlank: true},
			{name: 'LOC_TAX_I'		    		, text: '주민세'				, type: 'uniPrice'	, allowBlank: true},
			{name: 'HIR_TAX_I'		    		, text: '고용보험료'				, type: 'uniPrice'	, allowBlank: true},
			{name: 'REAL_SUPP_I'	    		, text: '실지급액'				, type: 'uniPrice'},
			{name: 'NONTAX_CODE'	    		, text: '비과세코드'				, type: 'string'	},
			{name: 'PRINT_LOCATION'	    		, text: '기재란'				, type: 'string'},
			{name: 'UPDATE_DB_USER'     		, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'     		, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'INSERT_DB_USER'     		, text: 'INSERT_DB_USER'	, type: 'string'},
			{name: 'INSERT_DB_TIME'     		, text: 'INSERT_DB_TIME'	, type: 'string'}
		]
	});
	
	Unilite.defineModel('hpa960ukrModel2', {
	    fields: [
			{name: 'COMP_CODE'          	, text: 'COMP_CODE'			, type: 'string'},
			{name: 'PERSON_NUMB'        	, text: '사번'				, type: 'string'	, allowBlank: false},	
			{name: 'NAME'               	, text: '성명'				, type: 'string'},
			{name: 'DEPT_NAME'          	, text: '부서명'				, type: 'string'},
			{name: 'POST_CODE'		    	, text: '직위'				, type: 'string'	, comboType:'AU', comboCode:'H005'},
			{name: 'PAY_YYYYMM'		    	, text: '귀속년월'				, type: 'string'	, allowBlank: false},
			{name: 'SUPP_DATE'		    	, text: '지급일자'				, type: 'uniDate'	, allowBlank: false},
			{name: 'PAY_TOTAL_I'	    	, text: '인출금'				, type: 'uniPrice'	, allowBlank: false},
			{name: 'TAX_EXEMPTION_I'    	, text: '비과세금액'			, type: 'uniPrice'	},
			{name: 'TAX_AMOUNT_I'	    	, text: '과세금액'				, type: 'uniPrice'	},
			{name: 'IN_TAX_I'		    	, text: '소득세'				, type: 'uniPrice'	},
			{name: 'LOC_TAX_I'		    	, text: '주민세'				, type: 'uniPrice'	},
			{name: 'HIR_TAX_I'		    	, text: '고용보험료'			, type: 'uniPrice'	},
			{name: 'REAL_SUPP_I'	    	, text: '실지급액'				, type: 'uniPrice'},
			{name: 'NONTAX_CODE'	    	, text: '비과세코드'			, type: 'string'	},
			{name: 'PRINT_LOCATION'	    	, text: '기재란'				, type: 'string'},
			{name: 'UPDATE_DB_USER'     	, text: 'UPDATE_DB_USER'	, type: 'string'},
			{name: 'UPDATE_DB_TIME'     	, text: 'UPDATE_DB_TIME'	, type: 'string'},
			{name: 'INSERT_DB_USER'     	, text: 'INSERT_DB_USER'	, type: 'string'},
			{name: 'INSERT_DB_TIME'     	, text: 'INSERT_DB_TIME'	, type: 'string'}
			]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa960ukrMasterStore',{
		model: 'hpa960ukrModel1',
		uniOpt: {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        saveStore : function()	{	
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
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function()	{	
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	var masterStore2 = Unilite.createStore('hpa960ukrMasterStore2',{
		model: 'hpa960ukrModel2',
		uniOpt: {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        saveStore : function()	{	
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
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        loadStoreRecords: function()	{
			console.log(tab.getActiveTab().getId());
			//panelSearch.setValue('ACTIVE_TAB','2');
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		}
	});

	/* 검색조건 (Search Panel)
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
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
		        fieldLabel: '사업장',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
		    },{
	        	fieldLabel: '귀속년월', 
				xtype: 'uniMonthRangefield',   
				startFieldName: 'PAY_YM_FR',
				endFieldName: 'PAY_YM_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PAY_YM_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PAY_YM_TO', newValue);				    		
			    	}
			    }
	        },{
	        	fieldLabel: '지급일자', 
				xtype: 'uniMonthRangefield',   
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
//				startDate: UniDate.get('startOfMonth'),
//				endDate: UniDate.get('today'),
				allowBlank: true,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO', newValue);				    		
			    	}
			    }
	        },
	      	Unilite.popup('Employee',{
		      	fieldLabel : '사원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
//			    validateBlank: false,
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
					}
				}
			}),
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
//				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
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
	                },
					'onTextSpecialKey': function(elm, e){
//						lastFieldSpacialKey(elm, e)
						UniAppManager.app.onQueryButtonDown();
					}
				}
			})]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        fieldLabel: '사업장',
	        name:'DIV_CODE', 
	        xtype: 'uniCombobox', 
	        comboType:'BOR120',
	        tdAttrs: {width: 380},  
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
	    },{
        	fieldLabel: '귀속년월', 
			xtype: 'uniMonthRangefield',   
			startFieldName: 'PAY_YM_FR',
			endFieldName: 'PAY_YM_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,                	
	        tdAttrs: {width: 380},  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('PAY_YM_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PAY_YM_TO', newValue);				    		
		    	}
		    }
        },{
        	fieldLabel: '지급일자', 
			xtype: 'uniMonthRangefield',   
			startFieldName: 'DATE_FR',
			endFieldName: 'DATE_TO',
//			startDate: UniDate.get('startOfMonth'),
//			endDate: UniDate.get('today'),
			allowBlank: true,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DATE_TO', newValue);				    		
		    	}
		    }
        },
      	Unilite.popup('Employee',{
	      	fieldLabel : '사원',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
//			    validateBlank: false,
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
				}
			}
		}),
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
//			textFieldWidth:89,
//			textFieldWidth: 159,
			validateBlank:true,
//			width:300,
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
                },
				'onTextSpecialKey': function(elm, e){
//					lastFieldSpacialKey(elm, e)
					UniAppManager.app.onQueryButtonDown();
				}
			}
		})]
	});
	
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('hpa960ukrGrid1', {
    	// for tab
		title: '주식매수선택권',
		layout: 'fit',    
		syncRowHeight: false,    
 		store: masterStore,
		uniOpt:{
			useMultipleSorting	: true,			 	
			useLiveSearch		: false,			
			onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
			dblClickToEdit		: true,			
			useGroupSummary		: true,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: false,				
			useRowContext		: false,	// rink 항목이 있을경우만 true		
			filter: {					
				useFilter	: false,			
				autoCreate	: true			
			}					
        },
		columns:  [         				
//			{dataIndex: 'COMP_CODE'         	  	, width: 66, hidden: true},
			{dataIndex: 'PERSON_NUMB'       	  	, width: 90,
				editor: Unilite.popup('Employee_G', {		
				textFieldName: 'PERSON_NUMB',
				autoPopup: true,
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							var hpa960ukrGrid1 = Ext.getCmp('hpa960ukrGrid1');
							var grdRecord = hpa960ukrGrid1.getSelectionModel().getSelection()[0];
							grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
							grdRecord.set('NAME', records[0].NAME);
							grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
							grdRecord.set('POST_CODE', records[0].POST_CODE);
						},
						scope: this
						},
					'onClear': function(type) {
					 	var hpa960ukrGrid1 = Ext.getCmp('hpa960ukrGrid1');
						var grdRecord = hpa960ukrGrid1.getSelectionModel().getSelection()[0]; 
						grdRecord.set('DEPT_NAME', '');
						grdRecord.set('NAME', '');
						grdRecord.set('PERSON_NUMB', '');
						grdRecord.set('POST_CODE', '');
					}
				}
			})},
			{dataIndex: 'NAME'              	  	, width: 80,
				editor: Unilite.popup('Employee_G', {		
				textFieldName: 'NAME',
				autoPopup: true,
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							var hpa960ukrGrid1 = Ext.getCmp('hpa960ukrGrid1');
							var grdRecord = hpa960ukrGrid1.getSelectionModel().getSelection()[0];
							grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
							grdRecord.set('NAME', records[0].NAME);
							grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
							grdRecord.set('POST_CODE', records[0].POST_CODE);
						},
						scope: this
						},
					'onClear': function(type) {
					 	var hpa960ukrGrid1 = Ext.getCmp('hpa960ukrGrid1');
						var grdRecord = hpa960ukrGrid1.getSelectionModel().getSelection()[0]; 
						grdRecord.set('DEPT_NAME', '');
						grdRecord.set('NAME', '');
						grdRecord.set('PERSON_NUMB', '');
						grdRecord.set('POST_CODE', '');
					}
				}
			})},
			{dataIndex: 'DEPT_NAME'         	  	, width: 160	, editable: false},
			{dataIndex: 'POST_CODE'		   	   		, width: 80		, editable: false},
			{dataIndex: 'PAY_YYYYMM'		   	  	, width: 80		, align: 'center'},
			{dataIndex: 'SUPP_DATE'		   	   		, width: 80},
			{dataIndex: 'GIVE_DATE'		   	   		, width: 80},
			{dataIndex: 'STOCK_QTY'		   	   		, width: 100},
			{dataIndex: 'ORGIN_I'		   	   		, width: 100},
			{dataIndex: 'BUYING_I'		   	   		, width: 110},
			{dataIndex: 'PROFIT_I'		   	   		, width: 100},
			{dataIndex: 'TAX_EXEMPTION_I'   	  	, width: 100},
			{dataIndex: 'TAX_AMOUNT_I'	   	   		, width: 100},
			{dataIndex: 'IN_TAX_I'		   	   		, width: 100},
			{dataIndex: 'LOC_TAX_I'		   	   		, width: 100},
			{dataIndex: 'HIR_TAX_I'		   	   		, width: 100},
			{dataIndex: 'REAL_SUPP_I'	   	   		, width: 100, editable: false},
			{dataIndex: 'NONTAX_CODE'	   	   		, width: 100,
				editor: Unilite.popup('NONTAX_CODE_G', {
					extParam:{
						'PAY_YM_FR': UniDate.getDbDateStr(panelSearch.getValue('PAY_YM_FR')).substring(0,4)
					},
					textFieldName: 'NONTAX_CODE',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var hpa960ukrGrid1 = Ext.getCmp('hpa960ukrGrid1');
								var grdRecord = hpa960ukrGrid1.getSelectionModel().getSelection()[0];
								grdRecord.set('NONTAX_CODE', records[0].NONTAX_CODE);
								grdRecord.set('PRINT_LOCATION', records[0].PRINT_LOCATION);
							
							},
							scope: this
						},
						'onClear': function(type) {
						 	var hpa960ukrGrid1 = Ext.getCmp('hpa960ukrGrid1');
							var grdRecord = hpa960ukrGrid1.getSelectionModel().getSelection()[0]; 
							grdRecord.set('NONTAX_CODE', '');
							grdRecord.set('PRINT_LOCATION', '');
							
						}
					}
				})	
			},
			{dataIndex: 'PRINT_LOCATION'	   	  	, width: 166, editable: false}/*,
			{dataIndex: 'UPDATE_DB_USER'    	  	, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'    	  	, width: 100, hidden: true},
			{dataIndex: 'INSERT_DB_USER'    	  	, width: 100, hidden: true},
			{dataIndex: 'INSERT_DB_TIME'    	  	, width: 100, hidden: true} 	*/			     
		] 
    });

	/* Master Grid2 정의(Grid Panel)
     * @type 
     */
	var masterGrid2 = Unilite.createGrid('hpa960ukrGrid2', {
		// for tab
    	title: '우리사주조합인출금',
        layout: 'fit',    
		syncRowHeight: false,    
    	store: masterStore2,
    	uniOpt:{
			useMultipleSorting	: true,			 	
			useLiveSearch		: false,			
			onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
			dblClickToEdit		: true,			
			useGroupSummary		: true,			
			useContextMenu		: false,			
			useRowNumberer		: true,			
			expandLastColumn	: false,				
			useRowContext		: false,	// rink 항목이 있을경우만 true		
			filter: {					
				useFilter	: false,			
				autoCreate	: true			
			}					
        },
        columns:  [        
//            {dataIndex: 'COMP_CODE'          	   		, width: 66, hidden: true},
			{dataIndex: 'PERSON_NUMB'        	   		, width: 90,
				editor: Unilite.popup('Employee_G', {		
				textFieldName: 'PERSON_NUMB',
				autoPopup: true,
				listeners: {
					'onSelected': {
						fn: function(records, type) {
//							console.log('records : ', records);
							var hpa960ukrGrid2 = Ext.getCmp('hpa960ukrGrid2');
							var grdRecord = hpa960ukrGrid2.getSelectionModel().getSelection()[0];
							grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
							grdRecord.set('NAME', records[0].NAME);
							grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
							grdRecord.set('POST_CODE', records[0].POST_CODE);
						},
						scope: this
					},
					'onClear': function(type) {
					 	var hpa960ukrGrid2 = Ext.getCmp('hpa960ukrGrid2');
						var grdRecord = hpa960ukrGrid2.getSelectionModel().getSelection()[0]; 
						grdRecord.set('DEPT_NAME', '');
						grdRecord.set('NAME', '');
						grdRecord.set('PERSON_NUMB', '');
						grdRecord.set('POST_CODE', '');
					}
				}
			})},
			{dataIndex: 'NAME'               	   		, width: 80,
				editor: Unilite.popup('Employee_G', {		
				textFieldName: 'NAME',
				autoPopup: true,
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							var hpa960ukrGrid2 = Ext.getCmp('hpa960ukrGrid2');
							var grdRecord = hpa960ukrGrid2.getSelectionModel().getSelection()[0];
							grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
							grdRecord.set('NAME', records[0].NAME);
							grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
							grdRecord.set('POST_CODE', records[0].POST_CODE);
						},
						scope: this
						},
					'onClear': function(type) {
					 	var hpa960ukrGrid2 = Ext.getCmp('hpa960ukrGrid2');
						var grdRecord = hpa960ukrGrid2.getSelectionModel().getSelection()[0]; 
						grdRecord.set('DEPT_NAME', '');
						grdRecord.set('NAME', '');
						grdRecord.set('PERSON_NUMB', '');
						grdRecord.set('POST_CODE', '');
					}
				}
			})},
			{dataIndex: 'DEPT_NAME'          	   		, width: 160	, editable: false},
			{dataIndex: 'POST_CODE'		    	   		, width: 80		, editable: false},
			{dataIndex: 'PAY_YYYYMM'		    	   	, width: 80		, align: 'center'},
			{dataIndex: 'SUPP_DATE'		    	   		, width: 80},
			{dataIndex: 'PAY_TOTAL_I'	    	   		, width: 100},
			{dataIndex: 'TAX_EXEMPTION_I'    	   		, width: 100},
			{dataIndex: 'TAX_AMOUNT_I'	    	   		, width: 100},
			{dataIndex: 'IN_TAX_I'		    	   		, width: 100},
			{dataIndex: 'LOC_TAX_I'		    	   		, width: 100},
			{dataIndex: 'HIR_TAX_I'		    	   		, width: 100},
			{dataIndex: 'REAL_SUPP_I'	    	   		, width: 100	, editable: false},
			{dataIndex: 'NONTAX_CODE'	    	   		, width: 100, 
				editor: Unilite.popup('NONTAX_CODE_G', {
					extParam:{
						'PAY_YM_FR': UniDate.getDbDateStr(panelSearch.getValue('PAY_YM_FR')).substring(0,4)
					},
					textFieldName: 'NONTAX_CODE',
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var hpa960ukrGrid2 = Ext.getCmp('hpa960ukrGrid2');
								var grdRecord = hpa960ukrGrid2.getSelectionModel().getSelection()[0];
								grdRecord.set('NONTAX_CODE', records[0].NONTAX_CODE);
								grdRecord.set('PRINT_LOCATION', records[0].PRINT_LOCATION);
							
							},
							scope: this
						},
						'onClear': function(type) {
						 	var hpa960ukrGrid2 = Ext.getCmp('hpa960ukrGrid2');
							var grdRecord = hpa960ukrGrid2.getSelectionModel().getSelection()[0]; 
							grdRecord.set('NONTAX_CODE', '');
							grdRecord.set('PRINT_LOCATION', '');
						}
					}
				}
			)},
			{dataIndex: 'PRINT_LOCATION'	    	   	, width: 166, editable: false}/*,
			{dataIndex: 'UPDATE_DB_USER'     	   		, width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'     	   		, width: 100, hidden: true},
			{dataIndex: 'INSERT_DB_USER'     	   		, width: 100, hidden: true},
			{dataIndex: 'INSERT_DB_TIME'     	   		, width: 100, hidden: true}*/
		],
		listeners: {
			edit: function(editor, e) {//입력 값 가져오기	
				var fieldName = e.field;
          	
				if (fieldName == 'PAY_TOTAL_I'||fieldName == 'TAX_EXEMPTION_I') {  
					var TAX_AMOUNT_I =e.record.data.PAY_TOTAL_I - e.record.data.TAX_EXEMPTION_I; 
					var REAL_SUPP_I =e.record.data.PAY_TOTAL_I - e.record.data.IN_TAX_I - e.record.data.LOC_TAX_I - e.record.data.HIR_TAX_I; 
					e.record.set("TAX_AMOUNT_I", TAX_AMOUNT_I);
					e.record.set("REAL_SUPP_I", REAL_SUPP_I);
				//UniAppManager.setToolbarButtons('save', false);
				//return false;
					
				}else if (fieldName == 'IN_TAX_I'||fieldName == 'LOC_TAX_I'||fieldName == 'HIR_TAX_I'){ 
					var REAL_SUPP_I =e.record.data.PAY_TOTAL_I - e.record.data.IN_TAX_I - e.record.data.LOC_TAX_I - e.record.data.HIR_TAX_I
					e.record.set("REAL_SUPP_I", REAL_SUPP_I);
				}
				
				if (e.originalValue != e.value) {
					UniAppManager.setToolbarButtons('save', true);
				} 
			},
			selectionchange: function(grid, selNodes ){
	        	UniAppManager.setToolbarButtons('delete', true);
			}
		}
	});  

	/* Master Grid3 정의(tab)
     * @type 
     */
     var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [
			masterGrid1,
			masterGrid2
		],
		listeners: {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {		
	     		var newTabId = newCard.getId();
	     		var isNewCardShow = true;		//newCard 보여줄것인지?
	     		var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				switch(newTabId)	{
					case 'hpa960ukrGrid1':
						if(needSave){
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
							     		var activeStore
							     		if(masterStore2.isDirty()){
							     			inValidRecs = masterStore2.getInvalidRecords();
							     			activeStore = masterStore2;							     			
							     		}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
//											tabCount = 1;											
										}
							     	}else if(res === 'no'){
//										tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		tabPanel.setActiveTab(newCard);
							     	}
							     }
							});
						}
						break;
						
					case 'hpa960ukrGrid2':
						if(needSave)	{							
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
							     		var activeStore;
							     		if(masterStore.isDirty()){
							     			inValidRecs = masterStore.getInvalidRecords();
							     			activeStore = masterStore;
							     		}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
										}
							     	}else if(res === 'no'){
//							     		tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		tabPanel.setActiveTab(newCard);
							     	}
							     }
							});
						}
						break;
						
					default:
						break;
				}
				return isNewCardShow;
	     	},
        	tabchange: function( tabPanel, newCard, oldCard ) {
//        		tabCount = 0;        		
        		var record = masterGrid1.getSelectedRecord();
        		if(!Ext.isEmpty(record)){
       				if(newCard.getId() == 'masterGrid1')	{       				    	        		
		        		masterStore.loadData({});
	        			masterStore.loadStoreRecords(record);
       				}else if(newCard.getId() == 'masterGrid2'){	
		        		masterStore2.loadData({});
	        			masterStore2.loadStoreRecords(record);
       				}
       				activeGridId = newCard.getId();	       			
        		}
        	}
		}
	});
	
	
    Unilite.Main( {
	 	border: false,
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
		id: 'hpa960ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('PAY_YM_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PAY_YM_FR', UniDate.get('today'));
//			panelSearch.setValue('DIV_CODE',UserInfo.divCode);			
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('newData',true);
			//UniAppManager.setToolbarButtons('save',true);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.reset();
			masterGrid2.reset();
			masterStore.clearData();
			masterStore2.clearData();
			this.fnInitBinding();
		},
		onNewDataButtonDown : function() {	
			var payYmFr = panelSearch.getValue('PAY_YM_FR');
			var payYmFrString = UniDate.getDbDateStr(payYmFr);
			var payYmFrDateString = (payYmFrString.substring(0,4) + "."+ payYmFrString.substring(4,6));  
			
			var detailform = panelSearch.getForm();
			if (detailform.isValid()) {
				var activeTabId = tab.getActiveTab().getId();			
				if(activeTabId == 'hpa960ukrGrid1'){				
				//alert((Ext.getCmp('PAY_YM_FR').startDate));
					masterGrid1.createRow({ PAY_YYYYMM : payYmFrDateString},'',0)
				//select LEFT('20140101',4)+'.'+ RIGHT('20140101',2)
				} else if(activeTabId == 'hpa960ukrGrid2'){				
					masterGrid2.createRow({ PAY_YYYYMM : payYmFrDateString},'',0);
					//.createRow({ TAX_YEAR : Ext.getCmp('TAX_YEAR1').getValue() },'',0);
					//masterGrid1.createRow(PERSON_NUMB, 'PERSON_NUMB', masterGrid1.getSelectedRowIndex());
				}			
			}
		},
		onSaveDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hpa960ukrGrid1'){				
				masterStore.saveStore();
				
			} else if(activeTabId == 'hpa960ukrGrid2'){	
				masterStore2.saveStore();
			}
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			var detailform = panelSearch.getForm();
			if (detailform.isValid()) {
				var activeTabId = tab.getActiveTab().getId();			
				if(activeTabId == 'hpa960ukrGrid1'){				
					masterStore.loadStoreRecords();				
				}
				else if(activeTabId == 'hpa960ukrGrid2'){
					masterStore2.loadStoreRecords();
				}
			} else {
				var invalid = panelSearch.getForm().getFields()
				.filterBy(function(field) {
					return !field.validate();
				});

				if (invalid.length > 0) {
					r = false;
					var labelText = ''

					if (Ext
							.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']
								+ '은(는)';
					} else if (Ext
							.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는)';
					}
					// Ext.Msg.alert(타이틀, 표시문구); 
					// Ext.Msg.alert('확인', "기준월(을) MM 형식으로 입력하십시오. ");
					// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
					invalid.items[0].focus();
				}
			}
		},	
		onDeleteDataButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'hpa960ukrGrid1'){				
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid1.deleteSelectedRow();
				}
			} else if(activeTabId == 'hpa960ukrGrid2'){
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid2.deleteSelectedRow();
				}
			}
		}
	});
	
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv          = true;
			var param	    = masterGrid1.getSelectedRecord;
			var sPersonNumb = masterGrid1.getSelectedRecord().data.PERSON_NUMB;
			
			switch(fieldName) {		
				case "STOCK_QTY"	:							// 행사수량
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
		  				//행사수량
						var newStockQty			= newValue;
						//행사이익 (실매수가액(행사수량 * (행사시가 - 실매수가액))
						var PROFIT_I		= newStockQty * (record.get('ORGIN_I') - record.get('BUYING_I'));
						//과세금액 (행사이익 - 비과세금액)
	  					var TAX_AMOUNT_I	= PROFIT_I - record.get('TAX_EXEMPTION_I');
						
	  					//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
						var param = masterGrid1.getSelectedRecord().data;	
						param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
						param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
						param.TAX_AMOUNT 	= TAX_AMOUNT_I;
						param.CPARAM0		= 0;
						param.CPARAM1		= 0;
						param.ERR_DESC		= '';
						hpa960ukrService.spFnGetTax(param, function(provider, response)	{
							if (!Ext.isEmpty(provider)){
			  					//소득세
			  					var IN_TAX_I		= provider.CPARAM0;
			  					//주민세
			  					var LOC_TAX_I		= provider.CPARAM1;
							} else {
			  					//소득세
			  					var IN_TAX_I		= 0;
			  					//주민세
			  					var LOC_TAX_I		= 0;
							}
							//고용보험료(과세금액 * 고용보험율 * 1/100)
							var employRate		= gsEmployRate[0].EMPLOY_RATE;
		  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
		  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
			  				var REAL_SUPP_I = PROFIT_I - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
			  				
			  				record.set('PROFIT_I'		, PROFIT_I);
							record.set('TAX_AMOUNT_I'	, TAX_AMOUNT_I);
							record.set('IN_TAX_I'		, IN_TAX_I);
							record.set('LOC_TAX_I'		, LOC_TAX_I);
							record.set('HIR_TAX_I'		, HIR_TAX_I);
							record.set('REAL_SUPP_I'	, REAL_SUPP_I);
						});
				break;
				
				case "ORGIN_I"		:						// 행사시가
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						//행사시가
						var newOrginI	= newValue;
						//행사이익 (실매수가액(행사수량 * (행사시가 - 실매수가액))
						var PROFIT_I		= record.get('STOCK_QTY') * (newOrginI - record.get('BUYING_I'));
						//과세금액 (행사이익 - 비과세금액)
	  					var TAX_AMOUNT_I	= PROFIT_I - record.get('TAX_EXEMPTION_I');
						//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
						var param = masterGrid1.getSelectedRecord().data;	
						param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
						param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
						param.TAX_AMOUNT 	= TAX_AMOUNT_I;
						param.CPARAM0		= 0;
						param.CPARAM1		= 0;
						param.ERR_DESC		= '';
						hpa960ukrService.spFnGetTax(param, function(provider, response)	{
							if (!Ext.isEmpty(provider)){
			  					//소득세
			  					var IN_TAX_I		= provider.CPARAM0;
			  					//주민세
			  					var LOC_TAX_I		= provider.CPARAM1;
							} else {
			  					//소득세
			  					var IN_TAX_I		= 0;
			  					//주민세
			  					var LOC_TAX_I		= 0;
							}
							//고용보험료(과세금액 * 고용보험율 * 1/100)
							var employRate		= gsEmployRate[0].EMPLOY_RATE;
		  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
		  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
			  				var REAL_SUPP_I = PROFIT_I - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
			  				
			  				record.set('PROFIT_I'		, PROFIT_I);
							record.set('TAX_AMOUNT_I'	, TAX_AMOUNT_I);
							record.set('IN_TAX_I'		, IN_TAX_I);
							record.set('LOC_TAX_I'		, LOC_TAX_I);
							record.set('HIR_TAX_I'		, HIR_TAX_I);
							record.set('REAL_SUPP_I'	, REAL_SUPP_I);
						});
				break;
				
				case "BUYING_I"		: 						// 실제매수가액 
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						//실제매수가액
						var newBuyingI	= newValue;   
						//행사이익 (실매수가액(행사수량 * (행사시가 - 실매수가액))
						var PROFIT_I		= record.get('STOCK_QTY') * (record.get('ORGIN_I') - newBuyingI);
						//과세금액 (행사이익 - 비과세금액)
	  					var TAX_AMOUNT_I	= PROFIT_I - record.get('TAX_EXEMPTION_I');
						//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
						var param = masterGrid1.getSelectedRecord().data;	
						param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
						param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
						param.TAX_AMOUNT 	= TAX_AMOUNT_I;
						param.CPARAM0		= 0;
						param.CPARAM1		= 0;
						param.ERR_DESC		= '';
						hpa960ukrService.spFnGetTax(param, function(provider, response)	{
							if (!Ext.isEmpty(provider)){
			  					//소득세
			  					var IN_TAX_I		= provider.CPARAM0;
			  					//주민세
			  					var LOC_TAX_I		= provider.CPARAM1;
							} else {
			  					//소득세
			  					var IN_TAX_I		= 0;
			  					//주민세
			  					var LOC_TAX_I		= 0;
							}
							//고용보험료(과세금액 * 고용보험율 * 1/100)
							var employRate		= gsEmployRate[0].EMPLOY_RATE;
		  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
		  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
			  				var REAL_SUPP_I = PROFIT_I - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
			  				
			  				record.set('PROFIT_I'		, PROFIT_I);
							record.set('TAX_AMOUNT_I'	, TAX_AMOUNT_I);
							record.set('IN_TAX_I'		, IN_TAX_I);
							record.set('LOC_TAX_I'		, LOC_TAX_I);
							record.set('HIR_TAX_I'		, HIR_TAX_I);
							record.set('REAL_SUPP_I'	, REAL_SUPP_I);
						});
				break;
				
				case "TAX_AMOUNT_I" :									// 과세금액
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						// 과세금액
						var TAX_AMOUNT_I = newValue;   
						
						if (TAX_AMOUNT_I == 0){
				  				record.set('IN_TAX_I', 0);
								record.set('LOC_TAX_I', 0);
							
						} else {
							//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
							var param = masterGrid1.getSelectedRecord().data;	
							param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
							param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
							param.TAX_AMOUNT 	= TAX_AMOUNT_I;
							param.CPARAM0		= 0;
							param.CPARAM1		= 0;
							param.ERR_DESC		= '';
							hpa960ukrService.spFnGetTax(param, function(provider, response)	{
								if (!Ext.isEmpty(provider)){
				  					//소득세
				  					var IN_TAX_I		= provider.CPARAM0;
				  					//주민세
				  					var LOC_TAX_I		= provider.CPARAM1;
								} else {
				  					//소득세
				  					var IN_TAX_I		= 0;
				  					//주민세
				  					var LOC_TAX_I		= 0;
								}
								//고용보험료(과세금액 * 고용보험율 * 1/100)
								var employRate		= gsEmployRate[0].EMPLOY_RATE;
			  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
			  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
				  				var REAL_SUPP_I = record.get('PROFIT_I') - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
				  				
								record.set('IN_TAX_I'		, IN_TAX_I);
								record.set('LOC_TAX_I'		, LOC_TAX_I);
								//record.set('HIR_TAX_I'		, HIR_TAX_I);
								record.set('REAL_SUPP_I'	, REAL_SUPP_I);							
							});
						}
				break;
				
				case "PROFIT_I" :									// 행사이익
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						// 행사이익
						var PROFIT_I = newValue;
						
						//과세금액 = 행사이익 - 비과세금액
						var TAX_AMOUNT_I = PROFIT_I - record.get('TAX_EXEMPTION_I');
						
						//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
						var param = masterGrid1.getSelectedRecord().data;	
						param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
						param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
						param.TAX_AMOUNT 	= TAX_AMOUNT_I;
						param.CPARAM0		= 0;
						param.CPARAM1		= 0;
						param.ERR_DESC		= '';
						hpa960ukrService.spFnGetTax(param, function(provider, response)	{
							if (!Ext.isEmpty(provider)){
			  					//소득세
			  					var IN_TAX_I		= provider.CPARAM0;
			  					//주민세
			  					var LOC_TAX_I		= provider.CPARAM1;
							} else {
			  					//소득세
			  					var IN_TAX_I		= 0;
			  					//주민세
			  					var LOC_TAX_I		= 0;
							}
							//고용보험료(과세금액 * 고용보험율 * 1/100)
							var employRate		= gsEmployRate[0].EMPLOY_RATE;
		  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
		  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
			  				var REAL_SUPP_I = PROFIT_I - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
			  				
			  				record.set('PROFIT_I'		, PROFIT_I);
							record.set('TAX_AMOUNT_I'	, TAX_AMOUNT_I);
							record.set('IN_TAX_I'		, IN_TAX_I);
							record.set('LOC_TAX_I'		, LOC_TAX_I);
							record.set('HIR_TAX_I'		, HIR_TAX_I);
							record.set('REAL_SUPP_I'	, REAL_SUPP_I);
						});
				break;
				
				case "TAX_EXEMPTION_I" :								// 비과세금액
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
												
						var sGiveDate = UniDate.getDbDateStr(masterGrid1.getSelectedRecord().data.GIVE_DATE);
						
		                var sTaxExemptionI1 = 0;
		                var sTaxExemptionI2 = 0;
		                var sTaxExemptionI3 = 0;
		                var sTaxExemptionI4 = 0;
		                var sTaxExemptionI5 = 0;
		                var sTaxExemptionI6 = 0;
		                var bIsErr			= false; 

						if (!Ext.isEmpty(sGiveDate)) {
							for (i=0, len = masterStore.data.length; i<len; i++){
								var sGiveDateOther	= UniDate.getDbDateStr(masterStore.data.items[i].data.GIVE_DATE);
				            	var sPersonNumb2 	= masterStore.data.items[i].data.PERSON_NUMB;
				            	
				            	if (sPersonNumb == sPersonNumb2) {
				            		if (!Ext.isEmpty(sGiveDateOther)) {
				            			if (sGiveDateOther <= '19991231') {
				            				sTaxExemptionI1 = sTaxExemptionI1 + (masterStore.data.items[i].id == record.obj.id ? newValue : masterStore.data.items[i].data.TAX_EXEMPTION_I);
				            			} else if (sGiveDateOther <= '20001231' && sGiveDateOther >= '20000101'){
				            				sTaxExemptionI2 = sTaxExemptionI2 + (masterStore.data.items[i].id == record.obj.id ? newValue : masterStore.data.items[i].data.TAX_EXEMPTION_I);
				            			} else if (sGiveDateOther <= '20061231' && sGiveDateOther >= '20010101') {
				            				sTaxExemptionI3 = sTaxExemptionI3 + (masterStore.data.items[i].id == record.obj.id ? newValue : masterStore.data.items[i].data.TAX_EXEMPTION_I);
				            			} else if (sGiveDateOther >= '20070101' && sGiveDateOther < '20180101') {
				            				sTaxExemptionI4 = sTaxExemptionI4 + (masterStore.data.items[i].id == record.obj.id ? newValue : masterStore.data.items[i].data.TAX_EXEMPTION_I);
				            			} else if (sGiveDateOther >= '20180101' && sGiveDateOther < '20200101') {
				            				sTaxExemptionI5 = sTaxExemptionI5 + (masterStore.data.items[i].id == record.obj.id ? newValue : masterStore.data.items[i].data.TAX_EXEMPTION_I);
				            			} else if (sGiveDateOther >= '20200101' && sGiveDateOther < '20211231') {
				            				sTaxExemptionI6 = sTaxExemptionI6 + (masterStore.data.items[i].id == record.obj.id ? newValue : masterStore.data.items[i].data.TAX_EXEMPTION_I);
					            		}
					            	}
								}
							}
							if (sGiveDate <= '19991231') {
								if (sTaxExemptionI1 > 50000000) {
									rv='<t:message code = "unilite.msg.fstMsgH0120"/>'
									record.set('TAX_EXEMPTION_I', 0);
									bIsErr = true;
								} 
							} else if (sGiveDate <= '20001231' && sGiveDate >= '20000101') {
								if (sTaxExemptionI2 > 30000000) {
									rv='<t:message code = "unilite.msg.fstMsgH0121"/>';
									record.set('TAX_EXEMPTION_I', 0);
									bIsErr = true;
								} 
							} else if (sGiveDate <= '20061231' && sGiveDate >= '20010101') {
								if (sTaxExemptionI3 > 30000000) {
									rv='<t:message code = "unilite.msg.fstMsgH0122"/>';
									record.set('TAX_EXEMPTION_I', 0);
									bIsErr = true;
								} 
							} else if (sGiveDate >= '20070101' && sGiveDate < '20180101' ) {
								if (sTaxExemptionI4 > 0){									
									record.set('TAX_EXEMPTION_I', 0);
									rv='<t:message code = "" default = "2007.01.01~2017.12.31 부여분은 과세특례가 폐지되어 비과세를 입력할 수 없습니다."/>';
									bIsErr = true;
								}
							} else if (sGiveDate >= '20180101' && sGiveDate < '20200101' ) {
								if (sTaxExemptionI5 > 20000000){									
									record.set('TAX_EXEMPTION_I', 0);
									rv='<t:message code = "" default = "2018.01.01~2019.12.31 부여분은 행사이익에 대해 연간 합계액 2천 만원을 초과할 수 없습니다."/>';	
									bIsErr = true;
								}
							} else if (sGiveDate >= '20200101' && sGiveDate < '20211231' ) {
								if (sTaxExemptionI6 > 30000000){									
									record.set('TAX_EXEMPTION_I', 0);
									rv='<t:message code = "" default = "2020.01.01~2021.12.31 부여분은 행사이익에 대해 연간 합계액 3천 만원을 초과할 수 없습니다."/>';
									bIsErr = true;
								}
							}
						}
						// 과세금액 = 행사이익 - 비과세금액
						var TAX_AMOUNT_I = record.get('PROFIT_I') - (bIsErr == true ? 0 : newValue);	
						
						//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
						var param = masterGrid1.getSelectedRecord().data;	
						param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
						param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
						param.TAX_AMOUNT 	= TAX_AMOUNT_I;
						param.CPARAM0		= 0;
						param.CPARAM1		= 0;
						param.ERR_DESC		= '';
						hpa960ukrService.spFnGetTax(param, function(provider, response)	{
							if (!Ext.isEmpty(provider)){
			  					//소득세
			  					var IN_TAX_I		= provider.CPARAM0;
			  					//주민세
			  					var LOC_TAX_I		= provider.CPARAM1;
							} else {
			  					//소득세
			  					var IN_TAX_I		= 0;
			  					//주민세
			  					var LOC_TAX_I		= 0;
							}
							//고용보험료(과세금액 * 고용보험율 * 1/100)
							var employRate		= gsEmployRate[0].EMPLOY_RATE;
		  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
		  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
			  				var REAL_SUPP_I = record.get('PROFIT_I') - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
			  				
							record.set('TAX_AMOUNT_I'	, TAX_AMOUNT_I);
							record.set('IN_TAX_I'		, IN_TAX_I);
							record.set('LOC_TAX_I'		, LOC_TAX_I);
							record.set('HIR_TAX_I'		, HIR_TAX_I);
							record.set('REAL_SUPP_I'	, REAL_SUPP_I);
						});
				break;

				case "IN_TAX_I" :									// 소득세
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}						
						// 소득세
						var IN_TAX_I = newValue;						
						var LOC_TAX_I = IN_TAX_I * 0.1;	
						
						record.set('LOC_TAX_I'		, LOC_TAX_I); 						
						var REAL_SUPP_I = record.get('PROFIT_I') - (IN_TAX_I + record.get('LOC_TAX_I') + record.get('HIR_TAX_I')); 
						record.set('REAL_SUPP_I', REAL_SUPP_I);
				break;
				
				case "LOC_TAX_I" :									// 주민세
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						// 주민세
						var LOC_TAX_I = newValue;
						
						var REAL_SUPP_I = record.get('PROFIT_I') - (record.get('IN_TAX_I') + LOC_TAX_I + record.get('HIR_TAX_I')); 
						record.set('REAL_SUPP_I', REAL_SUPP_I);
				break;

				case "HIR_TAX_I" :									// 고옹보험료
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						// 고옹보험료
						var HIR_TAX_I = newValue;
						
						var REAL_SUPP_I = record.get('PROFIT_I') - (record.get('IN_TAX_I') + record.get('LOC_TAX_I') + HIR_TAX_I); 
						record.set('REAL_SUPP_I', REAL_SUPP_I);
				break;
							
				case "GIVE_DATE" :									// 부여일자
					
					var sGiveDate = UniDate.getDbDateStr(newValue);
	                var sTaxExemptionI1 = 0;
	                var sTaxExemptionI2 = 0;
	                var sTaxExemptionI3 = 0;
	                var sTaxExemptionI4 = 0;
					var sTaxExemptionI5 = 0;
					var sTaxExemptionI6 = 0;
					var bIsErr			= false; 
					
					if (!Ext.isEmpty(sGiveDate)) {
						for (i=0, len = masterStore.data.length; i<len; i++){
							var sGiveDateOther	= UniDate.getDbDateStr(masterStore.data.items[i].id == record.obj.id ? newValue : masterStore.data.items[i].data.GIVE_DATE);
			            	var sPersonNumb 	= masterGrid1.getSelectedRecord().data.PERSON_NUMB;
			            	var sPersonNumb2 	= masterStore.data.items[i].data.PERSON_NUMB;			            	
			            	if (sPersonNumb == sPersonNumb2) {
			            		if (!Ext.isEmpty(sGiveDateOther)) {
			            			if (sGiveDateOther <= '19991231') {
			            				sTaxExemptionI1 = sTaxExemptionI1 + masterStore.data.items[i].data.TAX_EXEMPTION_I;
			            			} else if (sGiveDateOther <= '20001231' && sGiveDateOther >= '20000101'){
			            				sTaxExemptionI2 = sTaxExemptionI2 + masterStore.data.items[i].data.TAX_EXEMPTION_I;
			            			} else if (sGiveDateOther <= '20061231' && sGiveDateOther >= '20010101') {
			            				sTaxExemptionI3 = sTaxExemptionI3 + masterStore.data.items[i].data.TAX_EXEMPTION_I;
			            			} else if (sGiveDateOther >= '20070101' && sGiveDateOther < '20180101') {
			            				sTaxExemptionI4 = sTaxExemptionI4 + masterStore.data.items[i].data.TAX_EXEMPTION_I;
			            			} else if (sGiveDateOther >= '20180101' && sGiveDateOther < '20200101') {
			            				sTaxExemptionI5 = sTaxExemptionI5 + masterStore.data.items[i].data.TAX_EXEMPTION_I;
			            			} else if (sGiveDateOther >= '20200101' && sGiveDateOther < '20211231') {
			            				sTaxExemptionI6 = sTaxExemptionI6 + masterStore.data.items[i].data.TAX_EXEMPTION_I;
				            		}
			            		}
			            	}
						}
						
						if (sGiveDate <= '19991231') {
							if (sTaxExemptionI1 > 50000000) {
								rv='<t:message code = "unilite.msg.fstMsgH0120"/>'
								record.set('TAX_EXEMPTION_I', 0);
								bIsErr = true;
								
							} 
						} else if (sGiveDate <= '20001231' && sGiveDate >= '20000101') {
							if (sTaxExemptionI2 > 30000000) {
								rv='<t:message code = "unilite.msg.fstMsgH0121"/>';
								record.set('TAX_EXEMPTION_I', 0);
								bIsErr = true;
								
							} 
						} else if (sGiveDate <= '20061231' && sGiveDate >= '20010101') {
							if (sTaxExemptionI3 > 30000000) {
								rv='<t:message code = "unilite.msg.fstMsgH0122"/>';
								record.set('TAX_EXEMPTION_I', 0);
								bIsErr = true;
								
							} 
						} else if (sGiveDate >= '20070101' && sGiveDate < '20180101' ) {
							if (sTaxExemptionI4 > 0){									
								record.set('TAX_EXEMPTION_I', 0);
								rv='<t:message code = "" default = "2007.01.01~2017.12.31 부여분은 과세특례가 폐지되어 비과세를 입력할 수 없습니다."/>';
								bIsErr = true;//								
								
							}
						} else if (sGiveDate >= '20180101' && sGiveDate < '20200101' ) {
							if (sTaxExemptionI5 > 20000000){									
								record.set('TAX_EXEMPTION_I', 0);
								rv='<t:message code = "" default = "2018.01.01~2019.12.31 부여분은 행사이익에 대해 연간 합계액 2천 만원을 초과할 수 없습니다."/>';	//
								bIsErr = true;
								
							}
						} else if (sGiveDate >= '20200101' && sGiveDate < '20211231' ) {
							if (sTaxExemptionI6 > 30000000){									
								record.set('TAX_EXEMPTION_I', 0);
								rv='<t:message code = "" default = "2020.01.01~2021.12.31 부여분은 행사이익에 대해 연간 합계액 3천 만원을 초과할 수 없습니다."/>';	//	
								bIsErr = true;
								
							}
						}
					}					
					
					var TAX_AMOUNT_I = record.get('PROFIT_I') - (bIsErr == true ? 0 : record.get('TAX_EXEMPTION_I'));
					
					//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
					var param = masterGrid1.getSelectedRecord().data;	
					param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
					param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
					param.TAX_AMOUNT 	= TAX_AMOUNT_I;
					param.CPARAM0		= 0;
					param.CPARAM1		= 0;
					param.ERR_DESC		= '';
					hpa960ukrService.spFnGetTax(param, function(provider, response)	{
						if (!Ext.isEmpty(provider)){
		  					//소득세
		  					var IN_TAX_I		= provider.CPARAM0;
		  					//주민세
		  					var LOC_TAX_I		= provider.CPARAM1;
						} else {
		  					//소득세
		  					var IN_TAX_I		= 0;
		  					//주민세
		  					var LOC_TAX_I		= 0;
						}
						//고용보험료(과세금액 * 고용보험율 * 1/100)
						var employRate		= gsEmployRate[0].EMPLOY_RATE;
	  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
	  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
		  				var REAL_SUPP_I = record.get('PROFIT_I') - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
		  				
						record.set('TAX_AMOUNT_I'	, TAX_AMOUNT_I);
						record.set('IN_TAX_I'		, IN_TAX_I);
						record.set('LOC_TAX_I'		, LOC_TAX_I);
						record.set('HIR_TAX_I'		, HIR_TAX_I);
						record.set('REAL_SUPP_I'	, REAL_SUPP_I);
					});
				break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: masterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var param	= masterGrid2.getSelectedRecord;

			switch(fieldName) {		
				case "PAY_TOTAL_I"	:							// 인출금
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
		  				//인출금
						var PAY_TOTAL_I			= newValue;

						//과세금액 (인출금 - 비과세금액)
	  					var TAX_AMOUNT_I	= PAY_TOTAL_I - record.get('TAX_EXEMPTION_I');
						
	  					//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
						var param = masterGrid2.getSelectedRecord().data;	
						param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
						param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
						param.TAX_AMOUNT 	= TAX_AMOUNT_I;
						param.CPARAM0		= 0;
						param.CPARAM1		= 0;
						param.ERR_DESC		= '';
						hpa960ukrService.spFnGetTax(param, function(provider, response)	{
							if (!Ext.isEmpty(provider)){
			  					//소득세
			  					var IN_TAX_I		= provider.CPARAM0;
			  					//주민세
			  					var LOC_TAX_I		= provider.CPARAM1;
							} else {
			  					//소득세
			  					var IN_TAX_I		= 0;
			  					//주민세
			  					var LOC_TAX_I		= 0;
							}
							//고용보험료(과세금액 * 고용보험율 * 1/100)
							var employRate		= gsEmployRate[0].EMPLOY_RATE;
		  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
		  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
			  				var REAL_SUPP_I = PAY_TOTAL_I - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
			  				
			  				record.set('PAY_TOTAL_I'	, PAY_TOTAL_I);
							record.set('TAX_AMOUNT_I'	, TAX_AMOUNT_I);
							record.set('IN_TAX_I'		, IN_TAX_I);
							record.set('LOC_TAX_I'		, LOC_TAX_I);
							record.set('HIR_TAX_I'		, HIR_TAX_I);
							record.set('REAL_SUPP_I'	, REAL_SUPP_I);
						});
				break;
				
				case "TAX_EXEMPTION_I" :								// 비과세금액
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}

						// 비과세금액
						var TAX_EXEMPTION_I = newValue;
						
						//과세금액 (인출금 - 비과세금액)
	  					var TAX_AMOUNT_I	= record.get('PAY_TOTAL_I') - TAX_EXEMPTION_I;
						
	  					//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
						var param = masterGrid2.getSelectedRecord().data;	
						param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
						param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
						param.TAX_AMOUNT 	= TAX_AMOUNT_I;
						param.CPARAM0		= 0;
						param.CPARAM1		= 0;
						param.ERR_DESC		= '';
						hpa960ukrService.spFnGetTax(param, function(provider, response)	{
							if (!Ext.isEmpty(provider)){
			  					//소득세
			  					var IN_TAX_I		= provider.CPARAM0;
			  					//주민세
			  					var LOC_TAX_I		= provider.CPARAM1;
							} else {
			  					//소득세
			  					var IN_TAX_I		= 0;
			  					//주민세
			  					var LOC_TAX_I		= 0;
							}
							//고용보험료(과세금액 * 고용보험율 * 1/100)
							var employRate		= gsEmployRate[0].EMPLOY_RATE;
		  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
		  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
			  				var REAL_SUPP_I = record.get('PAY_TOTAL_I') - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
			  				
			  				record.set('TAX_EXEMPTION_I', TAX_EXEMPTION_I);
							record.set('TAX_AMOUNT_I'	, TAX_AMOUNT_I);
							record.set('IN_TAX_I'		, IN_TAX_I);
							record.set('LOC_TAX_I'		, LOC_TAX_I);
							record.set('HIR_TAX_I'		, HIR_TAX_I);
							record.set('REAL_SUPP_I'	, REAL_SUPP_I);
						});
				break;
				
				case "TAX_AMOUNT_I" :									// 과세금액
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						// 과세금액
						var TAX_AMOUNT_I = newValue;   
	  					var TAX_EXEMPTION_I	= record.get('PAY_TOTAL_I') - TAX_AMOUNT_I;

						if (TAX_AMOUNT_I == 0){
				  				record.set('IN_TAX_I', 0);
								record.set('LOC_TAX_I', 0);
							
						} else {
							//소득세 가져오기 (param에 해당 레코드 값 모두 넣어서 함수 호출)
							var param = masterGrid2.getSelectedRecord().data;	
							param.YEAR_YY 		= param.PAY_YYYYMM.substring(0,4);
							param.YEAR_MONTH 	= param.PAY_YYYYMM.substring(5,7);
							param.TAX_AMOUNT 	= TAX_AMOUNT_I;
							param.CPARAM0		= 0;
							param.CPARAM1		= 0;
							param.ERR_DESC		= '';
							hpa960ukrService.spFnGetTax(param, function(provider, response)	{
								if (!Ext.isEmpty(provider)){
				  					//소득세
				  					var IN_TAX_I		= provider.CPARAM0;
				  					//주민세
				  					var LOC_TAX_I		= provider.CPARAM1;
								} else {
				  					//소득세
				  					var IN_TAX_I		= 0;
				  					//주민세
				  					var LOC_TAX_I		= 0;
								}
								//고용보험료(과세금액 * 고용보험율 * 1/100)
								var employRate		= gsEmployRate[0].EMPLOY_RATE;
			  					var HIR_TAX_I		= TAX_AMOUNT_I * employRate * (1/100);
			  					//실지급액 (행사이익 - (소득세 + 주민세 + 고용보험료) 
				  				var REAL_SUPP_I = record.get('PAY_TOTAL_I') - (IN_TAX_I + LOC_TAX_I + HIR_TAX_I); 
				  				
								record.set('TAX_EXEMPTION_I', TAX_EXEMPTION_I);
								record.set('IN_TAX_I'		, IN_TAX_I);
								record.set('LOC_TAX_I'		, LOC_TAX_I);
								record.set('HIR_TAX_I'		, HIR_TAX_I);
								record.set('REAL_SUPP_I'	, REAL_SUPP_I);							
							});
						}
				break;
				
				case "IN_TAX_I" :									// 소득세
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						// 소득세
						var IN_TAX_I = newValue;
						
						var LOC_TAX_I = IN_TAX_I * 0.1;						
						record.set('LOC_TAX_I'		, LOC_TAX_I); 
						
						var REAL_SUPP_I = record.get('PAY_TOTAL_I') - (IN_TAX_I + record.get('LOC_TAX_I') + record.get('HIR_TAX_I')); 
						record.set('REAL_SUPP_I', REAL_SUPP_I);
				break;
				
				case "LOC_TAX_I" :									// 주민세
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						// 주민세
						var LOC_TAX_I = newValue;
						
						var REAL_SUPP_I = record.get('PAY_TOTAL_I') - (record.get('IN_TAX_I') + LOC_TAX_I + record.get('HIR_TAX_I')); 
						record.set('REAL_SUPP_I', REAL_SUPP_I);
				break;

				case "HIR_TAX_I" :									// 고옹보험료
						if (Ext.isEmpty(record.get('PERSON_NUMB'))){
							rv=	Msg.fsbMsgH0244
							break;
						}
						if(newValue <= 0 && !Ext.isEmpty(newValue))	{
							rv=Msg.sMB076;
							break;
						}
						
						// 고옹보험료
						var HIR_TAX_I = newValue;
						
						var REAL_SUPP_I = record.get('PAY_TOTAL_I') - (record.get('IN_TAX_I') + record.get('LOC_TAX_I') + HIR_TAX_I); 
						record.set('REAL_SUPP_I', REAL_SUPP_I);
				break;
			}
			return rv;
		}
	});
/*	////품목정보 팝업에서 선택된 데이타가 그리드에 추가되는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨(controller에서 페이지 오픈시 읽어오도록 변경)
	function getEmployRate(record, dataClear, grdRecord) {
		var param = record;
		hpa960ukrService.selectEmployRate(param, function(provider, response) {
			var EMPLOY_RATE = provider.EMPLOY_RATE
			return EMPLOY_RATE;
		});
	}*/

	function lastFieldSpacialKey(elm, e)	{
		if( e.getKey() == Ext.event.Event.ENTER)	{
			if(elm.isExpanded)	{
    			var picker = elm.getPicker();
    			if(picker)	{
    				var view = picker.selectionModel.view;
    				if(view && view.highlightItem)	{
    					picker.select(view.highlightItem);
    				}
    			}
			}else {
					UniAppManager.app.onQueryButtonDown();
			}
		}
	}
};
</script>
