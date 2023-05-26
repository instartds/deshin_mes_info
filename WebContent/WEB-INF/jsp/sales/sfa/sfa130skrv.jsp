<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa130skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="sfa130skrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {

    var BsaCodeInfo = { // 컨트롤러에서 값을 받아옴
        gsMoneyUnit:        '${gsMoneyUnit}'
    };
	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('Sfa130skrvModel', {
	    fields: [
	    	{name: 'CUSTOM_CODE'	,text:'<t:message code="system.label.sales.custom" default="거래처코드"/>'			,type:'string'},
		    {name: 'CUSTOM_NAME'	,text:'<t:message code="system.label.sales.customname" default="거래처"/>'		,type:'string'},
		    {name: 'MONEY_UNIT'		,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type:'string'},
		    {name: 'YEAR_AMT'		,text:'<t:message code="system.label.sales.yearuncollected" default="당해년도미수"/>',type:'uniPrice'},
		    {name: 'GUBUN'			,text:'<t:message code="system.label.sales.classfication" default="구분"/>'		,type:'string'},
		    {name: 'TOT_AMT'		,text:'<t:message code="system.label.sales.totalamount" default="합계"/>'			,type:'uniPrice'},
		    {name: '1MONTH'			,text:'<t:message code="system.label.sales.january" default="1월"/>'			    ,type:'uniPrice'},
		    {name: '2MONTH'			,text:'<t:message code="system.label.sales.february" default="2월"/>'			,type:'uniPrice'},
		    {name: '3MONTH'			,text:'<t:message code="system.label.sales.march" default="3월"/>'			    ,type:'uniPrice'},
		    {name: '4MONTH'			,text:'<t:message code="system.label.sales.april" default="4월"/>'			    ,type:'uniPrice'},
		    {name: '5MONTH'			,text:'<t:message code="system.label.sales.may" default="5월"/>'			    	,type:'uniPrice'},
		    {name: '6MONTH'			,text:'<t:message code="system.label.sales.june" default="6월"/>'			    ,type:'uniPrice'},
		    {name: '7MONTH'			,text:'<t:message code="system.label.sales.july" default="7월"/>'			    ,type:'uniPrice'},
		    {name: '8MONTH'			,text:'<t:message code="system.label.sales.august" default="8월"/>'			    ,type:'uniPrice'},
		    {name: '9MONTH'			,text:'<t:message code="system.label.sales.september" default="9월"/>'			,type:'uniPrice'},
		    {name: '10MONTH'		,text:'<t:message code="system.label.sales.october" default="10월"/>'			,type:'uniPrice'},
		    {name: '11MONTH'		,text:'<t:message code="system.label.sales.november" default="11월"/>'			,type:'uniPrice'},
		    {name: '12MONTH'		,text:'<t:message code="system.label.sales.december" default="12월"/>'			,type:'uniPrice'},
			{name: 'DIV_CODE'		,text:'<t:message code="system.label.sales.division" default="사업장"/>'		    ,type:'string' , comboType: 'BOR120'}
	    ]
	});


	/**
	 * Store 정의(Service 정의)
	 * @type
	 */

