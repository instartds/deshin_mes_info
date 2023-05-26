<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ass100ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A036" /> <!-- 삼각방법 -->
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
var getRefSubCode = ${getRefSubCode};

/*	alert("회계담당자 정보가 존재하지 않습니다. 먼저 담당자정보를 등록해 주십시오.");
	var tabPanel = parent.Ext.getCmp('contentTabPanel');
	if(tabPanel) {
		var activeTab = tabPanel.getActiveTab();
		var canClose = activeTab.onClose(activeTab);
		if(canClose)  {
			tabPanel.remove(activeTab);
		}
	} else {
		self.close();
	}
	*/

//if(getChargeCode == '' ){
//	alert('ㅇㅇㅇㅇ');
//	self.close();
//}
/*var output ='';
for(var key in useColList){
 output += key + '  :  ' + useColList[key] + '\n';
}
alert(output);*/



function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'ass100ukrService.selectList',
			update: 'ass100ukrService.updateDetail',
			create: 'ass100ukrService.insertDetail',
			destroy: 'ass100ukrService.deleteDetail',
			syncAll: 'ass100ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ass100ukrModel', {
	    fields: [  	  
	    	{name: 'ACCNT'				  , text: '계정코드'		 		,type: 'string',allowBlank:false},  	  
	    	{name: 'ACCNT_NAME'			  , text: '계정과목'		 		,type: 'string'},  	  
	    	{name: 'DEP_CTL'			  , text: '상각방법'		 		,type: 'string',comboType:'AU', comboCode:'A036',allowBlank:false},
	    	{name: 'GAAP_DRB_YEAR'		  , text: '내용년수'		 		,type: 'string',maxLength:3},
	    	{name: 'IFRS_DRB_YEAR'		  , text: 'IFRS 내용년수'			,type: 'string',maxLength:3},
	    	{name: 'JAN_RATE'			  , text: '잔존가율'		 		,type: 'float', format:'0.00', decimalPrecision:2 },  	  
	    	{name: 'PREFIX'       		  , text: '채번구분자'		 		,type: 'string',maxLength:5},  	  
	    	{name: 'SEQ_NUM'      		  , text: '채번자리수'		 		,type: 'string',maxLength:1},  	  
	    	{name: 'UPDATE_DB_USER'		  , text: '수정자'		 		,type: 'string'},  	  
	    	{name: 'UPDATE_DB_TIME'		  , text: '수정시간'		 		,type: 'string'},  	  
	    	{name: 'COMP_CODE'			  , text: '법인코드'		 		,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ass100ukrMasterStore1',{
		model: 'Ass100ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
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
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	
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
			items: [
				Unilite.popup('ACCNT',{
					fieldLabel: '계정코드', 
					valueFieldName:'ACCNT_CODE',
				    textFieldName:'ACCNT_NAME', 
				    listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
								panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
		                	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ACCNT_CODE', '');
							panelResult.setValue('ACCNT_NAME', '');
						},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
				})
			]		
		}]
	});	  
	
	var panelResult = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('ACCNT',{
				fieldLabel: '계정코드', 
				valueFieldName:'ACCNT_CODE',
			    textFieldName:'ACCNT_NAME',
			    listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
							panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ACCNT_CODE', '');
						panelSearch.setValue('ACCNT_NAME', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
			})
		]
	});	
		
    var masterGrid = Unilite.createGrid('atx425ukrGrid1', {
        region:'center',
    	store: directMasterStore,
    	excelTitle: '고정자산기본정보등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
			onLoadSelectFirst: true,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false, enableGroupingMenu:false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        	{dataIndex: 'ACCNT'					      	,		width: 120,
        		editor: Unilite.popup('ACCNT_G',{
					textFieldName: 'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
                    autoPopup: true,
					listeners:{ 
						'onSelected': {
	                    	fn: function(records, type  ){
	                    		var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
								grdRecord.set('ACCNT_NAME',records[0]['ACCNT_NAME']);
	                    	},
                    		scope: this
          	   			},
						'onClear' : function(type)	{
	                  		var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT','');
							grdRecord.set('ACCNT_NAME','');
	                  	},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
				})
        	},
        	{dataIndex: 'ACCNT_NAME'				    ,		width: 120,
        		editor: Unilite.popup('ACCNT_G',{
					textFieldName: 'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
                    autoPopup: true,
					listeners:{ 
						'onSelected': {
	                    	fn: function(records, type  ){
	                    		var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ACCNT',records[0]['ACCNT_CODE']);
								grdRecord.set('ACCNT_NAME',records[0]['ACCNT_NAME']);
	                    	},
                    		scope: this
          	   			},
						'onClear' : function(type)	{
	                  		var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT','');
							grdRecord.set('ACCNT_NAME','');
	                  	},
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "(SPEC_DIVI = 'K' OR SPEC_DIVI = 'K2') AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
					}
				})
        	},
        	{dataIndex: 'DEP_CTL'				      	,		width: 120},
        	{dataIndex: 'GAAP_DRB_YEAR'				    ,		width: 120,align:'center'},
        	{dataIndex: 'IFRS_DRB_YEAR'				    ,		width: 120,align:'center'},
        	{dataIndex: 'JAN_RATE'				      	,		width: 120,hidden:true/*,
        		renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
        			if(!Ext.isEmpty(val)){
        				return val+".00";
        			}else{
        				return val;
        			}
                }*/
        	},
        	{dataIndex: 'PREFIX'       			      	,		width: 120,align:'center'},
        	{dataIndex: 'SEQ_NUM'      			      	,		width: 120,align:'center'},
        	{dataIndex: 'UPDATE_DB_USER'			   	,		width: 120,hidden:true},
        	{dataIndex: 'UPDATE_DB_TIME'			    ,		width: 120,hidden:true},
        	{dataIndex: 'COMP_CODE'				      	,		width: 120,hidden:true}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'])){
						return false;
					}
				}else{
					if(UniUtils.indexOf(e.field, ['ACCNT','ACCNT_NAME','UPDATE_DB_USER','UPDATE_DB_TIME','COMP_CODE'])){
						return false;
					}	
				}
			},
			afterrender:function()	{
				UniAppManager.app.setHiddenColumn();
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,panelResult
			]	
		},
			panelSearch  	
		],
		id: 'ass100ukrApp',
		fnInitBinding : function() {
			if((Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE == ''){
				Ext.Msg.alert('확인',Msg.sMA0054);
//				var tabPanel = parent.Ext.getCmp('contentTabPanel');
//				if(tabPanel) {
//					var activeTab = tabPanel.getActiveTab();
//					var canClose = activeTab.onClose(activeTab);
//					if(canClose)  {
//						tabPanel.remove(activeTab);
//					}
//				} else {
//					self.close();
//				}
			}else{
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
			panelResult.getField('ACCNT_CODE').focus(); 
//			this.setDefault();
			}
			
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			var compCode   = UserInfo.compCode;

            var r = {
        	 	COMP_CODE    : compCode
	        };
				masterGrid.createRow(r,'ACCNT');
				
		},
		onResetButtonDown: function() {		
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			
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
				masterGrid.deleteSelectedRow();
			}
		},
		setHiddenColumn: function() {
			Ext.each(getRefSubCode, function(record, idx) {
				if(record.REF_CODE1 == 'Y'){
					masterGrid.getColumn('PREFIX').setVisible(true);
					masterGrid.getColumn('SEQ_NUM').setVisible(true);
				}else{
					masterGrid.getColumn('PREFIX').setVisible(false);
					masterGrid.getColumn('SEQ_NUM').setVisible(false);
				}
				if(record.SUB_CODE == '1'){
					masterGrid.getColumn('IFRS_DRB_YEAR').setVisible(false);
				}else{
					masterGrid.getColumn('GAAP_DRB_YEAR').setVisible(true);
					masterGrid.getColumn('IFRS_DRB_YEAR').setVisible(true);
				}
			});
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "GAAP_DRB_YEAR" :
					if(!Ext.isNumeric(newValue) || Ext.isEmpty(newValue)) {
						rv='<t:message code = "unilite.msg.sMB074"/>';	
	//					Ext.Msg.alert("확인","숫자만 입력가능합니다.");
					}
					break;
				case "IFRS_DRB_YEAR" :
					if(!Ext.isNumeric(newValue)|| Ext.isEmpty(newValue)) {  
						rv='<t:message code = "unilite.msg.sMB074"/>';	
	//					Ext.Msg.alert("확인","숫자만 입력가능합니다.");
					}
					break;
				case "JAN_RATE" :
					if(!Ext.isNumeric(newValue) || Ext.isEmpty(newValue)) {  
						rv='<t:message code = "unilite.msg.sMB074"/>';	
	//					Ext.Msg.alert("확인","숫자만 입력가능합니다.");
					}
					break;	
			}
			return rv;
		}
	});	
	
};


</script>
