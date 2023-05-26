<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx490ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A003" /> <!-- 매입/매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A149" /> <!-- 회계전자발행 -->
	<t:ExtComboStore comboType="AU" comboCode="B066" /> <!-- 계산서유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- 예/아니오 -->
	</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >

var sRefcode2   = '${sRefcode2}';

function appMain() {
    var excelWindow;            //세금계산서 업로드 윈도우 생성
    var excelWindow2;            //계산서 업로드 윈도우 생성
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx490ukrService.selectList',
			update: 'atx490ukrService.updateDetail',
//			create: 'atx490ukrService.insertDetail',
			destroy: 'atx490ukrService.deleteDetail',
			syncAll: 'atx490ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Atx490ukrModel', {
	    fields: [
//	    	{name: 'CHOICE'       			   	,text: '선택' 				,type: 'string'},
	    	{name: 'SEQ'          			   	,text: '순번' 				,type: 'string'},
	    	{name: 'GROUP_SEQ'    			   	,text: 'GROUP_SEQ' 			,type: 'string'},
	    	{name: 'COMP_CODE'    			   	,text: 'COMP_CODE' 			,type: 'string'},
	    	{name: 'DIV_CODE'     			   	,text: 'DIV_CODE' 			,type: 'string'},
	    	{name: 'INOUT_DIVI'   			   	,text: '구분' 				,type: 'string',comboType:'AU', comboCode:'A003'},
	    	{name: 'BILL_TYPE'    			   	,text: '계산서유형' 			,type: 'string'},
	    	{name: 'PUB_DATE'     			   	,text: '계산서일' 				,type: 'uniDate'},
	    	{name: 'CUSTOM_NAME'  			   	,text: '거래처명' 				,type: 'string'},
	    	{name: 'COMPANY_NUM'  			   	,text: '사업자/주민번호' 		,type: 'string'},
	    	{name: 'SUPPLY_AMT'   			   	,text: '공급가액' 				,type: 'uniPrice'},
	    	{name: 'TAX_AMT'      			   	,text: '세액' 				,type: 'uniPrice'},
	    	{name: 'TOTAL_AMT'    			   	,text: '합계' 				,type: 'uniPrice'},
	    	{name: 'APPR_NO'      			   	,text: '승인번호' 				,type: 'string'},
	    	{name: 'NTS_REPORT_YN'			   	,text: '신고여부' 				,type: 'string',comboType:'AU', comboCode:'A020'},
	    	{name: 'ACCRUE_I'     			   	,text: '대사결과차액' 			,type: 'uniPrice'},
	    	{name: 'SUPPLY_AMT_I' 			   	,text: '공급가액' 				,type: 'uniPrice'},
	    	{name: 'TAX_AMT_I'    			   	,text: '세액' 				,type: 'uniPrice'},
	    	{name: 'TOT_AMT_I'    			   	,text: '합계' 				,type: 'uniPrice'},
	    	{name: 'BILL_SEND_YN' 			   	,text: '전자발행여부' 			,type: 'string',comboType:'AU', comboCode:'A149'},
	    	{name: 'AC_DATE'      			   	,text: '전표일' 				,type: 'uniDate'},
	    	{name: 'SLIP_NUM'     			   	,text: '번호' 				,type: 'string'},
	    	{name: 'SLIP_SEQ'     			   	,text: '순번' 				,type: 'int'},
	    	{name: 'REMARK'       			   	,text: '적요' 				,type: 'string'},
	    	{name: 'WEB_BUY_I'    			   	,text: 'WEB_BUY_I' 			,type: 'string'},
	    	{name: 'WEB_SALE_I'   			   	,text: 'WEB_SALE_I' 		,type: 'string'},
	    	{name: 'ERP_BUY_I'    			   	,text: 'ERP_BUY_I' 			,type: 'string'},
	    	{name: 'ERP_SALE_I'   			   	,text: 'ERP_SALE_I' 		,type: 'string'}

		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('atx490ukrMasterStore1',{
		model: 'Atx490ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						masterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
//           		var viewNormal = masterGrid.normalGrid.getView();
//				var viewLocked = masterGrid.lockedGrid.getView();
           		if(store.getCount() > 0){
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
					
					UniAppManager.setToolbarButtons('deleteAll',true);
				}else{
//					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
//					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
					
					UniAppManager.setToolbarButtons('deleteAll',false);
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
				fieldLabel: '신고사업장', 
				name: 'txtBillDivCode', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode	: 'BILL',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('txtBillDivCode', newValue);
					}
				}
			},{ 
    			fieldLabel: '계산서일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'txtFrPubDate',
		        endFieldName: 'txtToPubDate',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('txtFrPubDate',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('txtToPubDate',newValue);
			    	}
			    }
	        },		
			Unilite.popup('CUST', {
				fieldLabel: '거래처',
				valueFieldName:'CUSTOM_CODE',
		    	textFieldName:'CUSTOM_NAME',
		    	hidden: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
							panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
			}),
			{
				fieldLabel: '매입/매출구분', 
				name: 'cboInoutDivi',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A003',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('cboInoutDivi', newValue);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '대사결과',						            		
//				id: 'rdoSelect',
				items: [{
					boxLabel: '전체', 
					width:60, 
					name: 'rdoAccrue', 
					inputValue: ''
				},{
					boxLabel: '일치', 
					width:60, 
					name: 'rdoAccrue', 
					inputValue: 'Y'
				},{
					boxLabel: '불일치', 
					width:60, 
					name: 'rdoAccrue', 
					inputValue: 'N', 
					checked: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('rdoAccrue').setValue(newValue.rdoAccrue);
						/*if(masterGrid.getStore().getCount() > 0){
							masterStore2.loadStoreRecords();
						}*/
					}
				}
			},{
				fieldLabel: '사업자/주민번호', 
				name: 'txtCompanyNum', 
				xtype: 'uniTextfield',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('txtCompanyNum', newValue);
					}
				}
			},{
				fieldLabel: '계산서유형', 
				name: 'cboBillType',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B066',
				allowBlank: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('cboBillType', newValue);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '국세청신고여부',						            		
//				id: 'rdoSelect2',
				items: [{
					boxLabel: '전체', 
					width:60, 
					name: 'rdoStatCode', 
					inputValue: '', 
					checked: true
				},{
					boxLabel: '예', 
					width:60, 
					name: 'rdoStatCode', 
					inputValue: 'Y'
				},{
					boxLabel: '아니오', 
					width:60, 
					name: 'rdoStatCode', 
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('rdoStatCode').setValue(newValue.rdoStatCode);
						/*if(masterGrid.getStore().getCount() > 0){
							masterStore2.loadStoreRecords();
						}*/
					}
				}
			},{
				fieldLabel: '회계전자발행', 
				name: 'cboBillSendYn', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A149',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('cboBillSendYn', newValue);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '주민번호 암호화',						            		
//				id: 'rdoEncryptCode',
				items: [{
					boxLabel: '예', 
					width:60, 
					name: 'rdoEncryptCode', 
					inputValue: 'Y', 
					checked: true
				},{
					boxLabel: '아니오', 
					width:60, 
					name: 'rdoEncryptCode', 
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('rdoEncryptCode').setValue(newValue.rdoEncryptCode);
						/*if(masterGrid.getStore().getCount() > 0){
							masterStore2.loadStoreRecords();
						}*/
					}
				}
			}/*,{
			    xtype: 'box',
			    autoEl: {tag: 'hr'}
//			    colspan: 3
			},{
				fieldLabel: '국세청매입액',
				value: '0', 
				name: '', 
				xtype: 'uniNumberfield',
				readOnly : true			
			},{
				fieldLabel: '국세청매출액',
				value: '0',
				name: '', 
				xtype: 'uniNumberfield',
				readOnly : true		
			},{
				fieldLabel: 'uniLITE매입금액', 
				value: '0',
				name: '', 
				xtype: 'uniNumberfield',
				readOnly : true
			},{
				fieldLabel: 'uniLITE매출금액',
				value: '0',
				name: '', 
				xtype: 'uniNumberfield',
				readOnly : true
			},{
				fieldLabel: '선택된 ERP의 전자발행여부 일괄변경', 
				name: 'cboBillSendYnChk', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode: 'A149',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('cboBillSendYnChk', newValue);
					}
				}
			},{
		    	xtype: 'container',
//		    	id:'temp2',
		    	margin: '0 0 0 60', 
		    	layout: {
		    		type: 'hbox'
//					align: 'center'
//					pack:'center'
		    	},
		    	items:[{
		    		xtype: 'button',
		    		text: '적용',
		    		width: 100,
		    		margin: '0 0 0 0',
		    		handler : function() {
						var me = this;
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						var param = panelSearch.getValues();
	   				}
		    	},{
		    		xtype: 'button',
		    		text: '전체선택',
		    		width: 100,
		    		margin: '0 0 0 0',                                                       
		    		handler : function() {
						var me = this;
						panelSearch.getEl().mask('로딩중...','loading-indicator');
						var param = panelSearch.getValues();
	   				}
		    	}]
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
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '신고사업장', 
			name: 'txtBillDivCode', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			comboCode	: 'BILL',          	
	        tdAttrs: {width: 420},  
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtBillDivCode', newValue);
				}
			}
		},{ 
			fieldLabel: '계산서일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'txtFrPubDate',
	        endFieldName: 'txtToPubDate',      
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
	        allowBlank: false,    	
	        tdAttrs: {width: 420},  
	        colspan: 2,
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('txtFrPubDate',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('txtToPubDate',newValue);
		    	}
		    }
        },		
		Unilite.popup('CUST', {
			fieldLabel: '거래처',
			valueFieldName:'CUSTOM_CODE',
	    	textFieldName:'CUSTOM_NAME',
	    	hidden: true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		}),
		{
			fieldLabel: '매입/매출구분', 
			name: 'cboInoutDivi', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'A003',
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('cboInoutDivi', newValue);
				}
			}
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '대사결과',	     
            tdAttrs: {width: 420},					            		
//				id: 'rdoSelect',
			items: [{
				boxLabel: '전체', 
				width:60, 
				name: 'rdoAccrue', 
				inputValue: ''
			},{
				boxLabel: '일치', 
				width:60, 
				name: 'rdoAccrue', 
				inputValue: 'Y'
			},{
				boxLabel: '불일치', 
				width:60, 
				name: 'rdoAccrue', 
				inputValue: 'N', 
				checked: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('rdoAccrue').setValue(newValue.rdoAccrue);
					/*if(masterGrid.getStore().getCount() > 0){
						masterStore2.loadStoreRecords();
					}*/
				}
			}
		},{
			fieldLabel: '사업자/주민번호', 
			name: 'txtCompanyNum', 
			xtype: 'uniTextfield',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('txtCompanyNum', newValue);
				}
			}
		},{
			fieldLabel: '계산서유형', 
			name: 'cboBillType', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B066',
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(newValue == '11') {         //계산서이면
                        Ext.getCmp('btn11').setDisabled(false);
                        Ext.getCmp('btn20').setDisabled(true);
					} else {
                        Ext.getCmp('btn11').setDisabled(true);
                        Ext.getCmp('btn20').setDisabled(false);
					}
					panelSearch.setValue('cboBillType', newValue);
				}
			}
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '국세청신고여부',		     
            tdAttrs: {width: 420},				            		
