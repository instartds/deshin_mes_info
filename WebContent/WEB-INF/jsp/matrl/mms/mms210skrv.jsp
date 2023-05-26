<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms210skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="mms210skrv"  />	<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var gsReportGubun = '${gsReportGubun}'	//레포트 구분
function appMain() {

	 var gubunStore = Unilite.createStore('gubunComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'자재발주'  , 'value':'1'},
            {'text':'외주발주'  , 'value':'2'}
        ]
    });

	/**
	 *   Model 정의
	 */
	Unilite.defineModel('mms210skrvModel', {
		fields: [
			{name: 'COMP_CODE'     	, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'     	, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
			{name: 'INSPEC_DATE'   	, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'		, type: 'uniDate'},
			{name: 'INSPEC_NUM'    	, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'		, type: 'string'},
			{name: 'INSPEC_SEQ'    	, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'    , text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'     	, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'     	, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'     		, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
			{name: 'INSPEC_Q'     	, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'		, type: 'uniQty'},
			{name: 'GOOD_INSPEC_Q'  , text: '<t:message code="system.label.purchase.gooditemqty" default="양품량"/>'		, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'  	, text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'		, type: 'uniQty'},
			{name: 'BAD_LATE'     	, text: '<t:message code="system.label.purchase.defectrate" default="불량률"/>'		, type: 'uniER'},
			{name: 'BAD_AMT'     	, text: '불량금액'		, type: 'uniPrice'},
			{name: 'ITEM_ACCOUNT'     	, text:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'		, type: 'string',  comboType:'AU', comboCode:'B020' },
			{name: 'LOT_NO'     	, text:'LOT_NO'		, type: 'string' },
			{name: 'MAKE_LOT_NO'   	, text: '<t:message code="system.label.purchase.makerlot" default="제조사LOT"/>'		, type: 'string'},
			{name: 'MAKE_DATE'   		, text: '<t:message code="system.label.purchase.makedate" default="제조일자"/>'		, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE' 	, text: '<t:message code="system.label.purchase.expirationdate" default="유통기한"/>'		, type: 'uniDate'},
		]
	});

	/**
	 * Store 정의(Service 정의)
	 */
	var masterStore = Unilite.createStore('mms210skrvMasterStore1', {
		model: 'mms210skrvModel',
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
				read: 'mms210skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			panelResult.setValue('INSPEC_NUMS','');
			panelResult.setValue('ITEM_CODES','');
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	/**
	 * 검색조건 (Search Panel)
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSPEC_DATE_FR',
				endFieldName: 'INSPEC_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('INSPEC_DATE_FR',newValue);

                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INSPEC_DATE_TO',newValue);
			    	}
			    }

			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
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
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.podivision" default="발주구분"/>',
				name: 'PODIV',
				xtype: 'uniCombobox',
				store:gubunStore,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PODIV', newValue);
					}
				}
			},{name: 'ITEM_ACCOUNT' ,
				fieldLabel:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' ,
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout: {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INSPEC_DATE_FR',
			endFieldName: 'INSPEC_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('INSPEC_DATE_FR',newValue);

            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INSPEC_DATE_TO',newValue);
		    	}
		    }

		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME',
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
		}),
		,{
			xtype: 'container',
			layout: {type: 'uniTable', columns:2},
			items: [{fieldLabel: '<t:message code="system.label.purchase.podivision" default="발주구분"/> ',
						name: 'PODIV',
						xtype: 'uniCombobox',
						store:gubunStore,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('PODIV', newValue);
							}
							}
						},
						{name: 'ITEM_ACCOUNT' ,
						 fieldLabel:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' ,
						 xtype:'uniCombobox',
						 comboType:'AU',
						 comboCode:'B020',
						 listeners: {
						  	 change: function(field, newValue, oldValue, eOpts) {
								 panelSearch.setValue('ITEM_ACCOUNT', newValue);
							 }
						 }
					}]
		 }]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     */
	var masterGrid = Unilite.createGrid('mms210skrvGrid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState: false,
				useStateList: false
			}
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],selModel : Ext.create("Ext.selection.CheckboxModel", {
        	singleSelect : true ,
        	checkOnly : false,showHeaderCheckbox :true,
        	listeners: {
        		select: function(grid, selectRecord, index, rowIndex, eOpts ){
        			/* if(Ext.isEmpty(panelResult.getValue('INSPEC_NUMS'))) {
						panelResult.setValue('INSPEC_NUMS', selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ'));
					} else {
						var inspecNums = panelResult.getValue('INSPEC_NUMS');
						inspecNums = inspecNums + ',' + selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');
						panelResult.setValue('INSPEC_NUMS', inspecNums);
					}
        			if(Ext.isEmpty(panelResult.getValue('ITEM_CODES'))) {
						panelResult.setValue('ITEM_CODES', selectRecord.get('ITEM_CODE'));
					} else {
						var itemCodes = panelResult.getValue('ITEM_CODES');
						itemCodes = itemCodes + ',' + selectRecord.get('ITEM_CODE') ;
						panelResult.setValue('ITEM_CODES', itemCodes);
					} */

        		},
				deselect:  function(grid, selectRecord, index, eOpts ){
					/* var inspecNums	 = panelResult.getValue('INSPEC_NUMS');
					var deselectedNum0  = selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ') + ',';
					var deselectedNum1  = ',' + selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');
					var deselectedNum2  = selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');

					inspecNums = inspecNums.split(deselectedNum0).join("");
					inspecNums = inspecNums.split(deselectedNum1).join("");
					inspecNums = inspecNums.split(deselectedNum2).join("");

					var itemCodes	 = panelResult.getValue('ITEM_CODES');
					var deselectedNum00  = selectRecord.get('ITEM_CODE') + ',';
					var deselectedNum11  = ',' + selectRecord.get('ITEM_CODE') ;
					var deselectedNum22  = selectRecord.get('ITEM_CODE') ;

					itemCodes = itemCodes.split(deselectedNum00).join("");
					itemCodes = itemCodes.split(deselectedNum11).join("");
					itemCodes = itemCodes.split(deselectedNum22).join("");

					panelResult.setValue('INSPEC_NUMS', inspecNums);
					panelResult.setValue('ITEM_CODES', itemCodes); */
				}
        	}
        }),
		store: masterStore,
		columns: [
			{dataIndex: 'INSPEC_DATE'		,width: 100},
			{dataIndex: 'INSPEC_NUM'			,width: 120},
			{dataIndex: 'INSPEC_SEQ'			,width: 100,hidden:true},
			{dataIndex: 'CUSTOM_NAME'		,width: 150},
			{dataIndex: 'ITEM_CODE'			,width: 100},
			{dataIndex: 'ITEM_NAME'			,width: 150},
			{dataIndex: 'SPEC'     				,width: 150},
			{dataIndex: 'ITEM_ACCOUNT'    	,width: 80,   align:'center'},
			{dataIndex: 'LOT_NO'     			,width: 100, align:'center'},
			{dataIndex: 'INSPEC_Q'				,width: 100},
			{dataIndex: 'GOOD_INSPEC_Q' 	,width: 100},
			{dataIndex: 'BAD_INSPEC_Q'		,width: 100},
			{dataIndex: 'BAD_LATE'				,width: 100},
			{dataIndex: 'BAD_AMT'				,width: 100},
			{dataIndex: 'MAKE_LOT_NO'		,width: 100,   align:'center'},
			{dataIndex: 'MAKE_DATE'			,width: 100,   align:'center'},
			{dataIndex: 'MAKE_EXP_DATE'	,width: 100,   align:'center'}
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
		id: 'mms210skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('INSPEC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INSPEC_DATE_TO',UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset','print'], true);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			masterStore.loadStoreRecords();
		},
        onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterStore.clearData();
        	UniAppManager.app.fnInitBinding();
        },
        onPrintButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;   //필수체크

            var selectedRecords = masterGrid.getSelectedRecords();
            if(Ext.isEmpty(selectedRecords)){
            	alert('출력할 데이터를 선택하여 주십시오.');
            	return;
            }

			var inspecNums = '';
			var inspecSeqs = '';
			var itemCodes = '';
			var param = panelResult.getValues();
			Ext.each(selectedRecords, function(selectedRecord, index){
				if(index ==0) {
					inspecNums		= inspecNums + selectedRecord.get('INSPEC_NUM');
					inspecSeqs		= inspecSeqs + selectedRecord.get('INSPEC_SEQ');
					itemCodes	    = itemCodes + selectedRecord.get('ITEM_CODE');
				}else{
					inspecNums		= inspecNums + ',' + selectedRecord.get('INSPEC_NUM');
					inspecSeqs		= inspecSeqs + ',' + selectedRecord.get('INSPEC_SEQ');
					itemCodes      = itemCodes + ',' + selectedRecord.get('ITEM_CODE');
				}
			});

			var param = panelResult.getValues();

			param["dataCount"] 		= selectedRecords.length;
			param["INSPEC_NUMS"] = inspecNums;
			param["INSPEC_SEQS"] = inspecSeqs;
			param["ITEM_CODES"]  = itemCodes;
			param["MAIN_CODE"] = 'M030';
			param["sTxtValue2_fileTitle"]='검사결과서';

			param["RPT_ID"]='mms210rkrv';
			param["PGM_ID"]='mms210skrv';
			var win = '';
			if(gsReportGubun == 'CLIP'){
				 win = Ext.create('widget.ClipReport', {
		                url: CPATH+'/matrl/mms210clrkrv.do',
		                prgID: 'mms210skrv',
		                extParam: param
		            });
					win.center();
					win.show();
			}else{
				 win = Ext.create('widget.CrystalReport', {
	                url: CPATH+'/matrl/mms210crkrv.do',
	                prgID: 'mms210skrv',
	                extParam: param
	           		 });
					win.center();
					win.show();
			}
		}
	});
};
</script>