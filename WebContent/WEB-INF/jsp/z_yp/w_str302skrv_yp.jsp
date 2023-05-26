<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="w_str302skrv_yp" >	
	<t:ExtComboStore comboType="BOR120" pgmId="w_str302skrv_yp" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU"  comboCode="B001"/>
	<t:ExtComboStore comboType="AU"  comboCode="B024"/>	
	<t:ExtComboStore comboType="AU"  comboCode="A"	/>
	<t:ExtComboStore comboType="AU"  comboCode="S006"/>	
	<t:ExtComboStore comboType="AU"  comboCode="S007"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B020"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B021"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B036"/>	
    <t:ExtComboStore comboType="AU"  comboCode="B001"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B116"/>	
    <t:ExtComboStore comboType="AU"  comboCode="B013"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B010"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B039"/>	
	<t:ExtComboStore comboType="AU"  comboCode="B031" opts="1;5"/>        <!--생성경로-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />		<!--창고-->
</t:appConfig>
<script type="text/javascript" >
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */

	Unilite.defineModel('w_str302skrv_ypModel2', {
	    fields:  [  
				     {name: 'ITEM_CODE1'                ,text: '품목코드'       ,type: 'string'},
					 {name: 'ITEM_NAME1'                ,text: '품목명'         ,type: 'string'},
					 {name: 'ITEM_CODE2'                ,text: '품목코드'       ,type: 'string'},
					 {name: 'ITEM_NAME2'                ,text: '품목명'         ,type: 'string'},
					 {name: 'ITEM_CODE'                 ,text: '품목코드'       ,type: 'string'},
					 {name: 'ITEM_NAME'                 ,text: '품목명'         ,type: 'string'},
					 {name: 'SPEC'                    	,text: '규격'			,type: 'string'},              
    				 {name: 'ORDER_UNIT'              	,text: '판매단위'		,type: 'string'},        
    				 {name: 'INOUT_Q'                 	,text: '출고량'	        ,type: 'uniQty'},    
    				 
    				 {name: 'WGT_UNIT'      			,text:'중량단위'  		,type: 'string' },  
			         {name: 'UNIT_WGT'      			,text:'단위중량'  		,type: 'string' },  
			         {name: 'INOUT_WGT_Q'        		,text: '출고량(중량)'	,type: 'uniQty' }, 
			         {name: 'INOUT_FOR_WGT_P'			,text: '단가(중량)'     ,type: 'uniUnitPrice'},  
			         {name: 'VOL_UNIT'      			,text:'부피단위'  		,type: 'string' },  
			         {name: 'UNIT_VOL'      			,text:'단위부피'  		,type: 'string' },  
			         {name: 'INOUT_VOL_Q'       	 	,text: '수불량(부피)'	,type: 'uniQty' },   
			         {name: 'INOUT_FOR_VOL_P'    		,text: '단가(부피)'	    ,type: 'uniUnitPrice' },  
			         
    				 {name: 'TRNS_RATE'               	,text: '입수'			,type: 'string'},
					 {name: 'STOCK_UNIT'              	,text: '재고단위'		,type: 'string'}, 
					 {name: 'MONEY_UNIT'     			,text: '화폐단위'   	,type: 'string'},   
    				 {name: 'ORDER_UNIT_Q'            	,text: '재고단위출고량'	,type: 'uniQty'},
					 {name: 'ORDER_UNIT_P'     			,text: '구매단가'		,type: 'uniUnitPrice' },  
					 {name: 'EXCHG_RATE_O'     			,text: '환율'    		,type: 'uniER' }, 
					
					 {name: 'INOUT_P'  					,text: '단가'    		,type: 'uniUnitPrice'},  
			         {name: 'INOUT_FOR_O'				,text: '외화금액'		,type: 'uniFC'},    
			         {name: 'INOUT_I'					,text: '원화금액'		,type: 'uniPrice'},   
			         {name: 'TRANS_COST'          		,text: '운반비'     	,type: 'uniPrice' },  
					 {name: 'INOUT_TYPE_DETAIL'         ,text: '출고유형'  	    ,type: 'string' ,comboType:"AU", comboCode:"S007"},          
					 {name: 'INOUT_CODE_TYPE'     		,text: '입고처구분'  	,type: 'string' },  
					 {name: 'INOUT_CODE'   				,text: '수불처코드'  	,type: 'string' },  
					 {name: 'INOUT_NAME'                ,text: '출고처'     	,type: 'string'},  
					 {name: 'INOUT_DATE'    			,text: '출고일'  		,type: 'uniDate'},    
					 {name: 'DVRY_CUST_NAME'       		,text:'배송처'		    ,type: 'string'},  
			         {name: 'DOM_FORIGN'     			,text:'국내외구분' 	    ,type: 'string'},   
					 {name:  'WH_CODE'                 	,text: '창고'			,type: 'string' ,store:  Ext.data.StoreManager.lookup('whList')},
					 {name: 'INOUT_PRSN'   				,text: '수불담당' 	    ,type: 'string' ,comboType:'AU', comboCode:'B024' },  
					 {name: 'ISSUE_DATE'    			,text: '출고요청일'   	,type: 'uniDate'},  
			         {name: 'ISSUE_REQ_NUM'    			,text: '출하지시번호'	,type: 'string'},
					 {name: 'LOT_NO'       				,text: 'LOT NO'	        ,type: 'string'},
					 {name: 'PROJECT_NO'                ,text: '프로젝트번호'   ,type: 'string'},
					 {name: 'REMARK'      				,text:'비고'    		,type: 'string'},   
				     {name: 'ACCOUNT_YNC'     			,text: '매출대상'  	    ,type: 'string' ,comboType:'AU', comboCode:'B010' },  
			         {name: 'ORDER_NUM'      			,text:'수주번호'  		,type: 'string'},  
			         {name: 'DVRY_DATE'     			,text:'납기일'    	    ,type: 'uniDate'},  
					 {name: 'DELIVERY_DATE'        		,text:'납품일'		    ,type: 'uniDate'},  
			         {name: 'ACCOUNT_Q'        			,text: '매출량'  		,type: 'uniQty'},  
			         {name: 'LC_NUM'        			,text: 'L/C번호'   	    ,type: 'string'},  
			         {name: 'INOUT_NUM'    				,text: '출고번호'		,type: 'string'},  
					 {name: 'PO_NUM'      				,text:'PO_NUM'   	    ,type: 'string' },  
					 {name: 'PO_SEQ'               		,text:'PO_SEQ'   	    ,type: 'string' },          
					 {name: 'INOUT_SEQ'    				,text: '순번'     	    ,type: 'string'},  
					 {name: 'INOUT_METH'    			,text: '출고방법'   	,type: 'string' ,comboType: "AU", comboCode: "B036"},  
					 {name: 'EVAL_INOUT_P'   			,text: '평균단가'  	    ,type: 'uniUnitPrice'},  
					 {name:  'SORT_KEY'                	,text: 'SORTKEY'	    ,type: 'string' },
			         {name: 'PRICE_TYPE'     			,text:'단가구분'  		,type: 'string' ,hidden:true},  
					 {name: 'UPDATE_DB_TIME' 	  		,text: '등록일시'		,type: 'uniDate'}
		]
	});

    var directMasterStore2 = Unilite.createStore('w_str302skrv_ypMasterStore2',{
			model:  'w_str302skrv_ypModel2',
			uniOpt:  {
            	isMaster:  true,			// 상위 버튼 연결
            	editable:  false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi:  false			// prev | newxt 버튼 사용
            },
            autoLoad:  false,
            proxy:  {
                type:  'direct',
                api:  {			
                	   read:  'w_str302skrv_ypService.selectList2'                	
                }
            }
			,loadStoreRecords:  function()	{
				var param1 = panelSearch.getValues();
                var param2 = panelResult.getValues();
                param2.TYPE = panelResult.getValue('TYPE').TYPE;
                var params = Ext.merge(param1 , param2);
				var authoInfo = pgmInfo.authoUser;				// 권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	// 부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				this.load({
					params:  params
				});				
			},
			groupField:  'ITEM_CODE1'
			
	});
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
//	        collapse: function () {
//	            panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
        },
		items: [{
			title: '추가검색', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
    		items:[{ 
    				fieldLabel:'대분류',
    				name:'ITEM_LEVEL1', 
    				xtype:'uniCombobox',  
    				store:  Ext.data.StoreManager.lookup('itemLeve1Store'), 
    				child:  'ITEM_LEVEL2'
    			},{ 
    				fieldLabel:'중분류',
    				name:'ITEM_LEVEL2', 
    				xtype:'uniCombobox',  
    				store:  Ext.data.StoreManager.lookup('itemLeve2Store'), 
    				child:  'ITEM_LEVEL3'
    			},{ 
    				fieldLabel:'소분류',
    				name:'ITEM_LEVEL3',
    				xtype:'uniCombobox',
    				store:Ext.data.StoreManager.lookup('itemLeve3Store'),
					parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
		            levelType:'ITEM'
    			},
    				Unilite.popup('ITEM_GROUP',{ 
							fieldLabel:'대표모델코드', 
							valueFieldName:'ITEM_GROUP',
							textFieldName: 'ITEM_GROUP_NAME',
							validateBlank: false,
							popupWidth:710,
							listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
			                    	},
									scope: this
								},
								onClear: function(type)	{
									
								},
								applyextparam: function(popup){							
								}
						}
    			}),{ 
		 	 		xtype:  'container',
		 	 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel:'출고번호',//출고번호
 						suffixTpl: '&nbsp;~&nbsp;', 
 						name:'FR_INOUT_NO',  
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TO_INOUT_NO', 
 						width: 107
 					}] 
		   		},{
		   			fieldLabel:'Lot No.',
		   			name:'LOT_NO',
		   			width: 325,
		   			xtype:'uniTextfield'
		   		},{
		   			fieldLabel:'품목계정',
		   			name:'ITEM_ACCOUNT',
		   			xtype:'uniCombobox',
		   			comboType:'AU',
		   			comboCode: 'B020'
		   		},{ 
		   			
		 	 		xtype:  'container',
		 	 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel:'출고량',//출고량
 						suffixTpl:'&nbsp;~&nbsp;',
 						name:'FR_INOUT_QTY',
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TO_INOUT_QTY', 
 						width: 107
 					}]
 				},{ 
 					fieldLabel:'출고유형',//출고유형
 					name: 'INOUT_TYPE_DETAIL',
 					xtype:'uniCombobox',
 					comboType:'AU',
 					comboCode: 'S007'
 				},{ 
 					fieldLabel:'양불구분',
 					name:'GOOD_BAD',
 					xtype:'uniCombobox',
 					comboType: 'AU',
 					comboCode: 'B021'
 				},
 				{ 
		 	 		xtype:  'container',
		 	 		colspan: 2,
 					layout:  {type:  'hbox', align: 'stretch'},
 					width: 325,
 					itemId:'FR_ORDER_NUM',
 					defaultType:  'uniTextfield',
 					items: [{
 						fieldLabel: '수주번호',
 						suffixTpl:'&nbsp;~&nbsp;',
 						name:'FR_ORDER_NUM',
 						width: 218
 					},{
 						hideLabel:true, 
 						name:'TO_ORDER_NUM',
 						width: 107
 					}]
 				},{ 
 					fieldLabel:'PO_NO',
 					name:'PO_NO', 
 					width: 300
 				},{ 
        			fieldLabel: '납기경과',
        		 	xtype: 'radiogroup',		
        		 	itemId:'DELIVERY',
        		 	width: 300,
        		 	items: [{
        		 		boxLabel:'전체', 
        		 		name:'DELIVERY',
        		 		inputValue: '0', 
        		 		checked: true
        		 	},{
        		 		boxLabel:'납기준수',
        		 		name:'DELIVERY',
        		 		inputValue: '1'
        		 	},{
        		 		boxLabel:'납기경과',
        		 		name:'DELIVERY',
        		 		inputValue: '2'
        		 	}]
        		 	
        		},{
        		 	xtype: 'radiogroup',
        		 	fieldLabel: '반품포함여부',
        		 	itemId:'RETURN',
        		 	width: 300,
        		 	items: [{
        		 		boxLabel:'포함안함',
        		 		name:'RETURN',
        		 		inputValue: '1',
        		 		checked: true
        		 	},{
        		 		boxLabel:'포함',
        		 		name:'RETURN',
        		 		inputValue: '2'
        		 	},{
        		 		hidden: true
        		 	}]
        		},{
        			fieldLabel: '매출대상여부',
        		 	xtype: 'radiogroup',
        		 	itemId:'ACCOUNT_YNC',
        		 	width: 300,
        		 	items: [{
        		 		boxLabel:'전체',
        		 		name:'ACCOUNT_YNC',
        		 		inputValue: '',
        		 		checked: true
        		 	},{
        		 		boxLabel:'예',
        		 		name:'ACCOUNT_YNC',
        		 		inputValue: 'Y'
        		 	},{
        		 		boxLabel:'아니오',
        		 		name:'ACCOUNT_YNC',
        		 		inputValue: 'N'
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
	   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}
	});	
	
    var panelResult = Unilite.createSearchForm('panelResultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        defaultType: 'uniSearchSubPanel',
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{	 	
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		holdable: 'hold',
        		value : UserInfo.divCode,
        		child: 'WH_CODE',
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				},
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('INOUT_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},
	    	
			{
				fieldLabel: '수불일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	 if(panelSearch) {
					 	panelSearch.setValue('FR_INOUT_DATE',newValue);
                	 }
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	 if(panelSearch) {
			    	 	panelSearch.setValue('TO_INOUT_DATE',newValue);
			    	 }
			    }
			},{
                fieldLabel: '생성경로',
                name:'CREATE_LOC', 
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'B031',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                         panelSearch.setValue('CREATE_LOC', newValue);
                    }
                }
            },
			{
				fieldLabel: '수불담당',
				name: 'INOUT_PRSN', 
				xtype:'uniCombobox', 
				comboType: 'AU',
				comboCode: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						 panelSearch.setValue('INOUT_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			
			Unilite.popup('DIV_PUMOK',{ 
	        	fieldLabel: '품목코드',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
				validateBlank: false,
	        	listeners: {
					onSelected: {
						fn: function(records, type) {
                    	},
						scope: this
					},
					onClear: function(type)	{
					},
					applyextparam: function(popup){							
						 popup.setExtParam({'DIV_CODE':panelResult.getValue('DIV_CODE')});
					}
				}
	 		}),{ 
                fieldLabel: '조회구분',
                xtype: 'radiogroup',
                name: 'TYPE',
                items:[{
                    boxLabel:'품목별',
                    name: 'TYPE',
                    inputValue: '1', 
                    checked: true,
                    width: 65
                },{
                    boxLabel:'출고처별',
                    name:'TYPE',
                    inputValue: '2',
                    width: 80
                },{
                    boxLabel:'배송처별',
                    name:'TYPE',
                    inputValue: '3',
                    width: 80
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	UniAppManager.app.onQueryButtonDown();
                    }
                }
                
                
            },
	 		{
				fieldLabel:  '창고',
				name: 'WH_CODE', 
				xtype:'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
						 change: function(field, newValue, oldValue, eOpts) {
						 panelSearch.setValue('WH_CODE', newValue);
						 }
					}
			},
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '출고처',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                validateBlank: false,
                holdable: 'hold',
                itemId:'CUSTOM_CODE',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            console.log('records : ', records);
                            CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
                        },
                        scope: this
                    },
                    onClear: function(type) {
                                CustomCodeInfo.gsUnderCalBase = '';
                            }
                }
            }),
			{ 
				fieldLabel: '합계행',
    		 	xtype: 'radiogroup',
    		 	itemId:'optSelect',
    		 	items:[{
    		 		boxLabel:'출력',
    		 		name: 'optSelect',
    		 		inputValue: 'Y', 
    		 		checked: true,
                    width: 65
    		 	},{
    		 		boxLabel:'미출력',
    		 		name:'optSelect',
    		 		inputValue: 'N'
    		 	}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						summaryHandle(newValue.optSelect);
					}
				}
    		 	
    		}
	]
	
    });
	
	var masterGrid2 = Unilite.createGrid('w_str302skrv_ypGrid2', {
    	// for tab
    	region: 'center' ,
        layout:  'fit',
    	store:  directMasterStore2, 
        uniOpt:{
        	expandLastColumn: false,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
    		filter: {
				useFilter: true,
				autoCreate: true
			},
			state: {
            useState: false,         //그리드 설정 버튼 사용 여부
            useStateList: false      //그리드 설정 목록 사용 여부
        }
        },
    	features:  [ {id:  'masterGridSubTotal2', ftype:  'uniGroupingsummary', showSummaryRow:  true },
    	           	 {id:  'masterGridTotal2', 	ftype:  'uniSummary'          , showSummaryRow:  true} ],
        columns: [   
					 { dataIndex: 'ITEM_CODE1'		   	,width: 120 ,locked: false,
					     summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			                 return Unilite.renderSummaryRow(summaryData, metaData, '품목소계', '총계');
                         }
					 }, 				
					 { dataIndex: 'ITEM_NAME1'		    ,width: 120 ,locked: false},
					 { dataIndex: 'ITEM_CODE2'  		,width: 120 ,hidden:true},
					 { dataIndex: 'ITEM_NAME2'  		,width: 120 ,hidden:true},
					 { dataIndex: 'ITEM_CODE'   		,width: 120 ,hidden:true},
					 { dataIndex: 'SPEC'				,width: 120 },				
					 { dataIndex: 'ORDER_UNIT'		    ,width: 100, align: 'center' },
					 { dataIndex: 'INOUT_Q'			 	,width: 113,summaryType:'sum'},		
					 
					 { dataIndex: 'WGT_UNIT'      		,width: 80, hidden: true },
					 { dataIndex: 'UNIT_WGT'      		,width: 80, hidden: true },
					 { dataIndex: 'INOUT_WGT_Q'       	,width: 100, hidden: true },
					 { dataIndex: 'INOUT_FOR_WGT_P'		,width: 80 ,hidden:true},
					 { dataIndex: 'VOL_UNIT'      		,width: 80 ,hidden:true},
					 { dataIndex: 'UNIT_VOL'      		,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_VOL_Q'      	,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_FOR_VOL_P'  	,width: 80 ,hidden:true},
					 
					 { dataIndex: 'TRNS_RATE'		    ,width: 90 },			
					 { dataIndex: 'STOCK_UNIT'			,width: 120, align: 'center'  },          				
					 { dataIndex: 'ORDER_UNIT_Q'        ,width: 100 ,summaryType:'sum'},
					 { dataIndex: 'ORDER_UNIT_P'		,width: 106 ,hidden:true},				
					 { dataIndex: 'EXCHG_RATE_O'     	,width: 80  ,hidden:true},			
					 { dataIndex: 'MONEY_UNIT'			,width: 65},				
					 { dataIndex: 'INOUT_P'  			,width: 80  ,hidden:true},				
					 { dataIndex: 'INOUT_FOR_O'     	,width: 80},			
					 { dataIndex: 'INOUT_I'				,width: 120 ,summaryType:'sum'},				
					 { dataIndex: 'TRANS_COST'			,width: 80 ,hidden:true},			
					 { dataIndex: 'INOUT_TYPE_DETAIL'	,width: 120 },				
					 { dataIndex: 'INOUT_CODE_TYPE'		,width: 60 ,hidden:true},				
					 { dataIndex: 'INOUT_CODE'   		,width: 30 ,hidden:true},			
					 { dataIndex: 'INOUT_NAME'			,width: 120 },				
					 { dataIndex: 'INOUT_DATE'   		,width: 120 },				
					 { dataIndex: 'DVRY_CUST_NAME'		,width: 100 },				
					 { dataIndex: 'DOM_FORIGN'			,width: 100},			
					 { dataIndex:  'WH_CODE'			,width: 110   },				
					 { dataIndex: 'INOUT_PRSN'   		,width: 100   },				
					 { dataIndex: 'ISSUE_DATE'			,width: 80},
					 { dataIndex: 'ISSUE_REQ_NUM'    	,width: 100 },
					 { dataIndex: 'LOT_NO'       		,width: 80 },
					 { dataIndex: 'PROJECT_NO'          ,width: 100 },
					 { dataIndex: 'REMARK'      		,width: 80 },
					 { dataIndex: 'ACCOUNT_YNC'     	,width: 80 },
					 { dataIndex: 'ORDER_NUM'			,width: 120 },
					 { dataIndex: 'DVRY_DATE'			,width: 80 },
					 { dataIndex: 'DELIVERY_DATE'		,width: 80 },
					 { dataIndex: 'ACCOUNT_Q'        	,width: 80 },
					 { dataIndex: 'LC_NUM'				,width: 80 },
					 { dataIndex: 'INOUT_NUM'    		,width: 120 },
					 { dataIndex: 'PO_NUM'      		,width: 80 ,hidden:true},
					 { dataIndex: 'PO_SEQ'				,width: 80 ,hidden:true},
					 { dataIndex: 'INOUT_SEQ'    		,width: 80 },
					 { dataIndex: 'INOUT_METH'			,width: 80 },
					 { dataIndex: 'EVAL_INOUT_P'		,width: 80 },
					 { dataIndex:  'SORT_KEY'           ,width: 80 ,hidden:true},
					 { dataIndex: 'PRICE_TYPE'			,width: 80 ,hidden:true},
					
					 { dataIndex: 'UPDATE_DB_TIME' 		,width: 80 }

		
//
//		.ColHidden(.ColIndex("INOUT_CODE"))			= True
//		.ColHidden(.ColIndex("INOUT_CODE_TYPE"))    = True	
//		.ColHidden(.ColIndex("TRANS_COST"))         = True	
//		
//		.ColHidden(.ColIndex("ORDER_UNIT_P"))	    = True
//		.ColHidden(.ColIndex("EXCHG_RATE_O"))       = True			
//		
//	    .ColHidden(.ColIndex("ITEM_CODE2"))			= True
//	    .ColHidden(.ColIndex("ITEM_NAME2"))			= True   		
//		.ColHidden(.ColIndex("INOUT_P"))            = True	
//	    .ColHidden(.ColIndex("PO_NUM"))			    = True
//	    .ColHidden(.ColIndex("PO_SEQ"))				= True 
//		.ColHidden(.ColIndex("SORT_KEY"))			= TRUE
//
//		.ColHidden(.ColIndex("PRICE_TYPE"))			= True
//'		.ColHidden(.ColIndex("INOUT_WGT_Q"))		= True
//		.ColHidden(.ColIndex("INOUT_FOR_WGT_P"))	= True
//		.ColHidden(.ColIndex("INOUT_VOL_Q"))		= True
//		.ColHidden(.ColIndex("INOUT_FOR_VOL_P"))	= True
//'		.ColHidden(.ColIndex("WGT_UNIT"))			= True
//'		.ColHidden(.ColIndex("UNIT_WGT"))			= True
//		.ColHidden(.ColIndex("VOL_UNIT"))			= True
//		.ColHidden(.ColIndex("UNIT_VOL"))			= True
					 
          ] 
    });
    
    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid2,  panelResult
         	]	
      	},panelSearch
      	// panelSearch
      	],
		id: 'w_str302skrv_ypApp',
		fnInitBinding:  function() {
			 panelResult.getField('CREATE_LOC').setHidden(false);                        
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_INOUT_DATE')));
			
			w_str302skrv_ypService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
				 	panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			UniAppManager.setToolbarButtons('save', false);
			
			panelSearch.setValue('CUSTOM_CODE', '${gsCustomCode}');
            panelSearch.setValue('CUSTOM_NAME', '${gsCustomName}');
//            panelSearch.setValue('ORDER_PRSN', '${gsBusiPrsn}');
//            panelSearch.setValue('ORDER_TYPE', '95');
            panelResult.setValue('CUSTOM_CODE', '${gsCustomCode}');
            panelResult.setValue('CUSTOM_NAME', '${gsCustomName}');
//            panelResult.setValue('ORDER_PRSN', '${gsBusiPrsn}');
//            panelResult.setValue('ORDER_TYPE', '95');
            
//            panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
//            panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
            panelResult.getField('CUSTOM_CODE').setReadOnly(true);
            panelResult.getField('CUSTOM_NAME').setReadOnly(true);
		},
		onResetButtonDown: function() {
			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid2.reset();
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{
			if(!this.isValidSearchForm()){
                return false;
            }
            directMasterStore2.loadStoreRecords();
            if(panelResult.getValue('TYPE').TYPE == '1'){
                masterGrid2.getColumn('ITEM_CODE1').setText('품목코드');
                masterGrid2.getColumn('ITEM_NAME1').setText('품목명');
            }
            else if(panelResult.getValue('TYPE').TYPE == '2'){
                masterGrid2.getColumn('ITEM_CODE1').setText('출고처코드');
                masterGrid2.getColumn('ITEM_NAME1').setText('출고처명');
            }
            else if(panelResult.getValue('TYPE').TYPE == '3'){
                masterGrid2.getColumn('ITEM_CODE1').setText('배송처코드');
                masterGrid2.getColumn('ITEM_NAME1').setText('배송처명');
            }
			summaryHandle(panelResult.down("#optSelect").getValue().optSelect);
			UniAppManager.setToolbarButtons('reset', true)
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
	function summaryHandle(type){
		var viewNormal2 = masterGrid2.getView();        
		if(type == 'Y'){
            viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
            viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
        }else{
            viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(false);
            viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(false);
        }
	}

};

</script>