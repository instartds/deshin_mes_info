<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tpl101ukrv"  >
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'templateService.selectMaster',
			update: 'templateService.updateDetail',
			create: 'templateService.insertDetail',
			destroy: 'templateService.deleteDetail',
			syncAll: 'templateService.saveAll'
		}
	});	
	
	Unilite.defineModel('Tpl101ukrvModel', {
	    fields: [  	  
	    	{name: 'SEQ'      		, text: '순번' 		,type: 'int'},
	    	{name: 'COL1'      		, text: '코드' 		,type: 'string'},
	    	{name: 'COL2'			, text: '품목명' 		,type: 'string'},
	    	{name: 'tempC2'			, text: '품목형태' 	,type: 'string'},
	    	{name: 'tempC3'			, text: '품목분류1' 	,type: 'string'},
	    	{name: 'tempC4'			, text: '품목분류2' 	,type: 'string'},
	    	{name: 'tempC6'			, text: '품목과세' 	,type: 'string'},
	    	{name: 'tempC7'			, text: '품목상태' 	,type: 'string'},
	    	{name: 'tempC8'			, text: '매출일자' 	,type: 'uniDate'},
	    	{name: 'tempC9'			, text: '정가' 		,type: 'uniUnitPrice'},
	    	{name: 'tempC10'		, text: '매입처코드' 	,type: 'string'},
	    	{name: 'tempC11'		, text: '매입처명' 	,type: 'string'},
	    	{name: 'tempC12'		, text: '매입단가' 	,type: 'uniUnitPrice'},
	    	{name: 'tempC13'		, text: '손익단위1' 	,type: 'string'},
	    	{name: 'tempC14'		, text: '손익단위2' 	,type: 'string'},
	    	{name: 'tempC15'		, text: '귀속부서코드' 	,type: 'string'},
	    	{name: 'tempC16'		, text: '귀속부서명' 	,type: 'string'},
	    	{name: 'tempC17'		, text: '비고' 		,type: 'string'}
	    	
		]
	});
	
	Unilite.defineModel('Tpl101ukrvSubModel', {
	    fields: [  	  
	    	{name: 'COL1'      	, text: '변경일자' 		,type: 'string'},
	    	{name: 'COL2'      	, text: '손익단위코드' 		,type: 'string'},
	    	{name: 'COL3'      	, text: '손익단위명' 		,type: 'string'},
	    	{name: 'COL4'      	, text: '귀속부서코드' 		,type: 'string'},
	    	{name: 'COL5'      	, text: '귀속부서명' 		,type: 'string'},
	    	{name: 't6'      	, text: '정가' 			,type: 'uniUnitPrice'},
	    	{name: 't7'      	, text: '매입단가' 		,type: 'uniUnitPrice'}
		]
	});
	
	var directMasterStore = Unilite.createStore('tpl101ukrvMasterStore',{
		model: 'Tpl101ukrvModel',
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
						subStore.loadStoreRecords();
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
           			informationForm.setActiveRecord(recordsFirst);
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
	
	var subStore = Unilite.createStore('tpl101ukrvSubStore',{
		model: 'Tpl101ukrvSubModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
            	read: 'templateService.selectDetail'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			this.load({
				params : param
			});
		}
	});
	var subGrid = Unilite.createGrid('tpl100ukrvSubGrid', {
    	height: 230,
    	width: 800,
    	store: subStore,
    	excelTitle: 'History',
        uniOpt: {
    		useLiveSearch		: true,//내용검색 버튼 사용 여부
    		onLoadSelectFirst	: false, //조회시 첫번째 레코드 select 사용여부
    		useGroupSummary		: false,//그룹핑 버튼 사용 여부
			useContextMenu		: false,//Context 메뉴 자동 생성 여부 
			useRowNumberer		: true,//번호 컬럼 사용 여부	
			expandLastColumn	: false,//마지막컬럼 빈컬럼 사용여부
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false			//그리드 설정 목록 사용 여부
			}
		},
    	
		columns:  [
			{dataIndex: 'COL1'			, width: 100},
			{dataIndex: 'COL2'			, width: 100},
			{dataIndex: 'COL3'			, width: 120},
			{dataIndex: 'COL4'			, width: 100},
			{dataIndex: 'COL5'			, width: 120},
			{dataIndex: 't6'			, width: 100},
			{dataIndex: 't7'			, width: 100}
        ],
		listeners:{
			beforeedit : function( editor, e, eOpts ) {	//그리드 레코드 edit 전
				return false;
			},
			selectionchangerecord : function(selected)	{	//로우 선택 변경시
          		detailForm.setActiveRecord(selected);
          	}
		}
    });
	
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
			items: [{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				items :[{
					xtype:'uniTextfield',
					fieldLabel: '품목분류', 
					width:160,
					name:'t1',
					listeners: {
			            change: function(field, newValue, oldValue, eOpts) {
			            	panelResult.setValue('t1', newValue);								
			            }
	        		}
				},{
					xtype:'uniTextfield',
					name:'t2',
					width:165,
					listeners: {
			            change: function(field, newValue, oldValue, eOpts) {
			            	panelResult.setValue('t2', newValue);								
			            }
	        		}
				}]
	    	},{
	    		xtype: 'uniCheckboxgroup',		            		
	    		fieldLabel: '품목형태',
	    		items: [{
	    			boxLabel: '상품',
	    			width: 100,
	    			name: 't3',
	    			listeners: {
			            change: function(field, newValue, oldValue, eOpts) {
			            	panelResult.setValue('t3', newValue);								
			            }
	        		}
	    		},{
	    			boxLabel: '제품',
	    			width: 100,
	    			name: 't4',
	    			listeners: {
			            change: function(field, newValue, oldValue, eOpts) {
			            	panelResult.setValue('t4', newValue);								
			            }
	        		}
	    		}]
	        },{
				xtype:'uniTextfield',
				fieldLabel: '품목명', 
				width:325,
				name:'t5',
				listeners: {
		            change: function(field, newValue, oldValue, eOpts) {
		            	panelResult.setValue('t5', newValue);								
		            }
        		}
			},{
				xtype: 'uniDatefield',
	        	fieldLabel: '기준일자',
	        	name:'t6',
	        	listeners: {
	        		change: function(field, newValue, oldValue, eOpts) {
		            	panelResult.setValue('t6', newValue);								
		            }
				}
	        }]		
		}]
	});	  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			items :[{
				xtype:'uniTextfield',
				fieldLabel: '품목분류', 
				width:160,
				name:'t1',
				listeners: {
		            change: function(field, newValue, oldValue, eOpts) {
		            	panelSearch.setValue('t1', newValue);								
		            }
	    		}
			},{
				xtype:'uniTextfield',
				name:'t2',
				width:165,
				listeners: {
		            change: function(field, newValue, oldValue, eOpts) {
		            	panelSearch.setValue('t2', newValue);								
		            }
	    		}
	        }]
        },{
    		xtype: 'uniCheckboxgroup',		            		
    		fieldLabel: '품목형태',
    		items: [{
    			boxLabel: '상품',
    			width: 100,
    			name: 't3',
    			listeners: {
		            change: function(field, newValue, oldValue, eOpts) {
		            	panelSearch.setValue('t3', newValue);								
		            }
        		}
    		},{
    			boxLabel: '제품',
    			width: 100,
    			name: 't4',
    			listeners: {
		            change: function(field, newValue, oldValue, eOpts) {
		            	panelSearch.setValue('t4', newValue);								
		            }
        		}
    		}]
        },{
			xtype:'uniTextfield',
			fieldLabel: '품목명', 
			width:325,
			name:'t5',
			listeners: {
	            change: function(field, newValue, oldValue, eOpts) {
	            	panelSearch.setValue('t5', newValue);								
	            }
    		}
		},{
			xtype: 'uniDatefield',
        	fieldLabel: '기준일자',
        	name:'t6',
        	listeners: {
        		change: function(field, newValue, oldValue, eOpts) {
	            	panelSearch.setValue('t6', newValue);								
	            }
			}
        }]
	});	
	
	var informationForm = Unilite.createForm('detailForm', { //createForm
		padding:'1 1 1 1',
		flex:2,
		border: true,
		disabled: false,
		region: 'center',
		masterGrid: masterGrid,
	    items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			padding:'10 10 10 10',
			items :[{
				title:'품목정보',
	        	xtype: 'fieldset',
	        	padding: '0 10 10 10',
	        	margin: '0 0 0 0',
	 		    layout : {
	 		    	type: 'uniTable', 
	 		    	columns: 1,
	 		    	tableAttrs: {width: '100%'},
					tdAttrs: {align : 'left'}
	 		    },
	        	items: [{
	        		xtype:'uniTextfield',
	        		fieldLabel:'품목코드',
	        		name:'COL1'
	        	},{
					xtype: 'radiogroup',
					fieldLabel:'품목형태',
					items: [{
						boxLabel: '상품', 
						name: 'tempC2',
						width:100,
						checked: true  
					},{
						boxLabel : '제품', 
						name: 'tempC2',
						width:100
					}]
				},{
					xtype: 'container',
					layout: {type : 'uniTable', columns : 2},
					items :[{
						xtype:'uniTextfield',
						fieldLabel: '품목분류', 
						name:'tempC3',
						width:160
					},{
						xtype:'uniTextfield',
						name:'tempC4',
						width:165
			        }]
		        },{
					xtype:'uniTextfield',
					fieldLabel: '품목명', 
					name:'COL2',
					width:325
				},{
					xtype: 'radiogroup',
					fieldLabel:'품목과세',
					items: [{
						boxLabel: '과세', 
						name: 'tempC6',
						width:100,
						checked: true  
					},{
						boxLabel : '면세', 
						name: 'tempC6',
						width:100
					}]
				},{
					xtype: 'radiogroup',
					fieldLabel:'품목상태',
					items: [{
						boxLabel: '판매품목', 
						name: 'tempC7',
						width:100,
						checked: true  
					},{
						boxLabel : '판매불가', 
						name: 'tempC7',
						width:100
					}]
				},{
					xtype: 'uniDatefield',
		        	fieldLabel: '매출일자',
		        	name:'tempC8'
		        },{
		        	xtype: 'uniNumberfield',
		        	fieldLabel:'정가',
		        	name:'tempC9'
		        },
	        	UniTempPopup.popup('TEMPLATE', {
					fieldLabel: '매입처', 
					valueFieldName: 'tempC10',
		    		textFieldName: 'tempC11'
//		    		valueFieldWidth: 50,
//					textFieldWidth: 100
				}),		
	        	{
		        	xtype: 'uniNumberfield',
		        	fieldLabel:'매입단가',
		        	name:'tempC12'
		        },				
	        	UniTempPopup.popup('TEMPLATE', {
					fieldLabel: '손익단위', 
					valueFieldName: 'tempC13',
		    		textFieldName: 'tempC14'
//		    		valueFieldWidth: 50,
//					textFieldWidth: 100
				}),
				UniTempPopup.popup('TEMPLATE', {
					fieldLabel: '귀속부서', 
					valueFieldName: 'tempC15',
		    		textFieldName: 'tempC16'
//		    		valueFieldWidth: 50,
//					textFieldWidth: 100
				}),
	        	{
					xtype:'uniTextfield',
					fieldLabel: '비고', 
					name:'tempC17',
					width:325
				}]
	    	},{
				title:'History',
	        	xtype: 'fieldset',
	        	padding: '0 0 0 0',
	        	margin: '0 0 0 0',
	        	width: 805,
	 		    layout: {
	 		    	type: 'uniTable', 
	 		    	columns: 1, 
	 		    	tdAttrs: {valign:'top'}
	 		    },
	        	items: [
					subGrid
	        	]
			}]
	    }]
	});
	
    var masterGrid = Unilite.createGrid('tpl101ukrvGrid', {
        store: directMasterStore,
    	excelTitle: '품목코드',
    	region: 'west',
    	flex:1,
    	split:true,
    	tbar: [{
			itemId: 'tempId1',
			text: '목록조회',
			handler: function() {
			}
    	},{
			itemId: 'tempId2',
			text: '기준일조회',
			handler: function() {
			}
    	}],
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: true,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },//그룹 합계 관련
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],//그룹 합계 관련
        columns:  [
        	{dataIndex: 'SEQ'       	,		width: 70},
        	{dataIndex: 'COL1'       	,		width: 150},
        	{dataIndex: 'COL2'	    	,		width: 230},
        	{dataIndex: 'tempC2'	    ,		width: 120,hidden:true},
        	{dataIndex: 'tempC3'	    ,		width: 120,hidden:true},
        	{dataIndex: 'tempC4'	    ,		width: 120,hidden:true},
        	{dataIndex: 'tempC6'	    ,		width: 120,hidden:true},
        	{dataIndex: 'tempC7'	    ,		width: 120,hidden:true},
        	{dataIndex: 'tempC8'	    ,		width: 120,hidden:true},
        	{dataIndex: 'tempC9'	    ,		width: 120,hidden:true},
        	{dataIndex: 'tempC10'      	,		width: 120,hidden:true},
        	{dataIndex: 'tempC11'      	,		width: 120,hidden:true},
        	{dataIndex: 'tempC12'      	,		width: 120,hidden:true},
        	{dataIndex: 'tempC13'      	,		width: 120,hidden:true},
        	{dataIndex: 'tempC14'      	,		width: 120,hidden:true},
        	{dataIndex: 'tempC15'      	,		width: 120,hidden:true},
        	{dataIndex: 'tempC16'      	,		width: 120,hidden:true},
        	{dataIndex: 'tempC17'      	,		width: 120,hidden:true}	  
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['SEQ'])){
					return true;
				}else{
					return false;
				}
			},
			selectionchangerecord:function(selected)	{
          		informationForm.setActiveRecord(selected);
          	}
		}
    });  
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,masterGrid, informationForm
			]	
		},
			panelSearch
		],
		id: 'tpl101ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
			subStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
//			var compCode = UserInfo.compCode;
            var seq = directMasterStore.max('SEQ');
            	 if(!seq){
            	 	seq = 1;
            	 }else{
            	 	seq += 1;
            	 }
            var r = {
        	 	SEQ: seq
	        };
				masterGrid.createRow(r);
		},
		onResetButtonDown: function() {		
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			informationForm.clearForm();
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
		}
	});
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':informationForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName){
			
			}
			return rv;
		}
	}); 
};


</script>