//				id: 'rdoStatCode',
			items: [{
				boxLabel: '전체', 
				width:60, 
				name: 'rdoStatCode', 
				inputValue: '', 
				checked: true
			},{
				boxLabel: '예', 
				width:60, 
				name: 'rdoStatCode', 
				inputValue: 'Y'
			},{
				boxLabel: '아니오', 
				width:60, 
				name: 'rdoStatCode', 
				inputValue: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('rdoStatCode').setValue(newValue.rdoStatCode);
					/*if(masterGrid.getStore().getCount() > 0){
						masterStore2.loadStoreRecords();
					}*/
				}
			}
		},{
			fieldLabel: '회계전자발행', 
			name: 'cboBillSendYn', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'A149',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('cboBillSendYn', newValue);
				}
			}
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '주민번호 암호화',		
			colspan:2,
//				id: 'rdoEncryptCode',
			items: [{
				boxLabel: '예', 
				width:60, 
				name: 'rdoEncryptCode', 
				inputValue: 'Y', 
				checked: true
			},{
				boxLabel: '아니오', 
				width:60, 
				name: 'rdoEncryptCode', 
				inputValue: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('rdoEncryptCode').setValue(newValue.rdoEncryptCode);
					/*if(masterGrid.getStore().getCount() > 0){
						masterStore2.loadStoreRecords();
					}*/
				}
			}
		}/*,{
			xtype: 'box',
		    autoEl: {tag: 'hr'},
			colspan: 3
		},
		{
			fieldLabel: '국세청매입액',
			value: '0', 
			name: '', 
			xtype: 'uniNumberfield',
			readOnly : true			
		},{
			fieldLabel: '국세청매출액',
			value: '0',
			name: '', 
			xtype: 'uniNumberfield',
			readOnly : true		
		},{
			fieldLabel: 'uniLITE매입금액', 
			value: '0',
			name: '', 
			xtype: 'uniNumberfield',
			readOnly : true
		},{
			fieldLabel: 'uniLITE매출금액',
			value: '0',
			name: '', 
			xtype: 'uniNumberfield',
			readOnly : true
		},{
		    xtype:'component', 
		    html:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※국세청 양식을 변경없이 바로 올리시기 바랍니다.',
		    width:350,
		    style: {
	           marginTop: '3px !important',
	           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
	           color: 'green'
			}
//			colspan:2
		},{
	    	xtype: 'container',
//		    	id:'temp2',
	    	margin: '0 0 0 60', 
	    	layout: {type : 'uniTable', columns : 3},
	    	colspan:2,
	    	items:[{
				fieldLabel: '선택된 uniLITE의 전자발행여부 일괄변경', 
				name: 'cboBillSendYnChk', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode: 'A149',
				labelWidth:250,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('cboBillSendYnChk', newValue);
					}
				}
			},{
	    		xtype: 'button',
	    		text: '적용',
	    		width: 100,
	    		margin: '0 0 0 0',
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
   				}
	    	},{
	    		xtype: 'button',
	    		text: '전체선택',
	    		width: 100,
	    		margin: '0 0 0 0',                                                       
	    		handler : function() {
					var me = this;
					panelSearch.getEl().mask('로딩중...','loading-indicator');
					var param = panelSearch.getValues();
   				}
	    	}]
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
	
	var panelResultSecond = Unilite.createSearchForm('resultSecondForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4,
			tableAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'},
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ align : 'right'}
		},
		padding:'1 1 1 1',
		border:true,
		items: [
		/*{
			fieldLabel: '국세청매입액',
			value: '0', 
			name: '', 
			xtype: 'uniNumberfield',
			readOnly : true			
		},{
			fieldLabel: '국세청매출액',
			value: '0',
			name: '', 
			xtype: 'uniNumberfield',
			readOnly : true		
		},{
			fieldLabel: 'uniLITE매입금액', 
			value: '0',
			name: '', 
			xtype: 'uniNumberfield',
			readOnly : true
		},{
			fieldLabel: 'uniLITE매출금액',
			value: '0',
			name: '', 
			xtype: 'uniNumberfield',
			readOnly : true
		},*/{
		    xtype:'component', 
		    name: '',
		    html:'※국세청 양식을 변경없이 바로 올리시기 바랍니다.',
		    width:280,
		    style: {
	           marginTop: '3px !important',
	           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
	           color: 'green'
			}
		},{
            xtype: 'button',
            text: '세금계산서 파일upload',
            id : 'btn11',
            margin: '0 0 0 2',
            tdAttrs: {/*style: 'border : 1px solid #ced9e7;', */align : 'center'},
            handler : function() {
                var me = this;
//                panelSearch.getEl().mask('로딩중...','loading-indicator');
                openExcelWindow(panelResult.getValue('cboBillType'));
            }
        },{
            xtype: 'button',
            text: '계산서 파일upload',
            id : 'btn20',
            margin: '0 0 0 2',
            tdAttrs: {/*style: 'border : 1px solid #ced9e7;', */align : 'center'},
            handler : function() {
                var me = this;
//                panelSearch.getEl().mask('로딩중...','loading-indicator');
                openExcelWindow(panelResult.getValue('cboBillType'));
            }
        },{
	    	xtype: 'container',
//		    	id:'temp2',
	    	margin: '0 0 0 60', 
	    	layout: {type : 'uniTable', columns : 3},
	    	colspan:2,
//	    	tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'east'},
	    	items:[{
				fieldLabel: '선택된 ERP의 전자발행여부 일괄변경', 
				name: 'cboBillSendYnChk', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode: 'A149',
				labelWidth:250,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
//						panelSearch.setValue('cboBillSendYnChk', newValue);
					}
				}
			},{
	    		xtype: 'button',
	    		text: '적용',
	    		width: 100,
	    		margin: '0 0 0 0',
	    		handler: function() {	
					var records = masterGrid.getSelectedRecords(); 
					Ext.each(records,  function(record, index){
						if(record.get('NTS_REPORT_YN') != ''){
							if(record.get('NTS_REPORT_YN') != panelResultSecond.getValue('cboBillSendYnChk')){
								Ext.Msg.alert("확인",records[0].data.SEQ+" 행의 신고여부와 변경하려는 전자발행여부가 일치하지 않습니다.");
								
							}else{
								record.set('BILL_SEND_YN',panelResultSecond.getValue('cboBillSendYnChk'));
							}
						}
					});
				}
	    	}/*,{
	    		xtype: 'button',
	    		text: '전체선택',
	    		width: 100,
	    		margin: '0 0 0 0',                                                       
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
	
	
	
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx490ukrGrid1', {
    	// for tab    	
//        layout : 'fit',
        region:'center',
    	store: masterStore,
    	excelTitle: '전사세금계산서 국세청신고자료 대사',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        }),
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
//	        	var cls = '';
	        	
	          	if(record.get('NTS_REPORT_YN') != record.get('BILL_SEND_YN')){
					return 'x-change-celltext_blue';
				}
				if(record.get('ACCRUE_I') != 0){
					return record.get('ACCRUE_I') == 'x-change-celltext_red';	
				}
				
//				return cls;
	        }
	    },
    	columns: [
//    	{xtype: 'rownumberer', text:'순번', 	width: 50, locked: true},
//			{ dataIndex: 'CHOICE'          	   		, 	width: 33, locked: true},
			{ dataIndex: 'SEQ'             	   		, 	width: 50,align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            	}
			
			
			},
			{ dataIndex: 'GROUP_SEQ'       	   		, 	width: 33, hidden: true},
			{ dataIndex: 'COMP_CODE'       	   		, 	width: 33, hidden: true},
			{ dataIndex: 'DIV_CODE'        	   		, 	width: 33, hidden: true},
			{ dataIndex: 'INOUT_DIVI'      	   		, 	width: 40},
			{ dataIndex: 'BILL_TYPE'       	   		, 	width: 80, hidden: true},
			{ dataIndex: 'PUB_DATE'        	   		, 	width: 73},
			{ dataIndex: 'CUSTOM_NAME'     	   		, 	width: 166},
			{ dataIndex: 'COMPANY_NUM'     	   		, 	width: 120, align:'center'},
			{ text: '국세청 신고된 매입/매출정보',
				columns: [
					{ dataIndex: 'SUPPLY_AMT'      	   		, 	width: 100,summaryType: 'sum'},
					{ dataIndex: 'TAX_AMT'         	   		, 	width: 100,summaryType: 'sum'},
					{ dataIndex: 'TOTAL_AMT'       	   		, 	width: 110,summaryType: 'sum'},
					{ dataIndex: 'APPR_NO'         	   		, 	width: 166},
					{ dataIndex: 'NTS_REPORT_YN'   	   		, 	width: 66}
				]
			},
			{ dataIndex: 'ACCRUE_I'        	   		, 	width: 110,summaryType: 'sum'/*,
			
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if (val != 0){
                        return '<span style= "color:' + '#da3f3a' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
                    }
                    return Ext.util.Format.number(val,'0,000');
                }*/
			
			},
			{ text: 'ERP 부가세정보',
				columns: [
					{ dataIndex: 'SUPPLY_AMT_I'    	   		, 	width: 100,summaryType: 'sum'},
					{ dataIndex: 'TAX_AMT_I'       	   		, 	width: 100,summaryType: 'sum'},
					{ dataIndex: 'TOT_AMT_I'       	   		, 	width: 110,summaryType: 'sum'},
					{ dataIndex: 'BILL_SEND_YN'    	   		, 	width: 93},
					{ dataIndex: 'AC_DATE'         	   		, 	width: 73},
					{ dataIndex: 'SLIP_NUM'        	   		, 	width: 66, align:'right'},
					{ dataIndex: 'SLIP_SEQ'        	   		, 	width: 66},
					{ dataIndex: 'REMARK'          	   		, 	width: 333}
				]
			},
			{ dataIndex: 'WEB_BUY_I'       	   		, 	width: 33, hidden: true},
			{ dataIndex: 'WEB_SALE_I'      	   		, 	width: 33, hidden: true},
			{ dataIndex: 'ERP_BUY_I'       	   		, 	width: 33, hidden: true},
			{ dataIndex: 'ERP_SALE_I'      	   		, 	width: 33, hidden: true}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		}
    });   
	
    
    
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult,panelResultSecond
			]	
		},
			panelSearch
		],
		id  : 'atx490ukrApp',
		fnInitBinding : function() {
//			UniAppManager.setToolbarButtons('newData',false);
			UniAppManager.setToolbarButtons('reset',true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('txtFrPubDate');
			
//			var viewNormal = masterGrid.normalGrid.getView();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
			this.setDefault();
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterStore.loadStoreRecords();
//				UniAppManager.setToolbarButtons('newData',true);
				return panelResult.setAllFieldsReadOnly(true);
			}
		},
