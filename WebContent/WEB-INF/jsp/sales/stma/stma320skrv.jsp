<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="stma320skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="stma320skrv" /> 			<!-- 사업장 -->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Stma320skrvModel1', {
	    fields: [
	    	{name: 'GUBUN'			,text: '<t:message code="system.label.sales.processtype" default="진행구분"/>',type: 'string'},
	    	{name: 'GUBUN_NAME'	    ,text: '<t:message code="system.label.sales.processtype" default="진행구분"/>',type: 'string'},
		    {name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'	,type: 'string'},
		    {name: 'AMOUNT'			,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>'	,type: 'uniPrice'},
		    {name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'	,type: 'string'},
		    {name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'	,type: 'string'},
		    {name: 'SOPT'			,text: 'SOPT'	,type: 'string'},
		    {name: 'SORT_STR'			,text: '<t:message code="system.label.sales.processtype" default="진행구분"/>'	,type: 'string'}
		]
	});

	Unilite.defineModel('Stma320skrvModel2', {
	    fields: [
	    	{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'	,type: 'string'},
		    {name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
		    {name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'		,type: 'string'},
            {name: 'INOUT_Q'        ,text: '<t:message code="system.label.sales.qty" default="수량"/>'       ,type: 'uniQty'},
		    {name: 'ORDER_UNIT'		,text: '<t:message code="system.label.sales.unit" default="단위"/>'		,type: 'string'},
		    {name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currency" default="화폐"/>'		,type: 'string'},
		    {name: 'ORDER_O'		,text: '<t:message code="system.label.sales.amount" default="금액"/>'		,type: 'uniPrice'},
		    {name: 'EXCHG_RATE_O'	,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'		,type: 'uniER'},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.sales.basisno" default="근거번호"/>'	,type: 'string'},
			{name: 'SER_NO'		    ,text: '<t:message code="system.label.sales.seq" default="순번"/>'		,type: 'string'}
		]
	});


	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('stma320skrvMasterStore1',{
		model: 'Stma320skrvModel1',
		uniOpt: {
            isMaster: true,		// 상위 버튼 연결
            editable: false,		// 수정 모드 사용
            deletable: false,		// 삭제 가능 여부
	        useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {
            	read: 'stma320skrvService.selectList1'
            }
        }
		,loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
        listeners:{
            load: function(store, records, successful, eOpts) {
                panelSearch.setValue('COUNT', masterGrid1.getStore().getCount());
            }
        },
        groupField:'SORT_STR'   //'GUBUN_NAME'
	});

	var directMasterStore2 = Unilite.createStore('stma320skrvMasterStore2',{
		model: 'Stma320skrvModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable: false,			// 삭제 가능 여부
	        useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {
				read: 'stma320skrvService.selectList2'
            }
        }
		,loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			var record = Ext.getCmp('stma320skrvGrid1').getSelectedRecord();
			if(record){
				param["GUBUN"] = record.get("GUBUN");
				param["CUSTOM_CODE"] = record.get("CUSTOM_CODE");
				param["DIV_CODE"] = record.get("DIV_CODE");
			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});

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
			layout: {type: 'uniTable', columns: 1},
			items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.basisdate" default="기준일"/>',
				xtype: 'uniDatefield',
				name: 'ORDER_DATE',
				value: new Date(),
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_DATE', newValue);
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
                fieldLabel: 'COUNT',
                xtype: 'uniNumberfield',
                name: 'COUNT',
                hidden: true
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
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.basisdate" default="기준일"/>',
			xtype: 'uniDatefield',
			name: 'ORDER_DATE',
			value: new Date(),
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_DATE', newValue);
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
		})]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid1 = Unilite.createGrid('stma320skrvGrid1', {
    	region:'center',
        layout: 'fit',
  		store: directMasterStore1,
  		uniOpt:{
  		    expandLastColumn   : false,
            useRowNumberer     : false,
            useMultipleSorting : false,
            onLoadSelectFirst  : true,     //체크박스모델은 false로 변경
            excel: {
				useExcel: false,			//엑셀 다운로드 사용 여부
				exportGroup : false, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:false
			}
        },
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: true
	    	}, {
	    	id: 'masterGridTotal',
	    	ftype: 'uniSummary',
	    	showSummaryRow: true
    	}],
        selModel : 'rowmodel',
        columns: [
            {dataIndex: 'GUBUN'	        , width: 90, hidden:true},
        	{dataIndex: 'GUBUN_NAME'	, width: 90,
        	    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
                }
        	},
        	{dataIndex: 'DIV_CODE'		, width: 80, hidden: false},
			{dataIndex: 'CUSTOM_NAME'	, width: 133},
			{dataIndex: 'AMOUNT'		, width: 86, summaryType:'sum'},
			{dataIndex: 'CUSTOM_CODE'	, width: 80, hidden: true},

			{dataIndex: 'SOPT'			, width: 80, hidden: true} ,
			{dataIndex: 'SORT_STR'			, width: 80, hidden: true}
		],
        listeners : {
            selectionchange : function(grid, selected, eOpts) {
                this.setDetailGrd(selected, eOpts) ;
            }
        },
        setDetailGrd : function (selected, eOpts) {
            if(selected.length > 0) {
                var param= Ext.getCmp('searchForm').getValues();
                param.GUBUN = selected[selected.length-1].get('GUBUN'),
                param.CUSTOM_CODE = selected[selected.length-1].get('CUSTOM_CODE')
                param.DIV_CODE = selected[selected.length-1].get('DIV_CODE') ;
                var dgrid = Ext.getCmp('stma320skrvGrid2');
                dgrid.getStore().loadStoreRecords(param);
            }
        }
    });

    var masterGrid2 = Unilite.createGrid('stma320skrvGrid2', {
    	split: {size: 1},
    	region:'east',
    	layout: 'fit',
    	uniOpt:{
    		useLiveSearch   : true,
    		excel: {
				useExcel: true,			//엑셀 다운로드 사용 여부
				exportGroup : true, 		//group 상태로 export 여부
				onlyData:false,
				summaryExport:true
			}
    	},
    	flex:3,
    	store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
	    	}, {
	    	id: 'masterGridTotal',
	    	ftype: 'uniSummary',
	    	showSummaryRow: false
	    }],
        columns: [
            {dataIndex: 'ITEM_CODE'		,width: 120},
	    	{dataIndex: 'ITEM_NAME'		,width: 180},
	    	{dataIndex: 'SPEC'			,width: 150},
            {dataIndex: 'INOUT_Q'       ,width: 120},
	    	{dataIndex: 'ORDER_UNIT'	,width: 60, align:"center"},
	    	{dataIndex: 'MONEY_UNIT'	,width: 60, align:"center"},
	    	{dataIndex: 'ORDER_O'		,width: 100},
	        {dataIndex: 'EXCHG_RATE_O'	,width: 80},
			{dataIndex: 'ORDER_NUM'		,width: 120},
			{dataIndex: 'SER_NO'		,width: 60}
        ]
    });

    /**
     * Master Grid2 정의(Grid Panel)
     * @type
     */

    Unilite.Main( {
    	borderItems : [ panelSearch,{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid1, masterGrid2
			]
        }],
        id: 'sma320skrvApp',
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',true);
        },
        onQueryButtonDown : function() {
            if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            masterGrid2.reset();
            directMasterStore2.clearData();
            UniAppManager.setToolbarButtons('save',false);
            directMasterStore1.loadStoreRecords();
        },
        onResetButtonDown : function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('reset',true);
			masterGrid1.reset();
			masterGrid2.reset();
			directMasterStore1.clearData();
			directMasterStore2.clearData();
			UniAppManager.setToolbarButtons('save',false);
		}
    });
};
</script>