<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat200skr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
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
	Unilite.defineModel('Hat200skrModel', {
		fields: fields
	});	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hat200skrMasterStore1', {
		model: 'Hat200skrModel',
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
				read: 's_hat200skrService_KOCIS.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
	    	if(this.uniOpt.isMaster) {
	    		var recLength = 0;
	    		Ext.each(records, function(record, idx){
	    			if(record.get('GUBUN') == '1'){
	    				recLength++;
	    			}
	    		});
		    	if (records) {
			    	UniAppManager.setToolbarButtons('save', false);
					var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
			    	//console.log(msg, st);
			    	UniAppManager.updateStatus(msg, true);	
		    	}
	    	}
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
    			fieldLabel: '근태년월',
		        xtype: 'uniMonthRangefield',
		        startFieldName: 'DUTY_YYYYMM_FR',
		        endFieldName: 'DUTY_YYYYMM_TO',
		        width: 325,
		        //startDate: UniDate.get('startOfMonth'),
		        //endDate: UniDate.get('today'),
		        allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DUTY_YYYYMM_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DUTY_YYYYMM_TO', newValue);				    		
			    	}
			    }
	        },{ 
	        	fieldLabel: '기관',
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
			{
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
				fieldLabel: '고용형태',
				name: 'PAY_GUBUN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_GUBUN', newValue);
					}
				}
			}/*,
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
			})*/,			
		     	Unilite.popup('Employee',{ 
				fieldLabel : '직원',
				validateBlank: false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
			    fieldLabel: '합계표시여부',
			    xtype: 'uniCheckboxgroup', 
			    items: [{
			    	boxLabel: '개인별',
			        name: 'CHECK_PERSON',
			        width: 70,
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CHECK_PERSON', newValue);
						}
					}
				}/*,{
			    	boxLabel: '부서별',
			        name: 'CHECK_DEPT',
			        listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CHECK_DEPT', newValue);
						}
					}
				}*/]
   			}
