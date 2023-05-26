<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ssa450rkrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_ssa450rkrv_yp"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 's_ssa450rkrv_ypService.selectList'
		}
	});



	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_ssa450rkrv_ypModel', {
		fields: [
			{name: 'COMP_CODE'			,text: 'COMP_CODE'	,type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'	,type: 'string'},
			{name: 'SALE_CUSTOM_CODE'	,text: '거래처코드'		,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	,text: '거래처명'		,type: 'string'},
			{name: 'SALE_AMT_TOT'		,text: '매출액'		,type: 'uniPrice'}
		]
	});


	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */				 
	var directMasterStore = Unilite.createStore('s_ssa450rkrv_ypMasterStore',{
		model: 's_ssa450rkrv_ypModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			console.log( param );
			panelResult.setValue('CUSTOM_CODES','');
			this.load({ params : param});
		}
	});
	
	
	
	var masterGrid = Unilite.createGrid('s_ssa450rkrv_ypGrid1', {
		region: 'center',
		layout: 'fit',
		uniOpt: {
			expandLastColumn	: true,
			copiedRow			: false,
			onLoadSelectFirst	: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODES'))) {
						panelResult.setValue('CUSTOM_CODES', selectRecord.get('SALE_CUSTOM_CODE'));
					} else {
						var customCodes = panelResult.getValue('CUSTOM_CODES');
						customCodes = customCodes + ',' + selectRecord.get('SALE_CUSTOM_CODE');
						panelResult.setValue('CUSTOM_CODES', customCodes);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var customCodes	 = panelResult.getValue('CUSTOM_CODES');
					var deselectedNum0  = selectRecord.get('SALE_CUSTOM_CODE') + ','; 
					var deselectedNum1  = ',' + selectRecord.get('SALE_CUSTOM_CODE'); 
					var deselectedNum2  = selectRecord.get('SALE_CUSTOM_CODE'); 
					customCodes = customCodes.split(deselectedNum0).join("");
					customCodes = customCodes.split(deselectedNum1).join("");
					customCodes = customCodes.split(deselectedNum2).join("");
					panelResult.setValue('CUSTOM_CODES', customCodes);
				}
			}
		}),
		store: directMasterStore,
		columns: [
				{dataIndex: 'COMP_CODE'			, width: 100, hidden: true },
				{dataIndex: 'DIV_CODE'			, width: 100, hidden: true },
				{dataIndex: 'SALE_CUSTOM_CODE'	, width: 120 }, 
				{dataIndex: 'SALE_CUSTOM_NAME'	, width: 240 }, 
				{dataIndex: 'SALE_AMT_TOT'		, width: 170 } 
			],
			listeners: {
				beforeedit: function( editor, e, eOpts ) {
//					if(!e.record.phantom == true) { // 신규가 아닐 때
//						if(UniUtils.indexOf(e.field, ['SALE_CUSTOM_CODE', 'SALE_CUSTOM_NAME' ,'FARM_CODE' ,'FARM_NAME'])) {
//							return false;
//						}
//					}
				}
			}
	}); 

	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'radiogroup',
			fieldLabel: '보고서 유형',	 
			id: 'PRINT_CONDITION',
			items : [{
				boxLabel: '상세내역',
				width:80 ,
				name: 'PRINT_CONDITION', 
				inputValue: '1',
				checked: true
			}, {
				boxLabel: '일자별내역', 
				width:100 ,
				name: 'PRINT_CONDITION', 
				inputValue: '3'
			}, {
				boxLabel: '집계내역', 
				width:80 ,
				name: 'PRINT_CONDITION', 
				inputValue: '2'
			}]
		},{		
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox', 
			comboType:'BOR120', 
			allowBlank:false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
			Unilite.popup('AGENT_CUST',{ 
			fieldLabel: '거래처', 
			valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME',
			//validateBlank	: false,
			autoPopup : true,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
				}
			}
		}),{
			fieldLabel: '매출일',
			xtype: 'uniDateRangefield',
			startFieldName: 'SALE_FR_DATE',
			endFieldName: 'SALE_TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),			
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			fieldLabel: '영업담당'  ,
			name: 'SALE_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('SALE_PRSN', newValue);
				}
			}/*,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}*/
		},
		Unilite.popup('DIV_PUMOK', { 
			fieldLabel: '품목코드',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			//validateBlank	: false,
			autoPopup : true
		}),{
			fieldLabel: 'CUSTOM_CODES',
			xtype: 'uniTextfield',
			name: 'CUSTOM_CODES',
			hidden: true
		}]
	});

	
	Unilite.Main({
		id			: 's_ssa450rkrv_ypApp',
		borderItems	: [{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,panelResult
			]
		}],
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('SALE_FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('SALE_TO_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('print',true);
//			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onPrintButtonDown: function() {
			if(this.onFormValidate()){
				if(directMasterStore.getCount() != 0 && masterGrid.getSelectedRecords().length == 0){
					alert('출력할 거래처를 선택해 주세요.');	
					return false;
				}
				var param = panelResult.getValues();
				 var win = Ext.create('widget.CrystalReport', {
					url: CPATH+'/z_yp/s_ssa450cukrv_yp.do',
					prgID: 's_ssa450rkrv',
						extParam: param
				});
				win.center();
				win.show();
			}
		},
		onFormValidate: function(){
			var r= true
			var invalid = panelResult.getForm().getFields().filterBy(
		 		function(field) {
					return !field.validate();
				}
			);

			if(invalid.length > 0) {
				r=false;
				var labelText = ''
	
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
	
				alert(labelText+Msg.sMB083);
				invalid.items[0].focus();
			}
			return r;
		}
	});
};

</script>
