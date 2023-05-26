<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof101skrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sof101skrv_yp"  />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!-- 발주단위 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" />						<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />						<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />						<!-- 영업담당 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >



function appMain() {
//일별 납기일 저장할 변수 선언
var queryYear   =  '';
var gsDvryDate1 = '';
var gsDvryDate2 = '';
var gsDvryDate3 = '';
var gsDvryDate4 = '';
var gsDvryDate5 = '';
var gsDvryDate6 = '';
var gsDvryDate7 = '';


	/** Model 정의입니다.
	 * @type
	 */
	Unilite.defineModel('s_sof101skrv_ypModel', {
		fields: [
			{name: 'COMP_CODE'			,text:'COMP_CODE'		,type: 'string'},
			{name: 'CUSTOM_CODE'		,text:'수주처코드'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text:'수주처'				,type: 'string'},
			{name: 'ITEM_CODE'			,text:'품목코드'			,type: 'string'},
			{name: 'ITEM_NAME'			,text:'품목명'				,type: 'string'},
			{name: 'SPEC'				,text:'규격'				,type: 'string'},
			{name: 'REMARK'				,text:'적요'				,type: 'string'},
			{name: 'ORDER_UNIT'			,text:'단위'				,type: 'string'		, comboType: 'AU', comboCode: 'B013'},
			{name: 'ORDER_UNIT_Q1'		,text:'ORDER_UNIT_Q1'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q2'		,text:'ORDER_UNIT_Q2'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q3'		,text:'ORDER_UNIT_Q3'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q4'		,text:'ORDER_UNIT_Q4'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q5'		,text:'ORDER_UNIT_Q5'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q6'		,text:'ORDER_UNIT_Q6'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_Q7'		,text:'ORDER_UNIT_Q7'	,type: 'uniQty'},
			{name: 'TOT_QTY'			,text:'총수량'				,type: 'uniQty'},
			{name: 'ORDER_NUM'			,text:'수주번호'			,type: 'string'},
			{name: 'PURCHASE_CUSTOM_CODE'			,text:'발주처코드'			,type: 'string'},
			{name: 'PURCHASE_CUSTOM_NAME'			,text:'발주처명'			,type: 'string'},
			{name: 'PRE_DVRY'			,text:'PRE_DVRY'			,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_sof101skrv_ypMasterStore1',{
		model	: 's_sof101skrv_ypModel',
		uniOpt	: {
			isMaster:  true,			// 상위 버튼 연결
			editable:  false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi :  false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type	: 'direct',
			api		: {
				read: 's_sof101skrv_ypService.selectList'
			}
		},
		loadStoreRecords : function()   {
			var param= panelResult.getValues();
			this.load({
				params : param
			});
		}, groupField:'CUSTOM_NAME'
	}); // End of var masterStore1



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			tdAttrs		: {width: 300}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '거래처',
			validateBlank	: false,
			extParam		: {'CUSTOM_TYPE':'3'},
			listeners		: {
				applyextparam: function(popup) {
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
//					popup.setExtParam({'CUSTOM_TYPE':'3'});
				}
			}
		}),{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items:[{
				fieldLabel	: '기준일자',
				xtype		: 'uniDatefield',
				name		: 'BASIS_DATE',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue) && UniDate.getDbDateStr(newValue).length == 8) {
							fnGetCalNo(newValue);
						} else {
							panelResult.setValue('DVRY_DATE_FR', '');
							panelResult.setValue('DVRY_DATE_TO', '');
						}
					}
				}
			},{
				fieldLabel		: '조회기간',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'DVRY_DATE_FR',
				endFieldName	: 'DVRY_DATE_TO',
				allReadOnly		: true,
				labelWidth		: 60,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			}
		]}, {
			fieldLabel	: '판매유형',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}, {
			fieldLabel	: '영업담당',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			multiSelect	: true,
			typeAhead	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '품목코드',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})]
	});


	var masterGrid = Unilite.createGrid('s_sof101skrv_ypmasterGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt: {
			expandLastColumn	: true,
			useMultipleSorting	: true,
			useGroupSummary		: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useRowNumberer		: true,	   //순번표시
			copiedRow			: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns:  [
			{ dataIndex: 'COMP_CODE'		, width: 90		, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 180	, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 140,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{ dataIndex: 'ITEM_CODE'		, width: 100	, hidden: true},
			{ dataIndex: 'ITEM_NAME'		, width: 140},
			{ dataIndex: 'SPEC'				, width: 100},
			{ dataIndex: 'REMARK'			, width: 100},
			{ dataIndex: 'ORDER_UNIT'		, width: 60 },
			{ dataIndex: 'ORDER_UNIT_Q1'	, width: 100	, id: 'dvryDate1'	,summaryType: 'sum',   renderer:function(value, metaData, record){
                if(record.get('PRE_DVRY') != 'A' && record.get('ORDER_UNIT_Q1') != 0){
                    return '<div style="background:orange">'+value+'</div>'
                }else{
                	return value;
                }
            }},
			{ dataIndex: 'ORDER_UNIT_Q2'	, width: 100	, id: 'dvryDate2'	,summaryType: 'sum',   renderer:function(value, metaData, record){
                if(record.get('PRE_DVRY') != 'A' &&  record.get('ORDER_UNIT_Q2') != 0){
                    return '<div style="background:orange">'+value+'</div>'
                }else{
                	return value;
                }
            }},
			{ dataIndex: 'ORDER_UNIT_Q3'	, width: 100	, id: 'dvryDate3'	,summaryType: 'sum',   renderer:function(value, metaData, record){
                if(record.get('PRE_DVRY') != 'A' &&  record.get('ORDER_UNIT_Q3') != 0){
                    return '<div style="background:orange">'+value+'</div>'
                }else{
                	return value;
                }
            }},
			{ dataIndex: 'ORDER_UNIT_Q4'	, width: 100	, id: 'dvryDate4'	,summaryType: 'sum',   renderer:function(value, metaData, record){
                if(record.get('PRE_DVRY') != 'A' &&  record.get('ORDER_UNIT_Q4') != 0){
                    return '<div style="background:orange">'+value+'</div>'
                }else{
                	return value;
                }
            }},
			{ dataIndex: 'ORDER_UNIT_Q5'	, width: 100	, id: 'dvryDate5'	,summaryType: 'sum',   renderer:function(value, metaData, record){
                if(record.get('PRE_DVRY') != 'A' &&  record.get('ORDER_UNIT_Q5') != 0){
                    return '<div style="background:orange">'+value+'</div>'
                }else{
                	return value;
                }
            }},
			{ dataIndex: 'ORDER_UNIT_Q6'	, width: 100	, id: 'dvryDate6'	,summaryType: 'sum',   renderer:function(value, metaData, record){
                if(record.get('PRE_DVRY') != 'A' &&  record.get('ORDER_UNIT_Q6') != 0){
                    return '<div style="background:orange">'+value+'</div>'
                }else{
                	return value;
                }
            }},
			{ dataIndex: 'ORDER_UNIT_Q7'	, width: 100	, id: 'dvryDate7'	,summaryType: 'sum',   renderer:function(value, metaData, record){
                if(record.get('PRE_DVRY') != 'A' &&  record.get('ORDER_UNIT_Q7') != 0){
                    return '<div style="background:orange">'+value+'</div>'
                }else{
                	return value;
                }
            }},
			{ dataIndex: 'TOT_QTY'			, width: 110	,summaryType: 'sum'},
			{ dataIndex: 'ORDER_NUM'		, width: 130},
			{ dataIndex: 'PURCHASE_CUSTOM_CODE'	, width: 100, align: 'center', hidden: true},
			{ dataIndex: 'PURCHASE_CUSTOM_NAME'	, width: 150, hidden: true}
		],
		listeners: {
		}
	});



	Unilite.Main({
		id			: 's_sof101skrv_ypApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [ panelResult, masterGrid ]
		}],
		fnInitBinding : function() {
			//전역변수 초기화
			queryYear = ''
			gsDvryDate1 = '';
			gsDvryDate2 = '';
			gsDvryDate3 = '';
			gsDvryDate4 = '';
			gsDvryDate5 = '';
			gsDvryDate6 = '';
			gsDvryDate7 = '';

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_DATE'	, UniDate.get('today'));
			panelResult.getField('DVRY_DATE_FR').setReadOnly(true);
			panelResult.getField('DVRY_DATE_TO').setReadOnly(true);

			fnGetCalNo(UniDate.get('today'));

			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown : function()  {
			if(!panelResult.getInvalidMessage()) {
				return false;
			}
			masterStore.loadStoreRecords();

			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},

		onResetButtonDown: function() {
			panelResult.clearForm();
			masterStore.loadData({});

			this.fnInitBinding();
		}
	});



	//수주일자 입력에 따른 주차 가져오는 로직
	function fnGetCalNo(newValue) {
		param = {
			CAL_DATE	: UniDate.getDbDateStr(newValue)
		}
		s_sof101skrv_ypService.getCalNo(param, function(provider, response){
			if(!Ext.isEmpty(provider)) {
				var calNo = provider[0].CAL_NO;

				//날짜 가져오는 로직 호출
				fnGetCalDate(calNo, param.CAL_DATE);
			} else {
				alert('입력된 일자에 해당하는 달력 정보가 없습니다.');
				panelResult.setValue('BASIS_DATE'	, '');
				panelResult.setValue('DVRY_DATE_FR'	, '');
				panelResult.setValue('DVRY_DATE_TO'	, '');

				return false;
			}
		});
	}
	//수주일자 입력에 따른 날짜 가져오는 로직
	function fnGetCalDate(calNo, calDate) {
		param = {
			CAL_NO	: calNo,
			CAL_DATE: calDate
		}
		s_sof101skrv_ypService.getCalDate(param, function(provider, response){
			if(!Ext.isEmpty(provider)) {
				fnSetValue(provider);
			}
		});
	}
	//만들어진 날짜를 그리드컬럼에 set
	function fnSetValue(provider) {
		if(Ext.isEmpty(provider)) {
			return false;

		} else if(provider.length != 7) {
			alert('입력된 일자의 주차에 해당하는 달력 정보가 없습니다.');
			panelResult.setValue('BASIS_DATE'	, '');
			panelResult.setValue('DVRY_DATE_FR'	, '');
			panelResult.setValue('DVRY_DATE_TO'	, '');

			return false;
		}
		gsDvryDate1 = provider[0].CAL_DATE.substring(0, 4) + '-' + provider[0].CAL_DATE.substring(4, 6) + '-' + provider[0].CAL_DATE.substring(6, 8);
		gsDvryDate2 = provider[1].CAL_DATE.substring(0, 4) + '-' + provider[1].CAL_DATE.substring(4, 6) + '-' + provider[1].CAL_DATE.substring(6, 8);
		gsDvryDate3 = provider[2].CAL_DATE.substring(0, 4) + '-' + provider[2].CAL_DATE.substring(4, 6) + '-' + provider[2].CAL_DATE.substring(6, 8);
		gsDvryDate4 = provider[3].CAL_DATE.substring(0, 4) + '-' + provider[3].CAL_DATE.substring(4, 6) + '-' + provider[3].CAL_DATE.substring(6, 8);
		gsDvryDate5 = provider[4].CAL_DATE.substring(0, 4) + '-' + provider[4].CAL_DATE.substring(4, 6) + '-' + provider[4].CAL_DATE.substring(6, 8);
		gsDvryDate6 = provider[5].CAL_DATE.substring(0, 4) + '-' + provider[5].CAL_DATE.substring(4, 6) + '-' + provider[5].CAL_DATE.substring(6, 8);
		gsDvryDate7 = provider[6].CAL_DATE.substring(0, 4) + '-' + provider[6].CAL_DATE.substring(4, 6) + '-' + provider[6].CAL_DATE.substring(6, 8);

		var dvryDate1 = provider[0].CAL_DATE.substring(4, 6) + '월 ' + provider[0].CAL_DATE.substring(6, 8) + '일 ';
		var dvryDate2 = provider[1].CAL_DATE.substring(4, 6) + '월 ' + provider[1].CAL_DATE.substring(6, 8) + '일 ';
		var dvryDate3 = provider[2].CAL_DATE.substring(4, 6) + '월 ' + provider[2].CAL_DATE.substring(6, 8) + '일 ';
		var dvryDate4 = provider[3].CAL_DATE.substring(4, 6) + '월 ' + provider[3].CAL_DATE.substring(6, 8) + '일 ';
		var dvryDate5 = provider[4].CAL_DATE.substring(4, 6) + '월 ' + provider[4].CAL_DATE.substring(6, 8) + '일 ';
		var dvryDate6 = provider[5].CAL_DATE.substring(4, 6) + '월 ' + provider[5].CAL_DATE.substring(6, 8) + '일 ';
		var dvryDate7 = provider[6].CAL_DATE.substring(4, 6) + '월 ' + provider[6].CAL_DATE.substring(6, 8) + '일 ';

		Ext.getCmp('dvryDate1').setText(dvryDate1);
		Ext.getCmp('dvryDate2').setText(dvryDate2);
		Ext.getCmp('dvryDate3').setText(dvryDate3);
		Ext.getCmp('dvryDate4').setText(dvryDate4);
		Ext.getCmp('dvryDate5').setText(dvryDate5);
		Ext.getCmp('dvryDate6').setText(dvryDate6);
		Ext.getCmp('dvryDate7').setText(dvryDate7);

		panelResult.setValue('DVRY_DATE_FR'	, gsDvryDate1);
		panelResult.setValue('DVRY_DATE_TO'	, gsDvryDate7);
	}
}
</script>