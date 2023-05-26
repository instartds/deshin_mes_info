<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum250skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum250skr" /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 			<!-- 사원구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hum250skrModel', {
	    fields: [
			{name: 'YEAR'						, text: '<t:message code="system.label.human.docyyyy" default="년도"/>'			, type: 'string'},
			{name: 'MONTH'				, text: '<t:message code="system.label.human.month" default="월"/>'				, type: 'string'},
			{name: 'COUNT_MEN'		, text: '<t:message code="system.label.human.male" default="남"/>'	, type: 'int'},
			{name: 'COUNT_FEM'		, text: '<t:message code="system.label.human.female" default="여"/>'	, type: 'int'},
			{name: 'COUNT_SUM'		, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'	, type: 'int'},
			{name: 'INNE_MEM'			, text: '<t:message code="system.label.human.male" default="남"/>'		, type: 'int'},
			{name: 'INNE_FEM'			, text: '<t:message code="system.label.human.female" default="여"/>'		, type: 'int'},
			{name: 'INNE_SUM'			, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int'},
			{name: 'OUTE_MAN'			, text: '<t:message code="system.label.human.male" default="남"/>'		, type: 'int'},
			{name: 'OUTE_FEM'			, text: '<t:message code="system.label.human.female" default="여"/>'		, type: 'int'},
			{name: 'OUTE_SUM'			, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int'},
			{name: 'FINE_MAN'			, text: '<t:message code="system.label.human.male" default="남"/>'		, type: 'int'},
			{name: 'FINE_FEM'				, text: '<t:message code="system.label.human.female" default="여"/>'		, type: 'int'},
			{name: 'FINE_SUM'			, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int'}
	    ]
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hum250skrMasterStore1',{
		model: 'Hum250skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable:false,		// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hum250skrService.selectDataList'                	
            }
        },
        loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			
			if(panelSearch.getValue("EMP_TYPE_FR") == null || panelSearch.getValue("EMP_TYPE_FR") == ''){
				param.EMP_TYPE_FR = '0';
			}
			if(panelSearch.getValue("EMP_TYPE_TO") == null || panelSearch.getValue("EMP_TYPE_TO") == ''){
				param.EMP_TYPE_TO = '99';
			}
			
			console.log( param );
			this.load({
				params: param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	           fieldLabel: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
 		       width:315,
               xtype: 'uniMonthRangefield',
               startFieldName: 'ANN_DATE_FROM',
               endFieldName: 'ANN_DATE_TO',
               allowBlank: false,
               onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ANN_DATE_FROM',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ANN_DATE_TO',newValue);
			    	}
			    }
	        },{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
		    Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.irregularworkinclude" default="비정규직포함"/>',	
				items: [{
					boxLabel: '<t:message code="system.label.human.do" default="한다"/>', 
					width: 70, 
					name: 'PAY_GUBUN',
					inputValue: ''  
				},{
					boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>', 
					width: 70,
					name: 'PAY_GUBUN',
					inputValue: 'Y',
					checked: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('PAY_GUBUN').setValue(newValue.PAY_GUBUN);
					}
				}
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'<t:message code="system.label.human.employtype" default="사원구분"/>', 
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H024',
					name: 'EMP_TYPE_FR',
					width:195,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('EMP_TYPE_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H024',
					name: 'EMP_TYPE_TO', 
					width: 110,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('EMP_TYPE_TO', newValue);
						}
					}
				}]
			}]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
		           fieldLabel: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
	 		       width:315,
	               xtype: 'uniMonthRangefield',
	               startFieldName: 'ANN_DATE_FROM',
	               endFieldName: 'ANN_DATE_TO',
	               allowBlank: false,
	               colspan:2,
	               onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('ANN_DATE_FROM',newValue);
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelSearch.setValue('ANN_DATE_TO',newValue);
				    	}
				    }
		        },{
					fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
					name:'DIV_CODE', 
					xtype: 'uniCombobox',
			        multiSelect: true, 
			        typeAhead: false,
			        comboType:'BOR120',
					width: 325,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},
		        Unilite.treePopup('DEPTTREE',{
					fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
					valueFieldName:'DEPT',
					textFieldName:'DEPT_NAME' ,
					valuesName:'DEPTS' ,
					DBvalueFieldName:'TREE_CODE',
					DBtextFieldName:'TREE_NAME',
					selectChildren:true,
					textFieldWidth:89,
					validateBlank:true,
					width:300,
					autoPopup:true,
					useLike:true,
					colspan:2,
					listeners: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelSearch.setValue('DEPT',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelSearch.setValue('DEPT_NAME',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelSearch.getField('DEPTS') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.human.irregularworkinclude" default="비정규직포함"/>',		
					items: [{
						boxLabel: '<t:message code="system.label.human.do" default="한다"/>', 
						width: 70, 
						name: 'PAY_GUBUN',
						inputValue: ''  
					},{
						boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>', 
						width: 70,
						name: 'PAY_GUBUN',
						inputValue: 'Y',
						checked: true
					}],
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('PAY_GUBUN').setValue(newValue.PAY_GUBUN);
						}
					}
				},{
				    xtype: 'container',
					layout: {type : 'uniTable', columns : 3},
					width:325,
					items :[{
						fieldLabel:'<t:message code="system.label.human.employtype" default="사원구분"/>', 
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'H024',
						name: 'EMP_TYPE_FR',
						width:195,
							listeners: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelSearch.setValue('EMP_TYPE_FR', newValue);
							}
						}
					},{
						xtype:'component', 
						html:'~',
						style: {
							marginTop: '3px !important',
							font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
						}
					},{
						fieldLabel:'', 
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'H024',
						name: 'EMP_TYPE_TO', 
						width: 110,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelSearch.setValue('EMP_TYPE_TO', newValue);
							}
						}
					}]
				}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('hum250skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore,
        selModel:'rowmodel',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStore,
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        columns: [{ 
        	dataIndex:'YEAR' 	 		, width: 88 , align: 'center'
				,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
 			{dataIndex:'MONTH' 			, width: 120 , align: 'center'},
 			{text: '<t:message code="system.label.human.continuingstaff" default="계속근무인원"/>',
					columns:[
						{dataIndex: 'COUNT_MEN',  width: 66,  text: '<t:message code="system.label.human.male" default="남"/>'  , summaryType: 'sum' },
                		{dataIndex: 'COUNT_FEM',  width: 66,  text: '<t:message code="system.label.human.female" default="여"/>'  , summaryType: 'sum'},
                		{dataIndex: 'COUNT_SUM',  width: 66,  text: '<t:message code="system.label.human.totwagesi" default="합계"/>', summaryType: 'sum'}
                	]
            },{text: '<t:message code="system.label.human.innestaff" default="입사인원"/>',
                	columns:[ 	 
                		{dataIndex: 'INNE_MEM',  width: 66,  text: '<t:message code="system.label.human.male" default="남"/>',  summaryType: 'sum'},
                		{dataIndex: 'INNE_FEM',  width: 66,  text: '<t:message code="system.label.human.female" default="여"/>',  summaryType: 'sum'},
                		{dataIndex: 'INNE_SUM',  width: 66,  text: '<t:message code="system.label.human.totwagesi" default="합계"/>', summaryType: 'sum'}
                	]
            },{text: '<t:message code="system.label.human.outestaff" default="퇴사인원"/>',
                	columns:[ 	
                		{dataIndex: 'OUTE_MAN',  width: 66,  text: '<t:message code="system.label.human.male" default="남"/>',  summaryType: 'sum'},
                		{dataIndex: 'OUTE_FEM',  width: 66,  text: '<t:message code="system.label.human.female" default="여"/>',  summaryType: 'sum'},
                		{dataIndex: 'OUTE_SUM',  width: 66,  text: '<t:message code="system.label.human.totwagesi" default="합계"/>', summaryType: 'sum'}
                	 ]
            },{text: '<t:message code="system.label.human.finestaff" default="월말인원"/>',
                	columns:[ 	 
                		{dataIndex: 'FINE_MAN',  width: 66,  text: '<t:message code="system.label.human.male" default="남"/>', summaryType:'sum'},
                		{dataIndex: 'FINE_FEM',  width: 66,  text: '<t:message code="system.label.human.female" default="여"/>', summaryType:'sum'},
                		{dataIndex: 'FINE_SUM',  width: 66,  text: '<t:message code="system.label.human.totwagesi" default="합계"/>', summaryType:'sum'}
                	]
            }]   
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
		id : 'hum250skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('ANN_DATE_FROM',UniDate.get('startOfMonth'));
			panelResult.setValue('ANN_DATE_FROM',UniDate.get('startOfMonth'));
			panelSearch.setValue('ANN_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ANN_DATE_TO',UniDate.get('today'));
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ANN_DATE_FROM');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			var viewNormal = masterGrid.getView();  // lock 없을 경우는 getView / lock 있을경우 nomalGrid. 추가
			console.log("viewNormal : ",viewNormal);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
		}
		/*onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		},*/
	});
};


</script>
