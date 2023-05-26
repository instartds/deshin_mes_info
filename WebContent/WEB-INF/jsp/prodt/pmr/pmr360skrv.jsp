<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr360skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var gsReportGubun = '${gsReportGubun}'	//레포트 구분

function appMain() {
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	//동적 그리드 구현(공통코드(p03)에서 컬럼 가져오기)
	colData		= ${colData};
	var fields	= createModelField(colData);
	var columns	= createGridColumn(colData);
	var gsBadQtyInfo;
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Pmr360skrvModel', {
		fields : fields
	}); //End of Unilite.defineModel('Pmr360skrvModel', {



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pmr360skrvMasterStore1',{
		model	: 'Pmr360skrvModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api: {
				read: 'pmr360skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();
			panelResult.setValue('GROUP_KEYS','');
			console.log( param );
			this.load({
				params : param
			});
		}
	});




	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.productiondate" default="생산일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			startDate: UniDate.get('todayOfLastWeek'),
			endDate: UniDate.get('today'),
			width			: 315,
			textFieldWidth	: 170,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {

			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {

			}
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			xtype		: 'uniCombobox',
			name		: 'WORK_SHOP_CODE',
			comboType:'W',
			hidden   : true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    store.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });

                    }else{
                        store.filterBy(function(record){
                            return false;
                        });

                    }
                }
			}
		},
		Unilite.popup('ITEM',{
			fieldLabel		: '<t:message code="system.label.product.itemnum" default="품번"/>',
			validateBlank	: false,
		 	listeners		: {
				onValueFieldChange: function(field, newValue){

				},
				onTextFieldChange: function(field, newValue){

				}
			}
		}), {
			text:'<div style="color: red"><t:message code="system.label.product.inspecgradereportprint" default="검사성적서출력"/></div>',
            xtype: 'button',
            margin: '0 0 0 50',
            handler: function(){
            	if(!panelResult.getInvalidMessage()) return;   //필수체크

              var selectedRecords = masterGrid1.getSelectedRecords();
              if(Ext.isEmpty(selectedRecords)){
                  alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                  return;
              }

              var param = panelResult.getValues();

              param["dataCount"] = selectedRecords.length;
              param["PGM_ID"]='pmr360skrv';
              param["MAIN_CODE"]='P010';
              var win = '';
              if(gsReportGubun == 'CLIP'){
 				 	win = Ext.create('widget.ClipReport', {
 		                url: CPATH+'/prodt/pmr360clrkrv.do',
 		                prgID: 'pmr360skrv',
 		                extParam: param
 		            });
 					win.center();
 					win.show();
	   			}else{
	   				win = Ext.create('widget.ClipReport', {
 		                url: CPATH+'/prodt/pmr360clrkrv.do',
 		                prgID: 'pmr360skrv',
 		                extParam: param
 		            });
	                    win.center();
	                    win.show();
	   			}

            }
       },{
			fieldLabel	: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
			xtype		: 'uniCombobox',
			name		: 'TXTLV_L1',
			store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
			child		: 'TXTLV_L2',
			listeners		: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{
			fieldLabel: 'LOT_NO',
			xtype: 'uniTextfield',
			name: 'LOT_NO',
			hidden: false
       },{
			fieldLabel	: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
			xtype		: 'uniCombobox',
			name		: 'TXTLV_L2',
			store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
			child		: 'TXTLV_L3',
			hidden   : true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
			xtype		: 'uniCombobox',
			name		: 'TXTLV_L3',
			store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
			hidden   : true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{name: 'ITEM_ACCOUNT' ,
			fieldLabel:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' ,
			xtype:'uniCombobox',
			margin: '0 0 0 0',
			comboType:'AU',
			comboCode:'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{
			fieldLabel: 'GROUP_KEYS',
			xtype: 'uniTextfield',
			name: 'GROUP_KEYS',
			hidden: true
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
				//	this.mask();
				}
	  		} else {
				this.unmask();
			}
			return r;
		}
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('pmr360skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	:{
			expandLastColumn	: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		sortableColumns : false,
		features: [
			{id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
			{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: false}
		],selModel : Ext.create("Ext.selection.CheckboxModel", {
        	singleSelect : true ,
        	checkOnly : false,showHeaderCheckbox :true,
        	listeners: {
        		select: function(grid, selectRecord, index, rowIndex, eOpts ){
        			if(Ext.isEmpty(panelResult.getValue('GROUP_KEYS'))) {
						panelResult.setValue('GROUP_KEYS', selectRecord.get('GROUP_KEY'));
					} else {
						var wkordNumProgs = panelResult.getValue('GROUP_KEYS');
						wkordNumProgs = wkordNumProgs + ',' + selectRecord.get('GROUP_KEY');
						panelResult.setValue('GROUP_KEYS', wkordNumProgs);
					}

        		},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var wkordNumProgs	 = panelResult.getValue('GROUP_KEYS');
					var deselectedNum0  = selectRecord.get('GROUP_KEY')+ ',';
					var deselectedNum1  = ',' + selectRecord.get('GROUP_KEY');
					var deselectedNum2  = selectRecord.get('GROUP_KEY');

					wkordNumProgs = wkordNumProgs.split(deselectedNum0).join("");
					wkordNumProgs = wkordNumProgs.split(deselectedNum1).join("");
					wkordNumProgs = wkordNumProgs.split(deselectedNum2).join("");

					panelResult.setValue('GROUP_KEYS', wkordNumProgs);
				}
        	}
        }),
		columns	: columns
	});	//End ofvar masterGrid1 = Unilite.createGrid('pmr360skrvGrid1', {



	Unilite.Main({
		id			: 'pmr360skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid1, panelResult
			]
		}
		],
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR'	, UniDate.get('todayOfLastWeek'));
			panelResult.setValue('ORDER_DATE_TO'	, UniDate.get('today'));


			UniAppManager.setToolbarButtons('reset'	, true);
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else {

				masterGrid1.getStore().loadStoreRecords();
			}
		},
		onDetailButtonDown:function() {

		},
		checkForNewDetail:function() {
			return panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown:function() {
			Ext.getCmp('panelResultForm').getForm().reset();
			masterGrid1.getStore().loadData({});
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR'	, UniDate.get('todayOfLastWeek'));
			panelResult.setValue('ORDER_DATE_TO'	, UniDate.get('today'));
			//UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		}
	}); //End of Unilite.Main



	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'DIV_CODE'						,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type: 'string'},
			{name: 'WORK_SHOP_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type: 'string'},
			{name: 'WORK_SHOP_NAME'			,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'			,type: 'string'},
			{name: 'PRODT_DATE'					,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'	,type: 'uniDate'},
			{name: 'PROG_WORK_CODE'			,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		,type: 'string'},
			{name: 'PROG_WORK_NAME'			,text: '<t:message code="system.label.product.routing" default="공정"/>'					,type: 'string'},
			{name: 'ITEM_CODE'						,text: '<t:message code="system.label.product.itemnum" default="품번"/>'					,type: 'string'},
			{name: 'ITEM_NAME'						,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'PASS_Q'							,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		,type: 'uniQty'},
			{name: 'WKORD_NUM'					,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'	,type: 'string'},
			{name: 'ITEM_LEVEL1'					,text: '<t:message code="system.label.product.majorgroup" default="대분류"/>'			,type: 'string', type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store') },
			{name: 'SPEC'								,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'					,text: '<t:message code="system.label.product.unit" default="단위"/>'						,type: 'string'},
			{name: 'LOT_NO'							,text: 'LOT_NO'																							,type: 'string'},
			{name: 'PRODT_WKORD_DATE'		,text:  '<t:message code="system.label.product.makedate" default="제조일자"/>'		,type: 'uniDate'},
			{name: 'PRODT_DATE'					,text:  '<t:message code="system.label.product.inspecdate" default="검사일자"/>'		,type: 'uniDate'},
			{name: 'REMARK'							,text:  '<t:message code="system.label.product.remarks" default="비고"/>'				,type: 'string'},
			{name: 'INSPEC_RESULT'				,text:   '<t:message code="system.label.product.inspecresult" default="검사결과"/>' 	,type: 'string'},
			{name: 'DECISION_DATE'				,text:  '<t:message code="system.label.product.decisiondate" default="판정일"/>'		,type: 'uniDate'},
			{name: 'GROUP_KEY'				,text:  'GROUP_KEY'		,type: 'string'}

		];

		console.log(fields);
		return fields;
	}

	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var array1  = new Array();
		var columns = [
			{dataIndex: 'DIV_CODE'						, width: 66		, hidden: true},
			{dataIndex: 'ITEM_LEVEL1'					, width: 100	, hidden: false},
			{dataIndex: 'ITEM_CODE'					, width: 100},
			{dataIndex: 'ITEM_NAME'					, width: 150},
			{dataIndex: 'SPEC'							, width: 100	, hidden: false, align: 'center'},
			{dataIndex: 'STOCK_UNIT'					, width: 80		, hidden: false, align: 'center'},
			{dataIndex: 'PASS_Q'						, width: 100	, summaryType: 'sum'},
			{dataIndex: 'LOT_NO'						, width: 100	, hidden: false, align: 'center'},
			{dataIndex: 'PRODT_WKORD_DATE'		, width: 100	, align: 'center'},
			{dataIndex: 'PRODT_DATE'					, width: 100	, align: 'center'},
			{dataIndex: 'INSPEC_RESULT'				, width: 200	, hidden: false},
			{dataIndex: 'DECISION_DATE'				, width: 100	, hidden: false , align: 'center'},
			{dataIndex: 'WORK_SHOP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_NAME'			, width: 100    , align: 'center'},
			{dataIndex: 'PROG_WORK_CODE'			, width: 80		, hidden: true, align: 'center'},
			{dataIndex: 'PROG_WORK_NAME'			, width: 80		, align: 'center'},
			{dataIndex: 'WKORD_NUM'					, width: 120	, hidden: false, align: 'center'},
			{dataIndex: 'REMARK'						, width: 250},
			{dataIndex: 'GROUP_KEY'					, width: 100, hidden: true}




		]

		return columns;
	}
};
</script>
