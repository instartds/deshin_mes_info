<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="gba220skrv"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장				 -->  
</t:appConfig>
<script type="text/javascript">
	function appMain(){
		Unilite.defineModel('Gba220skrvModel', {
			fields:[ 
				{name:'GUBUN1',			text:'<t:message code="system.label.base.classfication" default="구분"/>',		type:'string'},
				{name:'ITEM_CODE',		text:'항목',		type:'string'},
				{name:'ITEM_NAME',		text:'항목명',		type:'string'},
				{name:'SPEC',			text:'<t:message code="system.label.base.spec" default="규격"/>',		type:'string'},
				
				{name:'ORDER_UNIT_Q',	text:'수량',		type:'uniQty'},
				{name:'ORDER_P',		text:'단가',		type:'uniUnitPrice'},
				{name:'ORDER_O',		text:'수주금액',	type:'uniPrice'},
				
				{name:'BUDGET_UNIT_O',	text:'단가',		type:'uniUnitPrice'},
				{name:'BUDGET_O',		text:'예산금액',	type:'uniPrice'},
				
				{name:'EX_O',			text:'실행',		type:'uniPrice'},
				{name:'CSTOCK',			text:'현재고',		type:'uniQty'},
				
				{name:'SALE_Q',			text:'수량',		type:'uniQty'},
				{name:'SALE_O',			text:'금액',		type:'uniPrice'}
				//{name: 'TOTAL_AMT',		text:'합계',		type:'string'}
			
			]
		})
		var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'gba220skrvService.selectDetailList'
			}
		});
		var directMasterStore=Unilite.createStore('gba220skrvMasterStore',{
			model:'Gba220skrvModel',
			autoLoad:false,
			uniOpt:{
				isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
			},
			proxy:directProxy,
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
				groupField:  'GUBUN1'
		});
		var panelSearch=Unilite.createSearchForm('searchForm',{
			layout: {type : 'uniTable' , columns: 2, tableAttrs: {width: '100%'}},
			padding:'1 1 1 1',
            border:true,
			items:[{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode
			},
			Unilite.popup('PROJECT',{
				fieldLabel: '프로젝트번호',
				valueFieldName:'PJT_CODE',
			    textFieldName:'PJT_NAME',
	       		DBvalueFieldName: 'PJT_CODE',
			    DBtextFieldName: 'PJT_NAME',
			    autoPopup:false,
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('FR_DATE', records[0].FR_DATE);
                                panelSearch.setValue('TO_DATE', records[0].TO_DATE);
                                panelSearch.setValue('CUSTOM_CODE', records[0].CUSTOM_CODE);
                                panelSearch.setValue('CUSTOM_NAME', records[0].CUSTOM_NAME);
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('FR_DATE', '');
                            panelSearch.setValue('TO_DATE', '');
                            panelSearch.setValue('CUSTOM_CODE', '');
                            panelSearch.setValue('CUSTOM_NAME', '');
                            
                        }
                    }
			}),
			Unilite.popup('AGENT_CUST',{
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
		    		textFieldName:'CUSTOM_NAME',
		    		readOnly:true
                }),{
            		fieldLabel:'프로젝트기간',
            		xtype: 'uniDateRangefield',
            		startFieldName: 'FR_DATE',
            		endFieldName:'TO_DATE',    		
            		allowBlank:true,
            		readOnly:true,
            		//editable:false,
            		width:315
				}
		]
			
	});
	var masterGrid=Unilite.createGrid('gba220skrvGrid',{
		layout : 'fit',
		region:'center',
	 	store: directMasterStore,
	 	uniOpt:{	
	 	    expandLastColumn: true,
			useRowNumberer: false,
            useMultipleSorting:false
   	    },
       	features: [ {id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  true },
    	           	{id:  'masterGridTotal', 	ftype:  'uniSummary', 	  showSummaryRow:  true} ],
       	columns:[
       	 			{text:'<t:message code="system.label.base.classfication" default="구분"/>',
       	 			 columns:[
       	 			 	{dataIndex:'GUBUN1',width:80, align: 'center', 
       	 			 		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
       	 			 			
//                            metaData.tdCls = 'x-change-cell_color1';
//                            summaryData.tdCls = 'x-change-cell_color1';
              				return Unilite.renderSummaryRow(summaryData, metaData, '소계','합계'/*'<font color="blue">소계</font>', '<font color="blue">합계</font>'*/);
              				}
       	 			 	},
       	 			 	
       	 			 	{dataIndex:'ITEM_CODE',	width:100},
       	 			 	{dataIndex:'ITEM_NAME',	width:200},
       	 			 	{dataIndex:'SPEC',		width:200}
       	 			 ]
       	 			},{text:'수주',
       	 			 columns:[
       	 			 	{dataIndex:'ORDER_UNIT_Q',width:80,		summaryType: 'sum'},
       	 			 	{dataIndex:'ORDER_P',	width:100},
       	 			 	{dataIndex:'ORDER_O',	width:120,		summaryType: 'sum'}
       	 			 ]
       	 			},{text:'예산',
       	 				columns:[
       	 				{dataIndex:'BUDGET_UNIT_O',width:100},
       	 			 	{dataIndex:'BUDGET_O',	width:120,		summaryType: 'sum'}
       	 				]
       	 			},{dataIndex:'EX_O',		width:120,		summaryType: 'sum'/*,tdCls:'x-change-cell_color1'*/}
       	 			 ,{dataIndex:'CSTOCK',	    width:100}
       	 			 ,{text:'납품',
       	 			  columns:[
       	 			  	{dataIndex:'SALE_Q',	width:80,		summaryType: 'sum'},
       	 			  	{dataIndex:'SALE_O',	width:120,		summaryType: 'sum'}
       	 			  ]
       	 			 }
				]
	});
		Unilite.Main({
			items:[panelSearch,masterGrid],
			id : 'gba220skrvApp',
			fnInitBinding : function() {
    			UniAppManager.setToolbarButtons(['reset'],true);
    			panelSearch.getField('FR_DATE').setReadOnly(true);
    			panelSearch.getField('TO_DATE').setReadOnly(true);
            },
			onQueryButtonDown : function() {
				if(!panelSearch.getInvalidMessage()){
					return false;		
				};
				directMasterStore.loadStoreRecords();			
			},
			onResetButtonDown:function() {
                panelSearch.clearForm();
                masterGrid.reset();
                directMasterStore.clearData();
                this.fnInitBinding();
            }
		});
	}
</script>