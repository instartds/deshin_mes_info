<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx460ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

var getTaxBase = '${getTaxBase}';
var getAppNum = '${getAppNum}';
var getCompanyNum = '${getCompanyNum}';
var gsReportGubun = '${gsReportGubun}';

//var referenceSaveFlag ='';

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx460ukrService.selectList',
			update: 'atx460ukrService.updateDetail',
			create: 'atx460ukrService.insertDetail',
			destroy: 'atx460ukrService.deleteDetail',
			syncAll: 'atx460ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Atx460ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'			,text: '법인코드' 				,type: 'string',allowBlank:false},
	    	{name: 'FR_PUB_DATE'		,text: '신고기간FR' 			,type: 'string',allowBlank:false},
	    	{name: 'TO_PUB_DATE'		,text: '신고기간TO' 			,type: 'string',allowBlank:false},
	    	{name: 'SEQ'			   	,text: '순번' 				,type: 'int',allowBlank:false},
	    	{name: 'APP_NUM'			,text: '승인번호' 				,type: 'string',allowBlank:false},
	    	{name: 'CUSTOM_NAME'		,text: '사업장명' 				,type: 'string',allowBlank:false},
	    	{name: 'ADDR'			   	,text: '사업장 소재지' 			,type: 'string',allowBlank:false},
	    	{name: 'AMT_1'			   	,text: '매출과표</br>(과/세)' 	,type: 'uniPrice'},
	    	{name: 'TAX_1'			   	,text: '매출세액</br>(과/세)' 	,type: 'uniPrice'},
	    	{name: 'AMT_2'			   	,text: '매출과표</br>(과/기)' 	,type: 'uniPrice'},
	    	{name: 'TAX_2'			   	,text: '매출세액</br>(과/기)' 	,type: 'uniPrice'},
	    	{name: 'AMT_3'			   	,text: '매출과표</br>(영/세)' 	,type: 'uniPrice'},
	    	{name: 'TAX_3'			   	,text: '매출세액</br>(영/세)' 	,type: 'uniPrice'},
	    	{name: 'AMT_4'			   	,text: '매출과표</br>(영/기)' 	,type: 'uniPrice'},
	    	{name: 'TAX_4'			   	,text: '매출세액</br>(영/기)' 	,type: 'uniPrice'},
	    	{name: 'SUM_TAX_SALES'		,text: '매출세액</br>합계' 		,type: 'uniPrice'},
	    	{name: 'AMT_5'			   	,text: '매입과표</br>(과세)' 	,type: 'uniPrice'},
	    	{name: 'TAX_5'			   	,text: '매입세액</br>(과세)' 	,type: 'uniPrice'},
	    	{name: 'AMT_6'			   	,text: '매입과표</br>(의제등)' 	,type: 'uniPrice'},
	    	{name: 'TAX_6'			   	,text: '매입세액</br>(의제등)' 	,type: 'uniPrice'},
	    	{name: 'SUM_TAX_PURCHASE'	,text: '매입세액</br>합계' 		,type: 'uniPrice'},
	    	{name: 'AMT_7'			   	,text: '가산세' 				,type: 'uniPrice'},
	    	{name: 'AMT_8'			   	,text: '공제세액' 				,type: 'uniPrice'},
	    	{name: 'AMT_11'			   	,text: '납부</br>(환급세액)' 	,type: 'uniPrice'},
	    	{name: 'REMARK1'			,text: '비고' 				,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx460ukrMasterStore1',{
		model: 'Atx460ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			param.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			
			var paramMaster= panelSearch.getValues();
			paramMaster.FR_PUB_DATE = panelSearch.getField('FR_PUB_DATE').getStartDate();
			paramMaster.TO_PUB_DATE = panelSearch.getField('TO_PUB_DATE').getEndDate();
			
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					
					
					success: function(batch, option) {
						panelSearch.setValue('RE_REFERENCE','');
						directMasterStore.loadStoreRecords();
//						referenceSaveFlag = '';
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
				var recordsFirst = directMasterStore.data.items[0];	
				if(!Ext.isEmpty(recordsFirst)){
					detailForm.enable(true);
					if(recordsFirst.data.SAVE_FLAG == 'N'){
						masterGrid.reset();
						directMasterStore.clearData();
						Ext.each(records, function(record,i){	
			        		UniAppManager.app.onNewDataButtonDown();
			        		masterGrid.setNewDataATX100T(record.data);								        
				    	});
				    	var recordsFirst2 = directMasterStore.data.items[0];	
				    	detailForm.setActiveRecord(recordsFirst2);
				    	panelSearch.setValue('RE_REFERENCE_SAVE','Y');
				    	UniAppManager.setToolbarButtons('save',true);
//				    	UniAppManager.app.setSumDetailFormValue();
				    	detailForm.getField('APP_NUM').focus();
					}else{
						panelSearch.setValue('RE_REFERENCE_SAVE','');
					}
           		}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
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
		    items : [{ 
    			fieldLabel: '신고기간',
		        xtype: 'uniMonthRangefield',//uniMonthRangefield는 setReadOnly 속성이나 메서드를 지원하지 않습니다
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        width: 470,
		        startDD:'first',
		        endDD:'last',
		        holdable: 'hold',
		        allowBlank: false,
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
				fieldLabel: '사업자등록번호', 
				name: 'txtCompanyNum', 
				xtype: 'uniTextfield',
				readOnly: true
			},{
				fieldLabel: '승인번호', 
				name: 'txtAppNum', 
				xtype: 'uniTextfield',
				readOnly: true
			},{
	    		xtype: 'button',
	    		text: '재참조',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'temp20',
	    		handler : function() {
	    			if(!UniAppManager.app.checkForNewDetail()){
						return false;
					}else{
						var param = {"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
							"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate()
						};
						atx460ukrService.dataCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								if(confirm('이미 데이터가 존재합니다. 다시 생성하시면 기존 데이터가 삭제됩니다. 그래도 생성하시겠습니까?')) {
									panelSearch.setValue('RE_REFERENCE','Y');
//									referenceSaveFlag = 'Y';
									UniAppManager.app.onQueryButtonDown();
									panelSearch.setValue('RE_REFERENCE','');
//									UniAppManager.setToolbarButtons('deleteAll',false);	
//									UniAppManager.setToolbarButtons('query',false);
									UniAppManager.setToolbarButtons('save',true);	
								}else{
				    				return false;
				    			}
		    				}else{
		    					panelSearch.setValue('RE_REFERENCE','Y');
//								referenceSaveFlag = 'Y';
								UniAppManager.app.onQueryButtonDown();
								panelSearch.setValue('RE_REFERENCE','');
//								UniAppManager.setToolbarButtons('deleteAll',false);	
//								UniAppManager.setToolbarButtons('query',false);	
								UniAppManager.setToolbarButtons('save',true);	
		    				}
						});
					}
				}
	    	},{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 120', 
//	    		id:'temp20',
	    		handler : function() {
					var me = this;
					//panelSearch.getEl().mask('로딩중...','loading-indicator');
					
					var param = {
							"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
							"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate(),
							"COMPANY_NUM": panelSearch.getValue('txtCompanyNum'),
							"APP_NUM":panelSearch.getValue('txtAppNum'),
					};
					
					// Clip report
					var reportGubun	= gsReportGubun
					if(reportGubun.toUpperCase() == 'CLIP'){
						param.PGM_ID				= 'atx460ukr';
						param.MAIN_CODE				= 'A126';
						var win = Ext.create('widget.ClipReport', {
							url		: CPATH+'/accnt/atx460clukr.do',
							prgID	: 'atx460ukr',
							extParam: param
						});
						win.center();
						win.show();
						
					// jasper Report
					} else {
						var win = Ext.create('widget.PDFPrintWindow', {
							url: CPATH+'/atx/atx460rkrPrint.do',
							prgID: 'atx460rkr',
							extParam: param
							});
						win.center();
						win.show();
					}
				}
	    	},{
	    		xtype:'uniTextfield',
	    		name:'RE_REFERENCE',
	    		text:'재참조버튼클릭관련',
	    		hidden:true
	    	},{
	    		xtype:'uniTextfield',
	    		name:'RE_REFERENCE_SAVE',
	    		text:'재참조버튼클릭관련저장플래그',
	    		hidden:true
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
		layout : {type : 'uniTable', columns : 5,
			tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'},
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'center'}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '신고기간',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'FR_PUB_DATE',
	        endFieldName: 'TO_PUB_DATE',
//	        width: 470,
	        startDD:'first',
	        endDD:'last',
	        holdable: 'hold',
	        allowBlank: false,
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
			fieldLabel: '사업자등록번호', 
			name: 'txtCompanyNum', 
			xtype: 'uniTextfield',
			readOnly: true
    	},{
			fieldLabel: '승인번호', 
			name: 'txtAppNum', 
			xtype: 'uniTextfield',
			readOnly: true
		},{
    		xtype: 'button',
    		text: '재참조',
    		width: 100,
    		margin: '0 0 0 0',
    		tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'},
    		tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'right'},
