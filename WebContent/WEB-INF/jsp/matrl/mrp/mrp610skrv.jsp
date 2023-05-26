<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp610skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="mrp610skrv" /> 			<!-- 사업장 --> 	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /><!--대분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /><!--중분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /><!--소분류-->	
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->	
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;} 
.x-change-cell {
background-color: #FFC6C6;
}
</style>

<script type="text/javascript" >

function appMain() {
	/** 
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mrp610skrvModel1', {
	    fields: [
	    		{name: 'COMP_CODE'			    ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		,type: 'string'},
			    {name: 'DIV_CODE'			    ,text: '<t:message code="system.label.purchase.division" default="사업장"/>'		,type: 'string'},
	    		{name: 'ITEM_CODE'			    ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type: 'string'},
			    {name: 'ITEM_NAME'			    ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		,type: 'string'},
			    {name: 'DEPT_CODE'			    ,text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'		,type: 'string'},
			    {name: 'DEPT_NAME'			    ,text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'		,type: 'string'},
			    {name: 'AVG_Q'			    	,text: '평균소요량'		,type: 'uniQty'},
			    {name: 'SD_Q'			    	,text: '표준편차'		,type: 'uniQty'},
			    {name: 'PURCH_LDTIME'			,text: '리드타임'		,type: 'int'},
			    {name: 'SAFETY_Q'			    ,text: '<t:message code="system.label.purchase.safetystockqty" default="안전재고량"/>'		,type: 'uniQty'},
			    {name: 'REORDER_POINT'			,text: '재발주점'		,type: 'uniQty'},
			    {name: 'EOQ'			        ,text: '경제주문량'		,type: 'uniQty'},
			    {name: 'REMARK'			        ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			,type: 'string'}	
			]
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('mrp610skrvMasterStore1',{
			model: 'Mrp610skrvModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'mrp610skrvService.selectList'                	
                }
            }
			,loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params: param
				});
				
			},
			groupField: 'DEPT_CODE' 
			
	});	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
            items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
        			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
        		}, 
        		Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			}),
				Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',				
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			{
    			fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
    			name: 'ITEM_LEVEL1',
    			xtype: 'uniCombobox',
    			store: Ext.data.StoreManager.lookup('itemLeve1Store'),
    			child: 'ITEM_LEVEL2',
    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL1', newValue);
						}
					}
    		}, {
    			fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
    			name: 'ITEM_LEVEL2',
    			xtype: 'uniCombobox' ,
    			store: Ext.data.StoreManager.lookup('itemLeve2Store') , 
    			child: 'ITEM_LEVEL3',
    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL2', newValue);
						}
					}
    		},{ 
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>', 
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]
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
   						var labelText = invalid.items[0]['fieldLabel']+':';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}		
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
        			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
        		}, 
        		Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',				
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelSearch.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),
				Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',				
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			{
    			fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
    			name: 'ITEM_LEVEL1',
    			xtype: 'uniCombobox',
    			store: Ext.data.StoreManager.lookup('itemLeve1Store'),
    			child: 'ITEM_LEVEL2',
    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_LEVEL1', newValue);
						}
					}
    		}, {
    			fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
    			name: 'ITEM_LEVEL2',
    			xtype: 'uniCombobox' ,
    			store: Ext.data.StoreManager.lookup('itemLeve2Store') , 
    			child: 'ITEM_LEVEL3',
    			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_LEVEL2', newValue);
						}
					}
    		},{ 
				fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>', 
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('mrp610skrvGrid1', {
    	// for tab    	
        layout: 'fit',
        region: 'center',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [ 				
					{ dataIndex: 'COMP_CODE'		,    width: 93,hidden:true}, 
					{ dataIndex: 'DIV_CODE'			,    width: 93,hidden:true}, 
					{ dataIndex: 'ITEM_CODE'		,    width: 130}, 
					{ dataIndex: 'ITEM_NAME'		,    width: 250}, 
					{ dataIndex: 'DEPT_CODE'		,    width: 93}, 
					{ dataIndex: 'DEPT_NAME'		,    width: 93, 
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				      	return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
		            }}, 
					{ dataIndex: 'AVG_Q'			,    width: 93, summaryType: 'sum'}, 
					{ dataIndex: 'SD_Q'				,    width: 93, summaryType: 'sum'}, 
					{ dataIndex: 'PURCH_LDTIME'		,    width: 93, summaryType: 'sum'}, 
					{ dataIndex: 'SAFETY_Q'			,    width: 93 ,tdCls:'x-change-cell', summaryType: 'sum'}, 
					{ dataIndex: 'REORDER_POINT'	,    width: 93, summaryType: 'sum'}, 
					{ dataIndex: 'EOQ'				,    width: 93, summaryType: 'sum'}, 
					{ dataIndex: 'REMARK'			,    width: 200} 
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
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
        	panelResult.setValue('DEPT_NAME', UserInfo.deptName);
        	
//        	var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.getView();
//			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
//			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
			
			UniAppManager.setToolbarButtons(['reset'],false);
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore.loadStoreRecords();
		}
		
	});
};


</script>

