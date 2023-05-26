<%--
'   프로그램명 : 전략자재발주현황 (구매재고)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo170skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="mpo170skrv"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M170" /> 					<!-- 자재품목그룹 --> 
</t:appConfig>
<script type="text/javascript">
	function appMain(){
		var model = Unilite.defineModel('Mpo170skrvModel', {
			 fields: [
                {name:'ROWNUM',               text:'<t:message code="system.label.purchase.spec" default="규격"/>',      type:'int'},
			 	{name:'ITEM_GROUP', 		text:'품목그룹',	type:'string', comboType:"AU", comboCode:"M170"},
			 	{name:'ITEM_CODE', 			text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>',	type:'string'},
			 	{name:'ITEM_NAME', 			text:'<t:message code="system.label.purchase.itemname2" default="품명"/>',		type:'string'},
			 	{name:'SPEC', 				text:'<t:message code="system.label.purchase.spec" default="규격"/>',		type:'string'},
			 	{name:'PURCHASE_BASE_P',	text:'<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>',	type:'uniUnitPrice'},
			 	{name:'PURCH_LDTIME',		text:'L/T',			type:'string'},
			 	{name:'GUBUN', 				text:'<t:message code="system.label.purchase.classfication" default="구분"/>',		type:'string'},
			 	{name:'INOUTM7',			text:'당월-7',		type:'uniQty'},
			 	{name:'INOUTM8', 			text:'당월-8',		type:'uniQty'},
			 	{name:'INOUTM9', 			text:'당월-9',		type:'uniQty'},
			 	{name:'INOUTM10', 			text:'당월-10',		type:'uniQty'},
			 	{name:'INOUTM11', 			text:'당월-11',		type:'uniQty'},
			 	{name:'INOUTM12', 			text:'당월-12',		type:'uniQty'},
			 	{name:'INOUTP1', 			text:'당월-1',		type:'uniQty'},
			 	{name:'INOUTP2', 			text:'당월-2',		type:'uniQty'},
			 	{name:'INOUTP3', 			text:'당월-3',		type:'uniQty'},
			 	{name:'INOUTP4', 			text:'당월-4',		type:'uniQty'},
			 	{name:'INOUTP5', 			text:'당월-5',		type:'uniQty'},
			 	{name:'INOUTP6', 			text:'익월-6',		type:'uniQty'},
			 	{name:'STOCK_Q', 			text:'<t:message code="system.label.purchase.onhandstock" default="현재고"/>',		type:'uniQty'},
			 	{name:'SAFE_STOCK_Q', 		text:'<t:message code="system.label.purchase.safetystock" default="안전재고"/>',	type:'uniQty'}
			 ]
		});
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read: 'mpo170skrvService.selectList'
			}
		});
		var directMasterStore = Unilite.createStore('mpo170skrvMasterStore',{
			model: 'Mpo170skrvModel',
			uniOpt: {
	        	isMaster: true,			// 상위 버튼 연결 
	        	editable: false,			// 수정 모드 사용 
	        	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
	        },
	        autoLoad: false,
	        proxy: directProxy,
	        loadStoreRecords:function(){
				var param= Ext.getCmp('searchForm').getValues(); 
	        	console.log(param);
	        	this.load({
	        		params : param
	        	});
	        }
		});
		var panelSearch = Unilite.createSearchForm('searchForm', {
			region:'north',
			layout : {type : 'uniTable', columns : 4},
            padding:'1 1 1 1',
            border:true,
			items:[
				{
					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
					name: 'DIV_CODE', 
					xtype: 'uniCombobox', 
					comboType: 'BOR120',
					value: UserInfo.divCode,
					allowBlank: false
				},{
					fieldLabel: '기준월',
					xtype: 'uniMonthfield',
					name: 'CHANGE_BASISDATE',
			 		value: UniDate.get('startOfMonth'),
			 		allowBlank:false,
			 		listeners:{
			 			change: function(combo, newValue, oldValue, eOpts) {	
								panelSearch.setValue('CHANGE_BASISDATE', newValue);
								UniAppManager.app.setDefault(newValue);
							}
			 		}
				},Unilite.popup('DIV_PUMOK', { 
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>', 
					valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
								}
							},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				}),{
					fieldLabel: '품목그룹',
					xtype:'uniCombobox',
					comboType:'AU',
    				comboCode:'M170',
					name:'ITEM_FLAG'
				}
			]
		}); 
		var masterGrid = Unilite.createGrid('mpo170skrvGrid', {
			layout: 'fit',
			region:'center',
            enableColumnHide :false,
            sortableColumns : false,
	    	uniOpt: {
	    		useGroupSummary: false,
	    		useLiveSearch: true,
				useContextMenu: false,
				useMultipleSorting: false,
				useRowNumberer: false,
				expandLastColumn: false,
				onLoadSelectFirst : false,
	    		filter: {
					useFilter: false,
					autoCreate: false
				},
                state: {
                    useState: false,         //그리드 설정 버튼 사용 여부
                    useStateList: false      //그리드 설정 목록 사용 여부
                }
	        },
           /* plugins: [
                {
                    ptype: 'bufferedrenderer',
                    trailingBufferZone: 100000000,
                    leadingBufferZone: 100000000
                }
            ],*/
            viewConfig: {
                getRowClass: function(record, rowIndex, rowParams, store){
                    var cls = '';
                    if(record.data.ROWNUM % 2 == 0){
                        cls = 'x-change-cell_row3';
                    }
                    return cls;
                }
            },
	    	store: directMasterStore,
	    	columns:[
	    		{dataIndex: 'ITEM_GROUP',  		width: 70 , align:'center'},
	    		{dataIndex: 'ITEM_CODE',  		width: 120},
	    		{dataIndex: 'ITEM_NAME', 	 	width: 150},
	    		{dataIndex: 'SPEC',  			width: 120},
	    		{dataIndex: 'PURCHASE_BASE_P',	width: 80},
	    		{dataIndex: 'PURCH_LDTIME',		width: 60 , align:'center'},
	    		{dataIndex: 'GUBUN',  			width: 60 , align:'center'},
	    		{dataIndex: 'INOUTM7',  		width: 80,id:'prevMonth6',itemId:'prevMonth6'},
	    		{dataIndex: 'INOUTM8',  		width: 80,id:'prevMonth5',itemId:'prevMonth5'},
	    		{dataIndex: 'INOUTM9',  		width: 80,id:'prevMonth4',itemId:'prevMonth4'},
	    		{dataIndex: 'INOUTM10',  		width: 80,id:'prevMonth3',itemId:'prevMonth3'},
	    		{dataIndex: 'INOUTM11',  		width: 80,id:'prevMonth2',itemId:'prevMonth2'},
	    		{dataIndex: 'INOUTM12',  		width: 80,id:'prevMonth1',itemId:'prevMonth1'},
	    		{dataIndex: 'INOUTP1',  		width: 80,id:'currMonth',itemId:'currMonth'},
	    		{dataIndex: 'INOUTP2',  		width: 80,id:'nextMonth1',itemId:'nextMonth1'},
	    		{dataIndex: 'INOUTP3',  		width: 80,id:'nextMonth2',itemId:'nextMonth2'},
	    		{dataIndex: 'INOUTP4',  		width: 80,id:'nextMonth3',itemId:'nextMonth3'},
	    		{dataIndex: 'INOUTP5',  		width: 80,id:'nextMonth4',itemId:'nextMonth4'},
	    		{dataIndex: 'INOUTP6',  		width: 80,id:'nextMonth5',itemId:'nextMonth5'},
	    		{dataIndex: 'STOCK_Q',  		width: 80},
	    		{dataIndex: 'SAFE_STOCK_Q',  	width: 80}
	    	]
        
		});
		Unilite.Main( {
			borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					masterGrid, panelSearch
				]
			}	
		],
			id: 'mpo170skrvApp',
			fnInitBinding: function() {
				UniAppManager.setToolbarButtons('reset',false);
				UniAppManager.app.setDefault();
			},
			onQueryButtonDown: function() {
				if(!panelSearch.getInvalidMessage()){
					return false;		
				};
				directMasterStore.loadStoreRecords();			
			},
			onResetButtonDown: function() {
				panelSearch.clearForm();
				masterGrid.reset();
				this.fnInitBinding();
			},
			setDefault : function(date){
				var baseDate=Ext.util.Format.date(date,'Y-m-d');
				var date=Ext.util.Format.date(date,'Y-m-d');
				var year=parseInt(Ext.util.Format.date(date,'Y'));
				var date11=panelSearch.getValue('CHANGE_BASISDATE');
				var month=Ext.util.Format.date(date11,'Y.m');
				var gridTest = Ext.getCmp('currMonth');
					gridTest.setText(month)//当前月


				for(i=1;i<=6;i++){
					var cc=UniDate.get('aMonthAgo',date);
					var nextMonth=cc.substring(0,4)+'.'+cc.substring(4,6);
					var name='prevMonth'+i;
					var gridTest = Ext.getCmp(name);
					gridTest.setText(nextMonth)//当前月
					date=cc;
				}
				for(i=1;i<=5;i++){
					var cc=UniDate.get('startOfNextMonth',baseDate);
					var nextMonth=cc.substring(0,4)+'.'+cc.substring(4,6);
					var name='nextMonth'+i;
					var gridTest = Ext.getCmp(name);
					gridTest.setText(nextMonth)//当前月
					baseDate=cc;
				}
				masterGrid.reconfigure(directMasterStore,model);
			}
		});
	}
</script>