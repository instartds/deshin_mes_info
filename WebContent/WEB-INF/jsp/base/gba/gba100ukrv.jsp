<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="gba100ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장				 	-->  
	<t:ExtComboStore comboType="AU" comboCode="B248" /> <!-- 예산구분 			 		-->
</t:appConfig>

<script type="text/javascript" >

function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Gba100Model', {
	    fields: [
	    	{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'			, type: 'string'},
	    	{name: 'DIV_CODE'			, text: '사업장코드'		, type: 'string'},
	    	{name: 'PJT_TYPE'			, text: '프로젝트구분'		, type: 'string'},
	    	{name: 'PJT_CODE'			, text: '프로젝트코드'		, type: 'string'},
	    	{name: 'BUDG_CODE'			, text: '예산코드'			, type: 'string'	, allowBlank: false},
			{name: 'BUDG_NAME'			, text: '예산명'			, type: 'string'	, allowBlank: false},
			{name: 'ORDER_Q'			, text: '수주수량'			, type: 'uniQty'},
			{name: 'ORDER_P'			, text: '수주단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '수주금액'			, type: 'uniPrice'},
			{name: 'BUDG_O'				, text: '예산금액'			, type: 'uniPrice'},
			{name: 'REMARK'				, text: '<t:message code="system.label.base.remarks" default="비고"/>'			, type: 'string'}
	    ]
	});
	 
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	 var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 'gba100ukrvService.selectList'
        	,update : 'gba100ukrvService.updateMulti'
			,create : 'gba100ukrvService.insertMulti'
			,destroy: 'gba100ukrvService.deleteMulti'
			,syncAll: 'gba100ukrvService.saveAll'
		}
	});
	var directMasterStore = Unilite.createStore('gba100ukrvMasterStore',{
			model: 'Gba100Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy,
            listeners: {

            },
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				debugger;
				this.load({
					params : param
				});
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			saveStore : function()	{		
				var toCreate = this.getNewRecords();
	            var toUpdate = this.getUpdatedRecords();
	            var toDelete = this.getRemovedRecords();
	            
	            var list = [].concat(toUpdate, toCreate, toDelete);
	            
	            console.log(list);

	            var inValidRecs = this.getInvalidRecords();
	            var paramMaster= panelSearch.getValues();	//syncAll 수정
	            
	            if (inValidRecs.length == 0) {
	                config = {
	                	params: [paramMaster],
	                    success: function (batch, option) {
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
	            } else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
            
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm',{
        layout : {type : 'uniTable' , columns: 3, tableAttrs: {width: '100%'}},
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            useMultipleSorting: false,
            userToolbar: false,
            onLoadSelectFirst: false
        },
        items: [{
        	fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
        	name:'DIV_CODE',
        	xtype: 'uniCombobox', 
        	comboType:'BOR120',
        	allowBlank:false,
        	value: UserInfo.divCode,
        	listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
        }, Unilite.popup('PROJECT',{
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
		})],
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
    var masterGrid = Unilite.createGrid('gba100ukrvGrid', {
    	store: directMasterStore,
    	uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [
		    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
		],
		columns:[
        	{dataIndex: 'BUDG_CODE'		, text: '예산코드'	, width: 150	
        		,editor: Unilite.popup('BUDG_G',{
        			textFieldName: 'BUDG_CODE',
					DBtextFieldName: 'BUDG_CODE',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							
							grdRecord.set('BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('BUDG_NAME'		,records[0]['BUDG_NAME']);
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								var param = {
									'DIV_CODE' : grdRecord.get('DIV_CODE'),
									'BUDG_TYPE'	: '3',
									'ADD_QUERY' : 'CODE_LEVEL = 2'
								}
								popup.setExtParam(param);
							}
						}
					}
				}),
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
                }
        	},
   /*     	{dataIndex: 'BUDG_NAME'		, text: '항목명'		, width: 200
        		,editor: Unilite.popup('BUDG_G',{
        			textFieldName: 'BUDG_NAME',
					DBtextFieldName: 'BUDG_NAME',
					autoPopup: true,
					listeners:{ 
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							
							grdRecord.set('BUDG_CODE'		,records[0]['BUDG_CODE']);
							grdRecord.set('BUDG_NAME'		,records[0]['BUDG_NAME']);
						},
						onClear:function(type)	{
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('BUDG_CODE'		,'');
							grdRecord.set('BUDG_NAME'		,'');
					  	},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								var param = {
									'DIV_CODE' : grdRecord.get('DIV_CODE'),
									'BUDG_TYPE'	: '3',
									'ADD_QUERY' : 'CODE_LEVEL = 2'
								}
								popup.setExtParam(param);
							}
						}
					}
				})
			},*/
        	{dataIndex: 'BUDG_NAME'		, text: '예산명'		,width: 200},
			{dataIndex: 'COMP_CODE'		, hidden:true 		,width: 100},
			{dataIndex: 'DIV_CODE'		, hidden:true		,width:	100},
			{dataIndex: 'PJT_TYPE'		, hidden:true		, width: 80},
        	{dataIndex: 'PJT_CODE'		, hidden:true		, width: 80},
        	{dataIndex: 'ORDER_Q'		, text: '수주수량'		, width: 120, summaryType: 'sum'},
        	{dataIndex: 'ORDER_P'		, text: '수주단가'		, width: 120},
        	{dataIndex: 'ORDER_O'		, text: '수주금액'		, width: 120, summaryType: 'sum'},
        	{dataIndex: 'BUDG_O'		, text: '예산금액'		, width: 120, summaryType: 'sum'},
        	{dataIndex: 'REMARK'		, text: '<t:message code="system.label.base.remarks" default="비고"/>'		, width: 300}
        ],
        listeners: {
            beforeedit: function(editor, e, eOpts) {
                if (e.field == "ORDER_Q"||"ORDER_P"||"ORDER_O"||"BUDG_O"){
                	return true;
                }
                return false;
            }
        }
    });                                                           	
                                                                  	
  	Unilite.Main({                                                 
		items : [panelSearch, 	masterGrid],
		id  : 'gba100ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset'],false);
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['newData', 'reset'],true);
		},
		onSaveAndQueryButtonDown : function() {
			this.onSaveDataButtonDown();
		},
		onNewDataButtonDown : function() {
			if(!this.checkForNewDetail()) return false;

			/**
			 * Detail Grid Default 값 설정
			 */
			var compCode = UserInfo.compCode;
			var divCode = panelSearch.getValue('DIV_CODE');
			var pjtCode = panelSearch.getValue('PJT_CODE');
			var pjtType = '1';    //1:외부, 2:사내
        	 var r = {
        	 	COMP_CODE:			compCode,
        	 	DIV_CODE :			divCode,
        	 	PJT_CODE :          pjtCode,
        	 	PJT_TYPE :          pjtType
	        };
			masterGrid.createRow(r);
			
			UniAppManager.setToolbarButtons('save', true);
		},
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('gba100ukrvGrid');
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown : function()	{
			var record = masterGrid.getSelectionModel().getSelection();
			masterGrid.deleteSelectedRow();
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('gba100ukrvGrid');
			Ext.getCmp('searchForm').getForm().reset();
			masterGrid.reset();
			directMasterStore.clearData();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
			this.fnInitBinding();
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		fnCalOrderAmt: function(rtnRecord, sType, nValue) { 
			var dOrderUnitQ= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q'),0);
			var dOrderUnitP= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P'),0);
			var dOrderO= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0); 

			if(sType == 'P' || sType == 'Q'){
				dOrderO = Unilite.multiply(dOrderUnitQ, dOrderUnitP) //금액 = 발주량 * 단가
				rtnRecord.set('ORDER_O', dOrderO);
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
				case "ORDER_Q" : //발주량
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
			}
			return rv;
		}
	});

}; 


</script>