//    		id:'temp20',
    		handler : function() {
	    			if(!UniAppManager.app.checkForNewDetail()){
						return false;
					}else{
						var param = {"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
							"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate()
						};
						atx460ukrService.dataCheck(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
								if(confirm('이미 데이터가 존재합니다. 다시 생성하시면 기존 데이터가 삭제됩니다. 그래도 생성하시겠습니까?')) {
									panelSearch.setValue('RE_REFERENCE','Y');
									
									UniAppManager.app.onQueryButtonDown();
									panelSearch.setValue('RE_REFERENCE','');
//									UniAppManager.setToolbarButtons('deleteAll',false);	
//									UniAppManager.setToolbarButtons('query',false);
									UniAppManager.setToolbarButtons('save',true);	
								}else{
				    				return false;
				    			}
		    				}else{
		    					panelSearch.setValue('RE_REFERENCE','Y');
									
								UniAppManager.app.onQueryButtonDown();
								panelSearch.setValue('RE_REFERENCE','');
//								UniAppManager.setToolbarButtons('deleteAll',false);	
//								UniAppManager.setToolbarButtons('query',false);	
								UniAppManager.setToolbarButtons('save',true);	
		    				}
						});
					}
				}
    	},{
    		xtype: 'button',
    		text: '출력',
    		width: 100,
    		margin: '0 0 0 0',
    		tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'},
    		tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'left'},
