<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof115skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="sof115skrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" />                 <!--영업담당 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel3 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel4 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('sof115skrvModel', {
	    fields: [
				{name: 'CUSTOM_CODE'		 	,text:'<t:message code="system.label.sales.custom" default="거래처"/>'		,type:'string'},
				{name: 'CUSTOM_NAME'		 	,text:'<t:message code="system.label.sales.customname" default="거래처명"/>' 		,type:'string'},
				{name: 'ORDER_DATE'		 		,text:'<t:message code="system.label.sales.sodate" default="수주일"/>' 		,type:'uniDate',convert:dateToString},
				{name: 'ITEM_CODE'		 		,text:'<t:message code="system.label.sales.item" default="품목"/>' 		,type:'string'},
				{name: 'ITEM_NAME'		 		,text:'<t:message code="system.label.sales.itemname" default="품목명"/>' 		,type:'string'},
				{name: 'SPEC'			 		,text:'<t:message code="system.label.sales.spec" default="규격"/>' 			,type:'string'},				
				{name: 'STOCK_UNIT'		 		,text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>' 		,type:'string', displayField: 'value'},				
				{name: 'ORDER_P'		 		,text:'<t:message code="system.label.sales.price" default="단가"/>' 			,type:'uniPrice'},				
				{name: 'ORDER_Q'		 		,text:'<t:message code="system.label.sales.soqty" default="수주량"/>' 		,type:'uniQty'},
				{name: 'ORDER_O'		 		,text:'<t:message code="system.label.sales.soamount" default="수주액"/>' 		,type:'uniPrice'},						
				{name: 'DVRY_DATE'				,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'		,type:'uniDate',convert:dateToString},
				{name: 'DVRY_CUST_NM'	 		,text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>' 		,type:'string'},				
				{name: 'REMARK'					,text:'<t:message code="system.label.sales.remarks" default="비고"/>'			,type:'string'}

		]
	
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	 }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('sof115skrvMasterStore', {
		model: 'sof115skrvModel',
		uniOpt: {
           	isMaster: true,			// 상위 버튼,상태바 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'sof115skrvService.selectList'                	
		    }
		},
		loadStoreRecords: function() {
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
		groupField: 'CUSTOM_NAME'
	});

	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items: [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, { 
		    	fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
	         	xtype: 'uniDateRangefield',
	         	startFieldName: 'DVRY_DATE_FR',
	         	endFieldName: 'DVRY_DATE_TO',	
	         	width: 315,							               
	         	colspan: 2,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DVRY_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, {
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
				Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				
				holdable: 'hold',
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
			})]	
   		}, {
   			title:'거래처정보',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				
				validateBlank: false, 
				extParam: {'CUSTOM_TYPE':'3'},
				listeners: {
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':'3'});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name:'AGENT_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B055'  
			}, {
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name:'AREA_TYPE', 	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B056'  
			}]
		}, {	
			title:'품목정보',
        	defaultType: 'uniTextfield',
        	id: 'search_panel3',
        	itemId:'search_panel3',
        	layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
	        	listeners: {
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		   }),
				Unilite.popup('ITEM_GROUP',{
				fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				valueFieldName: 'ITEM_GROUP',
				textFieldName: 'ITEM_GROUP_NAME',
				validateBlank:false, 
				popupWidth: 710,
				colspan: 2
			}),{
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
				parentNames:['TXTLV_L1','TXTLV_L2'],
	            levelType:'ITEM'
				
			}]
		}, {	
			title:'수주정보',
			id: 'search_panel4',
			itemId:'search_panel4',			
    		defaultType: 'uniTextfield',
    		layout: {type: 'uniTable', columns: 1},
    		items:[{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.sales.soqty" default="수주량"/>',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_QTY',
					width:218
				}, {
					name: 'TO_ORDER_QTY',
					width:107
				}]
			}, {
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.sales.sono" default="수주번호"/>',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_NUM',
					width:218
				}, {
					name: 'TO_ORDER_NUM',
					width:107
				}] 
			}, {
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name:'TXT_CREATE_LOC', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B031'
			}, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '<t:message code="system.label.sales.closingyn" default="마감여부"/>',
	    		id: 'ORDER_STATUS',
//	    		name: 'ORDER_STATUS',
	    		items: [{
	    			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
	    			width: 50,
	    			name: 'ORDER_STATUS',
	    			inputValue: '%',
	    			checked: true
	    		}, {
	    			boxLabel: '<t:message code="system.label.sales.closing" default="마감"/>',
	    			width: 60, name: 'ORDER_STATUS',
	    			inputValue: 'Y'
	    		}, {
	    			boxLabel: '미마감',
	    			width: 80, name: 'ORDER_STATUS',
	    			inputValue: 'N'
	    		}]
	        }, {
	    		fieldLabel: '상태',
	    		xtype: 'radiogroup',
	    		id: 'rdoSelect2',
//	    		name: 'rdoSelect2',
	    		items: [{
	    			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
	    			width: 50,
	    			name: 'rdoSelect2', 
	    			inputValue: 'A',
	    			checked: true
	    		}, {
	    			boxLabel: '미승인', 
	    			width: 60, name: 'rdoSelect2',
	    			inputValue: 'N'
	    		}, {
	    			boxLabel: '승인',
	    			width: 50, name: 'rdoSelect2',
	    			inputValue: '6'
	    		}, {
	    			boxLabel: '반려',
	    			width: 50, name: 'rdoSelect2',
	    			inputValue: '5'
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, 	
			Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
					
					validateBlank: false, 
					extParam: {'CUSTOM_TYPE':'3'},
					listeners: {
						applyextparam: function(popup) {
							popup.setExtParam({'CUSTOM_TYPE':'3'});
						}
					}
				})
			,
			Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			
			holdable: 'hold',
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
		})]	
    });
	/**
     * Master Grid 정의(Grid Panel),
     * @type 
     */
    var masterGrid = Unilite.createGrid('sof115skrvGrid1', {
    	layout: 'fit', 
    	//layout: 'border', //fit->border 로 변경 5.0.1
    	//split: false,		//locking split panel
    	region:'center',
        uniOpt: {
			expandLastColumn: false,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
    		filter: {
				useFilter: true,
				autoCreate: true
			}
        },   			  
    	store: directMasterStore,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
            
        columns: [        
   			{dataIndex: 'CUSTOM_CODE'	 		, width: 100, locked: true}, 				
   			{dataIndex: 'CUSTOM_NAME'	 		, width: 133, locked: true}, 	
			{dataIndex: 'ORDER_DATE'		 	, width: 93}, 	 
            {dataIndex: 'ITEM_CODE'		 		, width: 133}, 				
			{dataIndex: 'ITEM_NAME'		 		, width: 166}, 				
			{dataIndex: 'SPEC'			 		, width: 133}, 				
			{dataIndex: 'STOCK_UNIT'		 	, width: 53}, 	
			{dataIndex: 'ORDER_P'		 		, width: 106}, 				
			{dataIndex: 'ORDER_Q'		 		, width: 106, summaryType: 'sum'}, 					
			{dataIndex: 'ORDER_O'		 		, width: 120, summaryType: 'sum'}, 	
			{dataIndex: 'DVRY_DATE'			 	, width:93}, 
			{dataIndex: 'DVRY_CUST_NM'	 		, width:100},	
			{dataIndex: 'REMARK'				, width:200},

		] 
    });

    Unilite.Main({
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
		id: 'sof115skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));


			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo 	= panelSearch.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);
			
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true); 
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});
};
</script>
