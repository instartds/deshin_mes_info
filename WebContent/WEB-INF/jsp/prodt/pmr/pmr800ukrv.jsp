<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr800ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmr800ukrvService.selectList1',
			update: 'pmr800ukrvService.updateDetail',
			create: 'pmr800ukrvService.insertDetail',
			destroy: 'pmr800ukrvService.deleteDetail',
			syncAll: 'pmr800ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmr800ukrvService.selectList2',
			update: 'pmr800ukrvService.updateDetail2',
			create: 'pmr800ukrvService.insertDetail2',
			destroy: 'pmr800ukrvService.deleteDetail2',
			syncAll: 'pmr800ukrvService.saveAll2'
		}
	});

	var cbDirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmr800ukrvService.progWorkCombo'
		}
	});

	//작업장에 따른 공정코드 콤보load..
    var cbStore = Unilite.createStore('pmr800ukrvComboStoreGrid',{
        autoLoad: false,
        uniOpt: {
            isMaster: false         // 상위 버튼 연결
        },
        fields: [
                {name: 'SUB_CODE', type : 'string'},
                {name: 'CODE_NAME', type : 'string'}
                ],
//        proxy: cbDirectProxy,
        proxy: {
            type: 'direct',
            api: {

                read: 'pmr800ukrvService.progWorkCombo'
            }
        },
        loadStoreRecords: function() {
            var param= panelSearch.getValues();
            param.COMP_CODE= UserInfo.compCode;
            param.DIV_CODE = UserInfo.divCode;
            param.WORK_SHOP_CODE = panelSearch.getValue('WORK_SHOP_CODE');

            console.log(param);
            this.load({
                params : param
            });

        }
    });

	/**
	 * main Model 정의
	 * @type
	 */
	Unilite.defineModel('pmr800ukrvModel', {
	    fields: [
	    	{name:'DIV_CODE'       		,text: '제조처'			,type:'string', comboType: 'BOR120',editable: false},
//			{name:'WORK_SHOP_CODE' 		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type:'string', comboType:'WU'},
			{name:'WORK_SHOP_CODE' 		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type:'string', comboType: 'WU', editable: false},

			{name:'PRODT_DATE'     		,text: '<t:message code="system.label.product.date" default="일자"/>'				,type:'uniDate', allowBlank: false, editable: false},
			{name:'TOTAL_MAN'      		,text: '<t:message code="system.label.product.totalnumber" default="총인원"/>'			,type:'int', allowBlank: false},
			{name:'WORK_MAN'       		,text: '<t:message code="system.label.product.workemployee" default="작업인원"/>'			,type:'int', editable: false},
			{name:'HOLIDAY_MAN'    		,text: '<t:message code="system.label.product.numberinholiday" default="휴가인원"/>'			,type:'int'},
			{name:'ABSENCE_MAN'    		,text: '<t:message code="system.label.product.absentsnumber" default="결근인원"/>'			,type:'int'},
			{name:'PERCEP_MAN'     		,text: '<t:message code="system.label.product.numberoflateness" default="지각인원"/>'			,type:'int'},
			{name:'SEND_MAN'       		,text: '<t:message code="system.label.product.dispatchnumber" default="파견인원"/>'			,type:'int'},
			{name:'SUPPORT_MAN'    		,text: '<t:message code="system.label.product.supportnumber" default="지원인원"/>'			,type:'int'},
			{name:'REMARK'         		,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			{name:'FLAG'         		,text: 'FLAG'			,type:'string'}
		]
	});

	/**
	 *
	 * @type
	 */
	Unilite.defineModel('pmr800ukrvModel2', {
	    fields: [
	    	{name: 'DIV_CODE'      		,text: '<t:message code="system.label.product.mfgplace" default="제조처"/>'				,type:'string', comboType: 'BOR120', disabled: true},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string', comboType: 'WU', disabled: true},
			{name: 'PRODT_DATE'    		,text: '<t:message code="system.label.product.date" default="일자"/>'					,type:'uniDate'},
//			{name: 'PROG_WORK_CODE' 	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'				,type:'string', store:Ext.data.StoreManager.lookup('wpList')},
			{name: 'PROG_WORK_CODE' 	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'				,type:'string', store: cbStore},
			{name: 'PROG_WORK_NAME' 	,text: '<t:message code="system.label.product.routingname" default="공정명"/>'				,type:'string'},
			{name: 'WORK_MAN'      		,text: '<t:message code="system.label.product.workemployee" default="작업인원"/>'				,type:'int', allowBlank: false}
		]
	});

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmr800ukrvMasterStore1',{
		model: 'pmr800ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:true,			// 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});

		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('pmr800ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
//				 alert(Msg.sMB083);
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('pmr800ukrvMasterStore2',{
		model: 'pmr800ukrvModel2',
		uniOpt: {
//            isMaster: true,			// 상위 버튼 연결
            isMaster: false,			// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:true,			// 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,

        proxy: directProxy2,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});

		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

					 }
				};
				this.syncAllDirect(config);
			} else {
//                var grid = Ext.getCmp('pmr800ukrvGrid1');
                var grid = Ext.getCmp('pmr800ukrvGrid2');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
//				 alert(Msg.sMB083);
			}
		}
	});


	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
    	defaultType: 'uniSearchSubPanel',
    	listeners: {
        	collapse: function () {
            	panelResult.show();
        	},
        	expand: function() {
        		panelResult.hide();
        	}
    	},
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE',
		        xtype: 'uniCombobox',
		        comboType:'BOR120' ,
		        holdable: 'hold',
		        allowBlank:false, //필수여부 false는 필수값
			    value: UserInfo.divCode, //기본값
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			      		panelResult.setValue('DIV_CODE', newValue);
			     	}
			    }
		    },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				holdable: 'hold',
				comboType: 'WU',
		 		allowBlank:false,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			      		panelResult.setValue('WORK_SHOP_CODE', newValue);

			      		//작업장변경시  공정코드 load
			      		cbStore.loadStoreRecords();
			     	}
			    }
			},{
		        fieldLabel: '<t:message code="system.label.product.date" default="일자"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 500,
				startDate: UniDate.get('startOfMonth'),
				textFieldWidth:170,
				startDateFieldWidth : 120,
				endDateFieldWidth:	120,
				pickerWidth : 420,
				pickerHeight : 280,
				holdable: 'hold',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_START_DATE_TO',newValue);
			    	}
			    }
			},{
		 		fieldLabel: '<t:message code="system.label.product.date" default="일자"/>',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_DATE',
		        holdable: 'hold',
		 		hidden: true
			}]
	    }],
		setAllFieldsReadOnly: function(b) {
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true);
		        			}
		       			}
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		}
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ;
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
	    items: [{
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 3},
	        items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE',
		        xtype: 'uniCombobox',
		        comboType:'BOR120' ,
		        allowBlank:false,
		        holdable: 'hold',
			    value: UserInfo.divCode,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			      		panelSearch.setValue('DIV_CODE', newValue);
			     	}
			    }
		    },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				holdable: 'hold',
