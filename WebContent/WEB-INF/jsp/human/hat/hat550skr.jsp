<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat550skr"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var colData = ${colData};
	console.log(colData);
	
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);
	

	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hat550skrModel', {
		fields: fields
	});	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hat550skrMasterStore1', {
		model: 'Hat550skrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'hat550skrService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		}/*,
		groupField: 'PERSON_NUMB'*/
		
		
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
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
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{ 
    			fieldLabel: '근태기간',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DUTY_YYYYMMDD_FR',
		        endFieldName: 'DUTY_YYYYMMDD_TO',
		        width: 325,
		        //startDate: UniDate.get('startOfMonth'),
		        //endDate: UniDate.get('today'),
		        allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DUTY_YYYYMMDD_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DUTY_YYYYMMDD_TO', newValue);				    		
			    	}
			    }
	        },{ 
	        	fieldLabel: '사업장',
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}	        	
        	},
        	{
				fieldLabel: '급여지급방식',
				name: 'PAY_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
					fieldLabel: '부서',
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
				fieldLabel: '지급차수',
				name: 'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_PROV_FLAG', newValue);
					}
				}
			},
			{
				fieldLabel: '사원구분',
				name: 'EMPLOY_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('EMPLOY_TYPE', newValue);
					}
				}
			},
				Unilite.popup('Employee', {
					 
					validateBlank: false,
//					extParam: {'CUSTOM_TYPE': '3'},
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
						}
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//								panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                    	},
//							scope: this
//						},
//						onClear: function(type)	{
//							panelResult.setValue('PERSON_NUMB', '');
//							panelResult.setValue('NAME', '');
//						}
					}
			}),{
    			fieldLabel: '확인여부',
//                name: 'halfhourunit',
                xtype: 'radiogroup',
                columns: [60,60,60],
                items: [{
					boxLabel: '전체',
					name: 'CONFIRM_YN',
					inputValue: '',
					checked: true 
					
				},{
					boxLabel: '미확인',
					name: 'CONFIRM_YN',
					inputValue: 'N'
				},{
					boxLabel: '확인',
					name: 'CONFIRM_YN',
					inputValue: 'Y'
				}],
				listeners: {
					change : function(rb, newValue, oldValue, options) {
						panelResult.getField('CONFIRM_YN').setValue(newValue.CONFIRM_YN);
					}
				}
            }]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns :	3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '근태기간',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'DUTY_YYYYMMDD_FR',
	        endFieldName: 'DUTY_YYYYMMDD_TO',
	        width: 325,
	        //startDate: UniDate.get('startOfMonth'),
	        //endDate: UniDate.get('today'),
	        allowBlank: false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DUTY_YYYYMMDD_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DUTY_YYYYMMDD_TO', newValue);				    		
		    	}
		    }
        },{ 
        	fieldLabel: '사업장',
        	name: 'DIV_CODE',
        	xtype: 'uniCombobox', 
        	comboType:'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}	        	
    	},
    	{
			fieldLabel: '급여지급방식',
			name: 'PAY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_CODE', newValue);
				}
			}
		},
		Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
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
			fieldLabel: '지급차수',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		},
		{
			fieldLabel: '사원구분',
			name: 'EMPLOY_TYPE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H024',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('EMPLOY_TYPE', newValue);
				}
			}
		},
			Unilite.popup('Employee', {
				 
				validateBlank: false,
//				extParam: {'CUSTOM_TYPE': '3'},
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//								panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                    	},
//							scope: this
//						},
//						onClear: function(type)	{
//							panelResult.setValue('PERSON_NUMB', '');
//							panelResult.setValue('NAME', '');
//						}
				}
		}),{
			fieldLabel: '확인여부',
//                name: 'halfhourunit',
            xtype: 'radiogroup',
            columns: [60,60,60],
            items: [{
				boxLabel: '전체',
				name: 'CONFIRM_YN',
				inputValue: '',
				checked: true 
				
			},{
				boxLabel: '미확인',
				name: 'CONFIRM_YN',
				inputValue: 'N'
			},{
				boxLabel: '확인',
				name: 'CONFIRM_YN',
				inputValue: 'Y'
			}],
			listeners: {
				change : function(rb, newValue, oldValue, options) {
					panelSearch.getField('CONFIRM_YN').setValue(newValue.CONFIRM_YN);
				}
			}
        }]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hat550skrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			},
            state: {					//그리드 설정 사용 여부
    			useState: false,
    			useStateList: false
    		}		
		},
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('GUBUN') == '4'){
					cls = 'x-change-cell_dark';
				}
				else if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3') {	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
