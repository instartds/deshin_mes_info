<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_afn100skr_kd">
    <t:ExtComboStore comboType="BOR120"	/>				<!-- 사업장-->
    <t:ExtComboStore comboType="AU" comboCode="B004" />	<!--화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="A089" />	<!--화폐단위-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

</style>    

<script type="text/javascript" >

function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('S_afn100skr_kdModel', {
		fields: [
			{name: 'COMP_CODE'				, text: '법인코드'				, type: 'string'},
			{name: 'NOTE_STS_NAME'			, text: '어음상태'				, type: 'string'},
			{name: 'AC_CD'					, text: '어음구분'				, type: 'string'},
			{name: 'AC_NM'					, text: '어음구분'				, type: 'string'},
			{name: 'NOTE_NUM'				, text: '어음번호'				, type: 'string'},
			{name: 'PUB_DATE'				, text: '발행일자'				, type: 'string'},
			{name: 'EXP_DATE'				, text: '만기일자'				, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '거래처'				, type: 'string'},            
			{name: 'CUSTOM_NAME'			, text: '거래처명'				, type: 'string'},
			{name: 'PUB_MAN'				, text: '발행인'				, type: 'string'},
			{name: 'OC_AMT_I'				, text: '발생금액'				, type: 'uniPrice'},
			{name: 'BANK_CODE'				, text: '은행코드'				, type: 'string'},
			{name: 'BANK_NAME'				, text: '은행명'				, type: 'string'},
			{name: 'RECEIPT_DIVI'			, text: '수취구분'				, type: 'string'},
			{name: 'RECEIPT_DIVI_NAME'		, text: '수취구분'				, type: 'string'},
			{name: 'NOTE_KEEP'				, text: '보관장소'				, type: 'string'},
			{name: 'NOTE_KEEP_NAME'			, text: '보관장소'				, type: 'string'},
			{name: 'ACCNT'					, text: '계정코드'				, type: 'string'},
			{name: 'ACCNT_NAME'				, text: '계정명'				, type: 'string'},
			{name: 'AC_DATE'				, text: '전표일자'				, type: 'string'},
			{name: 'SLIP_NUM'				, text: '전표번호'				, type: 'string'},
			{name: 'SLIP_SEQ'				, text: '순번'				, type: 'string'},
			{name: 'J_DATE'					, text: '전표일자'				, type: 'string'},
			{name: 'J_NUM'					, text: '전표번호'				, type: 'string'},
			{name: 'J_SEQ'					, text: '순번'				, type: 'string'},
			{name: 'NOTE_STS'				, text: '어음상태(현)'			, type: 'string'},
			{name: 'NOTE_STS_NAME_NOW'		, text: '어음상태(현)'			, type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */                 
	var masterStore = Unilite.createStore('s_afn100skr_kdStore',{
		model: 'S_afn100skr_kdModel',
		uniOpt : {
			isMaster : true,		// 상위 버튼 연결 
			editable : false,		// 수정 모드 사용 
			deletable: false,		// 삭제 가능 여부 
			useNavi	 : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		groupField: 'NOTE_STS_NAME',
		proxy: {
			type: 'direct',
			api: {			
				read	: 's_afn100skr_kdService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('searchForm').getValues();
			param.IS_EXPIRED = Ext.getCmp('searchForm').getValue('IS_EXPIRED');
			
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
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
			title: '기본정보', 	
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '기준일자', 
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				name: 'PUB_DATE',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PUB_DATE', newValue);
					}
				}
			},
			Unilite.popup('CUST',{ 
				fieldLabel: '거래처', 
				popupWidth: 710,
				autoPopup: true ,
				colspan:3,
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					},
					applyextparam: function(popup){							
						//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onTextSpecialKey: function(elm, e){
						if (e.getKey() == e.ENTER) {
							UniAppManager.app.onQueryButtonDown();  
						}
					}
				}
			})
			,{
				fieldLabel: '',
				name: 'IS_EXPIRED',
				xtype: 'checkbox',
				//labelWidth: 200,
				width: 200,
				boxLabel: '&nbsp;미결제 어음만 조회',
				padding: '0 0 0 95',
				value: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.setValue('IS_EXPIRED', newValue);
					}
				}
			}
			]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '기준일자', 
			xtype: 'uniDatefield',
			value: UniDate.get('today'),
			name: 'PUB_DATE',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PUB_DATE', newValue);
				}
			}
		},
		Unilite.popup('CUST',{ 
			fieldLabel: '거래처', 
			popupWidth: 710,
			autoPopup: true ,
			colspan:3,
			valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){							
					//popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				},
				onTextSpecialKey: function(elm, e){
					if (e.getKey() == e.ENTER) {
						UniAppManager.app.onQueryButtonDown();  
					}
				}
			}
		})
