<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//서비스 만족도 조회
request.setAttribute("PKGNAME","Unilite_app_gle100skrv");
%>
<t:appConfig pgmId="gle100skrv"  >
<t:ExtComboStore comboType="BOR120"/>
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	
	    fields: [
			{name: 'COMP_CODE'            	,text:'법인코드'	,type : 'string'},
			{name: 'DIV_CODE'            	,text:'사업장'	,type : 'string',comboType:'BOR120'},
			{name: 'RANK'            		,text:'순위'	,type : 'int'},
			{name: 'DRIVER_NAME'            ,text:'성명'	,type : 'string'},
			{name: 'SERVICE_EVALUATION'     ,text:'친절도'	,type : 'int'},
			{name: 'ROUTE_NUM'           	,text:'노선'	,type : 'string'},
			{name: 'REMARK'            		,text:'비고'		,type : 'string'}
		]
	});	
	var data = [ {'RANK' :1 , 'DRIVER_NAME':'한경수', 'SERVICE_EVALUATION': 62, 'ROUTE_NUM': '1'}
				,{'RANK' :2 , 'DRIVER_NAME':'황승호', 'SERVICE_EVALUATION': 60, 'ROUTE_NUM': '13'}
				,{'RANK' :3 , 'DRIVER_NAME':'한명희', 'SERVICE_EVALUATION': 57, 'ROUTE_NUM': '20-1'}
				,{'RANK' :4 , 'DRIVER_NAME':'정효근', 'SERVICE_EVALUATION': 53, 'ROUTE_NUM': '53'}
				,{'RANK' :5 , 'DRIVER_NAME':'이계응', 'SERVICE_EVALUATION': 49, 'ROUTE_NUM': '7-1'}
				,{'RANK' :6 , 'DRIVER_NAME':'박영수', 'SERVICE_EVALUATION': 48, 'ROUTE_NUM': '2-1'}
				,{'RANK' :7 , 'DRIVER_NAME':'김용식', 'SERVICE_EVALUATION': 46, 'ROUTE_NUM': '7-2'}
				,{'RANK' :8 , 'DRIVER_NAME':'김명섭', 'SERVICE_EVALUATION': 40, 'ROUTE_NUM': '11-1'}
				,{'RANK' :9 , 'DRIVER_NAME':'임정영', 'SERVICE_EVALUATION': 39, 'ROUTE_NUM': '13-1'}
				,{'RANK' :10 , 'DRIVER_NAME':'권인필', 'SERVICE_EVALUATION': 38, 'ROUTE_NUM': '85'}
	];
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            data: data,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '서비스만족도',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
        width: 330,
		items: [{	
			title: '검색조건', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',  
           	defaults:{
           		labelWidth:80
           	},
	    	items:[{
				fieldLabel: '사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
	        	fieldLabel: '조회월',
	        	xtype: 'uniMonthfield',
	        	name: 'S_MONTH', 
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('S_MONTH', newValue);
					}
				}
			    
			}]				
		}]
		
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
	        	fieldLabel: '조회월',
	        	xtype: 'uniMonthfield',
	        	name: 'S_MONTH', 
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('S_MONTH', newValue);
					}
				}
			    
			}]
	});
	
     var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
        layout : 'fit',        
    	region:'center',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: masterStore, 
		columns:[
			{dataIndex: 'RANK'			  		,width: 40},
			{dataIndex:'DRIVER_NAME'            ,width: 80 , align:'center'},
			{dataIndex:'SERVICE_EVALUATION'     ,width: 80},
			{dataIndex:'ROUTE_NUM'         		,width: 100, align:'center'},
			{dataIndex:'REMARK'         		,flex: 1}
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
		id  : 'gle100skrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
		},
		
		onQueryButtonDown : function()	{
			
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
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			this.fnInitBinding();
		}
	});

	
	
}; // main
  
</script>