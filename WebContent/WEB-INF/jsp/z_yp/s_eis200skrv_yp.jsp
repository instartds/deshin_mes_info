<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_eis200skrv_yp"  >
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장	-->
	<style type="text/css">
		#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
	</style>	
</t:appConfig>

<script type="text/javascript" >


function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_eis200skrv_ypModel', {
		fields: [
			{name: 'DIV_CODE'	, text: '사업장'	, type: 'string'	, allowBlank: false	, comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'REGION'		, text: ' '		, type: 'string'	},
			{name: 'GUBUN'		, text: '구분'	, type: 'string'	},
			//합계
			{name: 'SUM_Q'		, text: '수량'	, type: 'uniQty'	}, 
			{name: 'SUM_O'		, text: '금액'	, type: 'uniPrice'	},
			//기준일
			{name: 'Q1'			, text: '수량'	, type: 'uniQty'	}, 
			{name: 'O1'			, text: '금액'	, type: 'uniPrice'	},
			//기준일 + 1
			{name: 'Q2'			, text: '수량'	, type: 'uniQty'	}, 
			{name: 'O2'			, text: '금액'	, type: 'uniPrice'	},
			//기준일 + 2
			{name: 'Q3'			, text: '수량'	, type: 'uniQty'	}, 
			{name: 'O3'			, text: '금액'	, type: 'uniPrice'	},
			//기준일 + 3
			{name: 'Q4'			, text: '수량'	, type: 'uniQty'	}, 
			{name: 'O4'			, text: '금액'	, type: 'uniPrice'	},
			//기준일 + 4
			{name: 'Q5'			, text: '수량'	, type: 'uniQty'	}, 
			{name: 'O5'			, text: '금액'	, type: 'uniPrice'	},
			//기준일 + 5
			{name: 'Q6'			, text: '수량'	, type: 'uniQty'	}, 
			{name: 'O6'			, text: '금액'	, type: 'uniPrice'	},
			//기준일 + 6
			{name: 'Q7'			, text: '수량'	, type: 'uniQty'	}, 
			{name: 'O7'			, text: '금액'	, type: 'uniPrice'	}
		]
	});
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_eis200skrv_ypMasterStore',{
		model	: 's_eis200skrv_ypModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 's_eis200skrv_ypService.selectList'
			}
		},
		loadStoreRecords: function()	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				masterStore.sort({property : 'REGION', direction: 'DESC'});
			}
		}
