<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat605ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hat605ukr"  /> 		<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H004" /> 			<!-- 근무조 -->
    <t:ExtComboStore comboType="AU" comboCode="H033" /> 			<!-- 근태코드 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var popupWin;
function appMain() {

	var confirmComboStore = Unilite.createStore('confirmComboStore', {
        fields: ['text', 'value'],
        data :  [
                     {'text':'<t:message code="system.label.human.approval" default="인정"/>'          , 'value':'Y'},
                     {'text':'<t:message code="system.label.human.disapproval" default="불인정"/>'      , 'value':'N'}
                ]
    });
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hat605ukrModel', {
		fields: [
				{name: 'DUTY_YYYYMMDD', 		text: '<t:message code="system.label.human.dutydate" default="근태일자"/>',			type: 'uniDate',editable: false},
				{name: 'DIV_CODE',				text: '<t:message code="system.label.human.division" default="사업장"/>',				type: 'string', comboType	: 'BOR120',editable: false},
				{name: 'DEPT_CODE',				text: '<t:message code="system.label.human.deptcode" default="부서코드"/>',			type: 'string',editable: false},
				{name: 'DEPT_NAME',				text: '<t:message code="system.label.human.department" default="부서"/>',				type: 'string',editable: false},
				{name: 'NAME',					text: '<t:message code="system.label.human.name" default="성명"/>',					type: 'string',editable: false},
				{name: 'PERSON_NUMB',			text: '<t:message code="system.label.human.personnumb" default="사번"/>',				type: 'string',editable: false},
				{name: 'DUTY_CODE', 			text: '<t:message code="system.label.human.dutytype" default="근태구분"/>', 			type: 'string', comboType:'AU',comboCode:'H033',editable: false},
				{name: 'FLAG', 					text: '<t:message code="system.label.human.approvalyn" default="인정여부"/>', 	type: 'string', store:Ext.StoreManager.lookup('confirmComboStore')},
				//{name: 'weekofday', 			text: '<t:message code="system.label.human.day2" default="요일"/>',			type: 'string'},
				{name: 'DUTY_NUM', 				text: '<t:message code="system.label.human.days" default="일수"/>',			type: 'string',editable: false},
				{name: 'DUTY_TIME', 			text: '<t:message code="system.label.human.hour" default="시"/>',			type: 'string',editable: false},
				{name: 'DUTY_MINU', 			text: '<t:message code="system.label.human.minute" default="분"/>',			type: 'string',editable: false},
				{name: 'WORK_TEAM', 			text: '<t:message code="system.label.human.workteam" default="근무조"/>', 			type: 'string', comboType:'AU', comboCode:'H004',editable: false},
				{name: 'REMARK'	, 				text: '<t:message code="system.label.common.remark" default="적요"/>',			type: 'string',editable: false},
				{name: 'DUTY_FR_D'				, text: '<t:message code="system.label.human.caldate" default="일자"/>'			, type: 'uniDate',editable: false},
				{name: 'DUTY_FR_H'				, text: '<t:message code="system.label.human.hour" default="시"/>'				, type: 'int', maxLength: 2,editable: false},
				{name: 'DUTY_FR_M'				, text: '<t:message code="system.label.human.minute" default="분"/>'				, type: 'int', maxLength: 2,editable: false},
				{name: 'DUTY_TO_D'				, text: '<t:message code="system.label.human.caldate" default="일자"/>'			, type: 'uniDate',editable: false},
				{name: 'DUTY_TO_H'    			, text: '<t:message code="system.label.human.hour" default="시"/>'				, type: 'int', maxLength: 2,editable: false},
				{name: 'DUTY_TO_M'    			, text: '<t:message code="system.label.human.minute" default="분"/>'				, type: 'int', maxLength: 2,editable: false},
				{name: 'PAY_PROV_FLAG'    		, text: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>'				, type: 'string', editable: false},
				{name: 'DUTY_YYYYMMDD_FR'		, text: '<t:message code="system.label.human.dutydate" default="근태일자"/>',			type: 'uniDate',editable: false},
				{name: 'DUTY_YYYYMMDD_TO'		, text: '<t:message code="system.label.human.dutydate" default="근태일자"/>',			type: 'uniDate',editable: false},
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hat605ukrMasterStore1',{
		model: 'Hat605ukrModel',
		groupField:'PERSON_NUMB',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy:  Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
    		api: {
    			read: 'hat605ukrService.selectList',
    			update: 'hat605ukrService.updateList',
    			syncAll: 'hat605ukrService.saveAll'
    		}
    	}),
		loadStoreRecords: function() {
			
			if(Ext.getCmp('searchForm').getInvalidMessage())	{
				var param = Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();           
             if(inValidRecs.length == 0 )    {
                 this.syncAllDirect();     
             }else {
                 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
             }
		}
	});	//End of var directMasterStore1 = Unilite.createStore('hat605ukrMasterStore1',{

	
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
				fieldLabel: '<t:message code="system.label.human.dutydate" default="근태일자"/>',
				xtype: 'uniDatefield',
				name: 'ORDER_DATE',
				allowBlank:false,    
				listners:{
                	blur: function(field, eOpts) {
                		if(panelResult) {
						panelResult.setValue('ORDER_DATE', field.getValue());						
                		}
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
				fieldLabel: '<t:message code="system.label.human.dutytype" default="근태구분"/>',
				name: 'DUTY_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H033',
				multiSelect:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						var exdeptDutyCode = panelSearch.getValue('EXCEPT_DUTY_CODE')	
						if(!Ext.isEmpty(exdeptDutyCode) && !Ext.isEmpty(newValue))	{
							Ext.each(newValue,
									 function(item,idx){
										if(UniUtils.indexOf(item, exdeptDutyCode))	{
											Unilite.messageBox("근태구분제외로 선택된 코드 입니다.");
											newValue.pop()
											field.setValue(newValue);
										}
									 });
						}
						panelResult.setValue('DUTY_CODE', newValue);
					}
				}
			},{
				fieldLabel: '근태구분제외',
				name: 'EXCEPT_DUTY_CODE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H033',
				multiSelect:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						var dutyCode = panelSearch.getValue('DUTY_CODE');
						if(!Ext.isEmpty(dutyCode) && !Ext.isEmpty(newValue))	{
							Ext.each(newValue,
									 function(item,idx){
										if(UniUtils.indexOf(item, dutyCode))	{
											Unilite.messageBox("근태구분제외로 선택된 코드 입니다.");
											newValue.pop()
											field.setValue(newValue);
										}
									 });
						}
						panelResult.setValue('EXCEPT_DUTY_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.approvalyn" default="인정여부"/>',
				name: 'FLAG', 
				xtype: 'radiogroup',
				width: 300,
				items: [
					{ boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', name: 'FLAG', inputValue: '' , checked: true},
		            { boxLabel: '<t:message code="system.label.human.approval" default="인정"/>', name: 'FLAG', inputValue: 'Y' },
		            { boxLabel: '<t:message code="system.label.human.disapproval" default="불인정"/>', name: 'FLAG', inputValue: 'N'}
		         ],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('FLAG', newValue);
					}
				}
			},{
	        	fieldLabel: '0 제외',
	        	name: 'VALUE_CHECK',
				value: true,
				xtype: 'checkbox',
				labelWidth: 100,
				//tdAttrs: {align : 'right'}
				padding: '0 0 0 30'
			}] 
		}]
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns :	4, tableAttrs:{width:'100%', border:0}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		
		items: [{ 
			fieldLabel: '<t:message code="system.label.human.dutydate" default="근태일자"/>',
			xtype: 'uniDatefield',
			name: 'ORDER_DATE',
			tdAttrs:{style:"width:350px;"},
			allowBlank:false,   
			listeners:{
	            blur: function(field, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE', field.getValue());						
	            	}
			    }
			}
		},{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			colspan : 2,
			tdAttrs:{style:"width:310px;"},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		{
			xtype:'container',
			flex:1,
			tdAttrs:{style:"width:90%; "},
			layout:{type:'uniTable', columns:3, tableAttrs:{style:'text-align:right;width:100%;padding-right:20px;'}, tdAttrs:{style:'padding-top:0px;padding-left:5px;padding-bottom:3px;', align:'right'}},
			items:[
				{
					xtype:'button',
					text:'<t:message code="system.label.human.cancelapproval" default="작업취소"/>',
					width:100,
					handler:function()	{
						if(!UniAppManager.app._needSave()){
							cancelPopup(); 
						}
					}
				}
				
			]
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
			width:350,
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
			colspan:3,
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
			fieldLabel: '<t:message code="system.label.human.dutytype" default="근태구분"/>',
			name: 'DUTY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H033',
			multiSelect:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var exdeptDutyCode = panelSearch.getValue('EXCEPT_DUTY_CODE');
					if(!Ext.isEmpty(exdeptDutyCode) && !Ext.isEmpty(newValue))	{
						Ext.each(newValue,
								 function(item,idx){
									if(UniUtils.indexOf(item, exdeptDutyCode))	{
										Unilite.messageBox("근태구분제외로 선택된 코드 입니다.");
										newValue.pop()
										field.setValue(newValue);
									}
								 });
					}
					panelSearch.setValue('DUTY_CODE', newValue);
				}
			}
		},{
			fieldLabel: '근태구분제외',
			name: 'EXCEPT_DUTY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H033',
			multiSelect:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var dutyCode = panelSearch.getValue('DUTY_CODE');	
					if(!Ext.isEmpty(dutyCode) && !Ext.isEmpty(newValue))	{
					Ext.each(newValue,
							 function(item,idx){
								if(UniUtils.indexOf(item, dutyCode))	{
									Unilite.messageBox("근태구분제외로 선택된 코드 입니다.");
									newValue.pop()
									field.setValue(newValue);
								}
							 });
					}
					panelSearch.setValue('EXCEPT_DUTY_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.approvalyn" default="인정여부"/>',
			name: 'FLAG', 
			xtype: 'radiogroup',
			width: 300,
			//colspan:2,
			items: [
				{ boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', name: 'FLAG', inputValue: '' , checked: true},
				{ boxLabel: '<t:message code="system.label.human.approval" default="인정"/>', name: 'FLAG', inputValue: 'Y' },
	            { boxLabel: '<t:message code="system.label.human.disapproval" default="불인정"/>', name: 'FLAG', inputValue: 'N'}
	         ],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('FLAG', newValue);
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
    var masterGrid = Unilite.createGrid('hat605ukrGrid1', {
    	// for tab    	
        layout: 'fit',
        region:'center',
        sortableColumns: false,
        uniOpt:{
			onLoadSelectFirst : false
		},
        selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }), 
    	store: directMasterStore1,
        features: [ 
			{id: 'masterGrid1SubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false}
		], 
		viewConfig:{
			getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	var valueCheck = panelSearch.getValue('VALUE_CHECK');
	        	
	          	if(!valueCheck && (record.get('DUTY_NUM') != '0' || record.get('DUTY_TIME') != '0' || record.get('DUTY_MINU') != '0')){
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
		},
		tbar :[
			{
				xtype:'button',
				text:'<t:message code="system.label.human.confirmWorkingTime" default="일괄근태인정"/>',
				width:100,
				handler:function()	{
					var records = masterGrid.getSelectedRecords();
					Ext.each(records, function(record, idx){
						record.set("FLAG","Y");	
					});
				}
			},{
				xtype:'button',
				text:'<t:message code="system.label.human.denyWorkingTime" default="일괄근태불인정"/>',
				width:100,
				handler:function()	{
					var records = masterGrid.getSelectedRecords();
					Ext.each(records, function(record, idx){
						record.set("FLAG","N");	
					});
				}
			}
		],
    	columns: [
    		
			{dataIndex: 'DIV_CODE',			width: 100},
   			{dataIndex: 'DUTY_YYYYMMDD',	width: 86, hidden:true},
			{dataIndex: 'DEPT_CODE',		width: 86, hidden: true},
			{dataIndex: 'DEPT_NAME',		width: 120},
			{dataIndex: 'PERSON_NUMB',		width: 100},
			{dataIndex: 'NAME',				width: 93},
			{dataIndex: 'WORK_TEAM',		width: 100},
			{dataIndex: 'FLAG',		width: 66},
			{dataIndex: 'DUTY_CODE',		width: 100},
			{dataIndex: 'DUTY_NUM',		width: 50, align: 'right'},
			{dataIndex: 'DUTY_TIME',		width: 50, align: 'right'},
			{dataIndex: 'DUTY_MINU',		width: 50, align: 'right'},
			{text: '<t:message code="system.label.human.attendtime" default="출근시간"/>',
        		columns: [
					{dataIndex: 'DUTY_FR_D'			, width: 80, editor:
						{
					        xtype: 'datefield',
					        allowBlank: false,
					        format: 'Y/m/d'
					    }
					},
					{dataIndex: 'DUTY_FR_H'			, width:50, align: 'right'},
					{dataIndex: 'DUTY_FR_M'			, width: 50, align: 'right'}
				]
			},{text: '<t:message code="system.label.human.offworktime" default="퇴근시간"/>',
        		columns: [
					{dataIndex: 'DUTY_TO_D'			, width: 80, editor: 
						{
					        xtype: 'datefield',
					        allowBlank: false,
					        format: 'Y/m/d'
					    }
					},
					{dataIndex: 'DUTY_TO_H'    		, width: 66, align: 'right'},
					{dataIndex: 'DUTY_TO_M'    		, width: 66, align: 'right'}
				]
			}
		],
		listeners:{
			beforeedit : function( editor, context, eOpts)	{
				if(context.field != "FLAG")	{
					return false;
				}
			}
		}
    });//End of var masterGrid = Unilite.createGrid('hat605ukrGrid1', {
	
    function cancelPopup ()  { 

        if(!popupWin) {
                Unilite.defineModel('cancelModel', {
                    fields: [
                    	{name: 'DUTY_YYYYMMDD', 		text: '<t:message code="system.label.human.dutydate" default="근태일자"/>',			type: 'uniDate',editable: false},
        				{name: 'DIV_CODE',				text: '<t:message code="system.label.human.division" default="사업장"/>',				type: 'string', comboType	: 'BOR120',editable: false},
        				{name: 'DEPT_CODE',				text: '<t:message code="system.label.human.deptcode" default="부서코드"/>',			type: 'string',editable: false},
        				{name: 'DEPT_NAME',				text: '<t:message code="system.label.human.department" default="부서"/>',				type: 'string',editable: false},
        				{name: 'NAME',					text: '<t:message code="system.label.human.name" default="성명"/>',					type: 'string',editable: false},
        				{name: 'PERSON_NUMB',			text: '<t:message code="system.label.human.personnumb" default="사번"/>',				type: 'string',editable: false},
        				{name: 'DUTY_CODE', 			text: '<t:message code="system.label.human.dutytype" default="근태구분"/>', 			type: 'string', comboType:'AU',comboCode:'H033',editable: false},
        				{name: 'FLAG_Y_COUNT', 			text: '<t:message code="system.label.human.approval" default="인정"/>', 				type: 'int'},
        				{name: 'FLAG_N_COUNT', 			text: '<t:message code="system.label.human.disapproval" default="불인정"/>', 			type: 'int'},
        				{name: 'FLAG_COUNT', 			text: '<t:message code="system.label.human.whole" default="전체"/>', 					type: 'int'},
        				{name: 'CANCELACTION', 			text: 'CANCELACTION', 																type: 'string', defaultValue:'L' }
                                
                     ]
                });
                var cancelProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
                    api: {
                        read : 'hat605ukrService.selectCancelList',
                        update:'hat605ukrService.updateCancelList',
                        syncAll:'hat605ukrService.saveCancel'
                    }
                });
                
                var cancelStore = Unilite.createStoreSimple('cancelStore', {
                        model: 'cancelModel' ,
                        proxy: cancelProxy,            
                        
                        loadStoreRecords : function()   {
                            var param= popupWin.down('#search').getValues();    
                            
                            this.load({
                                params: param
                            });             
                        },
                        saveStore : function(config)	{				
                			var inValidRecs = this.getInvalidRecords();      
                			popupWin.getEl().mask();
                            if(inValidRecs.length == 0 )    {
                            	var config = {
                                        success: function(batch, option) {
                                        	popupWin.getEl().unmask();
                                        	cancelStore.loadStoreRecords();
                                        } 
                                    };  
                            
                                this.syncAllDirect(config);     
                            }
                		}
                });
                popupWin = Ext.create('widget.uniDetailWindow', {
                    title: '작업취소',
                    width: 800,                             
                    height:800,
                    
                    layout: {type:'vbox', align:'stretch'},                 
                    items: [{
                    	itemId:'search',
                        xtype:'uniSearchForm',
                    	layout : {type : 'uniTable', columns :	2, tableAttrs:{width:'100%', border:0}},
                		padding:'1 1 1 1',
                		border:true,
                		hidden: !UserInfo.appOption.collapseLeftSearch,
                		
                		items: [
                			{ 
	                			fieldLabel: '<t:message code="system.label.human.dutydate" default="근태일자"/>',
	                			xtype: 'uniDatefield',
	                			name: 'ORDER_DATE',
	                			allowBlank:false
	                		},{
	                			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
	                			name: 'DIV_CODE',
	                			xtype: 'uniCombobox',
	                			comboType: 'BOR120'
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
	                			useLike:true
	                		}),			
	                	     	Unilite.popup('Employee',{ 
	                			validateBlank: false,
	                			listeners: {
	                				onClear: function(type)	{
	                					var form = popupWin.down('#search');
	                					form.setValue('PERSON_NUMB', '');
	                					form.setValue('NAME', '');
	                				}
	                			}
	                		})
                           ]
                        },
                        Unilite.createGrid('', {
                            itemId:'grid',
                            layout : 'fit',
                            store: cancelStore,
                            selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }), 
                            uniOpt:{
                                onLoadSelectFirst : false
                            },
                            columns:  [  
                            		 { dataIndex: 'DIV_CODE'           ,width: 100 } 
                                    ,{ dataIndex: 'DUTY_YYYYMMDD'            ,width: 80  }   
                                    ,{ dataIndex: 'DEPT_CODE'      ,width: 80 , hidden:true} 
                                    ,{ dataIndex: 'DEPT_NAME'     ,width: 100} 
                                    ,{ dataIndex: 'PERSON_NUMB'           ,width: 80  } 
                                    ,{ dataIndex: 'NAME'       ,width: 80}   
									,{ text :'<t:message code="system.label.human.approvalyn" default="인정여부"/>',
									   columns:[
		                                     { dataIndex: 'FLAG_COUNT'        ,width: 60 } 
		                                    ,{ dataIndex: 'FLAG_Y_COUNT'        ,width: 60 } 
	                                    	,{ dataIndex: 'FLAG_N_COUNT'       ,width: 60}  
										]
									}
                            ]
                            ,listeners: {                                       
                                    select : function( rowModel, record, index, eOpts) {
                                    	if(record)	{
                                    		record.set('CANCELACTION', "U");
                                    	}
                                    },
                                    deselect:function  (rowModel, record, index, eOpts ) {                    
                                    	if(record)	{
                                    		record.set('CANCELACTION', "L");
                                    	}
                                    }
                             }
                            
                        })
                           
                    ],
                    tbar:  ['->',
                         {
                            itemId : 'searchtBtn',
                            text: '<t:message code="system.label.human.inquiry" default="조회"/>',
                            handler: function() {
                                var form = popupWin.down('#search');
                                var store = Ext.data.StoreManager.lookup('cancelStore')
                                cancelStore.loadStoreRecords();
                            },
                            disabled: false
                        },
                         {
                            itemId : 'submitBtn',
                            text: '<t:message code="system.label.human.cancel" default="취소"/><t:message code="system.label.human.execute" default="실행"/>',
                            handler: function() {
                            	cancelStore.saveStore();
                            },
                            disabled: false
                        },{
                            itemId : 'closeBtn',
                            text: '<t:message code="system.label.human.close" default="닫기"/>',
                            handler: function() {
                                popupWin.hide();
                            },
                            disabled: false
                        }
                    ],
                    listeners : {beforehide: function(me, eOpt) {
                                    popupWin.down('#search').clearForm();
                                    popupWin.down('#grid').reset();
                                    UniAppManager.app.onQueryButtonDown();
                                },
                                 beforeclose: function( panel, eOpts )  {
                                    popupWin.down('#search').clearForm();
                                    popupWin.down('#grid').reset();
                                    UniAppManager.app.onQueryButtonDown();
                                },
                                 show: function( panel, eOpts ) {
                                    var form = popupWin.down('#search');
                                    form.setValue("ORDER_DATE", panelResult.getValue("ORDER_DATE"));
                                    form.setValue("DIV_CODE", panelResult.getValue("DIV_CODE"));
                                    form.setValue("DEPTS", panelResult.getValue("DEPTS"));
                                    form.setValue("DEPT", panelResult.getValue("DEPT"));
                                    form.setValue("DEPT_NAME", panelResult.getValue("DEPT_NAME"));
                                    form.setValue("PERSON_NUMB", panelResult.getValue("PERSON_NUMB"));
                                    form.setValue("NAME", panelResult.getValue("NAME"));
                                    cancelStore.loadStoreRecords();
                                 }
                    },
                    
                });
        }   
        if(!Ext.isEmpty(popupWin))	{
            popupWin.center();      
            popupWin.show();
        }
        return popupWin;
    }	
    	
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
		id: 'hat605ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE', UniDate.get('today'));		
			//UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ORDER_DATE');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();

		},
		onSaveDataButtonDown: function() {
			if(directMasterStore1.isDirty()) {
				directMasterStore1.saveStore();
			}
			
		},
		onResetButtonDown: function(){
			
			directMasterStore1.loadData({})
            directMasterStore1.clearData();
            panelResult.clearForm();
            panelSearch.clearForm();
            UniAppManager.app.fnInitBinding();
        }
	});
};


</script>
