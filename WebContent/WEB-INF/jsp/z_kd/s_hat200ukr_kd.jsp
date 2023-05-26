<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat200ukr_kd"  >
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
var dutyNumFormat  = '${DUTY_NUM_FORMAT}';
var dutyTimeFormat = '${DUTY_TIME_FORMAT}';
var dutyNumDeP 	   = dutyNumFormat.indexOf('.') > -1 ? dutyNumFormat.length-1 - dutyNumFormat.indexOf('.') : 0;
var dutyTimeDeP    = dutyTimeFormat.indexOf('.') > -1 ? dutyTimeFormat.length-1 - dutyTimeFormat.indexOf('.') : 0;
var closeDate = '${CLOSE_DATE}';
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
            {name: 'PERSON_NUMB'  		,text: '<t:message code="system.label.human.personnumb" default="사번"/>'       ,type: 'string'},
            {name: 'NAME'         					,text: '<t:message code="system.label.human.name" default="성명"/>'       ,type: 'string'},
            {name: 'DUTY_TIME14'  			,text: '<t:message code="system.label.human.outingtime" default="외출시간"/>'    ,type: 'string'},
            {name: 'DUTY_TIME04'  			,text: '<t:message code="system.label.human.closingtime" default="휴근시간"/>'    ,type: 'string'},
            {name: 'DUTY_TIME15'  			,text: '<t:message code="system.label.human.extensiontime" default="연장시간"/>'    ,type: 'string'},
            {name: 'DUTY_TIME16'  			,text: '<t:message code="system.label.human.overtiming" default="야근시간"/>'    ,type: 'string'},
            {name: 'DUTY_TIME17'  			,text: '<t:message code="system.label.human.hldextensiontime" default="휴일연장시간"/>' ,type: 'string'},
            {name: 'DUTY_TIME18'  			,text: '<t:message code="system.label.human.hldovertiming" default="휴일야근시간"/>' ,type: 'string'},
            {name: 'DUTY_TIME19'  			,text: '<t:message code="system.label.human.othertime" default="기타시간"/>'    ,type: 'string'},
            {name: 'DUTY_NUM10'   			,text: '<t:message code="system.label.human.yeardatenum" default="연차일수"/>'    ,type: 'string'},
