<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="*"  >
	<t:ExtComboStore comboType="BOR120" storeId="toDivList"  /> <!-- 사업장 -->
</t:appConfig>
<t:appConfig pgmId="biv450ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="biv450ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="O" />		<!-- 창고-->
	<t:ExtComboStore comboType="W" />		<!-- 작업장  -->
	<t:ExtComboStore comboType="OU" storeId="whList" />  					<!--출고창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--출고창고Cell-->
	<t:ExtComboStore comboType="OU" storeId="whList2" />  					<!--입고창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST2}" storeId="whCellList2" /><!--입고창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!--담당자-->	

	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />

</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >


var BsaCodeInfo = {		// 컨트롤러에서 값을 받아옴
	gsInvstatus:		'${gsInvstatus}',
	gsMoneyUnit:		'${gsMoneyUnit}',
	gsManageLotNoYN:	'${gsManageLotNoYN}',
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsAutotype:			'${gsAutotype}',
	gsUsePabStockYn:	'${gsUsePabStockYn}',
	inoutPrsn:			${inoutPrsn},
	gsGwYn:				'${gsGwYn}',
};

var outDivCode = UserInfo.divCode;
var outUserId = UserInfo.userID;
var sumtypeCell = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
if(BsaCodeInfo.gsSumTypeCell =='Y') {
	sumtypeCell = false;
}

