<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa950ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="ZF01" />
	<t:ExtComboStore comboType="AU" comboCode="ZF02" />
	<t:ExtComboStore comboType="AU" comboCode="ZF03" />
	<t:ExtComboStore comboType="AU" comboCode="ZF04" />
	<t:ExtComboStore comboType="AU" comboCode="B007" />
	<t:ExtComboStore comboType="AU" comboCode="B009" />
</t:appConfig>
<script type="text/javascript">
var detailWin;
function appMain() {
	 
		Unilite.defineModel('bsa950ukrvModel', {
			fields : [ {name : 'PGM_ID'							,text: '프로그램ID'	,type : 'string'}
					 , {name : 'PGM_NAME'						,text: '프로그램명'	,type : 'string'}
					 , {name : 'UI_DESIGN_USER'					,text: '담당자'		,type : 'string'}
					 , {name : 'UI_DESIGN_PROCESS'				,text: '진행'		,type : 'string'}
					 , {name : 'UI_DESIGN_PLAN_START_DATE'		,text: '시작일'		,type : 'uniDate'}
					 , {name : 'PRESENTATION_USER'				,text: '담당자'		,type : 'string'}
					 , {name : 'PRESENTATION_PROCESS'			,text: '진행'		,type : 'string'}
					 , {name : 'PRESENTATION_START_DATE'		,text: '시작일'		,type : 'uniDate'}
					 , {name : 'PRESENTATION_LOGIC_USER'		,text: '담당자'		,type : 'string'}
					 , {name : 'PRESENTATION_LOGIC__PROCESS'	,text: '진행'		,type : 'string'}
					 , {name : 'PRESENTATION_LOGIC_START_DATE'	,text: '시작일'		,type : 'uniDate'}
					 , {name : 'DATA_LOGIC_USER'				,text: '담당자'		,type : 'string'}
					 , {name : 'DATA_LOGIC_PROCESS'				,text: '진행'		,type : 'string'}
					 , {name : 'DATA_LOGIC_PLAN_START_DATE'		,text: '시작일'		,type : 'uniDate'}
					 , {name : 'BUSINESS_LOGIC_USER'			,text: '담당자'		,type : 'string'}
					 , {name : 'BUSINESS_LOGIC_PROCESS'			,text: '진행'		,type : 'string'} 
					 , {name : 'BUSINESS_LOGIC_PLAN_START_DATE'	,text: '시작일'		,type : 'uniDate'} 
					 , {name : 'REPORT_USER'					,text: '담당자'		,type : 'string'} 
					 , {name : 'REPORT_PROCESS'					,text: '진행'		,type : 'string'}
					 , {name : 'REPORT_PLAN_START_DATE'			,text: '시작일'		,type : 'uniDate'}
					 , {name : 'TEST_USER'						,text: '담당자'		,type : 'string'}
					 , {name : 'TEST_PROCESS'					,text: '진행'		,type : 'string'}
					 , {name : 'TEST_PLAN_START_DATE'			,text: '시작일'		,type : 'uniDate'}
					]
		});

		var directMasterStore = Unilite.createStore('bsa950ukrvMasterStore', { 
			model : 'bsa950ukrvModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : {
				type : 'direct',
				api : {
					read : 	 'bsa950ukrvService.selectMasterList'
				}
			}
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();	
				this.load({
					params : param
				});
			}
		});										

		Unilite.defineModel('bsa950ukrvDetailModel', {
			fields : [ 	  
				  {name : 'PGM_ID'				,text: '프로그램ID'		,type : 'string', editable:false}
			 	, {name : 'PGM_NAME'			,text: '프로그램명'		,type : 'string', editable:false}
			 	, {name : 'STEP_CODE'			,text: '진행단계'		,type : 'string', comboType:'AU', comboCode:'ZF01', editable:false}
			 	, {name : 'USER_CODE'			,text: '진행담당'		,type : 'string', comboType:'AU', comboCode:'ZF02'}
			 	, {name : 'PROCESS_CODE'		,text: '진행상태'		,type : 'string', comboType:'AU', comboCode:'ZF03'}
			 	, {name : 'PLAN_START_DATE'		,text: '계획시작일'		,type : 'uniDate'}
			 	, {name : 'PLAN_END_DATE'		,text: '계획종료일'		,type : 'uniDate'}
			 	, {name : 'ACTION_START_DATE'	,text: '실행시작일'		,type : 'uniDate'}
				, {name : 'ACTION_END_DATE'		,text: '실행종료일'		,type : 'uniDate'}
				, {name : 'REMARK'				,text: '<t:message code="system.label.base.remarks" default="비고"/>'			,type : 'string'}
				, {name : 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type : 'string', editable:false}
			]
		});

		var directDetailStore = Unilite.createStore('directDetailStore', { 
			model : 'bsa950ukrvDetailModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
			proxy : {
				type : 'direct',
				api : {
					read : 'bsa950ukrvService.selectDetailList',
					update : 'bsa950ukrvService.update',
					syncAll: 'bsa950ukrvService.syncAll'
				}
			},
			loadStoreRecords : function(pgmId)	{
				
				var param= Ext.getCmp('searchForm').getValues();	
				this.load({
					params : param
				});
			},
			saveStore : function()	{
					var inValidRecs = this.getInvalidRecords();
					if(inValidRecs.length == 0 )	{
						this.syncAll({success : function()	{
													directMasterStore.loadStoreRecords();
												}
											});	
					}else {
						var grid = Ext.getCmp('bsa950ukrvDetailGrid');
						grid.uniSelectInvalidColumn(inValidRecs);
					}
			}
			
		});
		
		// create the Grid
		var masterGrid = Unilite.createGrid('bsa950ukrvGrid', {
			region: 'north',
			enableColumnMove: false,
			store: directMasterStore,
			uniOpt:{
				useRowNumberer: false,
	        	expandLastColumn: false
	        },
	        flex:0.5,
			columns : [ {dataIndex : 'PGM_ID'				,width: 80 },
					    {dataIndex : 'PGM_NAME'			,width: 150	},
						{
							text : 'UI Design',
							columns:[
								  {dataIndex : 'UI_DESIGN_USER'				,width : 75		}
								, {dataIndex : 'UI_DESIGN_PROCESS'			,width : 70		}
								, {dataIndex : 'UI_DESIGN_PLAN_START_DATE'	,width : 70		}
							]
						},{
							text : 'Presentation',
							columns:[
								  {dataIndex : 'PRESENTATION_USER'			,width : 75		}
								, {dataIndex : 'PRESENTATION_PROCESS'		,width : 70		}
								, {dataIndex : 'PRESENTATION_START_DATE'	,width : 70		}
							]
						},{
							text : 'Presentation Logic',
							columns:[
								  {dataIndex : 'DATA_LOGIC_USER'			,width : 75		}
								, {dataIndex : 'DATA_LOGIC_PROCESS'			,width : 70		}
								, {dataIndex : 'DATA_LOGIC_PLAN_START_DATE'	,width : 70		}
							]
						},{
							text : 'Data Logic',
							columns:[
								  {dataIndex : 'BUSINESS_LOGIC_USER'			,width : 75		}
								, {dataIndex : 'BUSINESS_LOGIC_PROCESS'			,width : 70		}
								, {dataIndex : 'BUSINESS_LOGIC_PLAN_START_DATE'	,width : 70		}
							]
						},{
							text : 'Business Logic',
							columns:[
								  {dataIndex : 'REPORT_USER'			,width : 75		}
								, {dataIndex : 'REPORT_PROCESS'			,width : 70		}
								, {dataIndex : 'REPORT_PLAN_START_DATE'	,width : 70		}
							]
						}
					],
				listeners:{
	    		selectionChange: function( gird, selected, eOpts )	{	    				
	    			if(selected.length == 1)	{
	    				var dataMap = selected[0].data;
	    				var idx = detailGrid.getStore().find('PGM_ID', dataMap['PGM_ID']);
	    				var sm = detailGrid.getSelectionModel();
	    				sm.deselect(sm.getSelection());
	    				if(idx >= 0)	{
	    					sm.select(idx);
	    					//detailGrid.moveTo(idx,0);
	    				}
	    			}
	    		}
    	}
		});
		
		var detailGrid =  Unilite.createGrid('bsa950ukrvDetailGrid', {
			region: 'center',
			store : directDetailStore,
			uniOpt:{
				useRowNumberer: false,
	        	expandLastColumn: false,
	        	onLoadSelectFirst: true
	        },
	        flex:0.5,
			columns : [   
				{dataIndex : 'PGM_ID'				,width: 100 },
				{dataIndex : 'PGM_NAME'			,width: 150	},
				{dataIndex : 'STEP_CODE'			,width: 150	},
				{dataIndex : 'USER_CODE'			,width: 120	},
				{dataIndex : 'PROCESS_CODE'		,width: 100	},
				{dataIndex : 'PLAN_START_DATE'	,width: 100	},
				{dataIndex : 'PLAN_END_DATE'		,width: 100	},
				{dataIndex : 'ACTION_START_DATE'	,width: 100	},
				{dataIndex : 'ACTION_END_DATE'	,width: 100	},
				{dataIndex : 'REMARK'			,flex: 1}
			],
    	listeners:{
    		selectionChange: function( gird, selected, eOpts )	{
    			detailForm.setActiveRecord(selected[0]||null);
    			detailFormWin.setActiveRecord(selected[0]||null);
    		},
			celldblclick: function( grid, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var clickedDataIndex = grid.panel.headerCt.getHeaderAtIndex(cellIndex).dataIndex;
				if(clickedDataIndex =='REMARK')	{
			    	openRemarkWin(record);
				}
			},
			edit: function(editor, context, eOpts) {
				detailForm.setActiveRecord(context.record);
    			detailFormWin.setActiveRecord(context.record);
			}
		 }
		});
	
		var panelSearch = Unilite.createSearchPanel('searchForm',{
			title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
			defaultType: 'uniSearchSubPanel',
			items: [{	
				title: '공통조건', 	
	   			itemId: 'search_panel1',
	           	layout: {type: 'uniTable', columns: 1},
	           	defaultType: 'uniTextfield',   
	           	defaults: {
	           		width: 315
	           	},
		    	items:[{
		    			fieldLabel : '모듈'		,
		    			name : 'PGM_SEQ',          
						xtype: 'uniCombobox', 
		    			comboType:'AU', 
		    			comboCode:'B007'
		    			
		    		}, {
		    			fieldLabel : '개발순위'		,
		    			name : 'DEV_PRIORITY',          
						xtype: 'uniCombobox', 
		    			comboType:'AU', 
		    			comboCode:'ZF04'
		    			
		    		}, {
		    			fieldLabel : '프로그램유형'		,
		    			name : 'PGM_TYPE',          
						xtype: 'uniCombobox', 
		    			comboType:'AU', 
		    			comboCode:'B009'
		    		},  
		    		{
		    			fieldLabel : '프로그램ID'	,
		    			name : 'PGM_ID'
		    		},{
		    			fieldLabel : '프로그램명'	,
		    			name : 'PGM_NAME' 
		    		}
				]
			 },{	
				title: '목록조건', 	
	   			itemId: 'search_panel2',
	           	layout: {type: 'uniTable', columns: 1},
	           	defaultType: 'uniTextfield', 
	           	defaults: {
	           		width: 315
	           	},
		    	items:[{
		    			fieldLabel : '진행단계'		,
		    			name : 'STEP_CODE',          
						xtype: 'uniCombobox', 
		    			comboType:'AU', 
		    			comboCode:'ZF01',
						multiSelect: true,
						typeAhead: false
		    			
		    		}, {
		    			fieldLabel : '진행담당'		,
		    			name : 'USER_CODE',          
						xtype: 'uniCombobox', 
		    			comboType:'AU', 
		    			comboCode:'ZF02'
		    		}, {
		    			fieldLabel : '진행상태'		,
		    			name : 'PROCESS_CODE',          
						xtype: 'uniCombobox', 
		    			comboType:'AU', 
		    			comboCode:'ZF03',
						multiSelect: true,
						typeAhead: false
		    		}, {	    
						fieldLabel: '계획시작일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'PLAN_START_DATE_FR',
			            endFieldName: 'PLAN_START_DATE_TO'
					},
					{	    
						fieldLabel: '계획종료일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'PLAN_END_DATE_FR',
			            endFieldName: 'PLAN_END_DATE_TO'
					},
					{	    
						fieldLabel: '실행시작일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ACTION_START_DATE_FR',
			            endFieldName: 'ACTION_START_DATE_TO'
					},
					{	    
						fieldLabel: '실행종료일',
						xtype: 'uniDateRangefield',
			            startFieldName: 'ACTION_END_DATE_FR',
			            endFieldName: 'ACTION_END_DATE_TO'
					}]
		    	},{	
					title: '조회방법', 	
		   			itemId: 'search_panel3',
		           	layout: {type: 'uniTable', columns: 1},
		           	defaults: {
		           		width: 350
		           	},
			    	items:[ {
					    xtype: 'container',
					    autoEl: 'div',
					    defaults:{
					    	margin: '3 0 0 5'
					    },
					    items: [
					    	{
					        	xtype: 'component',
					        	autoEl: 'div',
					        	html: '<strong>1. 설계담당</strong><br/>'+
									'&nbsp;&nbsp;&nbsp;&nbsp;진행담당에서 본인선택, 진행단계에서 화면설계, 쿼리<br/>&nbsp;&nbsp;&nbsp;&nbsp;개발 선택'
					    	},{
					        	xtype: 'component',
					        	autoEl: 'div',
					        	html: '<strong>2. 개발담당</strong><br/>'+
									 '&nbsp;&nbsp;&nbsp;&nbsp;진행담당에서 본인선택, 진행상태에서 할당,진행 선택<br/>'
					    	},{
					        	xtype: 'component',
					        	autoEl: 'div',
					        	html: '<strong>3. 1차테스트 담당</strong><br/>'+
									   '&nbsp;&nbsp;&nbsp;&nbsp;진행단계에서 업무로직 선택, 진행상태에서 완료 선택<br/>'
					    	},{
					        	xtype: 'component',
					        	autoEl: 'div',
					        	html: '<strong>4. 최종테스트 담당</strong><br/>'+
									  '&nbsp;&nbsp;&nbsp;&nbsp;진행단계에서 테스트 선택, 진행상태에서 완료 선택'
					    	}
					    ]
			    	}]
			    
		    	}
		    ]
		});
	var detailForm = Unilite.createForm('bsa950ukrvDetailForm',  {	
			region: 'south',
	        itemId: 'bsa950ukrvDetailForm',
			masterGrid: detailGrid,
			height: 105,
			disabled: false,
			border: true,
			padding: 0,
			layout: {
				type: 'hbox', 
				align:'stretch'
			},
			items: [
				{hidLabel:true, xtype:'textareafield', name:'REMARK', flex:1}
			]	
		});
	var detailFormWin = Unilite.createForm('bsa950ukrvDetailFormWin',  {	
	        itemId: 'bsa950ukrvDetailFormWin',
			masterGrid: detailGrid,
			disabled: false,
			border: true,
			padding: 0,
			layout: {
				type: 'hbox', 
				align:'stretch'
			},
			items: [
				{hidLabel:true, xtype:'textareafield', name:'REMARK', flex:1}
			]	
		});
	
	function openRemarkWin(record)	{		
		
		detailFormWin.setActiveRecord(record || null);
		
		if(!detailWin) {
			detailWin = Ext.create('widget.window', {
                title: '<t:message code="system.label.base.remarks" default="비고"/>',
                width: 810,				                
                height: 500,
				layout: 'fit',
				closable : false,
				modal : true,
                items: [detailFormWin],
                tbar: [ '->',{ 
                	xtype: 'button', 
	                text: '닫기' ,
	                handler: function()	{
	                	detailWin.hide();
	                }
	            }]
			})
		}
		detailWin.show();
	}
	var gridContainer = {
		xtype:'panel',
		region:'center',
		layout:{
			type:'border'
		},
		items:[
			masterGrid,
			detailGrid,
			detailForm
		]
	}
		
    Unilite.Main({
			borderItems:[ 
			panelSearch,
			gridContainer
	  	]
			,fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
			}
			, onQueryButtonDown:function() {
				masterGrid.getStore().loadStoreRecords();
				detailGrid.getStore().loadStoreRecords();
			}
			, onNewDataButtonDown : function()	{
				
			}
			, onSaveDataButtonDown: function () {										
				if(directDetailStore.isDirty())	{
					directDetailStore.saveStore();						
				}
			},
			onResetButtonDown:function() {
				masterGrid.reset();						
				detailGrid.reset();
				detailForm.clearForm();	
				panelSearch.clearForm();	
				UniAppManager.setToolbarButtons(['save'],false);
			}
			, onDeleteDataButtonDown : function()	{
					
			}	
		});
		
		
		var activeGridId = 'bsa950ukrvGrid';

};	// appMain
</script>