//    		id:'temp20',
    		handler : function() {
				var me = this;
				//panelSearch.getEl().mask('로딩중...','loading-indicator');
				
				var param = {
						"FR_PUB_DATE": panelSearch.getField('FR_PUB_DATE').getStartDate(),
						"TO_PUB_DATE": panelSearch.getField('TO_PUB_DATE').getEndDate(),
						"COMPANY_NUM": panelSearch.getValue('txtCompanyNum'),
						"APP_NUM"	 : panelSearch.getValue('txtAppNum'),
						};
				
				// Clip report
				var reportGubun	= gsReportGubun;
				if(reportGubun.toUpperCase() == 'CLIP'){
					param.PGM_ID				= 'atx460ukr';
					param.MAIN_CODE				= 'A126';
					var win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/accnt/atx460clukr.do',
						prgID	: 'atx460ukr',
						extParam: param
					});
					win.center();
					win.show();
					
				// jasper Report
				} else {
					var win = Ext.create('widget.PDFPrintWindow', {
						url: CPATH+'/atx/atx460rkrPrint.do',
						prgID: 'atx460rkr',
						extParam: param
						});
					win.center();
					win.show();
				}
			}
    	}/*,{
			xtype:'component',
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'left'},
			html:"<div class='x-hide-display' align='right' style='margin-top:5px'><div style='font-weight:bold; color:blue;'>※ 과세적용사업장의 과세승인번호는 &quot;0000&quot; 입니다.</div>"
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
    
	var detailForm = Unilite.createSearchForm('atx460ukrPanelSearch',{		
    	region: 'center', 
    	flex: 2.5,
    	autoScroll: true,
    	border:true,
    	padding:'1 1 1 1',
    	layout : {type : 'uniTable', columns : 1},
    	items:[{
    		layout : {type : 'uniTable', columns : 2},
			padding:'1 1 1 1',			
			xtype: 'container',
			defaults : {enforceMaxLength: true},
//			defaults: {margin: '5 0 5 0'},
			items: [{
				fieldLabel: '과세승인번호',
				name:'APP_NUM', 	
				xtype: 'uniTextfield',
				maxLength:4,
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						if(isNaN(newValue)){
							Ext.Msg.alert('확인','숫자만 입력가능합니다.');
							detailForm.setValue('APP_NUM','');
						}
					}
				}
			},{
			    xtype:'component', 
			    html:'※ 종사업장은 사업자단위과세 승인통지서에 종사업장 일련번호가 4자리 숫자로 부여됨',
			    width:500,
			    style: {
		           marginTop: '3px !important',
		           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
		           color: 'blue'
				}
			}, { 
				fieldLabel: '사업장 상호',
				name: 'CUSTOM_NAME',
				xtype: 'uniTextfield',
				maxLength:40,
				allowBlank: false,
				holdable: 'hold',
				colspan:2
			},{ 
				fieldLabel: '사업장 소재지',
				name: 'ADDR',
				xtype: 'uniTextfield',
				maxLength:200,
				allowBlank: false,
				holdable: 'hold',
				width:420,
				colspan:2
			}, { 
				fieldLabel: '비고',
				name: 'REMARK1',
				xtype: 'uniTextfield',
				maxLength:100,
				width:420
			}]
    	},{
    		xtype: 'container',
    		layout: {type : 'uniTable', columns : 1},
	    	border:true,
			padding:'1 1 1 1',
	    	items:[{
	    		xtype: 'container',
	    		margin: '0 0 0 0',
	    		layout : {type : 'uniTable', columns : 8/*,
	    		tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
			tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'bottom'}*/
			
			},		
				items: [{
					xtype: 'component',
					width: 10
				}, {
					title:'매출',
		        	xtype: 'fieldset',
		        	padding: '0 10 10 10',
		        	margin: '0 0 0 0',
		 		    defaults: {readOnly: false, xtype: 'uniNumberfield',enforceMaxLength: true},
		 		    layout : {type: 'uniTable' , columns: 3,
		 		    	tableAttrs: {width: '100%'},
						tdAttrs: {align : 'center'}
		 		    },
		        	items: [{
		        		xtype: 'component',  
		        		html:''
		        	},{
		        		xtype: 'component',  
		        		html:'매출과세표준'
		        	},{
		        		xtype: 'component',  
		        		html:'세액'
		        	},{
		        		xtype: 'component',  
		        		html:'과세/세금계산서분&nbsp;',
		        		tdAttrs: {align : 'right'}
		        	},{
						xtype: 'uniNumberfield',
						name:'AMT_1',
						maxLength:30
					},{
						xtype: 'uniNumberfield',
						name:'TAX_1',
						maxLength:30
					},{
		        		xtype: 'component',  
		        		html:'과세/기타분&nbsp;',
		        		tdAttrs: {align : 'right'}
		        	},{
						xtype: 'uniNumberfield',
						name:'AMT_2'
					},{
						xtype: 'uniNumberfield',
						name:'TAX_2'
					},{
		        		xtype: 'component',  
		        		html:'영세/세금계산서분&nbsp;',
		        		tdAttrs: {align : 'right'}
		        	},{
						xtype: 'uniNumberfield',
						name:'AMT_3'
					},{
						xtype: 'uniNumberfield',
						name:'TAX_3',
						readOnly:true
					},{
		        		xtype: 'component',  
		        		html:'영세/기타분&nbsp;',
		        		tdAttrs: {align : 'right'}
		        	},{
						xtype: 'uniNumberfield',
						name:'AMT_4'
					},{
						xtype: 'uniNumberfield',
						name:'TAX_4',
						readOnly:true
					},{
		        		xtype: 'component',  
		        		html:''
		        	},{
		        		xtype: 'component',  
		        		html:''
		        	},{
		        		xtype: 'component',  
		        		html:'1)매출세액합계',
		        		style: {
				           marginTop: '3px !important',
				           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
				           color: 'blue'
						},
		        		tdAttrs: {align : 'center'}
		        	},{
		        		xtype: 'component',  
		        		html:''
		        	},{
		        		xtype: 'component',  
		        		html:''
		        	},{
						xtype: 'uniNumberfield',
						name:'SUM_TAX_SALES',
						readOnly: true
					}]
				}, {
					xtype: 'component',
					width: 10
				}, {
					title:'매입',
		        	xtype: 'fieldset',
		        	padding: '0 10 10 10',
		        	margin: '0 0 0 0',
		 		    defaults: {readOnly: false, xtype: 'uniNumberfield',enforceMaxLength: true},
		 		    layout : {type: 'uniTable' , columns: 3,
		 		    	tableAttrs: {width: '100%'},
						tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'center',width: '100%'}
		 		    },
		        	items: [{
		        		xtype: 'component',  
		        		html:''
		        	},{
		        		xtype: 'component',  
		        		html:'매입과세표준'
		        	},{
		        		xtype: 'component',  
		        		html:'세액'
		        	},{
		        		xtype: 'component',  
		        		html:'과세&nbsp;',
		        		tdAttrs: {align : 'right'}
		        	},{
						xtype: 'uniNumberfield',
						name:'AMT_5',
						maxLength:30
					},{
						xtype: 'uniNumberfield',
						name:'TAX_5',
						maxLength:30
					},{
		        		xtype: 'component',  
		        		html:'의제 등&nbsp;',
		        		tdAttrs: {align : 'right'}
		        	},{
						xtype: 'uniNumberfield',
						name:'AMT_6'
					},{
						xtype: 'uniNumberfield',
						name:'TAX_6'
					},{
		        		xtype: 'component',  
		        		html:' '
		        	},{
		        		xtype: 'component',  
		        		html:' '
		        	},{
		        		xtype: 'component',  
		        		html:' ',
		        		tdAttrs: {height: 27}
		        	},{
		        		xtype: 'component',  
		        		html:' '
		        	},{
		        		xtype: 'component',  
		        		html:' '
		        	},{
		        		xtype: 'component',  
		        		html:' ',
		        		tdAttrs: {height: 27}
		        	},{
		        		xtype: 'component',  
		        		html:' '
		        	},{
		        		xtype: 'component',  
		        		html:' '
		        	},{
		        		xtype: 'component',  
		        		html:'2)매입세액합계',
		        		style: {
				           marginTop: '3px !important',
				           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
				           color: 'blue'
						},
		        		tdAttrs: {align : 'center'}
		        	},{
		        		xtype: 'component',  
		        		html:' '
		        	},{
		        		xtype: 'component',  
		        		html:' '
		        	},{
						xtype: 'uniNumberfield',
						name:'SUM_TAX_PURCHASE',
						readOnly: true
					}]
				}, {
					xtype: 'component',
					width: 10
				}, {
		    		xtype: 'container',
		    		margin: '0 0 0 0',
		    		layout : {type : 'uniTable', columns : 1
//		    		tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//					tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'bottom'}
					},
					items: [{
		        		xtype: 'component',
		        		html:' ',
		        		tdAttrs: {height: 85}
			        },{
						title:'기타',
			        	xtype: 'fieldset',
			        	padding: '10 10 10 10',
			        	margin: '0 0 0 0',
	//		        	tableAttrs: {align : 'bottom'},
	//		        	trAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'bottom'/*,width: '100%'*/},
	//		        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'bottom'/*,width: '100%'*/},
			 		    defaults: {readOnly: false, xtype: 'uniNumberfield',enforceMaxLength: true},
			 		    layout : {type: 'uniTable' , columns: 2,
			 		    	tableAttrs: {width: '100%'},
							tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'center'/*,width: '100%'*/}
			 		    },
			        	items: [{
			        		xtype: 'component',  
			        		html:' '
			        	},{
			        		xtype: 'component',  
			        		html:'3)기타세액',
			        		style: {
					           marginTop: '3px !important',
					           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
					           color: 'blue'
							},
			        		tdAttrs: {align : 'center'}
				        	},{
				        		xtype: 'component',  
				        		html:'가산세(+)&nbsp;'
				        	},{
								xtype: 'uniNumberfield',
								name:'AMT_7',
								maxLength:30
							},{
				        		xtype: 'component',  
				        		html:'공제세액(-)&nbsp;'
				        	},{
								xtype: 'uniNumberfield',
								name:'AMT_8'
						}]
					}]
				}, {
					xtype: 'component',
					width: 10
				}, {
		    		xtype: 'container',
		    		margin: '0 0 0 0',
		    		layout : {type : 'uniTable', columns : 1
//		    		tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//					tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'bottom'}
					},
					items: [{
		        		xtype: 'component',
		        		html:' ',
		        		tdAttrs: {height: 110}
			        },{
						title:'납부',
			        	xtype: 'fieldset',
			        	padding: '10 10 10 10',
			        	margin: '0 0 0 0',
	//		        	tableAttrs: {align : 'bottom'},
	//		        	trAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'bottom'/*,width: '100%'*/},
	//		        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'bottom'/*,width: '100%'*/},
			 		    defaults: {readOnly: false, xtype: 'uniNumberfield',enforceMaxLength: true},
			 		    layout : {type: 'uniTable' , columns: 1,
			 		    	tableAttrs: {width: '100%'},
							tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/align : 'center'/*,width: '100%'*/}
			 		    },
			        	items: [{
			        		xtype: 'component',  
			        		html:'납부세액(환급세액)',
			        		style: {
					           marginTop: '3px !important',
					           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
					           color: 'blue'
							},
			        		tdAttrs: {align : 'center'}
				        	},{
								xtype: 'uniNumberfield',
								name:'AMT_11',
								maxLength:30,
								readOnly: true
						}]
					}]
				}]
	    	}]
    	},{
    		xtype: 'component',  
    		html:' '
    	}],		
		/*api: {
			submit: 'atx460ukrService.syncForm'				
		},*//*listeners: {
	        uniOnChange: function(basicForm, dirty, eOpts) {
	        	if(gsSaveRefFlag == "Y"){
	        		UniAppManager.setToolbarButtons('save', true);
	        	}				
			}
		 },*/
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
					//this.mask();
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
				//this.unmask();
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
  		},
  		setLoadRecord: function()	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('atx460ukrGrid1', {
    	// for tab    	
//        layout : 'fit',
    	flex: 1.5,
        region:'south',
    	store: directMasterStore,
    	excelTitle: '사업자단위과세사업장별부가가치세과세표',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns:  [
			{dataIndex: 'COMP_CODE'						, width: 90,hidden:true},
			{dataIndex: 'FR_PUB_DATE'					, width: 90,hidden:true},
			{dataIndex: 'TO_PUB_DATE'					, width: 90,hidden:true},
        	{dataIndex: 'SEQ'							, width: 90,hidden:true},
        	{dataIndex: 'APP_NUM'						, width: 90},
        	{dataIndex: 'CUSTOM_NAME'					, width: 90,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}
        	},
        	{dataIndex: 'ADDR'							, width: 120},
        	{dataIndex: 'AMT_1'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'TAX_1'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'AMT_2'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'TAX_2'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'AMT_3'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'TAX_3'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'AMT_4'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'TAX_4'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'SUM_TAX_SALES'					, width: 90,summaryType: 'sum',
        		style: {
//		           marginTop: '3px !important',
		           font: '10px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
		           color: 'blue'
				},
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if (val != 0){
                        return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
                    }
                    return Ext.util.Format.number(val,'0,000');
                }
        	},
        	{dataIndex: 'AMT_5'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'TAX_5'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'AMT_6'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'TAX_6'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'SUM_TAX_PURCHASE'				, width: 90,summaryType: 'sum',
        		style: {
//		           marginTop: '3px !important',
		           font: '10px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
		           color: 'blue'
				},
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if (val != 0){
                        return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
                    }
                    return Ext.util.Format.number(val,'0,000');
                }
				
			},
        	{dataIndex: 'AMT_7'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'AMT_8'							, width: 90,summaryType: 'sum'},
        	{dataIndex: 'AMT_11'						, width: 90,summaryType: 'sum',
        		style: {
//		           marginTop: '3px !important',
		           font: '10px "굴림",Gulim,tahoma,arial,verdana,sans-serif,weight:bold',
		           color: 'blue'
				},
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if (val != 0){
                        return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
                    }
                    return Ext.util.Format.number(val,'0,000');
                }
			},
        	{dataIndex: 'REMARK1'						, width: 90}
        ],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			},
			selectionchangerecord:function(selected)	{
          		detailForm.setActiveRecord(selected);
//          		if(!Ext.isEmpty(selected.data.UPDATE_DB_TIME)){
//          			Ext.getCmp('crdt_num').setReadOnly(true);
//          		}else{
//          			Ext.getCmp('crdt_num').setReadOnly(false);
//          		}
          		detailForm.getField('APP_NUM').focus();
          	}
		},
		setNewDataATX100T:function(record){
			var grdRecord = this.getSelectedRecord();

			grdRecord.set('APP_NUM'			,record['APP_NUM']);
			grdRecord.set('CUSTOM_NAME'		,record['CUSTOM_NAME']);
			grdRecord.set('ADDR'			,record['ADDR']);
			grdRecord.set('AMT_1'			,record['AMT_1']);
			grdRecord.set('TAX_1'			,record['TAX_1']);
			grdRecord.set('AMT_2'			,record['AMT_2']);
			grdRecord.set('TAX_2'			,record['TAX_2']);
			grdRecord.set('AMT_3'			,record['AMT_3']);
			grdRecord.set('AMT_4'			,record['AMT_4']);
			grdRecord.set('AMT_5'			,record['AMT_5']);
			grdRecord.set('TAX_5'			,record['TAX_5']);
			grdRecord.set('AMT_6'			,record['AMT_6']);
			grdRecord.set('TAX_6'			,record['TAX_6']);
			grdRecord.set('SUM_TAX_SALES'	,record['SUM_TAX_SALES']);
			grdRecord.set('SUM_TAX_PURCHASE',record['SUM_TAX_PURCHASE']);
			
			grdRecord.set('AMT_11',record['SUM_TAX_SALES'] - record['SUM_TAX_PURCHASE']);
			
		}
    });   
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailForm,masterGrid, panelResult
			]	
		},
			panelSearch
		],
		id  : 'atx460ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['newData','save'],false);
			UniAppManager.setToolbarButtons('reset',true);
			this.setDefault();
			
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
//				panelSearch.setValue('RE_REFERENCE','');
				directMasterStore.loadStoreRecords();
				UniAppManager.setToolbarButtons('newData',true);
				
				return panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
			
