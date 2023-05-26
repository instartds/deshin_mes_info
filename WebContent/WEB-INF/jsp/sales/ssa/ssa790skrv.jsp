<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa790skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa790skrv"  /> 			<!-- 사업장 -->  
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */	   
	
	var deptList = ${deptList};
	Unilite.defineModel('ssa790skrvModel1', {
	    
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa790skrvMasterStore1',{
		model: 'ssa790skrvModel1',
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
            	   read: 'ssa790skrvService.selectList1'                	
            }
        }
		,loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.deptInfoList = deptList;	//부서목록
			
			console.log( param );
			this.load({
				params: param
			});			
		}
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
        		layout: {type: 'uniTable', columns:1},
        		items: [{
        			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
        		},{
					fieldLabel: '실적년월',
					name: 'BASIS_DAY',
					xtype: 'uniMonthfield',
					holdable: 'hold',
					value: new Date(),
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BASIS_DAY', newValue);
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
    			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
    			allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
    		},{
				fieldLabel: '실적년월',
				name: 'BASIS_DAY',
				xtype: 'uniMonthfield',
				value: new Date(),
				holdable: 'hold',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BASIS_DAY', newValue);
					}
				}
			}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa790skrvGrid1', {
    	// for tab
    	region: 'center',
        //layout: 'fit',    
		syncRowHeight: false,  
		uniOpt: {
		 	expandLastColumn: false,
		 	useRowNumberer: false,
		 	useContextMenu: true
        }, 
    	store: directMasterStore1,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [        
               							
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
			
			/*Model && Grid 동적 생성*/
			var grid = masterGrid;
		    var model = grid.getStore().getModel();
		    var modelFields = new Array();//model.getFields();
		    
		    modelFields.push({name:'SALE_DATE', text: '날짜' ,type:'uniDate'});
		    modelFields.push({name:'SALE_TOT_AMT', text: '<t:message code="system.label.sales.totalamount" default="합계"/>' ,type:'uniPrice'});
		    
		    var eColumn = Ext.create('Unilite.com.grid.column.UniPriceColumn', {
				dataIndex: 'SALE_TOT_AMT', 
				text: '<t:message code="system.label.sales.totalamount" default="합계"/>', 
				width:100,
				align:'right',
				summaryType: 'sum',
				summaryRenderer: Ext.util.Format.numberRenderer(UniFormat.Price)
		    });
		    grid.headerCt.insert(grid.columns.length, eColumn);
		    grid.setColumnInfo(grid, eColumn ,modelFields);
		    
			Ext.each(deptList, function(deptItem, idx) {
			    modelFields.push({name: deptItem.TREE_CODE, text:deptItem.TREE_NAME ,type:'uniPrice'})
			    eColumn = Ext.create('Unilite.com.grid.column.UniPriceColumn', {
					dataIndex: deptItem.TREE_CODE,
					text: deptItem.TREE_NAME,
					width:100,
					align:'right',
					summaryType: 'sum',
					summaryRenderer: Ext.util.Format.numberRenderer(UniFormat.Price)
			    });
			    grid.headerCt.insert(grid.columns.length, eColumn);
			    grid.setColumnInfo(grid, eColumn ,modelFields);
			});
			eColumn = Ext.create('Unilite.com.grid.column.UniDateColumn', {
				dataIndex: 'SALE_DATE', 
				text: '날짜', 
				width:100,
				align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            	}
		    });
		    grid.headerCt.insert(grid.columns.length, eColumn);
		    grid.setColumnInfo(grid, eColumn ,modelFields);
		    Ext.applyIf(model, {'fields':modelFields});
			
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();		
			var viewNormal = masterGrid.getView();			
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
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('BASIS_DAY',new Date());
			panelResult.setValue('BASIS_DAY',new Date());
		}
	});

};


</script>
