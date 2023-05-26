<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp175ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M003" />		 <!-- 반영여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />		 <!-- 수급계획 담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="T109" />		 <!-- 국내외구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mrp175ukrvService.selectGrid',
	//		update: 'mrp175ukrvService.updateDetail',
			create: 'mrp175ukrvService.insertDetail',
	//		destroy: 'mrp175ukrvService.deleteDetail',
			syncAll: 'mrp175ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Mrp175ukrvModel', {		
	    fields: [
			{name: 'FLAG'   						,text:'FLAG'					,type: 'string'},
	    	{name: 'DIV_CODE'						,text: '<t:message code="system.label.purchase.mfgplace" default="제조처"/>' 				,type: 'string'},
	    	{name: 'MRP_CONTROL_NUM'				,text: '<t:message code="system.label.purchase.grgiplanno" default="수급계획번호"/>' 			,type: 'string'},
	    	{name: 'ITEM_CODE'						,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 				,type: 'string'},
	    	{name: 'ITEM_NAME'						,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>' 				,type: 'string'},
	    	{name: 'SPEC'							,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 				,type: 'string'},
	    	{name: 'STOCK_UNIT'						,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>' 				,type: 'string'},
	    	{name: 'TOTAL_NEED_Q'					,text: '<t:message code="system.label.purchase.totalrequiredqty" default="총소요량"/>' 				,type: 'uniQty'},
	    	{name: 'DAY_AVG_SPEND'					,text: '일평균소비량' 			,type: 'uniQty'},
	    	{name: 'PURCH_LDTIME'					,text: '구매LT' 				,type: 'string'},
	    	{name: 'SAFE_STOCK_Q'					,text: '<t:message code="system.label.purchase.safetystock" default="안전재고"/>' 				,type: 'uniQty'},
	    	{name: 'ORDER_POINT'					,text: '발주점' 				,type: 'string'},
	    	{name: 'ORDER_PLAN_Q'					,text: '발주예정량' 			,type: 'uniQty'},
	    	{name: 'EXC_STOCK_Q'					,text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>' 				,type: 'uniQty'},
	    	{name: 'WH_STOCK_Q'						,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>' 				,type: 'uniQty'},
	    	{name: 'INSTOCK_PLAN_Q'					,text: '<t:message code="system.label.purchase.receiptplanned" default="입고예정"/>' 				,type: 'uniQty'},
	    	{name: 'OUTSTOCK_PLAN_Q'				,text: '<t:message code="system.label.purchase.issueresevation" default="출고예정"/>' 				,type: 'uniQty'},
	    	{name: 'ORDER_PLAN_DATE'				,text: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>' 			,type: 'uniDate'},
	    	{name: 'BASIS_DATE'						,text: '납기예정일' 			,type: 'uniDate'},
	    	{name: 'ORDER_PLAN_YN'					,text: '반영여부' 				,type: 'string',comboType:'AU',comboCode:'M003'},
	    	{name: 'ORDER_PLAN_YN_NM'				,text: '' 					,type: 'string'},
	    	{name: 'SUPPLY_TYPE'					,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>' 				,type: 'string'},
	    	{name: 'SUPPLY_TYPE_NM'					,text: '' 					,type: 'string'},
    		{name: 'DOM_FORIGN'						,text: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>' 			,type: 'string',comboType:'AU',comboCode:'T109'},
	    	{name: 'DOM_FORIGN_NM'					,text: '' 					,type: 'string'},
	    	{name: 'CUSTOM_CODE'					,text: '<t:message code="system.label.purchase.custom" default="거래처"/>' 				,type: 'string'},
	    	{name: 'CUSTOM_NAME'					,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>' 				,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrp175ukrvMasterStore1',{
			model: 'Mrp175ukrvModel',
			uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: false,			// 수정 모드 사용 
            	deletable	: false,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				if(inValidRecs.length == 0 )	{
					var allRecords = directMasterStore1.data.items
					var isErr = false;
                    if(isErr) return false;
					var records = masterGrid.getSelectedRecords();
					Ext.each(records, function(record, index) {
					   if(record.data['ORDER_PLAN_YN'] == 'Y') {
                           alert('이미 반영된 자료가 존재합니다.');
                           isErr = true;
                           return false;
                       }else{
                           record.phantom = true;
                       }					   
					});
					if(isErr) return false;
					var paramMaster= panelSearch.getValues();
					config = {
                        params: [paramMaster],
                        success: function(batch, option) {                                
                            directMasterStore1.loadStoreRecords();                        
                        } 
                    };
					directMasterStore1.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			groupField: ''
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
                xtype:'component', 
                html:'<b>[최근 ROP품목 소요량계산 내용]</b>',
                margin: '10 0 10 0',
                tdAttrs: {Style: 'text-align:right'}
            },{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
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
    			fieldLabel: '소요량 계산일',
    			name:'ROP_DATE',
				xtype: 'uniDatefield',
				allowBlank: false,
				readOnly: true
			},{ 
    			fieldLabel: '가용재고반영 기준일',
    			name:'BASIC_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank: false,
				readOnly: true
			},{					
    			fieldLabel: '수급계획 담당자',
    			name:'PLAN_PSRN',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'M201',
    			readOnly:true
    		},{
			    xtype: 'radiogroup',
			    id: 'rdoSelect2',
			    fieldLabel: '현재고 반영',
			    //disabled:true,
			    items : [{
			    	boxLabel: '예',
			    	name: 'STOCK_YN',
			    	inputValue: 'Y',
			    	width:80,
			    	readOnly:true
			    }, {
			    	boxLabel: '아니오',
			    	name: 'STOCK_YN' ,
			    	inputValue: 'N',
			    	readOnly:true,
			    	width:80
			    }]
			},{
			    xtype: 'radiogroup',
			    id: 'rdoSelect3',
			    fieldLabel: '안전재고 반영',
			    items : [{
			    	boxLabel: '예',
			    	name: 'SAFE_STOCK_YN',
			    	inputValue: 'Y',
			    	readOnly:true,
			    	width:80
			    }, {
			    	boxLabel: '아니오',
			    	name: 'SAFE_STOCK_YN' ,
			    	inputValue: 'N',
			    	readOnly:true,
			    	width:80
			    }]		
			},{
			    xtype: 'radiogroup',
			    id: 'rdoSelect4',
			    fieldLabel: '입고예정 반영',
			    items : [{
			    	boxLabel: '예',
			    	name: 'INSTOCK_PLAN_YN',
			    	inputValue: 'Y',
			    	readOnly:true,
			    	width:80
			    }, {
			    	boxLabel: '아니오',
			    	name: 'INSTOCK_PLAN_YN' ,
			    	inputValue: 'N',
			    	readOnly:true,
			    	width:80
			    }]
			},{
			    xtype: 'radiogroup',
			    id: 'rdoSelect5',
			    fieldLabel: '출고예정 반영',
			    items : [{
			    	boxLabel: '예',
			    	name: 'OUTSTOCK_PLAN_YN',
			    	inputValue: 'Y',
			    	readOnly:true,
			    	width:80
			    }, {
			    	boxLabel: '아니오',
			    	name: 'OUTSTOCK_PLAN_YN' ,
			    	inputValue: 'N',
			    	readOnly:true,
			    	width:80
			    }]
			},{
			    xtype: 'radiogroup',
			    id: 'rdoSelect8',
			    fieldLabel: '외주재고 반영',
			    items : [{
			    	boxLabel: '예',
			    	name: 'CUSTOM_STOCK_YN',
			    	inputValue: 'Y',
			    	readOnly:true,
			    	width:80
			    }, {
			    	boxLabel: '아니오',
			    	name: 'CUSTOM_STOCK_YN' ,
			    	inputValue: 'N',
			    	readOnly:true,
			    	width:80
			    }]
			},{
				xtype:'uniTextfield',
				name:'ORDER_PLAN_YN',
				hidden:true
			}]	
		}],
		api: {
			load: 'mrp175ukrvService.selectForm'
		}
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'container',
    			layout: {type : 'uniTable'},
    			colspan:4,
    			items :[{
                    xtype:'component', 
                    width: 300,
                    html:'<b>[최근 ROP품목 소요량계산 내용]</b>',
                    margin: '10 0 10 10',
                    tdAttrs: {Style: 'text-align:left'}
                }]			
			},{
					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					labelWidth: 120,
					allowBlank: false,
					value: UserInfo.divCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},{ 
	    			fieldLabel: '소요량 계산일',
	    			name:'ROP_DATE',
					xtype: 'uniDatefield',
					readOnly: true,
					value: UniDate.get('today'),
					allowBlank: false
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect10',
				    fieldLabel: '현재고 반영',
				    items : [{
						    	boxLabel: '예',
						    	name: 'STOCK_YN',
						    	inputValue: 'Y',
						    	readOnly:true,
			    				width:80
						    },{
						    	boxLabel: '아니오',
						    	name: 'STOCK_YN' ,
						    	inputValue: 'N',
						    	readOnly:true,
			    				width:80
						    }]/*,
				    listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.getField('STOCK_YN').setValue(newValue.STOCK_YN);
								}
						}*/
				},{
				    xtype: 'radiogroup',
				    id: 'rdoSelect11',
				    fieldLabel: '안전재고 반영',
				    items : [{
					    	boxLabel: '예',
					    	name: 'SAFE_STOCK_YN',
					    	inputValue: 'Y',
					    	readOnly:true,
			    			width:80
					    },{
					    	boxLabel: '아니오',
					    	name: 'SAFE_STOCK_YN' ,
					    	inputValue: 'N',
					    	readOnly:true,
			    			width:80
					    }]/*,
				    listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.getField('SAFE_STOCK_YN').setValue(newValue.SAFE_STOCK_YN);
							}
						}	*/			
					},{ 
		    			fieldLabel: '가용재고반영 기준일',
		    			name:'BASIC_DATE',
						xtype: 'uniDatefield',
						labelWidth: 120,
						allowBlank: false,
						value: UniDate.get('today'),
						readOnly: true
					},{					
		    			fieldLabel: '수급계획 담당자',
		    			name:'PLAN_PSRN',
		    			xtype: 'uniCombobox',
		    			comboType:'AU',
		    			comboCode:'M201',
		    			readOnly:true
		    		},{
					    xtype: 'radiogroup',
					    id: 'rdoSelect12',
					    fieldLabel: '입고예정 반영',
					    items : [{
							    	boxLabel: '예',
							    	name: 'INSTOCK_PLAN_YN',
							    	inputValue: 'Y',
							    	readOnly:true,
			    					width:80
							    }, {
							    	boxLabel: '아니오',
							    	name: 'INSTOCK_PLAN_YN' ,
							    	inputValue: 'N',
							    	readOnly:true,
			    					width:80
							    }]/*,
				    listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.getField('INSTOCK_PLAN_YN').setValue(newValue.INSTOCK_PLAN_YN);
							}
						}				*/
					},{
					    xtype: 'radiogroup',
					    id: 'rdoSelect13',
					    fieldLabel: '출고예정 반영',
					    items : [{
							    	boxLabel: '예',
							    	name: 'OUTSTOCK_PLAN_YN',
							    	inputValue: 'Y',
							    	readOnly:true,
			    					width:80
							    }, {
							    	boxLabel: '아니오',
							    	name: 'OUTSTOCK_PLAN_YN' ,
							    	inputValue: 'N',
							    	readOnly:true,
			    					width:80
							    }]/*,
				    listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.getField('OUTSTOCK_PLAN_YN').setValue(newValue.OUTSTOCK_PLAN_YN);
							}
						}			*/	
				},{
					xtype	: 'component'
				},{
					xtype	: 'component'
				},{
					xtype	: 'component'
				},{					
				    xtype: 'radiogroup',
				    id: 'rdoSelect14',
				    fieldLabel: '외주재고 반영',
				    items : [{
				    	boxLabel: '예',
				    	name: 'CUSTOM_STOCK_YN',
				    	inputValue: 'Y',
				    	readOnly:true,
			    		width:80
				    }, {
				    	boxLabel: '아니오',
				    	name: 'CUSTOM_STOCK_YN' ,
				    	inputValue: 'N',
				    	readOnly:true,
			    		width:80
				    }]/*,
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('CUSTOM_STOCK_YN').setValue(newValue.CUSTOM_STOCK_YN);
						}
					}				*/
			}],
			api: {
			load: 'mrp175ukrvService.selectForm'
		}
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('mrp175ukrvGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        selModel:   Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly : false,
        	toggleOnClick:false,
        	listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
//					if(selectRecord.get('ORDER_PLAN_YN') == 'Y'){					   
//					   return false;
//					}
					UniAppManager.setToolbarButtons(['save'], true);
                    if(Ext.isEmpty(masterGrid.getSelectedRecords())){
                        UniAppManager.setToolbarButtons(['save'], false);
                    }
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
                    UniAppManager.setToolbarButtons(['save'], true);
                    if(Ext.isEmpty(masterGrid.getSelectedRecords())){
                        UniAppManager.setToolbarButtons(['save'], false);
                    }
	    		}
			}
		}), 
		uniOpt: {
//			allowDeselect : false,
//    		useGroupSummary: false,
    		//useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
//			useRowNumberer: false,
//			expandLastColumn: false,
			onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
               		 { dataIndex: 'FLAG'  			  									 ,	width:40, hidden:true},
               		 { dataIndex: 'DIV_CODE'			  			  				     , 	width:106, hidden:true},
               		 { dataIndex: 'MRP_CONTROL_NUM'	  			  				    	 , 	width:106, hidden:true},
               		 { dataIndex: 'ITEM_CODE'			  			  				     , 	width:100},
               		 { dataIndex: 'ITEM_NAME'			  			  				     , 	width:240},
               		 { dataIndex: 'SPEC'				  			  				     , 	width:120},
               		 { dataIndex: 'STOCK_UNIT'			  			  				     , 	width:80, align: 'center'},
               		 { dataIndex: 'TOTAL_NEED_Q'		  			  				     , 	width:66, hidden:true},
               		 { dataIndex: 'DAY_AVG_SPEND'		  			  				     , 	width:110},
               		 { dataIndex: 'PURCH_LDTIME'		  			  				     , 	width:64},
               		 { dataIndex: 'SAFE_STOCK_Q'		  			  				     , 	width:93},
               		 { dataIndex: 'ORDER_POINT'		  			  				   	  	 , 	width:93},
               		 { dataIndex: 'ORDER_PLAN_Q'		  			  				     , 	width:93},
               		 { dataIndex: 'EXC_STOCK_Q'		  			  				     	 , 	width:93},
               		 { dataIndex: 'WH_STOCK_Q'			  			  				     , 	width:93},
               		 { dataIndex: 'INSTOCK_PLAN_Q'		  			  				     , 	width:93},
               		 { dataIndex: 'OUTSTOCK_PLAN_Q'	  			  				     	 , 	width:93},
               		 { dataIndex: 'ORDER_PLAN_DATE'	  			  				    	 , 	width:76},
               		 { dataIndex: 'BASIS_DATE'			  			  				     , 	width:76},
               		 { dataIndex: 'ORDER_PLAN_YN'		  			  				     , 	width:76},
               		 { dataIndex: 'ORDER_PLAN_YN_NM'	  			  				     , 	width:76, hidden:true},
               		 { dataIndex: 'SUPPLY_TYPE'		  			  				    	 , 	width:80, hidden:true},
               		 { dataIndex: 'SUPPLY_TYPE_NM'		  			  				     , 	width:80, hidden:true},
               		 { dataIndex: 'DOM_FORIGN'			  			  				     , 	width:80, align: 'center'},
               		 { dataIndex: 'DOM_FORIGN_NM'		  			  				     , 	width:80, hidden:true},
               		 { dataIndex: 'CUSTOM_CODE'		  			  				   		 , 	width:0, hidden:true},
               		 { dataIndex: 'CUSTOM_NAME'		  			  				    	 , 	width:0, hidden:true}
        ] 
    });   
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,panelResult
			]
		},
			panelSearch  	
		],
		id  : 'mrp175ukrvApp',
		fnInitBinding: function() {
			if(Ext.isEmpty(${masterHead})){
                panelSearch.setValue('DIV_CODE',UserInfo.divCode);
                panelSearch.setValue('ROP_DATE',UniDate.get('today'));
                panelSearch.setValue('BASIC_DATE',UniDate.get('today'));
                panelSearch.setValue('STOCK_YN','Y');
                panelSearch.setValue('SAFE_STOCK_YN','N');
                panelSearch.setValue('INSTOCK_PLAN_YN','N');
                panelSearch.setValue('OUTSTOCK_PLAN_YN','N');
                panelSearch.setValue('CUSTOM_STOCK_YN','N');
                
                panelResult.setValue('DIV_CODE',UserInfo.divCode);
                panelResult.setValue('ROP_DATE',UniDate.get('today'));
                panelResult.setValue('BASIC_DATE',UniDate.get('today'));
                panelResult.setValue('STOCK_YN','Y');
                panelResult.setValue('SAFE_STOCK_YN','N');
                panelResult.setValue('INSTOCK_PLAN_YN','N');
                panelResult.setValue('OUTSTOCK_PLAN_YN','N');
                panelResult.setValue('CUSTOM_STOCK_YN','N');
			}else{
			    panelSearch.setValue('DIV_CODE', ${masterHead}['DIV_CODE']);
                panelSearch.setValue('ROP_DATE', ${masterHead}['ROP_DATE']);
                panelSearch.setValue('BASIC_DATE', ${masterHead}['BASIC_DATE']);
                panelSearch.setValue('PLAN_PSRN', ${masterHead}['PLAN_PSRN']);                
                panelSearch.getField('STOCK_YN').setValue(${masterHead}['STOCK_YN']);
                panelSearch.getField('SAFE_STOCK_YN').setValue(${masterHead}['SAFE_STOCK_YN']);
                panelSearch.getField('INSTOCK_PLAN_YN').setValue(${masterHead}['INSTOCK_PLAN_YN']);
                panelSearch.getField('OUTSTOCK_PLAN_YN').setValue(${masterHead}['OUTSTOCK_PLAN_YN']);
                panelSearch.getField('CUSTOM_STOCK_YN').setValue(${masterHead}['CUSTOM_STOCK_YN']); 
                
                panelResult.setValue('DIV_CODE', ${masterHead}['DIV_CODE']);
                panelResult.setValue('ROP_DATE', ${masterHead}['ROP_DATE']);
                panelResult.setValue('BASIC_DATE', ${masterHead}['BASIC_DATE']);
                panelResult.setValue('PLAN_PSRN', ${masterHead}['PLAN_PSRN']);                
                panelResult.getField('STOCK_YN').setValue(${masterHead}['STOCK_YN']);
                panelResult.getField('SAFE_STOCK_YN').setValue(${masterHead}['SAFE_STOCK_YN']);
                panelResult.getField('INSTOCK_PLAN_YN').setValue(${masterHead}['INSTOCK_PLAN_YN']);
                panelResult.getField('OUTSTOCK_PLAN_YN').setValue(${masterHead}['OUTSTOCK_PLAN_YN']);
                panelResult.getField('CUSTOM_STOCK_YN').setValue(${masterHead}['CUSTOM_STOCK_YN']); 
			}
			UniAppManager.setToolbarButtons('reset', false);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
//				panelSearch.getForm().load();
//				panelResult.getForm().load();
				directMasterStore1.loadStoreRecords();	
			}
		},
        onSaveDataButtonDown: function(config) {    
        	directMasterStore1.saveStore();
        },
		
//		onResetButtonDown: function() {
//			panelSearch.clearForm();
//			panelSearch.setAllFieldsReadOnly(false);
//			panelResult.clearForm();
//			panelResult.setAllFieldsReadOnly(false);
//			masterGrid.reset();
//		//	panelResult.clearForm();
//	//		panelResult.setAllFieldsReadOnly(false);
//			this.fnInitBinding();
//		},
		setDefault: function() {
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() { 
			return panelSearch.setAllFieldsReadOnly(true);
			//	   panelResult.setAllFieldsReadOnly(true);
        }
	});
};

</script>