//         tbar: [{
//         	text:'상세보기',
//         	handler: function() {
//         		var record = masterGrid.getSelectedRecord();
// 	        	if(record) {
// 	        		openDetailWindow(record);
// 	        	}
//         	}
//         }],
//		features: [
//		 {	id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', 	showSummaryRow: true}
//		,{	id: 'masterGridTotal',	ftype: 'uniSummary',	showSummaryRow: false}
//		],
// 		selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }),
		store: directMasterStore1,
		columns: columns		
	});//End of var masterGrid = Unilite.createGr100id('hat550skrGrid1', {   
                                                 
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
		id: 'hat550skrApp',
		fnInitBinding: function() {
//			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DUTY_YYYYMMDD_FR', UniDate.get('startOfMonth'), UniDate.get('today'));
			panelSearch.setValue('DUTY_YYYYMMDD_TO', UniDate.get('endOfMonth'), UniDate.get('today'));
			panelResult.setValue('DUTY_YYYYMMDD_FR', UniDate.get('startOfMonth'), UniDate.get('today'));
			panelResult.setValue('DUTY_YYYYMMDD_TO', UniDate.get('endOfMonth'), UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',false);
			masterGrid.on('edit', function(editor, e) {
				UniAppManager.setToolbarButtons('save',true);
			})
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DUTY_YYYYMMDD_FR');
		},
		onQueryButtonDown: function() {	
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.getView();
			var viewNormal = masterGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});//End of Unilite.Main( {
		
	// 모델 필드 생성
	function createModelField(colData) {
		
		var fields = [	{name: 'GUBUN',					text: 'GUBUN', 	editable:false,		type: 'string'},
						{name: 'DUTY_YYYYMMDD',			text: '근무일자', 	editable:false,		type: 'string'},					
						{name: 'NAME',					text: '성명', 	editable:false,		type: 'string',
							summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			            		return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
			            }},
						{name: 'PERSON_NUMB',			text: '사번', 	editable:false,		type: 'string'},
						{name: 'POST_NAME',				text: '직위', 	editable:false,		type: 'string'}						
					];					
		Ext.each(colData, function(item, index){
			fields.push({name: 'DUTY_HOUR' + index, text:'시', type:'int', summaryType: 'sum' });
			fields.push({name: 'DUTY_MIN' + index, text:'분', type:'int', summaryType: 'sum' /*, decimalPrecsion: 2, format: '000,0.0'*/ });
		});
		
		fields.push({name: 'DEPT_CODE',	text: '부서코드',	type: 'string'});
		fields.push({name: 'DEPT_NAME',	text: '부서명',	type: 'string'});
		fields.push({name: 'DIV_NAME',	text: '사업장',	type: 'string'});
		fields.push({name: 'CONFIRM_YN',	text: '확인여부',	type: 'string'});		
		
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		
		var columns = [
					{dataIndex: 'GUBUN',					width: 100, hidden: true},
					{dataIndex: 'DUTY_YYYYMMDD',			width: 100, align: 'center'},
					{dataIndex: 'NAME',						width: 100},
					{dataIndex: 'PERSON_NUMB',				width: 100,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		            		return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
		            }},
					{dataIndex: 'POST_NAME',				width: 100}					
				];
					
		Ext.each(colData, function(item, index){
			columns.push({text: item.CODE_NAME,
				columns:[ 
					{dataIndex: 'DUTY_HOUR' + index, width:66, summaryType:'sum'},
					{dataIndex: 'DUTY_MIN' + index, width:66, summaryType:'sum'}
			]});
		});
		columns.push({dataIndex: 'DEPT_CODE',			width: 90});
		columns.push({dataIndex: 'DEPT_NAME',			width: 110});
		columns.push({dataIndex: 'DIV_NAME',			width: 110});
		columns.push({dataIndex: 'CONFIRM_YN',			minWidth: 90, flex: 1});
		return columns;
	}
		
};


</script>