function appMain() {
	var gubunStore = Unilite.createStore('gubunComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'<t:message code="system.label.purchase.confirm" default="확인"/>'  , 'value':'Y'},
            {'text':'<t:message code="system.label.purchase.notconfirm" default="미확인"/>'  , 'value':'N'}
        ]
    });

	Unilite.defineModel('detailModel', {
		fields: [
             { name: 'EXPIRY_TYPE'      ,text:'기한구분'            ,type: 'string'},
             { name: 'SEQ'       		,text:'번호'              ,type: 'int'},
             { name: 'ITEM_CODE'       	,text:'품목코드'            ,type: 'string'},
             { name: 'ITEM_NAME'       	,text:'품목명'             ,type: 'string'},
             { name: 'SPEC'       	    ,text:'규격'              ,type: 'string'},
             { name: 'STOCK_UNIT'       ,text:'재고단위'            ,type: 'string'},
             { name: 'GUBUN'       	    ,text:'양불구분'            ,type: 'string'},
             { name: 'STOCK_MOVE_Q'     ,text:'이관수량'            ,type: 'uniQty'},
             { name: 'GOOD_STOCK'       ,text:'양품수량'            ,type: 'uniQty'},
             { name: 'BAD_STOCK'       	,text:'불량수량'            ,type: 'uniQty'},             
             { name: 'AVERAGE_P'       	,text:'평균단가'            ,type: 'uniUnitPrice'},
             { name: 'STOCK_AMT'       	,text:'재고금액'            ,type: 'uniPrice'},
             { name: 'S_EXPIRY_DATE_YH' ,text:'유통기한'            ,type: 'uniDate'},
             { name: 'S_INOUT_DATE'     ,text:'수불일자'            ,type: 'uniDate'},
             { name: 'LOT_NO'       	,text:'LOT NO'          ,type: 'string'},
             { name: 'WH_CODE'       	,text:'출고창고'            ,type: 'string'},
             { name: 'REMARK'       	,text:'비고'              ,type: 'string'},
             { name: 'GUBUN_CODE'       ,text:'양불구분'            ,type: 'string'}

        ]
	});

	var detailStore = Unilite.createStore('detailStore',{
		model: 'detailModel',
		proxy: {
			type: 'direct',
			api: {
				read	: 'biv450ukrvService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelResult.getValues();
			if(BsaCodeInfo.gsSumTypeCell == 'Y'){
				param.SUM_TYPE = 'D';
			}else{
				param.SUM_TYPE = 'C';
			}
			
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	}
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items:[{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name		: 'DIV_CODE',
			value		: outDivCode,
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			child		: 'WH_CODE',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelResult.setValue('TO_DIV_CODE', newValue);
				}
			}
		},{
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				child		: 'WH_CELL_CODE',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('TO_WH_CODE')){
								if(BsaCodeInfo.gsSumTypeCell == 'N'){//cell사용을 안 할경우
									alert('<t:message code="" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
									panelResult.setValue('WH_CODE', oldValue);
									return false;
								}

							};
						};
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
				holdable	: 'hold',
				allowBlank  : sumtypeCell,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('TO_WH_CELL_CODE') && panelResult.getValue('WH_CODE') == panelResult.getValue('TO_WH_CODE')){
									alert('<t:message code="" default="입고창고cell과 출고창고cell이 동일할 수 없습니다."/>');
									panelResult.setValue('WH_CELL_CODE', oldValue);
									return false;

							};
						};

					}
				}
			},{
			fieldLabel:'기준일',
            xtype: 'uniDatefield',
            name: 'BASE_DATE',
            value: UniDate.get('today'),
			allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                }
            }

		},{
			fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
			name:'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},

		Unilite.popup('DIV_PUMOK',{
        	fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
        	valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			validateBlank: false,
        	listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
	   }),{
			xtype: 'radiogroup',
			fieldLabel: '유통기한',
			labelWidth:90,
			colspan:2,
			items : [{
				boxLabel: '폐기',
				width: 60,
				name: 'EXPIRY_SEQ',
				inputValue: '1',
				checked: true
			},{
				boxLabel: '6개월',
				width: 60,
				name: 'EXPIRY_SEQ' ,
				inputValue: '2'
			},{
				boxLabel: '12개월',
				width: 60,
				name: 'EXPIRY_SEQ' ,
				inputValue: '3'
			},{
				boxLabel: '전체',
				width: 60,
				name: 'EXPIRY_SEQ' ,
				inputValue: ''
				
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		{
			fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
			name: 'ITEM_LEVEL1' ,
			xtype: 'uniCombobox' ,
			store: Ext.data.StoreManager.lookup('itemLeve1Store') ,
			child: 'ITEM_LEVEL2',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
			name: 'ITEM_LEVEL2' ,
			xtype: 'uniCombobox' ,
			store: Ext.data.StoreManager.lookup('itemLeve2Store') ,
			child: 'ITEM_LEVEL3',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
			name: 'ITEM_LEVEL3' ,
			xtype: 'uniCombobox' ,
			colspan:2,
			store: Ext.data.StoreManager.lookup('itemLeve3Store'),
            parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
            levelType:'ITEM',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		{
				fieldLabel	: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name		: 'TO_WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList2'),
				child		: 'TO_WH_CELL_CODE',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('WH_CODE')){
								if(BsaCodeInfo.gsSumTypeCell == 'N'){//cell사용을 안 할경우
									alert('<t:message code="" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
									panelResult.setValue('TO_WH_CODE', oldValue);
									return false;
								}

							};
						};
					}
				}
			},{
				fieldLabel	: '입고창고Cell',
				name		: 'TO_WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('WH_CELL_CODE') && panelResult.getValue('WH_CODE') == panelResult.getValue('TO_WH_CODE')){
									alert('<t:message code="" default="입고창고cell과 출고창고cell이 동일할 수 없습니다."/>');
									panelResult.setValue('TO_WH_CELL_CODE', oldValue);
									return false;

							};
						};
					}
				}
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				autoSelect	: false,
				allowBlank	: false,
				holdable	: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>',
				name		: 'TO_DIV_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('toDivList'),
				child		: 'TO_WH_CODE',
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
					}
				}
			}
		]
    });

	var detailGrid = Unilite.createGrid('detailGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: true,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: true,
				useStateList: true
			}
		},
		tbar: [{
			itemId: 'stockmoveLinkBtn',
			text: '<t:message code="system.label.base.inventorymovementissue" default="재고이동출고"/>',
			handler: function() {
				if(!panelResult.getInvalidMessage()) return false;
				
				var detailSelectedRecs	= detailGrid.getSelectedRecords();
				if(detailSelectedRecs.length == 0){
					Unilite.messageBox('재고이동출고등록화면으로 보낼 자료가 없습니다.');
					return false;
				}
			
				if(detailSelectedRecs.length != 0){
					
					var record = detailGrid.getSelectionModel().getSelection();
					
					var sendCnt = 0;
				    data = new Object();
				    data.records = [];	
				    
					Ext.each(record, function(rec,i){
							sendCnt = sendCnt + 1;
							data.records.push(rec);

					});					
					
					if(sendCnt > 0){
						var params = {
							action		: 'select',
							'PGM_ID'	: 'biv450ukrv',
							'record'	: data.records,
							'formPram'	: panelResult.getValues()
						}
						var rec = {data : {prgID : 'btr111ukrv', 'text':''}};
						parent.openTab(rec, '/stock/btr111ukrv.do', params, CHOST+CPATH);
					
					}else{
							Unilite.messageBox('재고이동출고등록화면으로 보낼 자료가 없습니다.');
							return false;			
						
					}
				}
			}
		}

],		
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		store: detailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false, 
            listeners: {
		                select: function(grid, selectRecord, index, rowIndex, eOpts ){
						   if(selectRecord.get('STOCK_MOVE_Q') == 0) {
							   if(selectRecord.get('GUBUN_CODE') == '1') {
									selectRecord.set('STOCK_MOVE_Q', selectRecord.get('GOOD_STOCK'))
							   }
							   if(selectRecord.get('GUBUN_CODE') == '2') {
									selectRecord.set('STOCK_MOVE_Q', selectRecord.get('BAD_STOCK'))
							   }
						   }
						   
		                },
		                deselect:  function(grid, selectRecord, index, eOpts ){
		                	selectRecord.set('STOCK_MOVE_Q', 0)
		                }
		            }		
		}),
		columns: [
             { dataIndex: 'EXPIRY_TYPE'            ,  width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
             },
             { dataIndex: 'SEQ'       			,  width: 80 },
             { dataIndex: 'ITEM_CODE'       	,  width: 100 },
             { dataIndex: 'ITEM_NAME'       	,  width: 250 },
             { dataIndex: 'SPEC'       		    ,  width: 100 },
             { dataIndex: 'STOCK_UNIT'       	,  width: 100 },
             { dataIndex: 'GUBUN'       		,  width: 100 },
             { dataIndex: 'STOCK_MOVE_Q'       	,  width: 120, summaryType: 'sum' },
             { dataIndex: 'GOOD_STOCK'       	,  width: 120, summaryType: 'sum' },
             { dataIndex: 'BAD_STOCK'       	,  width: 120, summaryType: 'sum' },             
             { dataIndex: 'AVERAGE_P'       	,  width: 120, summaryType: 'sum' },
             { dataIndex: 'STOCK_AMT'       	,  width: 120, summaryType: 'sum' },
             { dataIndex: 'S_EXPIRY_DATE_YH' 	,  width: 100 },
             { dataIndex: 'S_INOUT_DATE' 		,  width: 100 },
             { dataIndex: 'LOT_NO'       		,  width: 100 },
             { dataIndex: 'WH_CODE'       		,  width: 100, hidden:true },
             { dataIndex: 'REMARK'       		,  width: 200 },
             { dataIndex: 'GUBUN_CODE'       	,  width: 100, hidden:true }
  		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['EXPIRY_TYPE', 'SEQ','ITEM_CODE','ITEM_NAME','SPEC', 'STOCK_UNIT','GUBUN', 'GOOD_STOCK','BAD_STOCK','AVERAGE_P','STOCK_AMT','S_EXPIRY_DATE_YH','S_INOUT_DATE','LOT_NO','REMARK'])){
						return false;
					}

				}
			}
		}
	});
	
	Unilite.Main({
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				detailGrid, panelResult
			]
		}
		],
		id: 'biv450ukrvApp',
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			detailGrid.reset();
			detailStore.clearData();

			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
            if(Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
            	Unilite.messageBox('사업장은 필수입력 항목입니다.');
            	return false;
            }
            if(Ext.isEmpty(panelResult.getValue('WH_CODE'))){
            	Unilite.messageBox('출고창고는 필수입력 항목입니다.');
            	return false;
            }            
			panelResult.getField('DIV_CODE').setReadOnly(true);
			detailStore.loadStoreRecords();
		},
		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnUserId: function(subCode){ //로그인 아이디의 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode10'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},		
		fnInitInputFields: function(){
			
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.getField('DIV_CODE').setReadOnly(false);
			panelResult.setValue('TO_DIV_CODE', UserInfo.divCode);
			panelResult.getField('TO_DIV_CODE').setReadOnly(true);

			panelResult.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_ORDER_DATE', UniDate.get('today'));
			
			var param = {
				"DIV_CODE": outDivCode,
				"DEPT_CODE": UserInfo.deptCodeR
			};
			biv450ukrvService.deptWhcode(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					 panelResult.setValue('WH_CODE', provider['WH_CODE']);
					  panelResult.setValue('TO_WH_CODE', provider['WH_CODE']);
				}
			});					
			
			biv450ukrvService.userWhcode({}, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('TO_WH_CODE',provider['WH_CODE']);
				}
			})	
			
			var inoutPrsn;
			if(!Ext.isEmpty(BsaCodeInfo.inoutPrsn[0].refCode10)){
				inoutPrsn = UniAppManager.app.fnGetInoutPrsnUserId(outUserId);	  //로그인 아이디에 따른 영업담당자 set
			}
			if(Ext.isEmpty(panelResult.getValue('INOUT_PRSN')) && Ext.isEmpty(inoutPrsn)){
				inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(outDivCode);		//사업장의 첫번째 영업담당자 set
			}			

			panelResult.setValue('INOUT_PRSN'		, inoutPrsn);							//사업장에 따른 수불담당자 불러와야함			
			

			UniAppManager.setToolbarButtons(['reset'], true);
		}
		
	});// End of Unilite.Main( {		
		
	//Validation
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;	
			
					switch(fieldName) {
					case "STOCK_MOVE_Q" :
						
						if(newValue <= 0 && !Ext.isEmpty(newValue)) {
							rv = '<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
							break;
						}
						break;
				}
			return rv;
		}
	}); // validator
};
</script>