//            {name: 'DUTY_NUM20'   ,text: '질병휴직일수' ,type: 'string'},
//            {name: 'DUTY_NUM21'   ,text: '결핵휴직일수' ,type: 'string'},
//            {name: 'DUTY_NUM22'   ,text: '출산휴직일수' ,type: 'string'},
            {name: 'DUTY_NUM07'  			,text: '<t:message code="system.label.human.yabsenteeismdate" default="유계결근일수"/>' ,type: 'string'},
            {name: 'DUTY_NUM23'   			,text: '<t:message code="system.label.human.nabsenteeismdate" default="무계결근일수"/>' ,type: 'string'}
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
                        excelConfigName: 's_hat200ukr_kd',
                        extParam: {
                            'PGM_ID'    : 's_hat200ukr_kd'
//                            'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                        },
                        grids: [{
                            itemId: 'grid01',
                            title: '<t:message code="system.label.human.monthlyworkinfotemplate" default="월근무현황등록양식"/>',
                            useCheckbox: false,
                            model : 'excel.hat200.sheet01',
                            readApi: 's_hat200ukr_kdService.selectExcelUploadSheet1',
//                                columns:excelColumns
                            columns:[
                                {dataIndex: 'PERSON_NUMB'                , width: 100},
                                {dataIndex: 'NAME'                       , width: 100},
                                {dataIndex: 'DUTY_TIME14'                , width: 100},
                                {dataIndex: 'DUTY_TIME04'                , width: 100},
                                {dataIndex: 'DUTY_TIME15'                , width: 100},
                                {dataIndex: 'DUTY_TIME16'                , width: 100},
                                {dataIndex: 'DUTY_TIME17'                , width: 100},
                                {dataIndex: 'DUTY_TIME18'                , width: 100},
                                {dataIndex: 'DUTY_TIME19'                , width: 100},
                                {dataIndex: 'DUTY_NUM10'                 , width: 100},
//                                {dataIndex: 'DUTY_NUM20'                 , width: 100},
//                                {dataIndex: 'DUTY_NUM21'                 , width: 100},
//                                {dataIndex: 'DUTY_NUM22'                 , width: 100},
                                {dataIndex: 'DUTY_NUM07'                 , width: 100},
                                {dataIndex: 'DUTY_NUM23'                 , width: 100}
                            ]
                        }],
                        listeners: {
                            show: function( panel, eOpts )  {
                            	Ext.getBody().mask('<t:message code="system.message.human.message040" default="엑셀업로드작업중..."/>','loading-indicator');
                            },
                            close: function() {
                                this.hide();
                            },
                            hide: function() {
                            	Ext.getBody().unmask();
                            }
                        },
                        onApply:function()  {
                            excelWindow.getEl().mask('<t:message code="system.label.human.loading" default="로딩중..."/>','loading-indicator');     ///////// 엑셀업로드 최신로직
                            var me = this;
                            var grid = this.down('#grid01');
                            var records = grid.getStore().getAt(0);
                            if(Ext.isEmpty(records)) {
                                excelWindow.getEl().unmask();
                                return false;
                            }
                            var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
                            hat200ukrService.selectExcelUploadApply(param, function(provider, response){
                                var store = masterGrid.getStore();
                                var records = response.result;

//                                var masterRecords = directMasterStore.data.filterBy(directMasterStore.filterNewOnly);
                                var masterRecords = directMasterStore.data.items;
                                if(masterRecords.length > 0)  {
                                	Ext.each(records, function(record, i){
                                        Ext.each(masterRecords, function(item, j){
                                            if(item.data['PERSON_NUMB'] == record.PERSON_NUMB){
                                            	if(item.data['FLAG'] == 'N'){
                                            		item.set('FLAG', 'N');
                                            	}else{
                                            	    item.set('FLAG', 'U');
                                            	}
                                            	item.set('DUTY_TIME14',record.DUTY_TIME14);
                                                item.set('DUTY_TIME04',record.DUTY_TIME04);
                                                item.set('DUTY_TIME15',record.DUTY_TIME15);
                                                item.set('DUTY_TIME16',record.DUTY_TIME16);
                                                item.set('DUTY_TIME17',record.DUTY_TIME17);
                                                item.set('DUTY_TIME18',record.DUTY_TIME18);
                                                item.set('DUTY_TIME19',record.DUTY_TIME19);
                                                item.set('DUTY_NUM10',record.DUTY_NUM10);
                                                item.set('DUTY_NUM20',record.DUTY_NUM20);
                                                item.set('DUTY_NUM21',record.DUTY_NUM21);
                                                item.set('DUTY_NUM22',record.DUTY_NUM22);
                                                item.set('DUTY_NUM07',record.DUTY_NUM07);
                                                item.set('DUTY_NUM23',record.DUTY_NUM23);
//                                                Ext.each(colData, function(colItem, index){
//                                                	item.set('DUTY_NUM'+colItem.SUB_CODE, record.get('DUTY_NUM'+colItem.SUB_CODE));
//                                                	item.set('DUTY_TIME'+colItem.SUB_CODE, record.get('DUTY_TIME'+colItem.SUB_CODE));
//                                                })
                                            }
                                        })
                                	})
                                }
                                //UniAppManager.setToolbarButtons('save',true);
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
	Unilite.defineModel('s_Hat200ukr_kdModel', {
		fields: fields
	});

	Unilite.defineModel('s_Hat200ukr_kdModel2', {
		fields: [
				{name: 'TOT_DAY' 							, text: '<t:message code="system.label.human.totday1" default="달력일수"/>'		, type: 'string'},
				{name: 'WEEK_DAY' 						, text: '<t:message code="system.label.human.weekday1" default="총근무일수"/>'		, type: 'string'},
				{name: 'DED_DAY' 						, text: '<t:message code="system.label.human.dedday" default="차감일수"/>'		, type: 'string'},
				{name: 'WORK_DAY' 					, text: '<t:message code="system.label.human.actualworkdate" default="실근무일수"/>'		, type: 'string'},
				{name: 'SUN_DAY' 						, text: '<t:message code="system.label.human.sunday" default="일요일"/>'		, type: 'string'},
				{name: 'SAT_DAY' 							, text: '<t:message code="system.label.human.satday" default="토요일"/>'		, type: 'string'},
				{name: 'DED_TIME' 						, text: '<t:message code="system.label.human.dedtime" default="차감시간"/>'		, type: 'string'},
				{name: 'WORK_TIME' 					, text: '<t:message code="system.label.human.worktime" default="실근무시간"/>'		, type: 'string'},
				{name: 'EXTEND_WORK_TIME' 	, text: '<t:message code="system.label.human.extendwork" default="연장근로"/>'		, type: 'string'},
				{name: 'NON_WEEK_DAY' 			, text: '<t:message code="system.label.human.nonweekdate" default="휴무일수"/>'		, type: 'string'},
				{name: 'WEEK_GIVE' 						, text: '<t:message code="system.label.human.weekgive" default="주차지급일수"/>'	, type: 'string'},
				{name: 'FULL_GIVE' 						, text: '<t:message code="system.label.human.fullgive" default="만근지급일수"/>'	, type: 'string'},
				{name: 'MONTH_GIVE' 					, text: '<t:message code="system.label.human.monthgive1" default="월차지급일수"/>'	, type: 'string'},
				{name: 'MENS_GIVE' 						, text: '<t:message code="system.label.human.mensgive" default="보건지급일수"/>'	, type: 'string'}
		         ]
	});//End of Unilite.defineModel('Hat200ukrModel', {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_hat200ukr_kdService.selectList',
			destroy: 's_hat200ukr_kdService.deleteHat200',
			update: 's_hat200ukr_kdService.updateHat200',
			syncAll: 's_hat200ukr_kdService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_hat200ukr_kdMasterStore1', {
		model: 's_Hat200ukr_kdModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
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
//			UniAppManager.setToolbarButtons('deleteAll',true);

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
                            //UniAppManager.setToolbarButtons('save', false);
                        }
                    };
                    this.syncAllDirect(config);
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
		},
        listeners: {
            load: function(store, records, successful, eOpts){
                //UniAppManager.setToolbarButtons('save',false);
            	var cnt = 0;
            	setTimeout(function() {
	            	Ext.each(records, function(record,i) {
	            		if(record.get('FLAG') == 'N'){
	                        //UniAppManager.setToolbarButtons('save',true);
	                        record.set('REMARK',' ');
	                        cnt = cnt + 1;
	            		}
	
	            	})
            	}, 100);
            	if(cnt > 0){
                    panelResult.getField('DUTY_YYYYMM').setReadOnly(true);
            	}else{
                    panelResult.getField('DUTY_YYYYMM').setReadOnly(false);
            	}

            }
        }

	});

	var directMasterStore2 = Unilite.createStore('s_hat200ukr_kdMasterStore2', {
		model: 's_Hat200ukr_kdModel2',
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
				read: 's_hat200ukr_kdService.selectList2'
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
	            detailForm1.unmask();
	        }
	    },
		loadStoreRecords: function(person_numb){
			var param= Ext.getCmp('resultForm').getValues();
			param.PERSON_NUMB = person_numb;

            param.EMPLOY_TYPE = panelSearch.getValue('EMPLOY_TYPE');
            param.SUB_CODE = panelSearch.getValue('SUB_CODE');
			console.log(param);
			detailForm1.mask("Loading...");
			this.load({
				params: param
			});
		}

	});

	//End of var directMasterStore = Unilite.createStore('hat200ukrMasterStore1', {

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.human.addinfo" default="추가정보"/>',
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
				name: 'EMPLOY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031'
			},{
				fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
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
			fieldLabel: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>',
			xtype: 'uniMonthfield',
			name: 'DUTY_YYYYMM',
			value: new Date(),
			allowBlank: false
		},
		{
        	fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
        	name: 'DIV_CODE',
        	xtype: 'uniCombobox',
        	comboType:'BOR120',
        	value :'01'
    	},{
			fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name: 'PAY_CODE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028'
		},{
			fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
			name: 'PAY_PROV_FLAG',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031'
		},
		{
            fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
			useLike:true
		}),{
			fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
			name: 'PAY_GUBUN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H011'
		},
	     	Unilite.popup('Employee',{
	     	valueFieldName:'PERSON_NUMB',
            textFieldName:'NAME',
			autoPopup:true,
			listeners: {
                applyextparam: function(popup){
                }
            }
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
					fieldLabel: '<t:message code="system.label.human.totday1" default="달력일수"/>',
					name: 'TOT_DAY'
				},
	        	{
					xtype: 'uniTextfield',
					fieldLabel: '<t:message code="system.label.human.sunday" default="일요일"/>',
					name: 'SUN_DAY'
				},
	        	{
	        		fieldLabel: '<t:message code="system.label.human.extendwork" default="연장근로"/>',
	        		name: 'EXTEND_WORK_TIME',
	        		hidden: true
	        	},
				{
					xtype: 'uniTextfield',
					fieldLabel: '<t:message code="system.label.human.weekday1" default="총근무일수"/>',
					name: 'WEEK_DAY'
				},
				{
					xtype: 'uniTextfield',
					fieldLabel: '<t:message code="system.label.human.satday" default="토요일"/>',
					name: 'SAT_DAY'
				},
	        	{
	        		fieldLabel: '<t:message code="system.label.human.nonweekdate" default="휴무일수"/>',
	        		name: 'NON_WEEK_DAY'
				},
				{
					xtype: 'uniTextfield',
					fieldLabel: '<t:message code="system.label.human.dedday" default="차감일수"/>',
					name: 'DED_DAY'
				},
				{
					xtype: 'uniTextfield',
					fieldLabel: '<t:message code="system.label.human.dedtime" default="차감시간"/>',
					name: 'DED_TIME'
				},
	        	{
	        		fieldLabel: '<t:message code="system.label.human.holidaydate" default="휴일일수"/>',
	        		name: 'HOLIDAY'
				},
				{
					xtype: 'uniTextfield',
					fieldLabel: '<t:message code="system.label.human.actualworkdate" default="실근무일수"/>',
					name: 'WORK_DAY'
				},
				{
					xtype: 'uniNumberfield',
					fieldLabel: '<t:message code="system.label.human.worktime" default="실근무시간"/>',
					readOnly: true,
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
					fieldLabel: '<t:message code="system.label.human.weekgive" default="주차지급일수"/>',
					name: 'WEEK_GIVE'
				},
				{
					fieldLabel: '<t:message code="system.label.human.fullgive" default="만근지급일수"/>',
					name: 'FULL_GIVE'
				},{
					fieldLabel: '<t:message code="system.label.human.monthgive1" default="월차지급일수"/>',
					name: 'MONTH_GIVE'
				},{
					fieldLabel: '<t:message code="system.label.human.yeargive3" default="중간입사자연차개수"/>',
					name: 'YEAR_GIVE'
				}
	        ]
		}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('s_hat200ukr_kdGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	onLoadSelectFirst: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        },

/*        tbar: [{
            xtype: 'splitbutton',
            itemId:'refTool',
            text: '<t:message code="system.label.human.reference" default="참조..."/>',
            iconCls : 'icon-referance',
            menu: Ext.create('Ext.menu.Menu', {
                items: [{
                    itemId: 'excelBtn',
                    text: '<t:message code="system.label.human.excelrefer" default="엑셀참조"/>',
                    handler: function() {
                    	if(!panelResult.getInvalidMessage()){
                            return false;
                        }
                        masterGrid.getStore().loadStoreRecords();
                        openExcelWindow();
                    }
                }]
            })
        }],*/

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
            	  if(selNodes[0].data.WORK_TIME == 0){
            	  	detailForm1.setValue('WORK_TIME', '');
            	  }else{
            	  	detailForm1.setValue('WORK_TIME', selNodes[0].data.WORK_TIME);
            	  }

                  var person_numb = selNodes[0].data.PERSON_NUMB;
                  directMasterStore2.loadStoreRecords(person_numb);
                  UniAppManager.app.setToolbarButtons('delete', true);
                  detailForm1.clearForm();
                  detailForm2.clearForm();
                }

            },
            beforeedit:function( editor, context, eOpts )	{
            	if(closeDate >= context.record.get("DUTY_YYYYMM"))	{
            		return false;
            	}
            }
		}
	});//End of var masterGrid = Unilite.createGr100id('hat200ukrGrid1', {

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
		id: 's_hat200ukr_kdApp',
		fnInitBinding: function() {
			UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['newData','delete','save','deleteAll'], false);
            panelResult.getField('DUTY_YYYYMM').setReadOnly(false);
