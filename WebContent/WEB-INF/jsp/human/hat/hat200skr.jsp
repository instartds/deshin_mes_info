<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat200skr"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_DEPTS2}" storeId="authDeptsStore" /> <!--권한부서-->
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
	var refCode = colData;
	
       
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
				read: 'hat200skrService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();	
			param.DEPT_AUTH = UserInfo.deptAuthYn;
			console.log(param);
			this.load({
				params: param
			});
		},
		
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() > 0){
        			Ext.each(records, function(record, rowIndex){ 
        				
        				TimeSum	= 0.00;
        				DaySum	= 0.0;
        				
        				TimeAvgSum	= 0.00;
        				DayAvgSum	= 0.0;
        				
        				Ext.each(refCode, function(item, index){
							if(record.get('REF_CODE' + item.SUB_CODE) == '1'){
								DaySum += record.get('DUTY_NUM' + item.SUB_CODE);
								TimeSum += record.get('DUTY_TIME' + item.SUB_CODE);
							}
						});
						
						record.set('DAY_SUM', DaySum);
						record.set('TIME_SUM', TimeSum);
						
						record.set('DAY_AVG_SUM', DaySum / record.get('DIFF_MONTH'));
						record.set('TIME_AVG_SUM', TimeSum / record.get('DIFF_MONTH'));

	          		});

        		} 

			}
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

	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns :	3},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>',
	        xtype: 'uniMonthRangefield',
	        startFieldName: 'DUTY_YYYYMM_FR',
	        endFieldName: 'DUTY_YYYYMM_TO',
	        width: 325,
	        //startDate: UniDate.get('startOfMonth'),
	        //endDate: UniDate.get('today'),
	        allowBlank: false
        },{ 
        	fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
        	name: 'DIV_CODE',
        	xtype: 'uniCombobox', 
        	comboType:'BOR120'      	
    	},
    	{
			fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name: 'PAY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028'
		},
		{
			fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031'
		},
		{
			fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
			name: 'PAY_GUBUN', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H011'
		},
		{
            fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
            name: 'DEPTS2',
            xtype: 'uniCombobox',
            width:300,
            multiSelect: true,
            store:  Ext.data.StoreManager.lookup('authDeptsStore'),
            disabled:true,
            hidden:false,
            allowBlank:false
		},
		Unilite.treePopup('DEPTTREE',{
			itemId : 'deptstree',
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
			useLike:true
		}),			
	     	Unilite.popup('Employee',{
			validateBlank: true,
			listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                            panelResult.setValue('NAME', panelResult.getValue('NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    },
                onValueFieldChange: function(field, newValue){
                    panelResult.setValue('PERSON_NUMB', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelResult.setValue('NAME', newValue);             
                }
            }
		}),{
		    fieldLabel: '<t:message code="system.label.human.summarkyn" default="합계표시여부"/>',
		    xtype: 'uniCheckboxgroup', 
		    items: [{
		    	boxLabel: '<t:message code="system.label.human.byperson" default="개인별"/>',
		        name: 'CHECK_PERSON',
		        width: 70
			},{
		    	boxLabel: '<t:message code="system.label.human.bydept" default="부서별"/>',
		        name: 'CHECK_DEPT'
			}]
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
		selModel:'rowmodel',
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
		}],
		id: 'hat200skrApp',
		fnInitBinding: function() {
			UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");

			panelResult.setValue('DUTY_YYYYMM_FR', UniDate.get('today'));
			panelResult.setValue('DUTY_YYYYMM_TO', UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',false);
			masterGrid.on('edit', function(editor, e) {
				UniAppManager.setToolbarButtons('save',true);
			})
		},
		onQueryButtonDown: function() {			
			
            if(!panelResult.getInvalidMessage()) return;
            
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		}
	});//End of Unilite.Main( {
		
	// 모델 필드 생성
	function createModelField(colData) {
		
		var fields = [	{name: 'GUBUN',					text: 'GUBUN', 	editable:false,		type: 'string'},					
						{name: 'DIV_CODE',				text: '<t:message code="system.label.human.divcode" default="사업장코드"/>', 		editable:false,		type: 'string', comboType:'BOR120', comboCode:'1234', hidden: true},
						{name: 'DIV_NAME',				text: '<t:message code="system.label.human.division" default="사업장"/>', 		editable:false,		type: 'string'},
						{name: 'DEPT_CODE',				text: '<t:message code="system.label.human.deptcode" default="부서코드"/>', 		editable:false,		type: 'string'},
						{name: 'DEPT_NAME',				text: '<t:message code="system.label.human.department" default="부서"/>', 		editable:false,		type: 'string'},
						{name: 'POST_CODE',				text: '<t:message code="system.label.human.postcode" default="직위"/>', 			editable:false,		type: 'string', comboType:'AU', comboCode:'H005'},
						{name: 'NAME',					text: '<t:message code="system.label.human.name" default="성명"/>', 				editable:false,		type: 'string'},
						{name: 'PERSON_NUMB',			text: '<t:message code="system.label.human.personnumb" default="사번"/>', 		editable:false,		type: 'string'},						
						{name: 'DUTY_YYYYMM',			text: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>', 	editable:false,		type: 'string'},
						{name: 'PAY_PROV_FLAG',			text: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>', 	editable:false,		type: 'string'},
						{name: 'DUTY_FROM',				text: '<t:message code="system.label.human.monthfirstday" default="연월첫일"/>', 	editable:false,		type: 'string'},
						{name: 'DUTY_TO',				text: '<t:message code="system.label.human.monthlastday" default="연월말일"/>', 	editable:false,		type: 'string'},
//						{name: 'DEPT_CODE',				text: '부서', 	editable:false,		type: 'string'},
						{name: 'DEPT_CODE2',			text: '<t:message code="system.label.human.department" default="부서"/>', 		editable:false,		type: 'string'},				
						{name: 'DIFF_MONTH',			text: '차이월', 	editable:false,		type: 'int'},
						{name: 'DAY_SUM',				text: '일수', 	editable:false,		type: 'number'},
						{name: 'TIME_SUM',				text: '시간', 	editable:false,		type: 'number'},
						{name: 'DAY_AVG_SUM',			text: '일수', 	editable:false,		type: 'number'},
						{name: 'TIME_AVG_SUM',			text: '시간', 	editable:false,		type: 'number'}
					];
					
		Ext.each(colData, function(item, index){
			if(dutyNumFormat == '0,000') {
				fields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'<t:message code="system.label.human.days" default="일수"/>', type:'int', format:dutyNumFormat });
			} else {
				fields.push({name: 'DUTY_NUM' + item.SUB_CODE, text:'<t:message code="system.label.human.days" default="일수"/>', type:'float', format:dutyNumFormat });
			}
			if(dutyTimeFormat == '0,000') {
				fields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'<t:message code="system.label.human.time" default="시간"/>', type:'int', format:dutyTimeFormat});
			} else {
				fields.push({name: 'DUTY_TIME' + item.SUB_CODE, text:'<t:message code="system.label.human.time" default="시간"/>', type:'float', format:dutyTimeFormat});
			}
			fields.push({name: 'REF_CODE' + item.SUB_CODE, text:'연장여부', type:'string'});
		});
		
		fields.push({name: 'REMARK',	text: '<t:message code="system.label.human.remark" default="비고"/>',	type: 'string'});
		
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
					{dataIndex: 'DEPT_NAME',		width: 120},
					{dataIndex: 'POST_CODE',		width: 86},
					{dataIndex: 'NAME',				width: 80},
					{dataIndex: 'PERSON_NUMB',		width: 80},
					{dataIndex: 'DUTY_YYYYMM',		width: 80, align: 'center'},
					{dataIndex: 'PAY_PROV_FLAG',	width: 100, hidden: true},
					{dataIndex: 'DUTY_FROM',		width: 100, hidden: true},
					{dataIndex: 'DUTY_TO',			width: 100, hidden: true},
					{dataIndex: 'DEPT_CODE',		width: 100, hidden: true},
					{dataIndex: 'DEPT_CODE2',		width: 100, hidden: true},
					{dataIndex: 'DIFF_MONTH',		width: 100, hidden: true},
					
					{text:'합계',
				    	 columns:[
				    	 	{dataIndex: 'DAY_SUM'		, width: 66, hidden: true,
					    	 	renderer: function(value, metaData, record) {							
								return Ext.util.Format.number(value, dutyNumFormat);
								}
							},
				    	 	{dataIndex: 'TIME_SUM'		, width: 66, hidden: true,
					    	 	renderer: function(value, metaData, record) {							
								return Ext.util.Format.number(value, dutyTimeFormat);
								}
							}
					], hidden: true},
					{text:'평균',
				    	 columns:[
				    	 	{dataIndex: 'DAY_AVG_SUM'		, width: 66, hidden: true},
				    	 	{dataIndex: 'TIME_AVG_SUM'		, width: 66, hidden: true}
					], hidden: true}

				];
					
		Ext.each(colData, function(item, index){
			columns.push({text: item.CODE_NAME,
				columns:[ 
					{dataIndex: 'DUTY_NUM' + item.SUB_CODE, width:66, summaryType:'sum', align: 'right',
						renderer: function(value, metaData, record) {							
							return Ext.util.Format.number(value, dutyNumFormat);
						}
					},
					{dataIndex: 'DUTY_TIME' + item.SUB_CODE, width:66, summaryType:'sum', align: 'right',
						renderer: function(value, metaData, record) {							
							return Ext.util.Format.number(value, dutyTimeFormat);
						}
					}
					,
					{dataIndex: 'REF_CODE' + item.SUB_CODE, width:66, hidden: true}
			]});
		});
		columns.push({dataIndex: 'REMARK',		width: 250});
		console.log(columns);
		return columns;
	}
		
};


</script>