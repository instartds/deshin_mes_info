<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//C1 노선별 차량현황
request.setAttribute("PKGNAME","Unilite_app_gev120skrv");
%>
<t:appConfig pgmId="gev120skrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	--> 
	<t:ExtComboStore comboType="AU" comboCode="GO10"/>				<!-- 운행구분  	-->
	<t:ExtComboStore comboType="AU" comboCode="GO11"/>				<!-- 노선구분  	-->
</t:appConfig>
<script type="text/javascript">
function appMain() {

	Unilite.defineModel('${PKGNAME}model', {
	    fields: [
					 {name: 'DIV_CODE'   			,text:'사업장'			,type : 'string'  ,comboType: 'BOR120' ,defaultValue: UserInfo.divCode} 
					,{name: 'SEQ'    				,text:'연번'			,type : 'string'  } 
					,{name: 'ROUTE_NUM'    			,text:'노선번호(B+NM)'	,type : 'string'  } 
					,{name: 'ROUTE_CODE'    		,text:'노선번호(ID)'	,type : 'string'  } 
					,{name: 'OPERATION_TYPE'    	,text:'유형구분'		,type : 'string'  ,comboType: 'AU',	comboCode: 'GO10'}					
					,{name: 'ROUTE_TYPE'   			,text:'노선구분'		,type : 'string'  ,comboType: 'AU',	comboCode: 'GO11'}	
					
					//보유대수
					,{name: 'O_TEMPN_01'    		,text:'경유일반'		,type : 'uniQty'  } 
					,{name: 'O_TEMPN_02'    		,text:'CNG일반'			,type : 'uniQty'  } 
					,{name: 'O_TEMPN_03'   			,text:'CNG저상'			,type : 'uniQty'  } 
					//가동대수
					,{name: 'R_TEMPN_01'    		,text:'경유일반'		,type : 'uniQty'  } 
					,{name: 'R_TEMPN_02'    		,text:'CNG일반'			,type : 'uniQty'  } 
					,{name: 'R_TEMPN_03'   			,text:'CNG저상'			,type : 'uniQty'  } 
					//예비차량
					,{name: 'T_TEMPN_01'    		,text:'경유일반'		,type : 'uniQty'  } 
					,{name: 'T_TEMPN_02'    		,text:'CNG일반'			,type : 'uniQty'  } 
					,{name: 'T_TEMPN_03'   			,text:'CNG저상'			,type : 'uniQty'  } 
					
					,{name: 'REMARK'  				,text:'비고'			,type : 'string'  } 
					,{name: 'COMP_CODE'  			,text:'법인코드'		,type : 'string' ,defaultValue: UserInfo.compCode} 
			]
	});
	
	var masterStore =  Unilite.createStore('${PKGNAME}store',{
        model: '${PKGNAME}model',
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
                	   read : 'gev120skrvService.selectList'
                }
            } ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}searchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});

	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '노선별 차량현황',
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
			            xtype: 'uniYearField',
			            name: 'S_YEAR',
			            fieldLabel: '기준년도',
			            value: new Date().getFullYear()-1
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
    	store: masterStore,
    	features: [ {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ], 
		columns:[
			{dataIndex:'SEQ'				,width: 40,
			 summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
	                    }
	        },
	        {dataIndex:'ROUTE_NUM'			,width: 100 ,summaryType:'count'},
			{dataIndex:'ROUTE_CODE'			,width: 80 },
			{dataIndex:'OPERATION_TYPE'		,width: 110 },
			{dataIndex:'ROUTE_TYPE'			,width: 110 },
			{text:'보유대수(a+b)',
			 columns:[
				{dataIndex:'O_TEMPN_01'		,width: 80 ,summaryType:'sum'},
				{dataIndex:'O_TEMPN_02'		,width: 80 ,summaryType:'sum'},
				{dataIndex:'O_TEMPN_03'		,width: 80 ,summaryType:'sum'}
			 ]
			},
			{text:'가동대수(a)',
			 columns:[
				{dataIndex:'R_TEMPN_01'		,width: 80 ,summaryType:'sum'},
				{dataIndex:'R_TEMPN_02'		,width: 80 ,summaryType:'sum'},
				{dataIndex:'R_TEMPN_03'		,width: 80 ,summaryType:'sum'}
			 ]
			},
			{text:'예비차량(b)',
			 columns:[
				{dataIndex:'T_TEMPN_01'		,width: 80 ,summaryType:'sum'},
				{dataIndex:'T_TEMPN_02'		,width: 80 ,summaryType:'sum'},
				{dataIndex:'T_TEMPN_03'		,width: 80 ,summaryType:'sum'}
			 ]
			}
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