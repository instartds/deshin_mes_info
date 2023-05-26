<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="qms701ukrv" >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--입고창고-->
	<t:ExtComboStore comboType="AU" comboCode="M001" /><!-- 발주유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /><!-- 검사유형 -->
	<t:ExtComboStore comboType="AU" comboCode="M414" /><!-- 합격여부 -->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {

	Unilite.defineModel('qms701ukrvModel1', {
	
		fields: [{name: 'COMP_CODE'          		, text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>',			type: 'string'	},
				 {name: 'DIV_CODE'           		, text: '<t:message code="system.label.inventory.division" default="사업장"/>',		type: 'string'	},
				 {name: 'INSPEC_NUM'         		, text: '검사번호',			type: 'string'	},
				 {name: 'INSPEC_SEQ'         		, text: '순번',				type: 'string'	},
				 {name: 'ITEM_CODE'          		, text: '<t:message code="system.label.inventory.item" default="품목"/>',			type: 'string'	},
				 {name: 'ITEM_NAME'          		, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',			type: 'string'	},
				 {name: 'SPEC'               		, text: '<t:message code="system.label.inventory.spec" default="규격"/>',				type: 'string'	},
				 {name: 'STOCK_UNIT'         		, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',			type: 'string'	},
				 {name: 'INSPEC_TYPE'        		, text: '검사유형',			type: 'string'	},
				 {name: 'INSPEC_METHOD'	     		, text: '검사방식',			type: 'string'	},
				 {name: 'GOODBAD_TYPE'       		, text: '합격여부',			type: 'string'	},
				 {name: 'END_DECISION'       		, text: '최종여부',			type: 'string'	},
				 {name: 'INSPEC_Q'           		, text: '검사량',			type: 'string'	},
				 {name: 'GOOD_INSPEC_Q'      		, text: '합격수량',			type: 'string'	},
				 {name: 'BAD_INSPEC_Q'       		, text: '불량수량',			type: 'string'	},
				 {name: 'INSTOCK_Q'          		, text: '입고량',			type: 'string'	},
				 {name: 'INSTOCK_I'          		, text: '입고금액',			type: 'string'	},
				 {name: 'IN_WH_CODE'         		, text: '출고창고',			type: 'string'	},
				 {name: 'GOOD_WH_CODE'       		, text: '입고창고',			type: 'string'	},
				 {name: 'BAD_WH_CODE'        		, text: '불량입고창고',		type: 'string'	},
				 {name: 'INSPEC_PRSN'        		, text: '검사담당자',		type: 'string'	},
				 {name: 'INOUT_NUM'          		, text: '입고번호',			type: 'string'	},
				 {name: 'INOUT_SEQ'          		, text: '입고순번',			type: 'string'	},
				 {name: 'REMARK'             		, text: '<t:message code="system.label.inventory.remarks" default="비고"/>',				type: 'string'	},
				 {name: 'PROJECT_NO'         		, text: '프로젝트번호',		type: 'string'	},
				 {name: 'INSPEC_DATE'        		, text: '검사일',			type: 'string'	},
				 {name: 'LOT_NO'             		, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',			type: 'string'	},
				 {name: 'UPDATE_DB_USER'     		, text: 'UPDATE_DB_USER',	type: 'string'	},
				 {name: 'UPDATE_DB_TIME'     		, text: 'UPDATE_DB_TIME',	type: 'string'	},
				 {name: 'OUT_NUM'            		, text: '출고번호',			type: 'string'	},
				 {name: 'OUT_SEQ'            		, text: '출고순번',			type: 'string'	},
				 {name: 'TABOPT'             		, text: 'TABOPT',			type: 'string'	},
				 {name: 'INOUT_DATE'         		, text: '출고일',			type: 'string'	}
				 
		]
	});

	
	var directMasterStore1 = Unilite.createStore('qms701ukrvGroupStore', { 
		model: 'qms701ukrvModel1',
		autoLoad: false,
		uniOpt: {
	    	isMaster: false,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
	    },
		proxy: {
			type: 'direct',
			api: {
				read: 	 'qms701ukrvService.selectList'
				
			}
		}
		,loadStoreRecords: function()	{
			var param= Ext.getCmp('qms701ukrvSearchForm').getValues();	
			if(panelSearch.getValue('USER_ID') != '')	{					
				this.load({
					params: param
				});
			}else {
				alert(Msg.sMB083);			
			}
		}
		
	});
	
	
	Unilite.defineModel('qms701ukrvModel2', {
	
		fields: [{name: 'DIV_CODE'				    , text: '<t:message code="system.label.inventory.division" default="사업장"/>',				type: 'string'	},		   	   
				 {name: 'INSPEC_NUM'				, text: '검사번호',			type: 'string'	},		   	   
				 {name: 'INSPEC_SEQ'				, text: '검사순번',			type: 'string'	},		   	   
				 {name: 'BAD_INSPEC_CODE'		    , text: '검사코드',			type: 'string'	},		   	   
				 {name: 'BAD_INSPEC_NAME'		    , text: '검사항목',			type: 'string'	},		   	   
				 {name: 'SPEC'           		    , text: '<t:message code="system.label.inventory.spec" default="규격"/>',				type: 'string'	},		   	   
				 {name: 'MEASURED_VALUE' 		    , text: '측정치',				type: 'string'	},		   	   
				 {name: 'BAD_INSPEC_Q'				, text: '불량수량',			type: 'string'	},		   	   
				 {name: 'INSPEC_REMARK'				, text: '불량내용',			type: 'string'	},		   	   
				 {name: 'MANAGE_REMARK'				, text: '조치내용',			type: 'string'	},		   	   
				 {name: 'COMP_CODE'      		    , text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>',			type: 'string'	},		   	   
				 {name: 'GUBUN'          		    , text: 'GUBUN',			type: 'string'	}   	   
				 
		]
	});	
	var directMasterStore2 = Unilite.createStore('qms701ukrvMasterStore', { 
		model: 'qms701ukrvModel2',
		autoLoad: false,
		uniOpt: {
	    	isMaster: false,			// 상위 버튼 연결 
	    	editable: false,			// 수정 모드 사용 
	    	deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
	    },
		proxy: {
			type: 'direct',
			api: {
				read: 	 'qms701ukrvService.selectList'
				
			}
		}
		,loadStoreRecords: function()	{
			var param= Ext.getCmp('qms701ukrvSearchForm').getValues();	
			if(panelSearch.getValue('USER_ID') != '')	{					
				this.load({
					params: param
				});
			}else {
				alert(Msg.sMB083);
			
			}
		}
		
	});	
		
	var panelSearch = Unilite.createSearchPanel('qms701ukrvSearchForm', {          
		title: '검색조건',         
		defaultType: 'uniSearchSubPanel',
		items: [{     
			title: '기본정보',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [{ 
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false
			}, {
            	fieldLabel: '입고창고',
            	name: 'TXT_WH_CODE',
            	xtype: 'uniCombobox',
            	store: Ext.data.StoreManager.lookup('whList'),
				allowBlank: false
            }, {
				fieldLabel: '검사입고일',
				name: '',
				xtype: 'uniDatefield',
				value: new Date(),
				allowBlank: false
			}, {
				fieldLabel: '검사담당',
				name:'',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:''
			}, {
				xtype: 'uniNumberfield',
				fieldLabel: '검사번호',
				name:''
			}, {
				fieldLabel: '합격여부',
				name:'',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'M414'
			}]
		}]
	});
		
   		
		
	// create the Grid			
	var masterGrid1 = Unilite.createGrid('qms701ukrv1Grid1', {
		region: 'north',
		store: directMasterStore1,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'COMP_CODE'          		,		width: 66, hidden: true	},
				  {dataIndex: 'DIV_CODE'           		,		width: 66, hidden: true	},
				  {dataIndex: 'INSPEC_NUM'         		,		width: 100, hidden: true	},
				  {dataIndex: 'INSPEC_SEQ'         		,		width: 100	},
				  {dataIndex: 'ITEM_CODE'          		,		width: 93	},
				  {dataIndex: 'ITEM_NAME'          		,		width: 120	},
				  {dataIndex: 'SPEC'               		,		width: 120	},
				  {dataIndex: 'STOCK_UNIT'         		,		width: 66, hidden: true	},
				  {dataIndex: 'INSPEC_TYPE'        		,		width: 86, hidden: true	},
				  {dataIndex: 'INSPEC_METHOD'	     	,		width: 93	},
				  {dataIndex: 'GOODBAD_TYPE'       		,		width: 86, hidden: true	},
				  {dataIndex: 'END_DECISION'       		,		width: 86	},
				  {dataIndex: 'INSPEC_Q'           		,		width: 86	},
				  {dataIndex: 'GOOD_INSPEC_Q'      		,		width: 86	},
				  {dataIndex: 'BAD_INSPEC_Q'       		,		width: 86	},
				  {dataIndex: 'INSTOCK_Q'          		,		width: 86, hidden: true	},
				  {dataIndex: 'INSTOCK_I'          		,		width: 100, hidden: true	},
				  {dataIndex: 'IN_WH_CODE'         		,		width: 100, hidden: true	},
				  {dataIndex: 'GOOD_WH_CODE'       		,		width: 100, hidden: true	},
				  {dataIndex: 'BAD_WH_CODE'        		,		width: 100, hidden: true	},
				  {dataIndex: 'INSPEC_PRSN'        		,		width: 100	},
				  {dataIndex: 'INOUT_NUM'          		,		width: 100	},
				  {dataIndex: 'INOUT_SEQ'          		,		width: 66	},
				  {dataIndex: 'REMARK'             		,		width: 100	},
				  {dataIndex: 'PROJECT_NO'         		,		width: 100	},
				  {dataIndex: 'INSPEC_DATE'        		,		width: 100, hidden: true	},
				  {dataIndex: 'LOT_NO'             		,		width: 100, hidden: true	},
				  {dataIndex: 'UPDATE_DB_USER'     		,		width: 100, hidden: true	},
				  {dataIndex: 'UPDATE_DB_TIME'     		,		width: 100, hidden: true	},
				  {dataIndex: 'OUT_NUM'            		,		width: 100	},
				  {dataIndex: 'OUT_SEQ'            		,		width: 66	},
				  {dataIndex: 'TABOPT'             		,		width: 33, hidden: true	},
				  {dataIndex: 'INOUT_DATE'             	,		width: 66, hidden: true	}
				]		
		
	});
	
	
	var masterGrid2 = Unilite.createGrid('qms701ukrvGrid2', {
		region: 'center',
		store: directMasterStore2,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
		uniOpt: {
	    	onLoadSelectFirst: false,
        	expandLastColumn: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true
	    },
		columns: [{dataIndex: 'DIV_CODE'				,		width: 66, hidden: true},	  
				  {dataIndex: 'INSPEC_NUM'				,		width: 66},	  
				  {dataIndex: 'INSPEC_SEQ'				,		width: 40},	  
				  {dataIndex: 'BAD_INSPEC_CODE'		    ,		width: 66},	  
				  {dataIndex: 'BAD_INSPEC_NAME'		    ,		width: 100},	  
				  {dataIndex: 'SPEC'           		    ,		width: 166},	  
				  {dataIndex: 'MEASURED_VALUE' 		    ,		width: 166},	  
				  {dataIndex: 'BAD_INSPEC_Q'			,		width: 100},	  
				  {dataIndex: 'INSPEC_REMARK'			,		width: 266},	  
				  {dataIndex: 'MANAGE_REMARK'			,		width: 266},	  
				  {dataIndex: 'COMP_CODE'      		    ,		width: 66, hidden: true},	  
				  {dataIndex: 'GUBUN'          		    ,		width: 66, hidden: true}  
				  	  
		]		
		
	});
		

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[masterGrid1, masterGrid2 ]	
		}		
		,panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset'],true);
		}
		, onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
		}

		, onSaveDataButtonDown: function () {										
				 if(programStore.isDirty())	{
					programStore.saveStore();						
				 }				
			}
		,
			onResetButtonDown: function() {
				detailUserGrid.reset();
				masterGrid.reset();
				Ext.getCmp('qms701ukrvSearchForm').reset();
			}
	});

		

};	// appMain
</script>