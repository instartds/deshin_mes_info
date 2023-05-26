<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="esa101ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S802" /> <!-- 유무상구분-->
	<t:ExtComboStore comboType="AU" comboCode="S805" /> <!-- 처리방법-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;};  
#ext-element-3 {align:center}
</style>

<script type="text/javascript" >
var SearchInfoWindow;
var BsaCodeInfo = {
		gsReportGubun: '${gsReportGubun}'//클립리포트 추가로 인한 리포트 출력 방식 설정(CR:크리스탈 또는 jasper CLIP:클립리포트)
}
function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
	    api: {
	        read: 'esa101ukrvService.selectList',
	        create: 'esa101ukrvService.insertDetail',
	        update: 'esa101ukrvService.updateDetail',
	        destroy: 'esa101ukrvService.deleteDetail',
	        syncAll: 'esa101ukrvService.saveAll'
	    }
	});
	
	/**
	 * detailGridModel
	 */
	Unilite.defineModel('esa101ukrvModel', {
		fields: [
			{name: 'AS_SEQ'					, text: '순번'				, type: 'int'	, allowBlank: false, editable: false},
			{name: 'COMP_CODE'      	, text: '법인코드'				, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'				, type: 'string'},
			{name: 'ITEM_CODE'      	, text: '품목코드' 			, type: 'string', allowBlank: false},
	    	{name: 'ITEM_NAME'      	, text: '품목명' 				, type: 'string'},
	    	{name: 'SPEC'      				, text: '규격' 				, type: 'string'},
	    	{name: 'STOCK_UNIT'     	, text: '단위' 				, type: 'string'},
	    	{name: 'AS_Q'      				, text: '수량' 				, type: 'uniQty'},
	    	{name: 'INOUT_DATE'      	, text: '접수일자' 			, type: 'uniDate'},
	    	{name: 'REMARK'      			, text: '메모' 				, type: 'string'},
	    	{name: 'AS_NUM'      		, text: '접수번호' 			, type: 'string'},
	    	{name: 'LOT_NO'      			, text: 'LOT NO' 			, type: 'string'},
	    	{name: 'SALE_DATE'      	, text: '판매일' 			, type: 'string'}
		]
	});

	/**
	 * detailStore
	 */
	var detailStore = Unilite.createStore('esa101ukrvDetailStore', {
	    model: 'esa101ukrvModel',
	    uniOpt: {
	        isMaster: true, // 상위 버튼 연결
	        editable: true, // 수정 모드 사용
	        deletable: true, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    proxy: directProxy,
	    loadStoreRecords: function() {
	        var param = panelSearch.getValues();
	        console.log(param);
	        this.load({
	            params: param
	        });
	    },
	    saveStore: function() {
	        var toCreate = this.getNewRecords();
	        var toUpdate = this.getUpdatedRecords();
	        var toDelete = this.getRemovedRecords();
	        var list = [].concat(toUpdate, toCreate, toDelete);
	        var listLength = list.length;
	        var inValidRecs = this.getInvalidRecords();
			var paramMaster = masterForm.getValues();	//syncAll 수정
			paramMaster.DIV_CODE = panelSearch.getValue('DIV_CODE');
	        if (inValidRecs.length == 0) {
	            config = {
					params: [paramMaster],
	                success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("AS_NUM", master.AS_NUM);
	                    masterForm.getForm().wasDirty = false;
	                    masterForm.resetDirtyStatus();
	                    console.log("set was dirty to false");
	                    UniAppManager.setToolbarButtons('save', false);
            			detailStore.loadStoreRecords();
	                }
	            };
	            this.syncAllDirect(config);
	        } else {
	            detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
	        }
	    }
	});
	
	var panelSearch = Unilite.createSearchForm('searchForm', {
    	region:'north',
	     layout : {type : 'uniTable', columns : 3},
	    padding: '1 1 1 1',
	    border: true,
	    items: [{
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank:false
        }, Unilite.popup('AS_NUM', {
            fieldLabel: '접수번호',
            valueFieldName: 'AS_NUM_SEACH',
            textFieldName: 'AS_NUM_SEACH',
            allowBlank:false
        }), {
            text: '보고서출력',
            itemId: 'printButton',
            id: 'printButton',
            xtype: 'button',
            margin: '0 0 0 100',
            disabled: true,
            handler: function() {
                if(!panelSearch.getInvalidMessage()){
					return false;		
				}
                if(masterForm.isDirty()){
					alert('먼저 저장을 하십시오');
                	return false;		
				}
                var param = masterForm.getValues();
                param.MAIN_CODE = 'S036';
                param.PGM_ID = 'esa101ukrv';
                param.DIV_CODE = panelSearch.getValue('DIV_CODE');
                param.ACCEPT_REMARK = "";
                var reportGubun = BsaCodeInfo.gsReportGubun //초기화 시 가져온 구분값, 값이 없거나 CR이면 크리스탈리포트나 jasper리포트 출력
    			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
                	window.open(CPATH + '/equit/esa100rkrvExcelDown.do?AS_NUM_SEACH=' + panelSearch.getValue('AS_NUM_SEACH') + '&DIV_CODE=' + panelSearch.getValue('DIV_CODE'), "_self");
    			}else{
    				var win = Ext.create('widget.ClipReport', {
    	                url: CPATH+'/equip/esa101clukrv.do',
    	                prgID: 'esa101ukrv',
    	                extParam: param
    	            });
    				win.center();
    				win.show();
    			}
            }
	    }]
	});
	
	var masterForm = Unilite.createForm('esa101ukrvDetail', {
    	disabled :false,
    	border:true,
	    split: true,
    	region:'north',
	    padding: '1 1 1 1',
        layout : {type : 'uniTable', columns : 3},
	    api: {
	        load: 'esa101ukrvService.selectForm',
	        submit: 'esa101ukrvService.syncForm'
	    },
		items: [{
            fieldLabel: '접수번호',
            name: 'AS_NUM',
            xtype: 'uniTextfield',
            readOnly: false,
            allowBlank: false,
            colspan: 3
        },{
            fieldLabel: '접수일',
            name: 'ACCEPT_DATE',
            xtype: 'uniDatefield',
            value: new Date(),
            allowBlank: false
        },
        Unilite.popup('Employee', {
            fieldLabel: '접수자',
            valueFieldName: 'ACCEPT_PRSN_NUMB',
            textFieldName: 'ACCEPT_PRSN',
            validateBlank: false,
            autoPopup: true,
            colspan: 2
        }),
        {
            fieldLabel: 'A/S요청자',
            name: 'AS_CUSTOMER_NM',
            xtype: 'uniTextfield',
            allowBlank: false

        },{
            fieldLabel: '연락처',
            name: 'PHONE',
            xtype: 'uniTextfield',
            colspan: 2

        },{
            xtype: 'component'
        },{
            fieldLabel: '휴대폰',
            name: 'HPHONE',
            colspan: 2,
            xtype: 'uniTextfield'
        },{
            fieldLabel: '수주번호',
            name: 'ORDER_NUM',
            xtype: 'uniTextfield',
            allowBlank: false,
            listeners: {
                render: function(p) {
                    p.getEl().on('click', function(p) {
                         openSearchInfoWindow(); 
                    });
                },
                change: function(field, newValue, oldValue, eOpts) {
                    if (Ext.isEmpty(newValue)) {
                        masterForm.setValues({
			                'ORDER_NUM': '',
			                'PROJECT_NO': '',
			                'FR_DATE': '',
			                'TO_DATE': '',
			                'AS_CUSTOMER_CD': '',
			                'AS_CUSTOMER_NAME': ''
						});
                    }
                }
            }
        },
        Unilite.popup('CUST', {
            fieldLabel: '수주처',
            valueFieldName: 'AS_CUSTOMER_CD',
            textFieldName: 'AS_CUSTOMER_NAME',
            allowBlank: false
        }),{
            fieldLabel: '영업담당',
            name: 'ORDER_PRSN',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'S010'
        },{
            fieldLabel: '처리구분',
            name: 'AS_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'S805'

        },{
            fieldLabel: '현장명',
            name: 'WORK_PLACE',
            xtype: 'uniTextfield',
            colspan: 2
        },{
            fieldLabel: '완료요청일',
            name: 'FINISH_REQ_DATE',
            xtype: 'uniDatefield',
            value: new Date()
        },{
            fieldLabel: '완료예정일',
            name: 'FINISH_EST_DATE',
            xtype: 'uniDatefield',
            value: new Date()
        },{
            fieldLabel: '유무상(접수)',
            name: 'BEFORE_PAY_YN',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'S802'
        },{
            fieldLabel: '요청사항',
            name: 'ACCEPT_REMARK',
            xtype: 'textarea',
            width: 600,
            height: 80,
            colspan: 3
        },{
            fieldLabel: '프로젝트번호',
            name: 'PROJECT_NO',
            xtype: 'uniTextfield',
            readOnly: true
        },{
            fieldLabel: '시작일',
            name: 'FR_DATE',
            xtype: 'uniDatefield',
            readOnly: true
        },{
            fieldLabel: '종료일',
            name: 'TO_DATE',
            xtype: 'uniDatefield',
            readOnly: true
        }],
        listeners: {
	        uniOnChange: function(basicForm, field, newValue, oldValue) {
				if(basicForm.isDirty()){
	                UniAppManager.setToolbarButtons('save', true);
				}
	        }
	    }
	});
	
	var detailGrid = Unilite.createGrid('esa101ukrvGrid', {
    	region:'center',
	    store: detailStore,
	    layout: 'fit',
	    uniOpt: {
	        expandLastColumn: false,
	        useLiveSearch: false,
	        useContextMenu: false,
	        useMultipleSorting: false,
	        useGroupSummary: false,
	        useRowNumberer: false,
	        filter: {
	            useFilter: true,
	            autoCreate: true
	        }
	    },
	    tbar:[{
			itemId: 'otherorderBtn',
			text: '<div style="color: blue">수주참조</div>',
			handler: function() {
				openSearchInfoWindow2();
			},
			listeners:{
				click:function(){
					if(!panelSearch.getInvalidMessage()) return false;
					if(!masterForm.getInvalidMessage()) return false;
				}
			}
		}],
	    columns: [
	    	{ dataIndex: 'COMP_CODE', width: 80, hidden: true },
	        { dataIndex: 'DIV_CODE', width: 80, hidden: true },
	        { dataIndex: 'AS_SEQ', width: 80},
	        // {dataIndex:'AS_NUM', width:80,hidden:true},
	        {
	            dataIndex: 'ITEM_CODE',
	            width: 130,
	            editor: Unilite.popup('DIV_PUMOK_G', {
	                textFieldName: 'ITEM_CODE',
	                DBtextFieldName: 'ITEM_CODE',
	                useBarcodeScanner: false,
	                autoPopup: true,
	                listeners: {
	                    'onSelected': {
	                        fn: function(records, type) {
	                            var grdRecord = detailGrid.uniOpt.currentRecord;
	                            grdRecord.set('ITEM_CODE', records[0]['ITEM_CODE']);
	                            grdRecord.set('ITEM_NAME', records[0]['ITEM_NAME']);
	                            grdRecord.set('STOCK_UNIT', records[0]['STOCK_UNIT']);
	                            grdRecord.set('SPEC', records[0]['SPEC']);
	                        },
	                        scope: this
	                    },
	                    'onClear': function(type) {
	                        var grdRecord = detailGrid.uniOpt.currentRecord;
	                        grdRecord.set('ITEM_CODE', '');
	                        grdRecord.set('ITEM_NAME', '');
	                        grdRecord.set('STOCK_UNIT', '');
	                        grdRecord.set('SPEC', '');
	                    }
	                }
	            })
	        },
	        {
	            dataIndex: 'ITEM_NAME',
	            width: 130,
	            editor: Unilite.popup('DIV_PUMOK_G', {
	                textFieldName: 'ITEM_NAME',
	                DBtextFieldName: 'ITEM_NAME',
	                useBarcodeScanner: false,
	                autoPopup: true,
	                listeners: {
	                    'onSelected': {
	                        fn: function(records, type) {
	                            var grdRecord = detailGrid.uniOpt.currentRecord;
	                            grdRecord.set('ITEM_CODE', records[0]['ITEM_CODE']);
	                            grdRecord.set('ITEM_NAME', records[0]['ITEM_NAME']);
	                            grdRecord.set('STOCK_UNIT', records[0]['STOCK_UNIT']);
	                            grdRecord.set('SPEC', records[0]['SPEC']);
	                        },
	                        scope: this
	                    },
	                    'onClear': function(type) {
	                        var grdRecord = detailGrid.uniOpt.currentRecord;
	                        grdRecord.set('ITEM_CODE', '');
	                        grdRecord.set('ITEM_NAME', '');
	                        grdRecord.set('STOCK_UNIT', '');
	                        grdRecord.set('SPEC', '');

	                    }
	                }
	            })
	        },
	        { dataIndex: 'LOT_NO', width: 120 },
	        { dataIndex: 'SALE_DATE', width: 120 },
	        { dataIndex: 'SPEC', width: 120 },
	        { dataIndex: 'STOCK_UNIT', width: 120, editable: false },
	        { dataIndex: 'AS_Q', width: 120 },
	        { dataIndex: 'INOUT_DATE', width: 120 },
	        { dataIndex: 'REMARK', width: 300 }
	    ],
	    setData:function(record){
        	/* var grdRecord = this.getSelectedRecord();
        	grdRecord.set('COMP_CODE'           , record['COMP_CODE']);
            grdRecord.set('DIV_CODE'          	, record['DIV_CODE']);
            grdRecord.set('ITEM_CODE'      		, record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'          	, record['ITEM_NAME']);
            grdRecord.set('SPEC'          		, record['SPEC']);
            grdRecord.set('STOCK_UNIT'         , record['STOCK_UNIT']);
            grdRecord.set('AS_Q'          		, record['AS_Q']);
            grdRecord.set('REMARK'          	, record['REMARK']); */
        }
	});
	
	
	/**
	*수주팝업
	*/
					var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
					    layout: {
					        type: 'uniTable',
					        columns: 3
					    },
					    trackResetOnLoad: true,
					    items: [{
					            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
					            name: 'DIV_CODE',
					            xtype: 'uniCombobox',
					            comboType: 'BOR120',
					            value: UserInfo.divCode,
					            allowBlank: false,
					            listeners: {
					                change: function(combo, newValue, oldValue, eOpts) {
					                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
					                    var field = orderNoSearch.getField('ORDER_PRSN');
					                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts); // panelResult의
					                }
					            }
					        }, {
					            fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
					            xtype: 'uniDateRangefield',
					            startFieldName: 'FR_ORDER_DATE',
					            endFieldName: 'TO_ORDER_DATE',
					            width: 350,
					            startDate: UniDate.get('startOfMonth'),
					            endDate: UniDate.get('today'),
					            colspan: 2
					        }, {
					            fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>',
					            name: 'ORDER_PRSN',
					            xtype: 'uniCombobox',
					            comboType: 'AU',
					            comboCode: 'S010',
					            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
					                if (eOpts) {
					                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					                } else {
					                    combo.divFilterByRefCode('refCode1', newValue, divCode);
					                }
					            }
					        },
					        Unilite.popup('AGENT_CUST', {
					            fieldLabel: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
					            validateBlank: false,
					            colspan: 2,
					            listeners: {
					                applyextparam: function(popup) {
					                    popup.setExtParam({
					                        'AGENT_CUST_FILTER': ['1', '3']
					                    });
					                    popup.setExtParam({
					                        'CUSTOM_TYPE': ['1', '3']
					                    });
					                }
					            }
					        }),
					        // Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO',
					        // textFieldName:'PROJECT_NAME', validateBlank: false}),
					        Unilite.popup('DIV_PUMOK', {
					            colspan: 2,
					            listeners: {
					                applyextparam: function(popup) {
					                    popup.setExtParam({
					                        'DIV_CODE': orderNoSearch.getValue('DIV_CODE')
					                    });
					                }
					            }
					        }),
					        {
					            fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
					            name: 'ORDER_TYPE',
					            xtype: 'uniCombobox',
					            comboType: 'AU',
					            comboCode: 'S002'
					        },
					        {
					            fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>',
					            name: 'PO_NUM'
					        },
					        {
					            fieldLabel: '조회구분',
					            xtype: 'uniRadiogroup',
					            allowBlank: false,
					            width: 235,
					            name: 'RDO_TYPE',
					            items: [{
					                    boxLabel: '마스터',
					                    name: 'RDO_TYPE',
					                    inputValue: 'master',
					                    checked: true
					                },
					                {
					                    boxLabel: '디테일',
					                    name: 'RDO_TYPE',
					                    inputValue: 'detail'
					                }
					            ],
					            listeners: {
					                change: function(field, newValue, oldValue, eOpts) {
					                    if (newValue.RDO_TYPE == 'detail') {
					                        if (orderNoMasterGrid) orderNoMasterGrid.hide();
					                        if (orderNoDetailGrid) orderNoDetailGrid.show();
					                    } else {
					                        if (orderNoDetailGrid) orderNoDetailGrid.hide();
					                        if (orderNoMasterGrid) orderNoMasterGrid.show();
					                    }
					                }
					            }
					        }
					        /*
					         * , Unilite.popup('DEPT', { fieldLabel: '부서', valueFieldName:
					         * 'DEPT_CODE', textFieldName: 'DEPT_NAME', listeners: {
					         * applyextparam: function(popup){ var authoInfo =
					         * pgmInfo.authoUser; //권한정보(N-전체,A-자기사업장>5-자기부서) var deptCode =
					         * UserInfo.deptCode; //부서정보 var divCode = ''; //사업장
					         * 
					         * if(authoInfo == "A"){ //자기사업장 popup.setExtParam({'DEPT_CODE':
					         * ""}); popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					         * 
					         * }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){ //전체권한
					         * popup.setExtParam({'DEPT_CODE': ""});
					         * popup.setExtParam({'DIV_CODE':
					         * masterForm.getValue('DIV_CODE')});
					         * 
					         * }else if(authoInfo == "5"){ //부서권한
					         * popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
					         * popup.setExtParam({'DIV_CODE': UserInfo.divCode}); } } } })
					         */
					    ]
					}); // createSearchForm
				    
				    // 검색 모델(마스터)
				    Unilite.defineModel('orderNoMasterModel', {
				        fields: [
				            {name: 'COMP_CODE'      , text: 'COMP_CODE'                                                 		, type: 'string'},
				            {name: 'DIV_CODE'       , text: '<t:message code="unilite.msg.sMS631" default="사업장"/>'             , type: 'string', comboType:'BOR120'}, 
				            {name: 'CUSTOM_CODE'    , text: '<t:message code="unilite.msg.sMSR213" default="거래처"/>' 			, type: 'string'}, 
				            {name: 'CUSTOM_NAME'    , text: '<t:message code="unilite.msg.sMSR279" default="거래처명"/>'    		, type: 'string'}, 
				            {name: 'ORDER_DATE'     , text: '<t:message code="unilite.msg.sMS122" default="수주일"/>'      		, type: 'uniDate'}, 
				            {name: 'ORDER_NUM'      , text: '<t:message code="unilite.msg.sMS533" default="수주번호"/>' 			, type: 'string'}, 
				            {name: 'ORDER_TYPE'     , text: '<t:message code="unilite.msg.sMS832" default="판매유형"/>' 			, type: 'string', comboType: 'AU', comboCode: 'S002'}, 
				            {name: 'ORDER_PRSN'     , text: '<t:message code="unilite.msg.sMS669" default="수주담당"/>' 			, type: 'string', comboType: 'AU', comboCode: 'S010'}, 
				            {name: 'PJT_CODE'       , text: '프로젝트코드'                                                    		, type: 'string'}, 
				            {name: 'PJT_NAME'       , text: '프로젝트'                                                  			, type: 'string'}, 
				            {name: 'FR_DATE'        , text: '시작일'                                                  				, type: 'string'},
				            {name: 'TO_DATE'        , text: '종료일'                                                  				, type: 'string'},
				            {name: 'ORDER_Q'        , text: '<t:message code="unilite.msg.sMS543" default="수주량"/>'     			, type: 'uniQty'}, 
				            {name: 'ORDER_O'        , text: '수주금액'                                                  			, type: 'uniPrice'},
				            {name: 'NATION_INOUT'   , text: '국내외구분'                                                  			, type: 'string'},    
				            {name: 'OFFER_NO'       , text: 'OFFER번호'                                                  			, type: 'string'},    
				            {name: 'DATE_DELIVERY'  , text: '납기일'                                                  				, type: 'string'}, 
				            {name: 'MONEY_UNIT'     , text: '화폐'                                                  				, type: 'string'}, 
				            {name: 'EXCHANGE_RATE'  , text: '환율'                                                  				, type: 'string'}, 
				            {name: 'RECEIPT_SET_METH'  , text: '결제방법'                                           				, type: 'string'}
				        ]
				    });
					
				    // 검색 스토어(마스터)
				    var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
					    model: 'orderNoMasterModel',
					    autoLoad: false,
					    uniOpt: {
					        isMaster: false, // 상위 버튼 연결
					        editable: false, // 수정 모드 사용
					        deletable: false, // 삭제 가능 여부
					        useNavi: false // prev | newxt 버튼 사용
					    },
					    proxy: {
					        type: 'direct',
					        api: {
					            read: 'sof100ukrvService.selectOrderNumMasterList'
					        }
					    },
					    loadStoreRecords: function() {
					        var param = orderNoSearch.getValues();
					        var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
					        var deptCode = UserInfo.deptCode; // 부서코드
					        if (authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))) {
					            param.DEPT_CODE = deptCode;
					        }
					        console.log(param);
					        this.load({
					            params: param
					        });
					    }
					});
				    
				 	// 검색 그리드(마스터)
				    var orderNoMasterGrid = Unilite.createGrid('sof100ukrvOrderNoMasterGrid', {
				        // title: '기본',
				        layout: 'fit',
				        store: orderNoMasterStore,
				        uniOpt: {
				            useRowNumberer: false
				        },
				        columns: [
				        	 { dataIndex: 'DIV_CODE'		,  width: 80 } 
				            ,{ dataIndex: 'ORDER_NUM'		,  width: 150 } 
				            ,{ dataIndex: 'ORDER_DATE'		,  width: 80 } 
				            ,{ dataIndex: 'ORDER_NUM'		,  width: 120 } 
				            ,{ dataIndex: 'ORDER_TYPE'		,  width: 80 } 
				            ,{ dataIndex: 'ORDER_PRSN'		,  width: 80 } 
				            ,{ dataIndex: 'PJT_CODE'			,  width: 120 		,hidden:true} 
				            ,{ dataIndex: 'PJT_NAME'			,  width: 200 } 
				            ,{ dataIndex: 'ORDER_Q'			,  width: 110 } 
				            ,{ dataIndex: 'ORDER_O'			,  width: 120 }  
				            ,{ dataIndex: 'FR_DATE'			,  width: 150 } 
				            ,{ dataIndex: 'TO_DATE'			,  width: 150 }
				        ],
				        listeners: {
				            onGridDblClick: function(grid, record, cellIndex, colName) {
				                orderNoMasterGrid.returnData(record);
				                SearchInfoWindow.hide();
				            }
				        } // listeners
				        ,
				        returnData: function(record) {
				            if (Ext.isEmpty(record)) {
				                record = this.getSelectedRecord();
				            }
				            masterForm.setValues({
				                'ORDER_NUM': record.get('ORDER_NUM'),
				                'PROJECT_NO': record.get('PJT_CODE'),
				                'FR_DATE': record.get('FR_DATE'),
				                'TO_DATE': record.get('TO_DATE'),
				                'AS_CUSTOMER_CD': record.get('CUSTOM_CODE'),
				                'AS_CUSTOMER_NAME': record.get('CUSTOM_NAME')
				            });
				        }
				    });
				    // 검색 모델(디테일)
				    Unilite.defineModel('orderNoDetailModel', {
				        fields: [
				             { name: 'DIV_CODE'     ,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'           ,type: 'string' ,comboType:'BOR120'} 
				            ,{ name: 'ITEM_CODE'    ,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'       	,type: 'string' } 
				            ,{ name: 'ITEM_NAME'    ,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'     		,type: 'string' } 
				            ,{ name: 'SPEC'         ,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'    		,type: 'string' } 
				            
				            ,{ name: 'ORDER_DATE'   ,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'        	,type: 'uniDate'} 
				            ,{ name: 'DVRY_DATE'    ,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'        	,type: 'uniDate'} 
				            
				            ,{ name: 'ORDER_Q'      ,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'        	,type: 'uniQty' } 
				            ,{ name: 'ORDER_TYPE'   ,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S002'} 
				            ,{ name: 'ORDER_PRSN'   ,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S010'} 
				            ,{ name: 'PO_NUM'       ,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'      	,type: 'string' }
				            ,{ name: 'PROJECT_NO'   ,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'       	,type: 'string' }
				            ,{ name: 'ORDER_NUM'    ,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'       	,type: 'string' } 
				            ,{ name: 'SER_NO'       ,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'       	,type: 'string' }
				            ,{ name: 'CUSTOM_CODE'  ,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'       	,type: 'string' } 
				            ,{ name: 'CUSTOM_NAME'  ,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'      	,type: 'string' } 
				            ,{ name: 'COMP_CODE'    ,text:'COMP_CODE'       ,type: 'string' } 
				            ,{ name: 'PJT_CODE'     ,text:'프로젝트코드'        	                                         		,type: 'string' } 
				            ,{ name: 'PJT_NAME'     ,text:'프로젝트'                                                        	,type: 'string' } 
				            ,{ name: 'FR_DATE'      ,text:'시작일'			                                                  	,type: 'string' } 
				            ,{ name: 'TO_DATE'      ,text:'종료일'         	                                              	,type: 'string' } 
				        ]
				    });
				    
				 // 검색 스토어(디테일)
				    var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
				        model: 'orderNoDetailModel',
				        autoLoad: false,
				        uniOpt: {
				            isMaster: false, // 상위 버튼 연결
				            editable: false, // 수정 모드 사용
				            deletable: false, // 삭제 가능 여부
				            useNavi: false // prev | newxt 버튼 사용
				        },
				        proxy: {
				            type: 'direct',
				            api: {
				                read: 'sof100ukrvService.selectOrderNumDetailList'
				            }
				        },
				        loadStoreRecords: function() {
				            var param = orderNoSearch.getValues();
				            var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
				            var deptCode = UserInfo.deptCode; // 부서코드
				            if (authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))) {
				                param.DEPT_CODE = deptCode;
				            }
				            console.log(param);
				            this.load({
				                params: param
				            });
				        }
				    });
				 
				    // 검색 그리드(디테일)
				    var orderNoDetailGrid = Unilite.createGrid('sof100ukrvOrderNoDetailGrid', {
				        layout: 'fit',
				        store: orderNoDetailStore,
				        uniOpt: {
				            useRowNumberer: false
				        },
				        hidden: true,
				        columns: [
				        	 { dataIndex: 'DIV_CODE'			,  width: 80 } 
				            ,{ dataIndex: 'ITEM_CODE'			,  width: 120 } 
				            ,{ dataIndex: 'ITEM_NAME'			,  width: 150 } 
				            ,{ dataIndex: 'SPEC'				,  width: 150 } 
				            ,{ dataIndex: 'ORDER_DATE'			,  width: 80 } 
				            ,{ dataIndex: 'DVRY_DATE'			,  width: 80 		,hidden:true} 
				            ,{ dataIndex: 'ORDER_Q'				,  width: 80 } 
				            ,{ dataIndex: 'ORDER_TYPE'			,  width: 90 } 
				            ,{ dataIndex: 'ORDER_PRSN'			,  width: 90 		,hidden:true} 
				            ,{ dataIndex: 'PO_NUM'				,  width: 100 } 
				            ,{ dataIndex: 'PROJECT_NO'			,  width: 90 } 
				            ,{ dataIndex: 'ORDER_NUM'			,  width: 120 } 
				            ,{ dataIndex: 'SER_NO'				,  width: 70 		,hidden:true} 
				            ,{ dataIndex: 'CUSTOM_CODE'			,  width: 120	 	,hidden:true} 
				            ,{ dataIndex: 'CUSTOM_NAME'			,  width: 200 } 
				            ,{ dataIndex: 'COMP_CODE'			,  width: 80 		,hidden:true} 
				            ,{ dataIndex: 'PJT_CODE'			,  width: 120 		,hidden:true} 
				            ,{ dataIndex: 'PJT_NAME'			,  width: 200 } 
				            ,{ dataIndex: 'FR_DATE'				,  width: 80	 	,hidden:true} 
				            ,{ dataIndex: 'TO_DATE'				,  width: 80 		,hidden:true}
				        ],
				        listeners: {
				            onGridDblClick: function(grid, record, cellIndex, colName) {
				                orderNoDetailGrid.returnData(record)
				                SearchInfoWindow.hide();
				            }
				        } // listeners
				        ,
				        returnData: function(record) {
				            if (Ext.isEmpty(record)) {
				                record = this.getSelectedRecord();
				            }
				            masterForm.setValues({
				                'ORDER_NUM': record.get('ORDER_NUM'),
				                'PROJECT_NO': record.get('PJT_CODE'),
				                'FR_DATE': record.get('FR_DATE'),
				                'TO_DATE': record.get('TO_DATE'),
				                'AS_CUSTOMER_CD': record.get('CUSTOM_CODE'),
				                'AS_CUSTOMER_NAME': record.get('CUSTOM_NAME')
				            });
				
				        }
				    });
				
				    function openSearchInfoWindow() {
				        if (!SearchInfoWindow) {
				            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				                title: '수주번호검색',
				                width: 830,
				                height: 580,
				                layout: {
				                    type: 'vbox',
				                    align: 'stretch'
				                },
				                items: [orderNoSearch, orderNoMasterGrid, orderNoDetailGrid],
				                tbar: [
				                       '->',{
				                    itemId: 'searchBtn',
				                    text: '조회',
				                    handler: function() {
				                        var rdoType = orderNoSearch.getValue('RDO_TYPE');
				                        console.log('rdoType : ', rdoType)
				                        if (rdoType.RDO_TYPE == 'master') {
				                            orderNoMasterStore.loadStoreRecords();
				                        } else {
				                            orderNoDetailStore.loadStoreRecords();
				                        }
				                    },
				                    disabled: false
				                }, {
				                    itemId: 'closeBtn',
				                    text: '닫기',
				                    handler: function() {
				                        SearchInfoWindow.hide();
				                    },
				                    disabled: false
				                }],
				                listeners: {
				                    beforehide: function(me, eOpt) {
				                        orderNoSearch.clearForm();
				                        orderNoMasterGrid.reset();
				            			orderNoMasterStore.clearData();
				                        orderNoDetailGrid.reset();
				                        orderNoDetailStore.clearData();
				                    },
				                    beforeclose: function(panel, eOpts) {
				                    },
				                    show: function(panel, eOpts) {
				                    	orderNoSearch.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
				                    	orderNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
				                    	orderNoSearch.setValue('TO_ORDER_DATE', UniDate.get('today'));
				                    }
				                }
				            })
				        }
				        SearchInfoWindow.center();
				        SearchInfoWindow.show();
				    }
    
    
				    
				    
				    
				    
				    
				    
				    
				    
				    
				    
				    
			////////////////////////////////////////////	    
				    var orderNoSearch2 = Unilite.createSearchForm('orderNoSearchForm2', {
					    layout: {
					        type: 'uniTable',
					        columns: 2
					    },
					    trackResetOnLoad: true,
					    items: [{
					            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
					            name: 'DIV_CODE',
					            xtype: 'uniCombobox',
					            comboType: 'BOR120',
					            value: UserInfo.divCode,
					            allowBlank: false,
					            listeners: {
					                change: function(combo, newValue, oldValue, eOpts) {
					                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
					                    var field = orderNoSearch2.getField('ORDER_PRSN');
					                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts); // panelResult의
					                }
					            }
					        }, {
					            fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
					            xtype: 'uniDateRangefield',
					            startFieldName: 'FR_ORDER_DATE',
					            endFieldName: 'TO_ORDER_DATE',
					            width: 350,
					            startDate: UniDate.get('startOfMonth'),
					            endDate: UniDate.get('today')
					        }, {
					            fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>',
					            name: 'ORDER_PRSN',
					            xtype: 'uniCombobox',
					            comboType: 'AU',
					            comboCode: 'S010',
					            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
					                if (eOpts) {
					                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					                } else {
					                    combo.divFilterByRefCode('refCode1', newValue, divCode);
					                }
					            }
					        },
					        Unilite.popup('AGENT_CUST', {
					            fieldLabel: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
					            validateBlank: false,
					            listeners: {
					                applyextparam: function(popup) {
					                    popup.setExtParam({
					                        'AGENT_CUST_FILTER': ['1', '3']
					                    });
					                    popup.setExtParam({
					                        'CUSTOM_TYPE': ['1', '3']
					                    });
					                }
					            }
					        }),
					        {
					            fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
					            name: 'ORDER_TYPE',
					            xtype: 'uniCombobox',
					            comboType: 'AU',
					            comboCode: 'S002'
					        },
					        Unilite.popup('DIV_PUMOK', {
					            listeners: {
					                applyextparam: function(popup) {
					                    popup.setExtParam({
					                        'DIV_CODE': orderNoSearch2.getValue('DIV_CODE')
					                    });
					                }
					            }
					        }),
					        {
					            fieldLabel: '수주번호',
					            name: 'ORDER_NUM',
					            readOnly: true
					        },
					        {
					            fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>',
					            name: 'PO_NUM'
					        },
					        {
					            fieldLabel: '조회구분',
					            xtype: 'uniRadiogroup',
					            allowBlank: false,
					            hidden: true,
					            width: 235,
					            name: 'RDO_TYPE',
					            items: [{
					                    boxLabel: '마스터',
					                    name: 'RDO_TYPE',
					                    inputValue: 'master'
					                },
					                {
					                    boxLabel: '디테일',
					                    name: 'RDO_TYPE',
					                    inputValue: 'detail',
					                    checked: true
					                }
					            ],
					            listeners: {
					                change: function(field, newValue, oldValue, eOpts) {
					                    if (newValue.RDO_TYPE == 'detail') {
					                        if (orderNoMasterGrid2) orderNoMasterGrid2.hide();
					                        if (orderNoDetailGrid2) orderNoDetailGrid2.show();
					                    } else {
					                        if (orderNoDetailGrid2) orderNoDetailGrid2.hide();
					                        if (orderNoMasterGrid2) orderNoMasterGrid2.show();
					                    }
					                }
					            }
					        }
					    ]
					}); // createSearchForm
				    
				    // 검색 모델(마스터)
				    Unilite.defineModel('orderNoMasterModel2', {
				        fields: [
				            {name: 'COMP_CODE'      , text: 'COMP_CODE'                                                 		, type: 'string'},
				            {name: 'DIV_CODE'       , text: '<t:message code="unilite.msg.sMS631" default="사업장"/>'             , type: 'string', comboType:'BOR120'}, 
				            {name: 'CUSTOM_CODE'    , text: '<t:message code="unilite.msg.sMSR213" default="거래처"/>' 			, type: 'string'}, 
				            {name: 'CUSTOM_NAME'    , text: '<t:message code="unilite.msg.sMSR279" default="거래처명"/>'    		, type: 'string'}, 
				            {name: 'ORDER_DATE'     , text: '<t:message code="unilite.msg.sMS122" default="수주일"/>'      		, type: 'uniDate'}, 
				            {name: 'ORDER_NUM'      , text: '<t:message code="unilite.msg.sMS533" default="수주번호"/>' 			, type: 'string'}, 
				            {name: 'ORDER_TYPE'     , text: '<t:message code="unilite.msg.sMS832" default="판매유형"/>' 			, type: 'string', comboType: 'AU', comboCode: 'S002'}, 
				            {name: 'ORDER_PRSN'     , text: '<t:message code="unilite.msg.sMS669" default="수주담당"/>' 			, type: 'string', comboType: 'AU', comboCode: 'S010'}, 
				            {name: 'PJT_CODE'       , text: '프로젝트코드'                                                    		, type: 'string'}, 
				            {name: 'PJT_NAME'       , text: '프로젝트'                                                  			, type: 'string'}, 
				            {name: 'FR_DATE'        , text: '시작일'                                                  				, type: 'string'},
				            {name: 'TO_DATE'        , text: '종료일'                                                  				, type: 'string'},
				            {name: 'ORDER_Q'        , text: '<t:message code="unilite.msg.sMS543" default="수주량"/>'     			, type: 'uniQty'}, 
				            {name: 'ORDER_O'        , text: '수주금액'                                                  			, type: 'uniPrice'},
				            {name: 'NATION_INOUT'   , text: '국내외구분'                                                  			, type: 'string'},    
				            {name: 'OFFER_NO'       , text: 'OFFER번호'                                                  			, type: 'string'},    
				            {name: 'DATE_DELIVERY'  , text: '납기일'                                                  				, type: 'string'}, 
				            {name: 'MONEY_UNIT'     , text: '화폐'                                                  				, type: 'string'}, 
				            {name: 'EXCHANGE_RATE'  , text: '환율'                                                  				, type: 'string'}, 
				            {name: 'RECEIPT_SET_METH'  , text: '결제방법'                                           				, type: 'string'}
				        ]
				    });
					
				    // 검색 스토어(마스터)
				    var orderNoMasterStore2 = Unilite.createStore('orderNoMasterStore2', {
					    model: 'orderNoMasterModel2',
					    autoLoad: false,
					    uniOpt: {
					        isMaster: false, // 상위 버튼 연결
					        editable: false, // 수정 모드 사용
					        deletable: false, // 삭제 가능 여부
					        useNavi: false // prev | newxt 버튼 사용
					    },
					    proxy: {
					        type: 'direct',
					        api: {
					            read: 'sof100ukrvService.selectOrderNumMasterList'
					        }
					    },
					    loadStoreRecords: function() {
					        var param = orderNoSearch2.getValues();
					        var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
					        var deptCode = UserInfo.deptCode; // 부서코드
					        if (authoInfo == "5" && Ext.isEmpty(orderNoSearch2.getValue('DEPT_CODE'))) {
					            param.DEPT_CODE = deptCode;
					        }
					        console.log(param);
					        this.load({
					            params: param
					        });
					    }
					});
				    
				 	// 검색 그리드(마스터)
				    var orderNoMasterGrid2 = Unilite.createGrid('sof100ukrvorderNoMasterGrid2', {
				        layout: 'fit',
				        store: orderNoMasterStore2,
				        uniOpt: {
				        	onLoadSelectFirst: false,  
				        	useRowNumberer: false
				        },
				        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }), 
				        hidden: true,
				        columns: [
				        	 { dataIndex: 'DIV_CODE'		,  width: 80 } 
				            ,{ dataIndex: 'ORDER_NUM'		,  width: 150 } 
				            ,{ dataIndex: 'ORDER_DATE'		,  width: 80 } 
				            ,{ dataIndex: 'ORDER_NUM'		,  width: 120 } 
				            ,{ dataIndex: 'ORDER_TYPE'		,  width: 80 } 
				            ,{ dataIndex: 'ORDER_PRSN'		,  width: 80 } 
				            ,{ dataIndex: 'PJT_CODE'			,  width: 120 		,hidden:true} 
				            ,{ dataIndex: 'PJT_NAME'			,  width: 200 } 
				            ,{ dataIndex: 'ORDER_Q'			,  width: 110 } 
				            ,{ dataIndex: 'ORDER_O'			,  width: 120 }  
				            ,{ dataIndex: 'FR_DATE'			,  width: 150 } 
				            ,{ dataIndex: 'TO_DATE'			,  width: 150 }
				        ],
				        listeners: {
				            onGridDblClick: function(grid, record, cellIndex, colName) {
				                orderNoMasterGrid2.returnData(record);
				                SearchInfoWindow.hide();
				            }
				        } // listeners
				        , returnData: function(records){
				            if(Ext.isEmpty(records))	{
				      			records = this.getSelectedRecords();
				      		}
							Ext.each(records, function(record,i) {
								//UniAppManager.app.onNewDataButtonDown();
								//detailGrid1.setData(record.data);
							});
				        }
				    });
				    // 검색 모델(디테일)
				    Unilite.defineModel('orderNoDetailModel2', {
				        fields: [
				             { name: 'DIV_CODE'     ,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'           ,type: 'string' ,comboType:'BOR120'} 
				            ,{ name: 'ITEM_CODE'    ,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'       	,type: 'string' } 
				            ,{ name: 'ITEM_NAME'    ,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'     		,type: 'string' } 
				            ,{ name: 'SPEC'         ,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'    		,type: 'string' } 
				            
				            ,{ name: 'ORDER_DATE'   ,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'        	,type: 'uniDate'} 
				            ,{ name: 'DVRY_DATE'    ,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'        	,type: 'uniDate'} 
				            
				            ,{ name: 'ORDER_Q'      ,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'        	,type: 'uniQty' } 
				            ,{ name: 'ORDER_TYPE'   ,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S002'} 
				            ,{ name: 'ORDER_PRSN'   ,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S010'} 
				            ,{ name: 'PO_NUM'       ,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'      	,type: 'string' }
				            ,{ name: 'PROJECT_NO'   ,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'       	,type: 'string' }
				            ,{ name: 'ORDER_NUM'    ,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'       	,type: 'string' } 
				            ,{ name: 'SER_NO'       ,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'       	,type: 'string' }
				            ,{ name: 'CUSTOM_CODE'  ,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'       	,type: 'string' } 
				            ,{ name: 'CUSTOM_NAME'  ,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'      	,type: 'string' } 
				            ,{ name: 'COMP_CODE'    ,text:'COMP_CODE'       ,type: 'string' } 
				            ,{ name: 'PJT_CODE'     ,text:'프로젝트코드'        	                                         		,type: 'string' } 
				            ,{ name: 'PJT_NAME'     ,text:'프로젝트'                                                        	,type: 'string' } 
				            ,{ name: 'FR_DATE'      ,text:'시작일'			                                                  	,type: 'string' } 
				            ,{ name: 'TO_DATE'      ,text:'종료일'         	                                              	,type: 'string' } 
				        ]
				    });
				    
				 // 검색 스토어(디테일)
				    var orderNoDetailStore2 = Unilite.createStore('orderNoDetailStore2', {
				        model: 'orderNoDetailModel2',
				        autoLoad: false,
				        uniOpt: {
				            isMaster: false, // 상위 버튼 연결
				            editable: false, // 수정 모드 사용
				            deletable: false, // 삭제 가능 여부
				            useNavi: false // prev | newxt 버튼 사용
				        },
				        proxy: {
				            type: 'direct',
				            api: {
				                read: 'sof100ukrvService.selectOrderNumDetailList'
				            }
				        },
				        loadStoreRecords: function() {
				            var param = orderNoSearch2.getValues();
				            var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
				            var deptCode = UserInfo.deptCode; // 부서코드
				            if (authoInfo == "5" && Ext.isEmpty(orderNoSearch2.getValue('DEPT_CODE'))) {
				                param.DEPT_CODE = deptCode;
				            }
				            console.log(param);
				            this.load({
				                params: param
				            });
				        }
				    });
				 
				    // 검색 그리드(디테일)
				    var orderNoDetailGrid2 = Unilite.createGrid('sof100ukrvorderNoDetailGrid2', {
				        layout: 'fit',
				        store: orderNoDetailStore2,
				        uniOpt: {
				        	onLoadSelectFirst: false,  
				        	useRowNumberer: false
				        },
				        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false }), 
				        columns: [
				        	 { dataIndex: 'DIV_CODE'			,  width: 80 } 
				            ,{ dataIndex: 'ITEM_CODE'			,  width: 120 } 
				            ,{ dataIndex: 'ITEM_NAME'			,  width: 150 } 
				            ,{ dataIndex: 'SPEC'				,  width: 150 } 
				            ,{ dataIndex: 'ORDER_DATE'			,  width: 80 } 
				            ,{ dataIndex: 'DVRY_DATE'			,  width: 80 		,hidden:true} 
				            ,{ dataIndex: 'ORDER_Q'				,  width: 80 } 
				            ,{ dataIndex: 'ORDER_TYPE'			,  width: 90 } 
				            ,{ dataIndex: 'ORDER_PRSN'			,  width: 90 		,hidden:true} 
				            ,{ dataIndex: 'PO_NUM'				,  width: 100 } 
				            ,{ dataIndex: 'PROJECT_NO'			,  width: 90 } 
				            ,{ dataIndex: 'ORDER_NUM'			,  width: 120 } 
				            ,{ dataIndex: 'SER_NO'				,  width: 70 		,hidden:true} 
				            ,{ dataIndex: 'CUSTOM_CODE'			,  width: 120	 	,hidden:true} 
				            ,{ dataIndex: 'CUSTOM_NAME'			,  width: 200 } 
				            ,{ dataIndex: 'COMP_CODE'			,  width: 80 		,hidden:true} 
				            ,{ dataIndex: 'PJT_CODE'			,  width: 120 		,hidden:true} 
				            ,{ dataIndex: 'PJT_NAME'			,  width: 200 } 
				            ,{ dataIndex: 'FR_DATE'				,  width: 80	 	,hidden:true} 
				            ,{ dataIndex: 'TO_DATE'				,  width: 80 		,hidden:true}
				        ],
				        listeners: {
				            onGridDblClick: function(grid, record, cellIndex, colName) {
				                orderNoDetailGrid2.returnData(record)
				                SearchInfoWindow.hide();
				            }
				        } // listeners
				        , returnData: function(records) {
				        	if(Ext.isEmpty(records))	{
				        		records = this.getSelectedRecords();
				      		}
							Ext.each(records, function(record,i) {
								var today = UniDate.get('today');
					            var asNum = masterForm.getValue('AS_NUM');
					            var divCode = panelSearch.getValue('DIV_CODE');
								var r = {
										AS_SEQ: record.get('SER_NO'),
										COMP_CODE: UserInfo.compCode,
										DIV_CODE: divCode,
										ITEM_CODE: record.get('ITEM_CODE'),
										ITEM_NAME: record.get('ITEM_NAME'),
										AS_Q: record.get('ORDER_Q'),
						                AS_NUM: asNum,
						                INOUT_DATE: today
						            }
						            detailGrid.createRow(r);
								//detailGrid1.setData(record.data);
							});
				        }
				    });
				
				    function openSearchInfoWindow2() {
				        if (!SearchInfoWindow) {
				            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				                title: '수주번호검색',
				                width: 830,
				                height: 580,
				                layout: {
				                    type: 'vbox',
				                    align: 'stretch'
				                },
				                items: [orderNoSearch2, orderNoMasterGrid2, orderNoDetailGrid2],
				                tbar: [
				                       '->',{
				                    itemId: 'searchBtn',
				                    text: '조회',
				                    handler: function() {
				                        var rdoType = orderNoSearch2.getValue('RDO_TYPE');
				                        console.log('rdoType : ', rdoType)
				                        if (rdoType.RDO_TYPE == 'master') {
				                            orderNoMasterStore2.loadStoreRecords();
				                        } else {
				                            orderNoDetailStore2.loadStoreRecords();
				                        }
				                    },
				                    disabled: false
				                },{	itemId : 'confirmBtn',
									id:'confirmBtn1',
									text: '적용',
									handler: function() {
										orderNoDetailGrid2.returnData();
									},
									disabled: false
								},{	itemId : 'confirmCloseBtn',
									id:'confirmCloseBtn1',
									text: '적용 후 닫기',
									handler: function() {
										orderNoDetailGrid2.returnData();
										SearchInfoWindow.hide();
									},
									disabled: false
								},{
				                    itemId: 'closeBtn',
				                    text: '닫기',
				                    handler: function() {
				                        SearchInfoWindow.hide();
				                    },
				                    disabled: false
				                }],
				                listeners: {
				                    beforehide: function(me, eOpt) {
				                        orderNoSearch2.clearForm();
				                        orderNoMasterGrid2.reset();
				            			orderNoMasterStore2.clearData();
				                        orderNoDetailGrid2.reset();
				                        orderNoDetailStore2.clearData();
				                    },
				                    beforeclose: function(panel, eOpts) {
				                    },
				                    show: function(panel, eOpts) {
				                    	orderNoSearch2.setValue('DIV_CODE', panelSearch.getValue('DIV_CODE'));
				                    	orderNoSearch2.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
				                    	orderNoSearch2.setValue('TO_ORDER_DATE', UniDate.get('today'));
				                    	orderNoSearch2.setValue('ORDER_NUM', masterForm.getValue('ORDER_NUM'));
				                    }
				                }
				            })
				        }
				        SearchInfoWindow.center();
				        SearchInfoWindow.show();
				    }
				    
			///////////////////////////////////////////////////	    
				 

    Unilite.Main({
        border: false,
        borderItems: [{
            region: 'center',
            layout: 'border',
            border: false,
            id:'pageAll',
            flex: 1,
            items: [
                panelSearch,masterForm, detailGrid
            ]
        }],
        id: 'esa101ukrvApp',
        fnInitBinding: function() {
            
            panelSearch.setValue("DIV_CODE", UserInfo.divCode);
            masterForm.setValue("ACCEPT_DATE", UniDate.get('today'));
            masterForm.setValue("FINISH_REQ_DATE", UniDate.get('today'));
            masterForm.setValue("FINISH_EST_DATE", UniDate.get('today'));
            
            UniAppManager.setToolbarButtons(['reset','newData'], true);
            UniAppManager.setToolbarButtons(['print','save'], false);
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
            masterForm.clearForm();
            detailGrid.reset();
            detailStore.clearData();
            
            this.fnInitInputFields();
        },
        onQueryButtonDown: function() {
//            if (panelSearch.setAllFieldsReadOnly2(true)) return;
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			
            masterForm.getForm().load({
                params: panelSearch.getValues(),
                success: function(form, action) {
                    Ext.getCmp("printButton").enable();
                    masterForm.uniOpt.inLoading = false;
                    masterForm.unmask();
                    panelSearch.getField('DIV_CODE').setReadOnly(true);
                    panelSearch.getField('AS_NUM_SEACH').setReadOnly(true);
                    masterForm.getField('AS_NUM').setReadOnly(true);
            		detailStore.loadStoreRecords();
                },
                failure: function(form, action) {
                    Ext.getCmp("printButton").setDisabled(true);
                    masterForm.uniOpt.inLoading = false;
                    masterForm.unmask();
                }
            });
     /*       var orderNum = panelSearch.getValue('AS_NUM_SEACH');
            if (Ext.isEmpty(orderNum)) {
                return false
            } else {
                detailStore.loadStoreRecords();
            }*/
        },
        onNewDataButtonDown: function() {
        	
			if(!masterForm.getInvalidMessage()) return;   //필수체크
        	
            panelSearch.getField('DIV_CODE').setReadOnly(true);
            masterForm.getField('AS_NUM').setReadOnly(true);
            
            var today = UniDate.get('today');
            var asNum = masterForm.getValue('AS_NUM');
            var divCode = panelSearch.getValue('DIV_CODE');
            var seq = detailGrid.getStore().max('AS_SEQ');
            if(!seq){
            	seq = 1;
            }else{
            	seq += 1;
            }
            var r = {
                AS_SEQ: seq,
                AS_NUM: asNum,
                DIV_CODE: divCode,
                INOUT_DATE: today
            }
            detailGrid.createRow(r);
        },
        onSaveDataButtonDown: function() {
			if(!masterForm.getInvalidMessage()) return;   //필수체크
        	
            if (!detailStore.isDirty()) {
           		Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
            	var param = masterForm.getValues();
				param.DIV_CODE = panelSearch.getValue('DIV_CODE');
                masterForm.getForm().submit({
                    params: param,
                    success: function(form, action) {
                    	
                        panelSearch.setValues('AS_NUM_SEACH',action.result.resultData.as_NUM);
                        masterForm.setValues('AS_NUM',action.result.resultData.as_NUM);
                        
                        masterForm.getForm().wasDirty = false;
                        masterForm.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.updateStatus(Msg.sMB011); // "저장되었습니다.
                        Ext.getCmp("printButton").enable();
                        UniAppManager.app.onQueryButtonDown();
                        
                        Ext.getCmp('pageAll').getEl().unmask();  
//                        UniAppManager.setToolbarButtons('newData', true);
                    },
					failure: function(form, action)	{
                        Ext.getCmp('pageAll').getEl().unmask();  	
                    }
                });
                
            } else {
                detailStore.saveStore();
            }

        },
        onDeleteDataButtonDown: function() {
            var selRow = detailGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                    detailGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                    detailGrid.deleteSelectedRow();   
                }
            }
        },
		fnInitInputFields: function(){
            
            panelSearch.setValue("DIV_CODE", UserInfo.divCode);
            masterForm.setValue("ACCEPT_DATE", UniDate.get('today'));
            masterForm.setValue("FINISH_REQ_DATE", UniDate.get('today'));
            masterForm.setValue("FINISH_EST_DATE", UniDate.get('today'));
            
            Ext.getCmp("printButton").setDisabled(true);
            panelSearch.getField('DIV_CODE').setReadOnly(false);
            panelSearch.getField('AS_NUM_SEACH').setReadOnly(false);
            masterForm.getField('AS_NUM').setReadOnly(false);
           
            UniAppManager.setToolbarButtons(['reset','newData'], true);
            UniAppManager.setToolbarButtons(['print','save'], false);
            
		}

    });
};
</script>