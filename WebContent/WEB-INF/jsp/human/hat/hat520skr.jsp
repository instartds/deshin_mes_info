<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat520skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hat520skr"  /> 		<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" /> 			<!-- 직위 -->
    <t:ExtComboStore comboType="AU" comboCode="H033" /> 			<!-- 근태코드 --> 
    <t:ExtComboStore comboType="AU" comboCode="H028" /> 			<!-- 급여지급방식 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var dutyNumFormat  = '${DUTY_NUM_FORMAT}';
var dutyTimeFormat = '${DUTY_TIME_FORMAT}';

function appMain() {

	var colData = ${colData};
	console.log(colData);
	
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hat520skrModel', {
		fields: fields
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hat520skrMasterStore1',{
		model: 'Hat520skrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 'hat520skrService.selectList'                	
			}
		},
		listeners : {
	        load : function(store, records, successful, eOpts) {
//	            if (store.getCount() > 0) {
//	            	setGridSummary(Ext.getCmp('CHKCNT').checked);
//	            }
//	        	store.insert(0, records[0]);
//	        	var lv1Total = 0;	//부서 필드에 보이는 합계
//	        	var lv2Total = 0;	//사업장 필드에 보이는 합계
//	        	var lv3Total = 0;	//근태일자 필드에 보이는 합계
//	        	Ext.each(records, function(record, index){
//	        		Ext.each(colData, function(item, index){
//	        			eval(lv1Total + index) = record.get('DUTY_NUM' + index);	//부서 필드에 보이는 합계
//			        	eval(lv2Total + index) = record.get('DUTY_NUM' + index);	//사업장 필드에 보이는 합계
//			        	eval(lv3Total + index) = record.get('DUTY_NUM' + index);	//근태일자 필드에 보이는 합계	
//	        		});	        		
//	        		if(record.get('DEPT_NAME') != records[index+1].get('DEPT_NAME')){
//						
//	        		}else{
//	        			lv1Total += lv1Total;
//	        		}	
//	        	});
//	        	Ext.each(records, function(record, index){
//	        		if(record.get('GUBUN') == '2'){	        		
//	        			record.set('DEPT_NAME', '합계');
//	        		}else if(record.get('GUBUN') == '3'){
//	        			record.set('DIV_CODE', '합계');
//	        		}else if(record.get('GUBUN') == '4'){
//	        			record.set('DUTY_YYYYMMDD', '합계');
//	        		}else if(record.get('GUBUN') == '5'){
//	        			record.set('DUTY_YYYYMMDD', '총계');
//	        		}
//	        	});
	        }
	    },
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
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
	    }
	});	//End of var directMasterStore1 = Unilite.createStore('hat520skrMasterStore1',{

	
	var panelSearch = Unilite.createSearchPanel('searchForm', {       
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
          	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
    		items: [{ 
				fieldLabel: '<t:message code="system.label.human.workprod" default="근무기간"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				width:315,
				allowBlank:false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO', newValue);				    		
			    	}
			    }
			},{
    			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
    			name: 'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'BOR120',
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
			}),			
		     	Unilite.popup('Employee',{ 
				
				validateBlank: false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
    			fieldLabel: '<t:message code="system.label.human.30minunit" default="30분단위"/>',
//                name: 'halfhourunit',
                xtype: 'radiogroup',
                columns: [60,60],
                items: [{
					boxLabel: '<t:message code="system.label.human.yes" default="예"/>',
					name: 'halfhourunit',
					inputValue: 'Y'
					
				},{
					boxLabel: '<t:message code="system.label.human.no" default="아니오"/>',
					name: 'halfhourunit',
					inputValue: 'N',
					checked: true 
				}],
				listeners: {
					change : function(rb, newValue, oldValue, options) {
						panelResult.getField('halfhourunit').setValue(newValue.halfhourunit);
// 						UniAppManager.app.onQueryButtonDown();
//						masterGrid.getView().refresh();
					}
				}
            },{
    			fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
    			name: 'PAY_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'AU',
    			comboCode: 'H028',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_CODE', newValue);
					}
				}
    		},{
    			fieldLabel: '<t:message code="system.label.human.dutytype" default="근태구분"/>',
    			name: 'SDUTY_CODE',
    			xtype: 'uniCombobox',
    			comboType: 'AU',
    			comboCode: 'H033',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SDUTY_CODE', newValue);
					}
				}
    		},{
            	fieldLabel: '<t:message code="system.label.human.summark" default="합계표기"/>',
            	name: 'CHKCNT',				
//				value:'Y',
				xtype: 'checkbox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CHKCNT', newValue);
					}
				}
    		}] 
		}]
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns :	5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '<t:message code="system.label.human.workprod" default="근무기간"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			width:315,
			allowBlank:false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('ORDER_DATE_TO', newValue);				    		
		    	}
		    }
		},{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.30minunit" default="30분단위"/>',
//            name: 'halfhourunit',
            xtype: 'radiogroup',
            columns: [60,60],
            colspan: 3,
            items: [{
				boxLabel: '<t:message code="system.label.human.yes" default="예"/>',
				name: 'halfhourunit',
				inputValue: 'Y'
				
			},{
				boxLabel: '<t:message code="system.label.human.no" default="아니오"/>',
				name: 'halfhourunit',
				inputValue: 'N',
				checked: true 
			}],
			listeners: {
				change : function(rb, newValue, oldValue, options) {
					panelSearch.getField('halfhourunit').setValue(newValue.halfhourunit);
// 						UniAppManager.app.onQueryButtonDown();
//						masterGrid.getView().refresh();
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
		}),			
	     	Unilite.popup('Employee',{ 
			
			validateBlank: false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
//                	},
//					scope: this
//				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
					panelResult.setValue('PERSON_NUMB', '');
                    panelResult.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name: 'PAY_CODE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.dutytype" default="근태구분"/>',
			name: 'SDUTY_CODE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H033',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SDUTY_CODE', newValue);
				}
			}
		},{
        	fieldLabel: '<t:message code="system.label.human.summark" default="합계표기"/>',
        	name: 'CHKCNT',
//			value:'Y',
			xtype: 'checkbox',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CHKCNT', newValue);
				}
			}
		}]
    });
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hat520skrGrid1', {
    	// for tab    	
        layout: 'fit',
        region:'center',
        sortableColumns: false,
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
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('GUBUN') == '5'){
					cls = 'x-change-cell_dark';
				}
				else if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3' || record.get('GUBUN') == '4') {	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
    	store: directMasterStore1,
    	columns: columns
    });//End of var masterGrid = Unilite.createGrid('hat520skrGrid1', {
	
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
		id: 'hat520skrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('today'));			
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ORDER_DATE_FR');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//
//			console.log(
//				"viewLocked: ",
//				viewLocked
//			);
//			console.log(
//				"viewNormal: ",
//				viewNormal
//			);
//		    
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		}
	});
	
	// 모델 필드 생성
	function createModelField(colData) {
		
		var fields = [
						{name: 'GUBUN', 							text: 'GUBUN', 	type: 'string'},
						{name: 'DUTY_YYYYMMDD', 		text: '<t:message code="system.label.human.dutyyyyymmdd" default="근무년월일"/>',	type: 'string'},
						{name: 'DIV_CODE',						text: '<t:message code="system.label.human.divcode" default="사업장코드"/>',	type: 'string'},
						{name: 'DIV_NAME',						text: '<t:message code="system.label.human.division" default="사업장"/>',	type: 'string'},
						{name: 'DEPT_CODE',					text: '<t:message code="system.label.human.deptcode" default="부서코드"/>',	type: 'string'},
						{name: 'DEPT_NAME',					text: '<t:message code="system.label.human.department" default="부서"/>',		type: 'string'},
						{name: 'POST_CODE',					text: '<t:message code="system.label.human.postcode" default="직위"/>',		type: 'string', comboType:'AU',comboCode:'H005'},
						{name: 'NAME',								text: '<t:message code="system.label.human.name" default="성명"/>',		type: 'string'},
						{name: 'PERSON_NUMB',				text: '<t:message code="system.label.human.personnumb" default="사번"/>',		type: 'string'},
						{name: 'DUTY_CODE', 					text: '<t:message code="system.label.human.dutytype" default="근태구분"/>', 	type: 'string', comboType:'AU',comboCode:'H033'},
						{name: 'DUTY_FR_D', 					text: '<t:message code="system.label.human.caldate" default="일자"/>', 	type: 'uniDate'},
						{name: 'DUTY_FR_H',						text: '<t:message code="system.label.human.hour" default="시"/>', 		type: 'string'},
						{name: 'DUTY_FR_M',					text: '<t:message code="system.label.human.minute" default="분"/>', 		type: 'string'},
						{name: 'DUTY_TO_D', 					text: '<t:message code="system.label.human.caldate" default="일자"/>', 	type: 'uniDate'},
						{name: 'DUTY_TO_H', 					text: '<t:message code="system.label.human.hour" default="시"/>', 		type: 'string'},
						{name: 'DUTY_TO_M', 					text: '<t:message code="system.label.human.minute" default="분"/>', 		type: 'string'}
					];
					
		Ext.each(colData, function(item, index){
			if(dutyNumFormat == "0,000") {
				fields.push({name: 'DUTY_NUM' + index, text:'<t:message code="system.label.human.days" default="일수"/>', type:'int', foramt:dutyNumFormat});
			} else {
				fields.push({name: 'DUTY_NUM' + index, text:'<t:message code="system.label.human.days" default="일수"/>', type:'float', foramt:dutyNumFormat});
			}
		
			if(dutyTimeFormat == "0,000") {
				fields.push({name: 'DUTY_TIME' + index, text:'<t:message code="system.label.human.time" default="시간"/>', type:'int', foramt:dutyTimeFormat});
			} else {
				fields.push({name: 'DUTY_TIME' + index, text:'<t:message code="system.label.human.time" default="시간"/>', type:'float', foramt:dutyTimeFormat});
			}
			
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [
		   			{dataIndex: 'GUBUN'			,	width: 86, hidden: true},
		   			{dataIndex: 'DUTY_YYYYMMDD',	width: 86, align: 'center', locked:true},
					{dataIndex: 'DIV_CODE',			width: 120, hidden: true},
					{dataIndex: 'DIV_NAME',			width: 120, locked:true},
					{dataIndex: 'DEPT_CODE',		width: 86, hidden: true, locked:true},
					{dataIndex: 'DEPT_NAME',		width: 120, locked:true/*, summaryType: 'totaltext'*/},
					{dataIndex: 'POST_CODE',		width: 93, locked:true},
					{dataIndex: 'NAME',				width: 93, locked:true},
					{dataIndex: 'PERSON_NUMB',		width: 100, locked:true},
					{dataIndex: 'DUTY_CODE',		width: 66},
					{text:'<t:message code="system.label.human.attenddate" default="출근일자"/>',
						columns:[ 
							{dataIndex: 'DUTY_FR_D', width:80},
							{dataIndex: 'DUTY_FR_H', width:66},
							{dataIndex: 'DUTY_FR_M', width:66}
					]},
					{text:'<t:message code="system.label.human.offworkdate" default="퇴근일자"/>',
						columns:[ 
							{dataIndex: 'DUTY_TO_D', width:80},
							{dataIndex: 'DUTY_TO_H', width:66},
							{dataIndex: 'DUTY_TO_M', width:66}
					]}	
				];
					
		Ext.each(colData, function(item, index){
			columns.push({text: item.CODE_NAME,
				columns:[ 
					{dataIndex: 'DUTY_NUM' + index, width:66/*, summaryType:'sum'*/,renderer: function(value, metaData, record) {							
						return Ext.util.Format.number(value, dutyNumFormat);
					}},
					{dataIndex: 'DUTY_TIME' + index, width:66/*, summaryType:'sum'*/,renderer: function(value, metaData, record) {							
						return Ext.util.Format.number(value, dutyTimeFormat);
					}}
			]});
		});
		console.log(columns);
		return columns;
	}
	
	
	// Grid 의 summary row의  표시 /숨김 적용
//    function setGridSummary(viewable){
//    	if (directMasterStore1.getCount() > 0) {
//    		var viewLocked = masterGrid.lockedGrid.getView();
//            var viewNormal = masterGrid.normalGrid.getView();
//            if (viewable) {
//            	viewLocked.getFeature('masterGridTotal').enable();
//            	viewNormal.getFeature('masterGridTotal').enable();
//            	viewLocked.getFeature('masterGridSubTotal').enable();        	
//            	viewNormal.getFeature('masterGridSubTotal').enable();
//            } else {
//            	viewLocked.getFeature('masterGridTotal').disable();
//            	viewNormal.getFeature('masterGridTotal').disable();
//            	viewLocked.getFeature('masterGridSubTotal').disable();
//            	viewNormal.getFeature('masterGridSubTotal').disable();
//            }
//            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(viewable);
//            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(viewable);
//            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(viewable);
//            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(viewable);
//            
//            masterGrid.getView().refresh();	
//    	}
//    }
};


</script>
