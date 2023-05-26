<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc165skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var fnSetFormTitle = ${fnSetFormTitle};

var BsaCodeInfo =  {
	gsFinancialY: '${gsFinancialY}'
}

function appMain() {     
	var len = fnSetFormTitle.length; 
	var tabTitle1 ='손익계산서';
	var tabTitle2 ='제조원가명세서';
	
	var hideTab1  = true;
	var hideTab2  = true;
	
	for(var i=0 ; i < len ; i++) { 
		if(fnSetFormTitle[i].SUB_CODE == '20'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab1 = false;
			}
			tabTitle1 = fnSetFormTitle[i].CODE_NAME;
		}
		if(fnSetFormTitle[i].SUB_CODE == '30'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab2 = false;
			}
			tabTitle2 = fnSetFormTitle[i].CODE_NAME;
		}
	}
	
	var getStDt = ${getStDt};// 당기시작년월
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agc165skrModel', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'	, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I'	, text: '합계'		,type: 'uniPrice'},
		    {name: 'AMT_I1'		, text: '금액' 		,type: 'uniPrice'},
		    {name: 'AMT_I2'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I3'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I4'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I5'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I6'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'RATE_1'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_2'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_3'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_4'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_5'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_6'		, text: '비율'		,type: 'uniPercent'}
		]          
	});
	
	Unilite.defineModel('Agc165skrModel2', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'	, text: '항목명' 		,type: 'string'},
		    {name: 'TOT_AMT_I'	, text: '합계'		,type: 'uniPrice'},
		    {name: 'AMT_I1'		, text: '금액' 		,type: 'uniPrice'},
		    {name: 'AMT_I2'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I3'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I4'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I5'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'AMT_I6'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'RATE_1'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_2'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_3'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_4'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_5'		, text: '비율'		,type: 'uniPercent'},
		    {name: 'RATE_6'		, text: '비율'		,type: 'uniPercent'}
		]          
	});
	  
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agc165skrMasterStore1',{
		model	: 'Agc165skrModel',
		uniOpt	: {
            isMaster	: true,				// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
           type: 'direct',
            api: {			
                read: 'agc165skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('agc165skrMasterStore2',{
		model	: 'Agc165skrModel2',
		uniOpt	: {
            isMaster	: true,				// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
           type: 'direct',
            api: {			
                read: 'agc165skrService.selectList2'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1, tableAttrs: {width: '100%'}
//			,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
           	},
           	defaultType	: 'uniTextfield',
		    items		: [{ 
	        	fieldLabel		: '전표일',
				xtype			: 'uniDateRangefield',  
				startFieldName	: 'DATE_FR',
				endFieldName	: 'DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR',newValue);
						UniAppManager.app.fnSetStDate(newValue);
                	}   
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO',newValue);
			    	}   	
			    }
			},{	            		
				fieldLabel	: '구분',	
	    		xtype		: 'radiogroup',						            		
				id			: 'rdoSelect1-1',
				items		: [{
					boxLabel	: '사업단위', 
					name		: 'UNIT',
	    			inputValue	: 'E1',
					width		: 90, 
					checked		: true  
				},{
					boxLabel	: '제품단위', 
					name		: 'UNIT',
	    			inputValue	: 'B1',
					width		: 90
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('UNIT', newValue.UNIT);
		
						if(newValue.UNIT == 'E1'){
							masterGrid.down('#CHANGE_NAME1').setText('사업코드1');
							masterGrid.down('#CHANGE_NAME2').setText('사업코드2');
							masterGrid.down('#CHANGE_NAME3').setText('사업코드3');
							masterGrid.down('#CHANGE_NAME4').setText('사업코드4');
							masterGrid.down('#CHANGE_NAME5').setText('사업코드5');
							masterGrid.down('#CHANGE_NAME6').setText('사업코드6');

						} else {
							masterGrid.down('#CHANGE_NAME1').setText('제품코드1');
							masterGrid.down('#CHANGE_NAME2').setText('제품코드2');
							masterGrid.down('#CHANGE_NAME3').setText('제품코드3');
							masterGrid.down('#CHANGE_NAME4').setText('제품코드4');
							masterGrid.down('#CHANGE_NAME5').setText('제품코드5');
							masterGrid.down('#CHANGE_NAME6').setText('제품코드6');
						}
						
						fnSetViewComponent(newValue.UNIT);							
					}
				}
			},{
			xtype: 'container',
			layout : {type : 'vbox', align : 'stretch'},
	    	items:[
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드1',
	    			itemId			: 'pjtCodePopup1',
					valueFieldName	: 'AC_PROJECT_CODE1',
					textFieldName	: 'AC_PROJECT_NAME1',
					valuesName		: 'DEPTS1',
					selectChildren	: true,
					DBvalueFieldName: 'PJT_CODE',
					DBtextFieldName	: 'PJT_NAME',
					autoPopup		: true,
					useLike			: false,
					allowBlank		: false,
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_CODE1',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_NAME1',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelResult.getField('DEPTS1') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드2',
	    			itemId			: 'pjtCodePopup2',
					valueFieldName	: 'AC_PROJECT_CODE2',
					textFieldName	: 'AC_PROJECT_NAME2',
					valuesName		: 'DEPTS2',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_CODE2',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_NAME2',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelResult.getField('DEPTS2') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드3',
	    			itemId			: 'pjtCodePopup3',
					valueFieldName	: 'AC_PROJECT_CODE3',
					textFieldName	: 'AC_PROJECT_NAME3',
					valuesName		: 'DEPTS3',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_CODE3',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_NAME3',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelResult.getField('DEPTS3') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드4',
	    			itemId			: 'pjtCodePopup4',
					valueFieldName	: 'AC_PROJECT_CODE4',
					textFieldName	: 'AC_PROJECT_NAME4',
					valuesName		: 'DEPTS4',
			    	listeners: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_CODE4',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_NAME4',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelResult.getField('DEPTS4') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드5',
	    			itemId			: 'pjtCodePopup5',
					valueFieldName	: 'AC_PROJECT_CODE5',
					textFieldName	: 'AC_PROJECT_NAME5',
					valuesName		: 'DEPTS5',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_CODE5',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_NAME5',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelResult.getField('DEPTS5') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel: '사업코드6',
	    			itemId			: 'pjtCodePopup6',
					valueFieldName	: 'AC_PROJECT_CODE6',
					textFieldName	: 'AC_PROJECT_NAME6',
					valuesName		: 'DEPTS6',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_CODE6',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelResult.setValue('AC_PROJECT_NAME6',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelResult.getField('DEPTS6') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드1',
		        	itemId			: 'itemCodePopup1',
		        	valueFieldName	: 'CUST_ITEM_CODE1',
		        	textFieldName	: 'CUST_ITEM_NAME1',
					allowBlank		: false,
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_ITEM_CODE1', panelSearch.getValue('CUST_ITEM_CODE1'));
								panelResult.setValue('CUST_ITEM_NAME1', panelSearch.getValue('CUST_ITEM_NAME1'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUST_ITEM_CODE1', '');
							panelResult.setValue('CUST_ITEM_NAME1', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드2',
		        	itemId			: 'itemCodePopup2',
		        	valueFieldName	: 'CUST_ITEM_CODE2',
		        	textFieldName	: 'CUST_ITEM_NAME2',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_ITEM_CODE2', panelSearch.getValue('CUST_ITEM_CODE2'));
								panelResult.setValue('CUST_ITEM_NAME2', panelSearch.getValue('CUST_ITEM_NAME2'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUST_ITEM_CODE2', '');
							panelResult.setValue('CUST_ITEM_NAME2', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드3',
		        	itemId			: 'itemCodePopup3',
		        	valueFieldName	: 'CUST_ITEM_CODE3',
		        	textFieldName	: 'CUST_ITEM_NAME3',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_ITEM_CODE3', panelSearch.getValue('CUST_ITEM_CODE3'));
								panelResult.setValue('CUST_ITEM_NAME3', panelSearch.getValue('CUST_ITEM_NAME3'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUST_ITEM_CODE3', '');
							panelResult.setValue('CUST_ITEM_NAME3', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드4',
		        	itemId			: 'itemCodePopup4',
		        	valueFieldName	: 'CUST_ITEM_CODE4',
		        	textFieldName	: 'CUST_ITEM_NAME4',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_ITEM_CODE4', panelSearch.getValue('CUST_ITEM_CODE4'));
								panelResult.setValue('CUST_ITEM_NAME4', panelSearch.getValue('CUST_ITEM_NAME4'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUST_ITEM_CODE4', '');
							panelResult.setValue('CUST_ITEM_NAME4', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드5',
		        	itemId			: 'itemCodePopup5',
		        	valueFieldName	: 'CUST_ITEM_CODE5',
		        	textFieldName	: 'CUST_ITEM_NAME5',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_ITEM_CODE5', panelSearch.getValue('CUST_ITEM_CODE5'));
								panelResult.setValue('CUST_ITEM_NAME5', panelSearch.getValue('CUST_ITEM_NAME5'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUST_ITEM_CODE5', '');
							panelResult.setValue('CUST_ITEM_NAME5', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드6',
		        	itemId			: 'itemCodePopup6',
		        	valueFieldName	: 'CUST_ITEM_CODE6',
		        	textFieldName	: 'CUST_ITEM_NAME6',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUST_ITEM_CODE6', panelSearch.getValue('CUST_ITEM_CODE6'));
								panelResult.setValue('CUST_ITEM_NAME6', panelSearch.getValue('CUST_ITEM_NAME6'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('CUST_ITEM_CODE6', '');
							panelResult.setValue('CUST_ITEM_NAME6', '');
						}
					}
		        })
	    	]}
		]},{
			title		:'추가정보',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
    		defaultType	: 'uniTextfield',
    		layout		: {type : 'uniTable', columns : 1},
    		defaultType	: 'uniTextfield',
    		items		: [{
		 		fieldLabel: '당기시작년월',
		 		xtype: 'uniMonthfield',
		 		name: 'START_DATE',
		 		allowBlank:false
			},{
		 		fieldLabel: '금액단위',
		 		name:'AMT_UNIT', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B042',
		 		allowBlank:false,
		 		listeners: {
				    afterrender: function(combo) {
				        var recordSelected = combo.getStore().getAt(0);                     
				        combo.setValue(recordSelected.get('value'));
				    }
				}
	 		},{
		 		fieldLabel: '재무제표양식차수',
		 		name:'GUBUN', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'A093',
		 		value: BsaCodeInfo.gsFinancialY,
		 		allowBlank:false
	 		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목명',		
				items: [{
					boxLabel: '과목명1', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '0'
				},{
					boxLabel : '과목명2', 
					width: 70,
					name: 'ACCOUNT_NAME',
					inputValue: '1'
				},{
					boxLabel: '과목명3', 
					width: 70, 
					name: 'ACCOUNT_NAME',
					inputValue: '2' 
				}]
	 		}]			
		}]	
	});	//end panelSearch  
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
        	fieldLabel		: '전표일',
			xtype			: 'uniDateRangefield',  
			startFieldName	: 'DATE_FR',
			endFieldName	: 'DATE_TO',
			allowBlank		: false,
	        tdAttrs			: {width: 380},  
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR',newValue);
					UniAppManager.app.fnSetStDate(newValue);
            	}   
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DATE_TO',newValue);
		    	}   	
		    }
		},{	            		
			fieldLabel	: '구분',	
    		xtype		: 'radiogroup',						            		
			id			: 'rdoSelect1-2',
			tdAttrs		: {align: 'left', width: 380},
			items		: [{
				boxLabel	: '사업단위', 
				name		: 'UNIT',
    			inputValue	: 'E1',
				width		: 90, 
				checked		: true  
			},{
				boxLabel	: '제품단위', 
				name		: 'UNIT',
    			inputValue	: 'B1',
				width		: 90
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('UNIT', newValue.UNIT);
	
					if(newValue.UNIT == 'E1'){
						masterGrid.down('#CHANGE_NAME1').setText('사업코드1');
						masterGrid.down('#CHANGE_NAME2').setText('사업코드2');
						masterGrid.down('#CHANGE_NAME3').setText('사업코드3');
						masterGrid.down('#CHANGE_NAME4').setText('사업코드4');
						masterGrid.down('#CHANGE_NAME5').setText('사업코드5');
						masterGrid.down('#CHANGE_NAME6').setText('사업코드6');

					} else {
						masterGrid.down('#CHANGE_NAME1').setText('제품코드1');
						masterGrid.down('#CHANGE_NAME2').setText('제품코드2');
						masterGrid.down('#CHANGE_NAME3').setText('제품코드3');
						masterGrid.down('#CHANGE_NAME4').setText('제품코드4');
						masterGrid.down('#CHANGE_NAME5').setText('제품코드5');
						masterGrid.down('#CHANGE_NAME6').setText('제품코드6');
					}
					
					fnSetViewComponent(newValue.UNIT);							
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'vbox', align : 'stretch'},
	    	items	: [
		    	Unilite.treePopup('PJT_TREE',{ 
			    	fieldLabel		: '사업코드1',
	        		itemId			: 'pjtCodePopup1',
			    	valueFieldName	: 'AC_PROJECT_CODE1',
					textFieldName	: 'AC_PROJECT_NAME1',
					valuesName		: 'DEPTS1',
					DBvalueFieldName: 'PJT_CODE',
					DBtextFieldName	: 'PJT_NAME',
					selectChildren	: true,
					autoPopup		: true,
					useLike			: false,
					allowBlank		: false,
			    	listeners: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelSearch.setValue('AC_PROJECT_CODE1',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelSearch.setValue('AC_PROJECT_NAME1',newValue);
						},
		                'onValuesChange':  function( field, records){
	                    	var tagfield = panelSearch.getField('DEPTS1') ;
	                    	tagfield.setStoreData(records)
		                }/*,
						onTextSpecialKey: function(elm, e){
		                    if (e.getKey() == e.ENTER) {
								masterStore.loadStoreRecords();
		                    }
		                }*/
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드3',
		    		itemId			: 'pjtCodePopup3',
					valueFieldName	: 'AC_PROJECT_CODE3',
					textFieldName	: 'AC_PROJECT_NAME3',
					valuesName		: 'DEPTS3',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_CODE3',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_NAME3',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelSearch.getField('DEPTS3') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드5',
		    		itemId			: 'pjtCodePopup5',
					valueFieldName	: 'AC_PROJECT_CODE5',
					textFieldName	: 'AC_PROJECT_NAME5',
					valuesName		: 'DEPTS5',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_CODE5',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_NAME5',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelSearch.getField('DEPTS5') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드1',
		        	itemId			: 'itemCodePopup1',
		        	valueFieldName	: 'CUST_ITEM_CODE1',
		        	textFieldName	: 'CUST_ITEM_NAME1',
					allowBlank		: false,
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_ITEM_CODE1', panelResult.getValue('CUST_ITEM_CODE1'));
								panelSearch.setValue('CUST_ITEM_NAME1', panelResult.getValue('CUST_ITEM_NAME1'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_ITEM_CODE1', '');
							panelSearch.setValue('CUST_ITEM_NAME1', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드3',
		        	itemId			: 'itemCodePopup3',
		        	valueFieldName	: 'CUST_ITEM_CODE3',
		        	textFieldName	: 'CUST_ITEM_NAME3',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_ITEM_CODE3', panelResult.getValue('CUST_ITEM_CODE3'));
								panelSearch.setValue('CUST_ITEM_NAME3', panelResult.getValue('CUST_ITEM_NAME3'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_ITEM_CODE3', '');
							panelSearch.setValue('CUST_ITEM_NAME3', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드5',
		        	itemId			: 'itemCodePopup5',
		        	valueFieldName	: 'CUST_ITEM_CODE5',
		        	textFieldName	: 'CUST_ITEM_NAME5',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_ITEM_CODE5', panelResult.getValue('CUST_ITEM_CODE5'));
								panelSearch.setValue('CUST_ITEM_NAME5', panelResult.getValue('CUST_ITEM_NAME5'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_ITEM_CODE5', '');
							panelSearch.setValue('CUST_ITEM_NAME5', '');
						}
					}
		        })
	    	]},{
			xtype	: 'container',
			layout	: {type : 'vbox', align : 'stretch'},
	    	items	: [
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드2',
		    		itemId			: 'pjtCodePopup2',
					valueFieldName	: 'AC_PROJECT_CODE2',
					textFieldName	: 'AC_PROJECT_NAME2',
					valuesName		: 'DEPTS2',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_CODE2',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_NAME2',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelSearch.getField('DEPTS2') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드4',
		    		itemId			: 'pjtCodePopup4',
					valueFieldName	: 'AC_PROJECT_CODE4',
					textFieldName	: 'AC_PROJECT_NAME4',
					valuesName		: 'DEPTS4',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_CODE4',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_NAME4',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelSearch.getField('DEPTS4') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
				Unilite.treePopup('PJT_TREE',{ 
					fieldLabel		: '사업코드6',
		    		itemId			: 'pjtCodePopup6',
					valueFieldName	: 'AC_PROJECT_CODE6',
					textFieldName	: 'AC_PROJECT_NAME6',
					valuesName		: 'DEPTS6',
			    	listeners		: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_CODE6',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelSearch.setValue('AC_PROJECT_NAME6',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelSearch.getField('DEPTS6') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드2',
		        	itemId			: 'itemCodePopup2',
		        	valueFieldName	: 'CUST_ITEM_CODE2',
		        	textFieldName	: 'CUST_ITEM_NAME2',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_ITEM_CODE2', panelResult.getValue('CUST_ITEM_CODE2'));
								panelSearch.setValue('CUST_ITEM_NAME2', panelResult.getValue('CUST_ITEM_NAME2'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_ITEM_CODE2', '');
							panelSearch.setValue('CUST_ITEM_NAME2', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드4',
		        	itemId			: 'itemCodePopup4',
		        	valueFieldName	: 'CUST_ITEM_CODE4',
		        	textFieldName	: 'CUST_ITEM_NAME4',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_ITEM_CODE4', panelResult.getValue('CUST_ITEM_CODE4'));
								panelSearch.setValue('CUST_ITEM_NAME4', panelResult.getValue('CUST_ITEM_NAME4'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_ITEM_CODE4', '');
							panelSearch.setValue('CUST_ITEM_NAME4', '');
						}
					}
		        }),
		    	Unilite.popup('ITEM',{
		        	fieldLabel		: '제품코드6',
		        	itemId			: 'itemCodePopup6',
		        	valueFieldName	: 'CUST_ITEM_CODE6',
		        	textFieldName	: 'CUST_ITEM_NAME6',
		        	listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('CUST_ITEM_CODE6', panelResult.getValue('CUST_ITEM_CODE6'));
								panelSearch.setValue('CUST_ITEM_NAME6', panelResult.getValue('CUST_ITEM_NAME6'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('CUST_ITEM_CODE6', '');
							panelSearch.setValue('CUST_ITEM_NAME6', '');
						}
					}
		        })
	    	]}
        ]	
    });
	
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('agc165skrGrid1', {
    	title  : tabTitle1,
    	hidden : hideTab1,
    	excelTitle: '사업별재무제표' + '   (' + tabTitle1 + ')',
    	layout : 'fit',
        store : directMasterStore, 
        uniOpt : {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
		    	filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		if(masterGrid.getSelectedRecords().length > 0 ){
		    			alert("출력 레포트를 만들어주세요.");
			    		}
			    		else{
			    			alert("선택된 자료가 없습니다.");
			    		}
	        		}
        	}
        ],
        columns: [        
        	{dataIndex: 'ACCNT_NAME'	, width: 180}, 				
			{dataIndex: 'TOT_AMT_I'		, width: 133},
			{itemId:'CHANGE_NAME1',
					columns:[{ dataIndex: 'AMT_I1'		, width: 150},
							 { dataIndex: 'RATE_1'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME2',
					columns:[{ dataIndex: 'AMT_I2'		, width: 150},
							 { dataIndex: 'RATE_2'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME3',
					columns:[{ dataIndex: 'AMT_I3'		, width: 150},
							 { dataIndex: 'RATE_3'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME4',
					columns:[{ dataIndex: 'AMT_I4'		, width: 150},
							 { dataIndex: 'RATE_4'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME5',
					columns:[{ dataIndex: 'AMT_I5'		, width: 150},
							 { dataIndex: 'RATE_5'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME6',
					columns:[{ dataIndex: 'AMT_I6'		, width: 150},
							 { dataIndex: 'RATE_6'		, width: 70}
					]	
			}
		]              	        
    });                  
    
	var masterGrid2 = Unilite.createGrid('agc165skrGrid2', {
    	title  : tabTitle2,
    	hidden : hideTab2,
    	excelTitle: '사업별별재무제표' + '   (' + tabTitle1 + ')',
    	layout : 'fit',
        store : directMasterStore2, 
        uniOpt : {
			useMultipleSorting	: true,			 
	    	useLiveSearch		: true,			
	    	onLoadSelectFirst	: true,		
	    	dblClickToEdit		: false,		
	    	useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,			
			expandLastColumn	: true,		
			useRowContext		: true,			
		    	filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
    	tbar:[
        	'->',
        	{
	        	xtype:'button',
	        	text:'출력',
	        	handler:function()	{
	        		if(masterGrid2.getSelectedRecords().length > 0 ){
		    			alert("출력 레포트를 만들어주세요.");
			    		}
			    		else{
			    			alert("선택된 자료가 없습니다.");
			    		}
	        		}
        	}
        ],
        columns: [        
        	{dataIndex: 'ACCNT_NAME'	, width: 180}, 				
			{dataIndex: 'TOT_AMT_I'		, width: 133},
			{itemId:'CHANGE_NAME7',
					columns:[{ dataIndex: 'AMT_I1'		, width: 150},
							 { dataIndex: 'RATE_1'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME8',
					columns:[{ dataIndex: 'AMT_I2'		, width: 150},
							 { dataIndex: 'RATE_2'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME9',
					columns:[{ dataIndex: 'AMT_I3'		, width: 150},
							 { dataIndex: 'RATE_3'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME10',
					columns:[{ dataIndex: 'AMT_I4'		, width: 150},
							 { dataIndex: 'RATE_4'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME11',
					columns:[{ dataIndex: 'AMT_I5'		, width: 150},
							 { dataIndex: 'RATE_5'		, width: 70}
					]	
			},
			{itemId:'CHANGE_NAME12',
					columns:[{ dataIndex: 'AMT_I6'		, width: 150},
							 { dataIndex: 'RATE_6'		, width: 70}
					]	
			}
		]              	        
    });
    
	var tab = Unilite.createTabPanel('tabPanel',{
    	region:'center',
	    items: [
	         masterGrid,
	         masterGrid2
	    ],
	    listeners:{
	    	beforetabchange: function( tabPanel, newCard, oldCard, eOpts ) {	
    			if(!UniAppManager.app.fnCheckData(true)){
					return false;
				}
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
    		},
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			
    			if(newCard.getItemId() == 'agc165skrGrid1')	{
    				UniAppManager.app.onQueryButtonDown();
    				
    			} else if(newCard.getItemId() == 'agc165skrGrid2') {
    				UniAppManager.app.onQueryButtonDown();
    			}
    		}
    	}
    });
    
    
    
	Unilite.Main({
		id			: 'agc165skrApp',
	 	border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
					tab, panelResult
			]
		},
		panelSearch  	
		],
		
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		
			panelSearch.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_FR',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('DATE_TO',UniDate.get('today'));
			panelResult.setValue('DATE_TO',UniDate.get('today'));
			
			panelSearch.setValue('START_DATE',getStDt[0].STDT);
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			
			/* 그리드 기본 값 */
			masterGrid.down('#CHANGE_NAME1').setText('사업코드1');
			masterGrid.down('#CHANGE_NAME2').setText('사업코드2');
			masterGrid.down('#CHANGE_NAME3').setText('사업코드3');
			masterGrid.down('#CHANGE_NAME4').setText('사업코드4');
			masterGrid.down('#CHANGE_NAME5').setText('사업코드5');
			masterGrid.down('#CHANGE_NAME6').setText('사업코드6');
			fnSetViewComponent('E1');
		},
		
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'agc165skrGrid1'){	
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
					masterGrid.down('#CHANGE_NAME1').setText(panelSearch.getValue('AC_PROJECT_NAME1'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
					masterGrid.down('#CHANGE_NAME1').setText('사업코드1');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME2'))){
					masterGrid.down('#CHANGE_NAME2').setText(panelSearch.getValue('AC_PROJECT_NAME2'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME2'))){
					masterGrid.down('#CHANGE_NAME2').setText('사업코드2');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME3'))){
					masterGrid.down('#CHANGE_NAME3').setText(panelSearch.getValue('AC_PROJECT_NAME3'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME3'))){
					masterGrid.down('#CHANGE_NAME3').setText('사업코드3');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME4'))){
					masterGrid.down('#CHANGE_NAME4').setText(panelSearch.getValue('AC_PROJECT_NAME4'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
					masterGrid.down('#CHANGE_NAME4').setText('사업코드4');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME5'))){
					masterGrid.down('#CHANGE_NAME5').setText(panelSearch.getValue('AC_PROJECT_NAME5'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME5'))){
					masterGrid.down('#CHANGE_NAME5').setText('사업코드5');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME6'))){
					masterGrid.down('#CHANGE_NAME6').setText(panelSearch.getValue('AC_PROJECT_NAME6'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME6'))){
					masterGrid.down('#CHANGE_NAME6').setText('사업코드6');
				}
				directMasterStore.loadStoreRecords();
				
			} else if(activeTabId == 'agc165skrGrid2'){	
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
					masterGrid2.down('#CHANGE_NAME7').setText(panelSearch.getValue('AC_PROJECT_NAME1'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME1'))){
					masterGrid2.down('#CHANGE_NAME7').setText('사업코드1');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME2'))){
					masterGrid2.down('#CHANGE_NAME8').setText(panelSearch.getValue('AC_PROJECT_NAME2'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME2'))){
					masterGrid2.down('#CHANGE_NAME8').setText('사업코드2');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME3'))){
					masterGrid2.down('#CHANGE_NAME9').setText(panelSearch.getValue('AC_PROJECT_NAME3'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME3'))){
					masterGrid2.down('#CHANGE_NAME9').setText('사업코드3');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME4'))){
					masterGrid2.down('#CHANGE_NAME10').setText(panelSearch.getValue('AC_PROJECT_NAME4'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME4'))){
					masterGrid2.down('#CHANGE_NAME10').setText('사업코드4');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME5'))){
					masterGrid2.down('#CHANGE_NAME11').setText(panelSearch.getValue('AC_PROJECT_NAME5'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME5'))){
					masterGrid2.down('#CHANGE_NAME11').setText('사업코드5');
				}
				
				if(!Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME6'))){
					masterGrid2.down('#CHANGE_NAME12').setText(panelSearch.getValue('AC_PROJECT_NAME6'));
				}
				else if(Ext.isEmpty(panelSearch.getValue('AC_PROJECT_NAME6'))){
					masterGrid2.down('#CHANGE_NAME12').setText('사업코드6');
				}
				directMasterStore2.loadStoreRecords();			
			}	
		},
		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
				
			}else {
				as.hide()
			}
		},
		
		fnCheckData:function(newValue){
			var dateFr = panelSearch.getField('DATE_FR').getSubmitValue();  // 전표일 FR
			var dateTo = panelSearch.getField('DATE_TO').getSubmitValue();  // 전표일 TO
			// 전기전표일
			var r= true
			
			if(dateFr > dateTo) {
				alert('시작일이 종료일보다 클수는 없습니다.');
				//당기전표일: 시작일이 종료일보다 클수는 없습니다.
				//alert('<t:message code="unilite.msg.sMAW036"/>' + '<t:message code="unilite.msg.sMB084"/>');
				panelSearch.setValue('DATE_FR',dateFr);
				panelResult.setValue('DATE_FR',dateFr);						
				panelSearch.getField('DATE_FR').focus();
				r = false;
				return false;
			}
			return r;
		},
		
		fnSetStDate:function(newValue) {
        	if (newValue == null){
				return false;
			
			} else {
		    	if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				
				} else {
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
        }
	});

	
	
	function fnSetViewComponent (flag) {							//라디오 버튼 변경에 따른 searchpanel 구성요소 변경
		var pjtFlag		= true;
		var itemFlag	= true;

		if (flag == 'E1') {											//"사업단위"이면
			pjtFlag		= true;
			itemFlag	= false;
			
		} else {
			pjtFlag		= false;
			itemFlag	= true;
		}
		//라디오 버튼 select에 따른 필수 여부 변경
		panelSearch.getField('AC_PROJECT_CODE1').allowBlank = itemFlag;
		panelSearch.getField('AC_PROJECT_NAME1').allowBlank = itemFlag;
		panelSearch.getField('DEPTS1').allowBlank = itemFlag;
		panelResult.getField('AC_PROJECT_CODE1').allowBlank = itemFlag;
		panelResult.getField('AC_PROJECT_NAME1').allowBlank = itemFlag;
		panelResult.getField('DEPTS1').allowBlank = itemFlag;

		panelSearch.getField('CUST_ITEM_CODE1').setConfig('allowBlank', pjtFlag);
		panelSearch.getField('CUST_ITEM_NAME1').setConfig('allowBlank', pjtFlag);
		panelResult.getField('CUST_ITEM_CODE1').setConfig('allowBlank', pjtFlag);
		panelResult.getField('CUST_ITEM_NAME1').setConfig('allowBlank', pjtFlag);

		//라디오 버튼 select에 따라 보이는 필드 변경
		panelSearch.down('#pjtCodePopup1').setVisible(pjtFlag);
		panelSearch.down('#pjtCodePopup2').setVisible(pjtFlag);
		panelSearch.down('#pjtCodePopup3').setVisible(pjtFlag);
		panelSearch.down('#pjtCodePopup4').setVisible(pjtFlag);
		panelSearch.down('#pjtCodePopup5').setVisible(pjtFlag);
		panelSearch.down('#pjtCodePopup6').setVisible(pjtFlag);
		panelSearch.down('#itemCodePopup1').setVisible(itemFlag);
		panelSearch.down('#itemCodePopup2').setVisible(itemFlag);
		panelSearch.down('#itemCodePopup3').setVisible(itemFlag);
		panelSearch.down('#itemCodePopup4').setVisible(itemFlag);
		panelSearch.down('#itemCodePopup5').setVisible(itemFlag);
		panelSearch.down('#itemCodePopup6').setVisible(itemFlag);

		panelResult.down('#pjtCodePopup1').setVisible(pjtFlag);
		panelResult.down('#pjtCodePopup2').setVisible(pjtFlag);
		panelResult.down('#pjtCodePopup3').setVisible(pjtFlag);
		panelResult.down('#pjtCodePopup4').setVisible(pjtFlag);
		panelResult.down('#pjtCodePopup5').setVisible(pjtFlag);
		panelResult.down('#pjtCodePopup6').setVisible(pjtFlag);
		panelResult.down('#itemCodePopup1').setVisible(itemFlag);
		panelResult.down('#itemCodePopup2').setVisible(itemFlag);
		panelResult.down('#itemCodePopup3').setVisible(itemFlag);
		panelResult.down('#itemCodePopup4').setVisible(itemFlag);
		panelResult.down('#itemCodePopup5').setVisible(itemFlag);
		panelResult.down('#itemCodePopup6').setVisible(itemFlag);
		
		//라디오 버튼 select에 따라 보이는 필드 변경
		if (pjtFlag) {
			panelSearch.setValue('CUST_ITEM_CODE1', '');
			panelSearch.setValue('CUST_ITEM_NAME1', '');
			panelSearch.setValue('CUST_ITEM_CODE2', '');
			panelSearch.setValue('CUST_ITEM_NAME2', '');
			panelSearch.setValue('CUST_ITEM_CODE3', '');
			panelSearch.setValue('CUST_ITEM_NAME3', '');
			panelSearch.setValue('CUST_ITEM_CODE4', '');
			panelSearch.setValue('CUST_ITEM_NAME4', '');
			panelSearch.setValue('CUST_ITEM_CODE5', '');
			panelSearch.setValue('CUST_ITEM_NAME5', '');
			panelSearch.setValue('CUST_ITEM_CODE6', '');
			panelSearch.setValue('CUST_ITEM_NAME6', '');
			
			panelResult.setValue('CUST_ITEM_CODE1', '');
			panelResult.setValue('CUST_ITEM_NAME1', '');
			panelResult.setValue('CUST_ITEM_CODE2', '');
			panelResult.setValue('CUST_ITEM_NAME2', '');
			panelResult.setValue('CUST_ITEM_CODE3', '');
			panelResult.setValue('CUST_ITEM_NAME3', '');
			panelResult.setValue('CUST_ITEM_CODE4', '');
			panelResult.setValue('CUST_ITEM_NAME4', '');
			panelResult.setValue('CUST_ITEM_CODE5', '');
			panelResult.setValue('CUST_ITEM_NAME5', '');
			panelResult.setValue('CUST_ITEM_CODE6', '');
			panelResult.setValue('CUST_ITEM_NAME6', '');
			
		} else {
			panelSearch.setValue('AC_PROJECT_CODE1', '');
			panelSearch.setValue('AC_PROJECT_NAME1', '');
			panelSearch.setValue('DEPTS1', '');
			panelSearch.setValue('AC_PROJECT_CODE2', '');
			panelSearch.setValue('AC_PROJECT_NAME2', '');
			panelSearch.setValue('DEPTS2', '');
			panelSearch.setValue('AC_PROJECT_CODE3', '');
			panelSearch.setValue('AC_PROJECT_NAME3', '');
			panelSearch.setValue('DEPTS3', '');
			panelSearch.setValue('AC_PROJECT_CODE4', '');
			panelSearch.setValue('AC_PROJECT_NAME4', '');
			panelSearch.setValue('DEPTS4', '');
			panelSearch.setValue('AC_PROJECT_CODE5', '');
			panelSearch.setValue('AC_PROJECT_NAME5', '');
			panelSearch.setValue('DEPTS5', '');
			panelSearch.setValue('AC_PROJECT_CODE6', '');
			panelSearch.setValue('AC_PROJECT_NAME6', '');
			panelSearch.setValue('DEPTS6', '');
			
			panelResult.setValue('AC_PROJECT_CODE1', '');
			panelResult.setValue('AC_PROJECT_NAME1', '');
			panelResult.setValue('DEPTS1', '');
			panelResult.setValue('AC_PROJECT_CODE2', '');
			panelResult.setValue('AC_PROJECT_NAME2', '');
			panelResult.setValue('DEPTS2', '');
			panelResult.setValue('AC_PROJECT_CODE3', '');
			panelResult.setValue('AC_PROJECT_NAME3', '');
			panelResult.setValue('DEPTS3', '');
			panelResult.setValue('AC_PROJECT_CODE4', '');
			panelResult.setValue('AC_PROJECT_NAME4', '');
			panelResult.setValue('DEPTS4', '');
			panelResult.setValue('AC_PROJECT_CODE5', '');
			panelResult.setValue('AC_PROJECT_NAME5', '');
			panelResult.setValue('DEPTS5', '');
			panelResult.setValue('AC_PROJECT_CODE6', '');
			panelResult.setValue('AC_PROJECT_NAME6', '');
			panelResult.setValue('DEPTS6', '');
		}
	}
};


</script>