//		groupField: 'REGION',
//		groupDir : 'DESC'
	});
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;' , width: '100%'}
		},
		padding	: '1 1 1 1',
		border	: true,	
		items	: [{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			tdAttrs		: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
//					if(!Ext.isEmpty(newValue)) {
//						UniAppManager.app.onQueryButtonDown();
//					}
				}
			}
		},{ 
			fieldLabel	: '기준일자',
			xtype		: 'uniDatefield',
			name		: 'BASIS_DATE',
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue) && UniDate.getDbDateStr(newValue).replace(/\./g,'').length == 8) {
						fnSetValue(newValue);
					}
				}
			}
		}]	
 	});		// end of var panelResul	
 	
	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_eis200skrv_ypGrid', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		flex	: 1,
		minHeight:220,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: false,		
			dblClickToEdit		: false,
			useMultipleSorting	: true
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 120	, hidden: true}, 
			{dataIndex: 'REGION'		, width: 80	, hidden: false}, 
			{dataIndex: 'GUBUN'			, width: 120}, 

			{text: '합계',
				columns: [
					{dataIndex: 'SUM_Q'	, width: 100}, 
					{dataIndex: 'SUM_O'	, width: 100} 
				]
			},
			{id: 'dvryDate1',
				columns: [
					{dataIndex: 'Q1'	, width: 100}, 
					{dataIndex: 'O1'	, width: 100} 
				]
			},
			{id: 'dvryDate2',
				columns: [
					{dataIndex: 'Q2'	, width: 100}, 
					{dataIndex: 'O2'	, width: 100} 
				]
			},
			{id: 'dvryDate3',
				columns: [
					{dataIndex: 'Q3'	, width: 100}, 
					{dataIndex: 'O3'	, width: 100} 
				]
			},
			{id: 'dvryDate4',
				columns: [
					{dataIndex: 'Q4'	, width: 100}, 
					{dataIndex: 'O4'	, width: 100} 
				]
			},
			{id: 'dvryDate5',
				columns: [
					{dataIndex: 'Q5'	, width: 100}, 
					{dataIndex: 'O5'	, width: 100} 
				]
			},
			{id: 'dvryDate6',
				columns: [
					{dataIndex: 'Q6'	, width: 100}, 
					{dataIndex: 'O6'	, width: 100} 
				]
			},
			{id: 'dvryDate7',
				columns: [
					{dataIndex: 'Q7'	, width: 100}, 
					{dataIndex: 'O7'	, width: 100} 
				]
			}
		]
	});
	
	
	
	Unilite.Main( {
		id			: 's_eis200skrv_ypApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid 
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);

			this.setDefault();
		},
		
		onQueryButtonDown: function()	{
			masterStore.loadStoreRecords();
		},
		
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_DATE'	, new Date());
			fnSetValue(new Date());
			
			panelResult.onLoadSelectText('DIV_CODE');
		}
	});
	
	
	
	
	
	
	
	
	//만들어진 날짜를 그리드컬럼에 set
	function fnSetValue(newValue) {
		if(Ext.isEmpty(newValue)) {
			return false;
		} 
		
		var dvryDate1 = UniDate.getDbDateStr(newValue);
		var dvryDate2 = UniDate.getDbDateStr(UniDate.add(newValue, {days: -1}));
		var dvryDate3 = UniDate.getDbDateStr(UniDate.add(newValue, {days: -2}));
		var dvryDate4 = UniDate.getDbDateStr(UniDate.add(newValue, {days: -3}));
		var dvryDate5 = UniDate.getDbDateStr(UniDate.add(newValue, {days: -4}));
		var dvryDate6 = UniDate.getDbDateStr(UniDate.add(newValue, {days: -5}));
		var dvryDate7 = UniDate.getDbDateStr(UniDate.add(newValue, {days: -6}));
		
		dvryDate1 = dvryDate1.substring(4, 6) + '월 ' + dvryDate1.substring(6, 8) + '일 (' + getInputDayLabel(dvryDate1) + ')';
		dvryDate2 = dvryDate2.substring(4, 6) + '월 ' + dvryDate2.substring(6, 8) + '일 (' + getInputDayLabel(dvryDate2) + ')';
		dvryDate3 = dvryDate3.substring(4, 6) + '월 ' + dvryDate3.substring(6, 8) + '일 (' + getInputDayLabel(dvryDate3) + ')';
		dvryDate4 = dvryDate4.substring(4, 6) + '월 ' + dvryDate4.substring(6, 8) + '일 (' + getInputDayLabel(dvryDate4) + ')';
		dvryDate5 = dvryDate5.substring(4, 6) + '월 ' + dvryDate5.substring(6, 8) + '일 (' + getInputDayLabel(dvryDate5) + ')';
		dvryDate6 = dvryDate6.substring(4, 6) + '월 ' + dvryDate6.substring(6, 8) + '일 (' + getInputDayLabel(dvryDate6) + ')';
		dvryDate7 = dvryDate7.substring(4, 6) + '월 ' + dvryDate7.substring(6, 8) + '일 (' + getInputDayLabel(dvryDate7) + ')';

		Ext.getCmp('dvryDate1').setText(dvryDate1);
		Ext.getCmp('dvryDate2').setText(dvryDate2);
		Ext.getCmp('dvryDate3').setText(dvryDate3);
		Ext.getCmp('dvryDate4').setText(dvryDate4);
		Ext.getCmp('dvryDate5').setText(dvryDate5);
		Ext.getCmp('dvryDate6').setText(dvryDate6);
		Ext.getCmp('dvryDate7').setText(dvryDate7);
		
		UniAppManager.app.onQueryButtonDown();
	}
	//날짜 입력 받아 요일 구하는 함수
	function getInputDayLabel(date) { 
		date		= date.substring(0, 4) + '-' + date.substring(4, 6) + '-' + date.substring(6, 8);
		var week	= new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'); 
		var today	= new Date(date).getDay(); 
		var todayLabel = week[today]; 

		return todayLabel;
	}
};
</script>
