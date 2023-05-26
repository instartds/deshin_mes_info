<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="had830ukr"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
<t:ExtComboStore comboType="AU" comboCode="H034" /> <!-- 공제코드 -->


</t:appConfig>

<script type="text/javascript" >

function appMain() {
	Ext.create('Ext.data.Store', {
		storeId:"gubun",
	    fields: ['text', 'value'],
	    data : [
	        {text:"중도퇴사",   value:"Y"},
	        {text:"연말정산", 	value:"N"}
	    ]
	});
	
	var panelSearch = Unilite.createForm('had830ukrDetail', {		
    	  disabled :false
    	, id: 'searchForm'
        , flex:1        
        , layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
        , defaults: {labelWidth: 100}
	    , items :[{
			xtype: 'radiogroup',		            		
			fieldLabel: '반영구분',						            		
			items: [{
				boxLabel: '총괄반영', 
				width: 70, 
				name: 'RETR_FLAG',
				inputValue: 'Y'
			},{
				boxLabel : '개별반영', 
				width: 70,
				name: 'RETR_FLAG',
				inputValue: 'N' 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					if(newValue.RETR_FLAG == 'Y'){	//총괄반영
						panelSearch.getField('SUPP_CODE1').setReadOnly(true);
						panelSearch.getField('SUPP_CODE2').setReadOnly(true);
						panelSearch.getField('SUPP_CODE3').setReadOnly(true);
						
						panelSearch.getField('SUPP_CODE').setReadOnly(false);
					}else{	//개별반영
						panelSearch.getField('SUPP_CODE').setReadOnly(true);
						
						panelSearch.getField('SUPP_CODE1').setReadOnly(false);
						panelSearch.getField('SUPP_CODE2').setReadOnly(false);
						panelSearch.getField('SUPP_CODE3').setReadOnly(false);
					}
				}
			}
		},{
			fieldLabel: '정산구분',
			name: 'RETURN_TYPE', 
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('gubun'),
			allowBlank: false,
			value: 'Y'
		},{
			fieldLabel: '정산년도',
			name: 'BASE_DATE', 
			xtype: 'uniYearField',
			value: new Date().getFullYear(),
			allowBlank: false
		},{
			fieldLabel: '반영년월',
			id: 'frToDate',
			xtype: 'uniMonthfield',
			name: 'PAY_YYMM',                    
			value: new Date(),                    
			allowBlank: false
		},{
			fieldLabel: '지급구분',
			name: 'PROV_TYPE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H032',
			allowBlank: false,
			value: '1'
		},{
			fieldLabel: '공제코드',
			name: 'SUPP_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H034',
			allowBlank: false
		},{
			fieldLabel: '차감소득세',
			name: 'SUPP_CODE1', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H034',
			allowBlank: false
		},{
			fieldLabel: '차감주민세',
			name: 'SUPP_CODE2', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H034',
			allowBlank: false
		},{
			fieldLabel: '차감농특세',
			name: 'SUPP_CODE3', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H034',
			allowBlank: false
		},{
			fieldLabel: '사업장',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value: UserInfo.divCode			
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
//                    	panelResult.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
//                    	panelResult.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),{
			fieldLabel: '지급차수',
			name: 'PAY_DAY_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031'
		},{
			fieldLabel: '급여지급방식',
			name: 'PAY_CODE', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028'
		},			
	     	Unilite.popup('Employee',{ 
			
			validateBlank: false, 
            listeners: {
                 onSelected: {
                    fn: function(records, type) {
                    },
                      scope: this
                 },
                 onClear: function(type) {
                     panelSearch.setValue('PERSON_NUMB', '');
                     panelSearch.setValue('NAME', '');
                 }
            }
		}),{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'hbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[{
	    		width : 80,
	    		xtype: 'button',
	    		text: '실행',
	    		handler: function(){
	    			var param = panelSearch.getValues();
					if(!panelSearch.checkValid()) {
						return;
					}
	    			panelSearch.getEl().mask('로딩중...','loading-indicator');
	    			had830ukrService.doBatch(param, function(provider, response)	{
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);
						}
						panelSearch.getEl().unmask();
					});
	    		}
	    	},{
	    		width : 80,
	    		xtype: 'button',
	    		margin: '0 0 0 8',
	    		text: '취소',
	    		handler: function(){
	    			var param = panelSearch.getValues();
	    			if(!panelSearch.checkValid()) {
						return;
					}
	    			panelSearch.getEl().mask('로딩중...','loading-indicator');
	    			had830ukrService.cancelBatch(param, function(provider, response)	{
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);
						}
						panelSearch.getEl().unmask();
					});
	    		}
	    	}]
	    }] ,
    	checkValid:function()	{
    		var me=this;
    		var values = me.getValues();
    		var retrFlag = values["RETR_FLAG"];
    		if(Ext.isEmpty(me.getValue("RETURN_TYPE")))	{
    			alert("정산구분은 필수 입력입니다.")
    			me.getField("RETURN_TYPE").focus();
    			return false;
    		}
    		if(Ext.isEmpty(me.getValue("BASE_DATE")))	{
    			alert("정산년도은 필수 입력입니다.")
    			me.getField("BASE_DATE").focus();
    			return false;
    		}
    		if(Ext.isEmpty(me.getValue("PAY_YYMM")))	{
    			alert("반영년월은 필수 입력입니다.")
    			me.getField("PAY_YYMM").focus();
    			return false;
    		}
    		if(Ext.isEmpty(me.getValue("PROV_TYPE")))	{
    			alert("지급구분은 필수 입력입니다.")
    			me.getField("PROV_TYPE").focus();
    			return false;
    		}
    		if(retrFlag == "Y")	{
	    		if(Ext.isEmpty(me.getValue("SUPP_CODE")))	{
	    			alert("공제코드는 필수 입력입니다.")
	    			me.getField("SUPP_CODE").focus();
	    			return false;
	    		}
    		}else {
	    		if(Ext.isEmpty(me.getValue("SUPP_CODE1")))	{
	    			alert("차감소득세는 필수 입력입니다.")
	    			me.getField("SUPP_CODE1").focus();
	    			return false;
	    		}
	    		if(Ext.isEmpty(me.getValue("SUPP_CODE2")))	{
	    			alert("차감주민세는 필수 입력입니다.")
	    			me.getField("SUPP_CODE2").focus();
	    			return false;
	    		}
	    		if(Ext.isEmpty(me.getValue("SUPP_CODE3")))	{
	    			alert("차감농특세는 필수 입력입니다.")
	    			me.getField("SUPP_CODE3").focus();
	    			return false;
	    		}
    		}
    		return true;
    	}     
	});
	
	 Unilite.Main( {
		items:[
	 		 panelSearch
		],
		id  : 'had830ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'query'], false);
			panelSearch.getField('RETR_FLAG').setValue('Y');
		}
	});

};


</script>
