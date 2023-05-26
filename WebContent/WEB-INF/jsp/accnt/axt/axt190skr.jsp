<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="axt190ukr">
    <t:ExtComboStore comboType="BOR120"	/>			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {

	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('axt190ukrModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '법인코드'				, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장코드'				, type: 'string'},
			{name: 'IN_DATE'		, text: '수금일자'				, type: 'string'},
			{name: 'AC_DATE'		, text: '전표일자'				, type: 'string'},
			{name: 'SLIP_NUM'		, text: '전표번호'				, type: 'string'},
			{name: 'SLIP_SEQ'		, text: '전표순번'				, type: 'string'},
			{name: 'ACCNT'			, text: '계정코드'				, type: 'string'},
			{name: 'CUSTOM_CODE'	, text: '거래처'				, type: 'string'},
			{name: 'CUSTOM_NAME'	, text: '거래처명'				, type: 'string'},
			{name: 'INCOME_TYPE'	, text: '거래구분'				, type: 'string'},
			{name: 'NOTE_NO'		, text: '어음번호'				, type: 'string'},
			{name: 'BANK_CODE'		, text: '지급은행'				, type: 'string'},
			{name: 'BANK_NAME'		, text: '지급은행'				, type: 'string'},
			{name: 'EXP_DATE'		, text: '만기일자'				, type: 'string'},
			{name: 'REMARK2'		, text: '적요'				, type: 'string'},
			{name: 'CASH_I'			, text: '현금'				, type: 'uniPrice'},
			{name: 'NOTE_I'			, text: '어음'				, type: 'uniPrice'},
			{name: 'AMT_I'			, text: '함계'				, type: 'uniPrice'},
			{name: 'REMARK'			, text: '비고'				, type: 'string'}
		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'axt190ukrService.selectList'
		}
	});
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */
	var directMasterStore = Unilite.createStore('axt190ukrMasterStore1',{
		model   : 'axt190ukrModel',
		uniOpt  : {
			isMaster    : true,				// 상위 버튼 연결
			editable    : false,			// 수정 모드 사용
			deletable   : false,			// 삭제 가능 여부
			useNavi     : false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'axt190skrService.selectList'
			}
		},
		groupField: 'CUSTOM_CODE',
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title: '기본정보', 	
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: false, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '전표일',
				xtype: 'uniDateRangefield',
				startFieldName: 'AC_DATE_FR',
				endFieldName: 'AC_DATE_TO',
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('AC_DATE_FR', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('AC_DATE_TO', newValue);
					}
				}
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			multiSelect: false,
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',
			startFieldName: 'AC_DATE_FR',
			endFieldName: 'AC_DATE_TO',
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('AC_DATE_TO', newValue);
				}
			}
		},{
			xtype:'button',
			text:'출    력',
			width:100,
			tdAttrs:{'align':'center', style:'padding-left:95px'},
			handler:function()	{
				UniAppManager.app.onPrintButtonDown();
			}
		}]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('axt190skrGrid', {
		layout : 'fit',
		region : 'center',
		uniOpt : {	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,
			onLoadSelectFirst	: true,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		store: directMasterStore,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true 
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		selModel:'rowmodel',
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden : true	},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden : true	},
			{dataIndex: 'IN_DATE'			, width: 100	, hidden : true	},
//			{dataIndex: 'AC_DATE'			, width: 100	, hidden : true	},
//			{dataIndex: 'SLIP_NUM'			, width: 100	, hidden : true	},
//			{dataIndex: 'SLIP_SEQ'			, width: 100	, hidden : true	},
//			{dataIndex: 'ACCNT'				, width: 100	, hidden : true	},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	, align : 'center'	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'CUSTOM_NAME'		, width: 200	},
			{dataIndex: 'INCOME_TYPE'		, width: 130	},
			{dataIndex: 'NOTE_NO'			, width: 130	},
			{dataIndex: 'BANK_CODE'			, width: 130	, hidden: true	},
			{dataIndex: 'BANK_NAME'			, width: 200	},
			{dataIndex: 'EXP_DATE'			, width:  90	, align: 'center'	},
			{dataIndex: 'REMARK2'			, width: 130	},
			{dataIndex: 'CASH_I'			, width: 130	, summaryType: 'sum'	},
			{dataIndex: 'NOTE_I'			, width: 130	, summaryType: 'sum'	},
			{dataIndex: 'AMT_I'				, width: 130	, summaryType: 'sum'	},
			{dataIndex: 'REMARK'			, width: 130	}
		]
	});
	
	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id : 'axt190skrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail'], false);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('AC_DATE_FR',UniDate.get('today'));
			panelResult.setValue('AC_DATE_FR',UniDate.get('today'));
			
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('AC_DATE_TO',UniDate.get('today'));
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}
			else {
				directMasterStore.loadStoreRecords();
			}
		},
		onPrintButtonDown: function() {
			
			if(!panelSearch.getInvalidMessage()) return;
			var param = panelSearch.getValues();
			
			param.PGM_ID = 'axt190skr';		//프로그램ID
			param.MAIN_CODE = 'A126';		//해당 모듈의 출력정보를 가지고 있는 공통코드
			param.sTxtValue2_fileTitle = '##  영  업  일  보  ##';
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/accnt/axt190clrkrv.do',
				prgID: 'axt190skr',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>
