<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx355ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A092"  /> 			<!-- 제출사유 -->
	<t:ExtComboStore comboType="AU" comboCode="A024"  /> 			<!-- 공제율 -->
	<t:ExtComboStore comboType="AU" comboCode="A197"  /> 			<!-- 한도율 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> 			<!-- 부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A149" />			<!-- 전자발행여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M302" />			<!-- 매입유형 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var gsFSetQ =UniFormat.Qty;

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx355Model', {
	   fields: [
			{name: 'FR_PUB_DATE'		, text: 'FR_PUB_DATE'				, type: 'uniDate'},
			{name: 'TO_PUB_DATE' 		, text: 'TO_PUB_DATE'				, type: 'uniDate'},
			{name: 'BILL_DIV_CODE' 		, text: 'BILL_DIV_CODE'				, type: 'string'},
			{name: 'SEQ'	    		, text: '일련번호'						, type: 'string'},
			{name: 'CUSTOM_CODE'	    , text: '(27)면세농산물등을 공급한 농.어민'	, type: 'string'},
			{name: 'CUSTOM_NAME' 		, text: '성명'						, type: 'string'},
			{name: 'TOP_NUM'			, text: '주민등록번호'					, type: 'string'},
			{name: 'ITEM_NUM'			, text: '(28)건수'					, type: 'uniQty'},
			{name: 'ITEM_NAME'			, text: '(29)품명'					, type: 'string'},
			{name: 'QTY'				, text: '(30)수량'					, type: 'uniQty'},
			{name: 'SUPPLY_AMT_I'		, text: '(31)매입가액'					, type: 'uniPrice'},
			{name: 'SORT_ORDER'			, text: 'SORT'						, type: 'string'},
			{name: 'UPDATE_DB_USER' 	, text: 'UPDATE_DB_USER'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'			, type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'					, type: 'string'}
	    ]
	});		// End of Ext.define('Atx355ukrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx355MasterStore1',{
		model: 'Atx355Model',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx355Service.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '검색조건',
    	defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        },
	        dirtychange: function(basicForm, dirty, eOpts) {
				console.log("onDirtyChange");
				UniAppManager.setToolbarButtons('save', true);
			}
	    },
		items: [{	
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{ 
    			fieldLabel: '계산서일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_PUB_DATE',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_PUB_DATE',newValue);
			    	}   	
			    } 
	        },{ 
				fieldLabel: '신고사업장',
				name: 'DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
			    value: UserInfo.divCode,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelResult.setValue('DIV_CODE', newValue);
			     	}
			    }
			     	
			},{
				fieldLabel: '작성일자',
	 		    width: 200,
	            xtype: 'uniDatefield',
	            name: 'WRITE_DATE', 
	            value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('', newValue);
					}
				}
					
	     	}]
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
					alert(labelText+Msg.sMB083);
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
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
    			fieldLabel: '계산서일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'FR_PUB_DATE',
		        endFieldName: 'TO_PUB_DATE',
		        width: 470,
		        startDate: UniDate.get('startOfMonth'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelSearch.setValue('FR_PUB_DATE',newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('TO_PUB_DATE',newValue);
			    	}   	
			    } 
	        },{ 
				fieldLabel: '신고사업장',
				name: 'DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
			    value: UserInfo.divCode,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			      		panelSearch.setValue('DIV_CODE', newValue);
			     	}
			    }
			     	
			},{
				fieldLabel: '작성일자',
	 		    width: 200,
	            xtype: 'uniDatefield',
	            name: '', 
	            value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('', newValue);
					}
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
					alert(labelText+Msg.sMB083);
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
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	//unilite.createForm으로 생성 할것 , title로 만들어 운영할것(cls:'moduleNameBox'이런식으로 css줄수있음), 테이블 구조로 만들것
	//flex기능은 tdAttrs{whidth:100%}이런식으로 줄것, 
	var tableView = Unilite.createForm('detailForm', { //createForm
	    title:'2. 면세농산물등 매입가액 및 의제매입세액 합계',
		//border: 0,
		disabled: false,
		flex: 1.6,
		xtype: 'container',
		bodyPadding: 10,
		margin:-5,
		
		region: 'north',
	    layout: {type: 'uniTable', columns: 6, 
	    
	    		tableAttrs: {style: 'border : 0.5mm solid #ced9e7;'},
	    		tdAttrs: {style: 'border : 0.5mm solid #ced9e7;',align : 'center'}
	    		
	    		},
	    		
	    tbar: [
		{
	    	xtype: 'toolbar',
	    	id:'temp5',
	    	margin: '0 0 0 0',
	    	width:200,
			border:false,
	    	layout: {
	    		type: 'hbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[
			{
	    		xtype: 'button',
	    		text: '출력',
	    		width: 100,
	    		margin: '0 0 0 0',
	    		handler : function() {
	    			UniAppManager.app.onPrintButtonDown();
	    		}
	    	}]
		}],		
	    items: [
				{ xtype: 'component',  html:'구&nbsp;&nbsp;분'},
		    	{ xtype: 'component',  html:'⑤매입처수'},
		    	{ xtype: 'component',  html:'⑥건&nbsp;&nbsp;수'},
		    	{ xtype: 'component',  html:'⑦매입가액'},
		    	{ xtype: 'component',  html:'⑧공제율'},
		    	{ xtype: 'component',  html:'⑨의제매입세액'},
		
				{ xtype: 'component',  html:'⑤합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계'},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniCombobox',	   comboType: 'AU', comboCode: 'A024'},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		
				{ xtype: 'component',  html:'⑪계   &nbsp; 산  &nbsp;  서'},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniCombobox',	   comboType: 'AU', comboCode: 'A024'},
		        { xtype: 'uniNumberfield', value:'0', readOnly:true},
		        
				{ xtype: 'component',  html:'⑫신용카드  등'},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniCombobox',	   comboType: 'AU', comboCode: 'A024'},
		        { xtype: 'uniNumberfield', value:'0', readOnly:true},
		
				{ xtype: 'component',  html:'⑬농.어민 등으로부터 매입분'},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniNumberfield', value:'0', readOnly:true},
		    	{ xtype: 'uniCombobox',	   comboType: 'AU', comboCode: 'A024'},
		        { xtype: 'uniNumberfield', value:'0', readOnly:true}]
	});
	
    var masterGrid = Unilite.createGrid('atx355Grid1', {
        region : 'south',
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'FR_PUB_DATE'		, width: 66, hidden: true}, 				
			{dataIndex: 'TO_PUB_DATE' 		, width: 66, hidden: true}, 				
			{dataIndex: 'BILL_DIV_CODE' 	, width: 66, hidden: true}, 				
			{dataIndex: 'SEQ'	    		, width: 86}, 				
			{dataIndex: 'CUSTOM_CODE'		, width: 166, hidden: true},
			{text: '(27)면세농산물등을 공급한 농.어민',
				columns: [
					{dataIndex: 'CUSTOM_NAME' 		, width: 166}, 				
					{dataIndex: 'TOP_NUM'			, width: 133}
				]
			}, 				
			{dataIndex: 'ITEM_NUM'			, width: 100}, 				
			{dataIndex: 'ITEM_NAME'			, width: 173}, 				
			{dataIndex: 'QTY'				, width: 100}, 				
			{dataIndex: 'SUPPLY_AMT_I'		, width: 133}, 				
			{dataIndex: 'SORT_ORDER'		, width: 66}, 				
			{dataIndex: 'UPDATE_DB_USER' 	, width: 0, hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'	, width: 0, hidden: true}, 				
			{dataIndex: 'COMP_CODE'			, width: 0, hidden: true}	
		] 
    });    
    
	 Unilite.Main( {
		borderItems:[{ 
			region: 'center',
			layout: 'border',
			items: [
				panelResult,
				tableView,
				{
					border: false,
					flex: 2.5,
					layout: {type: 'vbox', align: 'stretch'},
					region: 'center',
					items: [
						{title: '4. 농.어민 등으로부터의 매입분에 대한 명세(합계금액으로 작성함)',
						region: 'center',
						border: false},
						masterGrid//, panelResult
					]
				}
			]
		},
		panelSearch
		], 
		id : 'atx355App',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			//var activeTabId = tab.getActiveTab().getId();			
			//if(activeTabId == 'atx355Grid1'){				
			//	directMasterStore1.loadStoreRecords();				
			//}
			//var viewLocked = tab.getActiveTab().lockedGrid.getView();
			//var viewNormal = tab.getActiveTab().normalGrid.getView();
			//console.log("viewLocked : ",viewLocked);
			//console.log("viewNormal : ",viewNormal);
			//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			//viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			//viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			
			directMasterStore.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function(type) {
			var param = panelSearch.getValues();
			param["FSetQ"] = gsFSetQ;
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/atx/atx355ukrPrint.do',
				prgID: 'atx355ukr',
					extParam: param
				});
			win.center();
			win.show();   				
		}
	});
};


</script>
