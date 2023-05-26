<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tpl107ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="S002"/>	<!-- 수주구분		-->
<t:ExtComboStore comboType="AU" comboCode="S007"/>	<!-- 출고유형		-->
<t:ExtComboStore comboType="AU" comboCode="B013"/>	<!-- 판매단위 		-->
<t:ExtComboStore comboType="AU" comboCode="B059"/>	<!-- 과세여부 		-->
<t:ExtComboStore comboType="AU" comboCode="S014"/>	<!-- 계산서대상 	-->
<t:ExtComboStore comboType="AU" comboCode="S003"/>	<!-- 단가구분 		-->
<t:ExtComboStore comboType="AU" comboCode="S011"/>	<!-- 수주상태 		-->
<t:ExtComboStore comboType="AU" comboCode="S010"/>	<!-- 담당자 		-->
<t:ExtComboStore comboType="AU" comboCode="B038"/>	<!-- 결제방법 		-->
<t:ExtComboStore comboType="AU" comboCode="S024"/>	<!-- 부가세유형 	-->
<t:ExtComboStore comboType="AU" comboCode="S046"/>	<!-- 승인상태 		-->
<t:ExtComboStore comboType="AU" comboCode="B030"/>	<!-- 세액포함여부 	-->
<t:ExtComboStore comboType="AU" comboCode="B116"/>	<!-- 단가계산기준 	-->
<t:ExtComboStore comboType="AU" comboCode="S065"/>	<!-- 주문구분 		-->
<t:ExtComboStore comboType="AU" comboCode="B010"/>	<!-- 예/아니오 		-->
<t:ExtComboStore comboType="BOR120" pgmId="tpl107ukrv"/><!-- 사업장   	-->  
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>

<script type="text/javascript">

var excelWindow;	// 엑셀참조


var BsaCodeInfo = {};
	
var CustomCodeInfo = {
	
};

function appMain() {
  
	
	var masterForm = Unilite.createSearchPanel('tpl107ukrvMasterForm', {
		title: '입고정보',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        },
	        uniOnChange: function(basicForm, dirty, eOpts) {				
				
			}
		 },
	    items: [{ 
			title: '기본정보', 	
           	layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				value: UserInfo.divCode,
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '입고번호',
				name: 'ORDER_NUM',
				readOnly: false,
				holdable: 'hold'
			}, {
				fieldLabel: '입고일자',
				name: 'ORDER_DATE',
				xtype: 'uniDatefield',
				value: new Date(),
				allowBlank: false,
				holdable: 'hold'
			}
			]
	    }],		
		api: {
			load: 'tpl107ukrvService.selectMaster',
			submit: 'tpl107ukrvService.syncForm'				
		}
	    
	}); //End of var masterForm = Unilite.createForm('tpl107ukrvMasterForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value: UserInfo.divCode,
			allowBlank: false,
			holdable: 'hold',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
				
				}
			}
		},{
			fieldLabel: '입고번호',
			name: 'ORDER_NUM',
			readOnly: false,
			holdable: 'hold'
		},{
			fieldLabel: '입고일자',
			name: 'ORDER_DATE',
			xtype: 'uniDatefield',
			value: new Date(),
			allowBlank: false,
			holdable: 'hold'
		}]
	});

	
	Unilite.defineModel('tpl107ukrvDetailModel', {
	    fields: [
			{name: 'ORDER_NUM'      	 	, text:'입고번호'           , type: 'string' /*, isPk:true, pkGen:'user'*/},
			{name: 'SEQ'    			, text:'순번'				, type: 'int', allowBlank: false , defaultValue:0},
			{name: 'COL5'    			, text:'입고수량'			, type: 'uniQty', allowBlank: false , defaultValue:0},
			{name: 'COL1'        		, text:'품목코드'           , type: 'string', allowBlank: false},
			{name: 'COL2'        		, text:'품명'               , type: 'string'}
		]
	});
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'templateService.selectDetail',
			update: 'templateService.updateDetail',
			create: 'templateService.insertDetail',
			destroy: 'templateService.deleteDetail',
			syncAll: 'templateService.saveAll'
		}
	});

	var detailStore = Unilite.createStore('tpl107ukrvDetailStore', {
		model: 'tpl107ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
						
					}
				}
			});
		},
		saveStore: function() {				
			
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var orderNum = masterForm.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})
			//console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				this.syncAllDirect();
			} else {
                var grid = Ext.getCmp('tpl107ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
    var detailGrid = Unilite.createGrid('tpl107ukrvGrid', {
        layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false,
			useContextMenu: true,
			onLoadSelectFirst : true
        },
        margin: 0,
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '엑셀일괄등록',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [ {
					itemId: 'excelBtn',
					text: '엑셀일괄등록',
		        	handler: function() {
			        		openExcelWindow();
			        }
				}]
			})
		}],
    	store: detailStore,
        columns: [   
			{dataIndex: 'COL1',		width: 130},
			{dataIndex: 'COL2',		width: 150},
			{dataIndex: 'COL5',			width: 110}
		],
        setExcelData: function(record) {
   			var grdRecord = this.getSelectedRecord();
			grdRecord.set('COMP_CODE'			, UserInfo.compCode);
			grdRecord.set('SEQ'				, this.getStore().max('SEQ')+1);
   			grdRecord.set('COL1'			, record['ITEM_CODE']);
   			grdRecord.set('COL2'			, record['ITEM_NAME']);
   			grdRecord.set('COL5'				, record['QTY']);
			
		}
    });

   
	
    
	
	// 엑셀참조
	Unilite.Excel.defineModel('excel.tpl107.sheet01', {
	    fields: [
	             {name: 'ITEM_CODE',  	text:'품목코드', 			type: 'string'},
	             {name: 'QTY',  		text:'판매수량', 			type: 'uniQty'},
	             {name: 'ITEM_NAME',  	text:'품목명', 			type: 'string'} 
	    ]
	});
	function openExcelWindow() {
			
	        var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'tpl107',
                        grids: [
                        	 {
                        		itemId: 'grid01',
                        		title: '입고정보',                        		
                        		useCheckbox: true,
                        		model : 'excel.tpl107.sheet01',
                        		readApi: 'templateService.selectExcelUploadSheet1',
                        		columns: [
                             		     	 { dataIndex: 'ITEM_CODE',  		width: 120		} 
											,{ dataIndex: 'QTY',  				width: 80		} 
											,{ dataIndex: 'ITEM_NAME',  		width: 120		}               		     
                        		]
                        		
                        	}
                        ],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
                        	var grid = this.down('#grid01');
                			var records = grid.getSelectionModel().getSelection();       		
							Ext.each(records, function(record,i){	
											        	UniAppManager.app.onNewDataButtonDown();
											        	detailGrid.setExcelData(record.data);								        
												    }); 
							grid.getStore().remove(records);
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	};

    
    /**
	 * main app
	 */
    Unilite.Main({
		id: 'tpl107ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]	
		}		
		,masterForm 
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			
		},
		onQueryButtonDown: function() {
			detailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			detailGrid.createRow();
			},
		onResetButtonDown: function() {
			
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},		
		onDeleteDataButtonDown: function() {
			detailGrid.deleteSelectedRow();
		},
		onDeleteAllButtonDown: function() {
		
		},
		onDetailButtonDown: function() {
		
		}
	});
}
</script>
