<%--
'   프로그램명 : 생산계획(생산)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 : 20181010
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ppl100ukrv_in"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_ppl100ukrv_in"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />					<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="P402" /> <!-- 참조유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!-- 매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
   	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
	<t:ExtComboStore comboType="WU" />										<!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell_light_Yellow {
background-color: #FFFFA1;
}

.x-change-cell3 {
background-color: #fcfac5;
}
</style>
<script type="text/javascript" >

var referOrderInformationWindow;		//수주정보참조
var referSalesPlanWindow;				//판매계획참조
var needInput = null;
var BsaCodeInfo = {
	gsManageTimeYN:'${gsManageTimeYN}'
};

var outDivCode = UserInfo.divCode;

function appMain() {

	var mrpYnStore = Unilite.createStore('s_ppl100ukrv_inMRPYnStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.product.yes" default="예"/>'		, 'value':'Y'},
			        {'text':'<t:message code="system.label.product.no" default="아니오"/>'	, 'value':'N'}
	    		]
	});

	var isAutoTime = false;
	if(BsaCodeInfo.gsAutoType=='Y')	{
		isAutoTime = true;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_ppl100ukrv_inService.selectDetailList',
			update: 's_ppl100ukrv_inService.updateDetail',
			//create: 's_ppl100ukrv_inService.insertDetail',
			//destroy: 's_ppl100ukrv_inService.deleteDetail',
			syncAll: 's_ppl100ukrv_inService.saveAll'
		}
	});

	//작업장
	Unilite.defineModel('s_ppl100ukrv_inMasterModel1', {
	    fields: [
			{name: 'SELECT'           					, text: ' '      									, type: 'boolean'},
	    	{name: 'COMP_CODE'      				, text: '법인코드'							, type: 'string'},
	    	{name: 'DIV_CODE'       					, text: '사업장' 								, type: 'string'},
	    	{name: 'GUBUN'          					, text: '구분코드'   								, type: 'string'},
	    	{name: 'GUBUN_NAME'          					, text: '구분'   								, type: 'string'},
	    	{name: 'MP_NO'          					, text: 'MP번호'   							, type: 'string'},
	    	{name: 'WKORD_NUM'       			, text: '작지번호'							, type:'string'},
	    	{name: 'SEMI_ITEM_CODE'       	, text: '반제품코드(생산품목)'		, type:'string'},
	    	{name: 'SEMI_ITEM_NAME'       	, text: '반제품명(생산품목)'		, type:'string'},
	    	{name: 'WKORD_Q'                    	, text: '작지량(입고예정)'				, type: 'uniQty'},
	    	{name: 'PLAN_Q'             				, text: '계획량'     					, type: 'uniQty'},
	    	{name: 'ADD_Q'             				, text: '추가수량'     						, type: 'uniQty'},
	    	{name: 'PROD_PLAN_Q'				, text : '생산계획량'						, type : 'uniQty'},
	    	{name: 'PRODT_PLAN_DATE'      ,text: '계획일' 								,type: 'uniDate' },
	    	{name: 'WORK_SHOP_CODE' 		, text: '작업장'   			 				, type: 'string'  , comboType: 'WU', allowBlank : true},
	    	{name: 'ORDER_NUM'      			, text: '수주번호'  							, type:'string'},
	    	{name: 'SER_NO'                  			, text: '수주순번'              				, type: 'int'},
	    	{name: 'CUSTOM_CODE'      			, text: '거래처코드'  							, type:'string'},
	    	{name: 'CUSTOM_NAME'      			, text: '거래처명'  							, type:'string'},
	    	{name: 'ITEM_CODE'						, text: '품목코드'							, type: 'string'},
            {name: 'ITEM_NAME'					, text: '품목'									, type: 'string'},
            {name: 'SPEC'									, text: '규격'									, type: 'string'},
            {name: 'ORDER_UNIT_Q'    			, text: '수주(계획)량'   					, type:'uniQty'},
            {name: 'NOT_ISSUE_Q'     			    	, text: '미납량'    							, type: 'uniQty'},
            {name: 'GOOD_STOCK_Q'				, text: '양품재고량'						, type: 'uniQty'},
            {name: 'SAFE_STOCK_Q'      			, text: '안전재고'   						, type:'uniQty'},
            {name: 'ORDER_DATE'     				, text: '수주일'   							, type:'uniDate'},
            {name: 'DVRY_DATE'						, text: '납기요청일'						, type:'uniDate'},
            {name: 'SAVE_ITEM_CODE'						, text: 'SAVE_ITEM_CODE'						, type:'string'}
		]
	});

	//마스터 스토어 정의
	var masterStore1 = Unilite.createStore('s_ppl100ukrv_inmasterStore1', {
		model: 's_ppl100ukrv_inMasterModel1',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: false,
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,

		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
		    var needCheck = 0;
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			if(list.length > 0){
				for(var i =0; i < list.length; i++){
					if(list[i].data.SELECT == true && Ext.isEmpty(list[i].data.WORK_SHOP_CODE) == true){
						needCheck++;
					}else if(list[i].data.SELECT == true && list[i].data.PROD_PLAN_Q > 0 && Ext.isEmpty(list[i].data.WORK_SHOP_CODE) == true){
						needCheck++;
					}
				}
				if(needCheck > 0){
					alert('작업장은 입력 필수 항목입니다.');
				}
			}

			console.log("inValidRecords : ", inValidRecs);
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0&&needCheck == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						if (masterStore1.count() == 0) {
							UniAppManager.app.onResetButtonDown();
						}else{
							masterStore1.loadStoreRecords();
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_ppl100ukrv_inGrid1');
                if(!Ext.isEmpty(inValidRecs)){
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
			}
		},
		 listeners: {
	            load: function(store, records, successful, eOpts) {
	            },
	            add: function(store, records, index, eOpts) {
	            },
	            update: function(store, record, operation, modifiedFieldNames, eOpts) {
	            },
	            remove: function(store, record, index, isMove, eOpts) {
	            }
	        }
	});

	var panelSearch = Unilite.createSearchPanel('s_ppl100ukrv_inMasterForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120',
	        	allowBlank:false,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	        },{
            	fieldLabel: '생산계획월',
            	name: 'FR_MONTH',
            	xtype: 'uniMonthfield',
		 		value: UniDate.get('startOfMonth'),
            	allowBlank: false,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('FR_MONTH', newValue);
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
					} else {}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType:'BOR120',
	        	allowBlank:false,
	        	listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	        },{
            	fieldLabel: '생산계획월',
            	name: 'FR_MONTH',
            	xtype: 'uniMonthfield',
		 		value: UniDate.get('startOfMonth'),
            	allowBlank: false,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('FR_MONTH', newValue);
					}
				}
			},{
				fieldLabel: '납기일',
            	xtype: 'uniDateRangefield',
 			    startFieldName: 'ISSUE_DATE_FR',
 			    endFieldName: 'ISSUE_DATE_TO',
 			    startDate: UniDate.get('today'),
			},{
            	fieldLabel: '생산계획 > 0',
            	name: 'WK_PLAN_MORE_0',
				xtype: 'checkboxfield',
				checked: true
    		},{
            	fieldLabel: '간략보기',
            	name: 'GUBUN_90',
				xtype: 'checkboxfield'
    		},		
			Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '반제품',
	        	valueFieldName: 'SEMI_ITEM_CODE',
				textFieldName: 'SEMI_ITEM_NAME'
	   		})],
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
					} else {}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});	//end panelSearch

	/**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid1 = Unilite.createGrid('s_ppl100ukrv_inGrid1', {
    	layout: 'fit',
        region:'center',
            enableColumnHide :false,
            sortableColumns : false,
        uniOpt: {
        	expandLastColumn: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst : false
        },
    	store: masterStore1,
    	viewConfig:{
    		forceFit : true,
            stripeRows: false,//是否隔行换色
            getRowClass : function(record,rowIndex,rowParams,store){
            	var cls = '';
                if(record.get('GUBUN')=="90"){
                	cls = 'x-change-cell_light_Yellow';
                }
                return cls;
            }
        },
//		features: [
//			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
//		    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
//		],
        columns: [
        	 {dataIndex: 'COMP_CODE'                    	, width: 60	, hidden: true},
        	 {dataIndex: 'DIV_CODE'							, width: 60	, hidden: true},
        	 {dataIndex: 'GUBUN'                        		, width: 60 , hidden: true},
        	 {dataIndex: 'SAVE_ITEM_CODE'              , width: 60 , hidden: true},
        	 {dataIndex: 'SELECT'                , width: 40, xtype: 'checkcolumn',align:'center',
                 listeners: {
                     checkchange: function( CheckColumn, rowIndex, checked, eOpts){
                    	 var dataDay = eOpts.get('PRODT_PLAN_DATE');
                    	 if(eOpts.get('PROD_PLAN_Q') > 0 && checked == true){
                    		 if(Ext.isEmpty(eOpts.get('WORK_SHOP_CODE'))){
                    			 alert('작업장은 입력 필수 항목입니다.');
                              }
                          }
                    	 if(checked == true){
                    		 if(Ext.isEmpty(eOpts.get('PRODT_PLAN_DATE'))){
                    			 eOpts.set('PRODT_PLAN_DATE',UniDate.get('tomorrow'));
                        	 }
                    		 if(Ext.isEmpty(eOpts.get('ITEM_CODE'))){
                    			 eOpts.set('SAVE_ITEM_CODE',eOpts.get('SEMI_ITEM_CODE'));
             				}else{
             					eOpts.set('SAVE_ITEM_CODE',eOpts.get('ITEM_CODE'));
             				}
                    	 }else{
                    		 if(!Ext.isEmpty(eOpts.get('PRODT_PLAN_DATE')&&!Ext.isEmpty(eOpts.getChanges().PRODT_PLAN_DATE))){
                    			 eOpts.set('PRODT_PLAN_DATE','');
                        	 }
                    		 eOpts.set('SAVE_ITEM_CODE','');
                    	 }
                     },
                     beforecheckchange: function( CheckColumn, rowIndex, checked, eOpts ){
                         if(eOpts.get('GUBUN') != '90'){
                            return false;
                         }
                     }
                 }
             },
        	 {dataIndex: 'GUBUN_NAME'                        		, width: 65},
        	 {text :'생산',
     			columns:[
					{dataIndex: 'MP_NO'                        		, width: 65},
					{dataIndex: 'WKORD_NUM'                 , width: 130},
					{dataIndex: 'SEMI_ITEM_CODE'           , width: 160},
					{dataIndex: 'SEMI_ITEM_NAME'           , width: 160, hidden: true},
					{dataIndex: 'WKORD_Q'                      	, width: 120},
					{dataIndex: 'PLAN_Q'             				, width: 120},
					{dataIndex: 'ADD_Q'                        		, width: 80},
					{dataIndex: 'PROD_PLAN_Q'	            , width: 85},
					{dataIndex: 'PRODT_PLAN_DATE'	    , width: 85},
					{dataIndex: 'WORK_SHOP_CODE'       , width: 80}
     			]
			 },{text :'수주(계획)',
	     			columns:[
						{dataIndex: 'ORDER_NUM'              	, width: 120},
						{dataIndex: 'SER_NO'                	, width: 80},
						{dataIndex: 'CUSTOM_CODE'                	, width: 80},
						{dataIndex: 'CUSTOM_NAME'                	, width: 140},
						{dataIndex: 'ITEM_CODE'		            , width: 80},
						{dataIndex: 'ITEM_NAME'		            , width: 140},
						{dataIndex: 'SPEC'			                	, width: 80},
						{dataIndex: 'ORDER_UNIT_Q'          , width: 120}
	     			]
			},{text :'재고',
     			columns:[
					{dataIndex: 'NOT_ISSUE_Q'     	                , width: 100},
					{dataIndex: 'GOOD_STOCK_Q'	            , width: 100},
					{dataIndex: 'SAFE_STOCK_Q'   		        , width: 80}
     			]
		},{text :'일자',
 			columns:[
 					{dataIndex: 'ORDER_DATE'                  	, width: 80},
 					{dataIndex: 'DVRY_DATE'	                    , width: 80}
      			]
 		}
		],
		setItemData: function(record, dataClear) {
			var rowIndex = masterGrid1.getSelectedRowIndex();
       		if(dataClear) {
       			masterStore1.getAt(rowIndex).set('ITEM_CODE'		, "");
       			masterStore1.getAt(rowIndex).set('ITEM_INFO'		, "");
       			masterStore1.getAt(rowIndex).set('WORK_SHOP_CODE'	, "");
       			masterStore1.getAt(rowIndex+1).set('ITEM_CODE' 		, "");
       			masterStore1.getAt(rowIndex+1).set('ITEM_INFO' 		, "");
       		} else {
       			masterStore1.getAt(rowIndex).set('ITEM_CODE'		, record['ITEM_CODE']);
       			masterStore1.getAt(rowIndex).set('ITEM_INFO'		, record['ITEM_NAME']);
       			masterStore1.getAt(rowIndex).set('WORK_SHOP_CODE'	, record['WORK_SHOP_CODE']);
       			masterStore1.getAt(rowIndex+1).set('ITEM_CODE'		, record['STOCK_UNIT']);
       			masterStore1.getAt(rowIndex+1).set('ITEM_INFO'		, record['SPEC']);
       		}
		},
		listeners: {
			 beforeedit: function( editor, e, eOpts) {
				 var record = masterGrid1.getSelectedRecord();
				 if(!e.record.phantom) {
					 if(UniUtils.indexOf(e.field, ['ADD_Q', 'WORK_SHOP_CODE','PRODT_PLAN_DATE'])&&record.get('GUBUN')=="90"){
		                	return true;
	                   } else {
	                       return false;
	                   }
		        	} else {
		        		if(UniUtils.indexOf(e.field, ['ADD_Q', 'WORK_SHOP_CODE','PRODT_PLAN_DATE'])&&record.get('GUBUN')=="90"){
		                	return true;
	                   } else {
	                       return false;
	                   }
		        	}
	            },
	            onGridDblClick:function(grid, record, cellIndex, colName) {
	            	if(!Ext.isEmpty(record)){
	            		if(colName =="GOOD_STOCK_Q" && record.data.GUBUN == "90") {
							grid.ownerGrid.openLotNoPopup(record);
						}
	            	}
	            }
		},

        openLotNoPopup:function(record){
		var param = record.data;
		var params = {
				DIV_CODE : UserInfo.divCode,
				ITEM_CODE : record.data.ITEM_CODE,
				ITEM_NAME : record.data.ITEM_NAME
			}
			UniAppManager.app.popupGridNewConfig(params,'','');
		}
    });


	 /**
	 * main app
	 */
    Unilite.Main({
		id: 's_ppl100ukrv_inApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				 panelResult,masterGrid1
			]
		},
			panelResult
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['save','newData', 'prev', 'next'], false);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false){
        		return false;
			}else {
				masterStore1.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			this.suspendEvents();


			panelResult.setAllFieldsReadOnly(false);
			masterGrid1.reset();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {

			masterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
				this.deleteData(masterGrid1);
		},
		onDeleteAllButtonDown: function() {

		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_ppl100ukrv_inAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		deleteData : function(masterGrid){
			var model = masterGrid.getSelectionModel();
			var selRow = masterGrid.getSelectedRecord();
			var rowIndex = masterGrid.getSelectedRowIndex();

			if(selRow.get("GUBUN") == '<t:message code="system.label.product.plan" default="계획"/>'){
				model.selectRange(rowIndex, rowIndex+2);
			}else if(selRow.get("GUBUN") == '지시'){
				model.selectRange(rowIndex-1, rowIndex+1);
			}else{
				model.selectRange(rowIndex-2, rowIndex);
			}

			masterGrid.deleteSelectedRow();
		},
        checkForNewDetail:function() {
			if(Ext.isEmpty(panelResult.getValue('FR_DATE')) || Ext.isEmpty(panelResult.getValue('FR_DATE')))	{
				alert('<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}

			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return panelResult.setAllFieldsReadOnly(true);
        },
        popupGridNewConfig: function(param, callback, scope) {
        	var app = "Unilite.app.popup.LotPopupMulti";
			var fn = function() {
				var oWin =  Ext.WindowMgr.get(app);
				if(!oWin) {
					oWin = Ext.create( app, {
						callBackFn: callback,
						callBackScope: scope,
						width: 1000,
						height: 700,
						alwaysOnTop:89001,
						title: 'LOT 재고정보',
						param: param
					});
				}
				oWin.fnInitBinding(param);
				oWin.center();
				oWin.show();
				oWin.setAlwaysOnTop(true);
			};
			Unilite.require(app, fn, this, true);
        }
	});

		Unilite.createValidator('validator01', {
		store: masterStore1,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var sumValue = 0;
			switch(fieldName) {
			case "ADD_Q":
				var planQ = record.get('PLAN_Q');
				record.set('PROD_PLAN_Q', planQ+newValue);
				record.set('SELECT',true);

				if(Ext.isEmpty(record.get('ITEM_CODE'))){
					record.set('SAVE_ITEM_CODE',record.get('SEMI_ITEM_CODE'));
				}else{
					record.set('SAVE_ITEM_CODE',record.get('ITEM_CODE'));
				}
			break;

			case "WORK_SHOP_CODE":
				record.set('SELECT',true);
				if(Ext.isEmpty(record.get('ITEM_CODE'))){
					record.set('SAVE_ITEM_CODE',record.get('SEMI_ITEM_CODE'));
				}else{
					record.set('SAVE_ITEM_CODE',record.get('ITEM_CODE'));
				}
			break;

			case "PRODT_PLAN_DATE":
				record.set('SELECT',true);
				if(Ext.isEmpty(record.get('ITEM_CODE'))){
					record.set('SAVE_ITEM_CODE',record.get('SEMI_ITEM_CODE'));
				}else{
					record.set('SAVE_ITEM_CODE',record.get('ITEM_CODE'));
				}
			break;

					}
			return rv;
		}
		});
}
</script>
