<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpl100skrv">
	<t:ExtComboStore comboType="BOR120"/>	<!-- 사업장 -->
</t:appConfig>
<script type="text/javascript">
function appMain(){
	Unilite.defineModel('Bpl100skrvModel',{
		fields:[
			{name:'ITEM_ACCOUNT',		text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>',				type:'string' },
			{name:'ITEM_CODE',			text:'<t:message code="system.label.base.itemcode" default="품목코드"/>',					type:'string' },
			{name:'ITEM_NAME',			text:'<t:message code="system.label.base.itemname" default="품목명"/>',					type:'string' },
			{name:'SPEC',				text:'<t:message code="system.label.base.spec" default="규격"/>',							type:'string' },
			{name:'ORDER_UNIT',			text:'단위',		type:'string' },
			{name:'SUPPLY_TYPE_CODE',	text:'조달구분코드',	type:'string' },
			{name:'SUPPLY_TYPE',		text:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>',	type:'string' },
			{name:'BASIS_P',			text:'<t:message code="system.label.base.inventoryprice" default="재고단가"/>',				type:'uniPrice' },
			{name:'PL_COST',			text:'재료비',		type:'uniPrice' },
			{name:'PL_AMOUNT',			text:'외주가공비',	type:'uniPrice' },
			{name:'PL_PRICE',			text:'합계금액',	type:'uniPrice' },
			{name:'PL_MATERIAL',		text:'원료',		type:'uniPrice' },
			{name:'PL_SUB_MATERIAL',	text:'부재료',		type:'uniPrice' },
			{name:'PURCHASE_BASE_P',	text:'<t:message code="system.label.base.purchaseprice" default="구매단가"/>',				type:'uniPrice' }
		]
	});//model结束

	var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api:{
			read:'bpl100skrvService.selectDetailList'//对应的是该页面id的service
		}
	});

	var directMasterStore=Unilite.createStore('bpl100skrvMasterStore',{
		model:'Bpl100skrvModel',
		autoLoad:false,
		uniOpt:{
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false				// prev | next 버튼 사용
		},
		proxy:directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}//loadstore结束
	});//定义store结束



	var panelSearch=Unilite.createSearchForm('searchForm',{
		layout	: {type : 'uniTable' , columns: 3/*, tableAttrs: {width: '100%'}*/},		//20210819 주석: 100% 주석
		items	: [{
			fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
			xtype: 'uniCombobox', 
			comboType:'BOR120',//待定
			name:'DIV_CODE',
			allowBlank:false,
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('ITEM',{
			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
			valueFieldName:'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			allowBlank:true,
			validateBlank: false,		//20210819 추가
			listeners:{
				//20210819 수정: 조회조건 팝업설정에 맞게 변경
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
					}
				}
			}
		}),{
			fieldLabel:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>',
			xtype:'uniCombobox',
			name:'SPTYPE',
			comboType:'AU',
			comboCode:'B014',
			allowBlank:true,
			listeners:{
				change:function(combo,newValue,oldValue,eOpts){
				}
			}
		},{
			fieldLabel:'계정',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			name:'ACCOUNT',
			listeners:{
				change:function(combo,newValue,oldValue,eOpts){
				}
			}
		}]
	});//panelSearch结束



	var masterGrid=Unilite.createGrid('bpl100skrvGrid',{
		layout:'fit',
		region:'center',
		store: directMasterStore,
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false,
			useMultipleSorting:false
		},
		columns:[
			{dataIndex:'ITEM_ACCOUNT',		width:80, align:'center'},
			{dataIndex:'ITEM_CODE',			width:150},
			{dataIndex:'ITEM_NAME',			width:200},
			{dataIndex:'SPEC',				width:200},
			{dataIndex:'ORDER_UNIT',		width:80, align:'center'},
			{dataIndex:'SUPPLY_TYPE',		width:100, align:'center'},
			{dataIndex:'BASIS_P',			width:100},
			{dataIndex:'PL_COST',			width:100},
			{dataIndex:'PL_AMOUNT',			width:100},
			{dataIndex:'PL_PRICE',			width:100},
			{dataIndex:'PL_MATERIAL',		width:100},
			{dataIndex:'PL_SUB_MATERIAL',	width:100},
			{dataIndex:'PURCHASE_BASE_P',	width:100}
		]
	});//masterGrid结束



	Unilite.Main({
		items:[panelSearch,masterGrid],
		id : 'bpl100skrvApp',
		fnInitBinding : function(){
			UniAppManager.setToolbarButtons(['reset'],true);
		},
		onQueryButtonDown : function() {
			if(!panelSearch.getInvalidMessage()){
				return false;
			};
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('bpl100skrvGrid');
			Ext.getCmp('searchForm').getForm().reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		}
	});
}
</script>