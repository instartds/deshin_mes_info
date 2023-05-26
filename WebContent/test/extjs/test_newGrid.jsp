<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<t:appConfig pgmId="ssa450skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->    
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
	
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/MultiGroupingSummary.js" />' ></script>
	
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	    			
	Unilite.defineModel('Ssa450skrvModel1', {
	    fields: [    {name: 'SALE_CUSTOM_CODE'	        	,text:'거래처코드'		,type:'string'}
	    			,{name: 'SALE_CUSTOM_NAME'				,text:'거래처명'		,type:'string'}
	    			,{name: 'BILL_TYPE'						,text:'부가세유형'		,type:'string', comboType:"AU", comboCode:"S024"}
	    			,{name: 'SALE_DATE'						,text:'매출일'		,type:'uniDate'}
	    			,{name: 'INOUT_TYPE_DETAIL'	        	,text:'출고유형'		,type:'string',comboType:"AU", comboCode:"S007"}	    			
	    			,{name: 'ITEM_CODE'						,text:'품목코드'		,type:'string'}
	    			,{name: 'ITEM_NAME'						,text:'품명'			,type:'string'}
	    			,{name: 'CREATE_LOC'					,text:'생성경로'		,type:'string',comboType:"AU", comboCode:"B031"}
	    			,{name: 'SPEC'							,text:'규격'			,type:'string'}
	    			,{name: 'SALE_UNIT'						,text:'단위'			,type:'string'}
	    			,{name: 'PRICE_TYPE'					,text:'단가구분'		,type:'string'}
	    			,{name: 'TRANS_RATE'					,text:'입수'			,type:'string'}
	    			,{name: 'SALE_Q'						,text:'매출량'		,type:'uniQty'}
	    			,{name: 'SALE_WGT_Q'					,text:'매출량(중량)'	,type:'float'}
	    			,{name: 'SALE_VOL_Q'					,text:'매출량(부피)'	,type:'string'}	    			
	    			,{name: 'CUSTOM_CODE'					,text:'수주거래처'		,type:'string'}
	    			,{name: 'CUSTOM_NAME'					,text:'수주거래처명'	,type:'string'}	    					
	    			,{name: 'SALE_P'						,text:'단가'			,type:'uniPrice'}
	    			,{name: 'SALE_FOR_WGT_P'				,text:'단가(중량)'		,type:'float'}	    			
	    			,{name: 'SALE_FOR_VOL_P'				,text:'단가(부피)'		,type:'string'}    			
	    			,{name: 'MONEY_UNIT'					,text:'화폐'			,type:'string'}
	    			,{name: 'EXCHG_RATE_O'					,text:'환율'			,type:'uniER'}
	    			,{name: 'SALE_LOC_AMT_F'				,text:'매출액(외화)'	,type:'uniPrice'}
	    			,{name: 'SALE_LOC_AMT_I'				,text:'매출액'		,type:'uniPrice'}
	    			,{name: 'TAX_TYPE'						,text:'과세여부'		,type:'string', comboType:"AU", comboCode:"B059"}
	    			,{name: 'TAX_AMT_O'						,text:'세액'			,type:'uniPrice'}
	    			,{name: 'SUM_SALE_AMT'					,text:'매출계'		,type:'uniPrice'}    			
	    			,{name: 'ORDER_TYPE'					,text:'판매유형'		,type:'string',comboType:"AU", comboCode:"S002"}
	    			,{name: 'DIV_CODE'						,text:'사업장'		,type:'string',comboType:"BOR120"}
	    			,{name: 'SALE_PRSN'						,text:'영업담당'		,type:'string',comboType:"AU", comboCode:"S010"}
	    			,{name: 'MANAGE_CUSTOM'					,text:'집계거래처'		,type:'string'}
	    			,{name: 'MANAGE_CUSTOM_NM'				,text:'집계거래처명'	,type:'string'}
	    			,{name: 'AREA_TYPE'						,text:'지역'			,type:'string',comboType:"AU", comboCode:"B056"}
	    			,{name: 'AGENT_TYPE'					,text:'거래처분류'		,type:'string',comboType:"AU", comboCode:"B055"}	    			
	    			,{name: 'PROJECT_NO'					,text:'관리번호'		,type:'string'}
	    			,{name: 'PUB_NUM'						,text:'계산서번호'		,type:'string'}
	    			,{name: 'EX_NUM'						,text:'전표번호'		,type:'string'}
	    			,{name: 'BILL_NUM'						,text:'매출번호'		,type:'string'}
	    			,{name: 'ORDER_NUM'						,text:'수주번호'		,type:'string'}
	    			,{name: 'DISCOUNT_RATE'					,text:'할인율(%)'		,type:'float'}	    			
	    			,{name: 'PRICE_YN'						,text:'단가구분'		,type:'string', comboType:"AU", comboCode:"S003"}
	    			,{name: 'WGT_UNIT'						,text:'중량단위'		,type:'string'}
	    			,{name: 'UNIT_WGT'						,text:'단위중량'		,type:'string'}
	    			,{name: 'VOL_UNIT'						,text:'부피단위'		,type:'string'}
	    			,{name: 'UNIT_VOL'						,text:'단위부피'		,type:'string'}
	    			,{name: 'COMP_CODE'						,text:'법인코드'		,type:'string'}
	    			,{name: 'BILL_SEQ'						,text:'계산서 순번'		,type:'string'}
	    			
	    			
	    			
	    			
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa450skrvMasterStore1',{
			model: 'Ssa450skrvModel1',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'ssa450skrvService.selectList1'                	
                }
            },
            //groupField: 'SALE_CUSTOM_NAME',
			groupers: ['SALE_CUSTOM_NAME'
			, 'ITEM_NAME'
			],
			
			loadStoreRecords : function()	{							
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
	});
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm',{
		
					region:'west',
	            	layout : {type : 'vbox', align : 'stretch'},
	            	items : [{	xtype:'container',
	            				layout : {type : 'uniTable', columns : 3},
	            			 	items:[ {fieldLabel: '사업장'		,name:'DIV_CODE', xtype: 'uniCombobox', comboType:'BOR120', allowBlank:false }
	            			 		   , Unilite.popup('CUST',{ fieldLabel: '거래처', textFieldWidth:170, validateBlank:false,  id:'bpr400ukrvCustPopup'
	            			 		   							, extParam:{'CUSTOM_TYPE':'3'}, colspan:2, valueFieldName: 'SALE_CUSTOM_CODE', textFieldName:'SALE_CUSTOM_NAME'})	
					            	   ,{fieldLabel: '영업담당'	,name:'SALE_PRSN', xtype: 'uniCombobox', comboType:'AU',comboCode:'S010'}
					            	   , Unilite.popup('ITEM', { fieldLabel: '품목코드', textFieldWidth:170, validateBlank:false})
					            	   ,{xtype:'uniTextfield',name:'PROJECT_NO', fieldLabel:'관리번호'}
					            	   ,{ fieldLabel: '품목계정',name:'ITEM_ACCOUNT', xtype: 'uniCombobox', comboType:'AU',comboCode:'B020'}
            			 		       ,{ fieldLabel: '매출일'
            			 		       ,width:315
						               ,xtype: 'uniDateRangefield'
						               ,startFieldName: 'SALE_FR_DATE'
						               ,endFieldName: 'SALE_TO_DATE'
						               ,startDate: UniDate.get('startOfMonth')
						               ,endDate: UniDate.get('today')
						               
						            	 }
						               ,{
						            		xtype: 'radiogroup',
						            		fieldLabel: '매출기표유무',
						            		id: 'rdoSelect1',
						            		items : [{boxLabel  : '전체', width:50 ,name: 'SALE_YN', inputValue: 'A', checked: true  }
						                    		,{boxLabel  : '기표', width:50 ,name: 'SALE_YN' , inputValue: 'Y'}
						                    		,{boxLabel  : '미기표', width:70 ,name: 'SALE_YN' , inputValue: 'N'}						                    		
						                    		]}  	 
					            	   ,{fieldLabel: '생성경로',name:'TXT_CREATE_LOC', xtype: 'uniCombobox', comboType:'AU',comboCode:'B031'} 
					            	   ,{fieldLabel: '부가세유형',name:'BILL_TYPE', xtype: 'uniCombobox', comboType:'AU',comboCode:'S024'}					            	   
					            	   ,{fieldLabel: 'activeTab', name:'ACTIVE_TAB', hidden:false, xtype:'hiddenfield'}
	            			 	    ]	
	            			 },
	            			 {
	            			 	 xtype: 'container',
	            			     defaultType: 'uniTextfield',
	            			 	 layout: {type: 'uniTable', columns: 3},
	            			 	 hidden: true,
	            			 	 id : 'AdvanceSerch',
	            			 	 items: [ 
	            			 	 		  {fieldLabel: '거래처분류'	,name:'AGENT_TYPE', 	xtype: 'uniCombobox', comboType:'AU',comboCode:'B055'  }
	            			 	 		 , Unilite.popup('ITEM2',{ fieldLabel: '대표모델', textFieldWidth:170, validateBlank:false})
	            			 	 		 ,{fieldLabel: '출고유형',name:'INOUT_TYPE_DETAIL', xtype: 'uniCombobox', comboType:'AU',comboCode:'S007'}
	            			 	 		 ,{fieldLabel: '지역'		,name:'AREA_TYPE', 	xtype: 'uniCombobox', comboType:'AU',comboCode:'B056'  }
	            			 	 		 , Unilite.popup('CUST',{ fieldLabel: '집계거래처', validateBlank:false,textFieldWidth:170,valueFieldName: 'MANAGE_CUSTOM', textFieldName:'MANAGE_CUSTOM_NAME'
					            								 ,id:'ssa450skrvvCustPopup', extParam:{'CUSTOM_TYPE':''}})
	            			 	 		 ,{fieldLabel: '판매유형'	,name:'ORDER_TYPE', 	xtype: 'uniCombobox', comboType:'AU',comboCode:'S002'}	            			 	 		 
			            			 	 ,{ fieldLabel: '대분류'    ,name: 'ITEM_LEVEL1' , xtype: 'uniCombobox' ,  child: 'TXTLV_L2'}
			            			 	 ,{ 
			            			 	 	xtype: 'container',
	            			 				layout: {type: 'hbox', align:'stretch'},
	            			 				width:325,
	            			 				defaultType: 'uniTextfield',	            			 				
	            			 				items:[{fieldLabel:'매출번호', suffixTpl:'&nbsp;~&nbsp;', name: 'BILL_FR_NO', width:218},	            			 				
	            			 				{hideLabel : true, name: 'BILL_TO_NO', width:107}
	            			 				] 
							             }
							             ,{fieldLabel: '매출량'		,name:'SALE_FR_Q' , suffixTpl:'&nbsp;이상'}
							             ,{ fieldLabel: '중분류'	,name: 'ITEM_LEVEL2' , xtype: 'uniCombobox' ,  child: 'TXTLV_L3'}
							             ,{ 
			            			 	 	xtype: 'container',
	            			 				layout: {type: 'hbox', align:'stretch'},
	            			 				width:325,
	            			 				defaultType: 'uniTextfield',	            			 				
	            			 				items:[{fieldLabel:'계산서번호', suffixTpl:'&nbsp;~&nbsp;', name: 'PUB_FR_NUM', width:218},	            			 				
	            			 				{hideLabel : true, name: 'PUB_TO_NUM', width:107}
	            			 				] 
							             },{fieldLabel:' ',name:'SALE_TO_Q', suffixTpl:'&nbsp;이하'}
							             ,{ fieldLabel: '소분류'	,name: 'ITEM_LEVEL3' , xtype: 'uniCombobox' }
								         ,{ fieldLabel: '출고일'
							               ,xtype: 'uniDateRangefield'
							               ,startFieldName: 'INOUT_FR_DATE'
							               ,endFieldName: 'INOUT_TO_DATE'
							               ,width:315							              
							              }
	            			 	]
	            			 
	            			 }
	            		
		          ]
    });    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var showSummary = true;
    
    var changeSummaryRow = function(stype){
        return function(){
        	var grid = masterGrid1;
            var view = grid.lockedGrid.getView();
            view.getFeature('group').summaryRowPosition = stype;
            view.getFeature('group').showSummaryRow = true;

            view = grid.normalGrid.getView();
            view.getFeature('group').summaryRowPosition = stype;
            view.getFeature('group').showSummaryRow = true;
            
            grid.getStore().fireEvent('refresh', grid.getStore());
        }
    };
    var masterGrid1 = Unilite.createGrid('ssa450skrvGrid1', {
    //var masterGrid1 =Ext.create('Ext.grid.Panel', {
    	// for tab
    	//title: '거래처별',
    	region:'center',
        layout : 'fit',    
		syncRowHeight: false,    
    	store: directMasterStore1,
    	uniOpt: { 
//    		useGroupSummary : true,
    		useRowNumberer: false
    	},
     	        
        features: [
	        Ext.create('Ext.ux.grid.feature.MultiGroupingSummary', {
	            id:                     'group',
	            hideGroupedHeader:      true,
	            enableGroupingMenu:     true,
	            startCollapsed:         true
	        })
//	        , 
//	        {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
//	    	{id : 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false}	
//        {
//            ftype:  'summary',
//            dock:   'bottom'
//        }
        ],
        dockedItems: [{
            dock:   'top',
            xtype:  'toolbar',
            items: [{
                tooltip:        'Toggle the visibility of the summary row',
                text:           'Toggle Summary',
                enableToggle:   true,
                pressed:        true,
                handler: function() {
                	var grid = masterGrid1;
                    showSummary = !showSummary;
                    var view = grid.lockedGrid.getView();
                    view.getFeature('group').toggleSummaryRow(showSummary);
                    view.refresh();
                    view = grid.normalGrid.getView();
                    view.getFeature('group').toggleSummaryRow(showSummary);
                    view.refresh();
                }
            },{
                tooltip: 'Change summary row position',
                text: 'Summary row position',
                menu: {
                    items: [{
                        text:       'outside',
                        handler:    changeSummaryRow('outside')
                    },{
                        text:       'inside',
                        handler:    changeSummaryRow('inside')
                    }]
                }
            }]
        }],
        columns:  [        
               		 { dataIndex:'SALE_CUSTOM_CODE'	        		,		   	width:80, locked:true
               		 /*,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	var me = this;
		                  	var rv = '<div align="center"></div>';
		                  	rv =  '<div align="center">계</div>';
//		                  	if(Unilite.isGrandSummaryRow(summaryData)) {
//		        				rv =  '<div align="center">총계</div>';
//		                	}  else {
//		        				rv = '<div align="center">소계</div>';
//		                	}
	                		return rv;										
                    } */} 			
					,{ dataIndex:'SALE_CUSTOM_NAME'			,		   	width:100, locked:true } 	
					,{ dataIndex:'BILL_TYPE'				,		   	width:80}	
					,{ dataIndex:'SALE_DATE'				,		   	width:80} 				     
					,{ dataIndex:'INOUT_TYPE_DETAIL'	 	,		   	width:123}				     
					,{ dataIndex:'ITEM_CODE'				,		   	width:123} 				     
					,{ dataIndex:'ITEM_NAME'				,		   	width:123 }					
					,{ dataIndex:'SPEC'						,		   	width:123 } 				 
					,{ dataIndex:'SALE_UNIT'				,		   	width:53, align:'center'} 				     
					,{ dataIndex:'PRICE_TYPE'				,		   	width:53, hidden:true} 			
					,{ dataIndex:'TRANS_RATE'				,		   	width:53, align:'right'}						
					,{ dataIndex:'SALE_Q'					,		   	width:80, summaryType:'sum'} 				     
					,{ dataIndex:'SALE_WGT_Q'				,		   	width:100, hidden:true } 			
					,{ dataIndex:'SALE_VOL_Q'				,		   	width:80, hidden:true},{ dataIndex:'CUSTOM_CODE'				,		   	width:80} 				     
					,{ dataIndex:'CUSTOM_NAME'				,		   	width:113 }
					,{ dataIndex:'SALE_P'					,		   	width:113 } 				     
					,{ dataIndex:'SALE_FOR_WGT_P'			,		   	width:113, hidden:true } 	
					,{ dataIndex:'SALE_FOR_VOL_P'			,		   	width:113, hidden:true} 	
					,{ dataIndex:'MONEY_UNIT'				,		   	width:80} 				     
					,{ dataIndex:'EXCHG_RATE_O'				,		   	width:80, align:'right'} 		
					,{ dataIndex:'SALE_LOC_AMT_F'			,		   	width:113, summaryType:'sum'} 				     	
					,{ dataIndex:'SALE_LOC_AMT_I'			,		   	width:113, summaryType:'sum' } 				     
					,{ dataIndex:'TAX_TYPE'					,		   	width:80, align:'center'} 				     
					,{ dataIndex:'TAX_AMT_O'				,		   	width:113, summaryType:'sum'}				     
					,{ dataIndex:'SUM_SALE_AMT'				,		   	width:113, summaryType:'sum' }				 
					,{ dataIndex:'ORDER_TYPE'				,		   	width:100 } 				 
					,{ dataIndex:'DIV_CODE'					,		   	width:100 } 				 
					,{ dataIndex:'SALE_PRSN'				,		   	width:100} 				     
					,{ dataIndex:'MANAGE_CUSTOM'			,		   	width:80} 				     
					,{ dataIndex:'MANAGE_CUSTOM_NM'			,		   	width:113 }				     
					,{ dataIndex:'AREA_TYPE'				,		   	width:66 }			         
					,{ dataIndex:'AGENT_TYPE'				,		   	width:113 }
					,{ dataIndex:'PROJECT_NO'				,		   	width:113} 				     
					,{ dataIndex:'PUB_NUM'					,		   	width:80} 				     
					,{ dataIndex:'EX_NUM'					,		   	width:93 } 				     
					,{ dataIndex:'BILL_NUM'					,		   	width:106 } 				 
					,{ dataIndex:'ORDER_NUM'				,		   	width:106 } 				 
					,{ dataIndex:'DISCOUNT_RATE'			,		   	width:106 } 				 
					,{ dataIndex:'PRICE_YN'					,	    	width:106 }					
					,{ dataIndex:'WGT_UNIT'					,	    	width:106, hidden:true }
					,{ dataIndex:'UNIT_WGT'					,	    	width:106, hidden:true }
					,{ dataIndex:'VOL_UNIT'					,	    	width:106, hidden:true }
					,{ dataIndex:'UNIT_VOL'					,	    	width:106, hidden:true }
					,{ dataIndex:'COMP_CODE'				,	    	width:106, hidden:true }
					,{ dataIndex:'BILL_SEQ'					,	    	width:106, hidden:true }
					,{ dataIndex:'CREATE_LOC'				,		   	width:80 }
					
          ] 
    });
	
    Unilite.Main( {
		borderItems : [panelSearch, 	masterGrid1],
		id  : 'ssa450skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			
			
				directMasterStore1.loadStoreRecords();				
			
			
			/*
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			
			var masterGridSubTotal, masterGridTotal;
			
			masterGridSubTotal = viewLocked.getFeature('masterGridSubTotal'); 
			if(!Ext.isEmpty(masterGridSubTotal)) masterGridSubTotal.toggleSummaryRow(true);
			masterGridTotal = viewLocked.getFeature('masterGridTotal');
			if(!Ext.isEmpty(masterGridTotal)) masterGridTotal.toggleSummaryRow(true);
			
			masterGridSubTotal = viewNormal.getFeature('masterGridSubTotal'); 
			if(!Ext.isEmpty(masterGridSubTotal)) masterGridSubTotal.toggleSummaryRow(true);
			masterGridTotal = viewNormal.getFeature('masterGridTotal');
			if(!Ext.isEmpty(masterGridTotal)) masterGridTotal.toggleSummaryRow(true);		*/	
	
		},		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>
