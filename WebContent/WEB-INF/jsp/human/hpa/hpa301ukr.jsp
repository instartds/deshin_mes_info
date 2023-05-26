<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa301ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 반영여부 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var isSubmitBtnClick = false;
	var isCancelBtnClick = false;
	var excelWindow;
	
	Ext.create( 'Ext.data.Store', {
          storeId: "InsurStore",
          fields: [ 'text', 'value'],
          data : [
              {text: "국민연금",   value:"1" },
              {text: "건강보험",   value:"2" },
              {text:'고용보험'	, 	 value:"3" }
          ]
      });
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa301ukrModel', {
		fields: [
			{name: 'FLAG'					, text: 'FLAG'      	, type: 'string'},
			{name: 'COMP_CODE'				, text: 'COMP_CODE'      , type: 'string'},
			{name: 'BASE_DATE'				, text: '기준일'           , type: 'uniDate'},
			{name: 'INSUR_TYPE'				, text: '보험구분'          , type: 'string'},
			{name: 'DIV_CODE'				, text: '사업장'           , type: 'string', comboType:'BOR120', editable: false},
			{name: 'DEPT_NAME'				, text: '부서'           , type: 'string', editable: false},
			{name: 'POST_CODE'				, text: '직위'           , type: 'string', editable: false},
			{name: 'BASE_DATE'              , text: '등록기준일'        , type: 'uniDate'},
			{name: 'NAME'					, text: '성명'           , type: 'string', allowBlank: false},
			{name: 'PERSON_NUMB'			, text: '사번'           , type: 'string', allowBlank: false},
			{name: 'REPRE_NUM'				, text: '주민번호'         , type: 'string', editable: false},
			{name: 'JOIN_DATE'				, text: '입사일'          , type: 'uniDate', editable: false},
			{name: 'AF_INSUR_AVG_I'			, text: '월평균보수액'      , type: 'uniPrice',  maxLength: 10},
			{name: 'AF_INSUR_I'				, text: '산출보험료'       , type: 'uniPrice',  maxLength: 10},
			{name: 'AF_ORIMED_INSUR_I'		, text: '건강보험(고지)'    , type: 'uniPrice', maxLength: 10},
			{name: 'AF_OLDMED_INSUR_I'		, text: '장기요양(고지)'    , type: 'uniPrice', maxLength: 10},
			{name: 'APPLY_YN'				, text: '반영여부'         , type: 'string', comboType: 'AU', comboCode: 'B010', editable: false}
		]
	});//End of Unilite.defineModel('Hpa301ukrModel', {	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hpa301ukrService.selectList',
			create: 'hpa301ukrService.insertDetail',
			update: 'hpa301ukrService.updateDetail',
     	    destroy: 'hpa301ukrService.deleteDetail',
       	    syncAll : 'hpa301ukrService.saveAll'
		}
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hpa301ukrMasterStore', {
		model: 'Hpa301ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			allDeletable: true,		//전체 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					 } 
				}
				directMasterStore.syncAllDirect(config);	
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
	    	if (records) {
		    	UniAppManager.setToolbarButtons('save', false);
				var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
		    	//console.log(msg, st);
		    	UniAppManager.updateStatus(msg, true);	
	    	}
	    }
	    ,
	    listeners:{
	    	load: function(store, records, successful, eOpts) {
	    		if (records.length > 0){
		    		//panelSearch.setValue('BASE_DATE', UniDate.getDbDateStr(records[0].get('BASE_DATE')));
		    		//panelResult.setValue('BASE_DATE', UniDate.getDbDateStr(records[0].get('BASE_DATE')));
	    		}
	    		
	    		//panelResult.setValue('BASE_DATE', records[0].get('BASE_DATE'));
	    		panelSearch.getField('INSUR_TYPE').setReadOnly(false);
				panelResult.getField('INSUR_TYPE').setReadOnly(false);
	    		UniAppManager.setToolbarButtons('newData', true);
	    	}
	    }
		
