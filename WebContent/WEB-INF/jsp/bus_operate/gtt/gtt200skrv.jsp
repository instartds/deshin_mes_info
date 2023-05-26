<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//일일근태내역 조회(정비직)
request.setAttribute("PKGNAME","Unilite_app_gtt200skrv");
%>
<t:appConfig pgmId="gtt200skrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	--> 	
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>					<!-- 영업소     -->
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
					,{name: 'PERSON_NUMB'    		,text:'사원코드'		,type : 'string'  } 
					,{name: 'NAME'    				,text:'사원명'			,type : 'string'  } 
					,{name: 'ATT_DATE'    			,text:'근무일'			,type : 'uniDate' } 
					,{name: 'IN_TIME'    			,text:'출근시각'		,type : 'string'  } 
					,{name: 'FP_IN_TIME'    		,text:'지문출근'		,type : 'string'  } 
					,{name: 'CARD_IN_TIME'    		,text:'카드출근'		,type : 'string'  } 
					,{name: 'OUT_TIME'    			,text:'퇴근시각'		,type : 'string'  } 
					,{name: 'FP_OUT_TIME'    		,text:'지문퇴근'		,type : 'string'  } 
					,{name: 'CARD_OUT_TIME'    		,text:'카드퇴근'		,type : 'string'  }
					,{name: 'DATE_CNT'    			,text:'근무일수'		,type : 'uniQty'  }
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'  } 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string'  ,defaultValue: UserInfo.compCode} 
					
					,{name: 'TAG_CNT'   			,text:'정상근태'		,type : 'uniQty'  	  }
					,{name: 'NO_TAG_CNT'   			,text:'비정상근태'		,type : 'uniQty'  	  }	
					,{name: 'TAG_IN_CNT'   			,text:'출근등록'		,type : 'uniQty'  	  }						
					,{name: 'NO_TAG_IN_CNT'   		,text:'출근미등록'		,type : 'uniQty'  	  }	
					,{name: 'TAG_OUT_CNT'   		,text:'퇴근등록'		,type : 'uniQty'  	  }	
					,{name: 'NO_TAG_OUT_CNT'   		,text:'퇴근미등록'		,type : 'uniQty'  	  }	
					
			]
	});

	var masterStore =  Unilite.createStore('${PKGNAME}store',{
         model: '${PKGNAME}model',
         groupField: 'ATT_DATE',
         autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'gtt200skrvService.selectList'
                }
            },
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			},
            listeners:{
            	load:function(store, records, successful, eOpts)	{
            		if(successful)	{
            			if(records.length > 0)
            			summaryStore.loadData([records[0]]);
            		}
            	}
            }
		});
	
 	Unilite.defineModel('${PKGNAME}SummaryModel', {
	    fields: [
					 {name: 'TAG_CNT'   			,text:'정상등록'		,type : 'uniQty'  	  }
					,{name: 'NO_TAG_CNT'   			,text:'비정상등록'		,type : 'uniQty'  	  }	
					,{name: 'TAG_IN_CNT'   			,text:'출근등록수'		,type : 'uniQty'  	  }	
					,{name: 'NO_TAG_IN_CNT'   		,text:'출근미등록'		,type : 'uniQty'  	  }	
					,{name: 'TAG_OUT_CNT'   		,text:'퇴근등록수'		,type : 'uniQty'  	  }	
					,{name: 'NO_TAG_OUT_CNT'   		,text:'퇴근미등록'		,type : 'uniQty'  	  }	
		]
	});
	
	var summaryStore =  Ext.create('Ext.data.Store', {
        model: '${PKGNAME}SummaryModel',   
        data : [
     		{'TAG_CNT': 0,    'NO_TAG_CNT': 0,    'TAG_IN_CNT': 0,    'NO_TAG_IN_CNT': 0,    'TAG_OUT_CNT': 0,    'NO_TAG_OUT_CNT': 0}
     	]
	});	
		
	var masterView = Ext.create('Ext.view.View', {
		tpl: [
			'<div class="summary-source"  style="padding: 0 !important;border: 0 !important;overflow:hidden">' ,
			'<table cellpadding="5" cellspacing="0" border="0" width="315"  align="center" style="border:1px solid #cccccc;margin-top:5px;">' ,
			'<tpl for=".">' ,
			
		    '<tr class="x-grid-row x-grid-with-row-lines">' ,
			'	<td style="text-align: right;"  class="bus_gray-label">정상근태</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{TAG_CNT} 명</td>',
			'	<td style="text-align: right;"  class="bus_gray-label">비정상근태</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{NO_TAG_CNT} 명</td>',
			'</tr>' ,
			'<tr class="x-grid-row x-grid-with-row-lines">' ,
			'	<td style="text-align: right;"  class="bus_gray-label">출근등록</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{TAG_IN_CNT} 명</td>',
			'	<td style="text-align: right;"  class="bus_gray-label">출근미등록</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{NO_TAG_IN_CNT} 명</td>',
			'</tr>' ,
			'<tr class="x-grid-row x-grid-with-row-lines">' ,
			'	<td style="text-align: right;"  class="bus_gray-label">퇴근등록</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{TAG_OUT_CNT} 명</td>',
			'	<td style="text-align: right;"  class="bus_gray-label">퇴근미등록</td>' ,
			'	<td style="text-align: right;"  class="bus_white-label" style="padding-right:10px;">{NO_TAG_OUT_CNT} 명</td>',
			'</tr>' ,			
			'</tpl>' ,
			'</table><div>'
		],
		border:false,
		autoScroll:false,
		itemSelector: 'div.summary-source',
        store: summaryStore
	});

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '정비사정보',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        width: 330,
		items: [{	
					title: '검색조건', 	
					id: 'search_panel1',
		   			itemId: 'search_panel1',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode,
						allowBlank:false
					},{	    
						fieldLabel: '사원코드',
						name: 'PERSON_NUMB'	
					},{	    
						fieldLabel: '사원명',
						name: 'NAME'	
					},{	    
						fieldLabel: '영업소',
						name: 'OFFICE_CODE'	,
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'GO01'
					},{	    
						fieldLabel: '근무일',
						name: 'ATT_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ATT_DATE_FR',
			            endFieldName: 'ATT_DATE_TO',	
			            startDate: UniDate.today(),
			            endDate: UniDate.today(),
			            width:320,
						allowBlank:false,
						height:22
					}
					]				
				},
				{	
					title: '요약정보', 	
					id: 'search_panel2',
		   			itemId: 'search_panel2',
		           	layout: {type: 'uniTable', columns: 1, tableAttrs:{'align':'center'} },		           
			    	items:[masterView]
				},{	
					title: '일근태 집계 작업',
		   			itemId: 'search_panel3',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaultType: 'uniTextfield',  
		           	defaults:{
		           		labelWidth:90
		           	},
			    	items:[{	    
						fieldLabel: '사업장',
						name: 'B_DIV_CODE',
						xtype:'uniCombobox',
						comboType:'BOR120',
						value: UserInfo.divCode
					},{	    
						fieldLabel: '집계기간',
						name: 'B_ATT_DATE',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ATT_START_DATE',
			            endFieldName: 'ATT_END_DATE',	
			            startDate: UniDate.today(),
			            endDate: UniDate.today(),
			            width:320,
						height:22
					},{	    
						xtype:'button',
			        	text:'실행',
			        	width: 300,
			        	tdAttrs:{'align':'center'},
			        	handler: function()	{
			        		var sForm = Ext.getCmp('${PKGNAME}searchForm');
			        		
			        		if(Ext.isEmpty(sForm.getValue('B_DIV_CODE')) )	{
			        			alert("사업장은 필수입력입니다.");
			        			sForm.getField("B_DIV_CODE").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('ATT_START_DATE')))	{
			        			alert("집계기간은 필수입력입니다.");
			        			sForm.getField("ATT_START_DATE").focus();
			        			return;
			        		}
			        		if(Ext.isEmpty(sForm.getValue('ATT_END_DATE')))	{
			        			alert("집계기간은 필수입력입니다.");
			        			sForm.getField("ATT_END_DATE").focus();
			        			return;
			        		}
			        		
			        		var params = sForm.getValues();
			        		Ext.getBody().mask();
			        		gtt200skrvService.summary(params, function(provider, response)	{
			        			console.log("response", response);
			        			console.log("provider", provider);
			        			if(provider!= null && provider.ErrorDesc == '')	{
			        				alert("일근태 집계가 완료되었습니다.");
			        			}
			        			Ext.getBody().unmask();
			        		})
			        	}
					}					
					]				
				}
				]

	});	//end panelSearch    
	
     var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
        layout : 'fit',        
    	region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore,
		columns:[
			{dataIndex:'DIV_CODE'			,width: 100, hidden:true},
			{dataIndex:'ATT_DATE'		,width: 80 ,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	        },
			
			{dataIndex:'PERSON_NUMB'		,width: 70},
			{dataIndex:'NAME'		,width: 70, summaryType:'count',
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	var me = this;
                  	var rv = '<div align="right">'+value+'</div>';
                	return rv;
                }
	        },
			{dataIndex:'IN_TIME'			,width: 80		,align:'center', 
			 summaryType:function(values)	{
			 	var sumData = 0;
			 	var lateData=0;
			 	
			 	Ext.each(values, function(value, index){
			 							sumData = Ext.isEmpty(value.get('IN_TIME')) ? sumData : sumData+1;
			 						});			 	
			 	return sumData;
			 },
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	var me = this;
                  	var rv = '<div align="right">'+value+'</div>';
                	return rv;
                }
			},
			{dataIndex:'FP_IN_TIME'			,width: 80		,align:'center'},
			{dataIndex:'CARD_IN_TIME'		,width: 80		,align:'center'},
			{dataIndex:'OUT_TIME'			,width: 80		,align:'center', 
			 summaryType:function(values)	{
			 	var sumData = 0;
			 	var earlyData=0;
			 	
			 	Ext.each(values, function(value, index){
			 							sumData = Ext.isEmpty(value.get('OUT_TIME')) ? sumData : sumData+1;
			 						});			 	
			 	return sumData;
			 },
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              	var me = this;
                  	var rv = '<div align="right">'+value+'</div>';
                	return rv;
             }
			},
			{dataIndex:'FP_OUT_TIME'		,width: 80		,align:'center'},
			{dataIndex:'CARD_OUT_TIME'		,width: 80		,align:'center'},
			{dataIndex:'DATE_CNT'			,width: 80		,summaryType:'sum'},
			{dataIndex:'REMARK'				,flex: 1}
		] 
   });

      Unilite.Main({
		borderItems:[
	 		  panelSearch
	 		 ,masterGrid
		],
		id  : '${PKGNAME}ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['print', 'newData'], false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ], true);
			if(params) {
				if(!Ext.isEmpty(params.DIV_CODE))	{
					var sfrm = Ext.getCmp('${PKGNAME}searchForm');
					sfrm.setValue('DIV_CODE',params.DIV_CODE);
					sfrm.setValue('ATT_DATE_FR',params.ATT_DATE_FR);
					sfrm.setValue('ATT_DATE_TO',params.ATT_DATE_TO);
					masterStore.loadStoreRecords();
				}
			}
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{
			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
		},
		onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}
	});
	
}; // main
  
</script>