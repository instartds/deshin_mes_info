<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp130rkrv">
	<t:ExtComboStore comboType="BOR120"/>
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />
	<t:ExtComboStore comboType="AU" comboCode="M001" />
	<t:ExtComboStore comboType="AU" comboCode="M201" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /><!--대분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /><!--중분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /><!--소분류-->
	<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype		: 'radiogroup',	
				fieldLabel	: '보고서유형',
			    height      : 50,
				id			: 'sPrintFlag',
				items		: [{
					boxLabel	: '작업지시별', 
					width		: 90, 
					name		: 'sPrintFlag',
        			inputValue	: 'WKORDNUM',
					checked		: true  
				},{
					boxLabel	: '<t:message code="system.label.product.routingby" default="공정별"/>', 
					width		: 90,
        			inputValue	: 'PROGWORK',
					name		: 'sPrintFlag'
				}]
			},{
	    	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox', 
	    	comboType:'BOR120', 
	    	allowBlank:false,
	    	value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
    	},{
        	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
        	name: 'WORK_SHOP_CODE',
        	xtype: 'uniCombobox', 
        	allowBlank: false,
        	store: Ext.data.StoreManager.lookup('wsList')
        },{
    		fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
    		xtype: 'uniDateRangefield',
    		startFieldName: 'PRODT_START_DATE',
    		endFieldName: 'PRODT_END_DATE',
    		startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
    		width:315,
    		allowBlank: false,
    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    }
		},{ 
			xtype: 'container',
            layout: {type: 'hbox', align:'stretch' },
            width:325,
            defaultType: 'uniTextfield',
            items: [{
            	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
            	suffixTpl: '&nbsp;~&nbsp;',
            	name: 'WKORD_NUM_FR', 
            	width:218
            },{
	            hideLabel : true, 
	            name: 'WKORD_NUM_TO', 
	            width:107
            }
		]},Unilite.popup('DIV_PUMOK', { 
			fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
			valueFieldName: 'ITEM_CODE', 
			textFieldName: 'ITEM_NAME', 
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type)	{
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE' : panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
			name: 'ITEM_LEVEL1',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLeve1Store'),
			child: 'ITEM_LEVEL2'
		},{
			fieldLabel: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
			name: 'ITEM_LEVEL2',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLeve2Store'),
			child: 'ITEM_LEVEL3'
		},{
			fieldLabel: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
			name: 'ITEM_LEVEL3',
			colspan: 2,
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
	        parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	        levelType:'ITEM'
		},Unilite.popup('PROG_WORK_CODE',{ 
				fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>',
        		listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type)	{
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE'		: panelResult.getValue('DIV_CODE')});
						popup.setExtParam({'WORK_SHOP_CODE' : panelResult.getValue('WORK_SHOP_CODE')});
					}
				}
		}),{
				xtype		: 'radiogroup',		            		
				fieldLabel	: '<t:message code="system.label.product.processstatus" default="진행상태"/>',						            		
				id			: 'rdoSelect',
				items		: [{
					boxLabel	: '<t:message code="system.label.product.whole" default="전체"/>', 
					width		: 70, 
					name		: 'rdoSelect',
        			inputValue	: '1',
					checked		: true  
				},{
					boxLabel	: '<t:message code="system.label.product.process" default="진행"/>', 
					width		: 70,
        			inputValue	: '2',
					name		: 'rdoSelect'
				},{
					boxLabel	: '<t:message code="system.label.product.completion" default="완료"/>', 
					width		: 70,
        			inputValue	: '3',
					name		: 'rdoSelect'
				},{
					boxLabel	: '<t:message code="system.label.product.closing" default="마감"/>', 
					width		: 70,
        			inputValue	: '4',
					name		: 'rdoSelect'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						if(newValue.rdoSelect == "1"){
							panelResult.setValue("WORK_END_YN",'')
							panelResult.setValue("CONTROL_STATUS",'')
						}
						if(newValue.rdoSelect == "2"){
							panelResult.setValue("WORK_END_YN",'N')
							panelResult.setValue("CONTROL_STATUS",'')
						}
						if(newValue.rdoSelect == "3"){
							panelResult.setValue("WORK_END_YN",'Y')
							panelResult.setValue("CONTROL_STATUS",'')
						}
						if(newValue.rdoSelect == "4"){
							panelResult.setValue("WORK_END_YN",'N')
							panelResult.setValue("CONTROL_STATUS",'9')
						}
					}
				}
			},{
				fieldLabel: ' ',
    			xtype: 'uniTextfield',
    			name:'WORK_END_YN',
    			hidden:true
			},{
				fieldLabel: ' ',
    			xtype: 'uniTextfield',
    			name:'CONTROL_STATUS',
    			hidden:true
			}
		]
    });		

    
    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}	
		],	
		id  : 'pmp130rkrvApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE',UniDate.get('today'));
			panelResult.setValue('PRODT_END_DATE',UniDate.get('today'));
			panelResult.getField('sPrintFlag').setValue("WKORDNUM");
			panelResult.getField('rdoSelect').setValue("1");
			UniAppManager.setToolbarButtons('print',true);
			UniAppManager.setToolbarButtons('query',false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
        	if(this.onFormValidate()){
        		var param = panelResult.getValues();
				var prgID = param["sPrintFlag"] == "WKORDNUM"?'pmp130rkr':'pmp130rkr2'
				var win = Ext.create('widget.PDFPrintWindow', {
					url: CPATH+'/prodt/pmp130rkrPrint.do',
					prgID: prgID,
						extParam: param
					});
					win.center();
					win.show();
        	}
			
		},
	    onFormValidate: function(){
	    	var r= true
	        var invalid = panelResult.getForm().getFields().filterBy(
	     		function(field) {
					return !field.validate();
				}
		    );
   	
			if(invalid.length > 0) {
				r=false;
				var labelText = ''
	
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+' : ';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
				}
	
			   	alert(labelText+Msg.sMB083);
			   	invalid.items[0].focus();
			}
			return r;
	    }
	});
};

</script>