//				defaultValue: '3320',
		 		allowBlank:false,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			      		panelSearch.setValue('WORK_SHOP_CODE', newValue);
			     	}
			    }
			},{
		        fieldLabel: '<t:message code="system.label.product.date" default="일자"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName:'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 700,
				startDateFieldWidth : 120,
				endDateFieldWidth:	120,
				pickerWidth : 420,
				pickerHeight : 280,
				startDate: UniDate.get('startOfMonth'),
				textFieldWidth:300,
				holdable: 'hold',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('PRODT_START_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
			    	}
			    }
			}]
	    }],
		setAllFieldsReadOnly: function(b) {
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+' : ';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true);
		        			}
		       			}
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		}
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ;
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid1 = Unilite.createGrid('pmr800ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: directMasterStore1,
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
        columns: [
			{dataIndex: 'DIV_CODE'      	, width: 100, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE' 	, width: 166, hidden: true},
			{dataIndex: 'PRODT_DATE'    	, width: 100},
			{dataIndex: 'TOTAL_MAN'     	, width: 100},
			{dataIndex: 'WORK_MAN'      	, width: 100},
			{dataIndex: 'HOLIDAY_MAN'    	, width: 100},
			{dataIndex: 'ABSENCE_MAN'   	, width: 100},
			{dataIndex: 'PERCEP_MAN'    	, width: 100},
			{dataIndex: 'SEND_MAN'      	, width: 100},
			{dataIndex: 'SUPPORT_MAN'   	, width: 100},
			{dataIndex: 'REMARK'        	, width: 150},
			{dataIndex: 'FLAG'        		, width: 80, hidden: true}
		],
        listeners: {
        	render: function(grid, eOpts){

			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGridId = girdNm;
			    	//store.onStoreActionEnable();

			    	if( directMasterStore1.isDirty() || directMasterStore2.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}

					if(directMasterStore2.isDirty()){
					   alert('<t:message code="system.message.product.message030" default="먼저(디테일)저장을 하셔야 선택이 가능합니다."/>');

					   activeGridId = 'pmr800ukrvGrid2'; //활성화그리드 지정

					   return false;
					}

			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
//						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}

			    });
			},
        	selectionchange:function( model1, selected, eOpts ){
//        		var record = masterGrid1.getSelectedRecord();

        	   if(selected.length > 0) {
                    var record = selected[0];
                    this.returnCell(record);
                    directMasterStore2.loadData({})
                    if(!record.phantom){
                        directMasterStore2.loadStoreRecords(record);
                    }
                }
//
//        		if(record1.get('FLAG') != 'N') {
//	       			if(selected.length > 0)	{
//		        		var record = selected[0];
//		        		this.returnCell(record);
//		        		directMasterStore2.loadData({});
//						directMasterStore2.loadStoreRecords(record);
//						directMasterStore2.clearData();
//	       			}
//        		} else {
//        			directMasterStore2.loadData({});
//        		}
          	}



//          	selectionchange:function( model1, selected, eOpts ){
//                if(selected.length > 0) {
//                    var record = selected[0];
//                    directDetailStore.loadData({})
//                    if(!record.phantom){
//                        directDetailStore.loadStoreRecords(record);
//                    }
//                }
//            }

//          	beforeedit: function( editor, e, eOpts ) {
//				if(e.record.phantom == false) {
//        		 	if(UniUtils.indexOf(e.field, ['PRODT_DATE', 'WORK_MAN']))
//				   	{
//						return false;
//      				} else {
//      					return true;
//      				}
//        		} else {
//					return true;
//				}
//			}

        },
       	returnCell: function(record){
        	var workShopCode	= record.get("WORK_SHOP_CODE");
        	var prodtDate		= record.get("PRODT_DATE");
            panelSearch.setValues({'PRODT_DATE':prodtDate});
        }
    });

    var masterGrid2 = Unilite.createGrid('pmr800ukrvGrid2', {
    	layout : 'fit',
    	region:'east',
        store : directMasterStore2,
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: directMasterStore2,
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false}
    	],
        columns: [
			{dataIndex: 'DIV_CODE'       		, width: 100 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE' 		, width: 166, hidden: true},
			{dataIndex: 'PRODT_DATE'      		, width: 126, hidden: true},
			{dataIndex: 'PROG_WORK_CODE' 		, width: 150},
			{dataIndex: 'PROG_WORK_NAME' 		, width: 200},
			{dataIndex: 'WORK_MAN'       		, width: 100}
		],
        listeners: {
        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGridId = girdNm;
			    	//store.onStoreActionEnable();

			    	if( directMasterStore1.isDirty() || directMasterStore2.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}

					if(directMasterStore1.isDirty()){
                       alert('<t:message code="system.message.product.message031" default="먼저(메인)저장을 하셔야 선택이 가능합니다."/>');

                       activeGridId = 'pmr800ukrvGrid1'; //활성화그리드 지정

                       //임의 포커스 지정
                       panelResult.getField('WORK_SHOP_CODE').focus();
                       return false;
                    }

			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
			    });
			}

