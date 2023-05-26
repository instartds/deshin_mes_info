<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="agb170skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 	
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!--비용상태-->	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var getStDt = ${getStDt};
	var getChargeCode = ${getChargeCode};
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Agb170skrModel', {
		
	    fields: [{name: 'GBN'					,text: '구분' 		 ,type: 'string'},	    		
				 {name: 'ITEM_CODE'				,text: '비용코드' 		 ,type: 'string'},	    		
				 {name: 'ITEM_NAME'				,text: '비용명' 		 ,type: 'string'},	    		
				 {name: 'AMT_I'					,text: '계약금액' 		 ,type: 'uniPrice'},	    		
				 {name: 'DPR_YYMM'				,text: '비용처리년월' 	 ,type: 'string'},	    		
				 {name: 'FB_DPR_TOT_I'			,text: '기초비용누계액'   ,type: 'uniPrice'},	    		
				 {name: 'FB_BLN_I'				,text: '기초미처리잔액'   ,type: 'uniPrice'},	    		
				 {name: 'TM_DPR_I'				,text: '당월비용' 		 ,type: 'uniPrice'},	    		
				 {name: 'FL_DPR_TOT_I'			,text: '기말비용누계액'   ,type: 'uniPrice'},	    		
				 {name: 'FL_BLN_I'				,text: '기말미처리잔액'   ,type: 'uniPrice'},	    		
				 {name: 'DPR_STS'				,text: '비용상태' 		 ,type: 'string'},	    		
				 {name: 'EX_DATE'				,text: '결의일' 		 ,type: 'uniDate'},	    		
				 {name: 'EX_NUM'				,text: '결의번호' 		 ,type: 'string'}    		
				 
			]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agb170skrMasterStore1',{
			model: 'Agb170skrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'agb170skrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{ 
    			fieldLabel: '비용처리년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_MONTH',
		        endFieldName: 'TO_MONTH',
		        width: 325,
		        //startDate: UniDate.get('startOfMonth'),
		        //endDate: UniDate.get('today'),
		        allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FR_MONTH', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_MONTH', newValue);				    		
			    	}
			    }
	        },{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},		    
		    	Unilite.popup('COST',{
		    	fieldLabel: '기간비용',
	//	    	validateBlank:false,
		    	autoPopup:false,
		    	valueFieldName: 'COST_CODE_FR',
		    	textFieldName: 'COST_NAME_FR',
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelResult.setValue('COST_CODE_FR', panelSearch.getValue('COST_CODE_FR'));
							panelResult.setValue('COST_NAME_FR', panelSearch.getValue('COST_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('COST_CODE_FR', '');
						panelResult.setValue('COST_NAME_FR', '');
					}*/
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('COST_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('COST_NAME_FR', newValue);				
					}
				}
   	 		}),		    
		    	Unilite.popup('COST',{
		    	fieldLabel: '~',
	//	    	validateBlank:false,	
		    	autoPopup:false,
				valueFieldName: 'COST_CODE_TO',
		    	textFieldName: 'COST_NAME_TO',  			
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelResult.setValue('COST_CODE_TO', panelSearch.getValue('COST_CODE_TO'));
							panelResult.setValue('COST_NAME_TO', panelSearch.getValue('COST_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('COST_CODE_TO', '');
						panelResult.setValue('COST_NAME_TO', '');
					}*/
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('COST_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('COST_NAME_TO', newValue);				
					}
				}
	    	}),{
    			fieldLabel: '비용상태'	,
    			name:'COST_STS', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A035',
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COST_STS', newValue);
					}
				}
    		}]
		}, {
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [		    
		        Unilite.popup('DEPT',{
		        fieldLabel: '부서',
		        validateBlank:false,
		        autoPopup:false,
		        valueFieldName: 'DEPT_CODE_FR',
		    	textFieldName: 'DEPT_NAME_FR'
		    }),
		      	Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        validateBlank:false,
		        autoPopup:false,
		        valueFieldName: 'DEPT_CODE_TO',
		    	textFieldName: 'DEPT_NAME_TO'
		    })]		
		}]
	});    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
    			fieldLabel: '비용처리년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'FR_MONTH',
		        endFieldName: 'TO_MONTH',
		        width: 325,
		        //startDate: UniDate.get('startOfMonth'),
		        //endDate: UniDate.get('today'),
		        allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('FR_MONTH', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('TO_MONTH', newValue);				    		
			    	}
			    }
	        },{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			},		    
		    	Unilite.popup('COST',{
		    	fieldLabel: '기간비용',
		    	//validateBlank:false,
		    	autoPopup:false,
		    	valueFieldName: 'COST_CODE_FR',
		    	textFieldName: 'COST_NAME_FR',
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('COST_CODE_FR', panelResult.getValue('COST_CODE_FR'));
							panelSearch.setValue('COST_NAME_FR', panelResult.getValue('COST_NAME_FR'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('COST_CODE_FR', '');
						panelSearch.setValue('COST_NAME_FR', '');
					}*/
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('COST_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('COST_NAME_FR', newValue);				
					}
				}
   	 		}),		    
		    	Unilite.popup('COST',{
		    	fieldLabel: '~',
		    	//validateBlank:false,	
		    	autoPopup:false,
				valueFieldName: 'COST_CODE_TO',
		    	textFieldName: 'COST_NAME_TO',  			
				listeners: {
					/*onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('COST_CODE_TO', panelResult.getValue('COST_CODE_TO'));
							panelSearch.setValue('COST_NAME_TO', panelResult.getValue('COST_NAME_TO'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('COST_CODE_TO', '');
						panelSearch.setValue('COST_NAME_TO', '');
					}*/
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('COST_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('COST_NAME_TO', newValue);				
					}
				}
	    	}),{
    			fieldLabel: '비용상태'	,
    			name:'COST_STS', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A035',
    			listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COST_STS', newValue);
					}
				}
    		}]	
    }); 
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('agb170skrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore,
    	uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}	
		},
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [
        	       //{ dataIndex: 'GBN'				, 		width: 66, hidden: true	},
        		   { dataIndex: 'ITEM_CODE'			, 		width: 100	,align : 'center' },
        		   { dataIndex: 'ITEM_NAME'			, 		width: 250	},
        		   { dataIndex: 'AMT_I'				, 		width: 130	},
        		   { dataIndex: 'DPR_YYMM'			, 		width: 105	,align : 'center' , 
        		   		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				        	return Unilite.renderSummaryRow(summaryData, metaData, '소 계', '누 계');
		            	}
					},	
        		   { dataIndex: 'FB_DPR_TOT_I'		, 		width: 130	},
        		   { dataIndex: 'FB_BLN_I'			, 		width: 130	},
        		   { dataIndex: 'TM_DPR_I'			, 		width: 130	, summaryType: 'sum' },
        		   { dataIndex: 'FL_DPR_TOT_I'		, 		width: 130	},
        		   { dataIndex: 'FL_BLN_I'			, 		width: 130	},
        		   { dataIndex: 'DPR_STS'			, 		width: 88	},
        		   { dataIndex: 'EX_DATE'			, 		width: 133	},
        		   { dataIndex: 'EX_NUM'			, 		width: 88	,align : 'center'}        		   
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
		id  : 'agb170skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			
			panelSearch.setValue('FR_MONTH',getStDt[0].STDT);		
			panelResult.setValue('FR_MONTH',getStDt[0].STDT);
			panelSearch.setValue('TO_MONTH',UniDate.get('today'));
			panelResult.setValue('TO_MONTH',UniDate.get('today'));
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_MONTH');
			
			var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}else{
				directMasterStore.loadStoreRecords();	
				var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}	
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
	
	/*
	Unilite.createValidator('validator02', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			// 계획기간
			var frMonth = form.getField('FR_MONTH').getSubmitValue();  // 비용처리년월 fr
			var toMonth = form.getField('TO_MONTH').getSubmitValue();  // 비용처리년월 to
			
			switch(fieldName) {				
				case "FR_MONTH" : // 비용처리년월 fr
					if(toMonth < frMonth){
						alert('<t:message code="unilite.msg.sMB084"/>');
						//
						panelSearch.setValue('FR_MONTH',frMonth);
						panelResult.setValue('TO_MONTH',toMonth);						
						panelSearch.getField('FR_MONTH').focus();
						break;
					}
				case "TO_MONTH" : // 비용처리년월 fr
					if(toMonth < frMonth){
						alert('<t:message code="unilite.msg.sMB084"/>');
						//
						panelSearch.setValue('FR_MONTH',frMonth);
						panelResult.setValue('TO_MONTH',toMonth);						
						panelSearch.getField('FR_MONTH').focus();
						break;
					}	
			}
			return rv;
		}
	}); // validator02
	
	
	Unilite.createValidator('validator03', {
		forms: {'formB:':panelResult},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			// 계획기간
			var frMonth = form.getField('FR_MONTH').getSubmitValue();  // 비용처리년월 fr
			var toMonth = form.getField('TO_MONTH').getSubmitValue();  // 비용처리년월 to
			
			switch(fieldName) {				
				case "FR_MONTH" : // 비용처리년월 fr
					if(toMonth < frMonth){
						alert('<t:message code="unilite.msg.sMB084"/>');
						//
						panelSearch.setValue('FR_MONTH',frMonth);
						panelResult.setValue('TO_MONTH',toMonth);						
						panelSearch.getField('FR_MONTH').focus();
						break;
					}
				case "TO_MONTH" : // 비용처리년월 fr
					if(toMonth < frMonth){
						alert('<t:message code="unilite.msg.sMB084"/>');
						//
						panelSearch.setValue('FR_MONTH',frMonth);
						panelResult.setValue('TO_MONTH',toMonth);						
						panelSearch.getField('FR_MONTH').focus();
						break;
					}		
			}
			return rv;
		}
	}); // validator03
*/
};


</script>
