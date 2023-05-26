<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agc200skr"  >
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
	
	var hideTab1  = true;
	
	for(var i=0 ; i < len ; i++) { 
		if(fnSetFormTitle[i].SUB_CODE == '20'){
			if(fnSetFormTitle[i].USE_YN == 'Y'){
				hideTab1 = false;
			}
			tabTitle1 = fnSetFormTitle[i].CODE_NAME;
		}
	}
	
	var getStDt = ${getStDt};// 당기시작년월
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('agc200skrModel', {
	    fields: [  	  
	    	{name: 'ACCNT_NAME'	    , text: '항목명' 	    ,type: 'string'},
		    {name: 'TOTAL_AMT'	    , text: '합계'		,type: 'uniPrice'},
		    {name: 'DEPT_AMT_1'		, text: '금액' 		,type: 'uniPrice'},
		    {name: 'DEPT_AMT_2'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'DEPT_AMT_3'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'DEPT_AMT_4'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'DEPT_AMT_5'		, text: '금액'		,type: 'uniPrice'},
		    {name: 'DEPT_AMT_6'		, text: '금액'		,type: 'uniPrice'}
		]          
	});
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agc200skrMasterStore1',{
		model	: 'agc200skrModel',
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
                read: 'agc200skrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();	
			param.DIV_CODE = UserInfo.divCode;
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
			},
			Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드1',
                itemId          : 'deptCodePopup1',
                valueFieldName  : 'DEPT_CODE1',
                textFieldName   : 'DEPT_NAME1',
                valuesName      : 'DEPTS1',
                selectChildren  : true,
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                autoPopup       : true,
                useLike         : false,
                allowBlank      : false,
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_CODE1',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_NAME1',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelResult.getField('DEPTS1') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드2',
                itemId          : 'deptCodePopup2',
                valueFieldName  : 'DEPT_CODE2',
                textFieldName   : 'DEPT_NAME2',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS2',
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_CODE2',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_NAME2',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelResult.getField('DEPTS2') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드3',
                itemId          : 'deptCodePopup3',
                valueFieldName  : 'DEPT_CODE3',
                textFieldName   : 'DEPT_NAME3',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS3',
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_CODE3',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_NAME3',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelResult.getField('DEPTS3') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드4',
                itemId          : 'deptCodePopup4',
                valueFieldName  : 'DEPT_CODE4',
                textFieldName   : 'DEPT_NAME4',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS4',
                listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_CODE4',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_NAME4',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelResult.getField('DEPTS4') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드5',
                itemId          : 'deptCodePopup5',
                valueFieldName  : 'DEPT_CODE5',
                textFieldName   : 'DEPT_NAME5',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS5',
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_CODE5',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_NAME5',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelResult.getField('DEPTS5') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel: '부서코드6',
                itemId          : 'deptCodePopup6',
                valueFieldName  : 'DEPT_CODE6',
                textFieldName   : 'DEPT_NAME6',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS6',
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_CODE6',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_NAME6',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelResult.getField('DEPTS6') ;
                            tagfield.setStoreData(records)
                    }
                }
            })
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
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
        	fieldLabel		: '전표일',
			xtype			: 'uniDateRangefield',  
			startFieldName	: 'DATE_FR',
			endFieldName	: 'DATE_TO',
			allowBlank		: false,
			colspan: 2,
	        //tdAttrs			: {width: 380},  
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
		},
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드1',
                itemId          : 'deptCodePopup1',
                valueFieldName  : 'DEPT_CODE1',
                textFieldName   : 'DEPT_NAME1',
                valuesName      : 'DEPTS1',
                selectChildren  : true,
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                autoPopup       : true,
                useLike         : false,
                allowBlank      : false,
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_CODE1',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME1',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelSearch.getField('DEPTS1') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드2',
                itemId          : 'deptCodePopup2',
                valueFieldName  : 'DEPT_CODE2',
                textFieldName   : 'DEPT_NAME2',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS2',
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_CODE2',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME2',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelSearch.getField('DEPTS2') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드3',
                itemId          : 'deptCodePopup3',
                valueFieldName  : 'DEPT_CODE3',
                textFieldName   : 'DEPT_NAME3',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS3',
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_CODE3',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME3',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelSearch.getField('DEPTS3') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드4',
                itemId          : 'deptCodePopup4',
                valueFieldName  : 'DEPT_CODE4',
                textFieldName   : 'DEPT_NAME4',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS4',
                listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_CODE4',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME4',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelSearch.getField('DEPTS4') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel      : '부서코드5',
                itemId          : 'deptCodePopup5',
                valueFieldName  : 'DEPT_CODE5',
                textFieldName   : 'DEPT_NAME5',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS5',
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_CODE5',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME5',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelSearch.getField('DEPTS5') ;
                            tagfield.setStoreData(records)
                    }
                }
            }),
            Unilite.treePopup('DEPTTREE',{ 
                fieldLabel: '부서코드6',
                itemId          : 'deptCodePopup6',
                valueFieldName  : 'DEPT_CODE6',
                textFieldName   : 'DEPT_NAME6',
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                valuesName      : 'DEPTS6',
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_CODE6',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME6',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelSearch.getField('DEPTS6') ;
                            tagfield.setStoreData(records)
                    }
                }
            })
        ]	
    });
	
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('agc200skrGrid1', {
        layout : 'fit',
        region : 'center',
//    	excelTitle: '부서별손익계산서',
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
		    			//alert("출력 레포트를 만들어주세요.");
			    		}
			    		else{
			    			alert("선택된 자료가 없습니다.");
			    		}
	        		}
        	}
        ],
        columns: [        
        	{dataIndex: 'ACCNT_NAME'	, width: 180}, 				
			{dataIndex: 'TOTAL_AMT'		, width: 133},
			{itemId:'CHANGE_NAME1',
					columns:[{ dataIndex: 'DEPT_AMT_1'		, width: 150}
					]	
			},
			{itemId:'CHANGE_NAME2',
					columns:[{ dataIndex: 'DEPT_AMT_2'		, width: 150}
					]	
			},
			{itemId:'CHANGE_NAME3',
					columns:[{ dataIndex: 'DEPT_AMT_3'		, width: 150}
					]	
			},
			{itemId:'CHANGE_NAME4',
					columns:[{ dataIndex: 'DEPT_AMT_4'		, width: 150}
					]	
			},
			{itemId:'CHANGE_NAME5',
					columns:[{ dataIndex: 'DEPT_AMT_5'		, width: 150}
					]	
			},
			{itemId:'CHANGE_NAME6',
					columns:[{ dataIndex: 'DEPT_AMT_6'		, width: 150}
					]	
			}
		]              	        
    });                  
    
    
    Unilite.Main({
		id			: 'agc200skrApp',
	 	border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
					masterGrid, panelResult
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
			masterGrid.down('#CHANGE_NAME1').setText('부서코드1');
			masterGrid.down('#CHANGE_NAME2').setText('부서코드2');
			masterGrid.down('#CHANGE_NAME3').setText('부서코드3');
			masterGrid.down('#CHANGE_NAME4').setText('부서코드4');
			masterGrid.down('#CHANGE_NAME5').setText('부서코드5');
			masterGrid.down('#CHANGE_NAME6').setText('부서코드6');
			//fnSetViewComponent('E1');
		},
		
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE1'))){
				masterGrid.down('#CHANGE_NAME1').setText(panelSearch.getValue('DEPT_NAME1'));
			}
			else if(Ext.isEmpty(panelSearch.getValue('DEPT_CODE1'))){
				masterGrid.down('#CHANGE_NAME1').setText('부서코드1');
			}
			
			if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE2'))){
				masterGrid.down('#CHANGE_NAME2').setText(panelSearch.getValue('DEPT_NAME2'));
			}
			else if(Ext.isEmpty(panelSearch.getValue('DEPT_CODE2'))){
				masterGrid.down('#CHANGE_NAME2').setText('부서코드2');
			}
			
			if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE3'))){
				masterGrid.down('#CHANGE_NAME3').setText(panelSearch.getValue('DEPT_NAME3'));
			}
			else if(Ext.isEmpty(panelSearch.getValue('DEPT_CODE3'))){
				masterGrid.down('#CHANGE_NAME3').setText('부서코드3');
			}
			
			if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE4'))){
				masterGrid.down('#CHANGE_NAME4').setText(panelSearch.getValue('DEPT_NAME4'));
			}
			else if(Ext.isEmpty(panelSearch.getValue('DEPT_CODE4'))){
				masterGrid.down('#CHANGE_NAME4').setText('부서코드4');
			}
			
			if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE5'))){
				masterGrid.down('#CHANGE_NAME5').setText(panelSearch.getValue('DEPT_NAME5'));
			}
			else if(Ext.isEmpty(panelSearch.getValue('DEPT_CODE5'))){
				masterGrid.down('#CHANGE_NAME5').setText('부서코드5');
			}
			
			if(!Ext.isEmpty(panelSearch.getValue('DEPT_CODE6'))){
				masterGrid.down('#CHANGE_NAME6').setText(panelSearch.getValue('DEPT_NAME6'));
			}
			else if(Ext.isEmpty(panelSearch.getValue('DEPT_CODE6'))){
				masterGrid.down('#CHANGE_NAME6').setText('부서코드6');
			}
			directMasterStore.loadStoreRecords();	
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
};


</script>