// 		,groupField: 'CUSTOM_NAME'
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
		region: 'west',
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
				fieldLabel: '기준일기간',
				startFieldName: 'FR_BASE_DATE',
                endFieldName: 'TO_BASE_DATE',
	        	xtype: 'uniDateRangefield',	        	
	        	allowBlank: false,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                   if(panelSearch) {
                       panelSearch.setValue('FR_BASE_DATE',newValue);
                   }   
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                   if(panelSearch) {
                       panelSearch.setValue('TO_BASE_DATE',newValue);
                   }       
                }
	        },{
    			fieldLabel: '사업장',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
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
				fieldLabel: '보험구분',
				name: 'INSUR_TYPE', 
				xtype: 'combobox',
				store: Ext.data.StoreManager.lookup( 'InsurStore'),
				displayField : 'text',
                valueField : 'value',
                value : '1',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INSUR_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '사원구분',				
				name: 'EMPLOY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EMPLOY_TYPE', newValue);
					}
				}
			},			
		     	Unilite.popup('Employee',{ 				
				autoPopup: true,
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{ 
                fieldLabel: '등록 기준일',
                name: 'BASE_DATE',
                xtype: 'uniDatefield',              
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('BASE_DATE', newValue);
                    }
                }
            },{
		    	xtype: 'container',
		    	padding: '10 0 0 0',
		    	layout: {
		    		type: 'vbox',
					align: 'center',
					pack:'center'
		    	},
		    	items:[{
					xtype: 'container',
					tdAttrs: {align: 'right'},
					layout: {type: 'uniTable', columns: 3},
					items:[{
			    		xtype: 'button',
			    		width: 90,
			    		text: '인사정보반영',
			    		handler: function(){
			    			var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
			    			if(needSave){
			    				alert(Msg.sMB154);
			    				return;
			    			}
			    			var records = masterGrid.getSelectedRecords();
			    			Ext.each(records, function(record, i){
			    				record.set('FLAG', 'U');
			    			});
			    			directMasterStore.saveStore();
			    		}
			    	},{
			    		xtype: 'component',
			    		width: 3
			    	},{
			    		xtype: 'button',
			    		width: 90,
			    		text: '인사정보취소',
			    		handler: function(){
			    			var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
			    			if(needSave){
			    				alert(Msg.sMB154);
			    				return;
			    			}
			    			var records = masterGrid.getSelectedRecords();
			    			Ext.each(records, function(record, i){
			    				record.set('FLAG', 'D');
			    			});
			    			directMasterStore.saveStore();    			
			    		}
			    	}]
				}]
		    }
		    ]
		}]
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '기준일기간',
			startFieldName: 'FR_BASE_DATE',
            endFieldName: 'TO_BASE_DATE',
        	xtype: 'uniDateRangefield',	        	
        	allowBlank: false,   
		    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('FR_BASE_DATE',newValue);
                 }   
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                 if(panelSearch) {
                    panelSearch.setValue('TO_BASE_DATE',newValue);
                 }       
            }
			
        },{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
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
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			colspan:2,
			width:300,
			autoPopup:true,
			useLike:true,
			tdAttrs:{width: 270},
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
			fieldLabel: '보험구분',
			name: 'INSUR_TYPE', 
			xtype: 'combobox',
			store: Ext.data.StoreManager.lookup( 'InsurStore'),
			displayField : 'text',
            valueField : 'value',
            value : '1',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INSUR_TYPE', newValue);
				}
			}
		},{
			fieldLabel: '사원구분',				
			name: 'EMPLOY_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H024',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('EMPLOY_TYPE', newValue);
				}
			}
		},			
	     	Unilite.popup('Employee',{ 				
			autoPopup: true,
			validateBlank: false,
			colspan:2,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),{ 
                fieldLabel: '등록기준일',
                name: 'BASE_DATE',
                xtype: 'uniDatefield',
                colspan:3,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BASE_DATE', newValue);
                    }
                }
            },{
			xtype: 'container',
			tdAttrs: {align: 'right'},
			layout: {type: 'uniTable', columns: 4},
			items:[{
	    		xtype: 'button',
	    		width: 90,
//	    		id: 'submitBtn2',
	    		text: '인사정보반영',
	    		handler: function(){
	    			var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
	    			if(needSave){
	    				alert(Msg.sMB154);
	    				return;
	    			}
	    			var records = masterGrid.getSelectedRecords();
	    			Ext.each(records, function(record, i){
	    				record.set('FLAG', 'U');
	    			});
	    			directMasterStore.saveStore();
	    		}
	    	},{
	    		xtype: 'button',
	    		width: 90,
//	    		id: 'cancelBtn2',
	    		text: '인사정보취소',
	    		handler: function(){
	    			var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
	    			if(needSave){
	    				alert(Msg.sMB154);
	    				return;
	    			}
	    			var records = masterGrid.getSelectedRecords();
	    			Ext.each(records, function(record, i){
	    				record.set('FLAG', 'D');
	    			});
	    			directMasterStore.saveStore();    			
	    		}
	    	}]
		}]	
    });
		
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hpa301ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'south',
		store : directMasterStore, 
    	uniOpt: {
    		expandLastColumn: true,
    		onLoadSelectFirst: false,
    		copiedRow: true,
    		useRowNumberer: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        },
        tbar: [{
        	itemId : 'refBtn',
    		text:'엑셀 참조',
    		handler: function() {
    			openExcelWindow();
			}
   		 }],
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
    	selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false, toggleOnClick: false,
    		listeners: {  	
				checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
					
				},
				select: function(grid, record, index, rowIndex, eOpts ){
//					record.set('FLAG', 'U');
	          	},
				deselect:  function(grid, record, index, rowIndex, eOpts ){
					
	    		}
			}
        }),
		columns: [			
//			{ dataIndex:'FLAG'					,	width: 125, hidden: false},
//			{ dataIndex:'COMP_CODE'				,	width: 125, hidden: false},
//			{ dataIndex:'BASE_DATE'				,	width: 115, hidden: false},
//			{ dataIndex:'INSUR_TYPE'			,	width: 115, hidden: false},
			{ dataIndex:'DIV_CODE'				,	width: 153},
			{ dataIndex:'DEPT_NAME'				,	width: 192},
			{ dataIndex:'POST_CODE'				,	width: 76},
			{ dataIndex:'BASE_DATE'             ,   width: 100},
			{dataIndex: 'NAME'		  		, width: 86
				,editor: Unilite.popup('Employee_G', {
						autoPopup: true,
						listeners: {'onSelected': {
										fn: function(records, type) {
												console.log('records : ', records);
												console.log(records);
												var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
												grdRecord.set('DIV_CODE', records[0].DIV_CODE);
												grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
												grdRecord.set('POST_CODE', records[0].POST_CODE);
												grdRecord.set('NAME', records[0].NAME);
												grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);	
												grdRecord.set('REPRE_NUM', records[0].REPRE_NUM);
												grdRecord.set('JOIN_DATE', records[0].JOIN_DATE);
											},
										scope: this
										},
									'onClear': function(type) {
										var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
										grdRecord.set('DIV_CODE', '');
										grdRecord.set('DEPT_NAME', '');
										grdRecord.set('POST_CODE', '');
										grdRecord.set('NAME', '');
										grdRecord.set('PERSON_NUMB', '');
										grdRecord.set('REPRE_NUM', '');
										grdRecord.set('JOIN_DATE', '');
									}
					}
				})
			},
			{dataIndex: 'PERSON_NUMB'		, width: 86
				,editor: Unilite.popup('Employee_G', {
					autoPopup: true,
					DBtextFieldName: 'PERSON_NUMB',
					listeners: {'onSelected': {
									fn: function(records, type) {
											console.log('records : ', records);
											var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
											grdRecord.set('DIV_CODE', records[0].DIV_CODE);
											grdRecord.set('DEPT_NAME', records[0].DEPT_NAME);
											grdRecord.set('POST_CODE', records[0].POST_CODE);
											grdRecord.set('NAME', records[0].NAME);
											grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
											grdRecord.set('REPRE_NUM', records[0].REPRE_NUM);
											grdRecord.set('JOIN_DATE', records[0].JOIN_DATE);
										},
									scope: this
									},
								'onClear': function(type) {
									var grdRecord = masterGrid.getSelectionModel().getSelection()[0];
									grdRecord.set('WORK_TEAM', '');
									grdRecord.set('DIV_CODE', '');
									grdRecord.set('DEPT_NAME', '');
									grdRecord.set('POST_CODE', '');
									grdRecord.set('NAME', '');
									grdRecord.set('PERSON_NUMB', '');
									grdRecord.set('REPRE_NUM', '');
									grdRecord.set('JOIN_DATE', '');
								}
					}
				})
			},
			{ dataIndex:'REPRE_NUM'				,	width: 115},
			{ dataIndex:'JOIN_DATE'				,	width: 115},
			{ dataIndex:'AF_INSUR_AVG_I'		,	width: 115},
			{ dataIndex:'AF_INSUR_I'			,	width: 115},
			{ dataIndex:'AF_ORIMED_INSUR_I'		,	width: 115},
			{ dataIndex:'AF_OLDMED_INSUR_I'		,	width: 115},
			{ dataIndex:'APPLY_YN'				,	width: 115}
		],
		listeners: {
          	beforeedit: function(editor, e) {
          		if(e.record.get('APPLY_YN') == "Y") return false;
          		
				if (!e.record.phantom) {
					 if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME'])){
					 	return false;
					 }
				}
			}
		}
	});//End of var masterGrid = Unilite.createGrid('hpa301ukrGrid1', {
	
	// 수당기준설정 - 연봉등록 : excelUpload 연봉정보 모델
	Unilite.defineModel('excel.hpa301.sheet01', {
	    fields: [
	    		{name: '_EXCEL_JOBID'				,text:'_EXCEL_JOBID'		,type : 'string'},
	    		{name: 'NAME'						,text:'성명'					,type : 'string'},
	    		{name: 'REPRE_NUM'					,text:'주민등록번호'			    ,type : 'string'},
	    		{name: 'AF_INSUR_AVG_I'				,text:'보수월액'				,type : 'uniPrice'},
	    		{name: 'AF_INSUR_I'					,text:'산출보험료'				,type : 'uniPrice'},
	    		{name: 'AF_ORIMED_INSUR_I'			,text:'건강보험(고지)'			,type : 'uniPrice'},
	    		{name: 'AF_OLDMED_INSUR_I'			,text:'요양보험(고지)'			,type : 'uniPrice'}
			]
	});
	
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';        
        if(!excelWindow) {
        	excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
            		excelConfigName: 'hpa301',
                    grids: [
                    	 {
                    		itemId: 'grid01',
                    		title: '보험료 일괄 반영',                        		
                    		useCheckbox: false,
                    		model : 'excel.hpa301.sheet01',
                    		readApi: 'hpa301ukrService.selectExcelUploadSheet',
                    		columns: [
                     		     	{ dataIndex: 'NAME',					width: 80}, 
									{ dataIndex: 'REPRE_NUM',			 	width: 120},
									{ dataIndex: 'AF_INSUR_AVG_I',			width: 120},
									{ dataIndex: 'AF_INSUR_I',				width: 120},
									{ dataIndex: 'AF_ORIMED_INSUR_I',		width: 120},
									{ dataIndex: 'AF_OLDMED_INSUR_I',		width: 120}
                    		]
                    	}
                    ],
                    listeners: {
                        close: function() {
                            this.hide();
                        }
                    },
                    onApply:function()	{					
//						excelWindow.getEl().mask('로딩중...','loading-indicator');		///////// 엑셀업로드 최신로직
//                    	var me = this;
//                    	var grid = this.down('#grid01');
//            			var records = grid.getStore().getAt(0);	
//            			if(Ext.isEmpty(records) || records.length == 0){
//            				excelWindow.getEl().unmask();
//							grid.getStore().removeAll();
//							return false;
//						}
                    	excelWindow.getEl().mask('로딩중...','loading-indicator');		///////// 엑셀업로드 최신로직
                    	var me = this;
                    	var grid = this.down('#grid01');
            			var records = grid.getStore().getAt(0);	
            			if(Ext.isEmpty(records) || records.length == 0){
            				excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							return false;
						}	
			        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID'), BASE_DATE: UniDate.getDbDateStr(panelSearch.getValue('BASE_DATE')), INSUR_TYPE: panelSearch.getValue('INSUR_TYPE')};
						hpa301ukrService.selectExcelUploadSheet(param, function(provider, response){
							var store = masterGrid.getStore();
					    	var records = response.result;					    	
					    	store.insert(0, records);
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();							
							UniAppManager.setToolbarButtons('save', true);	
							UniAppManager.setToolbarButtons('delete', true);
							UniAppManager.setToolbarButtons('deleteAll', true);
					    });
            		}
             });
        }
        excelWindow.center();
        excelWindow.show();
	};
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: {type: 'vbox', align: 'stretch'},
			border: false,
			items:[
				panelResult,  masterGrid
			]
		},
		panelSearch  	
		],
		id: 'hpa301ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('BASE_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_BASE_DATE', UniDate.get('today'));
			panelSearch.setValue('TO_BASE_DATE', UniDate.get('today'));
			panelSearch.setValue('INSUR_TYPE', '1');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('BASE_DATE', UniDate.get('today'));
			panelResult.setValue('FR_BASE_DATE', UniDate.get('today'));
			panelResult.setValue('TO_BASE_DATE', UniDate.get('today'));
			panelResult.setValue('INSUR_TYPE', '1');
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('newData', false);
			panelSearch.getField('INSUR_TYPE').setReadOnly(false);
			panelResult.getField('INSUR_TYPE').setReadOnly(false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BASE_DATE');
		},
		onQueryButtonDown: function() {			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onNewDataButtonDown : function(additemCode)	{
        	 var r = {
				INSUR_TYPE: panelSearch.getValue('INSUR_TYPE'),
				DIV_CODE: panelSearch.getValue('DIV_CODE'),
				BASE_DATE: panelSearch.getValue('BASE_DATE')	
	        };	        
			masterGrid.createRow(r, 'PERSON_NUMB');
			panelSearch.getField('INSUR_TYPE').setReadOnly(true);
			panelResult.getField('INSUR_TYPE').setReadOnly(true);
			//openDetailWindow(null, true);
		},
		onResetButtonDown:function() {			
			panelSearch.clearForm();
			panelResult.clearForm();			
			masterGrid.getStore().loadData({});	//grid.reset()은 store에 삭제를 시키므로 못씀			
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function(){
			var selRow = Ext.getCmp('hpa301ukrGrid1').getSelectedRecord();
			if(selRow.phantom === true)	{
				Ext.getCmp('hpa301ukrGrid1').deleteSelectedRow();
			}else {
				if(selRow.get('APPLY_YN') == 'Y'){
					alert('인사반영된 자료이므로 삭제할 수 없습니다.');
					return false;
				}
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						Ext.getCmp('hpa301ukrGrid1').deleteSelectedRow();						
					}
				});
			}		
			
		},
		onSaveDataButtonDown : function() {			
			directMasterStore.saveStore();
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('삭제', '전체 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					masterGrid.reset();			
					UniAppManager.app.onSaveDataButtonDown();					
				}
			});
		}
	});//End of Unilite.Main( {
		
    /**
	 * Validation
	 */
    var validation = Unilite.createValidator('validator01', {
        store: directMasterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                
                case "AF_INSUR_AVG_I" :

                    if(panelResult.getValue('INSUR_TYPE') == '1'){
                    	hpa301ukrService.getMonthInsurI(
				 				{
				 					'MONTH_AVG_I':newValue, 
				 					'TYPE' : '1'
				 				}, 
				 				function(provider, response)	{
				 					if(!Ext.isEmpty(provider))	{
					 						record.set('AF_INSUR_I',provider['INSUR_I']);
				 					}
				 				}
				 			)
                    }else if(panelResult.getValue('INSUR_TYPE') == '2'){
                    	hpa301ukrService.getMonthInsurI(
				 				{
				 					'MONTH_AVG_I':newValue, 
				 					'TYPE' : '2'
				 				}, 
				 				function(provider, response)	{
				 					if(!Ext.isEmpty(provider))	{
					 						record.set('AF_ORIMED_INSUR_I',provider['INSUR_I']);
					 						record.set('AF_OLDMED_INSUR_I',provider['INSUR_I3']);
					 						record.set('AF_INSUR_I',provider['INSUR_I2']);
					 						//form.setValue('MED_INSUR_I', provider['INSUR_I2']);	
                                            //form.setValue('OLD_MED_INSUR_I', provider['INSUR_I3']); 
                                            //form.setValue('ORI_MED_INSUR_I', provider['INSUR_I']); 	
				 					}
				 				}
				 			)
                    }

                    break;

            }
            return rv;
        }
    }); // validator
		
		
};


</script>
