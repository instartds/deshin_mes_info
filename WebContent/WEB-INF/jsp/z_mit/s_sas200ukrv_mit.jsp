<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas200ukrv_mit"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas100ukrv_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="S162"/>								<!-- 장비유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S163"/>								<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S164"/>								<!-- 수리랭크 -->
	<t:ExtComboStore comboType="AU" comboCode="S802"/>								<!-- 유무상 -->
	<t:ExtComboStore comboType="AU" comboCode="S167"/>								<!-- 유지보수등급 -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var fda = ${FDA}
	
	function getFDAQuestion(id)	{
		var r = "";
		Ext.each(fda, function(item){
			if(id == item.codeNo)	{
				r = item.codeName;
			}
		});
		return r;
	} 
	
	var ynComboStore = Ext.create('Ext.data.Store', {
	    fields: ['value', 'text'],
	    data : [
	        {'value':'Y', 'text':'예'},
	        {'value':'N', 'text':'아니오'}
	    ]
	});
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_sas200ukrv_mitService.selectDetail',
			create: 's_sas200ukrv_mitService.insertDetail',
			update: 's_sas200ukrv_mitService.updateDetail',
			destroy: 's_sas200ukrv_mitService.deleteDetail',
			syncAll: 's_sas200ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_sas200ukrv_mitModel', {
	    fields: [  	  
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120', allowBlank:false},
			{name: 'QUOT_NUM'      	    , text: '수리견적번호' 																, type: 'string'},
			{name: 'QUOT_SEQ'      	    , text: '<t:message code="system.label.sales.repairestimateseq" default="순번"/>' 	, type: 'string'},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>' 				, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 			, type: 'string'},
	    	{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string', editable : false},
	    	{name: 'AS_QTY'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'					, type: 'uniQty'},
	    	{name: 'AS_UNIT'			, text: '<t:message code="system.label.sales.unit" default="단위"/>'					, type: 'string', comboType:'AU', comboCode:'B013'},
	    	{name: 'AS_PRICE'			, text: '<t:message code="system.label.sales.issueprice" default="출고단가"/>'		, type: 'uniUnitPrice'},
	    	{name: 'AS_AMT'				, text: '<t:message code="system.label.sales.issueamount2" default="출고금액"/>'		, type: 'uniPrice'},
	    	{name: 'STOCK_YN'			, text: '<t:message code="system.label.sales.inventoryyn" default="재고여부"/>'		, type: 'string' , store:ynComboStore},
	    	{name: 'AS_REMARK'			, text: '<t:message code="system.label.sales.remarks" default="비고"/>'				, type: 'string'},
	    	{name: 'TAX_AMT'			, text: '부가세'																		, type: 'uniPrice' 	, editable:false},
	    	{name: 'TOT_AMT'			, text: '총액'																		, type: 'uniPrice'	, editable:false},
	    	{name: 'PABSTOCK_YN'		, text: '가용재고적용여부'		, type: 'string' },
	    ]
	});
	
	var directMasterStore = Unilite.createStore('s_sas200ukrv_mitMasterStore',{
		model: 's_sas200ukrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();			
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= Ext.Object.merge(panelResult.getValues(), masterForm.getValues()); ;
			Ext.each(this.getData().items, function(record)	{
				if(Ext.isEmpty(record.get("QUOT_NUM")))	{
					record.set("QUOT_NUM", paramMaster.QUOT_NUM);
				}
			})
			
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(Ext.isEmpty(masterForm.getValue('QUOT_NUM') ) )	{
							console.log("batch : ", batch)
							if(batch.operations && batch.operations.length > 0 && batch.operations[0]._resultSet)	{
								masterForm.uniOpt.inLoading = true;
								masterForm.setValue('QUOT_NUM', batch.operations[0]._resultSet.QUOT_NUM);
								panelResult.setValue('QUOT_NUM', batch.operations[0]._resultSet.QUOT_NUM);
								masterForm.uniOpt.inLoading = false;
							}
							masterForm.getForm().wasDirty = false;
							masterForm.resetDirtyStatus()
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.setToolbarButtons(['deleteAll'],true);
						} 
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'0 0 0 0',
		border : 0,
		bodyStyle : {'background-color':'#fff;border-width: 0px;'},
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			width       : 230,
			labelWidth   : 90,
			listeners:{
				change:function(field, newValue, oldValue){
					if(newValue != oldValue)	{
						if(!masterForm.uniOpt.inLoading && !Ext.isEmpty(masterForm.getValue("QUOT_NUM")))	{
							//Unilite.messageBox("신규버튼을 누른 후 변경하세요.");
							return false;
						} else {
							masterForm.uniOpt.inLoading = true;
							masterForm.setValue('DIV_CODE', newValue);
							masterForm.setValue('RECEIPT_NUM', '');
							masterForm.setValue('MACHINE_TYPE', 'H');
							masterForm.setValue('COST_YN', 'Y');
							masterForm.uniOpt.inLoading = false;
						
							panelResult.setValue('RECEIPT_NUM', '');
							panelResult.setValue('RECEIPT_DATE', '');
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
							panelResult.setValue('SPEC', '');
							panelResult.setValue('SERIAL_NO', '');
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
							panelResult.setValue('RECEIPT_PRSN', '');
							panelResult.setValue('USER_NAME', '');
							panelResult.setValue('REPAIR_YN', '');
							panelResult.setValue('REPAIR_RANK', '');
							panelResult.setValue('SALE_DATE', '');
							panelResult.setValue('WARR_MONTH', '');
							panelResult.setValue('WARR_DATE','');
							panelResult.setValue('REMARK', '');
							panelResult.setValue('MACHINE_TYPE', '');
						}
					}
				}
			}
		},{
			xtype: 'uniTextfield',
			fieldLabel		: '<t:message code="system.label.sales.repairestimatenum" default="수리견적번호"/>',
    		name: 'QUOT_NUM',
    		readOnly:true
		},{
			fieldLabel		: '<t:message code="system.label.sales.repairestimatedate" default="수리견적일"/>',
			xtype			: 'uniDatefield',
			name		    : 'QUOT_DATE',
			allowBlank	    : false,
			labelWidth      : 90
		},{
			xtype : 'button',
			width:100,
			tdAttrs:{'align' :'right', width:120},
			text : '<t:message code="system.label.sales.referenceasreceipt" default="A/S 접수 참조"/>',
			handler: function(){
				var receiptPopup = panelResult.down("#RECEIPT_NUM_POPUP");
				receiptPopup.openPopup();
			}
		},{
			xtype : 'button',
			width:100,
			tdAttrs:{'align' :'right', width:120},
			text : '<t:message code="system.label.sales.repairhistory" default="수리이력"/>',
			handler: function(){
				if(Ext.isEmpty(panelResult.getValue("SERIAL_NO")))	{
					Unilite.messageBox('S/N을 입력하세요.');
					return;
				}
				var repairHistoryPopup = panelResult.down("#REPAIR_HISTORY_POPUP");
				repairHistoryPopup.openPopup();
			}
		},
		Unilite.popup('AS_REPAIR_HISTORY', {
			fieldLabel: '<t:message code="system.label.sales.repairhistory" default="수리이력"/>',
			textFieldName:'REPAIR_NUM1',
			DBtextFieldName: 'REPAIR_NUM1',
			itemId : 'REPAIR_HISTORY_POPUP',
			hidden :true,
			popupWidth : 1250,
        	listeners:{
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': masterForm.getValue("DIV_CODE"), 'SERIAL_NO': panelResult.getValue("SERIAL_NO")});
				}
        	}
	  }),Unilite.popup('AS_REPAIR_NUM', {
			fieldLabel: '수리내역',
			textFieldName:'REPAIR_NUM',
			DBtextFieldName: 'REPAIR_NUM',
			itemId : 'REPAIR_NUM_POPUP',
			hidden : true,
        	listeners:{
        		onSelected: {
					fn: function(records, type) {
						if(records) {
							panelResult.setValue('DIV_CODE', records[0]["DIV_CODE"]);
							panelResult.setValue('QUOT_NUM', records[0]["QUOT_NUM"]);
							UniAppManager.app.onQueryButtonDown();
						}
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'RECEIPT_NUM': panelResult.getValue("RECEIPT_NUM_POPUP"),  'SERIAL_NO':panelResult.getValue("SERIAL_NO")});
				}
        	}
        }),
		{
			xtype :'fieldset',
			colspan : 5,
			title :'<t:message code="system.label.sales.asreceiptcontent" default="A/S 접수 내역"/>',
			layout :{ type :'uniTable', columns:3},
			tdAttrs : {style:'padding:0px 0px 0px 10px;'},
			items:[
				Unilite.popup('AS_RECEIPT_NUM', {
					fieldLabel: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>',
					textFieldName:'RECEIPT_NUM_POP',
					DBtextFieldName: 'RECEIPT_NUM',
					itemId : 'RECEIPT_NUM_POPUP',
					hidden : true,
		        	listeners:{
		        		onSelected: {
							fn: function(records, type) {
								if(records) {
									if(!Ext.isEmpty(masterForm.getValue("QUOT_NUM")))	{
										if(confirm("조회된 수리견적번호가 있습니다. 신규로 등록하시겠습니까?"))	{
											 UniAppManager.app.onResetButtonDown();
										}	
									}
									masterForm.uniOpt.inLoading = true;
									panelResult.setValue('DIV_CODE', records[0]["DIV_CODE"]);
									panelResult.setValue('RECEIPT_NUM', records[0]["RECEIPT_NUM"]);
									panelResult.setValue('RECEIPT_DATE', records[0]["RECEIPT_DATE"]);
									panelResult.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
									panelResult.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
									panelResult.setValue('SPEC', records[0]["SPEC"]);
									panelResult.setValue('SERIAL_NO', records[0]["SERIAL_NO"]);
									panelResult.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
									panelResult.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
									panelResult.setValue('RECEIPT_PRSN', records[0]["RECEIPT_PRSN"]);
									panelResult.setValue('USER_NAME', records[0]["USER_NAME"]);
									panelResult.setValue('REPAIR_YN', records[0]["REPAIR_YN"]);
									panelResult.setValue('REPAIR_RANK', records[0]["REPAIR_RANK"]);
									panelResult.setValue('SALE_DATE', records[0]["SALE_DATE"]);
									panelResult.setValue('WARR_MONTH', records[0]["WARR_MONTH"]);
									panelResult.setValue('WARR_DATE', records[0]["WARR_DATE"]);
									panelResult.setValue('REMARK', records[0]["REMARK"]);
									panelResult.setValue('MACHINE_TYPE', records[0]["MACHINE_TYPE"]);
									
									masterForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
									masterForm.setValue('RECEIPT_NUM', records[0]["RECEIPT_NUM"]);
									masterForm.setValue('MACHINE_TYPE', records[0]["MACHINE_TYPE"]);
									masterForm.setValue('COST_YN', Unilite.nvl(records[0]["COST_YN"], 'Y'));
									masterForm.setValue('WON_CALC_BAS', records[0]["WON_CALC_BAS"]);
									masterForm.setValue('TAX_TYPE', records[0]["TAX_TYPE"]);
									masterForm.setValue('WON_CALC_BAS', records[0]["WON_CALC_BAS"]);
									masterForm.setValue('TAX_TYPE', records[0]["TAX_TYPE"]);
									
									masterForm.uniOpt.inLoading = false;
								}
							},
							scope: this
						},
						onClear: function(type) {
							
							panelResult.setValue('DIV_CODE', '');
							panelResult.setValue('RECEIPT_NUM', '');
							panelResult.setValue('RECEIPT_DATE', '');
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
							panelResult.setValue('SPEC', '');
							panelResult.setValue('SERIAL_NO', '');
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
							panelResult.setValue('RECEIPT_PRSN', '');
							panelResult.setValue('USER_NAME', '');
							panelResult.setValue('REPAIR_YN', '');
							panelResult.setValue('REPAIR_RANK', '');
							panelResult.setValue('SALE_DATE', '');
							panelResult.setValue('WARR_MONTH', '');
							panelResult.setValue('WARR_DATE','');
							panelResult.setValue('REMARK', '');
							panelResult.setValue('MACHINE_TYPE', '');
							
							masterForm.setValue('DIV_CODE', '');
							masterForm.setValue('RECEIPT_NUM', '');
							masterForm.setValue('MACHINE_TYPE', '');
							masterForm.setValue('COST_YN', '');
							masterForm.setValue('WON_CALC_BAS', '');
							masterForm.setValue('TAX_TYPE', '');
						},
						applyextparam: function(popup){
							
							popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'RECEIPT_NUM': panelResult.getValue("RECEIPT_NUM_POPUP"), 'AS_STATUS' : '10'});
						}
		        	}
		        }),{
					xtype: 'uniTextfield',
		    		fieldLabel: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>',
		    		name: 'RECEIPT_NUM',
		    		readOnly : true
				},{
					xtype: 'uniCombobox',
		    		fieldLabel: '<t:message code="system.label.sales.equipmenttype" default="장비유형"/>',
		    		name: 'MACHINE_TYPE',
					comboType : 'AU',
					comboCode : 'S162',
		    		readOnly : true	,
		    		colspan : 2
				},{
					xtype: 'uniTextfield',
		    		fieldLabel: '<t:message code="system.label.sales.asserialno" default="S/N"/>',
		    		name: 'SERIAL_NO',
		    		readOnly : true
				},Unilite.popup('DIV_PUMOK', {
					extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153}],
		    		readOnly : true,
					colspan : 2
		        }),Unilite.popup('CUST',{
		    		readOnly : true
	        	})
		        ,{
	        		xtype:'uniDatefield',
	        		fieldLabel:'<t:message code="system.label.sales.saledate" default="판매일"/>',
	        		name:'SALE_DATE',
		    		readOnly : true
	        	},{
					fieldLabel : '<t:message code="system.label.sales.warranty" default="보증기간"/>'  ,
					name : 'WARR_MONTH',
					xtype : 'uniCombobox',
					comboType : 'AU',
					comboCode : 'S166',
		    		readOnly : true
				},Unilite.popup('USER' , {
					xtype:'uniPopupField',
					fieldLabel : '<t:message code="system.label.sales.receiptperson" default="접수자"/>',
					valueFieldName:'RECEIPT_PRSN',
					textFieldName:'USER_NAME',
		    		readOnly : true
	   			}),{
					xtype: 'uniDatefield',
		    		fieldLabel: '<t:message code="system.label.sales.receiptdate2" default="접수일"/>',
		    		name: 'RECEIPT_DATE',
		    		readOnly : true
				},{
	        		xtype:'uniDatefield',
	        		fieldLabel:'<t:message code="system.label.sales.warrantyDate" default="보증일"/>',
	        		name:'WARR_DATE',
		    		readOnly : true
	        	},{
					xtype :'textarea',
					fieldLabel:'<t:message code="system.label.sales.receiptremark" default="접수내역"/>',
					name : 'REMARK',
		    		readOnly : true,
					height : 100,
					width : 895,
					colspan : 3
				}
			]
			
		}
		]
	});	
	
	
	var masterForm = Unilite.createForm('s_sas100ukrv_mitMasterForm',{		
    	region: 'north',		
    	autoScroll: true,  		
    	padding: '0 0 0 0' ,	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 0px;'},
    	heighr : 600,
    	layout : {type : 'uniTable', columns : 3}, 
		items: [{
			xtype:'container',
			colspan: 3,
			layout:{type:'uniTable', columns:5, tableAttrs:{height:30}},
			items:[{
					xtype:'component',
					html:'&nbsp;',
					width : 600
				},{
					xtype : 'button',
					width:100,
					tdAttrs:{'align' :'right', width:120},
					text : '<t:message code="system.label.sales.printestimateform" default="견적양식 출력"/>',
					handler: function(){
						var win;
						var param = {
								  'DIV_CODE'  : masterForm.getValue('DIV_CODE')
								, 'QUOT_NUM'  : masterForm.getValue('QUOT_NUM')
								, 'MAIN_CODE' : 'S036'
								, 'PGM_ID'    : PGM_ID
							};
						
						if(Ext.isEmpty(param.DIV_CODE) || Ext.isEmpty(param.QUOT_NUM) ) {
							Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
							return false;
						}
						
						win = Ext.create('widget.ClipReport', {
							url		: CPATH + '/z_mit/s_sas200clukrv2_mit.do',
							prgID	: 's_sas200ukrv_mit',
							extParam: param
						});
						win.center();
						win.show();
					}
				},{
					xtype : 'button',
					width:100,
					tdAttrs:{'align' :'right', width:120},
					text : '<t:message code="system.label.sales.printestimatedocument" default="견적서 출력"/>',
					handler: function(){
						var win;
						var param = {
								  'DIV_CODE'  : masterForm.getValue('DIV_CODE')
								, 'QUOT_NUM'  : masterForm.getValue('QUOT_NUM')
								, 'MAIN_CODE' : 'S036'
								, 'PGM_ID'    : PGM_ID
							}
						if(Ext.isEmpty(param.DIV_CODE) || Ext.isEmpty(param.QUOT_NUM) ) {
							Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
							return false;
						}
						
						win = Ext.create('widget.ClipReport', {
							url		: CPATH + '/z_mit/s_sas200clukrv_mit.do',
							prgID	: 's_sas200ukrv_mit',
							extParam: param
						});
						win.center();
						win.show();
					}
				},{
					xtype : 'button',
					width:100,
					tdAttrs:{'align' :'right', width:120},
					text : '<t:message code="system.label.sales.startrepair" default="수리진행"/>',
					handler: function(){
						if(!Ext.isEmpty(masterForm.getValue('QUOT_NUM')) && !Ext.isEmpty(masterForm.getValue('RECEIPT_NUM')) )	{
							var params = {
								DIV_CODE: masterForm.getValue("DIV_CODE"),
								QUOT_NUM: masterForm.getValue('QUOT_NUM'),
								RECEIPT_NUM: masterForm.getValue('RECEIPT_NUM')
							}
							var rec = {data : {prgID : 's_sas300ukrv_mit', 'text':''}};
							parent.openTab(rec, '/z_mit/s_sas300ukrv_mit.do', params);
						} else {
							Unilite.messageBox("수리견적등록 저장 후 진행할 수 있습니다.");
						}
					}
				},{
					xtype : 'button',
					width:100,
					tdAttrs:{'align' :'right', width:120},
					text : '<t:message code="system.label.sales.returnnonrepair" default="미수리반송"/>',
					hidden : true,
					handler: function(){
						if(confirm('미수리반송 하시겠습니까?'))	{
							var param = {
									DIV_CODE : masterForm.getValue("DIV_CODE"),
									RECEIPT_NUM : masterForm.getValue("RECEIPT_NUM"),
									AS_STATUS : '31'
							}
							s_sas100ukrv_mitService.updateASStatus(param, function(responseText){
								if(responseText)	{
									UniAppManager.updateStatus("미수리반송 되었습니다.");
								}
							})
						}
					}
				}
			]					
		},{
				fieldLabel : '<t:message code="system.label.sales.division" default="사업장"/>'  ,
				name : 'DIV_CODE',
				xtype : 'uniCombobox',
				comboType : 'BOR120',
				value : UserInfo.divCode,
				allowBlank : false,
				hidden :true
			}
			,
			Unilite.popup('AS_QUOT_NUM', {
				fieldLabel: '<t:message code="system.label.sales.repairestimatenum" default="수리견적번호"/>',
				textFieldName:'QUOT_NUM',
				DBtextFieldName: 'QUOT_NUM',
				itemId : 'QUOT_NUM_POPUP',
				hidden : true,
	        	listeners:{
	        		onSelected: {
						fn: function(records, type) {
							if(records) {
								masterForm.uniOpt.inLoading = true;
								masterForm.setValue('QUOT_NUM', records[0]["QUOT_NUM"]);
								masterForm.setValue('QUOT_DATE', records[0]["QUOT_DATE"]);
								panelResult.setValue('QUOT_NUM', records[0]["QUOT_NUM"]);
								panelResult.setValue('QUOT_DATE', records[0]["QUOT_DATE"]);
								masterForm.uniOpt.inLoading = false;
								UniAppManager.app.onQueryButtonDown();
							}
						},
						scope: this
					},
					onClear: function(type) {
						masterForm.setValue('QUOT_NUM', '');
						masterForm.setValue('QUOT_DATE', '');
						panelResult.setValue('QUOT_NUM', '');
						panelResult.setValue('QUOT_DATE', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'QUOT_NUM': panelResult.getValue("QUOT_NUM")});
					}
	        	}
		  }),{
				xtype: 'uniDatefield',
	    		fieldLabel: '<t:message code="system.label.sales.repairestimatedate" default="수리견적일"/>',
	    		name: 'QUOT_DATE',
	    		allowBlank :false,
	    		hidden : true
			},{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>',
	    		name: 'RECEIPT_NUM',
	    		allowBlank : false,
	    		hidden : true
			},{
				xtype: 'uniTextfield',
				fieldLabel: '<t:message code="system.label.sales.equipmenttype" default="장비유형"/>',
	    		name: 'MACHINE_TYPE',
	    		hidden : true
			},Unilite.popup('USER' , {
				xtype:'uniPopupField',
				fieldLabel : '<t:message code="system.label.sales.asestimateperson" default="견적자"/>',
				valueFieldName:'QUOT_PRSN',
				textFieldName:'USER_NAME',
				allowBlank : false
   			 })
        	,{
				fieldLabel : ''  ,//유무상
				fieldWidth : 0,
				name : 'COST_YN',
				xtype : 'uniRadiogroup',
				comboType : 'AU',
				allowBlank : false,
				comboCode : 'S802',
				width : 140
			},{
				fieldLabel : '<t:message code="system.label.sales.asrank" default="수리랭크"/>'  ,
				name : 'REPAIR_RANK',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S164'
			},{
        		xtype:'uniTextfield',
        		fieldLabel:'<t:message code="system.label.sales.repaircontent" default="불량내용"/>',
        		name:'BAD_REMARK',
        		width : 960,
        		colspan : 3
        	},{
        		xtype:'uniTextfield',
        		fieldLabel:'<t:message code="system.label.sales.estimatecontent" default="견적전달내용"/>',
        		name:'REMARK',
        		width : 960,
        		colspan : 3
        	},{ xtype : 'container',
				colspan : 3,
				layout : {type : 'uniTable', columns:'3', tdAttrs: {style:"vertical-align:top;"}},
				items:[{
						xtype :'component',
						tdAttrs: {style:"text-align:right;;padding-right:15px;vertical-align:top;"},
						html  : '<span>FDA1 : </span>',
						width : 90
					},{
						xtype :'component',
						html  : '<span>'+getFDAQuestion("1")+'</span>',
						width : 650
						
					},{
						xtype : 'uniRadiogroup',
						name:'FDA_Q1_YN',
						items : [
							{name:'FDA_Q1_YN', boxLabel:'YES' , inputValue : 'Y' , width : 60 , style : 'margin-left : 30px;', id : 'FDA_Q1_Y'},
							{name:'FDA_Q1_YN', boxLabel:'NO'  , inputValue : 'N' , width : 60 , id : 'FDA_Q1_N'}
						]
					}
				]
			},{ xtype : 'container',
				colspan : 3,
				layout : {type : 'uniTable', columns:'3', tdAttrs: {style:"vertical-align:top;"}},
				items:[{
						xtype :'component',
						tdAttrs: {style:"text-align:right;padding-right:15px;vertical-align:top;"},
						html  : '<span style="vertical-align:top;">FDA2 : </span>',
						width : 90
					},{
						xtype :'component',
						html  : '<span>'+getFDAQuestion("2")+'</span>',
						width : 650
						
					},{
						xtype : 'uniRadiogroup',
						name:'FDA_Q2_YN',
						items : [
							{name:'FDA_Q2_YN', boxLabel:'YES' , inputValue : 'Y' , width : 60 , style : 'margin-left : 30px;', id : 'FDA_Q2_Y'},
							{name:'FDA_Q2_YN', boxLabel:'NO'  , inputValue : 'N' , width : 60 , id : 'FDA_Q2_N'}
						]
					}
				]
			},{ xtype : 'container',
				colspan : 3,
				layout : {type : 'uniTable', columns:'3', tdAttrs: {style:"vertical-align:top;"}},
				items:[{
						xtype :'component',
						tdAttrs: {style:"text-align:right;;padding-right:15px;"},
						html  : '<span style="vertical-align:top;">FDA3 : </span>',
						width : 90
					},{
						xtype :'component',
						html  : '<span>'+getFDAQuestion("3")+'</span>',
						width : 650
						
					},{
						xtype : 'uniRadiogroup',
						name:'FDA_Q3_YN',
						items : [
							{name:'FDA_Q3_YN', boxLabel:'YES' , inputValue : 'Y' , width : 60 , style : 'margin-left : 30px;', id : 'FDA_Q3_Y'},
							{name:'FDA_Q3_YN', boxLabel:'NO'  , inputValue : 'N' , width : 60 , id : 'FDA_Q3_N'}
						]
					}
				]
			},{
				xtype: 'uniTextfield',
	    		fieldLabel: '파일번호',
	    		name: 'FILE_NUM',
	    		hidden : true
			},{
				xtype: 'uniTextfield',
	    		fieldLabel: '업로드파일',
	    		name: 'ADD_FID',
	    		hidden : true
			},{
				xtype: 'uniTextfield',
	    		fieldLabel: '삭제파일',
	    		name: 'DEL_FID',
	    		hidden : true
			},{
				xtype: 'uniTextfield',
	    		fieldLabel: '원미만 계산법',
	    		name: 'WON_CALC_BAS',
	    		hidden : true
			},{
				xtype: 'uniTextfield',
	    		fieldLabel: '세액포함여부',
	    		name: 'TAX_TYPE',
	    		hidden : true
			}],
		api: {
			load: 's_sas200ukrv_mitService.selectMaster',
			submit: 's_sas200ukrv_mitService.syncMaster'				
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {				
				UniAppManager.setToolbarButtons('save', true);
			}
		}
	});
	
    var masterGrid = Unilite.createGrid('s_sas200ukrv_mitGrid', {
        store: directMasterStore,
    	excelTitle: '품목코드',
    	region: 'center',
    	flex:1,
    	split:true,
    	uniOpt:{expandLastColumn: false,},
    	tbar:[
    		{
    			fieldLabel:'<t:message code="system.label.sales.amountsumofselection" default="선택금액합계"/>',
    			xtype:'uniNumberfield',
    			name :'AMOUNT_SUM',
    			itemId : 'AMOUNT_SUM',
    			format:'0.000.00',
    			readOnly:true
    		}
    	],
    	selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : true }),
    	features: [ {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],//그룹 합계 관련
        columns:  [
        	{dataIndex: 'DIV_CODE'       	,		width: 70, hidden :true},
        	{dataIndex: 'QUOT_NUM'       	,		width: 100, hidden :true},
        	{dataIndex: 'QUOT_SEQ'       	,		width: 40, hidden :true},
        	{dataIndex: 'ITEM_CODE'	    	,		width: 100,
        	 editor:Unilite.popup('AS_PUMOK_MIT_G', {
        		textFieldName:'ITEM_CODE',
 				DBtextFieldName: 'ITEM_CODE',
 				autoPopup : true,
 				extParam : {'SELMODEL' : 'MULTI'},
        		 listeners:{
 	        		onSelected: {
 						fn: function(records, type) {
 							if(records) {
 								masterGrid.setItems(records);
 								/*
 								var record = masterGrid.uniOpt.currentRecord;
 								record.set('DIV_CODE', records[0]["DIV_CODE"]);
 								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
 								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
 								record.set('SPEC', records[0]["SPEC"]);
 								record.set('AS_UNIT', records[0]["STOCK_UNIT"]);
 								record.set('AS_PRICE', records[0]["PURCHASE_BASE_P"]);
 								*/
 							}
 						},
 						scope: this
 					},
 					onClear: function(type) {
 						var record = masterGrid.uniOpt.currentRecord;
 						record.set('DIV_CODE', '');
 						record.set('ITEM_CODE', '');
 						record.set('ITEM_NAME', '');
 						record.set('SPEC', '');
 						record.set('AS_UNIT', "");
						record.set('AS_PRICE', 0);
						record.set('STOCK_CARE_YN', '');
 					},
 					applyextparam: function(popup){
 						var record = masterGrid.uniOpt.currentRecord;
 						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE"), 'CUSTOM_CODE' : panelResult.getValue("CUSTOM_CODE")});
 					}
 	        	}
        	 }),
        	 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
			 }	
        	},
        	{dataIndex: 'ITEM_NAME'	    	,		width: 230,
        		editor:Unilite.popup('AS_PUMOK_MIT_G', {
     				autoPopup : true,
     				extParam : {'SELMODEL' : 'MULTI'},
            		 listeners:{
     	        		onSelected: {
     						fn: function(records, type) {
     							if(records) {
     								masterGrid.setItems(records);
     								/* var record = masterGrid.uniOpt.currentRecord;
     								record.set('DIV_CODE', records[0]["DIV_CODE"]);
     								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
     								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
     								record.set('SPEC', records[0]["SPEC"]);
     								record.set('AS_UNIT', records[0]["STOCK_UNIT"]);
     								record.set('AS_PRICE', records[0]["PURCHASE_BASE_P"]); */
     							}
     						},
     						scope: this
     					},
     					onClear: function(type) {
     						var record = masterGrid.uniOpt.currentRecord;
     						record.set('DIV_CODE', '');
     						record.set('ITEM_CODE', '');
     						record.set('ITEM_NAME', '');
     						record.set('SPEC', '');
     						record.set('AS_UNIT', "");
							record.set('AS_PRICE', 0);
     					},
     					applyextparam: function(popup){
     						var record = masterGrid.uniOpt.currentRecord;
     						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE"), 'CUSTOM_CODE' : panelResult.getValue("CUSTOM_CODE")});
     					}
     	        	}
            	 })
        	},
        	{dataIndex: 'SPEC'	    		,		width: 230},
        	{dataIndex: 'AS_QTY'	    	,		width: 80, summaryType:'sum'},
        	{dataIndex: 'AS_UNIT'	    	,		width: 80},
        	{dataIndex: 'AS_PRICE'	    	,		width: 80},
        	{dataIndex: 'AS_AMT'	    	,		width: 80, summaryType:'sum'},
        	{dataIndex: 'TAX_AMT'	    	,		width: 80, summaryType:'sum'},
        	{dataIndex: 'TOT_AMT'	    	,		width: 80, summaryType:'sum'},
        	{dataIndex: 'STOCK_YN'	   		,		width: 80},
        	{dataIndex: 'AS_REMARK'	    	,		minValue : 100, flex:1}
		],
		listeners:{
			selectionchange:function(grid, selected)	{
				/* var sum = 0;
				//var selectedRecords = masterGrid.getSelectedRecords();
				Ext.each(selected,function(record){
					sum += sum + record.get("AS_AMT");
				});
				var sumField = masterGrid.down('#AMOUNT_SUM');
				sumField.setValue(sum); */
				masterGrid.setSelectionSummary(selected);
			},
			beforeedit: function( editor, e, eOpts ) {
				if(e.field == 'AS_PRICE' && e.record.get("STOCK_CARE_YN")=="Y") {
					return false;
				} else if(e.field == 'TOT_AMT' && e.field == 'TAX_AMT')	{
					return false;
				} else {
					return true;
				}
			} 
		}
    	,setSelectionSummary : function(selected) {
    		var sum = 0;
			//var selectedRecords = masterGrid.getSelectedRecords();
			Ext.each(selected,function(record){
				sum = sum + parseInt(record.get("AS_AMT"));
			});
			var sumField = masterGrid.down('#AMOUNT_SUM');
			sumField.setValue(sum);
    	}
    	,setItems : function(records) {
    		Ext.each(records, function(record, idx){
    			if(idx == 0)	{
    				var curRecord = masterGrid.uniOpt.currentRecord;
    					curRecord.set('DIV_CODE', record["DIV_CODE"]);
    					curRecord.set('ITEM_CODE', record["ITEM_CODE"]);
    					curRecord.set('ITEM_NAME', record["ITEM_NAME"]);
    					curRecord.set('SPEC', record["SPEC"]);
    					curRecord.set('AS_UNIT', record["STOCK_UNIT"]);
    					if(record["TYPE"] == '2') {
    						curRecord.set('AS_PRICE', record["PURCHASE_P"]);
    					} else {
    						curRecord.set('AS_PRICE', record["SALE_BASIS_P"]);
    					}
    					if(record["PABSTOCK_YN"] == "Y" && record["STOCK_Q"] > 0 )	{
    						curRecord.set('STOCK_YN', "Y");
    					}
    					curRecord.set('STOCK_CARE_YN', record["STOCK_CARE_YN"]);
    			} else {
    				var r = {
    						'DIV_CODE' : record['DIV_CODE'],
    						'ITEM_CODE' : record['ITEM_CODE'],
    						'ITEM_NAME' : record['ITEM_NAME'],
    						'SPEC' : record['SPEC'],
    						'AS_UNIT' : record['STOCK_UNIT'],
    						'AS_PRICE' : record["TYPE"] == '2' ?  record["PURCHASE_P"] : record['SALE_BASIS_P'],
    						'STOCK_CARE_YN' : record['STOCK_CARE_YN'],
    						'STOCK_YN' : (record["PABSTOCK_YN"] == "Y" && record["STOCK_Q"] > 0 ) ? "Y" : ""
    				}
    				masterGrid.createRow(r);
    			}
    		})
    	}
    });  
    
	Unilite.Main( {
		borderItems:[
			{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					panelResult, 
					masterForm, 
					masterGrid,
				    {
		     			xtype:'xuploadpanel',
		     			region :'south',
		     			id : 's_sas200ukrv_mitFileUploadPanel',
				    	itemId:'fileUploadPanel',
				    	height: 80,
				    	listeners : {
				    		change: function() {
				    			UniAppManager.setToolbarButtons('save', true);
				    		}
				    	}
			    	} 
				]	
			}
		],
		id: 's_sas200ukrv_mitApp',
		fnInitBinding : function(param) {

			masterForm.uniOpt.inLoading = true;
			Ext.getCmp("FDA_Q1_Y").setValue(false);
			Ext.getCmp("FDA_Q1_N").setValue(true);
			Ext.getCmp("FDA_Q2_Y").setValue(false);
			Ext.getCmp("FDA_Q2_N").setValue(true);
			Ext.getCmp("FDA_Q3_Y").setValue(false);
			Ext.getCmp("FDA_Q3_N").setValue(true);
			masterForm.uniOpt.inLoading = false;
			masterForm.clearForm();
			panelResult.clearForm();
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData','delete','deleteAll'],false);
			var quotNum = ""
			var receiptNum = ""
			if(!Ext.isEmpty(param) && !Ext.isEmpty(param.QUOT_NUM))	{
				quotNum = param.QUOT_NUM;
			}
			if(!Ext.isEmpty(param) && !Ext.isEmpty(param.RECEIPT_NUM))	{
				receiptNum = param.RECEIPT_NUM;
			}
			try{
				masterGrid.reset();
				directMasterStore.clearData();
				var fp = Ext.getCmp('s_sas200ukrv_mitFileUploadPanel');
				fp.clear();
			} catch(e)	{
				console.log("initBinding : ", e);
			}
			if(!Ext.isEmpty(receiptNum) && Ext.isEmpty(quotNum)) {
				panelResult.setValue("DIV_CODE", param.DIV_CODE);
				panelResult.setValue("QUOT_DATE", UniDate.today());
				masterForm.uniOpt.inLoading = true;
				masterForm.setValue("QUOT_PRSN", UserInfo.userID);
				masterForm.setValue("USER_NAME", UserInfo.userName);
				masterForm.setValue("COST_YN", "Y");
				masterForm.setValue("QUOT_DATE", UniDate.today());
				masterForm.uniOpt.inLoading = false;
				Ext.getBody().mask();
				s_sas100skrv_mitService.selectASList({'RECEIPT_NUM' :param.RECEIPT_NUM,  'DIV_CODE': param.DIV_CODE},
						function(resonseText)	{
							Ext.getBody().unmask();
							if(resonseText && resonseText[0])	{
								panelResult.setValue("DIV_CODE", resonseText[0].DIV_CODE);
								panelResult.setValue('RECEIPT_NUM', resonseText[0].RECEIPT_NUM);
								panelResult.setValue('RECEIPT_DATE', resonseText[0].RECEIPT_DATE);
								panelResult.setValue('ITEM_CODE', resonseText[0].ITEM_CODE);
								panelResult.setValue('ITEM_NAME', resonseText[0].ITEM_NAME);
								panelResult.setValue('SPEC', resonseText[0].SPEC);
								panelResult.setValue('SERIAL_NO', resonseText[0].SERIAL_NO);
								panelResult.setValue('CUSTOM_CODE', resonseText[0].CUSTOM_CODE);
								panelResult.setValue('CUSTOM_NAME', resonseText[0].CUSTOM_NAME);
								panelResult.setValue('RECEIPT_PRSN', resonseText[0].RECEIPT_PRSN);
								panelResult.setValue('USER_NAME', resonseText[0].USER_NAME);
								panelResult.setValue('SALE_DATE', resonseText[0].SALE_DATE);
								panelResult.setValue('WARR_MONTH', resonseText[0].WARR_MONTH);
								panelResult.setValue('WARR_DATE', resonseText[0].WARR_DATE);
								panelResult.setValue('REMARK', resonseText[0].RECEIPT_REMARK);
								panelResult.setValue('MACHINE_TYPE', resonseText[0].MACHINE_TYPE);
								if(!Ext.isEmpty(resonseText[0].QUOT_NUM)){
									panelResult.setValue("QUOT_NUM", resonseText[0].QUOT_NUM);
									panelResult.setValue("QUOT_DATE", resonseText[0].QUOT_DATE)
									masterForm.uniOpt.inLoading = true;
									masterForm.setValue("DIV_CODE", resonseText[0].DIV_CODE);
									masterForm.setValue("RECEIPT_NUM", resonseText[0].RECEIPT_NUM);
									masterForm.setValue("COST_YN",  resonseText[0].COST_YN);
									masterForm.setValue("QUOT_NUM", resonseText[0].QUOT_NUM);
									masterForm.setValue("QUOT_DATE", resonseText[0].QUOT_DATE);
									masterForm.setValue("QUOT_PRSN", resonseText[0].QUOT_PRSN);
									masterForm.setValue("USER_NAME", resonseText[0].QUOT_PRSN_NAME);
									masterForm.uniOpt.inLoading = false;
									setTimeout(UniAppManager.app.onQueryButtonDown(), 3000);
								} else {
									masterForm.setValue("DIV_CODE", resonseText[0].DIV_CODE);
									masterForm.setValue("RECEIPT_NUM", resonseText[0].RECEIPT_NUM);
									masterForm.setValue("COST_YN", resonseText[0].COST_YN);
									masterForm.setValue("WON_CALC_BAS", resonseText[0].WON_CALC_BAS);
									masterForm.setValue("TAX_TYPE", resonseText[0].TAX_TYPE);
								}
							} else {
								//masterForm.setValue("DIV_CODE", param.DIV_CODE);
								//masterForm.setValue("RECEIPT_NUM", param.RECEIPT_NUM);
								Unilite.messageBox("접수내역이 없습니다.")
							}		
						}
				)
			} else if(Ext.isEmpty(quotNum)) {
				panelResult.setValue("DIV_CODE", UserInfo.divCode);
				panelResult.setValue("QUOT_DATE", UniDate.today());
				masterForm.uniOpt.inLoading = true;
				masterForm.setValue("DIV_CODE", UserInfo.divCode);
				masterForm.setValue("QUOT_DATE", UniDate.today());
				masterForm.setValue("QUOT_PRSN", UserInfo.userID);
				masterForm.setValue("USER_NAME", UserInfo.userName);
				masterForm.setValue("COST_YN", "Y");
				masterForm.uniOpt.inLoading = false;
			}  else {
				panelResult.setValue("DIV_CODE", param.DIV_CODE);
				panelResult.setValue("QUOT_NUM", param.QUOT_NUM);
				panelResult.setValue("QUOT_DATE", UniDate.today());
				masterForm.uniOpt.inLoading = true;
				masterForm.setValue("DIV_CODE", param.DIV_CODE);
				masterForm.setValue("QUOT_NUM", param.QUOT_NUM);
				masterForm.uniOpt.inLoading = false;
				setTimeout(this.onQueryButtonDown(), 3000);
			}
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			var quotNum = panelResult.getValue("QUOT_NUM");
			var divCode = panelResult.getValue("DIV_CODE");
			if(!Ext.isEmpty(quotNum) && !Ext.isEmpty(divCode))	{
				if(masterForm.isVisible()) {
					masterForm.mask();
				}
				masterForm.uniOpt.inLoading = true;
				masterForm.getForm().load({
					params:{'QUOT_NUM' :quotNum, 'DIV_CODE': divCode},
					success: function(form, action)	{
						if(masterForm.isMasked()) {
							masterForm.unmask();
						}
						if(!Ext.isEmpty(action.result.data.QUOT_NUM))	{
							UniAppManager.setToolbarButtons(['deleteAll'],true);
						}
						panelResult.getField("DIV_CODE").setReadOnly(true);
						panelResult.getField("QUOT_DATE").setReadOnly(true);
						if(!Ext.isEmpty(action.result.data.RECEIPT_NUM))	{
							s_sas100skrv_mitService.selectASList({'RECEIPT_NUM' :action.result.data.RECEIPT_NUM, 'DIV_CODE': divCode},
									function(resonseText)	{
										if(resonseText && resonseText[0])	{
											panelResult.setValue('RECEIPT_NUM', resonseText[0].RECEIPT_NUM);
											panelResult.setValue('RECEIPT_DATE', resonseText[0].RECEIPT_DATE);
											panelResult.setValue('ITEM_CODE', resonseText[0].ITEM_CODE);
											panelResult.setValue('ITEM_NAME', resonseText[0].ITEM_NAME);
											panelResult.setValue('SPEC', resonseText[0].SPEC);
											panelResult.setValue('SERIAL_NO', resonseText[0].SERIAL_NO);
											panelResult.setValue('CUSTOM_CODE', resonseText[0].CUSTOM_CODE);
											panelResult.setValue('CUSTOM_NAME', resonseText[0].CUSTOM_NAME);
											panelResult.setValue('RECEIPT_PRSN', resonseText[0].RECEIPT_PRSN);
											panelResult.setValue('USER_NAME', resonseText[0].USER_NAME);
											panelResult.setValue('REPAIR_YN', resonseText[0].REPAIR_YN);
											panelResult.setValue('REPAIR_RANK', resonseText[0].REPAIR_RANK);
											panelResult.setValue('SALE_DATE', resonseText[0].SALE_DATE);
											panelResult.setValue('WARR_MONTH', resonseText[0].WARR_MONTH);
											panelResult.setValue('WARR_DATE', resonseText[0].WARR_DATE);
											panelResult.setValue('REMARK', resonseText[0].REMARK);
											panelResult.setValue('MACHINE_TYPE', resonseText[0].MACHINE_TYPE);
											directMasterStore.loadStoreRecords();
											setTimeout(function() {
												var fileNum = masterForm.getValue('FILE_NUM');
												bdc100ukrvService.getFileList({DOC_NO : fileNum},
													function(provider, response) {
														var fp = Ext.getCmp('s_sas200ukrv_mitFileUploadPanel');
														fp.loadData(response.result);
													}
												 )
											}, 1000);
										}		
									}
							);
						} else {
							directMasterStore.loadStoreRecords();
							setTimeout(function() {
								var fileNum = masterForm.getValue('FILE_NUM');
								bdc100ukrvService.getFileList({DOC_NO : fileNum},
									function(provider, response) {
										var fp = Ext.getCmp('s_sas200ukrv_mitFileUploadPanel');
										fp.loadData(response.result);
									}
								 )
							}, 1000);
						}
						masterForm.uniOpt.inLoading = false;
						//directMasterStore.loadStoreRecords();
					},
					failure : function()	{
						if(masterForm.isMasked()) {
							masterForm.unmask();
						}
						masterForm.uniOpt.inLoading = false;
					}
				})
			} else {
				var quotPopup = masterForm.down('#QUOT_NUM_POPUP');
				quotPopup.openPopup();
			}
		},
		onNewDataButtonDown: function()	{
			panelResult.getField("DIV_CODE").setReadOnly(true);
			panelResult.getField("QUOT_DATE").setReadOnly(true);
			
			if(Ext.isEmpty(masterForm.getValue("RECEIPT_NUM")))	{
				Unilite.messageBox("AS 접수내역을 선택하세요.");
				return;
			}
			
            var r = {
            	'DIV_CODE': panelResult.getValue("DIV_CODE"),
        	 	'QUOT_NUM': masterForm.getValue("QUOT_NUM")
	        };
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			masterForm.uniOpt.inLoading = true;
			panelResult.clearForm();
			directMasterStore.clearData();
			var fp = Ext.getCmp('s_sas200ukrv_mitFileUploadPanel');
			fp.clear();
			panelResult.getField("DIV_CODE").setReadOnly(false);
			panelResult.getField("QUOT_DATE").setReadOnly(false);
			
			

			masterForm.uniOpt.inLoading = false;
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			
			var fp = Ext.getCmp('s_sas200ukrv_mitFileUploadPanel');
			var addFiles = fp.getAddFiles();
			var removeFiles = fp.getRemoveFiles();
			if(masterForm.getValue('ADD_FID') != addFiles) masterForm.setValue('ADD_FID', addFiles);
			if(masterForm.getValue('DEL_FID') != removeFiles) masterForm.setValue('DEL_FID', removeFiles);
			
			if(masterForm.getInvalidMessage())	{
				if(directMasterStore.isDirty()) {
					directMasterStore.saveStore();
				} else if(masterForm.isDirty()) {
					masterForm.submit({
						success:function(form, action)	{
							if(Ext.isEmpty(masterForm.getValue('QUOT_NUM') ) )	{
								masterForm.uniOpt.inLoading = true;
								masterForm.setValue('QUOT_NUM', action.result.QUOT_NUM);
								panelResult.setValue('QUOT_NUM', action.result.QUOT_NUM);
								masterForm.uniOpt.inLoading = false;
								UniAppManager.setToolbarButtons(['deleteAll'],true);
							} 
							UniAppManager.updateStatus('<t:message code="system.message.commonJS.store.saved" default="저장되었습니다."/>');
							UniAppManager.setToolbarButtons('save',false);
						}
					});
				} 
			}			
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('삭제 하시겠습니까?')) {
				var divCode = masterForm.getValue('DIV_CODE')
				var quotNum = masterForm.getValue('QUOT_NUM');
				s_sas200ukrv_mitService.deleteMaster({
							DIV_CODE : divCode,
							QUOT_NUM : quotNum
						}, function(responseText){
							if(responseText) {
								UniAppManager.updateStatus("삭제되었습니다.");
								UniAppManager.app.onResetButtonDown();
							}
						});
			}
		},
		fnTaxCalculate: function(rtnRecord, dAmtO) {
			var sTaxType		= masterForm.getValue("TAX_TYPE");
			var sWonCalBas		=  masterForm.getValue("WON_CALC_BAS");

			var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
			var numDigitOfPrice	= UniFormat.Price.length - digit;
			var dVatRate = ${gsVatRate};
			var dTaxAmtO = 0;
			
			if(sTaxType =="1") {  
				dAmtO		= UniSales.fnAmtWonCalc(dAmtO, sWonCalBas, numDigitOfPrice);
				dTaxAmtO	= dAmtO * dVatRate / 100
				dTaxAmtO    = UniSales.fnAmtWonCalc(dTaxAmtO, sWonCalBas, numDigitOfPrice);	//세액은 절사처리함.
				
			} else if(sTaxType =="2") {
				dTemp	= UniSales.fnAmtWonCalc((dAmtO / ( dVatRate + 100 )) * 100, sWonCalBas, numDigitOfPrice);
				dTaxAmtO= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, sWonCalBas, numDigitOfPrice);	// 세액은 절사처리함.
				dAmtO = UniSales.fnAmtWonCalc((dAmtO - dTaxAmtO), rtnRecord.obj.get("WON_CALC_BAS"), numDigitOfPrice) ;
			}

			rtnRecord.obj.set('AS_AMT'	, dAmtO);
			rtnRecord.obj.set('TAX_AMT'	, dTaxAmtO);
			rtnRecord.obj.set('TOT_AMT'	, dAmtO+dTaxAmtO);
		}
	});
	
	Unilite.createValidator('validator01', {		//그리드 벨리데이터 관련		
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':''},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName){
				case "AS_QTY" : 
					var asPrice = record.get("AS_PRICE") ? record.get("AS_PRICE") : 0
					var asAmt = newValue * asPrice
					asAmt = UniAppManager.app.fnTaxCalculate(record, asAmt);
					break;
				case "AS_PRICE" : 
					var asQty = record.get("AS_QTY") ? record.get("AS_QTY") : 0
					var asAmt = newValue * asQty
					asAmt = UniAppManager.app.fnTaxCalculate(record, asAmt)
					break;
				case "AS_AMT" : 
					var asQty = Unilite.nvl(record.get("AS_QTY"), 0);
					if(asQty == 0)	{
						record.set('TAX_AMT', 0);
					} else {
						if(!Ext.isEmpty(record.get("TOT_AMT")) && record.get("TOT_AMT") != 0)	{
							var totAmt = Unilite.nvl(record.get("TOT_AMT"), 0);
							
							var taxAmt = totAmt - newValue;
							record.set('TAX_AMT', taxAmt)
						} else {
							UniAppManager.app.fnTaxCalculate(record, newValue)
						}
					}
					break;
				default:
				 	break;
			}
			return rv;
		}
	});
};


</script>