//			selectionchange:function( model1, selected, eOpts ){
//              var record1 = masterGrid1.getSelectedRecord();

//               if(selected.length > 0) {
//                    var record = selected[0];
//                    this.returnCell(record);
//                    directMasterStore2.loadData({})
//                    if(!record.phantom){
//                        directMasterStore2.loadStoreRecords(record);
//                    }
//                }

//
//              if(record1.get('FLAG') != 'N') {
//                  if(selected.length > 0) {
//                      var record = selected[0];
//                      this.returnCell(record);
//                      directMasterStore2.loadData({});
//                      directMasterStore2.loadStoreRecords(record);
//                      directMasterStore2.clearData();
//                  }
//              } else {
//                  directMasterStore2.loadData({});
//              }
//            }

//          	beforeedit: function( editor, e, eOpts ) {
//				if(e.record.phantom == false) {
//        		 	if(UniUtils.indexOf(e.field, ['PROG_WORK_CODE']))
//				   	{
//						return false;
//      				} else {
//      					return true;
//      				}
//        		} else {
//					return true;
//				}
//			}
        }
    });

    Unilite.Main( {
    	borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[panelResult,
					{
						region : 'west',
						xtype : 'container',
						layout : 'fit',
//						width : 1000,
						flex : 7.5,
						items : [ masterGrid1 ]
					}, {
						region : 'center',
						xtype : 'container',
						layout : 'fit',
						flex : 2.5,
						items : [ masterGrid2 ]
					}
				]
			}
			,panelSearch
		],
		id: 'pmr800ukrvApp',
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
        	panelSearch.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
        	panelResult.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
