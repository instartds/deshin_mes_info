<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas100ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas100ukrv_mit"/>
	<t:ExtComboStore comboType="AU" comboCode="S162"/>								<!-- 장비유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S163"/>								<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S164"/>								<!-- 수리랭크 -->
	<t:ExtComboStore comboType="AU" comboCode="S166"/>								<!-- 보증기간 -->
	<t:ExtComboStore comboType="AU" comboCode="S167"/>								<!-- 유지보수등급 -->
	<t:ExtComboStore comboType="AU" comboCode="S802"/>								<!-- 유무상 -->
</t:appConfig>
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
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_sas100ukrv_mitService.selectDetail',
		}
	});	
	
	Unilite.defineModel('s_sas100ukrv_mitModel', {
	    fields: [  	  
	    	{name: 'REPAIR_DATE'      	, text: '<t:message code="system.label.sales.asdatehistory" default="이전수리일"/>' 	,type: 'uniDate'},
	    	{name: 'REPAIR_NUM'      	, text: '<t:message code="system.label.sales.asrepairnum" default="수리번호"/>' 		,type: 'string'},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>' 					,type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 			,type: 'string'},
	    	{name: 'SERIAL_NO'			, text: '<t:message code="system.label.sales.asserialno" default="S/N"/>' 			,type: 'string'},
	    	{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>' 				,type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>' 		,type: 'string'},
	    	{name: 'USER_NAME'			, text: '<t:message code="system.label.sales.salesprsn" default="담당자"/>' 			,type: 'string'},
	    	{name: 'IN_DATE'			, text: '입고일' 			,type: 'uniDate'},
	    	{name: 'OUT_DATE'			, text: '출고일' 			,type: 'uniDate'},
	    	{name: 'COST_YN'			, text: '유무상' 			,type: 'string' , comboType : 'AU', comboCode : 'S802'},
	    	{name: 'REPAIR_RANK'		, text: '<t:message code="system.label.sales.asrank" default="수리랭크"/>' 			,type: 'string', comboType: 'AU', comboCode: 'S164'},
		]
	});
	
	var directMasterStore = Unilite.createStore('s_sas100ukrv_mitMasterStore',{
		model: 's_sas100ukrv_mitModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('s_sas100ukrv_mitMasterForm').getValues();			
			this.load({
				params : param
			});
		}
	});
	
	/**
	마스터 데이터 Form
	*/
	var masterForm = Unilite.createForm('s_sas100ukrv_mitMasterForm',{		
    	region: 'north',		
    	autoScroll: true,  		
    	border:true,			
    	padding: '1 1 1 1' ,	
    	disabled : false,
    	bodyStyle : {'background-color':'#fff'},
    	heighr : 600,
    	layout : {type : 'uniTable', columns : 4}, 
		items: [{
				fieldLabel : '<t:message code="system.label.sales.division" default="사업장"/>'  ,
				name : 'DIV_CODE',
				xtype : 'uniCombobox',
				comboType : 'BOR120',
				value : UserInfo.divCode,
				allowBlank : false
			},
			{
				xtype: 'uniTextfield',
	    		fieldLabel: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>',
	    		name: 'RECEIPT_NUM',
	    		readOnly:true
			},
			Unilite.popup('AS_RECEIPT_NUM', {
				fieldLabel: '<t:message code="system.label.sales.receiptnum" default="접수번호"/>',
				textFieldName:'RECEIPT_NUM_POPUP',
				DBtextFieldName: 'RECEIPT_NUM',
				itemId : 'RECEIPT_NUM_POPUP',
				hidden : true,
	        	listeners:{
	        		onSelected: {
						fn: function(records, type) {
							if(records) {
								masterForm.uniOpt.inLoading = true;
								masterForm.setValue('RECEIPT_NUM', records[0]["RECEIPT_NUM"]);
								masterForm.uniOpt.inLoading = false;
								UniAppManager.app.onQueryButtonDown();
							}
						},
						scope: this
					},
					onClear: function(type) {
						masterForm.setValue('RECEIPT_NUM', '');
					},
					applyextparam: function(popup){
						
						popup.setExtParam({'DIV_CODE': masterForm.getValue("DIV_CODE"), 'RECEIPT_NUM': masterForm.getValue("RECEIPT_NUM_POPUP")});
					}
	        	}
	        }),{
				xtype: 'uniDatefield',
	    		fieldLabel: '<t:message code="system.label.sales.receiptdate2" default="접수일"/>',
	    		name: 'RECEIPT_DATE',
	    		
			},{
				xtype : 'button',
				tdAttrs:{'align' :'right', width:150},
				text : '<t:message code="system.label.sales.printasreceipt" default="접수증출력"/>',
				tdAttrs:{width:200, align :'center'},
				handler: function(){
					var win;
					var param = {
							  'DIV_CODE'    : masterForm.getValue('DIV_CODE')
							, 'RECEIPT_NUM' : masterForm.getValue('RECEIPT_NUM')
						}
					if(Ext.isEmpty(param.DIV_CODE) || Ext.isEmpty(param.RECEIPT_NUM) ) {
						Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
						return false;
					}
					
					win = Ext.create('widget.ClipReport', {
						url		: CPATH + '/z_mit/s_sas100clukrv_mit.do',
						prgID	: 's_sas100ukrv_mit',
						extParam: param
					});
					win.center();
					win.show();
				}
			},Unilite.popup('SAS_LOT', {
				allowBlank : false,
				autoPopup : true,
				allowInputData : true,
				textFieldWidth : 150,
				itemId : 'serialNoPopup',
				popupSelected : false,
	        	listeners:{
	        		onSelected: {
						fn: function(records, type) {
							if(records) {
								masterForm.setValue('SERIAL_NO', records[0]["SERIAL_NO"]);
								masterForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
								masterForm.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
								masterForm.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
								masterForm.setValue('SPEC', records[0]["SPEC"]);
								masterForm.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
								masterForm.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
								masterForm.setValue('CONT_FR_DATE', records[0]["CONT_FR_DATE"]);
								masterForm.setValue('CONT_TO_DATE', records[0]["CONT_TO_DATE"]);
								masterForm.setValue('CONT_GRADE', records[0]["CONT_GRADE"]);
								masterForm.setValue('SALE_DATE', records[0]["SALE_DATE"]);
								masterForm.setValue('WARR_MONTH', records[0]["WARR_MONTH"]);
								masterForm.setValue('WARR_DATE', records[0]["WARR_DATE"]);
								masterForm.setValue('BILL_NUM', records[0]["BILL_NUM"]);
								masterForm.setValue('BILL_SEQ', Unilite.nvl(records[0]["BILL_SEQ"], 0));
								var field = masterForm.down("#serialNoPopup");
								field.popupSelected = true;
								directMasterStore.loadStoreRecords();
							}
						},
						scope: this
					},
					onClear: function(type) {
						var field = masterForm.down("#serialNoPopup");
						if(field.popupSelected)	{
							masterForm.setValue('SERIAL_NO','');
							masterForm.setValue('DIV_CODE', UserInfo.divCode);
							masterForm.setValue('ITEM_CODE', '');
							masterForm.setValue('ITEM_NAME', '');
							masterForm.setValue('SPEC', '');
							masterForm.setValue('CUSTOM_CODE', '');
							masterForm.setValue('CUSTOM_NAME', '');
							masterForm.setValue('CONT_FR_DATE', '');
							masterForm.setValue('CONT_TO_DATE', '');
							masterForm.setValue('CONT_GRADE', '');
							masterForm.setValue('SALE_DATE', '');
							masterForm.setValue('WARR_MONTH', '');
							masterForm.setValue('WARR_DATE', '');
							masterForm.setValue('BILL_NUM', '');
							masterForm.setValue('BILL_SEQ', 0);
						} else {
							field.popupSelected = false;
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue("DIV_CODE")});
					}
	        	}
	        }),Unilite.popup('DIV_PUMOK', {
	        	colspan : 3,
				allowBlank : false,
				extraFieldsConfig:[{extraFieldName:'SPEC', extraFieldWidth:153}],
	        	listeners:{
	        		onSelected: {
						fn: function(records, type) {
							if(records) {
								masterForm.setValue('DIV_CODE', records[0]["DIV_CODE"]);
								masterForm.setValue('ITEM_CODE', records[0]["ITEM_CODE"]);
								masterForm.setValue('ITEM_NAME', records[0]["ITEM_NAME"]);
								masterForm.setValue('SPEC', records[0]["SPEC"]);
								masterForm.setValue('CUSTOM_CODE', records[0]["CUSTOM_CODE"]);
								masterForm.setValue('CUSTOM_NAME', records[0]["CUSTOM_NAME"]);
							}
						},
						scope: this
					},
					onClear: function(type) {
						masterForm.setValue('DIV_CODE', '');
						masterForm.setValue('ITEM_CODE', '');
						masterForm.setValue('ITEM_NAME', '');
						masterForm.setValue('SPEC', '');
						masterForm.setValue('CUSTOM_CODE', '');
						masterForm.setValue('CUSTOM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue("DIV_CODE")});
					}
	        	}
	        }),{
        		xtype:'uniDatefield',
        		fieldLabel:'<t:message code="system.label.sales.saledate" default="판매일"/>',
        		name:'SALE_DATE',
        		listeners:{
        			change:function(field, newValue, oldValue)	{
        				if(newValue != oldValue && Ext.isDate(newValue))	{
        					if(!Ext.isEmpty(masterForm.getValue("WARR_MONTH")))	{
        						var warrDateField = masterForm.getField("WARR_DATE");
        						warrDateField.setAutoValue(masterForm.getValue("WARR_MONTH"), newValue);
        						/* var store = Ext.data.StoreManager.lookup("CBS_AU_S166");
        						if(!Ext.isEmpty(store))	{
        							var month = store.getAt(store.find("value", masterForm.getValue("WARR_MONTH")))
        							if(!Ext.isEmpty(month))	{
        								masterForm.setValue("WARR_DATE",  UniDate.add(UniDate.add(newValue, {months:month.get("refCode1")}), {days:-1}));
        							}
        						} */
        					}
        				}
        			}
        		}
        	},Unilite.popup('CUST',{
				allowBlank : false
        	})
        	,{
				fieldLabel : '<t:message code="system.label.sales.equipmenttype" default="장비유형"/>'  ,
				name : 'MACHINE_TYPE',
				xtype : 'uniRadiogroup',
				comboType : 'AU',
				comboCode : 'S162',
				allowBlank : false,
				value :'H',
				width :250,
				colspan : 2
			},{
				fieldLabel : '<t:message code="system.label.sales.warranty" default="보증기간"/>'  ,
				name : 'WARR_MONTH',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S166',
        		listeners:{
        			change:function(field, newValue, oldValue)	{
        				if(newValue != oldValue &&!Ext.isEmpty(newValue) )	{
        					if(Ext.isDate(masterForm.getValue("SALE_DATE")))	{
        						var warrDateField = masterForm.getField("WARR_DATE");
        						warrDateField.setAutoValue(newValue, masterForm.getValue("SALE_DATE"));
        						/* var store = Ext.data.StoreManager.lookup("CBS_AU_S166");
        						if(!Ext.isEmpty(store))	{
        							var month = store.getAt(store.find("value", masterForm.getValue("WARR_MONTH")))
        							if(!Ext.isEmpty(month))	{
        								masterForm.setValue("WARR_DATE",  UniDate.add(UniDate.add(newValue, {months:month.get("refCode1")}), {days:-1}));
        							}
        						} */
        					}
        				}
        			}
        		}
			},{
        		xtype:'uniDatefield',
        		fieldLabel:'<t:message code="system.label.sales.warrantyDate" default="보증일"/>',
        		name:'WARR_DATE',
				setAutoValue : function(worr_month, sale_date){
					var store = Ext.data.StoreManager.lookup("CBS_AU_S166");
					if(!Ext.isEmpty(store))	{
						var month = store.getAt(store.find("value", worr_month))
						if(!Ext.isEmpty(month))	{
							masterForm.setValue("WARR_DATE",  UniDate.add(UniDate.add(sale_date, {months:month.get("refCode1")}), {days:-1}));
						}
					}
				}
        	},{
				fieldLabel : '<t:message code="system.label.sales.processstatus" default="진행상태"/>'  ,
				name : 'AS_STATUS',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S163',
				readOnly  : true,
				value : '10',
				colspan : 2
			},Unilite.popup('USER' , {
				xtype:'uniPopupField',
				fieldLabel : '<t:message code="system.label.sales.receiptperson" default="접수자"/>',
				valueFieldName:'RECEIPT_PRSN',
				textFieldName:'USER_NAME',
				allowBlank : false
   			 })
			,{
        		fieldLabel:'<t:message code="system.label.sales.maintenanceperiod" default="유지보수기간"/>',
        		xtype			: 'uniDateRangefield',
				startFieldName	: 'CONT_FR_DATE',
				endFieldName	: 'CONT_TO_DATE'
        	},{
        		fieldLabel:'<t:message code="system.label.sales.maintenancegrade" default="유지보수등급"/>',
        		name : 'CONT_GRADE',
				xtype : 'uniCombobox',
				comboType : 'AU',
				comboCode : 'S167',
				colspan   : 2
			},{
				xtype:'uniDatefield',
        		fieldLabel:'입고일',
        		name:'IN_DATE'
			},{
				xtype:'uniDatefield',
        		fieldLabel:'출고일',
        		width :200,
        		name:'OUT_DATE',
        		value : '',
        		readOnly: true,
			},{
        		fieldLabel:'출고담당자',
        		width :200,
        		name:'OUT_PRSN',
        		value : '',
        		readOnly: true,
        		colspan : 2
			},{
				xtype :'textarea',
				fieldLabel:'<t:message code="system.label.sales.receiptremark" default="접수내역"/>',
				name : 'REMARK',
				height : 100,
				width : 895,
				colspan : 4
			},{ xtype : 'container',
				colspan : 4,
				layout : {type : 'uniTable', columns:'3', tdAttrs: {style:"vertical-align:top;"}},
				items:[{
						xtype :'component',
						tdAttrs: {style:"text-align:right;;padding-right:15px;"},
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
				colspan : 4,
				layout : {type : 'uniTable', columns:'3', tdAttrs: {style:"vertical-align:top;"}},
				items:[{
						xtype :'component',
						tdAttrs: {style:"text-align:right;padding-right:15px;"},
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
				colspan : 4,
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
	    		fieldLabel: '계산서번호',
	    		name: 'BILL_NUM',
	    		hidden : true
			},{
				xtype: 'uniTextfield',
	    		fieldLabel: '계산서번호순번',
	    		name: 'BILL_SEQ',
	    		hidden : true
			}],
		api: {
			load: 's_sas100ukrv_mitService.selectMaster',
			submit: 's_sas100ukrv_mitService.syncMaster'				
		},
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {				
				UniAppManager.setToolbarButtons('save', true);
			}
		}
	});
	
    var historyGrid = Unilite.createGrid('s_sas100ukrv_mitGrid', {
        store: directMasterStore,
    	title: '<t:message code="system.label.sales.ashistorylist" default="이전수리내역"/>',
    	region: 'center',
    	selModel : 'rowmodel',
        columns:  [
        	{dataIndex: 'REPAIR_DATE'	, width: 100},
        	{dataIndex: 'IN_DATE'	    , width: 80},
        	{dataIndex: 'OUT_DATE'	    , width: 80},
        	{dataIndex: 'COST_YN'	    , width: 80},
        	{dataIndex: 'REPAIR_NUM' 	, width: 110},
        	{dataIndex: 'ITEM_CODE' 	, width: 100},
        	{dataIndex: 'ITEM_NAME' 	, width: 150},
        	{dataIndex: 'SERIAL_NO' 	, width: 100, hidden:true},
        	{dataIndex: 'CUSTOM_CODE' 	, width: 80},
        	{dataIndex: 'CUSTOM_NAME' 	, width: 100},
        	{dataIndex: 'USER_NAME' 	, width: 70},
        	{dataIndex: 'REPAIR_RANK' 	, width: 100}
		],
		listeners:{
			onGridDblClick: function(grid, record, cellIndex, colName) {
				var records = grid.getSelectionModel().getSelection();
				var record = records[0];
				var params = {
					DIV_CODE: record.get("DIV_CODE"),
					RECEIPT_NUM: record.get('RECEIPT_NUM'),
					QUOT_NUM: record.get('QUOT_NUM'),
					REPAIR_NUM: record.get('REPAIR_NUM'),
					SERIAL_NO : record.get('SERIAL_NO'),
					REPAIR_DATE : record.get('REPAIR_DATE')
				}
				var rec = {data : {prgID : 's_sas300ukrv_mit', 'text':''}};
				parent.openTab(rec, '/z_mit/s_sas300ukrv_mit.do', params);
			},
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text: '<t:message code="system.label.sales.registerrepair" default="수리등록"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var records = grid.getSelectionModel().getSelection();
						var record = records[0];
						var params = {
							DIV_CODE: record.get("DIV_CODE"),
							RECEIPT_NUM: record.get('RECEIPT_NUM'),
							QUOT_NUM: record.get('QUOT_NUM'),
							REPAIR_NUM: record.get('REPAIR_NUM'),
							SERIAL_NO : record.get('SERIAL_NO'),
							REPAIR_DATE : record.get('REPAIR_DATE')
						}
						var rec = {data : {prgID : 's_sas300ukrv_mit', 'text':''}};
						parent.openTab(rec, '/z_mit/s_sas300ukrv_mit.do', params);
					}
				});
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[
			masterForm, historyGrid
		],
		id: 's_sas100ukrv_mitApp',
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
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData','delete'],false);
			var receiptNum = ""
			if(!Ext.isEmpty(param) && !Ext.isEmpty(param.RECEIPT_NUM))	{
				receiptNum = param.RECEIPT_NUM;
			}
			if( Ext.isEmpty(receiptNum)) {
				masterForm.uniOpt.inLoading = true;
				masterForm.setValue("DIV_CODE", UserInfo.divCode);
				masterForm.setValue("RECEIPT_DATE", UniDate.today());
				masterForm.setValue("RECEIPT_PRSN", UserInfo.userID);
				masterForm.setValue("USER_NAME", UserInfo.userName);
				masterForm.setValue("MACHINE_TYPE", "H");
				masterForm.setValue("AS_STATUS", '10');
				masterForm.uniOpt.inLoading = false;
			} else {
				masterForm.uniOpt.inLoading = true;
				masterForm.setValue("DIV_CODE", param.DIV_CODE);
				masterForm.setValue("RECEIPT_NUM", param.RECEIPT_NUM);
				masterForm.setValue("SERIAL_NO", param.SERIAL_NO);
				masterForm.uniOpt.inLoading = false;
				setTimeout(this.onQueryButtonDown(), 3000);
			}
			
		},
		onQueryButtonDown: function()	{
			var receiptNum = masterForm.getValue("RECEIPT_NUM");
			var divCode = masterForm.getValue("DIV_CODE");
			if(!Ext.isEmpty(receiptNum) && !Ext.isEmpty(divCode))	{
				if(masterForm.isVisible()) {
					masterForm.mask();
				}
				masterForm.uniOpt.inLoading = true;
				masterForm.getForm().load({
					params:{'RECEIPT_NUM' :receiptNum, 'DIV_CODE': divCode},
					success: function(form, action)	{
						if(masterForm.isMasked()) {
							masterForm.unmask();
							if(!Ext.isEmpty(action.result.data.RECEIPT_NUM))	{
								UniAppManager.setToolbarButtons(['delete'],true);
								UniAppManager.setToolbarButtons(['save'],false);
							}
							
						} else {
							if(!Ext.isEmpty(action.result.data.RECEIPT_NUM))	{
								UniAppManager.setToolbarButtons(['delete'],true);
								UniAppManager.setToolbarButtons(['save'],false);
							}
						}
						masterForm.uniOpt.inLoading = false;
						directMasterStore.loadStoreRecords();
					},
					failure : function()	{
						if(masterForm.isMasked()) {
							masterForm.unmask();
						}
						masterForm.uniOpt.inLoading = false;
					}
				})
			} else {
				var receiptPopup = masterForm.down('#RECEIPT_NUM_POPUP');
				receiptPopup.openPopup();
			}
		},
		onNewDataButtonDown: function() {
			if(!this.confirmSaveData())	{
				masterForm.clearForm();
			} 
		},
		onResetButtonDown: function() {		
			historyGrid.reset();
			directMasterStore.clearData();
			masterForm.uniOpt.inLoading = true;
			Ext.getCmp("FDA_Q1_Y").setValue(false);
			Ext.getCmp("FDA_Q1_N").setValue(true);
			Ext.getCmp("FDA_Q2_Y").setValue(false);
			Ext.getCmp("FDA_Q2_N").setValue(true);
			Ext.getCmp("FDA_Q3_Y").setValue(false);
			Ext.getCmp("FDA_Q3_N").setValue(true);
			masterForm.uniOpt.inLoading = false;
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {			
			if(masterForm.getInvalidMessage())	{
				var serialNo = masterForm.getValue("SERIAL_NO");
				if(Ext.isEmpty(serialNo))	{
					Unilite.messageBox('S/N <t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>')
					return;
				}
				if(Ext.isEmpty(masterForm.getValue('RECEIPT_NUM') ) )	{
					var param = {
							'DIV_CODE': masterForm.getValue("DIV_CODE"),
							'SERIAL_NO': serialNo
						};
					
					s_sas100ukrv_mitService.selectSNStatus(param, function(responseText){
						if(!Ext.isEmpty(responseText) && responseText.CNT > 0 )	{ 
							Unilite.messageBox("S/N ("+masterForm.getValue("SERIAL_NO") +")는 진행하고 있는 내역이 있습니다.");
						} else {
							UniAppManager.app.saveForm();
						}
					});
				} else {
					UniAppManager.app.saveForm();
				}
			}
		},
		saveForm : function()	{
			masterForm.submit({
				success:function(form, action)	{
					if(Ext.isEmpty(masterForm.getValue('RECEIPT_NUM') ) )	{
						masterForm.uniOpt.inLoading = true;
						masterForm.setValue('RECEIPT_NUM', action.result.RECEIPT_NUM);
						masterForm.setValue('AS_STATUS', action.result.AS_STATUS);
						
						masterForm.uniOpt.inLoading = false;
						UniAppManager.setToolbarButtons(['delete'],true);
					}
					masterForm.uniOpt.inLoading = true;
					masterForm.setValue('AS_STATUS', action.result.AS_STATUS);
					
					masterForm.uniOpt.inLoading = false;
					UniAppManager.updateStatus('<t:message code="system.message.commonJS.store.saved" default="저장되었습니다."/>');
					UniAppManager.setToolbarButtons('save',false);
				}
			});
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재  A/S 접수를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var param = masterForm.getValues();
				s_sas100ukrv_mitService.deleteMaster(param, function(responseText, response){
					if(responseText && responseText.success == "true")	{
						UniAppManager.updateStatus('<t:message code="system.message.commonJS.store.saved" default="저장되었습니다."/>');
						UniAppManager.app.onResetButtonDown();
					}
				})
			}
		},
		confirmSaveData: function(config) {
			if(masterForm.isDirty() ) {
				if(confirm('<t:message code="system.message.sales.message021" default="변경된 내용을 저장하시겠습니까?"/>')) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		}
	});
};
</script>