// 			,{
//              fieldLabel: '개인별합계표기여부',
//              labelWidth:110, 
//              boxLabel:'',
//              name:'PLAN_SAVE_YN', 
//              inputValue :'Y',
//              xtype:'checkbox', 
//              checked:true
// 			}
			]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns :	4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '근태년월',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'DUTY_YYYYMM_FR',
	        endFieldName: 'DUTY_YYYYMM_TO',
	        width: 325,
	        //startDate: UniDate.get('startOfMonth'),
	        //endDate: UniDate.get('today'),
	        allowBlank: false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DUTY_YYYYMM_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DUTY_YYYYMM_TO', newValue);				    		
		    	}
		    }
        },{ 
        	fieldLabel: '기관',
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
            colspan: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_CODE', newValue);
				}
			}
		},
		{
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
			fieldLabel: '고용형태',
			name: 'PAY_GUBUN', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H011',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_GUBUN', newValue);
				}
			}
		}/*,
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
		})*/,			
	     	Unilite.popup('Employee',{ 
			fieldLabel : '직원',
			validateBlank: false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
//                	},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('PERSON_NUMB', '');
//					panelSearch.setValue('NAME', '');
//				}
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),{
		    fieldLabel: '합계표시여부',
		    xtype: 'uniCheckboxgroup', 
		    items: [{
		    	boxLabel: '개인별',
		        name: 'CHECK_PERSON',
		        width: 70,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CHECK_PERSON', newValue);
					}
				}
			}/*,{
		    	boxLabel: '부서별',
		        name: 'CHECK_DEPT',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CHECK_DEPT', newValue);
					}
				}
			}*/]
		}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hat200skrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
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
	});//End of var masterGrid = Unilite.createGr100id('hat200skrGrid1', {   
                                                 
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
		id: 'hat200skrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DUTY_YYYYMM_FR', UniDate.get('today'));
			panelSearch.setValue('DUTY_YYYYMM_TO', UniDate.get('today'));
			panelResult.setValue('DUTY_YYYYMM_FR', UniDate.get('today'));
			panelResult.setValue('DUTY_YYYYMM_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',false);
			masterGrid.on('edit', function(editor, e) {
				UniAppManager.setToolbarButtons('save',true);
			})
            
            if(UserInfo.divCode == "01") {
                panelSearch.getField('DIV_CODE').setReadOnly(false);
                panelResult.getField('DIV_CODE').setReadOnly(false);
            }
            else {
                panelSearch.getField('DIV_CODE').setReadOnly(true);
                panelResult.getField('DIV_CODE').setReadOnly(true);
            }
		},
		onQueryButtonDown: function() {			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
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
		
		var fields = [	{name: 'GUBUN',			text: 'GUBUN', 	editable:false,		type: 'string'},					
						{name: 'DIV_CODE',			text: '기관코드', 	editable:false,		type: 'string', comboType:'BOR120', comboCode:'1234', hidden: true},
						{name: 'DIV_NAME',			text: '기관', 	editable:false,		type: 'string'},
						{name: 'DEPT_CODE',			text: '부서코드', 	editable:false,		type: 'string'},
						{name: 'DEPT_NAME',		text: '부서', 	editable:false,		type: 'string'},
						{name: 'POST_CODE',		text: '직위', 	editable:false,		type: 'string', comboType:'AU', comboCode:'H005'},
						{name: 'NAME',				text: '성명', 	editable:false,		type: 'string'},
						{name: 'PERSON_NUMB',	text: '사번', 	editable:false,		type: 'string'},						
						{name: 'DUTY_YYYYMM',	text: '근태년월', 	editable:false,		type: 'string'},
						{name: 'PAY_PROV_FLAG',	text: '지급차수', 	editable:false,		type: 'string'},
						{name: 'DUTY_FROM',	text: '연월첫일', 	editable:false,		type: 'string'},
						{name: 'DUTY_TO',	text: '연월말일', 	editable:false,		type: 'string'},
//						{name: 'DEPT_CODE',	text: '부서', 	editable:false,		type: 'string'},
						{name: 'DEPT_CODE2',	text: '부서', 	editable:false,		type: 'string'}						
					];
					
		Ext.each(colData, function(item, index){
			fields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'일수', type:'string' });
			fields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'시간', type:'string'});
		});
		
		fields.push({name: 'REMARK',	text: '비고',	type: 'string'});
		
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		
		var columns = [
					{dataIndex: 'GUBUN',			width: 100, hidden: true},
					{dataIndex: 'DIV_CODE',			width: 100, hidden: true/*,						
						summaryRenderer : function(value, summaryData, dataIndex) {
							var rv = '<div align="center">합 계</div>';
							if (Unilite.isGrandSummaryRow(summaryData)) {
								rv = '<div align="center">총 계</div>';
							}
							return rv;
						}*/
					},
					{dataIndex: 'DIV_NAME',			width: 120},
					{dataIndex: 'DEPT_CODE',		width: 86, hidden: true},
					{dataIndex: 'DEPT_NAME',		width: 120, hidden: true},
					{dataIndex: 'POST_CODE',		width: 86},
					{dataIndex: 'NAME',				width: 120},
					{dataIndex: 'PERSON_NUMB',		width: 80, hidden: true},
					{dataIndex: 'DUTY_YYYYMM',		width: 80, align: 'center'},
					{dataIndex: 'PAY_PROV_FLAG',		width: 100, hidden: true},
					{dataIndex: 'DUTY_FROM',		width: 100, hidden: true},
					{dataIndex: 'DUTY_TO',		width: 100, hidden: true},
					{dataIndex: 'DEPT_CODE',		width: 100, hidden: true},
					{dataIndex: 'DEPT_CODE2',		width: 100, hidden: true}
				];
					
		Ext.each(colData, function(item, index){
			columns.push({text: item.CODE_NAME,
				columns:[ 
					{dataIndex: 'DUTY_NUM' + item.SUB_CODE, width:66, summaryType:'sum', align: 'right',
						renderer: function(value, metaData, record) {							
							return Ext.util.Format.number(value, '0.0');
						}
					},
					{dataIndex: 'DUTY_TIME' + item.SUB_CODE, width:66, summaryType:'sum', align: 'right',
						renderer: function(value, metaData, record) {							
							return Ext.util.Format.number(value, '0.00');
						}
					}
			]});
		});
		columns.push({dataIndex: 'REMARK',		width: 250});
		console.log(columns);
		return columns;
	}
		
};


</script>