//			var insockDate = UniDate.get('today');
//			var procSw	 = '2'
			var frPubDate = panelSearch.getField('FR_PUB_DATE').getStartDate();
			var toPubDate = panelSearch.getField('TO_PUB_DATE').getEndDate();
			var compCode = UserInfo.compCode;
            var seq = directMasterStore.max('SEQ');
        	if(!seq){
        		seq = 1;
        	}else{
        		seq += 1;
        	}	 	 
            	 
            	 
        	var r = {
        		FR_PUB_DATE: frPubDate,
        		TO_PUB_DATE: toPubDate,
        		COMP_CODE: compCode,
        		SEQ: seq
//            	 	COMP_CODE : compCode,
//            	 	INSOCK_DATE : insockDate,
//            	 	PROC_SW : procSw
	        };
			masterGrid.createRow(r);
			panelSearch.setAllFieldsReadOnly(true);
			panelResult.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {	
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			detailForm.clearForm();
			directMasterStore.clearData();
			
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				if(selRow.get('ACCOUNT_Q') != 0)
//				{
//					alert('<t:message code="unilite.msg.sMM008"/>');
//				}else{
					masterGrid.deleteSelectedRow();
//				}
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						
						var deletable = true;
						if(deletable){		
							masterGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;	
							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
			if(getTaxBase == '5'){
				panelSearch.setValue('txtCompanyNum',getCompanyNum);	
				panelSearch.setValue('txtAppNum',getAppNum);
				panelResult.setValue('txtCompanyNum',getCompanyNum);
				panelResult.setValue('txtAppNum',getAppNum);
			}
			detailForm.disable(true);
        	panelSearch.setValue('FR_PUB_DATE',UniDate.get('today'));
        	panelSearch.setValue('TO_PUB_DATE',UniDate.get('today'));
        	panelResult.setValue('FR_PUB_DATE',UniDate.get('today'));
        	panelResult.setValue('TO_PUB_DATE',UniDate.get('today'));        	
        	
        	var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_PUB_DATE');
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        setSumDetailFormValue:function() {
        	
        	
        	detailForm.setValue('SUM_TAX_SALES', detailForm.getValue('TAX_1') + detailForm.getValue('TAX_2'));
        	
        	detailForm.setValue('SUM_TAX_PURCHASE', detailForm.getValue('TAX_5') + detailForm.getValue('TAX_6'));

        	detailForm.setValue('AMT_11', detailForm.getValue('SUM_TAX_SALES') - detailForm.getValue('SUM_TAX_PURCHASE') 
        								 + detailForm.getValue('AMT_7') - detailForm.getValue('AMT_8'));
		}
        
        
        
	});
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName){
				
				
				case 'AMT_1':
					detailForm.setValue('TAX_1', newValue * 0.1);
					UniAppManager.app.setSumDetailFormValue();
					break;
				case 'AMT_2':
					detailForm.setValue('TAX_2', newValue * 0.1);
					UniAppManager.app.setSumDetailFormValue();
					break;
				case 'AMT_5':
					detailForm.setValue('TAX_5', newValue * 0.1);
					UniAppManager.app.setSumDetailFormValue();
					break;
				
				case fieldName:
					UniAppManager.app.setSumDetailFormValue();
				break;
			
			}
			return rv;
		}
	});
};


</script>