//			UniAppManager.setToolbarButtons(['detail'], false);
//			UniAppManager.setToolbarButtons(['reset'], false);
			UniAppManager.setToolbarButtons(['newData'], true);

			panelSearch.setValue('WORK_SHOP_CODE','3320');
            panelResult.setValue('WORK_SHOP_CODE','3320');

//			if(params.WORK_SHOP_CODE == null){
//
//			}
			this.processParams(params);
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			var param= panelSearch.getValues();
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);

			activeGridId = 'pmr800ukrvGrid1'; //활성화그리드 지정

		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
        	panelSearch.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
        	panelResult.setValue('PRODT_START_DATE_TO',UniDate.get('today'));
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

			panelSearch.setValue('WORK_SHOP_CODE','3320');
            panelResult.setValue('WORK_SHOP_CODE','3320');

		},
		onResetButtonDown: function() {		// 새로고침 버튼
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid1.reset();
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onNewDataButtonDown: function()	{

			panelSearch.setAllFieldsReadOnly(true);
            panelResult.setAllFieldsReadOnly(true);

			if(!this.checkForNewDetail()) return false;

			 if(masterGrid1.getStore().getCount() == 0){
			     activeGridId = 'pmr800ukrvGrid1';
			 }

			if(activeGridId == 'pmr800ukrvGrid1' ) {
				 var workShopCode    = panelSearch.getValue('WORK_SHOP_CODE');
//                 var prodtDate      = panelSearch.getValue('PRODT_START_DATE_TO');/////
                 var prodtDate      = UniDate.get('today');
                 var totalMan       = 0;
                 var holidayMan     = 0;
                 var absenceMan     = 0;
                 var percepMan      = 0;
                 var sendMan        = 0;
                 var supportMan     = 0;
                 var remark         = '';
                 var flag           = 'N';
                 var divCode        = panelSearch.getValue('DIV_CODE');

                 var r = {
                    WORK_SHOP_CODE   : workShopCode,
                    PRODT_DATE       : prodtDate,
                    TOTAL_MAN        : totalMan,
                    HOLIDAY_MAN      : holidayMan,
                    ABSENCE_MAN      : absenceMan,
                    PERCEP_MAN       : percepMan,
                    SEND_MAN         : sendMan,
                    SUPPORT_MAN      : supportMan,
                    REMARK           : remark,
                    FLAG             : flag,
                    DIV_CODE         : divCode
                    //COMP_CODE
                };
                masterGrid1.createRow(r, masterGrid1.getStore().getCount() - 1);
            } else if(activeGridId == 'pmr800ukrvGrid2' ) {
            	var record = masterGrid1.getSelectedRecord();
                 var workShopCode   = record.get('WORK_SHOP_CODE');
                 var prodtDate      = record.get('PRODT_DATE');
                 var divCode        = record.get('DIV_CODE');
                 var progWorkCode   = '';
                 var workMan        = '';

                 var r = {
                    WORK_SHOP_CODE   : workShopCode,
                    PRODT_DATE       : prodtDate,
                    DIV_CODE         : divCode,
                    PROG_WORK_CODE   : progWorkCode,
                    WORK_MAN         : workMan
                    //COMP_CODE
                };
                masterGrid2.createRow(r, masterGrid2.getStore().getCount() - 1);
                UniAppManager.setToolbarButtons('delete', true);
            }

		},
        checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onSaveDataButtonDown: function(config) {


//			if(activeGridId == 'pmr800ukrvGrid1' ) {
//
//				directMasterStore1.saveStore();
//			} else if(activeGridId == 'pmr800ukrvGrid2' ) {
//
//				if(directMasterStore1.getCount)
//
//				directMasterStore1.saveStore();
//				directMasterStore2.saveStore();
//			}

			//총인원 체크
			var selected = masterGrid1.getSelectedRecord();
            var workMan = selected.data['WORK_MAN'];
			if(workMan < 1){
				alert('<t:message code="system.message.product.message032" default="총인원이 휴가인원+결근인원+파견인원 보다 작습니다."/>');
				return false;
			}

			if(directMasterStore1.isDirty()){
			 directMasterStore1.saveStore();
			}else if(directMasterStore2.isDirty()){
             directMasterStore2.saveStore();
            }

		},
		rejectSave: function() {
			var rowIndex = masterGrid1.getSelectedRowIndex();
			if(activeGridId == 'pmr800ukrvGrid1' ) {
				masterGrid1.select(rowIndex);
				directMasterStore1.rejectChanges();

				if(rowIndex >= 0){
					masterGrid1.getSelectionModel().select(rowIndex);
					var selected = masterGrid1.getSelectedRecord();

					var selected_doc_no = selected.data['DOC_NO'];
	  				bdc100ukrvService.getFileList(
						{DOC_NO : selected_doc_no},
						function(provider, response) {
						}
					);
				}
				directMasterStore1.onStoreActionEnable();
			} else if (activeGridId == 'pmr800ukrvGrid2' ) {
				masterGrid2.select(rowIndex);
				directMasterStore2.rejectChanges();

				if(rowIndex >= 0){
					masterGrid2.getSelectionModel().select(rowIndex);
					var selected = masterGrid2.getSelectedRecord();

					var selected_doc_no = selected.data['DOC_NO'];
	  				bdc100ukrvService.getFileList(
						{DOC_NO : selected_doc_no},
						function(provider, response) {
						}
					);
				}
				directMasterStore2.onStoreActionEnable();
			}

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('pmr800ukrvFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDeleteDataButtonDown: function() {

			if(activeGridId == 'pmr800ukrvGrid1' ) {
    			if (masterGrid2.getStore().getCount() > 0){
    				alert('<t:message code="system.message.product.message033" default="공정별 인원이 등록되어있습니다. 먼저 공정별 인원을 삭제해야 합니다."/>');
    			}else{
            			if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                			masterGrid1.deleteSelectedRow();
            			}
    			}
			} else if(activeGridId == 'pmr800ukrvGrid2' ) {
				if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid2.deleteSelectedRow();
				}

				if(masterGrid2.getStore().getCount() == 0 ){
                    UniAppManager.setToolbarButtons('delete', false);
                }


			}

			if(masterGrid1.getStore().getCount() >0){
    			UniAppManager.setToolbarButtons('save', true);
			}




		},
		processParams: function(params) {
			this.uniOpt.appParams = params;

			if(params && params.WORK_SHOP_CODE ) {
					panelSearch.setValue('DIV_CODE',params.DIV_CODE);
					panelSearch.setValue('WORK_SHOP_CODE',params.WORK_SHOP_CODE);
					panelSearch.setValue('PRODT_START_DATE_FR',params.PRODT_START_DATE_FR);
					panelSearch.setValue('PRODT_START_DATE_TO',params.PRODT_START_DATE_TO);

					panelResult.setValue('DIV_CODE',params.DIV_CODE);
					panelResult.setValue('WORK_SHOP_CODE',params.WORK_SHOP_CODE);
					panelResult.setValue('PRODT_START_DATE_FR',params.PRODT_START_DATE_FR);
					panelResult.setValue('PRODT_START_DATE_TO',params.PRODT_START_DATE_TO);

					masterGrid1.getStore().loadStoreRecords();
			}
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "TOTAL_MAN" :
					if(newValue < 0) {
						rv= alert('<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>');
						break;
					}
					//record.set('WORK_MAN',newValue);
					record.set('WORK_MAN',newValue - (record.get('HOLIDAY_MAN') + record.get('ABSENCE_MAN')));
				break;

				case "WORK_MAN" :
					if(newValue < 0) {
						rv= alert('<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>');
						break;
					}
					record.set('newValue', record.get('TOTAL_MAN') - (record.get('HOLIDAY_MAN') + record.get('ABSENCE_MAN')));
					/*record.set('AVERAGE_P',newValue);
					record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));*/
				break;

				case "HOLIDAY_MAN" :
					if(newValue < 0) {
						rv= alert('<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>');
						break;
					}
					record.set('WORK_MAN', record.get('TOTAL_MAN') - (newValue + record.get('ABSENCE_MAN')));
					//record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));
				break;

				case "ABSENCE_MAN" :
					if(newValue < 0) {
						rv= alert('<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>');
						break;
					}
					record.set('WORK_MAN', record.get('TOTAL_MAN') - (newValue + record.get('HOLIDAY_MAN')));
					//record.set('STOCK_I',(record.get('STOCK_Q') * record.get('AVERAGE_P')));
				break;
			}
			return rv;
		}
	})

	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var record1 = masterGrid1.getSelectedRecord();
//			var record2 = masterGrid2.getSelectedRecord();
			switch(fieldName) {
				case "WORK_MAN" :
					if(newValue < '0') {
						rv= alert('<t:message code="system.message.product.message034" default="양수만 입력 가능합니다."/>');
						break;
					} else if(newValue > record1.get('WORK_MAN')) {
						rv= alert('<t:message code="system.message.product.message035" default="공정 전체 작업인원을 초과했습니다."/>');
					}

					if(record.get('PROG_WORK_CODE') == ''){
					   alert('<t:message code="system.message.product.message036" default="먼저 공정을 선택하여 주십시오."/>');
					   break;
					}

				break;

			}
			return rv;
		}
	})
};

</script>