/*		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
//			var compCode = UserInfo.compCode;
            	 
            	 
            	 
            	 var r = {
//            	 	COMP_CODE : compCode,
		        };
				masterGrid.createRow(r);
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			},*/
		onResetButtonDown: function() {	
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			masterStore.saveStore();
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
			if(!panelSearch.getInvalidMessage()) {
				return false;
			}
			
			var param = {
				'COMP_CODE'     : UserInfo.compCode,
				'INOUT_DIVI'    : panelResult.getValue('cboInoutDivi'),
				'BILL_TYPE'     : panelResult.getValue('cboBillType'),
				'FR_DATE'       : UniDate.getDbDateStr(panelSearch.getValue('txtFrPubDate')),
				'TO_DATE'       : UniDate.getDbDateStr(panelSearch.getValue('txtToPubDate'))
			};
			
			atx490ukrService.fnDeleteAll(param, function(provider, response){
				if(provider) {
					Ext.Msg.alert('Success', '전체삭제 되었습니다.');
					UniAppManager.app.onQueryButtonDown();
				}
				else {
					Ext.Msg.alert('Error', provider);
				}
			});
		},
		setDefault: function() {
        	panelSearch.setValue('txtFrPubDate',UniDate.get('startOfMonth'));
        	panelSearch.setValue('txtToPubDate',UniDate.get('today'));
        	panelSearch.setValue('txtBillDivCode',baseInfo.gsBillDivCode);
        	panelSearch.setValue('cboBillType',sRefcode2);
        	panelSearch.setValue('rdoAccrue','N');
        	panelSearch.setValue('rdoStatCode','');
        	panelSearch.setValue('rdoEncryptCode','Y');
        	
        	panelResult.setValue('txtFrPubDate',UniDate.get('startOfMonth'));
        	panelResult.setValue('txtToPubDate',UniDate.get('today'));
        	panelResult.setValue('txtBillDivCode',baseInfo.gsBillDivCode);
        	panelResult.setValue('cboBillType',sRefcode2);
        	panelResult.setValue('rdoAccrue','N');
        	panelResult.setValue('rdoStatCode','');
        	panelResult.setValue('rdoEncryptCode','Y');

        	if(panelSearch.getValue('cboBillType') == '20') {
                Ext.getCmp('btn11').setDisabled(true);
                Ext.getCmp('btn20').setDisabled(false);
                
        	} else {
                Ext.getCmp('btn11').setDisabled(false);
                Ext.getCmp('btn20').setDisabled(true);
        	}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	
	
	
	function openExcelWindow(pBillType) {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		var configId = 'atx490ukr_1';
		
		if(pBillType == '20') {
			configId = 'atx490ukr_2';
		}
		
		if(!panelSearch.getInvalidMessage()) {
			return false;
		}
		
		if(!masterStore.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
			masterStore.loadData({});
		} else {
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
				masterStore.loadData({});
			}
		}
		
		if(!Ext.isEmpty(excelWindow)){
//			excelWindow.excelConfigName		= configId;
//			excelWindow.extParam.COMP_CODE	= UserInfo.compCode;
//			excelWindow.extParam.DIV_CODE	= panelResult.getValue('txtBillDivCode');                          //신고사업장
//			excelWindow.extParam.INOUT_DIVI	= panelResult.getValue('cboInoutDivi');                            //매입매출구분
//			excelWindow.extParam.BILL_TYPE	= panelResult.getValue('cboBillType');                             //계산서유형 (11:세금계산서, 20:계산서)
//			excelWindow.extParam.FR_DATE	= UniDate.getDbDateStr(panelSearch.getValue('txtFrPubDate'));
//			excelWindow.extParam.TO_DATE	= UniDate.getDbDateStr(panelSearch.getValue('txtToPubDate'));
//			excelWindow.extParam.USER_ID	= UserInfo.userID;
			
			excelWindow = null;
		}
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: configId,
				width		: 600,
				height		:  93,
				modal		: false,
				resizable	: false,
				extParam: {
					'COMP_CODE'     : UserInfo.compCode,
					'PGM_ID'        : configId,
					'DIV_CODE'      : panelResult.getValue('txtBillDivCode'),                         //신고사업장
					'INOUT_DIVI'    : panelResult.getValue('cboInoutDivi'),                           //매입매출구분
					'BILL_TYPE'     : panelResult.getValue('cboBillType'),                            //계산서유형 (11:세금계산서, 20:계산서)
					'FR_DATE'       : UniDate.getDbDateStr(panelSearch.getValue('txtFrPubDate')),
					'TO_DATE'       : UniDate.getDbDateStr(panelSearch.getValue('txtToPubDate')),
					'USER_ID'       : UserInfo.userID
				},
				listeners: {
					close: function() {
						this.hide();
					}
				},
				uploadFile: function() {
					var me = this,
						frm = me.down('#uploadForm').getForm(),
						param = me.extParam;
					
					atx490ukrService.fnDeleteAll(param, function(provider, response){
						if (!Ext.isEmpty(provider)) {
							frm.submit({
								params  : me.extParam,
								waitMsg : 'Uploading...',
								success : function(form, action) {
									var param = {
										jobID : action.result.jobID
									};
									atx490ukrService.getErrMsg(param, function(provider, response){
										if (Ext.isEmpty(provider)) {
											Ext.Msg.alert('Success', 'Upload 성공 하였습니다.');
											
											me.hide();
											UniAppManager.app.onQueryButtonDown();
										} else {
											alert(provider);
										}
									});
								},
								failure: function(form, action) {
									Ext.Msg.alert('Failed', action.result.msg);
								}
							});
						}
						else {
							alert(provider);
						}
					});
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [{
						xtype: 'button',
						text : '업로드',
						tooltip : '업로드', 
						handler: function() { 
							me.jobID = null;
							me.uploadFile();
						}
					},
					'->',
					{
						xtype: 'button',
						text : '닫기',
						tooltip : '닫기', 
						handler: function() { 
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};


//    function openExcelWindow2() {
//        var me = this;
//        var vParam = {};
//        var appName = 'Unilite.com.excel.ExcelUpload';
//        
//        if(!panelSearch.getInvalidMessage()) {
//            return false;
//        }
//        
//        if(!masterStore.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
//            masterStore.loadData({});
//        } else {
//            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
//                UniAppManager.app.onSaveDataButtonDown();
//                return;
//            }else {
//                masterStore.loadData({});
//            }
//        }
//        if(!Ext.isEmpty(excelWindow2)){
//            excelWindow2.extParam.DIV_CODE   = panelResult.getValue('txtBillDivCode');                          //신고사업장
//            excelWindow2.extParam.INOUT_DIVI = panelResult.getValue('cboInoutDivi');                            //매입매출구분
//            excelWindow2.extParam.BILL_TYPE  = panelResult.getValue('cboBillType');                             //계산서유형 (11:세금계산서, 20:계산서)
//            excelWindow2.extParam.FR_DATE    = UniDate.getDbDateStr(panelSearch.getValue('txtFrPubDate'));
//            excelWindow2.extParam.TO_DATE    = UniDate.getDbDateStr(panelSearch.getValue('txtToPubDate'));
//        }
//        if(!excelWindow2) { 
//            excelWindow2 = Ext.WindowMgr.get(appName);
//            excelWindow2 = Ext.create( appName, {
//                excelConfigName: 'atx490ukr_2',
//                width   : 600,
//                height  : 200,
//                modal   : false,
//                extParam: { 
//                    'PGM_ID'        : 'atx490ukr_2',
//                    'DIV_CODE'      : panelResult.getValue('txtBillDivCode'),                         //신고사업장
//                    'INOUT_DIVI'    : panelResult.getValue('cboInoutDivi'),                           //매입매출구분
//                    'BILL_TYPE'     : panelResult.getValue('cboBillType'),                            //계산서유형 (11:세금계산서, 20:계산서)
//                    'FR_DATE'       : UniDate.getDbDateStr(panelSearch.getValue('txtFrPubDate')),
//                    'TO_DATE'       : UniDate.getDbDateStr(panelSearch.getValue('txtToPubDate'))
//                },
//                listeners: {
//                    close: function() {
//                        this.hide();
//                    }
//                },
//                uploadFile: function() {
//                    var me = this,
//                    frm = me.down('#uploadForm');
//                    frm.submit({
//                        params  : me.extParam,
//                        waitMsg : 'Uploading...',
//                        success : function(form, action) {
//                            var param = {
//                                 jobID : action.result.jobID
//                            }
//                            atx490ukrService.getErrMsg(param, function(provider, response){
//                                if (Ext.isEmpty(provider)) {
//                                    me.jobID = action.result.jobID;
//                                    me.readGridData(me.jobID);
//                                    me.down('tabpanel').setActiveTab(1);
//                                    Ext.Msg.alert('Success', 'Upload 성공 하였습니다.');
//                                    
//                                    me.hide();
//                                    UniAppManager.app.onQueryButtonDown();
//                                    
//                                } else {
//                                    alert(provider);
//                                }
//                            });
//                        },
//                        failure: function(form, action) {
//                            Ext.Msg.alert('Failed', action.result.msg);
//                        }
//                        
//                    });
//                },
//                
//                _setToolBar: function() {
//                    var me = this;
//                    me.tbar = [{
//                        xtype: 'button',
//                        text : '업로드',
//                        tooltip : '업로드', 
//                        handler: function() { 
//                            me.jobID = null;
//                            me.uploadFile();
//                        }
//                    },
//                    '->',
//                    {
//                        xtype: 'button',
//                        text : '닫기',
//                        tooltip : '닫기', 
//                        handler: function() { 
//                            me.hide();
//                        }
//                    }
//                ]}
//            });
//        }
//        excelWindow2.center();
//        excelWindow2.show();
//    };

};


</script>
