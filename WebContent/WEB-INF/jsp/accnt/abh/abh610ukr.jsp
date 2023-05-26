<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="abh610ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->      
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Abh610ukrModel', {		
	    fields: [{name: 'SEQ'  		     ,text: '순번' 		,type: 'string'},			 	 	
				 {name: 'APPR_DATE' 	 ,text: '승인일' 		,type: 'string'},			 	 	
				 {name: 'CARD_COMP_NAME' ,text: '카드사' 		,type: 'string'},			 	 	
				 {name: 'CARD_NO'     	 ,text: '신용카드번호' 	,type: 'string'},			 	 	
				 {name: 'CHAIN_NAME'     ,text: '가맹점명' 	,type: 'string'},			 	 	
				 {name: 'CHAIN_ID'       ,text: '사업자번호' 	,type: 'string'},			 	 	
				 {name: 'APPR_AMT_I'  	 ,text: '금액' 		,type: 'string'},			 	 	
				 {name: 'APPR_NO'      	 ,text: '승인번호' 	,type: 'string'},			 	 	
				 {name: 'ACCRUE_I'       ,text: '대사결과차액' 	,type: 'string'},			 	 	
				 {name: 'AMT_I'      	 ,text: '금액' 		,type: 'string'},			 	 	
				 {name: 'AC_DATE'      	 ,text: '전표일' 		,type: 'string'},			 	 	
				 {name: 'SLIP_NUM'       ,text: '번호' 		,type: 'string'},			 	 	
				 {name: 'SLIP_SEQ'       ,text: '순번' 		,type: 'string'},			 	 	
				 {name: 'OC_DATE'        ,text: '승인일' 		,type: 'string'},			 	 	
				 {name: 'REMARK'         ,text: '적요' 		,type: 'string'},			 	 	
				 {name: 'PAY_REFT_NO'    ,text: '지출참조정보' 	,type: 'string', hidden: true}		 	 	
				 		
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('abh610ukrMasterStore1',{
			model: 'Abh610ukrModel',
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
                	   read: 'abh610ukrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'CUSTOM_NAME'			
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */ 
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '검색조건',         
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
			title: '기본정보',   
			itemId: 'search_panel1',
			layout : {type : 'vbox', align : 'stretch'},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},
	    		items:[{ 
	    			fieldLabel: '일자',
			        xtype: 'uniDateRangefield',
			        startFieldName: 'FR_DATE',
			        endFieldName: 'TO_DATE',
			        width: 470,
			        startDate: UniDate.get('startOfMonth'),
			        endDate: UniDate.get('today'),
			        allowBlank: false,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_DATE', newValue);			    		
				    	}
				    }
		        }, {
		    		xtype: 'radiogroup',		            		
		    		fieldLabel: ' ',		    		
		    		items: [{
			    			boxLabel: '전표일' , width: 62, name: 'RADIO1', inputValue: '1', checked: true
			    		}, {
			    			boxLabel: '승인일' , width: 62, name: 'RADIO1', inputValue: '2'
		    		}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('RADIO1').setValue(newValue.RADIO1);
						}
					}
		        }, {
		    		xtype: 'radiogroup',		            		
		    		fieldLabel: '대사결과',		    		
		    		items: [{
			    			boxLabel: '전체' , width: 62, name: 'RADIO2', inputValue: 'A', checked: true
			    		}, {
			    			boxLabel: '일치' , width: 62, name: 'RADIO2', inputValue: 'Y'
			    		}, {
			    			boxLabel: '불일치' , width: 62, name: 'RADIO2', inputValue: 'N'
		    		}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('RADIO2').setValue(newValue.RADIO2);
						}
					}
		        },		    
			    	Unilite.popup('CREDIT_NO',{
			    	fieldLabel: '카드번호',
					valueFieldName:'CREDIT_NO_CODE',
					textFieldName:'CREDIT_NO_NAME',
			    	validateBlank:false
	//		    	textFieldWidth:170
			    }), {
		    		xtype: 'radiogroup',		            		
		    		fieldLabel: '지출참조',		    		
		    		items: [{
			    			boxLabel: '전체' , width: 62, name: 'RADIO3', inputValue: 'A', checked: true
			    		}, {
			    			boxLabel: '예' , width: 62, name: 'RADIO3', inputValue: 'Y'
			    		}, {
			    			boxLabel: '아니오' , width: 62, name: 'RADIO3', inputValue: 'N'
		    		}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('RADIO3').setValue(newValue.RADIO3);
						}
					}
		        }, {
			    	xtype: 'uniTextfield',
			    	fieldLabel: '승인금액합계',
			    	name: 'CRD_TOT_I'
			    }, {
			    	xtype: 'uniTextfield',
			    	fieldLabel: '승인금액합계',
			    	name: 'ERP_TOT_I'
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
			fieldLabel: '일자',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'FR_DATE',
	        endFieldName: 'TO_DATE',
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),
	        allowBlank: false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE', newValue);			    		
		    	}
		    }
        }, {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '',    		
    		items: [{
	    			boxLabel: '전표일' , width: 62, name: 'RADIO1', inputValue: '1', checked: true
	    		}, {
	    			boxLabel: '승인일' , width: 62, name: 'RADIO1', inputValue: '2'
    		}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('RADIO1').setValue(newValue.RADIO1);
				}
			}
        }, {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '대사결과',    		
    		items: [{
	    			boxLabel: '전체' , width: 62, name: 'RADIO2', inputValue: 'A', checked: true
	    		}, {
	    			boxLabel: '일치' , width: 62, name: 'RADIO2', inputValue: 'Y'
	    		}, {
	    			boxLabel: '불일치' , width: 62, name: 'RADIO2', inputValue: 'N'
    		}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('RADIO2').setValue(newValue.RADIO2);
				}
			}
        },		    
	    	Unilite.popup('CREDIT_NO',{
	    	fieldLabel: '카드번호',
			valueFieldName:'CREDIT_NO_CODE',
			textFieldName:'CREDIT_NO_NAME',
	    	validateBlank:false
//		    	textFieldWidth:170
	    }),{
        	xtype: 'component'
        }, {
    		xtype: 'radiogroup',		            		
    		fieldLabel: '지출참조',    		
    		items: [{
	    			boxLabel: '전체' , width: 62, name: 'RADIO3', inputValue: 'A', checked: true
	    		}, {
	    			boxLabel: '예' , width: 62, name: 'RADIO3', inputValue: 'Y'
	    		}, {
	    			boxLabel: '아니오' , width: 62, name: 'RADIO3', inputValue: 'N'
    		}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('RADIO3').setValue(newValue.RADIO3);
				}
			}
        },{
        	xtype: 'component',
        	colspan: 3,
			tdAttrs: {style: 'border-bottom: 1px solid #cccccc;'}
        }, {
	    	xtype: 'uniTextfield',
	    	fieldLabel: '승인금액합계',
	    	name: 'CRD_TOT_I'
	    }, {
	    	xtype: 'uniTextfield',
	    	fieldLabel: '승인금액합계',
	    	name: 'ERP_TOT_I'
	    }]	
    }); 
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('abh610ukrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore1,
    	uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'SEQ'  		     ,		 	width: 46, locked: true },
        		   { dataIndex: 'APPR_DATE' 	 ,		 	width: 80, locked: true },
        		   { dataIndex: 'CARD_COMP_NAME' ,		 	width: 120, locked: true },
        		   { dataIndex: 'CARD_NO'     	 ,		 	width: 133, locked: true },
        		   {text: '법인카드 승인정보',
				   columns: [{dataIndex: 'CHAIN_NAME'     ,		 	width: 146 },
			        		 {dataIndex: 'CHAIN_ID'       ,		 	width: 100 },
			        		 {dataIndex: 'APPR_AMT_I'     ,		 	width: 86 },
			        		 {dataIndex: 'APPR_NO'        ,		 	width: 86 }]
				   },        		   
        		   { dataIndex: 'ACCRUE_I'       ,		 	width: 86 },
        		   {text: 'uniLITE 미지급카드 정보',
				   columns: [{dataIndex: 'AMT_I'      	 ,		 	width: 86 },
		        		     {dataIndex: 'AC_DATE'       ,		 	width: 80 },
		        		     {dataIndex: 'SLIP_NUM'       ,		 	width: 46 },
		        		     {dataIndex: 'SLIP_SEQ'       ,		 	width: 46 },
		        		     {dataIndex: 'OC_DATE'        ,		 	width: 80 },
		        		     {dataIndex: 'REMARK'         ,		 	width: 133 }]
				   },        		   
        		   { dataIndex: 'PAY_REFT_NO'    ,		 	width: 100 }
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
		id  : 'abh610ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			
				masterGrid.getStore().loadStoreRecords();
				var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);				
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
