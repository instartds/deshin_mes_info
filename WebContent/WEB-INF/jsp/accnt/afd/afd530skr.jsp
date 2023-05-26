<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd530skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="B010"  /> 			<!-- 질권여부 -->
	<t:ExtComboStore comboType="A089"  /> 			<!-- 차입구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};

function appMain() {  
	var providerSTDT ='';   
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afd530Model', {
	   fields: [
			{name: 'ACCNT'					, text: '계정코드'			, type: 'string'},
			{name: 'ACCNT_NAME'				, text: '계정과목'			, type: 'string'},
			{name: 'BANK_CODE'				, text: '은행코드'			, type: 'string'},
			{name: 'BANK_NAME'				, text: '금융기관'			, type: 'string'},
			{name: 'SEQ'					, text: 'NO'			, type: 'string'},
			{name: 'BANK_ACCOUNT'			, text: '계좌번호'			, type: 'string'},
			{name: 'BANK_KIND'				, text: '예적금종류'		, type: 'string'},
			{name: 'PUB_DATE'				, text: '계약일'			, type: 'uniDate'},
			{name: 'EXP_DATE'				, text: '만기일'			, type: 'uniDate'},
			{name: 'MONTH_AMT'				, text: '월불입액'			, type: 'uniPrice'},
			{name: 'EXP_AMT_I'				, text: '약정금액'			, type: 'uniPrice'},
			{name: 'MONTH_0'				, text: '전년불입금액'		, type: 'uniPrice'},
			{name: 'MONTH_1'				, text: '1월'			, type: 'uniPrice'},
			{name: 'MONTH_2'				, text: '2월'			, type: 'uniPrice'},
			{name: 'MONTH_3'				, text: '3월'			, type: 'uniPrice'},
			{name: 'MONTH_4'				, text: '4월'			, type: 'uniPrice'},
			{name: 'MONTH_5'				, text: '5월'			, type: 'uniPrice'},
			{name: 'MONTH_6'				, text: '6월'			, type: 'uniPrice'},
			{name: 'MONTH_7'				, text: '7월'			, type: 'uniPrice'},
			{name: 'MONTH_8'				, text: '8월'			, type: 'uniPrice'},
			{name: 'MONTH_9'				, text: '9월'			, type: 'uniPrice'},
			{name: 'MONTH_10'				, text: '10월'			, type: 'uniPrice'},
			{name: 'MONTH_11'				, text: '11월'			, type: 'uniPrice'},
			{name: 'MONTH_12'				, text: '12월'			, type: 'uniPrice'},
			{name: 'TOT_AMT_I'				, text: '합계'			, type: 'uniPrice'},
			{name: 'INT_RATE'				, text: '이율'			, type: 'uniPercent'},
			{name: 'JAN_AMT_I'				, text: '잔액'			, type: 'uniPrice'}
	    ]
	});		// End of Ext.define('Afd530skrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afd530MasterStore1',{
		model: 'Afd530Model',
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
                read: 'afd530skrService.selectMasterList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ACCNT_NAME'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
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
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
	    		fieldLabel: '기준년월', 
	    		xtype: 'uniMonthfield',
	    		name: 'BASIS_MONTH',
	    		value: UniDate.get('today'),
	    		allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASIS_MONTH', newValue);
					}
				}

	    	},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			}]
		},{
			title: '추가정보', 	
	   		itemId: 'search_panel2',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{ 
    			fieldLabel: '당기시작년월',
    			name:'ST_DATE',
				xtype: 'uniMonthfield',
//				value: UniDate.get('today'),
				allowBlank:false,
				width: 200
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '구분',						            		
				id: 'rdoSelect',
				items: [{
						boxLabel: '전체', 
						width: 50, 
						name: 'QRY_TYPE',
						inputValue: 'A'
					},{
						boxLabel : '진행', 
						width: 50,
						name: 'QRY_TYPE',
						inputValue: 'I',
						checked: true  
					},{
						boxLabel : '마감', 
						width: 50,
						name: 'QRY_TYPE',
						inputValue: 'E'
				}]
			}/*,{
				xtype: 'radiogroup',		            		
				fieldLabel: '소계표시',						            		
				id: 'rdoSelect2',
				items: [{
					boxLabel: '예', 
					width: 50, 
					name: 'DISP_SUM',
					inputValue: 'Y',
					checked: true  
				},{
					boxLabel : '아니오', 
					width: 55,
					name: 'DISP_SUM',
					inputValue: 'N'
				}]
			}*/]		
		}],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	    		fieldLabel: '기준년월', 
	    		xtype: 'uniMonthfield',
	    		name: 'BASIS_MONTH',
	    		value: UniDate.get('today'),
	    		allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BASIS_MONTH', newValue);
					}
				}
	    	},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
			}
		],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afd530Grid1', {
    	layout : 'fit',
        region : 'center',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store: directMasterStore,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
        columns: [        
        	{dataIndex: 'ACCNT'				, width: 100, hidden: true},
        	{dataIndex: 'ACCNT_NAME'		, width: 100, locked: true, align:'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	       			return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
			}},
        	{dataIndex: 'BANK_CODE'			, width: 100, hidden: true},
        	{dataIndex: 'BANK_NAME'			, width: 100, locked: true},
        	{dataIndex: 'SEQ'				, width: 53, locked: true},
        	{dataIndex: 'BANK_ACCOUNT'		, width: 120, locked: true},
        	{dataIndex: 'BANK_KIND'			, width: 86, locked: true},
        	{dataIndex: 'PUB_DATE'			, width: 80, locked: true},
        	{dataIndex: 'EXP_DATE'			, width: 80, locked: true},
        	{dataIndex: 'MONTH_AMT'			, width: 86, locked: true, summaryType: 'sum'},
        	{dataIndex: 'EXP_AMT_I'			, width: 100, locked: true, summaryType: 'sum'},
        	{dataIndex: 'MONTH_0'			, width: 100, summaryType: 'sum'},
        	{dataIndex: 'MONTH_1'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_2'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_3'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_4'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_5'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_6'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_7'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_8'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_9'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_10'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_11'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'MONTH_12'			, width: 86, summaryType: 'sum'},
        	{dataIndex: 'TOT_AMT_I'			, width: 100, summaryType: 'sum'},
        	{dataIndex: 'INT_RATE'			, width: 66, summaryType: 'sum'},
        	{dataIndex: 'JAN_AMT_I'			, width: 100, summaryType: 'sum'}
		] 
    });    
    
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
		id : 'afd530App',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BASIS_MONTH');
			panelSearch.setValue('ACCNT_DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
		},
		onQueryButtonDown : function()	{		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
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
		}
	});
};


</script>
