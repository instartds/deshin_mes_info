<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="gba200skrv"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장				 	-->  
	<t:ExtComboStore comboType="AU" comboCode="B248" /> <!-- 예산구분 			 		-->
</t:appConfig>

<script type="text/javascript" >

var lastYearCopyWindow; // 전년도자료복사 버튼

function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Gba200Model', {
		// pkGen : user, system(default)
		//idProperty: 'TREE_CODE',
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '사업장코드'		, type: 'string'},
	    	{name: 'GUBUN'				, text: '분류'			, type: 'string'},
	    	{name: 'ITEM_CODE'			, text: '항목'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '항목명'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.base.spec" default="규격"/>'			, type: 'string'},
			{name: 'ORDER_UNIT_Q'		, text: '수주수량'			, type: 'uniQty'},
			{name: 'ORDER_P'			, text: '수주단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '수주금액'			, type: 'uniPrice'},
			{name: 'BUDGET_UNIT_O'		, text: '예산단가'			, type: 'uniUnitPrice'},
			{name: 'BUDGET_O'			, text: '예산금액'			, type: 'uniPrice'},
			{name: 'ORDER_RATE'			, text: '수주비율(%)'		, type: 'uniPercent'},
			{name: 'REMARK'				, text: '<t:message code="system.label.base.remarks" default="비고"/>'			, type: 'string'}
	    ]
	});
	 
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	 var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 'gba200skrvService.selectList'
        	,update : 'gba200skrvService.updateMulti'
			,create : 'gba200skrvService.insertMulti'
			,destroy: 'gba200skrvService.deleteMulti'
			,syncAll: 'gba200skrvService.saveAll'
		}
	});
	var directMasterStore = Unilite.createStore('gba200skrvMasterStore',{
			model: 'Gba200Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용 
            },
            proxy: directProxy,
            listeners: {
            	load:function(store, records, successful, eOpts) {
            		if(successful){
            			console.log("store.items :", store.items);
    			   		console.log("records", records);
    			   		var orderSum = 0;
    			   		Ext.each(records, function(item, i)	{           			   								
    			   			if(item.data['GUBUN'].indexOf('직접재료비') > -1){
    			   				orderSum += item.data['ORDER_O'];
    			   			}
     			   		});
    			   		console.log(orderSum);
    			   		Ext.each(records, function(item, i)	{           			   								
//    			   			if(item.data['GUBUN'].indexOf('기타경비') > -1){
//    			   				item.data['ORDER_O'] = orderSum * item.data['ORDER_RATE'];
//    			   			}
     			   		});
    			   		console.log(records);
            		}
            	}
            },
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기
			loadStoreRecords : function() {
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			saveStore : function() {		
				var me = this;
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				
				// 상위 부서 코드 정리
				var toCreate = me.getNewRecords();
           		var toUpdate = me.getUpdatedRecords();
           		var toDelete = me.getRemovedRecords();
           		var list = [].concat( toUpdate, toCreate );
           		
           		var paramMaster= panelSearch.getValues();	//syncAll 수정
				
				console.log("list:", list);
				if(inValidRecs.length == 0 ) {
					config = {
						params: [paramMaster],
						success: function(batch, option) {
							panelSearch.getForm().wasDirty = false;
							panelSearch.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
							if (directMasterStore.count() == 0) {
								UniAppManager.app.onResetButtonDown();
							}else{
								directMasterStore.loadStoreRecords();
							}
						 }
					};
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},			
			groupField: 'GUBUN'
		});

	var panelFileDown = Unilite.createForm('FileDownForm', {
		url: CPATH+'/base/gba210skrvExcelDown.do',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true,  
		items:[{
			xtype: 'uniTextfield',
			name: 'DIV_CODE'
		},{
			xtype: 'uniTextfield',
			name: 'PJT_CODE'
		},{
			xtype:'uniTextfield',
			name:'BUDG_DATA'
		}]
	});
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable' , columns: 3, tableAttrs: {width: '100%'}},
        items: [{
        	fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
        	name:'DIV_CODE',
        	xtype: 'uniCombobox',
        	comboType:'BOR120',
        	allowBlank:false,
        	value: UserInfo.divCode,
        	listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					UniAppManager.app.onQueryButtonDown();
				}
			}
        },Unilite.popup('PROJECT',{
			fieldLabel: '프로젝트번호',
			valueFieldName:'PJT_CODE',
		    textFieldName:'PJT_NAME',
       		DBvalueFieldName: 'PJT_CODE',
		    DBtextFieldName: 'PJT_NAME',
			validateBlank: false,
			allowBlank:false,
			textFieldOnly: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				}, 
				applyextparam: function(popup) {
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),{
        	xtype:'button',
        	text:'손익예산서출력',
        	//disabled: true,
        	id : 'excelDown',
        	handler:function(){
        		if(panelSearch.setAllFieldsReadOnly(true) == false){
    				return ;
    			}
        		
        		var form = panelFileDown;
        		form.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
        		form.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
        		
        		var toUpdate = directMasterStore.getUpdatedRecords();
        		var budgData = [];
        		if(toUpdate.length > 0){
        			for(var i = 0; i < toUpdate.length; i++){
            			var data = toUpdate[i].data;
            			var itemCode = data.ITEM_CODE;
            			var budgetO = data.BUDGET_O;
            			var budgetP = data.BUDGET_UNIT_O;
            			budgData.push({
            				'ITEM_CODE' 	: itemCode,
            				'BUDGET_UNIT_O' : budgetP,
            				'BUDGET_O' 		: budgetO
            			});
            		}
        		}
        		
        		form.setValue('BUDG_DATA', JSON.stringify(budgData));
        		var param = form.getValues();

        		form.submit({
                    params: param,
                    success:function()  {
                    },
                    failure: function(form, action){
                    }
                });
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
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
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
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
	});	//end panelSearch 

    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('gba200skrvGrid', {
    	store: directMasterStore,
    	uniOpt:{	
        	useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter  : false,
				autoCreate : false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
        
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
		    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
		],
		columns:[
			{text:'예산항목',
				columns:[
					{dataIndex: 'GUBUN'			, text: '분류'		, width: 100, hidden:true},
					{dataIndex: 'ITEM_CODE'		, text: '항목'		, width: 100,
		            		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		                  		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
		                    }},
		        	{dataIndex: 'ITEM_NAME'		, text: '항목명'		, width: 200},
		        	{dataIndex: 'SPEC'	   		, text: '<t:message code="system.label.base.spec" default="규격"/>'		, width: 150}
				]
			},
			{text:'수주',
				columns:[
					{dataIndex: 'ORDER_UNIT_Q'  ,text: '수량'			, width: 80  ,summaryType: 'sum'},
					{dataIndex: 'ORDER_P'  		,text: '단가'			, width: 100},
		        	{dataIndex: 'ORDER_O'  		,text: '수주금액'		, width: 120 ,summaryType: 'sum'}
				]
			},
			{text:'예산',
				columns:[
					{dataIndex: 'BUDGET_UNIT_O'  	,text: '단가'		, width: 100},
		        	{dataIndex: 'BUDGET_O'  		,text: '예산금액'	, width: 120 ,summaryType: 'sum'}
				]
			},
			{dataIndex: 'ORDER_RATE'    , text:'수주비율(%)'		, width: 90},
        	{dataIndex: 'REMARK'		, text:'<t:message code="system.label.base.remarks" default="비고"/>'			, width: 150}
        ],
        listeners: {
            beforeedit: function(editor, e, eOpts) {
                if (e.field == "ORDER_UNIT_Q"||"ORDER_P"||"ORDER_O"||"BUDGET_UNIT_O"){
                	return true;
                }
                return false;
            }
        }
    });                                                           	
                                                                  	
  	Unilite.Main({
		items : [panelSearch, 	masterGrid],
		id  : 'gba200skrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['newData'],true);
			//this.onQueryButtonDown();
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onSaveAndQueryButtonDown : function() {
			this.onSaveDataButtonDown();
		},
		onNewDataButtonDown : function() {
		},
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('gba200skrvGrid');
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown : function()	{
			var record = masterGrid.getSelectionModel().getSelection();
			masterGrid.deleteSelectedRow();
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('gba200skrvGrid');
			Ext.getCmp('searchForm').getForm().reset();
			masterGrid.reset();
			directMasterStore.clearData();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
			this.fnInitBinding();
		},
		fnCalOrderAmt: function(rtnRecord, sType, nValue) { 
			var dOrderUnitQ= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_UNIT_Q'),0);
			var dOrderUnitP= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P'),0);
			var dBudgUnitP= sType =='PP' ? nValue : Unilite.nvl(rtnRecord.get('BUDGET_UNIT_O'),0);
			var dOrderO= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0); 
			var dBudgetO= sType =='OO' ? nValue : Unilite.nvl(rtnRecord.get('BUDGET_O'),0); 

			if(sType == 'P' || sType == 'Q' || sType == 'PP'){
				dOrderO = dOrderUnitQ * dOrderUnitP; //금액 = 발주량 * 단가
				dBudgetO = dOrderUnitQ * dBudgUnitP; //금액 = 발주량 * 단가
				rtnRecord.set('ORDER_O', dOrderO);
				rtnRecord.set('BUDGET_O', dBudgetO);
				rtnRecord.set('ORDER_RATE', ( dBudgetO / dOrderO* 100).toFixed(2) + "%");
			}
		}

	});
  	
  	
  	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_UNIT_Q" : //발주량
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
					break;
					
				case "ORDER_P":    // 단가
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
					break;
				case "BUDGET_UNIT_O":    // 단가
					if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnCalOrderAmt(record, "PP", newValue);
					break;
				
			}
			return rv;
		}
	});
  	

}; 


</script>
