<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat200ukr_yp"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_DEPTS2}" storeId="authDeptsStore" /> <!--권한부서-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var excelWindow;    // 엑셀참조

function appMain() {
	
	var colData = ${colData};
	console.log(colData);
	
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);
	
//    var excelFields = createModelExcelField(colData);
//    var excelColumns = createGridExcelColumn(colData);
	
	
	
	
	// 엑셀참조
    Unilite.Excel.defineModel('excel.hat200.sheet01', {
//        fields: excelFields
        fields:[
            {name: 'PERSON_NUMB'  ,text: '사번'       ,type: 'string'},
            {name: 'NAME'         ,text: '성명'       ,type: 'string'},
            {name: 'DUTY_TIME14'  ,text: '외출시간'    ,type: 'string'},
            {name: 'DUTY_TIME04'  ,text: '휴근시간'    ,type: 'string'},
            {name: 'DUTY_TIME51'  ,text: '연장시간'    ,type: 'string'},
            {name: 'DUTY_TIME52'  ,text: '야근시간'    ,type: 'string'},
            {name: 'DUTY_TIME17'  ,text: '휴일연장시간' ,type: 'string'},
            {name: 'DUTY_TIME18'  ,text: '휴일야근시간' ,type: 'string'},
            {name: 'DUTY_TIME19'  ,text: '기타시간'    ,type: 'string'},
            {name: 'DUTY_TIME80'  ,text: '가드수당'    ,type: 'string'},
            {name: 'DUTY_NUM10'   ,text: '연차일수'    ,type: 'string'},
//            {name: 'DUTY_NUM20'   ,text: '질병휴직일수' ,type: 'string'},
//            {name: 'DUTY_NUM21'   ,text: '결핵휴직일수' ,type: 'string'},
//            {name: 'DUTY_NUM22'   ,text: '출산휴직일수' ,type: 'string'},
            {name: 'DUTY_NUM07'   ,text: '유계결근일수' ,type: 'string'},
            {name: 'DUTY_NUM23'   ,text: '무계결근일수' ,type: 'string'},
            {name: 'DUTY_NUM70'   ,text: '평일당직' ,type: 'string'},
            {name: 'DUTY_NUM71'   ,text: '휴일당직' ,type: 'string'},
            {name: 'DUTY_NUM53'   ,text: '휴일근무' ,type: 'string'},
            {name: 'DUTY_NUM57'   ,text: '사역일' ,type: 'string'},
            {name: 'DUTY_NUM58'   ,text: '주휴일수' ,type: 'string'}
        ]
    });
    
    function openExcelWindow() {
            var me = this;
            var vParam = {};
            var appName = 'Unilite.com.excel.ExcelUpload';
            if(!excelWindow) {
                excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                        modal: false,
                        excelConfigName: 's_hat200ukr_yp',
                        extParam: {
                            'PGM_ID'    : 's_hat200ukr_yp'
//                            'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                        },
                        grids: [{
                            itemId: 'grid01',
                            title: '월근무현황등록양식',                                
                            useCheckbox: false,
                            model : 'excel.hat200.sheet01',
                            readApi: 's_hat200ukr_ypService.selectExcelUploadSheet1',
//                                columns:excelColumns
                            columns:[
                                {dataIndex: 'PERSON_NUMB'                , width: 100},
                                {dataIndex: 'NAME'                       , width: 100},
                                {dataIndex: 'DUTY_TIME14'                , width: 100},
                                {dataIndex: 'DUTY_TIME04'                , width: 100},
                                {dataIndex: 'DUTY_TIME51'                , width: 100},
                                {dataIndex: 'DUTY_TIME52'                , width: 100},
                                {dataIndex: 'DUTY_TIME17'                , width: 100},
                                {dataIndex: 'DUTY_TIME18'                , width: 100},
                                {dataIndex: 'DUTY_TIME19'                , width: 100},
                                {dataIndex: 'DUTY_TIME80'                , width: 100},
                                {dataIndex: 'DUTY_NUM10'                 , width: 100},
//                                {dataIndex: 'DUTY_NUM20'                 , width: 100},
//                                {dataIndex: 'DUTY_NUM21'                 , width: 100},
//                                {dataIndex: 'DUTY_NUM22'                 , width: 100},
                                {dataIndex: 'DUTY_NUM07'                 , width: 100},
                                {dataIndex: 'DUTY_NUM23'                 , width: 100},                             
                                {dataIndex: 'DUTY_NUM70'                 , width: 100},                               
                                {dataIndex: 'DUTY_NUM71'                 , width: 100},                               
                                {dataIndex: 'DUTY_NUM53'                 , width: 100},                               
                                {dataIndex: 'DUTY_NUM57'                 , width: 100},                               
                                {dataIndex: 'DUTY_NUM58'                 , width: 100},                               
                            ]
                        }],
                        listeners: {
                            show: function( panel, eOpts )  {
                            	Ext.getBody().mask('엑셀업로드작업중...','loading-indicator');
                            },
                            close: function() {
                                this.hide();
                            },
                            hide: function() {
                            	Ext.getBody().unmask();
                            }
                        },
                        onApply:function()  {
                            excelWindow.getEl().mask('로딩중...','loading-indicator');     ///////// 엑셀업로드 최신로직
                            var me = this;
                            var grid = this.down('#grid01');
                            var records = grid.getStore().getAt(0); 
                            if(Ext.isEmpty(records)) {
                                excelWindow.getEl().unmask();
                                return false;
                            }
                            var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
                            s_hat200ukr_ypService.selectExcelUploadApply(param, function(provider, response){
                                var store = masterGrid.getStore();
                                var records = response.result;
                                
//                                var masterRecords = directMasterStore.data.filterBy(directMasterStore.filterNewOnly);
                                var masterRecords = directMasterStore.data.items;
                                if(masterRecords.length > 0)  {
                                	Ext.each(records, function(record, i){
                                        Ext.each(masterRecords, function(item, j){
                                            if(item.data['PERSON_NUMB'] == record.PERSON_NUMB){
                                            	item.set('DUTY_TIME14',record.DUTY_TIME14);
                                                item.set('DUTY_TIME04',record.DUTY_TIME04);
                                                item.set('DUTY_TIME51',record.DUTY_TIME51);
                                                item.set('DUTY_TIME52',record.DUTY_TIME52);
                                                item.set('DUTY_TIME17',record.DUTY_TIME17);
                                                item.set('DUTY_TIME18',record.DUTY_TIME18);
                                                item.set('DUTY_TIME19',record.DUTY_TIME19);
                                                item.set('DUTY_TIME80',record.DUTY_TIME80);
                                                item.set('DUTY_NUM10',record.DUTY_NUM10);
                                                item.set('DUTY_NUM20',record.DUTY_NUM20);
                                                item.set('DUTY_NUM21',record.DUTY_NUM21);
                                                item.set('DUTY_NUM22',record.DUTY_NUM22);
                                                item.set('DUTY_NUM07',record.DUTY_NUM07);
                                                item.set('DUTY_NUM23',record.DUTY_NUM23);
                                                item.set('DUTY_NUM70',record.DUTY_NUM70);
                                                item.set('DUTY_NUM71',record.DUTY_NUM71);
                                                item.set('DUTY_NUM53',record.DUTY_NUM53);
                                                item.set('DUTY_NUM57',record.DUTY_NUM57);
                                                item.set('DUTY_NUM58',record.DUTY_NUM58);
//                                                Ext.each(colData, function(colItem, index){
//                                                	item.set('DUTY_NUM'+colItem.SUB_CODE, record.get('DUTY_NUM'+colItem.SUB_CODE));
//                                                	item.set('DUTY_TIME'+colItem.SUB_CODE, record.get('DUTY_TIME'+colItem.SUB_CODE));
//                                                })
                                            }
                                        })
                                	})
                                }
                                
//                                store.insert(0, records);
//                                console.log("response",response)
                                excelWindow.getEl().unmask();
                                grid.getStore().removeAll();
                                me.hide();
                            });
                        }
                 });
            }
            excelWindow.center();
            excelWindow.show();
    }
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hat200ukr_ypModel', {
		fields: fields
	});
	
	Unilite.defineModel('s_hat200ukr_ypModel2', {
		fields: [
				{name: 'TOT_DAY' 		, text: '달력일수'		, type: 'string'},
				{name: 'WEEK_DAY' 		, text: '총근무일수'		, type: 'string'},
				{name: 'DED_DAY' 		, text: '차감일수'		, type: 'string'},
				{name: 'WORK_DAY' 		, text: '실근무일수'		, type: 'string'},
				{name: 'SUN_DAY' 		, text: '일요일'		, type: 'string'},
				{name: 'SAT_DAY' 		, text: '토요일'		, type: 'string'},				
				{name: 'DED_TIME' 		, text: '차감시간'		, type: 'string'},				
				{name: 'WORK_TIME' 		, text: '실근무시간'		, type: 'string'},
				{name: 'EXTEND_WORK_TIME' 		, text: '연장근로'		, type: 'string'},
				{name: 'NON_WEEK_DAY' 		, text: '휴무일수'		, type: 'string'},
				{name: 'WEEK_GIVE' 		, text: '주차지급일수'	, type: 'string'},
				{name: 'FULL_GIVE' 		, text: '만근지급일수'	, type: 'string'},
				{name: 'MONTH_GIVE' 	, text: '월차지급일수'	, type: 'string'},
				{name: 'MENS_GIVE' 		, text: '보건지급일수'	, type: 'string'}
		         ]
	});//End of Unilite.defineModel('s_hat200ukr_ypModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_hat200ukr_ypService.selectList',
			destroy: 's_hat200ukr_ypService.deleteHat200',
			update: 's_hat200ukr_ypService.updateHat200',
			syncAll: 's_hat200ukr_ypService.saveAll'
		}
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_hat200ukr_ypMasterStore1', {
		model: 's_hat200ukr_ypModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			allDeletable: true,		// 전체삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();		
			param.EMPLOY_TYPE = panelSearch.getValue('EMPLOY_TYPE');
			param.SUB_CODE = panelSearch.getValue('SUB_CODE');
			
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= panelResult.getValues();                
                if(inValidRecs.length == 0 )    {
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                            directMasterStore.loadStoreRecords();
                        } 
                    };  
                    this.syncAllDirect(config);     
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
		}, 
        listeners: {
            load: function(store, records, successful, eOpts){
            	var cnt = 0;
            	Ext.each(records, function(record,i) {
            		if(record.get('FLAG') == 'N'){
//                        record.phantom = true;
                        record.set('REMARK',' ');
            			
                        cnt = cnt + 1;
            		}
            	})
            	if(cnt > 0){
            	    UniAppManager.setToolbarButtons('save', true);
            	   
                    panelResult.getField('DUTY_YYYYMM').setReadOnly(true);
            	}else{
            	    UniAppManager.setToolbarButtons('save', false);	
                   
                    panelResult.getField('DUTY_YYYYMM').setReadOnly(false);
            	}
            	
            }
        }
		
	});
	
	var directMasterStore2 = Unilite.createStore('s_hat200ukr_ypMasterStore2', {
		model: 's_hat200ukr_ypModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 's_hat200ukr_ypService.selectList2'
			}
		},
		listeners: {
	        load: function(store, records) {
	            var form1 = Ext.getCmp('detailForm1');
	            var form2 = Ext.getCmp('detailForm2');
	            if (store.getCount() > 0) {
	            	form1.loadRecord(records[0]);
	            	form2.loadRecord(records[0]);	 
	            }
	        }
	    },
		loadStoreRecords: function(person_numb){
			var param= Ext.getCmp('resultForm').getValues();
			param.PERSON_NUMB = person_numb;
			 
            param.EMPLOY_TYPE = panelSearch.getValue('EMPLOY_TYPE');
            param.SUB_CODE = panelSearch.getValue('SUB_CODE');
			console.log(param);
			this.load({
				params: param
			});
		}
		
	});
	
	//End of var directMasterStore = Unilite.createStore('s_hat200ukr_ypMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '추가정보', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사원구분',
				name: 'EMPLOY_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031'
			},{
				fieldLabel: '사원그룹',
				name: 'SUB_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031'
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '근태년월',
			xtype: 'uniMonthfield',
			name: 'DUTY_YYYYMM',                    
			value: new Date(),                    
			allowBlank: false
		},
		{ 
        	fieldLabel: '사업장',
        	name: 'DIV_CODE', 
        	xtype: 'uniCombobox', 
        	comboType:'BOR120',
        	value :'01'
    	},{
			fieldLabel: '급여지급방식',
			name: 'PAY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028'
		},{
			fieldLabel: '지급차수',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031'
		},
		{
            fieldLabel: '부서',
            name: 'DEPTS2',
            xtype: 'uniCombobox',
            width:300,
            multiSelect: true,
            store: Ext.data.StoreManager.lookup('authDeptsStore'),
            disabled:true,
            hidden:false,
            allowBlank:false
        },
		Unilite.treePopup('DEPTTREE',{
            itemId : 'deptstree',
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
			useLike:true
		}),{
			fieldLabel: '고용형태',
			name: 'PAY_GUBUN', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H011'
		},			
	     	Unilite.popup('Employee',{ 
			validateBlank: false
		})]	
    });
    
	var detailForm1 = Unilite.createSearchForm('detailForm1',{
		padding:'1 1 1 1',
		flex: 2,
		border:true,
		region: 'west',
		layout : {type : 'uniTable', columns : 1},
	    items: [{	
	    	xtype:'container',
	        defaultType: 'uniTextfield',
	        flex: 1,
	        layout: {
	        	type: 'uniTable',
	        	columns : 3
	        },
	        defaults: { labelWidth: 150, readOnly: true, fieldStyle: "text-align:right;"},
	        items: [
	        	{   
					xtype: 'uniTextfield', 
					fieldLabel: '달력일수',
					name: 'TOT_DAY'
				},
	        	{ 
					xtype: 'uniTextfield',
					fieldLabel: '일요일',
					name: 'SUN_DAY'
				},
	        	{
	        		fieldLabel: '연장근로',
	        		name: 'EXTEND_WORK_TIME'
	        	},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '총근무일수',
					name: 'WEEK_DAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '토요일',
					name: 'SAT_DAY'
				},	        	
	        	{
	        		fieldLabel: '휴무일수',	        	
	        		name: 'NON_WEEK_DAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '차감일수',
					name: 'DED_DAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '차감시간',
					name: 'DED_TIME'
				},	        	
	        	{
	        		fieldLabel: '휴일일수',	        	
	        		name: 'HOLIDAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '실근무일수',
					name: 'WORK_DAY'
				},
				{ 
					xtype: 'uniTextfield',
					fieldLabel: '실근무시간',
					name: 'WORK_TIME'
				}
	        ]
		}]
    });
    
    var detailForm2 = Unilite.createSearchForm('detailForm2',{
		padding:'1 1 1 1',
		flex: 1,
		border:true,
		region: 'center',
		layout : {type : 'uniTable', columns : 1},
	    items: [{
	    	xtype:'container',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 1
	        },
	        defaults: { labelWidth: 150, readOnly: true, fieldStyle: "text-align:right;"},
	        items: [
	        	{ 
					fieldLabel: '주차지급일수',
					name: 'WEEK_GIVE'
				},
				{ 
					fieldLabel: '만근지급일수',
					name: 'FULL_GIVE'
				},{ 
					fieldLabel: '월차지급일수',
					name: 'MONTH_GIVE'
				},{ 
					fieldLabel: '보건지급일수',
					name: 'MENS_GIVE'
				}
	        ]
		}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('s_hat200ukr_ypGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        },
        
        tbar: [{
            xtype: 'splitbutton',
            itemId:'refTool',
            text: '참조...',
            iconCls : 'icon-referance',
            menu: Ext.create('Ext.menu.Menu', {
                items: [{
                    itemId: 'excelBtn',
                    text: '엑셀참조',
                    handler: function() {
                    	if(!panelResult.getInvalidMessage()){
                            return false;
                        }
                        masterGrid.getStore().loadStoreRecords();
                        openExcelWindow();
                    }
                }]
            })
        }],
//         tbar: [{
//         	text:'상세보기',
//         	handler: function() {
//         		var record = masterGrid.getSelectedRecord();
// 	        	if(record) {
// 	        		openDetailWindow(record);
// 	        	}
//         	}
//         }],
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
// 		selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }),
		store: directMasterStore,
		columns: columns,
		listeners: {
            selectionchange: function(grid, selNodes ){
				if (typeof selNodes[0] != 'undefined') {
            	  console.log(selNodes[0].data.PERSON_NUMB);
                  var person_numb = selNodes[0].data.PERSON_NUMB;
                  directMasterStore2.loadStoreRecords(person_numb);
                  UniAppManager.app.setToolbarButtons('delete', true);
                }
				
            }/*,            
            uniOnChange: function(grid, dirty, eOpts) {	
            	alert("change");
				UniAppManager.app.setToolbarButtons('save', true);
			}*/
		}
	});//End of var masterGrid = Unilite.createGr100id('s_hat200ukr_ypGrid1', {   
                                                 
	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult, 
				{	xtype: 'container',
					region: 'south',
//					layout: 'border',
					layout: {type: 'hbox'},
					items:[
						detailForm1, detailForm2
					]
				}
			]
		},
			panelSearch  	
		],
		id: 's_hat200ukr_ypApp',
		fnInitBinding: function() {
			UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['newData','delete','save'], false);
            panelResult.getField('DUTY_YYYYMM').setReadOnly(false);
			masterGrid.on('edit', function(editor, e) {
				UniAppManager.setToolbarButtons('save',true);
			})
			
			panelResult.onLoadSelectText('DUTY_YYYYMM');
		},
		onResetButtonDown: function(){
            masterGrid.reset();
            directMasterStore.clearData();
            directMasterStore2.clearData();
            detailForm1.clearForm();
            detailForm2.clearForm();
            UniAppManager.app.fnInitBinding();
        },
		onQueryButtonDown: function() {	
            if(!panelResult.getInvalidMessage()) return;
            
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		},
		onSaveDataButtonDown: function() {
			if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						if(record.get('ACCOUNT_Q') != 0)
							{
								alert('<t:message code="unilite.msg.sMM008"/>');
							}else{
						
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					directMasterStore.removeAll();
					directMasterStore.saveStore();
				}
			});			
		},
		dutyCheck: function(fieldName, record, newValue, oldValue, e){		//입력전 체크
			var param = {PAY_CODE: record.get('PAY_CODE'), DUTY_CODE: e.column.DUTY_CODE}
			s_hat200ukr_ypService.wirteCheck(param, function(provider, response)	{
				fieldName.indexOf('DUTY_NUM') > -1 ? activeField = 'DUTY_NUM' : activeField = 'DUTY_TIME';
				switch(activeField) {				
					case "DUTY_NUM" :
						if(Ext.isEmpty(provider)){
							record.set(fieldName, oldValue);
							alert(Msg.sMB379);
							return false;
						}else if(provider[0].COTR_TYPE != "2"){
							record.set(fieldName, oldValue);
							alert(Msg.sMH1206);
							return false;
							
						}
						if(Ext.isEmpty(record.get('PERSON_NUMB'))){
							alert(Msg.sMH1082);
							record.set(fieldName, oldValue);
							return false;							
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							alert(Msg.sMB076);	//양수만 입력 가능합니다.
							record.set(fieldName, oldValue);
							return false;
						}
						if(Ext.isEmpty(record.get('FLAG'))){
							record.set('FLAG', 'U');
						}
						if(e.column.DUTY_CODE == "25"){	//보건
							if(record.get('SEX_CODE') == "M"){
								alert(Msg.sMH912);
								record.set(fieldName, oldValue);
								return false;
							}
							if(newValue > 1){
								alert(Msg.sMH1203);
								record.set(fieldName, oldValue);
								return false;
							}
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "20"){	//년차사용유무체크 및 수량 체크
							if(record.get('YEAR_GIVE') == "N"){
								alert(Msg.sMH913);
								record.set(fieldName, oldValue);
								return false;
							}
							if(newValue > record.get('YEAR_NUM')){
								alert(Msg.sMH914);
//								record.set(fieldName, oldValue);
		//						return false;
							}
						}
						if(e.column.DUTY_CODE == "10"){	//무휴
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "11"){ //결근
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "22"){ //월차
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
					break;	
						
					case "DUTY_TIME" :
						if(Ext.isEmpty(provider)){
							record.set(fieldName, oldValue);
							alert(Msg.sMB379);
							return false;
						}else if(provider[0].COTR_TYPE != "1"){
							record.set(fieldName, oldValue);
							alert(Msg.sMH1207);
							return false;
							
						}
						if(Ext.isEmpty(record.get('PERSON_NUMB'))){
							alert(Msg.sMH1082);
							record.set(fieldName, oldValue);
							return false;							
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							alert(Msg.sMB076);	//양수만 입력 가능합니다.
							record.set(fieldName, oldValue);
							return false;
						}
						if(Ext.isEmpty(record.get('FLAG'))){
							record.set('FLAG', 'U');
						}
						if(e.column.DUTY_CODE == "25"){	//보건
							if(record.get('SEX_CODE') == "M"){
								alert(Msg.sMH912);
								record.set(fieldName, oldValue);
								return false;
							}
							if(newValue > 1){
								alert(Msg.sMH1203);
								record.set(fieldName, oldValue);
								return false;
							}
							if(record.get('DAYDIFF') < newValue){
								alert(Msg.sMH1037);
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "20"){	//년차사용유무체크 및 수량 체크
							if(record.get('YEAR_GIVE') == "N"){
								alert(Msg.sMH913);
								record.set(fieldName, oldValue);
								return false;
							}
//							if(newValue > record.get('YEAR_NUM')){
//								alert(Msg.sMH914);
//								record.set(fieldName, oldValue);
		//						return false;
//							}
						}
//						if(e.column.DUTY_CODE == "10"){	//무휴
//							if(record.get('DAYDIFF') < newValue){
//								alert(Msg.sMH1037);
//								record.set(fieldName, oldValue);
//								return false;
//							}
//						}
//						if(e.column.DUTY_CODE == "11"){ //결근
//							if(record.get('DAYDIFF') < newValue){
//								alert(Msg.sMH1037);
//								record.set(fieldName, oldValue);
//								return false;
//							}
//						}
//						if(e.column.DUTY_CODE == "22"){ //월차
//							if(record.get('DAYDIFF') < newValue){
//								alert(Msg.sMH1037);
//								record.set(fieldName, oldValue);
//								return false;
//							}
//						}
					break;	
				}
				
			});
		}
	});//End of Unilite.Main( {
		
	// 모델 필드 생성
	function createModelField(colData) {
		
		var fields = [
						{name: 'FLAG',				text: ' ', 			editable:false,		type: 'string'},
						{name: 'DIV_CODE',			text: '사업장', 	editable:false,		type: 'string', comboType:'BOR120', comboCode:'1234'},
						{name: 'DEPT_NAME',		text: '부서', 	editable:false,		type: 'string'},
						{name: 'NAME',				text: '성명', 	editable:false,		type: 'string'},
						{name: 'PERSON_NUMB',	text: '사번', 	editable:false,		type: 'string'},
						{name: 'DUTY_YYYYMM',	text: '연월', 	editable:false,		type: 'string'},
						{name: 'PAY_PROV_FLAG',	text: '지급차수', 	editable:false,		type: 'string'},
						{name: 'DUTY_FROM',	text: '연월첫일', 	editable:false,		type: 'string'},
						{name: 'DUTY_TO',	text: '연월말일', 	editable:false,		type: 'string'},
						{name: 'DEPT_CODE',	text: '부서', 	editable:false,		type: 'string'},
						{name: 'DEPT_CODE2',	text: '부서', 	editable:false,		type: 'string'}						
					];
					
		Ext.each(colData, function(item, index){
			fields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'일수', type:'string'});
			fields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'시간', type:'string'});
		});
		
		fields.push({name: 'REMARK',	text: '비고',	type: 'string'});
		
		console.log(fields);
