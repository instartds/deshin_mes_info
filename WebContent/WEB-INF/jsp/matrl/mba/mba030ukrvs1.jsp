<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'단위환산정보등록',
		border: false,
		id		: 'tab_tranUnit',
		itemId	: 'tab_tranUnit',
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2, tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'}},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>',
				name: 'BASE_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B013', 
				displayField: 'value'
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				tdAttrs: {align: 'right'},
				width: 300,
				items:[{
					xtype: 'component',
					border: false,
					html: "<font color= 'blue'>※ 입고수량 = (구매수량 * 입수)&nbsp;&nbsp;</font>"
	
				}]	
			}]			
		}, {				
			xtype: 'uniGridPanel',
			id		: 'mba030ukrsGrid1',
			itemId	: 'mba030ukrsGrid1',
		    store	: mba030ukrvs1Store,
			uniOpt	: {							
					useMultipleSorting	: true,				
				    useLiveSearch		: true,				
				    onLoadSelectFirst	: false,					
				    dblClickToEdit		: true,				
				    useGroupSummary		: false,				
					useContextMenu		: false,			
					useRowNumberer		: true,			
					expandLastColumn	: false,				
					useRowContext		: true,			
				    filter: {						
						useFilter		: true,		
						autoCreate		: true		
				},						
				excel: {						
					useExcel		: true,		//엑셀 다운로드 사용 여부	
					exportGroup		: false,	//group 상태로 export 여부		
					onlyData		: false,			
					summaryExport	: false				
				}						
			},							
			columns: [{dataIndex: 'STOCK_UNIT'			,		width:180},				  
					  {dataIndex: 'ORDER_UNIT'			,		width:180},
					  {dataIndex: 'TRNS_RATE'			,		width:180},
					  {dataIndex: 'ITEM_CHG'			,		width:100,hidden:true},
					  {dataIndex: 'COMP_CODE'			,		width:100,hidden:true},
					  {dataIndex: 'UPDATE_DATE'			,		flex:1}
			], 
			listeners: {
	      		beforeedit  : function( editor, e, eOpts ) {
	      			//조회된 데이터일 경우, 입수만 수정 가능
		      		if(!e.record.phantom){
		      			if (UniUtils.indexOf(e.field, ['TRNS_RATE'])){
							return true;
							
						} else {
							return false;
						}
						
					//신규입력일 경우, 최종변경일 외 수정 가능
					} else {
		      			if (UniUtils.indexOf(e.field, ['UPDATE_DATE'])){
							return false;
						}
					}
	      		}
	  			 
			}
		}]
	}