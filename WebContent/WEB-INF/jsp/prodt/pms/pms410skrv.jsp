<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms410skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pms410skrv"  />	<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var gsReportGubun = '${gsReportGubun}'	//레포트 구분

function appMain() {

	/**
	 *   Model 정의
	 */
	Unilite.defineModel('pms410skrvModel', {
		fields: [
			{name: 'COMP_CODE'     	, text: '<t:message code="system.label.product.compcode" default="법인코드"/>'					, type: 'string'},
			{name: 'DIV_CODE'     	, text: '<t:message code="system.label.product.division" default="사업장"/>'								, type: 'string'},
			{name: 'INSPEC_DATE'   	, text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'					, type: 'uniDate'},
			{name: 'INSPEC_NUM'    	, text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'						, type: 'string'},
			{name: 'INSPEC_SEQ'    	, text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'					, type: 'string'},
			{name: 'WORK_SHOP_CODE'	, text: '<t:message code="system.label.product.mainworkcenter" default="작업장"/>'	 		, type: 'string'},
			{name: 'WORK_SHOP_NAME' , text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'		, type: 'string'},
			{name:'GOODBAD_TYPE'	,text: '<t:message code="system.label.product.passyn" default="합격여부"/>'					,type:'string' , comboType:'AU' , comboCode:'M414'},
			{name: 'ITEM_CODE'     	, text: '<t:message code="system.label.product.item" default="품목"/>'								, type: 'string'},
			{name: 'ITEM_NAME'     	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'						, type: 'string'},
			{name: 'SPEC'     		, text: '<t:message code="system.label.product.spec" default="규격"/>'										, type: 'string'},
			{name: 'LOT_NO'			,text: '<t:message code="system.label.product.lotno" default="LOT NO"/>'				,type: 'string'},
			{name: 'INSPEC_Q'     	, text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'							, type: 'uniQty'},
			{name: 'GOOD_INSPEC_Q'  , text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'					, type: 'uniQty'},
			{name: 'BAD_INSPEC_Q'  	, text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'					, type: 'uniQty'},
			{name: 'BAD_LATE'     	, text: '<t:message code="system.label.product.defectrate" default="불량률"/>'							, type: 'uniER'},
			{name: 'INSPEC_PRSN'		,text: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>'		,type:'string' , comboType:'AU' , comboCode:'Q024', allowBlank: false},
			{name:'RECEIPT_Q'		,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'				,type:'uniQty'},
			{name:'INSTOCK_Q'		,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'					,type:'uniQty'}

		]
	});

	/**
	 * Store 정의(Service 정의)
	 */
	var masterStore = Unilite.createStore('pms410skrvMasterStore1', {
		model: 'pms410skrvModel',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'pms410skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			panelResult.setValue('INSPEC_NUMS','');
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
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
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
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
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

			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType: 'WU',
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
					 beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                            prStore.filterBy(function(record){
                                return false;
                            });
                        }
                    }
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '검사품목',
				id			: 'rdoSelect1',
				items		: [{
					boxLabel	: '반제품',
					name		: 'INSPEC_ITEM',
					width		: 80,
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '제품',
					name		: 'INSPEC_ITEM',
					width		: 70,
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('INSPEC_ITEM').setValue(newValue.INSPEC_ITEM);
						masterGrid.reset();
						masterStore.commitChanges();
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout: {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
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
			fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
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

		}, {
              text: '검사현황출력',
              xtype: 'button',
              margin: '0 0 0 10',
              handler: function(){
              	if(!panelResult.getInvalidMessage()) return;   //필수체크

              	var selectedRecords = masterGrid.getSelectedRecords();
                if(Ext.isEmpty(selectedRecords)){
                    alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                    return;
                }
                var inspecNumRecords = new Array();
                var inspecSeqRecords = new Array();
                Ext.each(selectedRecords, function(record, idx) {
                    inspecNumRecords.push(record.get('INSPEC_NUM'));
                    inspecSeqRecords.push(record.get('INSPEC_SEQ'));
                });

                var param = panelResult.getValues();
                param["dataCount"] = selectedRecords.length;
                param["INSPEC_NUM"] = inspecNumRecords;
                param["INSPEC_SEQ"] = inspecSeqRecords;
                param["sTxtValue2_fileTitle"]='완제품검사현황';
                param["RPT_ID"]='pms400rkrv';
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/prodt/pms400crkrv.do',
                    prgID: 'pms400rkrv',
                    extParam: param
                });
                    win.center();
                    win.show();
              }
         }, {
              text:'<div style="color: red"><t:message code="system.label.product.inspecgradereportprint" default="검사성적서출력"/></div>',
              xtype: 'button',
              margin: '0 0 0 15',
              handler: function(){
              	if(!panelResult.getInvalidMessage()) return;   //필수체크

                var selectedRecords = masterGrid.getSelectedRecords();
                if(Ext.isEmpty(selectedRecords)){
                    alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                    return;
                }
                var inspecNumRecords = new Array();
                var inspecSeqRecords = new Array();
                Ext.each(selectedRecords, function(record, idx) {
                    inspecNumRecords.push(record.get('INSPEC_NUM'));
                    inspecSeqRecords.push(record.get('INSPEC_SEQ'));
                });

                var param = panelResult.getValues();

                param["dataCount"] = selectedRecords.length;
                param["INSPEC_NUM"] = inspecNumRecords;
                param["INSPEC_SEQ"] = inspecSeqRecords;
                param["sTxtValue2_fileTitle"]='검사결과서';

                param["RPT_ID"]='pms410rkrv';
                param["PGM_ID"]='pms410skrv';
                param["MAIN_CODE"]='P010';
                var win = '';
                if(gsReportGubun == 'CLIP'){
   				 	win = Ext.create('widget.ClipReport', {
   		                url: CPATH+'/prodt/pms410clrkrv.do',
   		                prgID: 'pms410skrv',
   		                extParam: param
   		            });
   					win.center();
   					win.show();
	   			}else{
	   			  win = Ext.create('widget.CrystalReport', {
	                    url: CPATH+'/prodt/pms410crkrv_.do',
	                    prgID: 'pms410skrv',
	                    extParam: param
	                });
	                    win.center();
	                    win.show();
	   			}

              }
         }, {
             text:'<div style="color: red">라벨출력</div>',
             xtype: 'button',
             margin: '0 0 0 20',
             handler: function(){

             	UniAppManager.app.onPrintButtonDown();
             }

        },{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU',
			store: Ext.data.StoreManager.lookup('wsList'),
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
                     beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                            prStore.filterBy(function(record){
                                return false;
                            });
                        }
                    }
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '검사품목',
			id			: 'rdoSelect2',
			items		: [{
				boxLabel	: '반제품',
				name		: 'INSPEC_ITEM',
				width		: 80,
				inputValue	: '1',
				checked		: true
			},{
				boxLabel	: '제품',
				name		: 'INSPEC_ITEM',
				width		: 70,
				inputValue	: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('INSPEC_ITEM').setValue(newValue.INSPEC_ITEM);
					masterGrid.reset();
					masterStore.commitChanges();
				}
			}
		},{
			fieldLabel: 'INSPEC_NUMS',
			xtype: 'uniTextfield',
			name: 'INSPEC_NUMS',
			hidden: true
		}]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     */
	var masterGrid = Unilite.createGrid('pms410skrvGrid', {
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
        			if(Ext.isEmpty(panelResult.getValue('INSPEC_NUMS'))) {
						panelResult.setValue('INSPEC_NUMS', selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ'));
					} else {
						var inspecNums = panelResult.getValue('INSPEC_NUMS');
						inspecNums = inspecNums + ',' + selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');
						panelResult.setValue('INSPEC_NUMS', inspecNums);
					}

        		},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var inspecNums	 = panelResult.getValue('INSPEC_NUMS');
					var deselectedNum0  = selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ') + ',';
					var deselectedNum1  = ',' + selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');
					var deselectedNum2  = selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');

					inspecNums = inspecNums.split(deselectedNum0).join("");
					inspecNums = inspecNums.split(deselectedNum1).join("");
					inspecNums = inspecNums.split(deselectedNum2).join("");

					panelResult.setValue('INSPEC_NUMS', inspecNums);
				}
        	}
        }),
		store: masterStore,
		columns: [
			{dataIndex: 'INSPEC_DATE'		,width: 100},
			{dataIndex: 'INSPEC_NUM'		,width: 120},
			{dataIndex: 'INSPEC_SEQ'		,width: 100,hidden:true},
			{dataIndex: 'ITEM_CODE'			,width: 100},
			{dataIndex: 'ITEM_NAME'			,width: 200},
			{dataIndex: 'SPEC'     			,width: 80},
			{dataIndex: 'LOT_NO'     		,width: 80},
			{dataIndex: 'WORK_SHOP_CODE'	,width: 80, hidden:true},
			{dataIndex: 'WORK_SHOP_NAME'	,width: 100, align:'center'},
			{dataIndex: 'GOODBAD_TYPE'		, width: 80, align:'center'},
			{dataIndex: 'RECEIPT_Q'			, width: 80},
			{dataIndex: 'INSPEC_Q'			,width: 100},
			{dataIndex: 'GOOD_INSPEC_Q' 	,width: 100},
			{dataIndex: 'BAD_INSPEC_Q'		,width: 100},
			{dataIndex: 'INSTOCK_Q'			, width: 66},
			{dataIndex: 'BAD_LATE'			,width: 100},
			{dataIndex: 'INSPEC_PRSN'		, width: 90}

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
		id: 'pms410skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('INSPEC_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('INSPEC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INSPEC_DATE_TO',UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'], true);
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
	        	if(!panelResult.getInvalidMessage()) return;	//필수체크

				  var selectedRecords = masterGrid.getSelectedRecords();
	            if(Ext.isEmpty(selectedRecords)){
	                alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
	                return;
	            }
	            var inspecNumRecords = new Array();
	            var inspecSeqRecords = new Array();
	            Ext.each(selectedRecords, function(record, idx) {
	                inspecNumRecords.push(record.get('INSPEC_NUM'));
	                inspecSeqRecords.push(record.get('INSPEC_SEQ'));
	            });

	            var param = panelResult.getValues();

	            param["dataCount"] = selectedRecords.length;
	            param["INSPEC_NUM"] = inspecNumRecords;
	            param["INSPEC_SEQ"] = inspecSeqRecords;
	            param["sTxtValue2_fileTitle"]='검사결과서';

	            param["RPT_ID"]='pms410rkrv';
	            param["PGM_ID"]='pms410skrv';
	            param["MAIN_CODE"]='P010';
	            var win = '';
	           		 win = Ext.create('widget.ClipReport', {
		                    url: CPATH+'/prodt/pms410clrkrv_label.do',
		                    prgID: 'pms410skrv',
		                    extParam: param
		                });
		                    win.center();
		                    win.show();

		},
		onDirectPrintButtonDown: function() { // 인쇄 버튼 handler : 미리보기 없이 인쇄
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			  var selectedRecords = masterGrid.getSelectedRecords();
              if(Ext.isEmpty(selectedRecords)){
                  alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                  return;
              }
              var inspecNumRecords = new Array();
              var inspecSeqRecords = new Array();
              Ext.each(selectedRecords, function(record, idx) {
                  inspecNumRecords.push(record.get('INSPEC_NUM'));
                  inspecSeqRecords.push(record.get('INSPEC_SEQ'));
              });

              var param = panelResult.getValues();

              param["dataCount"] = selectedRecords.length;
              param["INSPEC_NUM"] = inspecNumRecords;
              param["INSPEC_SEQ"] = inspecSeqRecords;
              param["sTxtValue2_fileTitle"]='검사결과서';

              param["RPT_ID"]='pms410rkrv';
              param["PGM_ID"]='pms410skrv';
              param["MAIN_CODE"]='P010';
              var win = '';
             		 win = Ext.create('widget.ClipReport', {
	                    url: CPATH+'/prodt/pms410clrkrv_label.do',
	                    prgID: 'pms410skrv',
	                    uniOpt:{
							directPrint:true
						},
	                    extParam: param
	                });
	                    win.center();
	                    win.show();

		}
	});
};
</script>