var directMasterStore1 = Unilite.createStore('sfa130skrvMasterStore1',{
		model: 'Sfa130skrvModel',
		uniOpt: {
        	isMaster: true,	// 상위 버튼 연결
            editable: false,	// 수정 모드 사용
            deletable: false,	// 삭제 가능 여부
	        useNavi : false		// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {
            	read: 'sfa130skrvService.selectList1'
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.GS_MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;
			param.S_YEAR = panelSearch.getValue('SALE_YEAR') - 1;
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'CUSTOM_NAME'
	}); //End of var directMasterStore1 = Unilite.createStore('sfa130skrvMasterStore1',{


 	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type : 'vbox', align : 'stretch'},
	    	items: [{
	    		xtype:'container',
	    		layout: {type: 'uniTable', columns : 1},
	    		items: [{
	    			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	    			name: 'DIV_CODE',
	    			xtype: 'uniCombobox',
	    			comboType:'BOR120',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
	        	}, {
	        		fieldLabel: '<t:message code="system.label.sales.salesyear" default="매출년도"/>',
	        		name: 'SALE_YEAR',
					xtype: 'uniYearField',
					value: new Date().getFullYear(),
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SALE_YEAR', newValue);
						}
					}
	        	}, {
	        		fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
	        		name:'AGENT_TYPE',
	        		xtype: 'uniCombobox',
	        		comboType:'AU',
	        		comboCode:'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
	        	}, {
					xtype: 'radiogroup',
				    fieldLabel: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
				    labelWidth:90,
				    items: [{
					    boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
					    width: 80,
					    name: 'RDO',
					    inputValue: 'S',
					    checked: true
				    }, {
					    boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
					    width: 60,
					    name: 'RDO' ,
					    inputValue: 'T'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('RDO').setValue(newValue.RDO);
						}
					}
				},
					Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),{
				    fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				    name:'AREA_TYPE',
				    xtype: 'uniCombobox',
				    comboType:'AU',
				    comboCode:'B056',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AREA_TYPE', newValue);
						}
					}
				},{
                    fieldLabel: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
                    name:'MONEY_UNIT',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'B004' ,
                    displayField: 'value',
                    fieldStyle: 'text-align: center;',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('MONEY_UNIT', newValue);
                        }
                    }
                }]
			}]
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
	items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
    	}, {
    		fieldLabel: '<t:message code="system.label.sales.salesyear" default="매출년도"/>',
    		name: 'SALE_YEAR',
			xtype: 'uniYearField',
			value: new Date().getFullYear(),
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_YEAR', newValue);
				}
			}
    	}, {
    		fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
    		name:'AGENT_TYPE',
    		xtype: 'uniCombobox',
    		comboType:'AU',
    		comboCode:'B055',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
    	}, {
			xtype: 'radiogroup',
		    fieldLabel: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
		    labelWidth:90,
		    items: [{
			    boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
			    width: 80,
			    name: 'RDO',
			    inputValue: 'S',
			    checked: true
		    }, {
			    boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>',
			    width: 60,
			    name: 'RDO' ,
			    inputValue: 'T'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('RDO').setValue(newValue.RDO);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
		    fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
		    name:'AREA_TYPE',
		    xtype: 'uniCombobox',
		    comboType:'AU',
		    comboCode:'B056',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AREA_TYPE', newValue);
				}
			}
		},{
            fieldLabel: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
            name:'MONEY_UNIT',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B004' ,
            displayField: 'value',
            fieldStyle: 'text-align: center;',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('MONEY_UNIT', newValue);
                }
            }
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                }
            }
            return r;
        }
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('sfa130skrvGrid1', {
    	region: 'center',
    	layout : 'fit',
      	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	}, {
    	id: 'masterGridTotal',
    	ftype: 'uniSummary',
    	showSummaryRow: false} ],
        columns: [
			 {dataIndex: 'DIV_CODE'		, width: 93, hidden:false},
       		 {dataIndex: 'CUSTOM_CODE'	, width: 80, hidden:true},
			 {dataIndex: 'CUSTOM_NAME'	, width: 100, hidden:true},
			 {dataIndex: 'MONEY_UNIT'	, width: 66, hidden:true},
			 {dataIndex: 'YEAR_AMT'		, width: 100},
			 {dataIndex: 'GUBUN'		, width: 106},
			 {dataIndex: 'TOT_AMT'		, width: 100},
			 {dataIndex: '1MONTH'		, width: 100},
			 {dataIndex: '2MONTH'		, width: 100},
			 {dataIndex: '3MONTH'		, width: 100},
			 {dataIndex: '4MONTH'		, width: 100},
			 {dataIndex: '5MONTH'		, width: 100},
			 {dataIndex: '6MONTH'		, width: 100},
			 {dataIndex: '7MONTH'		, width: 100},
			 {dataIndex: '8MONTH'		, width: 100},
			 {dataIndex: '9MONTH'		, width: 100},
			 {dataIndex: '10MONTH'		, width: 100},
			 {dataIndex: '11MONTH'		, width: 100},
			 {dataIndex: '12MONTH'		, width: 100},
			 {dataIndex: 'SEQ'			, width: 6, hidden:true}

		]
    });

    /**
     * Master Grid2 정의(Grid Panel)
     * @type
     */

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
		id: 'sfa130skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
                directMasterStore1.loadStoreRecords();
		}
	});
};


</script>
