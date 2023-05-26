<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="esa200ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S806" /> <!-- 원인분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S802" /> <!-- 유/무상 -->
	<t:ExtComboStore comboType="AU" comboCode="S803" /> <!-- 조치구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S808" /> <!-- A/S인건비임율표 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;};  
#ext-element-3 {align:center}
</style>

<script type="text/javascript" >

var referOtherOrderWindow;
function appMain() {   
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'esa200ukrvService.selectList1',
			update: 'esa200ukrvService.updateDetail1',
			create: 'esa200ukrvService.insertDetail1',
			destroy: 'esa200ukrvService.deleteDetail1',
			syncAll: 'esa200ukrvService.saveAll1'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'esa200ukrvService.selectList2',
			update: 'esa200ukrvService.updateDetail2',
			create: 'esa200ukrvService.insertDetail2',
			destroy: 'esa200ukrvService.deleteDetail2',
			syncAll: 'esa200ukrvService.saveAll2'

			}
	});
	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'esa200ukrvService.selectList3',
			update: 'esa200ukrvService.updateDetail3',
			create: 'esa200ukrvService.insertDetail3',
			destroy: 'esa200ukrvService.deleteDetail3',
			syncAll: 'esa200ukrvService.saveAll3'
		}
	});
		
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'esa200ukrvService.selectList4',
			update: 'esa200ukrvService.updateDetail4',
			create: 'esa200ukrvService.insertDetail4',
			destroy: 'esa200ukrvService.deleteDetail4',
			syncAll: 'esa200ukrvService.saveAll4'
		}
	});
	
	Unilite.defineModel('esa200ukrvDetailModel1', {
	    fields: [
	    	{name: 'COMP_CODE'      	, text: '법인코드'				, type: 'string', allowBlank: false},
	    	{name: 'DIV_CODE'       	, text: '사업장' 				, type: 'string', allowBlank: false},
	    	{name: 'AS_NUM'      		, text: '접수번호' 			, type: 'string', allowBlank: false},
	    	{name: 'AS_SEQ'				, text: '순번'				, type: 'int'	, allowBlank: false},
	    	{name: 'ITEM_CODE'      	, text: '품목코드' 			, type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'      	, text: '품목명' 				, type: 'string'},
	    	{name: 'SPEC'      			, text: '규격' 				, type: 'string'},
	    	{name: 'STOCK_UNIT'      	, text: '단위' 				, type: 'string'},
	    	{name: 'AS_Q'      			, text: '수량' 				, type: 'uniQty'},
	    	{name: 'CLOSE_DATE'      	, text: '완료일자' 			, type: 'uniDate'},
	    	{name: 'BAD_GUBUN'      	, text: '원인분류' 			, type: 'string', comboType:'AU', comboCode: 'S806', allowBlank: false},
	    	{name: 'PAY_YN'      		, text: '유/무상' 			, type: 'string', comboType:'AU', comboCode: 'S802', allowBlank: false},
	    	{name: 'CLOSE_TYPE'      	, text: '처리방법' 			, type: 'string', comboType:'AU', comboCode: 'S803', allowBlank: false},
	    	{name: 'REMARK'      		, text: '메모' 				, type: 'string'}
		]
	});
	
	Unilite.defineModel('esa200ukrvDetailModel2', {
	    fields: [
	    	{name: 'COMP_CODE'      	, text: '법인코드'				, type: 'string', allowBlank: false},
	    	{name: 'DIV_CODE'       	, text: '사업장' 				, type: 'string', allowBlank: false},
	    	{name: 'AS_NUM'      		, text: '접수번호' 			, type: 'string', allowBlank: false},
	    	{name: 'AS_SEQ'		       	, text: '품목순번' 			, type: 'int'	, allowBlank: false},
	    	{name: 'PART_CODE'      	, text: '부품코드' 			, type: 'string', allowBlank: false},
	    	{name: 'PART_SEQ'			, text: '부품순번'          	, type: 'int'	, allowBlank: false},
	    	{name: 'ITEM_NAME'      	, text: '부품명' 				, type: 'string'},
	    	{name: 'SPEC'      			, text: '규격' 				, type: 'string'},
	    	{name: 'STOCK_UNIT'      	, text: '단위' 				, type: 'string'},
	    	{name: 'AS_Q'      			, text: '수량' 				, type: 'uniQty'},
	    	{name: 'AS_P'      			, text: '단가' 				, type: 'uniUnitPrice'},
	    	{name: 'AS_O'      			, text: '금액' 				, type: 'uniPrice'},
	    	{name: 'DUMMY_AS_O'      	, text: '기존금액' 			, type: 'uniPrice'},
	    	{name:'PREVENT_REMARK'		, text:'예방조치사항'			, type: 'string'},
	    	{name:'CAUSES_REMARK'		, text:'발생원인'				, type: 'string'},
	    	{name:'MANAGE_REMARK'		, text:'처리내용'				, type: 'string'},
	    	{name: 'REMARK'      		, text: '비고' 				, type: 'string'}
		]
	});
	
	Unilite.defineModel('esa200ukrvDetailModel3', {
	    fields: [
	    	{name: 'COMP_CODE'      	, text: '법인코드'				, type: 'string', allowBlank: false},
	    	{name: 'DIV_CODE'       	, text: '사업장' 				, type: 'string', allowBlank: false},
	    	{name: 'AS_NUM'      		, text: '접수번호' 			, type: 'string', allowBlank: false},
	    	{name: 'PERSON_NUMB'      	, text: '사원번호' 			, type: 'string', allowBlank: false},
	    	{name: 'PERSON_NAME' 		, text: '이름' 				, type: 'string'},
	    	{name: 'MAN_HOUR'      		, text: '투입M/D'				, type: 'uniQty'},
	    	{name: 'AVG_LABOR_CODE'     , text: '평균임률코드' 			, type: 'string', comboType:'AU', comboCode: 'S808',displayField:'value'},
	    	{name: 'AVG_LABOR_RATE'     , text: '평균임률' 			, type: 'uniPrice'},
	    	{name: 'LABOR_COST'      	, text: '노무비' 				, type: 'uniPrice'},
	    	{name: 'DUMMY_LABOR_COST'   , text: '기존노무비' 			, type: 'uniPrice'},
	    	{name: 'REMARK'      		, text: '비고' 				, type: 'string'}
		]
	});
		
	Unilite.defineModel('esa200ukrvDetailModel4', {
	    fields: [
	    	{name: 'COMP_CODE'      	, text: '법인코드'				, type: 'string', allowBlank: false},
	    	{name: 'DIV_CODE'       	, text: '사업장' 				, type: 'string', allowBlank: false},
	    	{name: 'AS_NUM'      		, text: '접수번호' 			, type: 'string', allowBlank: false},
	    	{name: 'SER_NO'				, text: '순번'				, type: 'int'	, allowBlank: false},
	    	{name: 'EXPENSE_NAME' 		, text: '경비명' 				, type: 'string'},
	    	{name: 'EXPENSE_COST'      	, text: '경비금액'				, type: 'uniPrice'},
	    	{name: 'DUMMY_EXPENSE_COST' , text: '기존경비금액'				, type: 'uniPrice'},
	    	{name: 'REMARK'      		, text: '비고' 				, type: 'string'}
		]
	});
	Unilite.defineModel('esa200ukrvOtherModel', {// 참조model
		fields: [
			{name: 'COMP_CODE'      	, text: '법인코드'			, type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장'				,type: 'string'},
	    	{name: 'AS_NUM'      		, text: '접수번호' 			, type: 'string'},
			{name: 'AS_SEQ'				, text: '순번'				, type: 'int'	, allowBlank: false},
			{name: 'ITEM_CODE'      	, text: '품목코드' 			, type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'      	, text: '품목명' 			, type: 'string'},
	    	{name: 'SPEC'      			, text: '규격' 				, type: 'string'},
	    	{name: 'STOCK_UNIT'      	, text: '단위' 				, type: 'string'},
	    	{name: 'AS_Q'      			, text: '수량' 				, type: 'uniQty'},
	    	{name: 'INOUT_DATE'      	, text: '접수일자' 			, type: 'uniDate'},
	    	{name: 'REMARK'      		, text: '메모' 				, type: 'string'}
		]
	});
	var detailStore1 = Unilite.createStore('esa200ukrvDetailStore1', {
		model: 'esa200ukrvDetailModel1',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy1,
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {		
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();       			
   			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate,toCreate,toDelete);
			var listLength = list.length;
			
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= masterForm.getValues();
			paramMaster.DIV_CODE = panelResult.getValue('DIV_CODE');
			if(inValidRecs.length == 0){
				var config = {
					params:[paramMaster],
					success : function()	{
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						
						UniAppManager.app.onQueryButtonDown();
					}
				}
				this.syncAllDirect(config);	
			}else {
				detailGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var detailStore2 = Unilite.createStore('esa200ukrvDetailStore2', {
		model: 'esa200ukrvDetailModel2',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy2,
		loadStoreRecords:function(record){
			if(!record){
        		return;
        	}
			this.load({
				params:{
					'DIV_CODE':record.data.DIV_CODE,
					'AS_NUM':record.data.AS_NUM,
					'AS_SEQ':record.data.AS_SEQ
				}
			})
		},
		saveStore: function() {		
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();       			
   			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate,toCreate,toDelete);
			var listLength = list.length;
			var paramMaster= masterForm.getValues();
			paramMaster.DIV_CODE = panelResult.getValue('DIV_CODE');
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0){
				var config = {
					params:[paramMaster],
					success : function()	{
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					
						masterForm.getForm().load({
							params : panelResult.getValues()
						});
						
						var selectedSubGrid = subGrid.getSelectedRecord();
        				detailStore2.loadStoreRecords(selectedSubGrid);
					}
				}
				this.syncAllDirect(config);	
			}else {
				detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var detailStore3 = Unilite.createStore('esa200ukrvDetailStore3', {
		model: 'esa200ukrvDetailModel3',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy3,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {		
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();       			
   			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate,toCreate,toDelete);
			var listLength = list.length;
			
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= masterForm.getValues();
			paramMaster.DIV_CODE = panelResult.getValue('DIV_CODE');
			if(inValidRecs.length == 0){
				var config = {
					params:[paramMaster],
					success : function()	{
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						
						masterForm.getForm().load({
							params : panelResult.getValues()
						});
					}
				}
				this.syncAllDirect(config);	
			}else {
				detailGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var detailStore4 = Unilite.createStore('esa200ukrvDetailStore4', {
		model: 'esa200ukrvDetailModel4',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy4,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {		
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();       			
   			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate,toCreate,toDelete);
			var listLength = list.length;
			
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= masterForm.getValues();
			paramMaster.DIV_CODE = panelResult.getValue('DIV_CODE');
			if(inValidRecs.length == 0){
				var config = {
					params:[paramMaster],
					success : function()	{
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						
						masterForm.getForm().load({
							params : panelResult.getValues()
						});
					}
				}
				this.syncAllDirect(config);	
			}else {
				detailGrid4.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	var panelResult = Unilite.createSearchForm('searchForm', {
    	region:'north',
	     layout : {type : 'uniTable', columns : 3},
	    padding: '1 1 1 1',
	    border: true,
	    items: [{
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank:false
        }, 
        Unilite.popup('AS_NUM', {
            fieldLabel: '접수번호',
            valueFieldName: 'AS_NUM_SEACH',
            textFieldName: 'AS_NUM_SEACH',
            allowBlank:false
        }), 
        {
            text: '보고서출력',
            itemId: 'printButton',
            id: 'printButton',
            xtype: 'button',
            margin: '0 0 0 100',
            disabled: true,
            handler: function() {
                if(!panelResult.getInvalidMessage()){
					return false;		
				}
                window.open(CPATH + '/equit/esa100rkrvExcelDown.do?AS_NUM_SEACH=' + panelResult.getValue('AS_NUM_SEACH') + '&DIV_CODE=' + panelResult.getValue('DIV_CODE'), "_self");
            }
	    }]
	});
	var masterForm = Unilite.createForm('esa200ukrvDetail', {
    	disabled :false,
    	border:true,
	    split: true,
    	region:'north',
	    padding: '1 1 1 1',
        layout : {type : 'uniTable', columns : 3},
	    api: {
            load : 'esa200ukrvService.selectForm',
            submit: 'esa200ukrvService.syncForm'	
	    },
		items: [{
			fieldLabel: '접수번호',
			name: 'AS_NUM',
			xtype:'uniTextfield',
   			readOnly : true,
			allowBlank:false
		},{
			fieldLabel: '접수일',
			name: 'ACCEPT_DATE',
			xtype:'uniDatefield',
   			readOnly : true,
			allowBlank:false
		},{
			fieldLabel: '접수자',
			name: 'ACCEPT_PRSN',
			xtype:'uniTextfield',
   			readOnly : true
		},{
			fieldLabel: 'AS요청자',
			name: 'AS_CUSTOMER_NM',
			xtype:'uniTextfield',
   			readOnly : true
		},{
			fieldLabel: '수주번호',
			name: 'ORDER_NUM',
			xtype:'uniTextfield',
   			readOnly : true
		},
		Unilite.popup('CUST',{
            fieldLabel: '수주처',
            valueFieldName:'AS_CUSTOMER_CD',
            textFieldName:'AS_CUSTOMER_NAME',
            readOnly: true
        }),
        {
			fieldLabel: '프로젝트번호',
			name: 'PROJECT_NO',
			xtype:'uniTextfield',
   			readOnly : true
		},{
			fieldLabel: '전화번호',
			name: 'PHONE',
			xtype:'uniTextfield',
   			readOnly : true
		},{
			fieldLabel: '완료일',
			name: 'CLOSE_DATE',
			xtype:'uniDatefield',
			colspan: 2,
   			readOnly : true
		},{
			fieldLabel: '재료비',
			xtype: 'uniNumberfield',
			name: 'ITEM_O',
   			readOnly : true
		},{
			fieldLabel: '재료비(계산관련사용)',
			xtype: 'uniNumberfield',
			name: 'DUMMY_ITEM_O',
   			readOnly : true,
   			hidden:true
		},{
			fieldLabel: '노무비',
			xtype: 'uniNumberfield',
			name: 'MAN_O',
   			readOnly : true
		},{
			fieldLabel: '노무비(계산관련사용)',
			xtype: 'uniNumberfield',
			name: 'DUMMY_MAN_O',
   			readOnly : true,
   			hidden:true
		},{
			fieldLabel: '경비',
			xtype: 'uniNumberfield',
			name: 'ETC_O',
   			readOnly : true
		},{
			fieldLabel: '경비(계산관련사용)',
			xtype: 'uniNumberfield',
			name: 'DUMMY_ETC_O',
   			readOnly : true,
   			hidden:true
		},{
			xtype:'container',
	    	layout:{type:'table', column: 2},
	    	items:[{
				fieldLabel: '총계약금액',
				xtype: 'uniNumberfield',
				type: 'uniPrice',
	   			readOnly : true,
				name: 'ORDER_O'
			},{
				fieldLabel: '',
				labelWidth : 0,
				width:50,
				xtype: 'uniTextfield',
				name: 'MONEY_UNIT',
	   			readOnly : true
			}]
	    },{
			fieldLabel: '비용합계',
			xtype: 'uniNumberfield',
			name: 'SUM_O',
   			readOnly : true,
   			colspan:2
		},{
			fieldLabel: '유무상(처리)',
			name: 'PAY_YN', 
			xtype: 'uniCombobox', 
			comboType: 'AU',
			comboCode: 'S802'
		},{
			fieldLabel: '진행상태',
			name: 'FINISH_YN', 
			xtype: 'uniCombobox', 
			comboType: 'AU',
			comboCode: 'B046',
			allowBlank:false
		}],
        listeners: {
	        uniOnChange: function(basicForm, field, newValue, oldValue) {
				if(basicForm.isDirty()){
	                UniAppManager.setToolbarButtons('save', true);
				}
	        }
	    }
	});
	
    var detailGrid1 = Unilite.createGrid('esa200ukrvGrid1', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
        	expandLastColumn: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        tbar:[{
			itemId: 'otherorderBtn',
			text: '<t:message code="Mpo501.label.BTN_REF" default="참조..."/>',
			iconCls : 'icon-referance',
			handler: function() {
				openOtherOrderWindow();
			},
			listeners:{
				click:function(){
					if(!panelResult.getInvalidMessage()){
						return false;		
					};
				}
			}
		}],
    	store: detailStore1,
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
		    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
		],
        columns: [
        	{ dataIndex: 'COMP_CODE'		, width: 80, hidden: true },
        	{ dataIndex: 'DIV_CODE'			, width: 80, hidden: true },
        	{ dataIndex: 'AS_NUM'			, width: 100 , hidden: true},
        	{ dataIndex: 'AS_SEQ'			, width: 60},
        	{ dataIndex: 'ITEM_CODE'        , width: 130,
                editor: Unilite.popup('DIV_PUMOK_G', {
                	textFieldName: 'ITEM_CODE',
                	DBtextFieldName: 'ITEM_CODE',
                	useBarcodeScanner: false,
                	autoPopup: true,
                	listeners: {
                		'onSelected': {
                			fn: function(records, type) {
                				console.log('records : ', records);
                				Ext.each(records, function(record,i) {
                					console.log('record',record);
                					if(i==0) {
                						detailGrid1.setItemData(record,false, detailGrid1.uniOpt.currentRecord);
                					} else {
                						UniAppManager.app.onNewDataButtonDown();
                						detailGrid1.setItemData(record,false, detailGrid1.getSelectedRecord());
                					}
                				});
                			},
                			scope: this
                		},
                		'onClear': function(type) {
                			detailGrid1.setItemData(null,true, detailGrid1.uniOpt.currentRecord);
                		},
                		applyextparam: function(popup){
                			popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                			popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
                            popup.setExtParam({'DEFAULT_ITEM_ACCOUNT': '10'});
                		}
                	}
                })
            },
            { dataIndex: 'ITEM_NAME'                 , width: 200,
                editor: Unilite.popup('DIV_PUMOK_G', {
                	textFieldName: 'ITEM_NAME',
                	DBtextFieldName: 'ITEM_NAME',
                	useBarcodeScanner: false,
                	autoPopup: true,
                	listeners: {
                		'onSelected': {
                			fn: function(records, type) {
                				console.log('records : ', records);
                				Ext.each(records, function(record,i) {
                					console.log('record',record);
                					if(i==0) {
                						detailGrid1.setItemData(record,false, detailGrid1.uniOpt.currentRecord);
                					} else {
                						UniAppManager.app.onNewDataButtonDown();
                						detailGrid1.setItemData(record,false, detailGrid1.getSelectedRecord());
                					}
                				});
                			},
                			scope: this
                		},
                		'onClear': function(type) {
                			detailGrid1.setItemData(null,true, detailGrid1.uniOpt.currentRecord);
                		},
                		applyextparam: function(popup){
                			popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                			popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
                            popup.setExtParam({'DEFAULT_ITEM_ACCOUNT': '10'});
                		}
                	}
                })
            },
        	{ dataIndex: 'SPEC'				, width: 150},
        	{ dataIndex: 'STOCK_UNIT'		, width: 60 , align:'center'},
        	{ dataIndex: 'AS_Q'				, width: 100},
        	{ dataIndex: 'CLOSE_DATE'		, width: 100},
        	{ dataIndex: 'BAD_GUBUN'		, width: 120},
        	{ dataIndex: 'PAY_YN'			, width: 80},
        	{ dataIndex: 'CLOSE_TYPE'		, width: 120},
        	{ dataIndex: 'REMARK'			, flex:1}
        ],
        setData:function(record){
        	var grdRecord = this.getSelectedRecord();
        	grdRecord.set('COMP_CODE'           , record['COMP_CODE']);
            grdRecord.set('DIV_CODE'          	, record['DIV_CODE']);
            grdRecord.set('ITEM_CODE'      		, record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'          	, record['ITEM_NAME']);
            grdRecord.set('SPEC'          		, record['SPEC']);
            grdRecord.set('STOCK_UNIT'         , record['STOCK_UNIT']);
            grdRecord.set('AS_Q'          		, record['AS_Q']);
            grdRecord.set('REMARK'          	, record['REMARK']);
        },
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       			grdRecord.set('SPEC'				, "");
       			grdRecord.set('STOCK_UNIT'			, "");
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('SPEC'				, record['SPEC']);
       			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
       		}
		},
    	listeners: {
    		beforeedit:function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','SPEC','AS_Q','CLOSE_DATE','BAD_GUBUN','PAY_YN','CLOSE_TYPE','REMARK'])){
					return true;
				}else{
					return false;
				}
    		}
    	}
    }); 
	var OrderSearch=Unilite.createSearchForm('OrderSerchForm',{
		layout: {type : 'uniTable', columns : 3},
		items:[{
			fieldLabel: '<t:message code="omegaplus.system.label.purchase.divCode" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120'
		},
		Unilite.popup('AS_NUM', {
			fieldLabel: '접수번호',
			valueFieldName:'AS_NUM',
            textFieldName:'AS_NUM'
		})
		]
	});
	var directProxy6= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api:{
			read: 'esa200ukrvService.selectOtherOrderList'
		}
	});
	var OrderStore=Unilite.createStore('eas200ukrvOtherStore', {
		model: 'esa200ukrvOtherModel',
		autoLoad: false,
           uniOpt : {
           	isMaster: true,			// 상위 버튼 연결
           	editable: false,			// 수정 모드 사용
           	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
           },
		proxy: directProxy6,
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)	{
    			   var masterRecords =detailStore1 .data.filterBy(detailStore1.filterNewOnly);  
    			   var orderRecords = new Array();
    			   if(masterRecords.items.length > 0)	{
        			   	Ext.each(records, function(item, i)	{           			   								
   							Ext.each(masterRecords.items, function(record, i)	{
   									if( (record.data['AS_NUM'] == item.data['AS_NUM'])
   									  ){
   										orderRecords.push(item);
   									}
   							});		
    			   		});
        			   store.remove(orderRecords);
    			   }
        		}
        	}
        },
        loadStoreRecords:function(){
         	var param=OrderSearch.getValues();
         	this.load({
         		params:param
         	});
        }
	});
	var OrderGrid=Unilite.createGrid('esa200ukrvOtherGrid',{
		layout:'fit',
		store:OrderStore,
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
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }), 
        columns:[
        	{ dataIndex: 'COMP_CODE'		, width: 80, hidden: true },
        	{ dataIndex: 'DIV_CODE'			, width: 80, hidden: true },
        	{ dataIndex: 'AS_NUM'			, width: 120},
        	{ dataIndex: 'AS_SEQ'			, width: 60},
        	{ dataIndex: 'ITEM_CODE'        , width: 120},
            { dataIndex: 'ITEM_NAME'        , width: 150},
           	{ dataIndex: 'SPEC'				, width: 150 , align:'center' },
            { dataIndex: 'STOCK_UNIT'		, width: 80},
            { dataIndex: 'AS_Q'				, width: 80},
            { dataIndex: 'INOUT_DATE'		, width: 80},
            { dataIndex: 'REMARK'			, width: 300}
        ],
        returnData: function(record)	{
			if(Ext.isEmpty(record))	{
      			records = this.getSelectedRecords();
      		}
			Ext.each(records, function(record,i) {
				UniAppManager.app.onNewDataButtonDown();
				detailGrid1.setData(record.data);
			});
       	}
	});
	
    function openOtherOrderWindow(){
    	if(!referOtherOrderWindow){
    		referOtherOrderWindow=Ext.create('widget.uniDetailWindow', {
    			title:'참조',
    			width: 950,				                
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [OrderSearch, OrderGrid],
                tbar:['->',
        			{	itemId : 'saveBtn',
						id:'saveBtn1',
						text: '조회',
						handler: function() {
							OrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						id:'confirmBtn1',
						text: '적용',
						handler: function() {
							OrderGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						id:'confirmCloseBtn1',
						text: '적용 후 닫기',
						handler: function() {
							OrderGrid.returnData();
							referOtherOrderWindow.hide();
						},
						disabled: false
				},{
					itemId : 'closeBtn',
					id:'closeBtn1',
					text: '닫기',
					handler: function() {
						referOtherOrderWindow.hide();
					},
					disabled: false
				}],
                listeners: {
					beforehide: function(me, eOpt)	{
	    			},
	    			beforeclose: function( panel, eOpts ) {
	    			},
	    			beforeshow: function ( me, eOpts )	{
                		OrderSearch.setValue('DIV_CODE', panelResult.getValue("DIV_CODE"));
                		OrderSearch.setValue('AS_NUM', panelResult.getValue('AS_NUM'));
                		OrderStore.loadStoreRecords();
                	}
                }
    		});
    	}
    	referOtherOrderWindow.center();
		referOtherOrderWindow.show();
    }
	
    var detailGrid2 = Unilite.createGrid('esa200ukrvGrid2', {
    	layout: 'fit',
        uniOpt: {
        	expandLastColumn: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	store: detailStore2,
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
		    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
		],
        columns: [
        	{ dataIndex: 'COMP_CODE'		, width: 80, hidden: true },
        	{ dataIndex: 'DIV_CODE'			, width: 80, hidden: true },
        	{ dataIndex: 'AS_NUM'			, width: 100, hidden: true},
        	{ dataIndex: 'AS_SEQ'			, width: 80, hidden: true },
        	{ dataIndex: 'PART_SEQ'			, width: 80 , align:'center'},
        	{ dataIndex: 'PART_CODE'        , width: 120,
                editor: Unilite.popup('DIV_PUMOK_G', {
                	textFieldName: 'ITEM_CODE',
                	DBtextFieldName: 'ITEM_CODE',
                	useBarcodeScanner: false,
                	autoPopup: true,
                	listeners: {
                		'onSelected': {
                			fn: function(records, type) {
	                            var grdRecord = detailGrid2.uniOpt.currentRecord;
                				detailGrid2.setItemData(records[0],false, grdRecord);
                			},
                			scope: this
                		},
                		'onClear': function(type) {
                            var grdRecord = detailGrid2.uniOpt.currentRecord;
                			detailGrid2.setItemData(null,true, grdRecord);
                		},
                		applyextparam: function(popup){
                			popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                		}
                	}
                })
            },
            { dataIndex: 'ITEM_NAME'                 , width: 150,
                editor: Unilite.popup('DIV_PUMOK_G', {
                	textFieldName: 'ITEM_NAME',
                	DBtextFieldName: 'ITEM_NAME',
                	useBarcodeScanner: false,
                	autoPopup: true,
                	listeners: {
                		'onSelected': {
                			fn: function(records, type) {
	                            var grdRecord = detailGrid2.uniOpt.currentRecord;
                				detailGrid2.setItemData(records[0],false, grdRecord);
                			},
                			scope: this
                		},
                		'onClear': function(type) {
                            var grdRecord = detailGrid2.uniOpt.currentRecord;
                			detailGrid2.setItemData(null,true, grdRecord);
                		},
                		applyextparam: function(popup){
                			popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                		}
                	}
                })
            },
        	{ dataIndex: 'SPEC'				, width: 150},
        	{ dataIndex: 'STOCK_UNIT'		, width: 60 , align:'center'},
        	{ dataIndex: 'AS_Q'				, width: 80},
        	{ dataIndex: 'AS_P'				, width: 120},
        	{ dataIndex: 'AS_O'				, width: 120},
        	{ dataIndex: 'DUMMY_AS_O'		, width: 120,hidden:true},
        	{ dataIndex: 'REMARK'			, width: 200},
        	{ dataIndex: 'MANAGE_REMARK'	, width: 200},
        	{ dataIndex: 'CAUSES_REMARK'	, width: 200},
        	{ dataIndex: 'PREVENT_REMARK'	, width: 200}
        ],
    	setItemData: function(record, dataClear,grdRecord) {
    		if(dataClear) {
       			grdRecord.set('PART_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       			grdRecord.set('SPEC'				, "");
       			grdRecord.set('STOCK_UNIT'			, "");
       			
       			grdRecord.set('AS_Q'			, 0);
       			grdRecord.set('AS_P'			, 0);
       			grdRecord.set('AS_O'			, 0);
       		} else {
       			var param = {
       				"DIV_CODE" : grdRecord.get('DIV_CODE'),
       				"PART_CODE" : record['ITEM_CODE']
       			};
       			esa200ukrvService.checkAsP(param, function(provider, response) {
       				if(!Ext.isEmpty(provider)){
	       				grdRecord.set('AS_P'			, provider.ITEM_PRICE);
       				}else{
	       				grdRecord.set('AS_P'			, 0);
       				}
       				
	       			grdRecord.set('PART_CODE'			, record['ITEM_CODE']);
	       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
	       			grdRecord.set('SPEC'				, record['SPEC']);
	       			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
	       			grdRecord.set('AS_Q'			, 0);
	       			grdRecord.set('AS_O'			, 0);
       			});
       		}
    	},
    	listeners: {
    		beforeedit:function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['PART_CODE','ITEM_NAME','SPEC','AS_Q','AS_P','AS_O','REMARK'])){
					return true;
				}else{
					return false;
				}
    		},
    		selectionchangerecord : function(selected) {
    			subForm.setActiveRecord(selected);
    		}
    	}
    });
   Unilite.defineModel('esa200ukrvSubModel', {
	    fields: [
	    	{name: 'AS_SEQ'		       	, text: '품목순번' 			, type: 'int'},
	    	{name: 'ITEM_CODE'		    , text: '발생품목' 			, type: 'string'},
	    	{name: 'ITEM_NAME'		    , text: '발생품목명' 			, type: 'string'},
	    	{name: 'AS_NUM'      		, text: '접수번호' 			, type: 'string', allowBlank: false},
	    	{name: 'COMP_CODE'      	, text: '법인코드'				, type: 'string', allowBlank: false},
	    	{name: 'DIV_CODE'       	, text: '사업장' 				, type: 'string', allowBlank: false}
		]
	});
    
    var subProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'esa200ukrvService.selectSubGrid'
		}
	});
    var subStore= Unilite.createStore('esa200ukrvSubStore', {
		model: 'esa200ukrvSubModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: subProxy1,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
    });
    
    var subGrid = Unilite.createGrid('esa200ukrvSubGrid', {
    	layout: 'fit',
        uniOpt: {
        	expandLastColumn: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        store:subStore,
        selModel:'rowmodel',
        columns:[
        	{dataIndex:'AS_SEQ',   width:80},
        	{dataIndex:'ITEM_CODE',width:100},
        	{dataIndex:'ITEM_NAME',flex:1},
        	{dataIndex:'AS_NUM',width:100,hidden:true},
        	{dataIndex:'COMP_CODE',width:100,hidden:true},
        	{dataIndex:'DIV_CODE',width:100,hidden:true}
        ],
        listeners:{
        	selectionchange:function(grid,selected,eOpts){
        		detailGrid2.reset();
        		detailStore2.clearData();
        		subForm.clearForm();
        		UniAppManager.setToolbarButtons(['delete','newData'],true);
        		if(selected[0]){
        			detailStore2.loadStoreRecords(selected[0]);
				
        		}
        	}
        }
    });
    
    var detailGrid3 = Unilite.createGrid('esa200ukrvGrid3', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
        	expandLastColumn: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	store: detailStore3,
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
		    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
		],
        columns: [
        	{ dataIndex: 'COMP_CODE'		, width: 80, hidden: true },
        	{ dataIndex: 'DIV_CODE'			, width: 80, hidden: true },
        	{ dataIndex: 'AS_NUM'			, width: 100, hidden: true},
        	{ dataIndex: 'PERSON_NUMB'      , width: 130,
        		editor: Unilite.popup('Employee_G',{
			  		autoPopup:true,
					listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid3.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB',records[0]['PERSON_NUMB']);
                            grdRecord.set('PERSON_NAME',records[0]['NAME']);
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid3.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB','');
                            grdRecord.set('PERSON_NAME','');
                        }
					}
				})
            },
            { dataIndex: 'PERSON_NAME'                 , width: 130,
            	editor: Unilite.popup('Employee_G',{
			  		autoPopup:true,
					listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = detailGrid3.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB',records[0]['PERSON_NUMB']);
                            grdRecord.set('PERSON_NAME',records[0]['NAME']);
                            
                        },
                        onClear:function(type)  {
                            var grdRecord = detailGrid3.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB','');
                            grdRecord.set('PERSON_NAME','');
                        }
					}
				})
            },
        	{ dataIndex: 'MAN_HOUR'			, width: 110},
        	{ dataIndex: 'AVG_LABOR_CODE'	, width: 90, align:'center'},
        	{ dataIndex: 'AVG_LABOR_RATE'	, width: 120},
        	{ dataIndex: 'LABOR_COST'		, width: 120},
        	{ dataIndex: 'DUMMY_LABOR_COST'	, width: 120,hidden:true},
        	{ dataIndex: 'REMARK'			, flex:1}
        ],
    	listeners: {
    		beforeedit:function(editor, e, eOpts) {
				if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['PERSON_NUMB','PERSON_NAME','MAN_HOUR','AVG_LABOR_CODE','AVG_LABOR_RATE','REMARK'])){
						return true;
					}else{
						return false;
					}
				}else{
					if(UniUtils.indexOf(e.field, ['MAN_HOUR','AVG_LABOR_CODE','AVG_LABOR_RATE','REMARK'])){
						return true;
					}else{
						return false;
					}
    			}
    		}
    	}
    });
    
    var detailGrid4 = Unilite.createGrid('esa200ukrvGrid4', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
        	expandLastColumn: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	store: detailStore4,
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
		    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
		],
        columns: [
        	{ dataIndex: 'COMP_CODE'		, width: 80, hidden: true },
        	{ dataIndex: 'DIV_CODE'			, width: 80, hidden: true },
        	{ dataIndex: 'AS_NUM'			, width: 100, hidden: true},
        	{ dataIndex: 'SER_NO'			, width: 80},
        	{ dataIndex: 'EXPENSE_NAME'		, width: 300},
        	{ dataIndex: 'EXPENSE_COST'		, width: 200},
        	{ dataIndex: 'DUMMY_EXPENSE_COST'	, width: 120,hidden:true},
        	{ dataIndex: 'REMARK'			, flex:1		}
        ],
    	listeners: {
    		beforeedit:function(editor, e, eOpts) {
				if(UniUtils.indexOf(e.field, ['EXPENSE_NAME','EXPENSE_COST','REMARK'])){
					return true;
				}else{
					return false;
				}
    		}
    	}
    });
    
    var subForm = Unilite.createForm('esa200ukrvSubForm', {
    	region:'center',
		layout : {type : 'uniTable', columns: 3,
            tableAttrs: {width: '100%'}
		},
		padding:'1 1 1 1',
    	masterGrid:detailGrid2,
		defaultType: 'textarea',
		border:true,
		autoScroll: true,
		disabled: false,
    	items :[{
    		fieldLabel:'처리내용',
    		name: 'MANAGE_REMARK',
    		width:400,
			height:160
    	},{
    		fieldLabel:'발생원인',
    		name: 'CAUSES_REMARK',
    		width:400,
    		height:160
    	},{
    		fieldLabel:'예방조치사항',
    		name: 'PREVENT_REMARK',
    		width:400,
    		height:160
    	}]
    });
    
	var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [{
	    	title: 'AS발생품목등록',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[detailGrid1],
	    	id: 'detailGrid1'
	    },{
	    	title: '소요품목등록',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
		    items : [{
                xtype    : 'container',
                flex     : 1,
                layout   : 'border',
                items : [{
                    region : 'west',
                    xtype  : 'container',
                    width  : '25%',
                    layout : 'fit',
					split:true,
                    items  : [ subGrid ]
                }, {
                    region : 'center',
                    xtype  : 'container',
                    layout : 'fit',
                    layout:{type:'vbox', align:'stretch'},
                    items  : [ detailGrid2, subForm]
                }]
	        }],
	        id:'detailGrid2'
	    },{
	    	title: '투입인원등록',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[detailGrid3],
	    	id: 'detailGrid3' 
	    },{
	    	title: '기타경비등록',
	    	xtype:'container',
	    	layout:{type:'vbox', align:'stretch'},
	    	items:[detailGrid4],
	    	id: 'detailGrid4' 
	    }],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
				if(!panelResult.getInvalidMessage()) return false;   // 필수체크
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				console.log("newCard : " + newCard.getId());
				console.log("oldCard : " + oldCard.getId());
				
				UniAppManager.app.onQueryButtonDown();
			}
	    }
	});
	
	Unilite.Main( {
		id : 'esa200ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				panelResult, masterForm, tab
			]
		}],
		fnInitBinding : function(param) {
            panelResult.setValue("DIV_CODE", UserInfo.divCode);
            
            UniAppManager.setToolbarButtons(['reset','newData'], true);
            UniAppManager.setToolbarButtons(['print','save'], false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterForm.clearForm();
			
			detailGrid1.reset();
			detailStore1.clearData();
			subGrid.reset();
			subStore.clearData();
			subForm.clearForm();
			detailGrid2.reset();
			detailStore2.clearData();
			detailGrid3.reset();
			detailStore3.clearData();
			detailGrid4.reset();
			detailStore4.clearData();
			
            this.fnInitInputFields();
        },
		onQueryButtonDown : function() {
			if(!panelResult.getInvalidMessage()) return;   // 필수체크
			
			masterForm.getForm().load({
				params : panelResult.getValues(),
				success: function(form, action)	{
                    Ext.getCmp("printButton").enable();
                    panelResult.getField('DIV_CODE').setReadOnly(true);
                    panelResult.getField('AS_NUM_SEACH').setReadOnly(true);
                    masterForm.getField('AS_NUM').setReadOnly(true);
					var activeTabId = tab.getActiveTab().getId();
					
					switch(activeTabId){
						case 'detailGrid1' : 
							detailStore1.loadStoreRecords();
							break;
						case 'detailGrid2' : 
							subStore.loadStoreRecords();
							break;
						case 'detailGrid3' : 
							detailStore3.loadStoreRecords();
							break;
						case 'detailGrid4' : 
							detailStore4.loadStoreRecords();
							break;
					}
					
					UniAppManager.setToolbarButtons('newData', true);
					subForm.clearForm();
				},
				failure: function(form, action)	{
                    Ext.getCmp("printButton").setDisabled(true);
				}
			});
		},
		onNewDataButtonDown: function()	{
			if(!masterForm.getInvalidMessage()) return;   // 필수체크
			
			var today 		= UniDate.get('today');
			var compCode 	= UserInfo.compCode;
			var divCode 	= panelResult.getValue('DIV_CODE');
			var asNum 		= masterForm.getValue('AS_NUM');
			var activeTabId = tab.getActiveTab().getId();
			switch(activeTabId){
				case 'detailGrid1' :
					var seq = detailStore1.max('AS_SEQ');
        	 		if(!seq) seq = 1;
        			 else  seq += 1;
					var r = {
						AS_SEQ		: seq,
						COMP_CODE 	: compCode,
						DIV_CODE 	: divCode,
						ITEM_CODE	: '',
						ITEM_NAME	: '',
						SPEC		: '',
						STOCK_UNIT	: '',
						CLOSE_DATE 		: today,
						AS_Q		: 0,
						AS_NUM 		: asNum,
						REMARK		: ''
					}
					detailGrid1.createRow(r);
					break;
				case 'detailGrid2' : 
					var asSeq		= subGrid.getSelectedRecord().get('AS_SEQ')
					var asNum1		= subGrid.getSelectedRecord().get('AS_NUM')
					var seq = detailStore2.max('PART_SEQ');
					if(!seq) seq = 1; 
					else seq += 1;
					
					var r = {
						AS_SEQ		:asSeq,
						PART_SEQ	: seq,
						COMP_CODE 	: compCode,
						DIV_CODE 	: divCode,	
						PART_CODE	: '',
						ITEM_NAME	: '',
						SPEC		: '',
						STOCK_UNIT	: '',
						AS_P		: 0,
						AS_Q		: 0,
						AS_O		: 0,
						AS_NUM 		: asNum1,
						REMARK		: ''
					}
					detailGrid2.createRow(r);
					break;
				case 'detailGrid3' :
					
					var r = {
						COMP_CODE 		: compCode,
						DIV_CODE 		: divCode,
						PERSON_NUMB		: '',
						PERSON_NAME			: '',
						MAN_HOUR		: 0,
						LABOR_COST		: 0,
						AS_NUM 			: asNum,
						REMARK			: ''
					}
					detailGrid3.createRow(r);
					break;
				case 'detailGrid4' :
					var seq = detailStore4.max('SER_NO');
					if(!seq) seq = 1; 
					else seq += 1;
					
					var r = {
						SER_NO			: seq,
						COMP_CODE 		: compCode,
						DIV_CODE 		: divCode,
						EXPENSE_NAME		: '',
						EXPENSE_COST		: 0,
						AS_NUM 			: asNum,
						REMARK			: ''
					}
					detailGrid4.createRow(r);
					break;
			}
		},
		onDeleteDataButtonDown: function() {
			
			var activeTabId = tab.getActiveTab().getId();
			
			var selRow = null;
			var selectGrid = null;
			if(activeTabId == 'detailGrid1'){
				selRow = detailGrid1.getSelectedRecord();
				selectGrid = detailGrid1;
			}else if(activeTabId == 'detailGrid2'){
				selRow = detailGrid2.getSelectedRecord();
				selectGrid = detailGrid2;
			}else if(activeTabId == 'detailGrid3'){
				selRow = detailGrid3.getSelectedRecord();
				selectGrid = detailGrid3;
			}else if(activeTabId == 'detailGrid4'){
				selRow = detailGrid4.getSelectedRecord();
				selectGrid = detailGrid4;
			}
			
			if(selRow.phantom === true)	{
				selectGrid.deleteSelectedRow();
				
				if(selectGrid == detailGrid2){	//소요품목등록
					
					masterForm.setValue('ITEM_O', masterForm.getValue('ITEM_O') - selRow.get('AS_O'));
					masterForm.setValue('SUM_O', masterForm.getValue('ITEM_O')+ masterForm.getValue('MAN_O') + masterForm.getValue('ETC_O'));
					var detailGrid2SelectedRecord = detailGrid2.getSelectedRecord();
					if(Ext.isEmpty(detailGrid2SelectedRecord)){
						subForm.clearForm();
					}
				}else if(selectGrid == detailGrid3){	//투입인원등록
					
					masterForm.setValue('MAN_O', masterForm.getValue('MAN_O') - selRow.get('LABOR_COST'));
					masterForm.setValue('SUM_O', masterForm.getValue('ITEM_O')+ masterForm.getValue('MAN_O') + masterForm.getValue('ETC_O'));
				}else if(selectGrid == detailGrid4){	//기타경비등록
					
					masterForm.setValue('ETC_O', masterForm.getValue('ETC_O') - selRow.get('EXPENSE_COST'));
					masterForm.setValue('SUM_O', masterForm.getValue('ITEM_O')+ masterForm.getValue('MAN_O') + masterForm.getValue('ETC_O'));
				}
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				selectGrid.deleteSelectedRow();
				
				if(selectGrid == detailGrid2){	//소요품목등록
					
					masterForm.setValue('ITEM_O', masterForm.getValue('ITEM_O') - selRow.get('AS_O'));
					masterForm.setValue('DUMMY_ITEM_O', masterForm.getValue('DUMMY_ITEM_O') - selRow.get('DUMMY_AS_O'));
					
					masterForm.setValue('SUM_O', masterForm.getValue('ITEM_O')+ masterForm.getValue('MAN_O') + masterForm.getValue('ETC_O'));

					var detailGrid2SelectedRecord = detailGrid2.getSelectedRecord();
					if(Ext.isEmpty(detailGrid2SelectedRecord)){
						subForm.clearForm();
					}
				}else if(selectGrid == detailGrid3){	//투입인원등록
					
					masterForm.setValue('MAN_O', masterForm.getValue('MAN_O') - selRow.get('LABOR_COST'));
					masterForm.setValue('DUMMY_MAN_O', masterForm.getValue('DUMMY_MAN_O') - selRow.get('DUMMY_LABOR_COST'));
					
					masterForm.setValue('SUM_O', masterForm.getValue('ITEM_O')+ masterForm.getValue('MAN_O') + masterForm.getValue('ETC_O'));

				}else if(selectGrid == detailGrid4){	//기타경비등록
					
					masterForm.setValue('ETC_O', masterForm.getValue('ETC_O') - selRow.get('EXPENSE_COST'));
					masterForm.setValue('DUMMY_ETC_O', masterForm.getValue('DUMMY_ETC_O') - selRow.get('DUMMY_EXPENSE_COST'));
					
					masterForm.setValue('SUM_O', masterForm.getValue('ITEM_O')+ masterForm.getValue('MAN_O') + masterForm.getValue('ETC_O'));

				}
			}
		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
			
			var selectSaveStore = '';
        	if(activeTabId == 'detailGrid1'){
				selectSaveStore = detailStore1;
        	}else if(activeTabId == 'detailGrid2'){
				selectSaveStore = detailStore2;
        	}else if(activeTabId == 'detailGrid3'){
				selectSaveStore = detailStore3;
        	}else if(activeTabId == 'detailGrid4'){
				selectSaveStore = detailStore4;
        	}
			
			if (!selectSaveStore.isDirty()) {
           		Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
            	var param = masterForm.getValues();
				param.DIV_CODE = panelResult.getValue('DIV_CODE');
                masterForm.getForm().submit({
                    params: param,
                    success: function(form, action) {
                        masterForm.getForm().wasDirty = false;
                        masterForm.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.updateStatus(Msg.sMB011); // "저장되었습니다.
                        Ext.getCmp("printButton").enable();
                        UniAppManager.app.onQueryButtonDown();
                        
                        Ext.getCmp('pageAll').getEl().unmask();  
                    },
					failure: function(form, action)	{
                        Ext.getCmp('pageAll').getEl().unmask();  	
                    }
                });
                
            } else {
                selectSaveStore.saveStore();
            }
		},
		fnInitInputFields: function(){
            panelResult.setValue("DIV_CODE", UserInfo.divCode);
            
            Ext.getCmp("printButton").setDisabled(true);
            panelResult.getField('DIV_CODE').setReadOnly(false);
            panelResult.getField('AS_NUM_SEACH').setReadOnly(false);
            masterForm.getField('AS_NUM').setReadOnly(false);
           
            UniAppManager.setToolbarButtons(['reset','newData'], true);
            UniAppManager.setToolbarButtons(['print','save'], false);
            
		},
		fnCalcO:function(gridName,newValue,oldValue) { 
			if(gridName == 'detailGrid2'){	//소요품목등록
				if(Ext.isEmpty(newValue)){
					var itemO = masterForm.getValue('DUMMY_ITEM_O');
					var dataAll = detailStore2.data.items;
					
					var originO = 0;
					var changeO = 0;
					Ext.each(dataAll, function(record, i){
						originO = originO + record.get('DUMMY_AS_O');
						changeO = changeO + record.get('AS_O');
					});
					itemO = itemO - originO + changeO;
					masterForm.setValue('ITEM_O',itemO);
					masterForm.setValue('SUM_O',itemO + masterForm.getValue('MAN_O') + masterForm.getValue('ETC_O'));
				}else{
					var itemO = masterForm.getValue('ITEM_O');
					
					itemO = itemO - oldValue + newValue;
					masterForm.setValue('ITEM_O',itemO);
					masterForm.setValue('SUM_O',itemO + masterForm.getValue('MAN_O') + masterForm.getValue('ETC_O'));
				}
				
			}else if(gridName == 'detailGrid3'){	//투입인원등록
				var manO = masterForm.getValue('DUMMY_MAN_O');
				var dataAll = detailStore3.data.items;
				
				var originO = 0;
				var changeO = 0;
				Ext.each(dataAll, function(record, i){
					originO = originO + record.get('DUMMY_LABOR_COST');
					changeO = changeO + record.get('LABOR_COST');
				});
				manO = manO - originO + changeO;
				masterForm.setValue('MAN_O',manO);
				masterForm.setValue('SUM_O',manO + masterForm.getValue('ITEM_O') + masterForm.getValue('ETC_O'));
				
			}else if(gridName == 'detailGrid4'){	//기타경비등록
				if(!Ext.isEmpty(newValue)){
					var etcO = masterForm.getValue('ETC_O');
					
					etcO = etcO - oldValue + newValue;
					masterForm.setValue('ETC_O',etcO);
					masterForm.setValue('SUM_O',etcO + masterForm.getValue('ITEM_O') + masterForm.getValue('MAN_O'));
				}
			}
		},
		deleteData : function(masterGrid){
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
		}
	});
	
	Unilite.createValidator('validator01', {
		store: detailStore1,
		grid: detailGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {	
				case "AS_Q" : 
					if(newValue <= 0){
						rv='품목수량은 0보다 큰값이어야합니다';
						break;
					}
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: detailStore2,
		grid: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {	
				case "AS_Q" : 
//					if(newValue <= 0){					20180910 유양산전 요청으로  0입력가능하도록 수정 
//						rv='수량은 0보다 큰값이어야합니다';
//						break;
//					}
					
					record.set('AS_O',newValue * record.get('AS_P'));
					
					UniAppManager.app.fnCalcO('detailGrid2');
					break;
					
				case "AS_P" : 
//					if(newValue <= 0){					20180910 유양산전 요청으로  0입력가능하도록 수정
//						rv='단가는 0보다 큰값이어야합니다';
//						break;
//					}
					
					record.set('AS_O',newValue * record.get('AS_Q'));
					
					UniAppManager.app.fnCalcO('detailGrid2');
					break;
					
				case "AS_O" :
				
//					if(record.get('AS_Q') <= 0){			20180910 유양산전 요청으로  0입력가능하도록 수정
//						rv='수량은 0보다 큰값이어야합니다';
//						break;
//					}
//					if(newValue <= 0){
//						rv='금액은 0보다 큰값이어야합니다';
//						break;
//					}
					record.set('AS_P',newValue / record.get('AS_Q'));
					
					UniAppManager.app.fnCalcO('detailGrid2',newValue,oldValue);

					
					
					break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator03', {
		store: detailStore3,
		grid: detailGrid3,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {	
				case "MAN_HOUR" : 
					if(newValue <= 0){
						rv='투입M/D는 0 이상이어야합니다';
						break;
					}
					
					record.set('LABOR_COST',newValue * record.get('AVG_LABOR_RATE'));
					
					UniAppManager.app.fnCalcO('detailGrid3');
					break;
					
				case "AVG_LABOR_CODE" :
					var avgLaborRate = 0;
					Ext.each(Ext.data.StoreManager.lookup('CBS_AU_S808').data.items, function(comboR,i){
						if(comboR.get('value') == newValue){
							avgLaborRate = comboR.get('text');
						}
					});
					
					record.set('AVG_LABOR_RATE', avgLaborRate);
					record.set('LABOR_COST', avgLaborRate * record.get('MAN_HOUR'));
					
					UniAppManager.app.fnCalcO('detailGrid3');
					break;
					
				case "AVG_LABOR_RATE" : 
					if(newValue <= 0){
						rv='평균임률는 0보다 큰값이어야합니다';
						break;
					}
					
					record.set('LABOR_COST', newValue * record.get('MAN_HOUR'));
					
					UniAppManager.app.fnCalcO('detailGrid3');
					break;
					
				case "LABOR_COST" :
				
					if(record.get('MAN_HOUR') <= 0){
						rv='투입시간은 0 이상이어야합니다';
						break;
					}
					if(newValue <= 0){
						rv='노무비는 0보다 큰값이어야합니다';
						break;
					}
					record.set('AVG_LABOR_RATE',newValue / record.get('MAN_HOUR'));
					
					UniAppManager.app.fnCalcO('detailGrid3');
					break;
			}
			return rv;
		}
	});
	Unilite.createValidator('validator04', {
		store: detailStore4,
		grid: detailGrid4,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {	
				case "EXPENSE_COST" : 
					if(newValue <= 0){
						rv='금액은 0 이상이어야합니다.';
						break;
					}
					UniAppManager.app.fnCalcO('detailGrid4',newValue,oldValue);
					break;
			}
			return rv;
		}
	});
};
</script>