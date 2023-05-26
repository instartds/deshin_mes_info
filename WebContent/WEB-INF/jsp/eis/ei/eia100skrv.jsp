<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eia100skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="eia100skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!--영업담당 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell_DrvyOver {
	//background-color: #FDE3FF;
	color: #FF0000;
}
.x-change-cell_DrvySoon {
	//background-color: #F3E2A9;
	color: #FFB000;
}

</style>
</t:appConfig>
<script type="text/javascript" >
var beforeRowIndex;	//마스터그리드 같은row중복 클릭시 다시 load되지 않게


function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Eia100skrvModel1', {
		fields: [
			{name : 'COMP_CODE'     ,       text : '법인코드',           type : 'string'},
            {name : 'GUBUN'      	,       text : '구분',        	  type : 'string'},
 	        {name : 'COL1'     		,       text : '극동가스케드공업(주)',   type : 'float'			, decimalPrecision: 0 , format:'0,000'},
			{name : 'COL2' 			,       text : '청도KDG',      	  type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'COL3'  		,       text : '스타월드공업(주)',      type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'COL4'       	,       text : '극동엔지니어링(주)',     type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'COL5'   		,       text : '',          	   type : 'float'		, decimalPrecision: 0 , format:'0,000'},
            {name : 'COL6'    		,       text : '',            	   type : 'float'		, decimalPrecision: 0 , format:'0,000'}
		]
	});

	Unilite.defineModel('Eia100skrvModel2', {
		fields: [
		         {name : 'COMP_CODE'    ,   text : '법인코드',          type : 'string'},
		         {name : 'COMP_NUM'     ,   text : '관계사명',          type : 'string', comboType : 'AU', comboCode : 'B302', allowBlank : false},
		         {name : 'COMP_NAME'    ,   text : '관계사명',          type : 'string'},
		         {name : 'CLOSING_DATE' ,   text : '결산 기준일',        type : 'uniDate', allowBlank : false},
		         {name : 'TOTAL_ASSETS' ,   text : '총자산',           type : 'float'		, decimalPrecision: 0 , format:'0,000'},
		         {name : 'TOTAL_DEBT'   ,   text : '부채총계',          type : 'float'		, decimalPrecision: 0 , format:'0,000'},
		         {name : 'TOTAL_CAPITAL',   text : '자본총계',          type : 'float'		, decimalPrecision: 0 , format:'0,000'},
		         {name : 'SALE_AMT'     ,   text : '매출액',           type : 'float'		, decimalPrecision: 0 , format:'0,000'},
		         {name : 'BIZ_PROFIT'   ,   text : '영업이익',          type : 'float'		, decimalPrecision: 0 , format:'0,000'},
		         {name : 'NET_PROFIT'   ,   text : '당기순이익',         type : 'float'		, decimalPrecision: 0 , format:'0,000'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('eia100skrvMasterStore1',{
		model	: 'Eia100skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'eia100skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param,
				callback: function() {

				}
			});
		}
	});

	var detailStore = Unilite.createStore('eia100skrvMasterStore2',{
		model	: 'Eia100skrvModel2',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'eia100skrvService.detailList'
			}
		},
		loadStoreRecords : function(record){

			var params = panelSearch.getValues();
			this.load({
				params : params
			});
		},
		groupField: 'COMP_NUM'
	});





	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items		: [{fieldLabel: '관계사(EIS)',
			            name:'COMP_NUM',
			            xtype: 'uniCombobox',
			            comboType:'AU',
			            comboCode:'B302',
			            width: 200,
						listeners	: {
							change: function(combo, newValue, oldValue, eOpts) {
							  panelResult.setValue('COMP_NUM', newValue);
							}
						}
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
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{	fieldLabel: '관계사(EIS)',
			            name:'COMP_NUM',
			            xtype: 'uniCombobox',
			            comboType:'AU',
			            comboCode:'B302',
						listeners	: {
							change: function(combo, newValue, oldValue, eOpts) {
							  panelSearch.setValue('COMP_NUM', newValue);
							}
						}
			          }
		     	   ]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('eia100skrvGrid1', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		flex	: 1.2,
		title	: 'Ⅰ.자본금 현황(주식의 총수)',
		uniOpt	:{
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: true,
			userToolbar :false
		},
		selModel: 'rowmodel',
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		tbar:     ['->',
					{
						xtype:'label',
						html:'<div style="color:#0033CC;font-weight: bold;font-size:11px">( '+'단위: 주 /원'+' )</div>'

					}
			  ],
		viewConfig: {
			/* getRowClass: function(record, rowIndex, rowParams, store){		//오류 row 빨간색 표시
				var cls = '';
				var val = record.get('DVRY_FOLLOW');
				//	하단 로직에서 사용중인 style class 는 현재 페이지 상단에 선언되어 있음.
				if (val == '초과') {
					cls = 'x-change-cell_DrvyOver';
				}
				else {
					if (val == '납품중' && masterGrid.fnGetDrvyArrivalYn(val))
						cls = 'x-change-cell_DrvySoon';
					else
						cls = '';
				}
				return cls;
			} */
		},
		columns: [
			{ dataIndex: 'COMP_CODE' 	, width: 66, hidden: true },
			{ dataIndex: 'GUBUN'     	, width: 150 },
			{ dataIndex: 'COL1'     	, width: 150 },
			{ dataIndex: 'COL2' 		, width: 150 },
			{ dataIndex: 'COL3'  		, width: 150 },
			{ dataIndex: 'COL4'      	, width: 150 },
			{ dataIndex: 'COL5'   		, width: 150, hidden: true },
			{ dataIndex: 'COL6'    		, width: 150 , hidden: true},

		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {

			}
		},
		fnGetDrvyArrivalYn: function(val) {
			var date = val.split(".");
			var drvyDate = new Date(Number(date[0]), Number(date[1]) - 1, Number(date[2]));

			date = UniDate.get('today').split(".");
			var today = new Date(Number(date[0]), Number(date[1]) - 1, Number(date[2]));

			var threeDaysAfterToday = today;
			threeDaysAfterToday.setDate(threeDaysAfterToday.getDate() + 3);

			if(drvyDate >= today && drvyDate <= threeDaysAfterToday) {
				return true;
			}
			return false;
		}
	});

	var detailGrid = Unilite.createGrid('eia100skrvGrid2', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		title	: 'Ⅱ.요약재무현황',
		flex	: 2,
		uniOpt	:{
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: true,
			userToolbar :false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		tbar:     ['->',
						{
							xtype:'label',
							html:'<div style="color:#0033CC;font-weight: bold;font-size:11px">( '+'단위: 백만원'+' )</div>'

						}
				  ],
		columns	: [
			{ dataIndex: 'COMP_NUM'    , width: 150 },
			{ dataIndex: 'COMP_NAME'    , width: 150 ,hidden:true},
			{ dataIndex: 'CLOSING_DATE' , width: 100 },
			{ dataIndex: 'TOTAL_ASSETS' , width: 120 },
			{ dataIndex: 'TOTAL_DEBT'   , width: 120 },
			{ dataIndex: 'TOTAL_CAPITAL', width: 120 },
			{ dataIndex: 'SALE_AMT'     , width: 120},
			{ dataIndex: 'BIZ_PROFIT'   , width: 120 },
			{ dataIndex: 'NET_PROFIT'   , width: 120 }

		]
	});






	Unilite.Main({
		id			: 'eia100skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				//panelResult,
				masterGrid,detailGrid
			]
		}/* ,
		panelSearch */
		],
		fnInitBinding : function() {

			UniAppManager.setToolbarButtons(['detail', 'reset'], false);

		},
		onQueryButtonDown : function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}

			masterGrid.getStore().loadStoreRecords();
			detailGrid.getStore().loadStoreRecords();;
		}
	});
};
</script>