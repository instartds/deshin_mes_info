<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas300ukrv_mit"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas100ukrv_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="S162"/>								<!-- 장비유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S164"/>								<!-- 수리랭크 -->
	<t:ExtComboStore comboType="AU" comboCode="S165"/>								<!-- 출고검사 -->
	<t:ExtComboStore comboType="AU" comboCode="S802"/>								<!-- 유무상 -->
	<t:ExtComboStore comboType="AU" comboCode="S167"/>								<!-- 유지보수등급 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>								<!-- 출고단가 -->
	<t:ExtComboStore comboType="AU" comboCode="S168"/>								<!-- 위치  -->
	<t:ExtComboStore comboType="AU" comboCode="S169"/>								<!-- 증상 -->
	<t:ExtComboStore comboType="AU" comboCode="S170"/>								<!-- 원인 -->
	<t:ExtComboStore comboType="AU" comboCode="S171"/>								<!-- 해결 -->
	<t:ExtComboStore comboType="AU" comboCode="S172"/>								<!-- 매핑 -->
	<t:ExtComboStore comboType="OU" />								                <!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	        <!--창고Cell-->
	
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  

	var ynComboStore = Ext.create('Ext.data.Store', {
	    fields: ['value', 'text'],
	    data : [
	        {'value':'Y', 'text':'예'},
	        {'value':'N', 'text':'아니오'}
	    ]
	});
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_sas300ukrv_mitService.selectDetail',
			update: 's_sas300ukrv_mitService.updateDetail',
			create: 's_sas300ukrv_mitService.insertDetail',
			destroy: 's_sas300ukrv_mitService.deleteDetail',
			syncAll: 's_sas300ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_sas300ukrv_mitModel', {
	    fields: [  	  
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.sales.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120', allowBlank:false, child: 'WH_CODE'},
			{name: 'REPAIR_NUM'      	, text: '<t:message code="system.label.sales.asrepairnum" default="수리번호"/>' 		, type: 'string', allowBlank:false},
			{name: 'REPAIR_SEQ'      	, text: '<t:message code="system.label.sales.repairestimateseq" default="순번"/>'	, type: 'string'},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>' 				, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 			, type: 'string'},
	    	{name: 'SPEC'				, text: '<t:message code="system.label.sales.spec" default="규격"/>'					, type: 'string', editable:false},
	    	{name: 'AS_QTY'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'					, type: 'uniQty'},
	    	{name: 'AS_UNIT'			, text: '<t:message code="system.label.sales.unit" default="단위"/>'					, type: 'string', comboType:'AU', comboCode:'B013'},
	    	{name: 'AS_PRICE'			, text: '<t:message code="system.label.sales.issueprice" default="출고단가"/>'		, type: 'uniUnitPrice'},
	    	{name: 'AS_AMT'				, text: '<t:message code="system.label.sales.issueamount2" default="출고금액"/>'		, type: 'uniPrice' },
	    	{name: 'LOT_NO'				, text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				, type: 'string'},
	    	{name: 'SERIAL_NO'			, text: 'Serial No.'																, type: 'string'},
	    	{name: 'LOT_YN'				, text: '<t:message code="system.label.common.lotmanageyn" default="LOT관리여부"/>'	, type: 'string'},
	    	{name: 'WH_CODE'			, text: '<t:message code="system.label.sales.warehouse" default="창고"/>'			, type: 'string', comboType:'OU', child: 'WH_CELL_CODE' },
	    	{name: 'WH_CELL_CODE'		, text: '<t:message code="system.label.sales.warehouse" default="창고"/> CELL'		, type: 'string', store : Ext.data.StoreManager.lookup("whCellList"), parentNames:['WH_CODE','DIV_CODE']},
	    	{name: 'INOUT_NUM'			, text: '자재출고번호'																, type: 'string' 	, editable:false},
	    	{name: 'INOUT_SEQ'			, text: '자재출고순번'																, type: 'string'	, editable:false},
	    	{name: 'TAX_AMT'			, text: '부가세'																		, type: 'uniPrice' 	, editable:false},
	    	{name: 'TOT_AMT'			, text: '총액'																		, type: 'uniPrice'	, editable:false},
	    	{name: 'AS_REMARK'			, text: '<t:message code="system.label.sales.remarks" default="비고"/>'				, type: 'string'},
	    	{name: 'STOCK_CARE_YN'		, text: 'STOCK_CARE_YN'																, type: 'string' , editable:false}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_sas300ukrv_mitMasterStore',{
		model: 's_sas300ukrv_mitModel',
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
			var paramMaster= masterForm.getValues();
			Ext.each(this.getData().items, function(record, idx)	{
				if(Ext.isEmpty(record.get("REPAIR_NUM")))	{
					record.set("REPAIR_NUM", paramMaster.REPAIR_NUM);
				}
			})
			paramMaster.CUSTOM_CODE = panelResult.getValue("CUSTOM_CODE");
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
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
						if(!masterForm.uniOpt.inLoading && !Ext.isEmpty(masterForm.getValue("REPAIR_NUM")))	{
							//Unilite.messageBox("신규버튼을 누른 후 변경하세요.");
							return false;
						} else {
							masterForm.uniOpt.inLoading = true;
							masterForm.setValue('DIV_CODE', newValue);
							masterForm.setValue('RECEIPT_NUM', '');
							masterForm.setValue('QUOT_NUM', '');
							masterForm.setValue('MACHINE_TYPE', '');
						
							panelResult.setValue('QUOT_NUM', '');
							panelResult.setValue('RECEIPT_NUM', '');
							panelResult.setValue('SERIAL_NO', '');
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
							panelResult.setValue('SPEC', '');
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
							panelResult.setValue('SALE_DATE', '');
							panelResult.setValue('WARR_MONTH', '');
							panelResult.setValue('RECEIPT_PRSN', '');
							panelResult.setValue('USER_NAME', '');
							panelResult.setValue('IN_DATE', '');
							panelResult.setValue('AS_STATUS', '');
							panelResult.setValue('QUOT_REMARK', '');
							panelResult.setValue('RECEIPT_REMARK', '');

							masterForm.uniOpt.inLoading = false;
						}
					} 
				}
			}
		},{
			xtype: 'uniTextfield',
			fieldLabel		: '<t:message code="system.label.sales.repairnum" default="수리번호"/>',
    		name: 'REPAIR_NUM',
    		readOnly:true
		},{
			fieldLabel		: '<t:message code="system.label.sales.repairedate" default="수리일"/>',
			xtype			: 'uniDatefield',
			name		    : 'REPAIR_DATE',
			allowBlank	    : false,
			labelWidth      : 90 ,
			listeners:{
				change:function(field, newValue, oldValue){
					if(newValue != '')	{
						masterForm.setValue("REPAIR_DATE", newValue);		
					}
				}
			}
		},{
			xtype : 'button',
			width:130,
			tdAttrs:{'align' :'right', width:140},
			text : 'A/S 접수(견적) 내역',
			handler: function(){
				var quotPopup = panelResult.down("#QUOT_NUM_POPUP");
				quotPopup.openPopup();
			}
		},{
			xtype : 'button',
			width:100,
			tdAttrs:{'align' :'right', width:110},
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
			popupWidth	: 1250,
        	listeners:{
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': masterForm.getValue("DIV_CODE"), 'SERIAL_NO': panelResult.getValue("SERIAL_NO")});
				}
        	}
	  }),{
			xtype :'fieldset',
			colspan : 5,
			title :'<t:message code="system.label.sales.asreceiptcontent" default="A/S 접수 내역"/>',
			layout :{ type :'uniTable', columns:3},
			tdAttrs : {style:'padding:0px 0px 0px 10px;'},
			items:[
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
									if(!Ext.isEmpty(masterForm.getValue("REPAIR_NUM"))) {
										if(confirm("조회된 수리번호가 있습니다. 신규로 등록하시겠습니까?"))	{
											 UniAppManager.app.onResetButtonDown();
										}	
									}
									masterForm.uniOpt.inLoading = true;
									panelResult.setValue('DIV_CODE', records[0]["DIV_CODE"]);
									panelResult.setValue('QUOT_NUM', records[0]["QUOT_NUM"]);
									panelResult.setValue('RECEIPT_NUM', records[0]["RECEIPT_NUM"]);
									panelResult.setValue('SERIAL_NO', records[0]["SERIAL_NO"]);
									panelResult.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
									panelResult.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
									panelResult.setValue('SPEC', records[0]["SPEC"]);
									panelResult.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
									panelResult.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
									panelResult.setValue('SALE_DATE', records[0]["SALE_DATE"]);
									panelResult.setValue('WARR_MONTH', records[0]["WARR_MONTH"]);
									panelResult.setValue('RECEIPT_PRSN', records[0]["RECEIPT_PRSN"]);
									panelResult.setValue('USER_NAME', records[0]["RECEIPT_PRSN_NAME"]);
									panelResult.setValue('IN_DATE', records[0]["IN_DATE"]);
									panelResult.setValue('AS_STATUS', records[0]["AS_STATUS"]);
									panelResult.setValue('QUOT_REMARK', records[0]["QUOT_REMARK"]);
									panelResult.setValue('RECEIPT_REMARK', records[0]["RECEIPT_REMARK"]);
									panelResult.setValue('MACHINE_TYPE', records[0].MACHINE_TYPE);
									
									masterForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
									masterForm.setValue('RECEIPT_NUM', records[0]["RECEIPT_NUM"]);
									masterForm.setValue('QUOT_NUM', records[0]["QUOT_NUM"]);
									masterForm.setValue('MACHINE_TYPE', records[0]["MACHINE_TYPE"]);
									masterForm.setValue('REPAIR_RANK', records[0]["REPAIR_RANK"]);
									masterForm.setValue('COST_YN', records[0]["COST_YN"]);
									masterForm.setValue('WON_CALC_BAS', records[0]["WON_CALC_BAS"]);
									masterForm.setValue('TAX_TYPE', records[0]["TAX_TYPE"]);
									
									masterForm.setValue('INSPEC_FLAG', 'N');
									masterForm.setValue('FILE_NUM', records[0]["FILE_NUM"]);
									masterForm.uniOpt.inLoading = false;
									var detailParam = {
											'DIV_CODE' : records[0]["DIV_CODE"],
											'QUOT_NUM' : records[0]["QUOT_NUM"]
									}
									masterGrid.store.loadData({});
									s_sas200ukrv_mitService.selectDetail(detailParam, function(responseText) {
										Ext.each(responseText, function(record){
											record['QUOT_NUM'] = masterForm.getValue('QUOT_NUM');
											masterGrid.createRow(record);
										});										
									});
									var fp = Ext.getCmp('s_sas300ukrv_mitFileUploadPanel');
									fp.loadFileList();
								}
							},
							scope: this
						},
						onClear: function(type) {
							
							panelResult.setValue('DIV_CODE', '');
							panelResult.setValue('QUOT_NUM', '');
							panelResult.setValue('RECEIPT_NUM', '');
							panelResult.setValue('SERIAL_NO', '');
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
							panelResult.setValue('SPEC', '');
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
							panelResult.setValue('SALE_DATE', '');
							panelResult.setValue('WARR_MONTH', '');
							panelResult.setValue('RECEIPT_PRSN', '');
							panelResult.setValue('USER_NAME', '');
							panelResult.setValue('IN_DATE', '');
							panelResult.setValue('AS_STATUS', '');
							panelResult.setValue('QUOT_REMARK', '');
							panelResult.setValue('RECEIPT_REMARK', '');
							panelResult.setValue('MACHINE_TYPE', '');
							
							masterForm.setValue('DIV_CODE', '');
							masterForm.setValue('RECEIPT_NUM', '');
							masterForm.setValue('QUOT_NUM', '');
							masterForm.setValue('MACHINE_TYPE', '');
							masterForm.setValue('REPAIR_RANK', '');
							masterForm.setValue('COST_YN', '');
							masterForm.setValue('WON_CALC_BAS', '');
							masterForm.setValue('TAX_TYPE', '');
						},
						applyextparam: function(popup){
							
							popup.setExtParam({'DIV_CODE': panelResult.getValue("DIV_CODE"), 'AS_STATUS' : '20'});
						}
		        	}
		        }),{
					fieldLabel : '<t:message code="system.label.sales.receiptnum" default="접수번호"/>'  ,
					name : 'RECEIPT_NUM',
					xtype : 'uniTextfield',
		    		readOnly : true
				},{
					fieldLabel : '<t:message code="system.label.sales.equipmenttype" default="장비유형"/>'  ,
					name : 'MACHINE_TYPE',
					xtype : 'uniCombobox',
					comboType : 'AU',
					comboCode : 'S162',
		    		readOnly : true,
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
		    		fieldLabel: '<t:message code="system.label.sales.receiptdate" default="입고일"/>',
		    		name: 'IN_DATE',
		    		readOnly : true
				},{
	        		xtype:'uniCombobox',
	        		fieldLabel:'<t:message code="system.label.sales.processstatus" default="진행상태"/>',
	        		name:'AS_STATUS',
	        		comboType : 'AU',
					comboCode : 'S163',
		    		readOnly : true
	        	},{
					xtype :'textarea',
					fieldLabel:'<t:message code="system.label.sales.receiptremark" default="접수내역"/>',
					name : 'RECEIPT_REMARK',
		    		readOnly : true,
					height : 40,
					width : 895,
					colspan : 3
				},{
					xtype :'uniTextfield',
					fieldLabel:'<t:message code="system.label.sales.estimatecontent" default="견적전달내용"/>',
					name : 'QUOT_REMARK',
		    		readOnly : true,
					width : 895,
					colspan : 3
				}
			]
			
		}
		]
	});	
	
	
	var masterForm = Unilite.createForm('s_sas300ukrv_mitMasterForm',{		
    	region: 'north',		
    	autoScroll: true,  		
    	padding: '0 0 0 0' ,	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff;border-width: 0px;'},
    	layout : {type : 'uniTable', columns : 4, tableAttrs:{border:0}}, 
		items: [{
				fieldLabel : '<t:message code="system.label.sales.division" default="사업장"/>'  ,
				name : 'DIV_CODE',
				xtype : 'uniCombobox',
				comboType : 'BOR120',
				value : UserInfo.divCode,
				allowBlank : false,
				hidden :true
			}
			,
			Unilite.popup('AS_REPAIR_NUM', {
				fieldLabel: '<t:message code="system.label.sales.repairnum" default="수리번호"/>',
				textFieldName:'REPAIR_NUM',
				DBtextFieldName: 'REPAIR_NUM',
				itemId : 'REPAIR_NUM_POPUP',
				hidden :true,
	        	listeners:{
	        		onSelected: {
						fn: function(records, type) {
							if(records) {
								masterForm.uniOpt.inLoading = true;
								masterForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
								masterForm.setValue('REPAIR_NUM', records[0]["REPAIR_NUM"]);
								masterForm.setValue('REPAIR_DATE', records[0]["REPAIR_DATE"]);
								panelResult.setValue('DIV_CODE', records[0]["DIV_CODE"]);
								panelResult.setValue('REPAIR_NUM', records[0]["REPAIR_NUM"]);
								panelResult.setValue('REPAIR_DATE', records[0]["REPAIR_DATE"]);
								masterForm.uniOpt.inLoading = false;
								UniAppManager.app.onQueryButtonDown();
							}
						},
						scope: this
					},
					onClear: function(type) {
						masterForm.setValue('DIV_CODE', '');
						masterForm.setValue('REPAIR_NUM', '');
						masterForm.setValue('REPAIR_DATE', '');
						panelResult.setValue('DIV_CODE', '');
						panelResult.setValue('REPAIR_NUM', '');
						panelResult.setValue('REPAIR_DATE', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue("DIV_CODE"), 'REPAIR_NUM': masterForm.getValue("REPAIR_NUM_POPUP"), 'SERIAL_NO': panelResult.getValue("SERIAL_NO"), 'REPAIR_DATE_FR':panelResult.getValue("REPAIR_DATE"), 'REPAIR_DATE_TO':panelResult.getValue("REPAIR_DATE")});
					}
	        	}
		  }),{
				xtype: 'uniTextfield',
	    		fieldLabel: '수리견적번호',
	    		name: 'QUOT_NUM',
	    		allowBlank :false,
	    		hidden : true
			},{
				xtype: 'uniDatefield',
	    		fieldLabel: '<t:message code="system.label.sales.repairdate" default="수리일"/>',
	    		name: 'REPAIR_DATE',
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
			},{
				fieldLabel : '<t:message code="system.label.sales.asrank" default="수리랭크"/>'  ,
				name : 'REPAIR_RANK',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S164'
			},{
				fieldLabel : ''  ,//유무상
				fieldWidth : 0,
				name : 'COST_YN',
				xtype : 'uniRadiogroup',
				comboType : 'AU',
				allowBlank : false,
				comboCode : 'S802',
				width : 140,
				tdAttrs : {width : 250}
			},{
				xtype : 'component',
				html  : '&nbsp;'
			},{
				fieldLabel : '수리상태'  ,
				name : 'INSPEC_FLAG',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S165',
				width : 210,
				labelWidth : 50,
				listeners : {
					change : function(field, newValue, oldValue) {
						if(newValue != oldValue && !masterForm.uniOpt.inLoading)	{
							if(newValue == "R" || newValue == "Y")	{
								Unilite.messageBox("해당 상태는 선택할 수 없습니다");
								field.setValue(oldValue);
							}
						}
					}
				}
			},Unilite.popup('USER' , {
				xtype:'uniPopupField',
				fieldLabel : '수리자',
				valueFieldName:'REPAIR_PRSN',
				textFieldName:'USER_NAME',
				textFieldWidth : 150
   			 })
        	,{
        		xtype:'uniTextfield',
        		fieldLabel:'수리내용',
				labelWidth : 70,
        		name:'REPAIR_REMARK',
        		width : 665,
        		colspan : 3
        	},{
				fieldLabel : '위치'  , // 위치
				name : 'BAD_LOC_CODE',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S168',
				listeners : {
					change:function(field, newValue, oldValue)	{
						if(newValue != oldValue && !masterForm.uniOpt.inLoading)	{
							masterForm.setValue('BAD_CONDITION_CODE','');
						}
					}
				}
			},{
				fieldLabel : '증상'  ,//증상
				labelWidth : 70,
				name : 'BAD_CONDITION_CODE',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S169',
				listeners : {
					beforequery: function(queryPlan, eOpt) {
						var store = queryPlan.combo.store;
						var mappingStore = Ext.data.StoreManager.lookup("CBS_AU_S172") ;
						var mappingValue = masterForm.getValue("BAD_LOC_CODE");
						var fArr = new Array();
						if(mappingStore.getData() && !Ext.isEmpty(mappingValue))	{
							Ext.each(mappingStore.getData().items, function(fItem){
								if(fItem.get("refCode1") == mappingValue)	{
									fArr.push(fItem.get("refCode2"));
								}
							})
							
							store.clearFilter();
							store.filterBy(function(item){
								return fArr.indexOf(item.get('value')) > -1 ;
							})
						} else {
							store.clearFilter();
						}
					}
				}
			},{
				fieldLabel : '원인'  ,//원인
				labelWidth : 50,
				name : 'BAD_REASON_CODE',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S170'
			},{
				fieldLabel : '해결'  , 
				labelWidth : 50,
				name : 'SOLUTION_CODE',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S171',
				width : 210
			},{
				fieldLabel : '위치'  , // 위치
				name : 'BAD_LOC_CODE2',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S168',
				listeners : {
					change:function(field, newValue, oldValue)	{
						if(newValue != oldValue && !masterForm.uniOpt.inLoading)	{
							masterForm.setValue('BAD_CONDITION_CODE2','');
						}
					}
				}
			},{
				fieldLabel : '증상'  ,//증상
				labelWidth : 70,
				name : 'BAD_CONDITION_CODE2',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S169',
				listeners : {
					beforequery: function(queryPlan, eOpt) {
						var store = queryPlan.combo.store;
						var mappingStore = Ext.data.StoreManager.lookup("CBS_AU_S172") ;
						var mappingValue = masterForm.getValue("BAD_LOC_CODE2");
						var fArr = new Array();
						if(mappingStore.getData() && !Ext.isEmpty(mappingValue))	{
							Ext.each(mappingStore.getData().items, function(fItem){
								if(fItem.get("refCode1") == mappingValue)	{
									fArr.push(fItem.get("refCode2"));
								}
							})
							
							store.clearFilter();
							store.filterBy(function(item){
								return fArr.indexOf(item.get('value')) > -1 ;
							})
						} else {
							store.clearFilter();
						}
					}
				}
			},{
				fieldLabel : '원인'  ,//원인
				labelWidth : 50,
				name : 'BAD_REASON_CODE2',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S170'
			},{
				fieldLabel : '해결'  , 
				labelWidth : 50,
				name : 'SOLUTION_CODE2',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S171',
				width : 210
			},{
				fieldLabel : '위치'  , // 위치
				name : 'BAD_LOC_CODE3',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S168',
				listeners : {
					change:function(field, newValue, oldValue)	{
						if(newValue != oldValue && !masterForm.uniOpt.inLoading)	{
							masterForm.setValue('BAD_CONDITION_CODE3','');
						}
					}
				}
			},{
				fieldLabel : '증상'  ,//증상
				labelWidth : 70,
				name : 'BAD_CONDITION_CODE3',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S169',
				listeners : {
					beforequery: function(queryPlan, eOpt) {
						var store = queryPlan.combo.store;
						var mappingStore = Ext.data.StoreManager.lookup("CBS_AU_S172") ;
						var mappingValue = masterForm.getValue("BAD_LOC_CODE3");
						var fArr = new Array();
						if(mappingStore.getData() && !Ext.isEmpty(mappingValue))	{
							Ext.each(mappingStore.getData().items, function(fItem){
								if(fItem.get("refCode1") == mappingValue)	{
									fArr.push(fItem.get("refCode2"));
								}
							})
							
							store.clearFilter();
							store.filterBy(function(item){
								return fArr.indexOf(item.get('value')) > -1 ;
							})
						} else {
							store.clearFilter();
						}
					}
				}
			},{
				fieldLabel : '원인'  ,//원인
				labelWidth : 50,
				name : 'BAD_REASON_CODE3',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S170'
			},{
				fieldLabel : '해결'  , 
				labelWidth : 50,
				name : 'SOLUTION_CODE3',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S171',
				width : 210
			},{
				fieldLabel : '위치'  , // 위치
				name : 'BAD_LOC_CODE4',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S168',
				listeners : {
					change:function(field, newValue, oldValue)	{
						if(newValue != oldValue && !masterForm.uniOpt.inLoading)	{
							masterForm.setValue('BAD_CONDITION_CODE4','');
						}
					}
				}
			},{
				fieldLabel : '증상'  ,//증상
				labelWidth : 70,
				name : 'BAD_CONDITION_CODE4',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S169',
				listeners : {
					beforequery: function(queryPlan, eOpt) {
						var store = queryPlan.combo.store;
						var mappingStore = Ext.data.StoreManager.lookup("CBS_AU_S172") ;
						var mappingValue = masterForm.getValue("BAD_LOC_CODE4");
						var fArr = new Array();
						if(mappingStore.getData() && !Ext.isEmpty(mappingValue))	{
							Ext.each(mappingStore.getData().items, function(fItem){
								if(fItem.get("refCode1") == mappingValue)	{
									fArr.push(fItem.get("refCode2"));
								}
							})
							
							store.clearFilter();
							store.filterBy(function(item){
								return fArr.indexOf(item.get('value')) > -1 ;
							})
						} else {
							store.clearFilter();
						}
					}
				}
			},{
				fieldLabel : '원인'  ,//원인
				labelWidth : 50,
				name : 'BAD_REASON_CODE4',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S170'
			},{
				fieldLabel : '해결'  , 
				labelWidth : 50,
				name : 'SOLUTION_CODE4',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S171',
				width : 210
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
			load: 's_sas300ukrv_mitService.selectMaster',
			submit: 's_sas300ukrv_mitService.syncMaster'				
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {				
				UniAppManager.setToolbarButtons('save', true);
			}
		}
	});
	
    var masterGrid = Unilite.createGrid('s_sas300ukrv_mitGrid', {
        store: directMasterStore,
    	excelTitle: '품목코드',
    	region: 'center',
    	flex:1,
    	minHeight : 80,
    	split:true,
    	uniOpt:{expandLastColumn: false},
    	tbar:[{
				xtype : 'button',
				width:140,
				tdAttrs:{'align' :'right', width:150},
				text : '<t:message code="" default="수리완료보고서 출력"/>',
				handler: function(){
					var win;
					var param = {
							  'DIV_CODE'   : panelResult.getValue('DIV_CODE')
							, 'REPAIR_NUM' : panelResult.getValue('REPAIR_NUM')
						};
					if(Ext.isEmpty(param.DIV_CODE) || Ext.isEmpty(param.REPAIR_NUM) ) {
						Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
						return false;
					}
					
					win = Ext.create('widget.ClipReport', {
						url		: CPATH + '/z_mit/s_sas300clukrv_mit.do',
						prgID	: 's_sas300ukrv_mit',
						extParam: param
					});
					win.center();
					win.show();
				}
			},{
				xtype : 'button',
				width:150,
				tdAttrs:{'align' :'right', width:150},
				text : '<t:message code="" default="수리완료보고서(2) 출력"/>',
				handler: function(){
					var win;
					var param = {
							  'DIV_CODE'   : panelResult.getValue('DIV_CODE')
							, 'REPAIR_NUM' : panelResult.getValue('REPAIR_NUM')
						};
					if(Ext.isEmpty(param.DIV_CODE) || Ext.isEmpty(param.REPAIR_NUM) ) {
						Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
						return false;
					}
					
					win = Ext.create('widget.ClipReport', {
						url		: CPATH + '/z_mit/s_sas300clukrv2_mit.do',
						prgID	: 's_sas300ukrv_mit',
						extParam: param
					});
					win.center();
					win.show();
				}
			},{
				xtype : 'button',
				width:150,
				tdAttrs:{'align' :'right', width:150},
				text : '<t:message code="" default="자재출고요청서 출력"/>',
				handler: function(){
					var win;
					var param = {
							  'DIV_CODE'   : panelResult.getValue('DIV_CODE')
							, 'REPAIR_NUM' : panelResult.getValue('REPAIR_NUM')
						};
					if(Ext.isEmpty(param.DIV_CODE) || Ext.isEmpty(param.REPAIR_NUM) ) {
						Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
						return false;
					}
					
					win = Ext.create('widget.ClipReport', {
						url		: CPATH + '/z_mit/s_sas300clukrv3_mit.do',
						prgID	: 's_sas300ukrv_mit',
						extParam: param
					});
					win.center();
					win.show();
				}
			},{
				xtype : 'button',
				width:100,
				tdAttrs:{'align' :'center', width:120},
				text : '<t:message code="system.label.sales.materialissue" default="자재출고"/>',
				handler: function(){
					if(UniAppManager.app._needSave())	{
						Unilite.messageBox("저장 후 자재출고를 실행하세요.");
						return;
					}
					var records = masterGrid.getSelectedRecords();
					if(Ext.isEmpty(records))	{
						Unilite.messageBox("자재출고 품목을 선택하세요.");
						return;
					}
					var allCheck = true;
					if(records.length != directMasterStore.getData().items.length)	{
						if(!confirm('부분 출고 하시겠습니까?'))	{
							allCheck = false;
						}
					}
					if(allCheck)	{
						var chkLotNo = true;
						var lotMessage = "";
						Ext.each(records, function(record, idx)	{
							 if(record.get("LOT_YN") == "Y" && Ext.isEmpty(record.get("LOT_NO")) )	{
								 lotMessage += "품목코드 "+record.get("ITEM_CODE") + " 의 LOT 번호 "+"\n";
								chkLotNo = false;
							} 
						})
						if(!chkLotNo)	{
							Unilite.messageBox("LOT 번호는 필수입력입니다.", lotMessage);
							return;
						} 
						
						var repairSeqArr = new Array();
						Ext.each(records, function(record){
							repairSeqArr.push(record.get("REPAIR_SEQ"));
						})
						
						var params = {
							DIV_CODE : masterForm.getValue("DIV_CODE"),
							REPAIR_NUM : masterForm.getValue("REPAIR_NUM"),
							REPAIR_SEQ_ARR : repairSeqArr
						}
						s_sas300ukrv_mitService.selectCheckInoutNumDetail(params, function(checResponseText) {
							
							if(!Ext.isEmpty(checResponseText) && checResponseText.length > 0  ) {
								
								var inOutNum  = false;
								Ext.each(checResponseText, function(checkRecord)	{
									
									if(!Ext.isEmpty(checkRecord.INOUT_NUM) ) {
										inOutNum = true;
									}
								})
								if(inOutNum)	{
									Unilite.messageBox("출고된 품목이 있습니다.");
									return;
								} else {
									Ext.getBody().mask();
									s_sas300ukrv_mitService.updateMtr200(params, function(responseText){
										Ext.getBody().unmask();
										if(responseText)	{
											UniAppManager.updateStatus("자재출고가 등록되었습니다.");
											directMasterStore.loadStoreRecords();
										}
									} ) 
								} 
							}
						})	
					}
				}
			},{
				xtype : 'button',
				width:100,
				tdAttrs:{'align' :'right', width:100},
				text : '출고취소',
				handler: function(){
					if(masterForm.getValue("INSPEC_FLAG") == "Y")	{
						Unilite.messageBox('검수완료되어  취소할 수 없습니다');
						return ;
					}
					var records = masterGrid.getSelectedRecords();
					if(confirm('출고 취소하시겠습니까?'))	{
						if(Ext.isEmpty(records))	{
							Unilite.messageBox("출고취소 품목을 선택하세요.");
							return;
						}
						
						var repairSeqArr = new Array();
						Ext.each(records, function(record){
							repairSeqArr.push(record.get("REPAIR_SEQ"));
						})
						
						var params = {
							DIV_CODE : masterForm.getValue("DIV_CODE"),
							REPAIR_NUM : masterForm.getValue("REPAIR_NUM"),
							REPAIR_SEQ_ARR : repairSeqArr,
							OPR_FLAG : 'D'
						}
						s_sas300ukrv_mitService.selectCheckInoutNumDetail(params, function(checResponseText) {
							
							if(!Ext.isEmpty(checResponseText) && checResponseText.length > 0 ) {
								
								var scmFlagYn = "N";
								var inOutNum  = false;
								Ext.each(checResponseText, function(checkRecord)	{
									if(checkRecord.SCM_FLAG_YN == "Y" ) {
										scmFlagYn = "Y";
									}
									if(!Ext.isEmpty(checkRecord.INOUT_NUM) ) {
										inOutNum = true;
									}
								})
								if(scmFlagYn == "Y")	{
									Unilite.messageBox("출고정산되어  취소할 수 없습니다.");
									return;
								}
								if(!inOutNum ) {
									Unilite.messageBox("출고 품목이 없습니다.");
									return;
								}
								
								Ext.getBody().mask();
								s_sas300ukrv_mitService.updateMtr200(params, function(responseText){
									Ext.getBody().unmask();
									if(responseText)	{
										UniAppManager.updateStatus("출고가 취소되었습니다.");
										directMasterStore.loadStoreRecords();
									}
								} )
							}
								
						})
					}
				}
			}
    	],
    	selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : true }),
    	features: [ {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],//그룹 합계 관련
        columns:  [
        	{dataIndex: 'DIV_CODE'       	,		width: 70, hidden :true},
        	{dataIndex: 'REPAIR_NUM'       	,		width: 100, hidden :true},
        	{dataIndex: 'REPAIR_SEQ'       	,		width: 40, hidden :true},
        	{dataIndex: 'ITEM_CODE'	    	,		width: 100,
        	 editor:Unilite.popup('AS_PUMOK_MIT_G', {
        		textFieldName:'ITEM_CODE',
 				DBtextFieldName: 'ITEM_CODE',
 				autoPopup : true,
 				extParam:{'DIV_CODE': panelResult.getValue("DIV_CODE")},
        		 listeners:{
 	        		onSelected: {
 						fn: function(records, type) {
 							if(records) {
 								var record = masterGrid.uniOpt.currentRecord;
 								record.set('DIV_CODE', records[0]["DIV_CODE"]);
 								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
 								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
 								record.set('SPEC', records[0]["SPEC"]);
 								record.set('UNIT', records[0]["STOCK_UNIT"]);
 								record.set('LOT_YN', records[0]["LOT_YN"]);
 								record.set('STOCK_CARE_YN', records[0]["STOCK_CARE_YN"]);
 								record.set('AS_PRICE', records[0]["SALE_BASIS_P"]);
 								if(records[0]['STOCK_CARE_YN'] == 'N')	{
 									record.set('WH_CODE', records[0]["WH_CODE"]);
 								}
 								if(records[0]["TYPE"] == '2') {
 									record.set('AS_PRICE', records[0]["PURCHASE_P"]);
 		    					} else {
 		    						record.set('AS_PRICE', records[0]["SALE_BASIS_P"]);
 		    					}
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
 						record.set('UNIT', '');
						record.set('LOT_YN', '');
						record.set('STOCK_CARE_YN', '');
						record.set('AS_PRICE', '');
 					},
 					applyextparam: function(popup){
 						var record = masterGrid.uniOpt.currentRecord;
 						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE"), 'CUSTOM_CODE' : panelResult.getValue('CUSTOM_CODE')});
 					}
 	        	}
        	 }),
        	 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
			 }	
        	},
        	{dataIndex: 'ITEM_NAME'	    	,		width: 100,
        		editor:Unilite.popup('AS_PUMOK_MIT_G', {
     				autoPopup : true,
     				extParam:{'DIV_CODE': panelResult.getValue("DIV_CODE")},
            		 listeners:{
     	        		onSelected: {
     						fn: function(records, type) {
     							if(records) {
     								var record = masterGrid.uniOpt.currentRecord;
     								record.set('DIV_CODE', records[0]["DIV_CODE"]);
     								record.set('ITEM_CODE', records[0]["ITEM_CODE"]);
     								record.set('ITEM_NAME', records[0]["ITEM_NAME"]);
     								record.set('SPEC', records[0]["SPEC"]);
     								record.set('LOT_YN', records[0]["LOT_YN"]);
     								record.set('STOCK_CARE_YN', records[0]["STOCK_CARE_YN"]);
     								if(records[0]['STOCK_CARE_YN'] == 'N')	{
     									record.set('WH_CODE', records[0]["WH_CODE"]);
     								} 
     								if(records[0]["TYPE"] == '2') {
     									record.set('AS_PRICE', records[0]["PURCHASE_P"]);
     		    					} else {
     		    						record.set('AS_PRICE', records[0]["SALE_BASIS_P"]);
     		    					}
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
							record.set('LOT_YN', '');
							record.set('STOCK_CARE_YN', '');
							record.set('AS_PRICE', '');
     					},
     					applyextparam: function(popup){
     						var record = masterGrid.uniOpt.currentRecord;
     						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE"), 'CUSTOM_CODE' : panelResult.getValue('CUSTOM_CODE')});
     					}
     	        	}
            	 })
        	},
        	{dataIndex: 'SPEC'	    		,		width: 230},
        	{dataIndex: 'LOT_YN'			,       width: 100, hidden : true},
        	{dataIndex: 'LOT_NO'			,       width: 100,
        	 editor:Unilite.popup('LOTNO_G', {
        		 textFieldName:'LOT_NO',
 				 DBtextFieldName: 'LOTNO_CODE',
 				 listeners:{
 					onSelected: {
 						fn: function(records, type) {
 							if(records) {
 								var record = masterGrid.uniOpt.currentRecord;
 								record.set('LOT_NO', records[0]["LOT_NO"]);
 								record.set('WH_CODE', records[0]["WH_CODE"]);
 								record.set('WH_CELL_CODE', records[0]["WH_CELL_CODE"]);
 							}
 						},
 						scope: this
 					},
 					onClear: function(type) {
 						var record = masterGrid.uniOpt.currentRecord;
 						record.set('LOT_NO', '');
 						record.set('WH_CODE', '');
 						record.set('WH_CELL_CODE', '');
 					},
 					applyextparam: function(popup){
 						var record = masterGrid.uniOpt.currentRecord;
 						popup.setExtParam({'DIV_CODE': record.get("DIV_CODE") ,
 										   'ITEM_CODE': record.get("ITEM_CODE"), 
 										   'ITEM_NAME': record.get("ITEM_NAME") 
 						                   });
 					}
 				 }
        	 })
    		},
    		{dataIndex: 'SERIAL_NO'	    	,		width: 80},
        	{dataIndex: 'AS_QTY'	    	,		width: 80, summaryType:'sum'},
        	{dataIndex: 'AS_UNIT'	    	,		width: 80},
        	{dataIndex: 'AS_PRICE'	    	,		width: 80},
        	{dataIndex: 'AS_AMT'	    	,		width: 80, summaryType:'sum'},
        	{dataIndex: 'TAX_AMT'	    	,		width: 80, summaryType:'sum'},
        	{dataIndex: 'TOT_AMT'	    	,		width: 80, summaryType:'sum'},
        	{dataIndex: 'WH_CODE'	    	,		width: 110},
        	{dataIndex: 'WH_CELL_CODE'	    ,		width: 110},
        	{dataIndex: 'INOUT_NUM'	    	,		width: 120	},
        	{dataIndex: 'INOUT_SEQ'	    	,		width: 100	},
        	{dataIndex: 'AS_REMARK'	    	,		minValue : 100, flex:1}
		],
		listeners : {
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
		     			id : 's_sas300ukrv_mitFileUploadPanel',
				    	itemId:'fileUploadPanel',
				    	height: 80,
				    	listeners : {
				    		change: function() {
				    			UniAppManager.setToolbarButtons('save', true);
				    		}
				    	},
				    	loadFileList: function()	{
				    		var fileNum = masterForm.getValue('FILE_NUM');
				    		if(!Ext.isEmpty(fileNum))	{
								bdc100ukrvService.getFileList({DOC_NO : fileNum},
									function(provider, response) {
										var fp = Ext.getCmp('s_sas300ukrv_mitFileUploadPanel');
										fp.loadData(response.result);
									}
								 )
				    		}
				    	}
			    	} 
				]	
			}
		],
		id: 's_sas300ukrv_mitApp',
		fnInitBinding : function(param) {
			masterForm.clearForm();
			panelResult.clearForm();
			directMasterStore.loadData({});
			var fp = Ext.getCmp('s_sas300ukrv_mitFileUploadPanel');
			if(fp) fp.clear();
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData','delete','deleteAll'],false);
			var repairNum = "";
			var quotNum = "";
			var receiptNum = ""
			if(!Ext.isEmpty(param) && !Ext.isEmpty(param.REPAIR_NUM))	{
				repairNum = param.REPAIR_NUM;
			}
			if(!Ext.isEmpty(param) && !Ext.isEmpty(param.QUOT_NUM))	{
				quotNum = param.QUOT_NUM;
			}
			if(!Ext.isEmpty(param) && !Ext.isEmpty(param.RECEIPT_NUM))	{
				receiptNum = param.RECEIPT_NUM;
			}
			if(Ext.isEmpty(repairNum) && Ext.isEmpty(quotNum) && Ext.isEmpty(receiptNum)) {
				masterForm.uniOpt.inLoading = true;
				masterForm.setValue("DIV_CODE", UserInfo.divCode);
				masterForm.setValue("REPAIR_DATE", UniDate.today());
				masterForm.setValue("REPAIR_PRSN", UserInfo.userID);
				masterForm.setValue("USER_NAME", UserInfo.userName);
				masterForm.setValue("COST_YN", "Y");
				masterForm.setValue("INSPEC_FLAG", "");
				masterForm.uniOpt.inLoading = false;
				panelResult.setValue("DIV_CODE", UserInfo.divCode);
				panelResult.setValue("REPAIR_DATE", UniDate.today());
			} else if(Ext.isEmpty(repairNum) && (!Ext.isEmpty(quotNum) || !Ext.isEmpty(receiptNum)) ) {
				Ext.getBody().mask();
				s_sas100skrv_mitService.selectASList({'RECEIPT_NUM' :param.RECEIPT_NUM, 'QUOT_NUM' : param.QUOT_NUM,  'DIV_CODE': param.DIV_CODE},
						function(resonseText)	{
							Ext.getBody().unmask();
							if(resonseText && resonseText[0])	{
								panelResult.setValue("DIV_CODE", resonseText[0].DIV_CODE);
								panelResult.setValue("QUOT_NUM", resonseText[0].QUOT_NUM);
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
								panelResult.setValue('IN_DATE', resonseText[0].IN_DATE);
								panelResult.setValue('AS_STATUS', resonseText[0].AS_STATUS);
								panelResult.setValue('RECEIPT_REMARK', resonseText[0].RECEIPT_REMARK);
								panelResult.setValue('QUOT_NUM', resonseText[0].QUOT_NUM);
								panelResult.setValue('QUOT_REMARK', resonseText[0].QUOT_REMARK);
								panelResult.setValue("REPAIR_NUM", resonseText[0].REPAIR_NUM);
								panelResult.setValue('MACHINE_TYPE', resonseText[0].MACHINE_TYPE);
								if(!Ext.isEmpty(resonseText[0].REPAIR_NUM)){
									panelResult.setValue("DIV_CODE", resonseText[0].DIV_CODE);
									panelResult.setValue("REPAIR_NUM", resonseText[0].REPAIR_NUM);
									panelResult.setValue("REPAIR_DATE", resonseText[0].REPAIR_DATE);
									masterForm.uniOpt.inLoading = true ;
									masterForm.setValue("DIV_CODE", resonseText[0].DIV_CODE);
									masterForm.setValue("QUOT_NUM", resonseText[0].QUOT_NUM);
									masterForm.setValue("RECEIPT_NUM", resonseText[0].RECEIPT_NUM);
									masterForm.setValue("REPAIR_NUM", resonseText[0].REPAIR_NUM);
									masterForm.setValue("COST_YN", resonseText[0].COST_YN);
									masterForm.setValue("REPAIR_RANK", resonseText[0].REPAIR_RANK);
									masterForm.uniOpt.inLoading = false ;
									setTimeout(UniAppManager.app.onQueryButtonDown(), 1000);
								} else {
									panelResult.setValue("REPAIR_DATE", UniDate.today());
									masterForm.setValue("DIV_CODE", resonseText[0].DIV_CODE);
									masterForm.setValue("QUOT_NUM", resonseText[0].QUOT_NUM);
									masterForm.setValue("RECEIPT_NUM", resonseText[0].RECEIPT_NUM);
									masterForm.setValue("REPAIR_DATE", UniDate.today());
									masterForm.setValue("COST_YN", resonseText[0].COST_YN);
									masterForm.setValue("REPAIR_RANK", resonseText[0].REPAIR_RANK);
									masterForm.setValue('MACHINE_TYPE', resonseText[0].MACHINE_TYPE);
									masterForm.setValue('FILE_NUM', resonseText[0].FILE_NUM);
									masterForm.setValue('REPAIR_PRSN', UserInfo.userID);
									masterForm.setValue('USER_NAME', UserInfo.userName);
									masterForm.setValue("INSPEC_FLAG", "");
									masterForm.setValue("WON_CALC_BAS", resonseText[0].WON_CALC_BAS);
									masterForm.setValue("TAX_TYPE", resonseText[0].TAX_TYPE);
									var detailParam = {
											'DIV_CODE' : resonseText[0].DIV_CODE,
											'QUOT_NUM' : resonseText[0].QUOT_NUM
									}
									s_sas200ukrv_mitService.selectDetail(detailParam, function(responseText) {
										Ext.each(responseText, function(record){
											record['QUOT_NUM'] = masterForm.getValue('QUOT_NUM');
											masterGrid.createRow(record);
										});										
									});
									var fp = Ext.getCmp('s_sas300ukrv_mitFileUploadPanel');
									fp.loadFileList();
								}
									
							} else {
								panelResult.setValue("DIV_CODE", param.DIV_CODE);
								panelResult.setValue("REPAIR_DATE", UniDate.today());
								panelResult.setValue("RECEIPT_NUM", param.RECEIPT_NUM);
								masterForm.setValue("DIV_CODE", param.DIV_CODE);
								masterForm.setValue("QUOT_NUM", param.QUOT_NUM);
								masterForm.setValue("REPAIR_DATE", UniDate.today());
								masterForm.setValue("RECEIPT_NUM", param.RECEIPT_NUM);
							}		
						}
				);
			}else {
				masterForm.uniOpt.inLoading = true;
				panelResult.setValue("DIV_CODE", param.DIV_CODE);
				panelResult.setValue("REPAIR_NUM", param.REPAIR_NUM);
				panelResult.setValue("REPAIR_DATE", param.REPAIR_DATE);
				masterForm.uniOpt.inLoading = false;
				setTimeout(UniAppManager.app.onQueryButtonDown(), 3000);
			}
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			var repairNum = panelResult.getValue("REPAIR_NUM");
			var divCode = panelResult.getValue("DIV_CODE");
			if(!Ext.isEmpty(repairNum) && !Ext.isEmpty(divCode))	{
				if(masterForm.isVisible()) {
					masterForm.mask();
				}
				masterForm.uniOpt.inLoading = true;
				masterForm.getForm().load({
					params:{'REPAIR_NUM' :repairNum, 'DIV_CODE': divCode},
					success: function(form, action)	{
						if(masterForm.isMasked()) {
							masterForm.unmask();
						}
						if(!Ext.isEmpty(action.result.data.REPAIR_NUM))	{
							UniAppManager.setToolbarButtons(['deleteAll'],true);
						}
						
						if(masterForm.getValue("INSPEC_FLAG") == "Y")	{
							masterForm.setReadOnly(true);
							directMasterStore.uniOpt.editable = false;
							directMasterStore.uniOpt.deletable = false;
							UniAppManager.setToolbarButtons(['newData','delete','deleteAll'],false);
						} else {
							masterForm.setReadOnly(false);
							directMasterStore.uniOpt.editable = true;
							directMasterStore.uniOpt.deletable = true;
							UniAppManager.setToolbarButtons(['newData','delete','deleteAll'],true);
						}
							
							
							
						panelResult.getField("DIV_CODE").setReadOnly(true);
						panelResult.getField("REPAIR_DATE").setReadOnly(true);
						var receiptNum = action.result.data.RECEIPT_NUM;
						var quotNum = action.result.data.QUOT_NUM;
						if(!Ext.isEmpty(action.result.data.RECEIPT_NUM))	{
							s_sas100skrv_mitService.selectASList({'RECEIPT_NUM' :receiptNum, 'QUOT_NUM' : quotNum,  'DIV_CODE': divCode},
									function(resonseText)	{
										if(resonseText && resonseText.length > 0)	{
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
											panelResult.setValue('IN_DATE', resonseText[0].IN_DATE);
											panelResult.setValue('AS_STATUS', resonseText[0].AS_STATUS);
											panelResult.setValue('RECEIPT_REMARK', resonseText[0].RECEIPT_REMARK);
											panelResult.setValue('QUOT_NUM', resonseText[0].QUOT_NUM);
											panelResult.setValue('QUOT_REMARK', resonseText[0].QUOT_REMARK);
											panelResult.setValue('MACHINE_TYPE', resonseText[0].MACHINE_TYPE);
											directMasterStore.loadStoreRecords();
											
											var fp = Ext.getCmp('s_sas300ukrv_mitFileUploadPanel');
											fp.loadFileList();
										}		
									}
							);
						}
						if(Ext.isEmpty(action.result.data.RECEIPT_NUM) && Ext.isEmpty(action.result.data.QUOT_NUM) )  {
							directMasterStore.loadStoreRecords();
							var fp = Ext.getCmp('s_sas300ukrv_mitFileUploadPanel');
							fp.loadFileList();
									
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
				var repairPopup = masterForm.down('#REPAIR_NUM_POPUP');
				repairPopup.openPopup();
			}
		},
		onNewDataButtonDown: function()	{
			if(Ext.isEmpty(masterForm.getValue("QUOT_NUM")))	{
				Unilite.messageBox("AS 접수(견적)내역을 선택하세요.");
				return;
			}
            var r = {
            	'DIV_CODE': masterForm.getValue("DIV_CODE"),
        	 	'REPAIR_NUM': masterForm.getValue("REPAIR_NUM")
	        };
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			masterForm.setReadOnly(false);
			directMasterStore.uniOpt.editable = true;
			directMasterStore.uniOpt.deletable = true;
			var fp = Ext.getCmp('s_sas300ukrv_mitFileUploadPanel');
			fp.clear();
			panelResult.getField("DIV_CODE").setReadOnly(false);
			panelResult.getField("REPAIR_DATE").setReadOnly(false);
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			// LOT 관리여부에 따라 LOT 번호 필수 체크
			var chkLotNo = true;
			var messge = "";
			Ext.each(directMasterStore.getData().items, function(record, idx)	{
				if(Ext.isEmpty(record.get("REPAIR_NUM")))	{
					record.set("REPAIR_NUM", masterForm.getValue("REPAIR_NUM"));
				}
				/* if(record.get("LOT_YN") == "Y" && Ext.isEmpty(record.get("LOT_NO")) )	{
					messge += parseInt(idx+1)+"행의 입력값을 확인해 주세요."+"\n"
					chkLotNo = false;
				} */
			})
			/* if(!chkLotNo)	{
				Unilite.messageBox(messge, "LOT 번호는 필수입력입니다.");
				return;
			} */
			
			var fp = Ext.getCmp('s_sas300ukrv_mitFileUploadPanel');
			var addFiles = fp.getAddFiles();
			var removeFiles = fp.getRemoveFiles();
			if(masterForm.getValue('ADD_FID') != addFiles) masterForm.setValue('ADD_FID', addFiles);
			if(masterForm.getValue('DEL_FID') != removeFiles) masterForm.setValue('DEL_FID', removeFiles);
			
			if(masterForm.getInvalidMessage())	{
				if(masterForm.isDirty()) {
					Ext.getBody().mask();
					masterForm.submit({
						success:function(form, action)	{
							Ext.getBody().unmask();
							if(Ext.isEmpty(masterForm.getValue('REPAIR_NUM') ) )	{
								masterForm.uniOpt.inLoading = true;
								masterForm.setValue('REPAIR_NUM', action.result.REPAIR_NUM);
								panelResult.setValue('REPAIR_NUM', action.result.REPAIR_NUM);
								masterForm.uniOpt.inLoading = false;
								UniAppManager.setToolbarButtons(['deleteAll'],true);
								
							} 
							if(masterForm.getValue("INSPEC_FLAG") == "Y")	{
								masterForm.getField("INSPEC_FLAG").setReadOnly(true);
							}
							if(directMasterStore.isDirty())	{
								directMasterStore.saveStore();
							} else {
								UniAppManager.updateStatus('<t:message code="system.message.commonJS.store.saved" default="저장되었습니다."/>');
								UniAppManager.setToolbarButtons('save',false);
							}
						},
						failure: function()	{
							Ext.getBody().unmask();
						}
					});
				} else {
					if(directMasterStore.isDirty())	{
						directMasterStore.saveStore();
					}
				}
			}			
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(!Ext.isEmpty(selRow.get("INOUT_NUM")))	{
				Unilite.messageBox("자재출고된 데이터가 있습니다. 출고 취소 후 삭제하세요.")	
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			if(confirm('삭제 하시겠습니까?')) {
				var divCode = masterForm.getValue('DIV_CODE')
				var repairNum = masterForm.getValue('REPAIR_NUM');
				s_sas300ukrv_mitService.deleteMaster({
							DIV_CODE : divCode,
							REPAIR_NUM : repairNum,
							RECEIPT_NUM : masterForm.getValue('RECEIPT_NUM')
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
