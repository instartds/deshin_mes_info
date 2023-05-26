<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="spp200skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="spp200skrv"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 고객분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S018" /> <!-- 확정 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />

</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	   
	Unilite.defineModel('Spp200skrvModel1', {
	    fields: [{name: 'ESTI_DATE'	    ,text: '견적일자'	, type: 'uniDate'},				  
				 {name: 'CUSTOM_CODE'  	,text: '<t:message code="system.label.sales.client" default="고객"/>'	, type: 'string'},				  
				 {name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'	, type: 'string'},				  
				 {name: 'ESTI_NUM'  	,text: '견적번호'	, type: 'string'},				  
				 {name: 'ESTI_SEQ'	    ,text: '<t:message code="system.label.sales.seq" default="순번"/>'		, type: 'int'},				  
				 {name: 'ESTI_CFM_PRICE',text: '확정단가'	, type: 'uniUnitPrice'},				  
				 {name: 'ESTI_QTY'	    ,text: '견적수량'	, type: 'uniQty'},				  
				 {name: 'ESTI_CFM_AMT'  ,text: '확정금액'	, type: 'uniPrice'},				  
				 {name: 'ORDER_Q'  		,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'	, type: 'uniQty'},				  
				 {name: 'JAN_QTY'		,text: '잔량'		, type: 'uniQty'},				  
				 {name: 'ITEM_CODE'  	,text: '<t:message code="system.label.sales.item" default="품목"/>'	, type: 'string'},				  
				 {name: 'ITEM_NAME'	    ,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'	, type: 'string'},				  
				 {name: 'ESTI_UNIT'  	,text: '<t:message code="system.label.sales.unit" default="단위"/>'		, type: 'string'},				  
				 {name: 'TRANS_RATE'	,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'		, type: 'uniQty'},				  
				 {name: 'ESTI_PRSN'  	,text: '<t:message code="system.label.sales.charger" default="담당자"/>'	, type: 'string'},				  
				 {name: 'SORT'	  		,text: 'SORT'	, type: 'string'}			  
				 
			]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('spp200skrvMasterStore1',{
			model: 'Spp200skrvModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'spp200skrvService.selectList'
                }
            }
			,loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
				
			},
			groupField: 'ESTI_DATE'
			
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{	
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
	            	fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
	            	name: 'ESTI_PRSN', 
	            	xtype: 'uniCombobox',
	            	comboType: 'AU',
	            	comboCode: 'S010',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ESTI_PRSN', newValue);
						}
					}
	            }, {
					fieldLabel: '견적일',
	 		        width: 315,
	                xtype: 'uniDateRangefield',
	                startFieldName: 'ESTI_DATE_FR',
	                endFieldName: 'ESTI_DATE_TO',
	                startDate: UniDate.get('startOfMonth'),
	                endDate: UniDate.get('today'),                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('ESTI_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('ESTI_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
	            },
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})]
			}]
		}, {
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{ 
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120'
			} , {
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'TXTLV_L2'
			}, {
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'TXTLV_L3'
			}, {
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
				colspan: 2
			}, {
				fieldLabel: '견적수량',
				xtype: 'uniNumberfield',
				name:'ESTI_QTY_FR',
				suffixTpl: '&nbsp;이상'
			}, {
				fieldLabel: ' ',
				xtype: 'uniNumberfield',
				name:'ESTI_QTY_TO',
				suffixTpl: '&nbsp;이하'
			}, {
            	fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'	,
            	name: 'AGENT_TYPE', 
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'B055'
            }, {
            	fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>'	,
            	name: 'AREA_TYPE', 
            	xtype: 'uniCombobox',
            	comboType: 'AU',
            	comboCode: 'B056'
            }, {
				xtype: 'uniTextfield',
				fieldLabel: '견적요청자',
				width: 315,
				name:'CUST_PRSN'
			}, {
				xtype: 'uniTextfield',
				fieldLabel: '견적건명',
				width: 315,
				name:'ESTI_TITLE'
			}, 
    			Unilite.popup('ITEM_GROUP',{
    			fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
    			
			    valueFieldName:'ITEM_GROUP_CODE',
			    textFieldName:'ITEM_GROUP_NAME'
    		})]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
        	fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
        	name: 'ESTI_PRSN', 
        	xtype: 'uniCombobox',
        	comboType: 'AU',
        	comboCode: 'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ESTI_PRSN', newValue);
				}
			}
        }, {
			fieldLabel: '견적일',
	        width: 315,
            xtype: 'uniDateRangefield',
            startFieldName: 'ESTI_DATE_FR',
            endFieldName: 'ESTI_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('ESTI_DATE_FR',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ESTI_DATE_TO',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
        },
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
       	 	Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		})]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('spp200skrvGrid1', {
    	// for tab3
    	region: 'center',
        layout: 'fit',
    	store: directMasterStore1,
        uniOpt: {			
			useRowNumberer: false
        },
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [{ dataIndex: 'ESTI_DATE'	    , width: 80, locked: true,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '일자계', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
    			  { dataIndex: 'CUSTOM_CODE'  	, width: 80, locked: true},
    			  { dataIndex: 'CUSTOM_NAME'	, width: 133, locked: true},
    			  { dataIndex: 'ESTI_NUM'  		, width: 120, locked: true},
    			  { dataIndex: 'ESTI_SEQ'	    , width: 36, locked: true},
    			  { dataIndex: 'ESTI_CFM_PRICE' , width: 116},
    			  { dataIndex: 'ESTI_QTY'	    , width: 116, summaryType: 'sum'},
    			  { dataIndex: 'ESTI_CFM_AMT'   , width: 126, summaryType: 'sum'},
    			  { dataIndex: 'ORDER_Q'  		, width: 116, summaryType: 'sum'},
    			  { dataIndex: 'JAN_QTY'		, width: 116, summaryType: 'sum'},
    			  { dataIndex: 'ITEM_CODE'  	, width: 150},
    			  { dataIndex: 'ITEM_NAME'	    , width: 133},
    			  { dataIndex: 'ESTI_UNIT'  	, width: 66},
    			  { dataIndex: 'TRANS_RATE'	    , width: 100},
    			  { dataIndex: 'ESTI_PRSN'  	, width: 100},
    			  { dataIndex: 'SORT'	  		, width: 100, hidden: true}
    	]
    });

    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 'spp200skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{		
			
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);				
		},		
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