// 		alert(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {		
		
		var columns = [
					{dataIndex: 'FLAG',			width: 30, align: 'center'},
					{dataIndex: 'DIV_CODE',			width: 130},
					{dataIndex: 'DEPT_NAME',		width: 150},
					{dataIndex: 'NAME',				width: 80},
					{dataIndex: 'PERSON_NUMB',		width: 100},
					{dataIndex: 'DUTY_YYYYMM',		width: 100, hidden: true},
					{dataIndex: 'PAY_PROV_FLAG',		width: 100, hidden: true},
					{dataIndex: 'DUTY_FROM',		width: 100, hidden: true},
					{dataIndex: 'DUTY_TO',		width: 100, hidden: true},
					{dataIndex: 'DEPT_CODE',		width: 100, hidden: true},
					{dataIndex: 'DEPT_CODE2',		width: 100, hidden: true}
				];
					
		Ext.each(colData, function(item, index){
			columns.push({text: item.CODE_NAME,
				columns:[ 
					{dataIndex: 'DUTY_NUM' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
						renderer: function(value, metaData, record) {							
							return Ext.util.Format.number(value, '0.0');
						}
					},
					{dataIndex: 'DUTY_TIME' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
						renderer: function(value, metaData, record) {							
							return Ext.util.Format.number(value, '0.00');
						}
					}
			]});
		});
		columns.push({dataIndex: 'REMARK',		minWidth: 200, flex: 1});
		console.log(columns);
		return columns;
	}
	
	// 엑셀 업로드 관련 모델 필드 생성