/* 			masterGrid.on('edit', function(editor, e) {
				if(directMasterStore.isDirty()) {
				    UniAppManager.setToolbarButtons('save',true);
				}
			})
 */
			panelResult.onLoadSelectText('DUTY_YYYYMM');
		},
		onResetButtonDown: function(){
            directMasterStore.loadData({});
            directMasterStore2.loadData({});
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
			}else if(confirm('<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
			//UniAppManager.setToolbarButtons('save',true);
		},
		onDeleteAllButtonDown: function() {
            var records = directMasterStore.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    if(confirm('<t:message code="system.message.human.message041" default="전체삭제 하시겠습니까?"/>')) {
                        var deletable = true;
                        if(deletable){
                        	directMasterStore.remove(directMasterStore.getData().items)
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                        isNewData = false;
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
        },
		dutyCheck: function(fieldName, record, newValue, oldValue, e){		//입력전 체크
			var param = {PAY_CODE: record.get('PAY_CODE'), DUTY_CODE: e.column.DUTY_CODE}
			Ext.getBody().mask();
			hat200ukrService.wirteCheck(param, function(provider, response)	{
		
				if(Ext.isEmpty(provider)){
					record.obj.set(fieldName, oldValue);
					alert('Configuration정보-인사/급여 업무설정-근태기준등록에서 \n근태코드의 일수 또는 시간관리를 등록하십시오.');
					//UniAppManager.setToolbarButtons('save',false);
					return false;
				}
				Ext.getBody().unmask();
				fieldName.indexOf('DUTY_NUM') > -1 ? activeField = 'DUTY_NUM' : activeField = 'DUTY_TIME';
				switch(activeField) {

					case "DUTY_NUM" :
    					if(!Ext.isEmpty(provider)){
    					    if(provider[0].COTR_TYPE == '2'){
    					    	record.set(fieldName,newValue);
    					    }else{
    					    	alert('선택한 근태는 시간관리 근태입니다.');
                                record.set(fieldName,oldValue);
                                return false;
                            }
    					}
						/* if(Ext.isEmpty(provider)){
							record.set(fieldName, oldValue);
							alert('Configuration정보-인사/급여 업무설정-근태기준등록에서 \n근태코드의 일수 또는 시간관리를 등록하십시오.');
							UniAppManager.setToolbarButtons('save',false);
							return false;
						} */
						if(Ext.isEmpty(record.get('PERSON_NUMB'))){
							alert('<t:message code="system.message.human.message048" default="행의 사번 항목이 비었습니다."/>');
							record.set(fieldName, oldValue);
							return false;
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							alert('<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>');	//양수만 입력 가능합니다.
							record.set(fieldName, oldValue);
							return false;
						}
						if(Ext.isEmpty(record.get('FLAG'))){
							record.set('FLAG', 'U');
						}
						if(e.column.DUTY_CODE == "25"){	//보건
							/*if(record.get('SEX_CODE') == "M"){
								alert(Msg.sMH912);
								record.set(fieldName, oldValue);
								return false;
							}*/
					/*		if(newValue > 1){
								alert(Msg.sMH1203);
								record.set(fieldName, oldValue);
								return false;
							}*/
							if(record.get('DAYDIFF') != 0 && record.get('DAYDIFF') < newValue){
								alert('<t:message code="system.message.human.message050" default="총일수를 넘을수 없습니다."/>');
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "20"){	//년차사용유무체크 및 수량 체크
//							if(record.get('YEAR_GIVE') == "N"){
//								alert('<t:message code="system.message.human.message065" default="년월차 대상자가 아닙니다."/>');
//								record.set(fieldName, oldValue);
//								return false;
//							}
							if(newValue > record.get('YEAR_NUM')){
								alert('<t:message code="system.message.human.message066" default="년차 초과한도를 넘었습니다."/>');
//								record.set(fieldName, oldValue);
		//						return false;
							}
						}
						if(e.column.DUTY_CODE == "10"){	//무휴
							if(record.get('DAYDIFF') != 0 && record.get('DAYDIFF') < newValue){
								alert('<t:message code="system.message.human.message050" default="총일수를 넘을수 없습니다."/>');
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "11"){ //결근
							if(record.get('DAYDIFF') != 0 && record.get('DAYDIFF') < newValue){
								alert('<t:message code="system.message.human.message050" default="총일수를 넘을수 없습니다."/>');
								record.set(fieldName, oldValue);
								return false;
							}
						}
						if(e.column.DUTY_CODE == "22"){ //월차
							if(record.get('DAYDIFF') != 0 && record.get('DAYDIFF') < newValue){
								alert('<t:message code="system.message.human.message050" default="총일수를 넘을수 없습니다."/>');
								record.set(fieldName, oldValue);
								return false;
							}
						}
					break;

					case "DUTY_TIME" :
					   if(!Ext.isEmpty(provider)){
    					    if(provider[0].COTR_TYPE == '1'){
                                record.set(fieldName,newValue);
    					    }else{
    					    	alert('선택한 근태는 일수관리 근태입니다.');
                                record.set(fieldName,oldValue);
                                return false;
    					    }
					   }
						/* if(Ext.isEmpty(provider)){
							record.set(fieldName, oldValue);
							alert('Configuration정보-인사/급여 업무설정-근태기준등록에서 \n근태코드의 일수 또는 시간관리를 등록하십시오.');
							UniAppManager.setToolbarButtons('save',false);
							return false;
						} */
/*						else if(provider[0].COTR_TYPE != "1"){
							record.set(fieldName, oldValue);
							alert(Msg.sMH1207);
							return false;

						}*/
						if(Ext.isEmpty(record.get('PERSON_NUMB'))){
							alert('<t:message code="system.message.human.message048" default="행의 사번 항목이 비었습니다."/>');
							record.set(fieldName, oldValue);
							return false;
						}
						if(newValue < 0 && !Ext.isEmpty(newValue))	{
							alert('<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>');	//양수만 입력 가능합니다.
							record.set(fieldName, oldValue);
							return false;
						}
						if(Ext.isEmpty(record.get('FLAG'))){
							record.set('FLAG', 'U');
						}
						if(e.column.DUTY_CODE == "25"){	//보건
							if(record.get('SEX_CODE') == "M"){
								alert('<t:message code="system.message.human.message051" default="남자는 등록할수 없습니다."/>');
								record.set(fieldName, oldValue);
								return false;
							}
							if(newValue > 1){
								alert('<t:message code="system.message.human.message052" default="한달에 한개만 사용가능합니다"/>');
								record.set(fieldName, oldValue);
								return false;
							}
							if(record.get('DAYDIFF') != 0 && record.get('DAYDIFF') < newValue){
								alert('<t:message code="system.message.human.message050" default="총일수를 넘을수 없습니다."/>');
								record.set(fieldName, oldValue);
								return false;
							}
						}
//						if(e.column.DUTY_CODE == "20"){	//년차사용유무체크 및 수량 체크
////							if(record.get('YEAR_GIVE') == "N"){
////								alert('<t:message code="system.message.human.message065" default="년월차 대상자가 아닙니다."/>');
////								record.set(fieldName, oldValue);
////								return false;
////							}
////							if(newValue > record.get('YEAR_NUM')){
////								alert(Msg.sMH914);
////								record.set(fieldName, oldValue);
//		//						return false;
////							}
//						}
//						if(e.column.DUTY_CODE == "10"){	//무휴
//							if(record.get('DAYDIFF') < newValue){
//								alert('<t:message code="system.message.human.message050" default="총일수를 넘을수 없습니다."/>');
//								record.set(fieldName, oldValue);
//								return false;
//							}
//						}
//						if(e.column.DUTY_CODE == "11"){ //결근
//							if(record.get('DAYDIFF') < newValue){
//								alert('<t:message code="system.message.human.message050" default="총일수를 넘을수 없습니다."/>');
//								record.set(fieldName, oldValue);
//								return false;
//							}
//						}
//						if(e.column.DUTY_CODE == "22"){ //월차
//							if(record.get('DAYDIFF') < newValue){
//								alert('<t:message code="system.message.human.message050" default="총일수를 넘을수 없습니다."/>');
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
						{name: 'FLAG',							text: ' ', 			editable:false,		type: 'string'},
						{name: 'DIV_CODE',					text: '<t:message code="system.label.human.division" default="사업장"/>', 	editable:false,		type: 'string', comboType:'BOR120', comboCode:'1234'},
						{name: 'DEPT_NAME',				text: '<t:message code="system.label.human.department" default="부서"/>', 	editable:false,		type: 'string'},
						{name: 'NAME',							text: '<t:message code="system.label.human.name" default="성명"/>', 	editable:false,		type: 'string'},
						{name: 'PERSON_NUMB',			text: '<t:message code="system.label.human.personnumb" default="사번"/>', 	editable:false,		type: 'string'},
						{name: 'DUTY_YYYYMM',			text: '<t:message code="system.label.human.yearmonth" default="연월"/>', 	editable:false,		type: 'string'},
						{name: 'PAY_PROV_FLAG',		text: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>', 	editable:false,		type: 'string'},
						{name: 'DUTY_FROM',				text: '<t:message code="system.label.human.monthfirstday" default="연월첫일"/>', 	editable:false,		type: 'string'},
						{name: 'DUTY_TO',						text: '<t:message code="system.label.human.monthlastday" default="연월말일"/>', 	editable:false,		type: 'string'},
						{name: 'DEPT_CODE',				text: '<t:message code="system.label.human.department" default="부서"/>', 	editable:false,		type: 'string'},
						{name: 'DEPT_CODE2',				text: '<t:message code="system.label.human.department" default="부서"/>', 	editable:false,		type: 'string'},
						{name: 'WORK_TIME',				text: '<t:message code="system.label.human.worktime" default="실근무시간"/>', 	editable:true,		type: 'string'}
					];

		Ext.each(colData, function(item, index){
			if(dutyNumFormat == "0,000")	{
				fields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'<t:message code="system.label.human.days" default="일수"/>',  type:'int', format:dutyNumFormat});
			} else {
				fields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'<t:message code="system.label.human.days" default="일수"/>',  type:'float', format:dutyNumFormat, decimalPrecision:dutyNumDeP});
			}
			if(dutyTimeFormat == "0,000")	{
				fields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'<t:message code="system.label.human.time" default="시간"/>', type:'int', format:dutyTimeFormat});
			} else {
				fields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'<t:message code="system.label.human.time" default="시간"/>', type:'float', format:dutyTimeFormat, decimalPrecision:dutyTimeDeP});
			}
			fields.push({name: 'COTR_TYPE' + item.SUB_CODE, text:'COTR_TYPE', type:'string'});
		});

		fields.push({name: 'REMARK',	text: '<t:message code="system.label.human.remark" default="비고"/>',	type: 'string'});


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
					{dataIndex: 'DEPT_CODE2',		width: 100, hidden: true},
					{dataIndex: 'WORK_TIME',		width: 100, hidden: true}
				];

		Ext.each(colData, function(item, index){
			columns.push({text: item.CODE_NAME,
				columns:[
					{dataIndex: 'DUTY_NUM' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
						renderer: function(value, metaData, record) {
							 if(value != 0){
                                    return '<div style="background:orange">'+Ext.util.Format.number(value, dutyNumFormat)+'</div>'
                               }else{
                                    return Ext.util.Format.number(value, dutyNumFormat);
                               }
						}
					},
					{dataIndex: 'DUTY_TIME' + item.SUB_CODE, width:50, summaryType:'sum', DUTY_CODE: item.SUB_CODE, align: 'right',
						renderer: function(value, metaData, record) {
							if(value != 0){
                                    return '<div style="background:orange">'+ Ext.util.Format.number(value, dutyTimeFormat)+'</div>'
                               }else{
                                    return Ext.util.Format.number(value, dutyTimeFormat);
                               }
						}
					},
					{dataIndex: 'COTR_TYPE' + item.SUB_CODE, width:50, summaryType:'sum', align: 'right',hidden:true}
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

			if( fieldName == 'REMARK' ) {

				return rv;
			} else if ( fieldName == 'WORK_TIME' ) {

				return rv;
			} else {
			
				UniAppManager.app.dutyCheck(fieldName, record.obj, newValue, oldValue, e);					
				
				return rv;
	//			setTimeout( rv, 100);
			}
		}
	}); // validator
};


</script>