//		,{
//			fieldLabel: '',
//			name: 'IS_EXPIRED',
//			xtype: 'checkbox',
//			labelWidth: 200,
//			boxLabel: '&nbsp;만기일 초과 어음만 조회',
//			listeners: {
//				change: function(field, newValue, oldValue, eOpts) {						
//					panelSearch.setValue('IS_EXPIRED', newValue);
//				}
//			}
//		}
		]
	});

	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_afd660skr_kdGrid1', {
		// for tab      
		region:'center',
		store : masterStore, 
		excelTitle: '자산변동내역조회',
		uniOpt: {
			useMultipleSorting  : true,
			useLiveSearch       : true,
			onLoadSelectFirst   : true,
			dblClickToEdit      : false,
			useGroupSummary     : true,
			useContextMenu      : false,
			useRowNumberer      : true,
			expandLastColumn    : true,
			useRowContext       : false,
			filter: {
				useFilter       : true,
				autoCreate      : true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false} ,
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns:  [
			{ dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{ dataIndex: 'NOTE_STS_NAME'		, width: 100	, align: 'center'},
			{ dataIndex: 'AC_CD'				, width: 100	, hidden: true},
			{ dataIndex: 'AC_NM'				, width: 100	, align: 'center'},
			{ dataIndex: 'NOTE_NUM'				, width: 100	},
			{ dataIndex: 'PUB_DATE'				, width:  90	, align: 'center'},
			{ dataIndex: 'EXP_DATE'				, width:  90	, align: 'center'},
			{ dataIndex: 'CUSTOM_CODE'			, width:  80	, align: 'center'},
			{ dataIndex: 'CUSTOM_NAME'			, width: 150	},
			{ dataIndex: 'PUB_MAN'				, width: 100	},
			{ dataIndex: 'OC_AMT_I'				, width: 130	},
			{ dataIndex: 'BANK_CODE'			, width:  80	, hidden: true},
			{ dataIndex: 'BANK_NAME'			, width: 150	},
			{ dataIndex: 'RECEIPT_DIVI'			, width: 100	, hidden: true},
			{ dataIndex: 'RECEIPT_DIVI_NAME'	, width:  80	},
			{ dataIndex: 'NOTE_KEEP'			, width: 100	, hidden: true},
			{ dataIndex: 'NOTE_KEEP_NAME'		, width:  80	},
			{ dataIndex: 'ACCNT'				, width: 100	, hidden: true},
			{ dataIndex: 'ACCNT_NAME'			, width: 100	, hidden: true},
			{ dataIndex: 'AC_DATE'				, width: 100	, hidden: true},
			{ dataIndex: 'SLIP_NUM'				, width: 100	, hidden: true},
			{ dataIndex: 'SLIP_SEQ'				, width: 100	, hidden: true},
			{ dataIndex: 'J_DATE'				, width: 100	, hidden: true},
			{ dataIndex: 'J_NUM'				, width: 100	, hidden: true},
			{ dataIndex: 'J_SEQ'				, width: 100	, hidden: true},
			{ dataIndex: 'NOTE_STS'				, width: 100	, hidden: true},
			{ dataIndex: 'NOTE_STS_NAME_NOW'	, width: 100	, hidden: true}
		],
		listeners: {
			itemmouseenter:function(view, record, item, index, e, eOpts )   {               
			}
		}
	});
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}
			, panelSearch
		],  
		id  : 's_afn100skr_kdApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown : function()  {
			if(!this.isValidSearchForm()){
				return false;
			}
			else {
				masterGrid.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			//masterGrid.reset();
			this.fnInitBinding();
		}
	});
};

</script>
