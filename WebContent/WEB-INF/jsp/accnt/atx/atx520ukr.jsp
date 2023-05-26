<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx520ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

var resetButtonFlag = '';

function appMain() {
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	

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
		    items : [{ 
    			fieldLabel: '계산서일',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        startDD:'first',
		        endDD:'last',
		        allowBlank: false,
		        holdable:'hold',
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_PUB_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PUB_DATE',newValue);
			    	}
			    }
	        },{
				fieldLabel: '신고사업장', 
				name: 'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				}
			}/*,{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 120',                                                       
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
				}
	    	}*/]		
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});   
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '계산서일',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_PUB_DATE',
	        endFieldName: 'TO_PUB_DATE',
	        width: 470,
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
	        startDD:'first',
	        endDD:'last',
	        allowBlank: false,
	        holdable:'hold',
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_PUB_DATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_PUB_DATE',newValue);
		    	}
		    }
        },{
			fieldLabel: '신고사업장', 
			name: 'BILL_DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode	: 'BILL',
			allowBlank: false,
			holdable:'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			}
		}/*,{
    		xtype: 'button',
    		text: '출력',
    		width: 100,
    		margin: '0 0 0 120',                                                       
    		handler : function() {
				var me = this;
				panelSearch.getEl().mask('로딩중...','loading-indicator');
				var param = panelSearch.getValues();
			}
    	}*/],
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	}); 
	var sumTable = Unilite.createForm('detailForm', { //createForm
		padding:'0 0 0 0',
	    title:'2. 영세율 적용 공급실적 합계',
		//border: 0,
		disabled: false,
		flex: 1.5,
		bodyPadding: 10,
		
		region: 'center',
	    layout: {type: 'uniTable', columns: 4, 
			tableAttrs: {style: 'border : 1px solid #ced9e7;'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'},
			trAttrs: {style: 'height:29px;'}
		},
		tbar: [
		{
			xtype: 'toolbar',
	    	id:'temp5',
	    	margin: '0 0 0 0',
	    	width:200,
			border:false,
	    	layout: {
	    		type: 'hbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[
			{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 0',
	    		handler : function() {
	    			UniAppManager.app.onPrintButtonDown();
	    		}
	    	}]
		}],
		defaults:{width: 140},
	    items: [
	    		{ xtype:'uniTextfield',	name:'SAVE_FLAG_MASTER',	hidden:true	},
	    		
	    		{ xtype: 'component'		,	html: '(7)구분'			,	width: 100	},
	    		{ xtype: 'component'		,	html: '(8)조문'			,	width: 150	},
	    		{ xtype: 'component'		,	html: '(9)내용'			,	width: 800	},
	    		{ xtype: 'component'		,	html: '(10)금액(원)'						},
	    		
	    		{ xtype: 'component'		,	html: '부가가치세법'			,	rowspan:16	},
	    		{ xtype: 'component'		,	html: '제11조 제1항 제1호'		,	rowspan:5	},
	    		{ xtype: 'component'		,	html: '직접수출(대행수술 포함)'	,	width: 800			,	style: { textAlign:'left' }	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_11_01'	,	id: 'AMT_11_11_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '중계무역 · 위탁판매 · 외국인도 또는 위탁가공무역 방식의 수출'		,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_11_02'	,	id: 'AMT_11_11_02'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '내국신용장 · 구매확인서에 의하여 공급하는 재화'				,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_11_03'	,	id: 'AMT_11_11_03'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '한국국제협력단 및 한국국제보건의료재단에 공급하는 해외반출용 재화'		,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_11_04'	,	id: 'AMT_11_11_04'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '수탁가공무역 수출용으로 공급하는 재화'					,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_11_05'	,	id: 'AMT_11_11_05'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제11조 제1항 제2호'						},
	    		{ xtype: 'component'		,	html: '국외에서 제공하는 용역'							,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_12_01'	,	id: 'AMT_11_12_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제11조 제1항 제3호'		,	rowspan: 2	},
	    		{ xtype: 'component'		,	html: '선박 · 항공기에 의한 외국항행용역'						,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_13_01'	,	id: 'AMT_11_13_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '국제복합운송계약에 의한 외국항행용역'						,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_13_02'	,	id: 'AMT_11_13_02'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제11조 제1항 제4호'		,	rowspan: 8	},
	    		{ xtype: 'component'		,	html: '국내에서 비거주자 · 외국법인에게 공급되는 재화 또는 용역'			,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_14_01'	,	id: 'AMT_11_14_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '수출재화임가공용역'								,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_14_02'	,	id: 'AMT_11_14_02'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '외국항행 선박 · 항공기 등에 공급하는 재화 또 는 용역'			,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_14_03'	,	id: 'AMT_11_14_03'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '국내 주재 외교공관, 영사기광, 국제연합과 이에 준하는 국제기구, 국제연합군 또는 미국군에게 공급하는 재화 또는 용역'	,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_14_04'	,	id: 'AMT_11_14_04'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '관광진흥법 에 따른 일반여행업자 또는 외국인전용 관광기념품 판매업자가 외국인광관객에게 공급하는 관광알선용역 또는 관광기념품'	,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_14_05'	,	id: 'AMT_11_14_05'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '외국인전용판매장 또는 주한외국군인 등의 전용 유흥음식점에서 공급하는 재화 또는 용역'						,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_14_06'	,	id: 'AMT_11_14_06'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '외교관 등에게 공급하는 재화 또는 용역'						,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_14_07'	,	id: 'AMT_11_14_07'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '외국인환자 유치용역'								,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_14_08'	,	id: 'AMT_11_14_08'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '(11)부가가치세법에 따른 영세율 적용 공급실적 합계'			,	width: '100%'	,	colspan: 3	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_TOT'		,	id: 'AMT_11_TOT'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '조세특례제한법'			,	rowspan: 9	},
	    		{ xtype: 'component'		,	html: '제105조 제1항 제1호'					},
	    		{ xtype: 'component'		,	html: '방위산업물자 및 비상대비자원관리'						,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_105_11_01'	,	id: 'AMT_105_11_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제105조 제1항 제2호'					},
	    		{ xtype: 'component'		,	html: '군부대 등에 공급하는 석유류'							,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_105_11_02'	,	id: 'AMT_105_11_02'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제105조 제1항 제3호'					},
	    		{ xtype: 'component'		,	html: '도시철도건설용역'								,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_105_13_01'	,	id: 'AMT_105_13_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제105조 제1항 제3호의 2'					},
	    		{ xtype: 'component'		,	html: '국가 · 지방자치단체에 공급하는 사회기반시설 등'				,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_105_13_02'	,	id: 'AMT_105_13_02'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제105조 제1항 제4호'					},
	    		{ xtype: 'component'		,	html: '장애인용 보장구 및 장애인용 정보통신기기 등'					,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_105_14_01'	,	id: 'AMT_105_14_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제105조 제1항 제5호 '					},
	    		{ xtype: 'component'		,	html: '농민 또는 임업종사자에게 공급하는 농업용 · 축산업용 · 임업용 기자재'	,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_105_15_01'	,	id: 'AMT_105_15_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제105조 제1항 제6호'					},
	    		{ xtype: 'component'		,	html: '어민에게 공급하는 어업용 기자재'						,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_105_16_01'	,	id: 'AMT_105_16_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제107조'							},
	    		{ xtype: 'component'		,	html: '외국인관광객 등에게 공급하는 재화'						,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_107_11_01'	,	id: 'AMT_107_11_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '제121조의 13'						},
	    		{ xtype: 'component'		,	html: '제주특별자치도 면세품판매장에서 판매하거나 제주 특별자치도 명세품판매장에 공급하는 물품'						,	style: { textAlign: 'left' }	,	width: 800	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_121_13_01'	,	id: 'AMT_121_13_01'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '(12)조세특례제한법 및 그 밖의 법률에 따른 영세율 적용 공급실적 합계'	,	width: '100%'	,	colspan: 3	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_12_TOT'		,	id: 'AMT_12_TOT'	,	value:0	,	readOnly: true	},
	    		
	    		{ xtype: 'component'		,	html: '(13)영세율 적용 공급실적 총 합계(11)+(12)'			,	width: '100%'	,	colspan: 3	},
	    		{ xtype: 'uniNumberfield'	,	name: 'AMT_11_12_TOT'	,	id: 'AMT_11_12_TOT'	,	value:0	,	readOnly: true	}
	    ],
		api: {
	 		load: 'atx520ukrService.selectForm'	,
	 		submit: 'atx520ukrService.syncMaster'	
		}
	});
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			items:[
				sumTable, panelResult
			]	
		},
			panelSearch
		],
		id  : 'atx520ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData','reset'],false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_PUB_DATE');
			this.setDefault();
		},
		onPrintButtonDown: function(type) {
			var param = panelSearch.getValues();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/atx/atx520ukrPrint.do',
				prgID: 'atx520ukr',
					extParam: param
				});
			win.center();
			win.show();   				
		},
		onQueryButtonDown : function()	{	
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				sumTable.mask('loading...');
				var param= panelSearch.getValues();
				param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
				param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
				sumTable.getForm().load({
					params: param,
					success: function(form, action) {
						sumTable.unmask();
						UniAppManager.app.readOnlyBool(false);
						UniAppManager.setToolbarButtons('delete',true);
						sumTable.setValue('SAVE_FLAG_MASTER','U');
					},
					failure: function(form, action) {
						sumTable.setValue('SAVE_FLAG_MASTER','N');
						UniAppManager.app.readOnlyBool(false);
						sumTable.unmask();
					}
				});
				UniAppManager.setToolbarButtons('reset',true);
				panelResult.setAllFieldsReadOnly(true);
				
			}
		},
		onResetButtonDown: function() {	
			resetButtonFlag = 'Y';
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
//			panelSearch.clearForm();
//			panelResult.clearForm();
			sumTable.clearForm();
			UniAppManager.app.readOnlyBool(true);
			sumTable.setValue('SAVE_FLAG_MASTER','');
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('delete',false);
		},
		onSaveDataButtonDown: function() {				
			var param= sumTable.getValues();
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			param.BILL_DIV_CODE = panelSearch.getValue("BILL_DIV_CODE");
			
			sumTable.getForm().submit({
			params : param,
				success : function(form, action) {
	 				sumTable.getForm().wasDirty = false;
					sumTable.resetDirtyStatus();											
					UniAppManager.setToolbarButtons('save', false);	
	            	UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
	            	UniAppManager.app.onQueryButtonDown();
				}	
			});
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				sumTable.clearForm();
				UniAppManager.app.readOnlyBool(true);
//				panelSearch.setAllFieldsReadOnly(false);
//				panelResult.setAllFieldsReadOnly(false);
				UniAppManager.setToolbarButtons('delete',false);
				UniAppManager.setToolbarButtons('save',true);
				sumTable.setValue('SAVE_FLAG_MASTER','D');
				UniAppManager.app.setSumTableDefaultValue();
			}
		},
		setDefault: function() {
			if(resetButtonFlag != 'Y'){
		    	panelSearch.setValue('FR_PUB_DATE',UniDate.get('today'));
		    	panelSearch.setValue('TO_PUB_DATE',UniDate.get('today'));
		    	panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
		    	panelResult.setValue('FR_PUB_DATE',UniDate.get('today'));
		    	panelResult.setValue('TO_PUB_DATE',UniDate.get('today'));
		    	panelResult.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			}
        	UniAppManager.app.setSumTableDefaultValue();
        	       	
		},
		setSumTableDefaultValue:function() {
			sumTable.setValue('AMT_11_11_01',0);
        	sumTable.setValue('AMT_11_11_02',0);
        	sumTable.setValue('AMT_11_11_03',0);
        	sumTable.setValue('AMT_11_11_04',0);
        	sumTable.setValue('AMT_11_11_05',0);
        	sumTable.setValue('AMT_11_12_01',0);
        	sumTable.setValue('AMT_11_13_01',0);
        	sumTable.setValue('AMT_11_13_02',0);
        	sumTable.setValue('AMT_11_14_01',0);
        	sumTable.setValue('AMT_11_14_02',0);
        	sumTable.setValue('AMT_11_14_03',0);
        	sumTable.setValue('AMT_11_14_04',0);
        	sumTable.setValue('AMT_11_14_05',0);
        	sumTable.setValue('AMT_11_14_06',0);
        	sumTable.setValue('AMT_11_14_07',0);
        	sumTable.setValue('AMT_11_14_08',0);
        	sumTable.setValue('AMT_11_TOT',0);
        	sumTable.setValue('AMT_105_11_01',0);
        	sumTable.setValue('AMT_105_11_02',0);
        	sumTable.setValue('AMT_105_13_01',0);
        	sumTable.setValue('AMT_105_13_02',0);
        	sumTable.setValue('AMT_105_14_01',0);
        	sumTable.setValue('AMT_105_15_01',0);
        	sumTable.setValue('AMT_105_16_01',0);
        	sumTable.setValue('AMT_107_11_01',0);
        	sumTable.setValue('AMT_121_13_01',0);
        	sumTable.setValue('AMT_12_TOT',0);
        	sumTable.setValue('AMT_11_12_TOT',0);
		},
		setSumTableValue:function() {
			sumTable.setValue('AMT_11_TOT',
				sumTable.getValue('AMT_11_11_01') + sumTable.getValue('AMT_11_11_02') + sumTable.getValue('AMT_11_11_03') + sumTable.getValue('AMT_11_11_04') +
				sumTable.getValue('AMT_11_11_05') + sumTable.getValue('AMT_11_12_01') + sumTable.getValue('AMT_11_13_01') + sumTable.getValue('AMT_11_13_02') +
				sumTable.getValue('AMT_11_14_01') + sumTable.getValue('AMT_11_14_02') + sumTable.getValue('AMT_11_14_03') + sumTable.getValue('AMT_11_14_04') +
				sumTable.getValue('AMT_11_14_05') + sumTable.getValue('AMT_11_14_06') + sumTable.getValue('AMT_11_14_07') + sumTable.getValue('AMT_11_14_08')
			);
			sumTable.setValue('AMT_12_TOT',
				sumTable.getValue('AMT_105_11_01') + sumTable.getValue('AMT_105_11_02') + sumTable.getValue('AMT_105_13_01') + sumTable.getValue('AMT_105_13_02') + sumTable.getValue('AMT_105_14_01') +
				sumTable.getValue('AMT_105_15_01') + sumTable.getValue('AMT_105_16_01') + sumTable.getValue('AMT_107_11_01') + sumTable.getValue('AMT_121_13_01')
			);
			sumTable.setValue('AMT_11_12_TOT',sumTable.getValue('AMT_11_TOT') + sumTable.getValue('AMT_12_TOT'));
		},
		readOnlyBool:function(boolean){
			if(boolean == true){
				Ext.getCmp('AMT_11_11_01').setReadOnly(true);
				Ext.getCmp('AMT_11_11_02').setReadOnly(true);
				Ext.getCmp('AMT_11_11_03').setReadOnly(true);
				Ext.getCmp('AMT_11_11_04').setReadOnly(true);
				Ext.getCmp('AMT_11_11_05').setReadOnly(true);
				Ext.getCmp('AMT_11_12_01').setReadOnly(true);
				Ext.getCmp('AMT_11_13_01').setReadOnly(true);
				Ext.getCmp('AMT_11_13_02').setReadOnly(true);
				Ext.getCmp('AMT_11_14_01').setReadOnly(true);
				Ext.getCmp('AMT_11_14_02').setReadOnly(true);
				Ext.getCmp('AMT_11_14_03').setReadOnly(true);
				Ext.getCmp('AMT_11_14_04').setReadOnly(true);
				Ext.getCmp('AMT_11_14_05').setReadOnly(true);
				Ext.getCmp('AMT_11_14_06').setReadOnly(true);
				Ext.getCmp('AMT_11_14_07').setReadOnly(true);
				Ext.getCmp('AMT_11_14_08').setReadOnly(true);
				Ext.getCmp('AMT_105_11_01').setReadOnly(true);
				Ext.getCmp('AMT_105_11_02').setReadOnly(true);
				Ext.getCmp('AMT_105_13_01').setReadOnly(true);
				Ext.getCmp('AMT_105_13_02').setReadOnly(true);
				Ext.getCmp('AMT_105_14_01').setReadOnly(true);
				Ext.getCmp('AMT_105_15_01').setReadOnly(true);
				Ext.getCmp('AMT_105_16_01').setReadOnly(true);
				Ext.getCmp('AMT_107_11_01').setReadOnly(true);
				Ext.getCmp('AMT_121_13_01').setReadOnly(true);
				
				Ext.getCmp('AMT_11_TOT').setReadOnly(true);
				Ext.getCmp('AMT_12_TOT').setReadOnly(true);
				Ext.getCmp('AMT_11_12_TOT').setReadOnly(true);
			}else{
				Ext.getCmp('AMT_11_11_01').setReadOnly(false);
				Ext.getCmp('AMT_11_11_02').setReadOnly(false);
				Ext.getCmp('AMT_11_11_03').setReadOnly(false);
				Ext.getCmp('AMT_11_11_04').setReadOnly(false);
				Ext.getCmp('AMT_11_11_05').setReadOnly(false);
				Ext.getCmp('AMT_11_12_01').setReadOnly(false);
				Ext.getCmp('AMT_11_13_01').setReadOnly(false);
				Ext.getCmp('AMT_11_13_02').setReadOnly(false);
				Ext.getCmp('AMT_11_14_01').setReadOnly(false);
				Ext.getCmp('AMT_11_14_02').setReadOnly(false);
				Ext.getCmp('AMT_11_14_03').setReadOnly(false);
				Ext.getCmp('AMT_11_14_04').setReadOnly(false);
				Ext.getCmp('AMT_11_14_05').setReadOnly(false);
				Ext.getCmp('AMT_11_14_06').setReadOnly(false);
				Ext.getCmp('AMT_11_14_07').setReadOnly(false);
				Ext.getCmp('AMT_11_14_08').setReadOnly(false);
				Ext.getCmp('AMT_105_11_01').setReadOnly(false);
				Ext.getCmp('AMT_105_11_02').setReadOnly(false);
				Ext.getCmp('AMT_105_13_01').setReadOnly(false);
				Ext.getCmp('AMT_105_13_02').setReadOnly(false);
				Ext.getCmp('AMT_105_14_01').setReadOnly(false);
				Ext.getCmp('AMT_105_15_01').setReadOnly(false);
				Ext.getCmp('AMT_105_16_01').setReadOnly(false);
				Ext.getCmp('AMT_107_11_01').setReadOnly(false);
				Ext.getCmp('AMT_121_13_01').setReadOnly(false);
				
				Ext.getCmp('AMT_11_TOT').setReadOnly(true);
				Ext.getCmp('AMT_12_TOT').setReadOnly(true);
				Ext.getCmp('AMT_11_12_TOT').setReadOnly(true);
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	Unilite.createValidator('validator01', {
		forms: {'formA:':sumTable},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					UniAppManager.app.setSumTableValue();
					UniAppManager.setToolbarButtons('save',true);
//					if(sumTable.getValue('SAVE_FLAG_MASTER')=='D'){
//						sumTable.setValue('SAVE_FLAG_MASTER','U');
//					}
					break;
			}
			return rv;
		}
	});
};


</script>
