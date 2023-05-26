<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sfa100skrv_kd"  >
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="BOR120"  pgmId="s_sfa100skrv_kd"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위 -->
</t:appConfig>
<script type="text/javascript" >



function appMain() {

	var BsaCodeInfo = { // 컨트롤러에서 값을 받아옴
        gsMoneyUnit:        '${gsMoneyUnit}'
    };
//    var output ='';     // 입고내역 셋팅 값 확인 alert
//    for(var key in BsaCodeInfo){
//        output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//    }
//    Unilite.messageBox(output);
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('S_sfa100skrv_kdModel', {
		fields:  [{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처"/>'		, type: 'string'},
			      {name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			, type: 'string'},
			      {name: 'BUSI_PRSN'		, text: '<t:message code="system.label.sales.charger" default="담당자"/>'			, type: 'string',comboType:'AU', comboCode:'S010'},
			      {name: 'MONEY_UNIT'		, text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			, type: 'string'},
			      {name: 'UN_COLLECT_AMT'	, text: '<t:message code="system.label.sales.lastdayar" default="전일미수"/>'			, type: 'uniPrice'},
				  {name: 'SALE_AVG'			, text: '<t:message code="system.label.sales.salescomposite" default="판매구성비율(%)"/>'	, type: 'uniER'},
				  {name: 'MONTH_PLAN'		, text: '<t:message code="system.label.sales.salesplan" default="판매계획"/>'			, type: 'uniPrice'},
				  {name: 'SALE_SUB_TOT'		, text: '<t:message code="system.label.sales.monthresults" default="당월실적"/>'			, type: 'uniPrice'},
				  {name: 'TARGET_RATE'		, text: '<t:message code="system.label.sales.accompratepercent" default="달성율(%)"/>'		    , type: 'uniER'},
				  {name: 'SALE_BEFORE_TOT'	, text: '<t:message code="system.label.sales.lastyearachievement" default="전년실적"/>'			, type: 'uniPrice'},
				  {name: 'UP_RATE'			, text: '<t:message code="system.label.sales.growthrate" default="신장율(%)"/>'		    , type: 'uniER'},
				  {name: 'DAY_Q'			, text: '<t:message code="system.label.sales.daysalesqty" default="당일매출량"/>'		, type: 'uniQty'},
				  {name: 'DAY_AMT'			, text: '<t:message code="system.label.sales.daysalesamount" default="당일매출액"/>'		, type: 'uniPrice'},
				  {name: 'DAY_TAX'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'		 	, type: 'uniPrice'},
				  {name: 'DAY_COLLECT'		, text: '<t:message code="system.label.sales.daycollected" default="당일수금"/>'		 	, type: 'uniPrice'},
				  {name: 'MONTH_COLLECT'	, text: '<t:message code="system.label.sales.monthcollected" default="당월수금"/>'		 	, type: 'uniPrice'},
				  {name: 'BLAN_AMT'			, text: '<t:message code="system.label.sales.presentar" default="현재미수"/>'		 	, type: 'uniPrice'}
	     ]
	}); //End of Unilite.defineModel('S_sfa100skrv_kdModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_sfa100skrv_kdMasterStore1',{
		model: 'S_sfa100skrv_kdModel',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
            editable  : false,			// 수정 모드 사용
            deletable : false,			// 삭제 가능 여부
	        useNavi   : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {
            	read: 's_sfa100skrv_kdService.selectList1'
			}
        },
        loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();
            param.GS_MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;
            if(panelSearch.getValue('MONEY_UNIT') == '1') {
            	param.MONEY_RATE = '1';
            } else if(panelSearch.getValue('MONEY_UNIT') == '2') {
            	param.MONEY_RATE = '1000';
            } else if(panelSearch.getValue('MONEY_UNIT') == '3') {
                param.MONEY_RATE = '1000000';
            } else {
                param.MONEY_RATE = '100000000';
            }
			console.log( param );
			this.load({
				params: param
			});
		}
	});		//End of var directMasterStore1 = Unilite.createStore('s_sfa100skrv_kdMasterStore1',{

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
			layout: {type: 'vbox', align: 'stretch'},
		    items: [{
		        	xtype: 'container',
		            layout: {type: 'uniTable', columns: 1},
		            items: [{
	            		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
	            		name: 'DIV_CODE',
	            		xtype: 'uniCombobox',
	            		comboType: 'BOR120',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
	            	},
	        			Unilite.popup('AGENT_CUST',{
	    				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',

						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
									panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						}
					}),{
						fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
						name: 'AGENT_TYPE',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'B055',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('AGENT_TYPE', newValue);
							}
						}
					}, {
						fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
					    xtype: 'uniDatefield',
					    name: 'SALE_DATE',
					    value: new Date(),
					    allowBlank: false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('SALE_DATE', newValue);
							}
						}
					}, {
						xtype: 'radiogroup',
						fieldLabel: '<t:message code="system.label.sales.salesplanapply" default="판매계획적용"/>',
						items: [{
							boxLabel: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>',
							width: 70,
							name: 'RDO',
							inputValue: 'A',
							checked: true
						}, {
							boxLabel: '<t:message code="system.label.sales.yearplan" default="년초계획"/>',
							width: 70,
							name: 'RDO',
							inputValue: 'F'
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
								panelResult.getField('RDO').setValue(newValue.RDO);
							}
						}
					}, {
						fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
						name: 'AREA_TYPE',
						xtype: 'uniCombobox',
						comboType: 'AU',
						comboCode: 'B056',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('AREA_TYPE', newValue);
							}
						}
					}]
		       }]
		}, {
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.sales.amountunit" default="금액단위"/>'	,
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B042',
				value: '1'
			}, {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.sales.tradeinclusionyn" default="무역포함여부"/>',
				id: 'tradeaddyn',
				items: [
					{boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>', width: 70,  name: 'traden', inputValue: 'S', checked: true},
				    {boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>', width: 70, name: 'traden', inputValue: 'T'}
				]
			}, {
				fieldLabel: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>',
                name: 'AMT_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				displayField: 'value',
				fieldStyle: 'text-align: center;'
			}, {
				fieldLabel: '<t:message code="system.label.sales.charger" default="담당자"/>',
				name: 'BUSI_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S010'
			}, {
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.sales.amountzero" default="금액이 0인 건"/>',
				id: 'moneyzero',
				items: [
					{boxLabel: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>', width: 70,  name: 'moneyzeron', inputValue: '1'},
					{boxLabel: '<t:message code="system.label.sales.inclusion" default="포함"/>', width: 70 , name: 'moneyzeron' , inputValue: '2', checked: true  }
				]
			}, {
				xtype: 'container',
				items: [{
					xtype: 'container',
					contentEl: 's_sfa100skrv_kdMessage'
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
    		comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
    	},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',

			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
			name: 'AGENT_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B055',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
		    xtype: 'uniDatefield',
		    name: 'SALE_DATE',
		    value: new Date(),
		    allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_DATE', newValue);
				}
			}
		}, {
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.sales.salesplanapply" default="판매계획적용"/>',
			items: [{
				boxLabel: '<t:message code="system.label.sales.amendmentplan" default="수정계획"/>',
				width: 70,
				name: 'RDO',
				inputValue: 'A',
				checked: true
			}, {
				boxLabel: '<t:message code="system.label.sales.yearplan" default="년초계획"/>',
				width: 70,
				name: 'RDO',
				inputValue: 'F'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('RDO').setValue(newValue.RDO);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
			name: 'AREA_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B056',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AREA_TYPE', newValue);
				}
			}
		}]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('s_sfa100skrv_kdGrid1', {
    	// for tab
    	region: 'center',
		layout: 'fit',
        uniOpt: {
        	useLiveSearch      : true,
        	useGroupSummary    : true,
        	useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
			filter: {
				useFilter  : false,
				autoCreate : false
			},
			excel: {
				useExcel      : true,		//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
    	store: directMasterStore1,
    	features: [
    		{
    			id: 'masterGridSubTotal',
    			ftype: 'uniGroupingsummary',
    			showSummaryRow: true
    		},{
    			id: 'masterGridTotal',
    			ftype: 'uniSummary',
    			showSummaryRow: true
    		}
    	],
        columns: [
        	{dataIndex: 'CUSTOM_CODE', width: 80, hidden: true},
        	{dataIndex: 'CUSTOM_NAME', width: 150},
        	{dataIndex: 'BUSI_PRSN', width: 100},
        	{dataIndex: 'SALE_AVG', width: 120},
        	{
        		text: '<t:message code="system.label.sales.monthselling" default="당월판매"/>',
         		columns: [
             		{dataIndex: 'MONTH_PLAN'   		, width: 120, summaryType:'sum'},
             		{dataIndex: 'SALE_SUB_TOT'   	, width: 120, summaryType:'sum'},
             		{dataIndex: 'TARGET_RATE'  		, width: 80},
             		{dataIndex: 'SALE_BEFORE_TOT'	, width: 120, summaryType:'sum'},
             		{dataIndex: 'UP_RATE'  			, width: 80}
                ]
           	},{
           		text: '<t:message code="system.label.sales.dayselling" default="당일판매"/>',
         		columns: [
             		{dataIndex: 'DAY_Q'   	, width: 120, summaryType:'sum'},
             		{dataIndex: 'DAY_AMT'	, width: 120, summaryType:'sum'}
                ]
           	},{
           		text: '<t:message code="system.label.sales.collectiondetails" default="수금내역"/>',
         		columns: [
             		{dataIndex: 'DAY_COLLECT'    , width: 120, summaryType:'sum'},
             		{dataIndex: 'MONTH_COLLECT'	, width: 120, summaryType:'sum'}
                ]
           	},
           	{dataIndex: 'BLAN_AMT'  		, width: 120, summaryType:'sum'},
        	{dataIndex: 'UN_COLLECT_AMT'	, width: 80, hidden: true},
        	{dataIndex: 'DAY_TAX'  		, width: 120, hidden: true},
        	{dataIndex: 'MONEY_UNIT'  	, width: 66, hidden: true}
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
		id: 's_sfa100skrv_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('SALE_DATE',UniDate.get('today'));
			panelResult.setValue('SALE_DATE',UniDate.get('today'));
			panelSearch.setValue('MONEY_UNIT','1');
			panelResult.setValue('MONEY_UNIT','1');
			panelResult.getField('RDO').setValue("A");
			panelSearch.getField('RDO').setValue("A");
			panelSearch.getField('traden').setValue("S");
			panelSearch.getField('moneyzeron').setValue("2");
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown: function() {
            if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            directMasterStore1.loadStoreRecords();
		},
		onResetButtonDown : function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding()
		}
	});

};


</script>
</script>
<div id='s_sfa100skrv_kdMessage' class='x-hide-display' align='right' style='margin-top: 15px; margin-right: 10px '>
<div style='font-weight: bold;'>※ <t:message code="system.label.sales.vatseparate" default="부가세별도"/></div>
</div>