//    function createModelExcelField(colData) {
//        
//        var excelFields = [
//            {name: 'PERSON_NUMB',   text: '사번',    type: 'string'},
//            {name: 'NAME',          text: '성명',    type: 'string'}
//        ];
//                    
//        Ext.each(colData, function(item, index){
//            excelFields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'일수', type:'string'});
//            excelFields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'시간', type:'string'});
//        });
//        return excelFields;
//    }
    
    // 엑셀 업로드 관련 그리드 컬럼 생성
//    function createGridExcelColumn(colData) {        
//        var excelColumns = [
//            {dataIndex: 'PERSON_NUMB',      width: 80},
//            {dataIndex: 'NAME',             width: 80}
//        ];
//        
//        Ext.each(colData, function(item, index){
//            excelColumns.push({text: item.CODE_NAME,
//                columns:[
//                    {dataIndex: 'DUTY_NUM' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
//                        renderer: function(value, metaData, record) {
//                            return Ext.util.Format.number(value, '0.0');
//                        }
//                    },
//                    {dataIndex: 'DUTY_TIME' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
//                        renderer: function(value, metaData, record) {
//                            return Ext.util.Format.number(value, '0.00');
//                        }
//                    }
//            ]});
//        });
//        return excelColumns;
//    }
	
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var activeField = '';
			UniAppManager.app.dutyCheck(fieldName, record, newValue, oldValue, e);					
			
			return rv;
//			setTimeout( rv, 100);
		}
	}); // validator
};


</script>