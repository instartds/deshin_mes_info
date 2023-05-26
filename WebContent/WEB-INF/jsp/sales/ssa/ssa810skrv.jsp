<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa810skrv"  >

	<t:ExtComboStore comboType="BOR120" pgmId="ssa810skrv"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="S052" /> <!--문서단계 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('ssa810skrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'						,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>' 				,type:'string'},
	    	{name: 'DIV_CODE'						,text:'<t:message code="system.label.sales.division" default="사업장"/>' 				,type:'string', xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'STORE_CODE'						,text:'<t:message code="system.label.sales.department" default="부서"/>' 					,type:'string'},
	    	{name: 'STORE_NAME'						,text:'<t:message code="system.label.sales.departmentname" default="부서명"/>' 				,type:'string'},
	    	{name: 'PURCHASE_CUSTOM_CODE'			,text:'<t:message code="system.label.sales.purchaseplace" default="매입처"/>' 				,type:'string'},
	    	{name: 'PURCHASE_CUSTOM_NAME'			,text:'<t:message code="system.label.sales.purchaseplacename" default="매입처명"/>' 				,type:'string'},
	    	{name: 'ITEM_CODE'						,text:'<t:message code="system.label.sales.item" default="품목"/>' 					,type:'string'},
	    	{name: 'ITEM_NAME'						,text:'<t:message code="system.label.sales.itemname" default="품목명"/>' 				,type:'string'},
	    	{name: 'TAX_TYPE'						,text:'<t:message code="system.label.sales.taxabledivision" default="과세구분"/>' 				,type:'string', comboType: 'AU', comboCode: 'B059'},
	    	{name: 'SALE_Q'							,text:'판매수량' 				,type:'uniPrice'},
	    	{name: 'SALE_BASIS_P'					,text:'(기준)판매단가' 				,type:'uniUnitPrice'},
	    	{name: 'GROSS_SALES'					,text:'총매출액' 				,type:'uniPrice'},
	    	{name: 'DISCOUNT_O'						,text:'할인(에누리)' 			,type:'uniPrice'},
	    	{name: 'NET_SALES'						,text:'순매출액' 				,type:'uniPrice'},
	    	{name: 'SALE_AMT_O'						,text:'<t:message code="system.label.sales.supplyamount" default="공급가액"/>' 				,type:'uniPrice'},
	    	{name: 'TAX_AMT_O'						,text:'<t:message code="system.label.sales.taxamount" default="세액"/>' 					,type:'uniPrice'}
	    ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa810skrvMasterStore1',{
			model: 'ssa810skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa810skrvService.selectList'  
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log(param);					
				this.load({
					params : param
				});
				
			},
			groupField: 'STORE_CODE'			
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
			layout : {type : 'uniTable', columns : 1},
        	items : [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},
				Unilite.popup('DEPT',{ 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
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
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),
		    Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));	
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		   }),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>',
				labelWidth:90,
				items : [{
					boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
					width:60,
					name:'TAX_TYPE',
					//inputValue: 'A',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.sales.taxation" default="과세"/>',
					width:60,
					name:'TAX_TYPE',
					inputValue: '1'
				},{
					boxLabel: '<t:message code="system.label.sales.taxexemption" default="면세"/>', 
					width:60, 
					name:'TAX_TYPE' , 
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelResult.getField('TAX_TYPE').setValue(newValue.TAX_TYPE);
					}
				}
			}]
		}], setAllFieldsReadOnly: function(b) {
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
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('today'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},
				Unilite.popup('DEPT',{ 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
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
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),
		    Unilite.popup('DIV_PUMOK',{ 
		        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
		        	valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
		        	listeners: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
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
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
		   }),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>',
				labelWidth:90,
				items : [{
					boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
					width:60,
					name:'TAX_TYPE',
					//inputValue: 'A',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.sales.taxation" default="과세"/>',
					width:60,
					name:'TAX_TYPE',
					inputValue: '1'
				},{
					boxLabel: '<t:message code="system.label.sales.taxexemption" default="면세"/>', 
					width:60, 
					name:'TAX_TYPE' , 
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelSearch.getField('TAX_TYPE').setValue(newValue.TAX_TYPE);
					}
				}
			}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa810skrvGrid', {
    	layout : 'fit',
    	region:'center',
    	excelTitle: '부서별 매출현황 상세',
        store : directMasterStore1, 
        uniOpt:{
        	expandLastColumn: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
    	store: directMasterStore1,
        columns: [   
        	{dataIndex: 'COMP_CODE'			        , width:100, hidden: true},
        	{dataIndex: 'DIV_CODE'			        , width:160,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            	}
            },
        	{dataIndex: 'STORE_CODE'			    , width:70},
        	{dataIndex: 'STORE_NAME'			    , width:100},
        	{dataIndex: 'PURCHASE_CUSTOM_CODE'		, width:80},
        	{dataIndex: 'PURCHASE_CUSTOM_NAME'	    , width:150},
        	{dataIndex: 'ITEM_CODE'				    , width:100},
        	{dataIndex: 'ITEM_NAME'				    , width:180},
        	{dataIndex: 'TAX_TYPE'			        , width:80, align:'center'},
        	{dataIndex: 'SALE_Q'		        	, width:80, summaryType: 'sum'},
        	{dataIndex: 'SALE_BASIS_P'		        , width:100, summaryType: 'sum'},        	
        	{dataIndex: 'GROSS_SALES'		        , width:120, summaryType: 'sum'},
        	{dataIndex: 'DISCOUNT_O'			    , width:120, summaryType: 'sum'},
        	{dataIndex: 'NET_SALES'			        , width:120, summaryType: 'sum'},
        	{dataIndex: 'SALE_AMT_O'			    , width:120, summaryType: 'sum'},
        	{dataIndex: 'TAX_AMT_O'			        , width:120, summaryType: 'sum'}

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
		id: 'ssa810skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}			
			masterGrid.getStore().loadStoreRecords();
					
				
		},
		onResetButtonDown:function() {
			
			var frm = Ext.getCmp('searchForm');						
			var grid = masterGrid;				
			frm.reset();			
			grid.reset();			
		}
	});

};


</script>
