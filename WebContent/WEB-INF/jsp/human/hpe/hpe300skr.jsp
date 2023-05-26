<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="hpe300skr">
	<t:ExtComboStore comboType="BOR120"  pgmId="hpe300skr"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"  comboCode="H118"/> 				<!-- 내외국인여부 -->
	<t:ExtComboStore comboType="AU"  comboCode="HS06"/> 				<!-- 소득구분코드 -->
</t:appConfig>
<style>
.x-grid-cell-essential {background-color:yellow;}
</style>

<script type="text/javascript" >
function appMain() {

	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('hpe300skrMasterModel', {
		fields: [
			{name: 'COMP_CODE'				,text:'법인코드'			,type : 'string'},
			{name: 'YEAR_YYYY'				,text:'정산년도'			,type : 'string'},
			{name: 'HALF_YEAR'				,text:'반기구분'			,type : 'string'},
			{name: 'PERSON_NUMB'			,text:'소득자코드'			,type : 'string'},
			{name: 'NAME'					,text:'7.소득자성명(상호)'		,type : 'string'},
			{name: 'FOREIGN_YN'				,text:'내외국인구분'			,type : 'string'},
			{name: 'REPRE_NUM'				,text:'8.주민(사업자)등록번호'	,type : 'string'},
			{name: 'PAY_AMOUNT_I'			,text:'15.지급총액'			,type : 'uniPrice'},
			{name: 'DED_CODE'				,text:'6.소득구분코드'		,type : 'string'},
			{name: 'DED_NAME'				,text:'소득구분명'			,type : 'string'},
			{name: 'ADDR'					,text:'9.소득자의 주소'		,type : 'string'},
			{name: 'DWELLING_CODE'			,text:'11.거주구분'			,type : 'string'},
			{name: 'DWELLING_NAME'			,text:'거주국가'			,type : 'string'},
			{name: 'SUPP_YEAR'				,text:'13.지급연도'			,type : 'string'},
			{name: 'PAY_YEAR'				,text:'귀속연도'			,type : 'string'}
		]
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
				fieldLabel: '정산년도',
				xtype: 'uniYearField',
				name: 'YEAR_YYYY',
				allowBlank:false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('YEAR_YYYY', newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '반기구분',
				id:'rdoHalfYearS',
				holdable: 'hold',
				items: [{
					boxLabel: '상반기',
					width: 70,
					name: 'HALF_YEAR',
					inputValue: '1'
				},{
					boxLabel : '하반기',
					width: 70,
					name: 'HALF_YEAR',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {					
						panelResult.getField('HALF_YEAR').setValue(newValue.HALF_YEAR);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
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
						labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText + Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;       
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if(item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm', {
		region : 'north',
		layout : {type : 'uniTable', columns : 3},
		padding: '1 1 1 1',
		border : true,
		hidden : !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '정산년도',
			xtype: 'uniYearField',
			name: 'YEAR_YYYY',
			allowBlank:false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('YEAR_YYYY', newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '반기구분',
			id:'rdoHalfYearR',
			holdable: 'hold',
			items: [{
				boxLabel: '상반기',
				width: 70,
				name: 'HALF_YEAR',
				inputValue: '1'
			},{
				boxLabel : '하반기',
				width: 70,
				name: 'HALF_YEAR',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {					
					panelSearch.getField('HALF_YEAR').setValue(newValue.HALF_YEAR);
				}
			}
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
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
						labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText + Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField') ;       
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if(item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var panelInfo = Unilite.createSimpleForm('panelInfo', {
		region : 'north',
		layout : {type : 'uniTable', columns : 2,
			tableAttrs:{style: 'border : 0px solid #99bce8; padding: 5px 5px 8px 30px; color:blue; font-weight:bold;'}//,
			//trAttrs:{style:'height:25px;'}
		},
		padding: '0 0 1 0',
		border : true,
		//width: 700,
		items:[{
	  	 		xtype: 'component',
	  	 		html: '* 주의사항 : 영문성명, 영문법인명, 영문주소는 사업기타소득관리 > 사업소득자등록 프로그램의 주의사항을 참고하여 주시기 바랍니다.',
	  	 		colspan:2
//	  	 	},{
//	  	 		xtype: 'component',
//	  	 		html: '영문성명, 영문법인명, 영문주소는 사업소득자등록의 주의사항을 참고하여 주시기 바랍니다.',
//	  	 		width: 500
//	  	 	},{
//	  	 		xtype: 'component',
//	  	 		html: '1. 영문성명은 여권상의 영문 성명 전부를 기재하십시오.',
//	  	 		width: 500
//	  	 	},{
//	  	 		xtype: 'component',
//	  	 		html: '3. 영문 주소는 번지(number), 거리(street), 시(city), 도(state), 우편번호(postal zone), 국가(country) 순으로 기재해 주십시오.'
//	  	 	},{
//	  	 		xtype: 'component',
//	  	 		html: '2. 영문 법인명은 정식명칭 전부를 기재하십시오.',
//	  	 		colspan:2
	  	 	}]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('hpe300skrMasterStore', {
		model: 'hpe300skrMasterModel',
		uniOpt: {
			isMaster : true,		// 상위 버튼 연결
			editable : false,		// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi  : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'uniDirect',
			api: {
				read   : 'hpe300skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load: function(store) {
				if (store.getCount() < 1) {
					masterGrid.reset();
				}
			}
		}
	});

	/**
	 * Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('hpe300skrMasterGrid', {
		layout	: 'fit',
		region	: 'center',
		title	: '지급명세서',
		flex	: 1,
		store	: directMasterStore,
		uniOpt: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			state: {
				useState	: false,
				useStateList: false
			}
		},
		selModel: 'rowmodel',
		features: [	{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'YEAR_YYYY'				, width: 100	, hidden: true},
			{dataIndex: 'HALF_YEAR'				, width: 100	, hidden: true},
			{dataIndex: 'PERSON_NUMB'			, width: 80		, align: 'center'	,
				summaryRenderer: function(value, summaryData, dataIndex, metaData ) 
				{
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'NAME'					, width: 180	},
			{dataIndex: 'FOREIGN_YN'			, width: 100	, align: 'center'},
			{dataIndex: 'REPRE_NUM'				, width: 150	, align: 'center',
				renderer: function(value, meta, record) {
				 	if(Ext.isEmpty(value)) {
				 		meta.tdCls = 'x-grid-cell-essential';
				 	}
				 	return value;
				}
			},
			{dataIndex: 'PAY_AMOUNT_I'			, width: 120	, summaryType: 'sum'},
			{dataIndex: 'DED_CODE'				, width: 100	, align: 'center'},
			{dataIndex: 'DED_NAME'				, width: 90		},
			{dataIndex: 'ADDR'					, width: 350	,
				renderer: function(value, meta, record) {
				 	if(Ext.isEmpty(value)) {
				 		meta.tdCls = 'x-grid-cell-essential';
				 	}
				 	return value;
				}
			},
			{dataIndex: 'DWELLING_CODE'			, width: 100	, align: 'center'},
			{dataIndex: 'DWELLING_NAME'			, width: 130	},
			{dataIndex: 'SUPP_YEAR'				, width: 80		, align: 'center'},
			{dataIndex: 'PAY_YEAR'				, width: 80		, align: 'center'}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				
			},
			selectionchangerecord : function( record ) {
				
			}
		}
	});

	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult, panelInfo
			]},
			panelSearch
		],
		id : 'hpe300skrApp',
		fnInitBinding : function() {
//			var activeSForm;
//			
//			if(!UserInfo.appOption.collapseLeftSearch) {
//				activeSForm = panelSearch;
//			} else {
//				activeSForm = panelResult;
//			}
//			//activeSForm.onLoadSelectText('YEAR_YYYY');
			
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			var month = Ext.Date.format(UniDate.add(UniDate.today(),{'months':-1} ),'n');
			var halfYear = "1";
			if(month > 6)	{
				halfYear="2";
			}
			panelSearch.getField('HALF_YEAR').setValue(halfYear);
			panelResult.getField('HALF_YEAR').setValue(halfYear);
			
			panelSearch.setValue('YEAR_YYYY', UniDate.add(UniDate.today(),{'months':-1} ).getFullYear());
			panelResult.setValue('YEAR_YYYY', UniDate.add(UniDate.today(),{'months':-1} ).getFullYear());
			
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			
			panelSearch.clearForm();
			panelResult.clearForm();
			
			this.fnInitBinding();
		},
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
			
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		}
	});
}
</script>