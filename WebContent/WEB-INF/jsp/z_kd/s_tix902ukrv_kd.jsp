<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tix902ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 판매단위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var isLoad = false; //로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음

function appMain() {
	var searchInfoWindow;  //검색창
	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('S_tix902ukrv_kdModel', {  //모델정의 - 디테일 그리드
		fields: [
			{name: 'DIV_CODE'                 , text: '사업장'              , type: 'string', comboType:'BOR120'},
            {name: 'RETURN_NO'                , text: '환급번호'             , type: 'string'},
            {name: 'SEQ_OLD'                  , text: '순서(순번)OLD'        , type: 'int' },
            {name: 'SEQ'                      , text: '순서(순번)'           , type: 'int' , allowBlank: false },
            {name: 'ACCEPT_NO'                , text: '접수번호'             , type: 'string' , allowBlank: false },
            {name: 'BASIS_NO'                 , text: '근거번호'             , type: 'string', allowBlank: false },
            {name: 'TAKER_CODE'                , text: '양도자코드'             , type: 'string', allowBlank: false },
            {name: 'TAKE_DATE'                , text: '양도일자'             , type: 'uniDate', allowBlank: false },
            {name: 'TAKER_NAME'               , text: '양도자상호'            , type: 'string', allowBlank: false },
            {name: 'COMPANY_NUM'              , text: '사업자번호'            , type: 'string', allowBlank: false , maxLength: 10}, // maxlength: '10',  enforceMaxLength: true},
            {name: 'TAKE_QTY'                 , text: '양도물량'             , type: 'uniPrice', allowBlank: false},
            {name: 'STOCK_UNIT'               , text: '단위'                , type: 'string', allowBlank: false, comboType:'AU',comboCode:'B013' ,defaultValue:'EA', displayField: 'value' },
            {name: 'FOB_AMT'                  , text: 'FOB금액'             , type: 'uniPrice', allowBlank: false },
            {name: 'TAKE_VAT'                 , text: '양도세액'             , type: 'uniPrice', allowBlank: false },
            {name: 'SAVE_FLAG'                 , text: 'SAVE_FLAG'             , type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 's_tix902ukrv_kdService.insertList',
			read: 's_tix902ukrv_kdService.selectList',
			update: 's_tix902ukrv_kdService.updateList',
			destroy: 's_tix902ukrv_kdService.deleteList',
			syncAll: 's_tix902ukrv_kdService.saveAll'
		}
	});
   /**
     * Store 정의(Combobox)
     * @type
     */

	var directMasterStore1 = Unilite.createStore('s_tix902ukrv_kdMasterStore1', {
		model: 'S_tix902ukrv_kdModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
        saveStore : function()	{
        	var paramMaster = panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
                        panelSearch.setValue("RETURN_NO", master.RETURN_NO);
                        panelResult.setValue("RETURN_NO", master.RETURN_NO);
                        panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
                        directMasterStore1.loadStoreRecords();
                        if(directMasterStore1.getCount() == 0&& !panelResult.isDirty()){
                            UniAppManager.app.onResetButtonDown();
                        }
					 }
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});//End of var directMasterStore1


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
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },
            	{
                fieldLabel: '환급번호',
                xtype:'uniTextfield',
                name: 'RETURN_NO',
                readOnly: true
            },{
                fieldLabel: '(작성)일자',
                xtype: 'uniDatefield',
                name: 'RETURN_DATE',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('RETURN_NO', newValue);
                        
                    }
                }
            },{
                fieldLabel: '등록자',
                xtype: 'uniTextfield',
                name: 'ENTRY_MAN',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ENTRY_MAN', newValue);
                    }
                }
            },
            	{
                fieldLabel: '비고',
//                xtype: 'uniTextfield',
                xtype: 'textareafield',
                name: 'REMARK',
                textFieldWidth: 170,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('REMARK', newValue);
                    }

                }
            }
            ,{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                items:[{
                    fieldLabel: '화폐/환율',
                    xtype:'uniCombobox',
                    name: 'MONEY_UNIT',
                    comboType: 'AU',
                    comboCode: 'B004',
                    value: 'KRW',
                    displayField: 'value',
                    width: 174,
                    allowBlank: false,
                    hidden: true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('MONEY_UNIT', newValue);
//                            if(isLoad){
//                                isLoad = false;
//                            }else{
//                                UniAppManager.app.fnExchngRateO();
//                            }
                        }
                    }
                },{
                    fieldLabel: '',
                    xtype:'uniNumberfield',
                    name: 'EXCHG_RATE_O',
                    decimalPrecision: 4,
                    allowBlank: false,
                    hidden: true,
                    width: 70,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('EXCHG_RATE_O', newValue);
                        }
                    }
                }]
            }]
		}]
	});//End of var panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            readOnly: true,
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },{
            fieldLabel: '환급번호',
            xtype:'uniTextfield',
            name: 'RETURN_NO',
            readOnly: true
        },{
            fieldLabel: '(작성)일자',
            xtype: 'uniDatefield',
            name: 'RETURN_DATE',
            margin: '0 0 0 -247',
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('RETURN_DATE', newValue);

                }
            }
        },{
            fieldLabel: '등록자',
            xtype: 'uniTextfield',
            name: 'ENTRY_MAN',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ENTRY_MAN', newValue);

                }
            }
        },{
            fieldLabel: '비고',
            xtype: 'uniTextfield',
            name: 'REMARK',
            width: 500, //////
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('REMARK', newValue);

                }
            }
        }
        ,{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 2},
            items:[{
                fieldLabel: '화폐/환율',
                xtype: 'uniCombobox',
                name: 'MONEY_UNIT',
                comboType: 'AU',
                comboCode: 'B004',
                value: 'KRW',
                displayField: 'value',
                allowBlank: false,
                hidden: true,
                width: 174,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('MONEY_UNIT', newValue);
                        if(isLoad){
                            isLoad = false;
                        }else{
                            UniAppManager.app.fnExchngRateO();
                        }
                    }
                }
            },{
                fieldLabel: '환율',
                hideLabel: true,
                xtype:'uniNumberfield',
                name: 'EXCHG_RATE_O',
                decimalPrecision: 4,
                allowBlank: false,
                hidden: true,
                value: '1',
                width: 70,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('EXCHG_RATE_O', newValue);
                    }
                }
            }]
        }],
        listeners: {
            uniOnChange: function(basicForm, dirty, eOpts) {
                var record = masterGrid.getSelectedRecord();
                if(!Ext.isEmpty(record)){
                    UniAppManager.setToolbarButtons('save', true);
                    record.set('SAVE_FLAG', 'Y');
                }else{
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
       
    });//End of var panelSearch

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

	var masterGrid = Unilite.createGrid('s_tix902ukrv_kdGrid1', {      //detail그리드 정의
		layout: 'fit',
		region: 'center',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
            {dataIndex: 'DIV_CODE'     		    , width: 120   , hidden: true},    //사업장
            {dataIndex: 'RETURN_NO'             , width: 120   , hidden: true},    //환급번호
            {dataIndex: 'SEQ_OLD'               , width: 100   , hidden: true},    //순서(순번)OLD
            {dataIndex: 'SEQ'                   , width: 100},                     //순서(순번)
            {dataIndex: 'ACCEPT_NO'             , width: 120},                     //접수번호
            {dataIndex: 'BASIS_NO'              , width: 150},                     //근거번호
            {dataIndex: 'TAKE_DATE'             , width: 100},                     //양도일자
            {dataIndex: 'TAKER_CODE'             , width: 100,
            	editor: Unilite.popup('CUST_G', {
            		autoPopup: true,
    				listeners: {
    					onSelected: {
    						fn: function(records, type) {
    							var grdRecord = masterGrid.uniOpt.currentRecord;
    							grdRecord.set('TAKER_CODE',records[0]['CUSTOM_CODE']);
    							grdRecord.set('TAKER_NAME',records[0]['CUSTOM_NAME']);
    							grdRecord.set('COMPANY_NUM',records[0]['COMPANY_NUM']);
    						},
    	                    scope: this
    					},
    					onClear: function(type) {
    						var grdRecord = masterGrid.uniOpt.currentRecord;
    						grdRecord.set('TAKER_CODE','');
    						grdRecord.set('TAKER_NAME','');
    	                }
    				}
    			})
            },
            {dataIndex: 'TAKER_NAME'            , width: 150},                     //양수자상호
            {dataIndex: 'COMPANY_NUM'           , width: 100},                     //사업자번호
            {dataIndex: 'TAKE_QTY'              , width: 100},                     //양도물량
            {dataIndex: 'STOCK_UNIT'            , width: 80, align: 'center'},     //단위
            {dataIndex: 'FOB_AMT'               , width: 120},                     //FOB금액
            {dataIndex: 'TAKE_VAT'              , width: 100},                      //양도세액
            {dataIndex: 'SAVE_FLAG'              , width: 100 , hidden: true}
//            {dataIndex: 'GW_FLAG'               , width: 100, hidden: true}
		],
		setItemData: function(record, dataClear, grdRecord) {
              var grdRecord = this.uniOpt.currentRecord;
            if(dataClear) {
                grdRecord.set('SEQ_OLD'             ,'');
                grdRecord.set('SEQ'                 ,'');
                grdRecord.set('ACCEPT_NO'           ,'');
                grdRecord.set('BASIS_NO'            ,'');
                grdRecord.set('TAKE_DATE'           ,'');
                grdRecord.set('TAKER_NAME'          ,'');
                grdRecord.set('COMPANY_NUM'         ,'');
                grdRecord.set('TAKE_QTY'            ,0);
                grdRecord.set('STOCK_UNIT'          ,'EA');
                grdRecord.set('FOB_AMT'             ,0);
                grdRecord.set('TAKE_VAT'            ,0);


            } else {
                grdRecord.set('DIV_CODE'            , record['DIV_CODE']);
                grdRecord.set('RETURN_NO'           , record['RETURN_NO']);
                grdRecord.set('SEQ_OLD'             , record['SEQ_OLD']);
                grdRecord.set('SEQ'                 , record['SEQ']);
                grdRecord.set('ACCEPT_NO'           , record['ACCEPT_NO']);
                grdRecord.set('BASIS_NO'            , record['BASIS_NO']);
                grdRecord.set('TAKE_DATE'           , record['TAKE_DATE']);
                grdRecord.set('TAKER_NAME'          , record['TAKER_NAME']);
                grdRecord.set('COMPANY_NUM'         , record['COMPANY_NUM']);
                grdRecord.set('TAKE_QTY'            , record['TAKE_QTY']);
                grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
                grdRecord.set('FOB_AMT'             , record['FOB_AMT']);
                grdRecord.set('TAKE_VAT'            , record['TAKE_VAT']);


            }
        },
        listeners: {
          	beforeedit: function(editor, e) { //그리드상에 필드 수정 가능 여부 설정
          		if(e.record.phantom){ //행추가 버튼을 눌렀을때 생긴 행에 대한 설정(신규데이터)
          		    if (UniUtils.indexOf(e.field, ['DIV_CODE','RETURN_NO','SEQ_OLD'])){
                        return false;
                    }

          		}else{ // 조회했을때 설정(기존데이터)
          			var mstRecord = masterGrid.getSelectedRecord(); //선택한 행의 레코드
//                    if(e.record.get('GW_FLAG') != 'N' && e.record.get('GW_FLAG') != '2') { //GW_Flag가 기안전(N), 반려(2)일때 수정가능
//                    if(mstRecord.get('GW_FLAG') != 'N' && mstRecord.get('GW_FLAG') != '2') { //GW_Flag가 기안전(N), 반려(2)일때 수정가능
//                        return false;
//                    } else {
                	if(UniUtils.indexOf(e.field, ['DIV_CODE','RETURN_NO','SEQ_OLD'])){
                        return false;
                    }else {
                        return true;
                    }
//                    }

          		}

          	},
          	edit: function(editor, e) {

          	}
        }
	});//End of var masterGrid

	 //검색창 폼 정의 - 메인조회 (큰돋보기)
    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
        layout: {type: 'uniTable', columns : 2},
        trackResetOnLoad: true,
        items: [{
            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>'  ,
            name: 'DIV_CODE',
            xtype:'uniCombobox',
            comboType:'BOR120',
            value:UserInfo.divCode,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                }
            }
        },{
        	fieldLabel: '(작성)일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'RETURN_DATE_FR',
            endFieldName: 'RETURN_DATE_TO',
            margin: '0 0 0 -246',
            width: 350,
            startDate: new Date() ,
            endDate: new Date()
        },{
            xtype: 'uniTextfield',
            name: 'RETURN_NO',
            fieldLabel: '환급번호'
//            readOnly: true
        },{
            xtype: 'uniTextfield',
            name: 'ENTRY_MAN',
            margin: '0 0 0 -246',
            fieldLabel: '등록자'
        },{
            xtype: 'uniTextfield',
//            xtype: 'textareafield',
            name: 'REMARK',
            width: 500, //////
            fieldLabel: '비고'


        }]
    });

	//검색창 모델 정의
    Unilite.defineModel('orderNoMasterModel', { //모델정의 - 메인 조회버튼 팝업 그리드
        fields: [
        	     {name: 'DIV_CODE'               , text: '사업장'             , type: 'string'},
                 {name: 'RETURN_NO'              , text: '환급번호'            , type: 'string'},
        	     {name: 'RETURN_DATE'            , text: '(작성)일자'          , type: 'uniDate'},
                 {name: 'ENTRY_MAN'              , text: '등록자'             , type: 'string'},
                 {name: 'REMARK'                 , text: '비고'               , type: 'string'}
	     ]
    });
    //검색창 스토어 정의
    var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
            model: 'orderNoMasterModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결여부
                editable: false,            // 수정 모드 사용여부
                deletable:false,            // 삭제 가능 여부
                useNavi : false             // prev | newxt 버튼 사용여부
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 's_tix902ukrv_kdService.selectOrderNumMasterList'
                }
            }
            ,loadStoreRecords : function()  {
                var param= orderNoSearch.getValues();
                console.log( param );
                this.load({
                    params : param
                });
            }
    });
    //검색창 그리드 정의
    var orderNoMasterGrid = Unilite.createGrid('s_tix902ukrvOrderNoMasterGrid', {
        // title: '기본',
        layout : 'fit',
        store: orderNoMasterStore,
        uniOpt:{
            useRowNumberer: false
        },
        columns:  [{ dataIndex: 'DIV_CODE'                , width: 100 },
                   { dataIndex: 'RETURN_NO'               , width: 120 },
                   { dataIndex: 'RETURN_DATE'             , width: 100 },
                   { dataIndex: 'ENTRY_MAN'               , width: 150 },
                   { dataIndex: 'REMARK'                  , width: 110 },
                   { dataIndex: 'MONEY_UNIT'              , width: 110 , hidden: true},
                   { dataIndex: 'EXCHG_RATE_O'            , width: 110 , hidden: true}
          ] ,
          listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
                orderNoMasterGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                searchInfoWindow.hide();
              }
          }
          ,returnData: function(record) {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }

                panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
                panelResult.setValue('RETURN_NO', record.get('RETURN_NO'));
                panelResult.setValue('RETURN_DATE', record.get('RETURN_DATE'));
                panelResult.setValue('ENTRY_MAN', record.get('ENTRY_MAN'));
                panelResult.setValue('REMARK', record.get('REMARK'));

                panelSearch.setValue('DIV_CODE', record.get('DIV_CODE'));
                panelSearch.setValue('RETURN_NO', record.get('RETURN_NO'));
                panelSearch.setValue('RETURN_DATE', record.get('RETURN_DATE'));
                panelSearch.setValue('ENTRY_MAN', record.get('ENTRY_MAN'));
                panelSearch.setValue('REMARK', record.get('REMARK'));

          }

    });

    //openSearchInfoWindow
    //검색창 메인
    function openSearchInfoWindow() {       //메인조회(큰 돋보기) 창을 띄우는 함수
        if(!searchInfoWindow) {
            searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '환급번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch, orderNoMasterGrid],
                tbar:  ['->',
                        {   itemId : 'searchBtn',
                            text: '조회',
                            handler: function() {
                                orderNoMasterStore.loadStoreRecords();
                            },
                            disabled: false
                        }, {
                            itemId : 'closeBtn',
                            text: '닫기',
                            handler: function() {
                                searchInfoWindow.hide();
                            },
                            disabled: false
                        }
                ],
                listeners : {beforehide: function(me, eOpt) {
                                            orderNoSearch.clearForm();
                                            orderNoMasterGrid.reset();
                                        },
                             beforeclose: function( panel, eOpts )  {
                                            orderNoSearch.clearForm();
                                            orderNoMasterGrid.reset();
                                        },
                             show: function( panel, eOpts ) {
                                orderNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                                orderNoSearch.setValue('ENTRY_MAN',panelSearch.getValue('ENTRY_MAN'));
                                orderNoSearch.setValue('REMARK',panelSearch.getValue('REMARK'));
//                                orderNoSearch.setValue('RETURN_DATE_TO', UniDate.get('today'));
                                orderNoSearch.setValue('RETURN_DATE_TO', panelSearch.getValue('RETURN_DATE'));
                                orderNoSearch.setValue('RETURN_DATE_FR', UniDate.get('startOfMonth', orderNoSearch.getValue('RETURN_DATE_TO')));
                             }
                }
            })
        }
        searchInfoWindow.center();
        searchInfoWindow.show();
    }

	Unilite.Main( {
		border: false,
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
		id: 's_tix902ukrv_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('RETURN_NO', '');
			panelSearch.setValue('RETURN_DATE', UniDate.get('today'));
			panelSearch.setValue('ENTRY_MAN', '');
			panelSearch.setValue('REMARK', '');
			panelSearch.setValue('MONEY_UNIT', 'KRW');
            panelSearch.setValue('EXCHG_RATE_O', '1');
           // panelSearch.getField('MONEY_UNIT').setReadOnly(true);
            //panelSearch.getField('EXCHG_RATE_O').setReadOnly(true);
//			panelSearch.getField('MONEY_UNIT').setVisible(false);
//			panelSearch.getField('EXCHG_RATE_O').setVisible(false);
			//panelSearch.getField('RETURN_NO').setReadOnly(true);

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('RETURN_NO', '');
            panelResult.setValue('RETURN_DATE', UniDate.get('today'));
            panelResult.setValue('ENTRY_MAN', '');
            panelResult.setValue('REMARK', '');
            panelResult.setValue('MONEY_UNIT', 'KRW');
            panelResult.setValue('EXCHG_RATE_O', '1');
           // panelResult.getField('MONEY_UNIT').setReadOnly(true);
            //panelResult.getField('EXCHG_RATE_O').setReadOnly(true);
//            panelResult.getField('MONEY_UNIT').setVisible(false);
//            panelResult.getField('EXCHG_RATE_O').setVisible(false);
            //panelResult.getField('RETURN_NO').setReadOnly(true);

			UniAppManager.setToolbarButtons(['reset','newData'], true);
			UniAppManager.setToolbarButtons('save', false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() { //조회

			
			var reportNo = panelSearch.getValue('RETURN_NO');
            if(Ext.isEmpty(reportNo)) {
                openSearchInfoWindow()
            } else {
            	isLoad = true;
                var detailform = panelSearch.getForm();
                if (detailform.isValid()) {
                    masterGrid.getStore().loadStoreRecords(); //메인조회
                    panelSearch.getForm().getFields().each(function(field) {
                          //field.setReadOnly(true);
                    });
                    panelResult.getForm().getFields().each(function(field) {
                          //field.setReadOnly(true);
                    });
                    UniAppManager.setToolbarButtons('reset', true);
                } else {
                    var invalid = panelSearch.getForm().getFields()
                            .filterBy(function(field) {
                                return !field.validate();
                            });

                    if (invalid.length > 0) {
                        r = false;
                        var labelText = ''

                        if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                            var labelText = invalid.items[0]['fieldLabel']
                                    + '은(는)';
                        } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']
                                    + '은(는)';
                        }

                        Ext.Msg.alert('확인', labelText + Msg.sMB083);
                        invalid.items[0].focus();
                    }
                }
            }
		},
		onNewDataButtonDown : function() { //행추가
			if(!this.isValidSearchForm()){
				return false;
			}
			panelSearch.getForm().getFields().each(function(field) {
			     // field.setReadOnly(true);
			});
			panelResult.getForm().getFields().each(function(field) {
			     // field.setReadOnly(true);
			});

			//순서(순번)
			var seqNo = directMasterStore1.max('SEQ');
                    if(!seqNo) seqNo       = 1;
                    else seqNo            += 1;

			var record = {
				DIV_CODE : panelSearch.getValue('DIV_CODE'),
				SEQ : seqNo

			};
            masterGrid.createRow(record);

		},
		onSaveDataButtonDown : function() { //저장, 수정후 저장
			masterGrid.getStore().saveStore();
		},
		onDeleteDataButtonDown : function()	{ //행삭제
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown : function() { //초기화
			panelSearch.getForm().getFields().each(function(field) {
			      //field.setReadOnly(false);
			});
			panelResult.getForm().getFields().each(function(field) {
			      //field.setReadOnly(false);
			});
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			UniAppManager.setToolbarButtons('save', false);
			this.fnInitBinding();;
		},
		fnExchngRateO:function(isIni) {  // 화폐/환율
            var param = {
                "AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('RETURN_DATE')),
                "MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
            };
            salesCommonService.fnExchgRateO(param, function(provider, response) {
                if(!Ext.isEmpty(provider)){
                    if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != "KRW"){
                        alert('환율정보가 없습니다.');
                    }
                    panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
                    panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);

                }

            });
        }

	});

	 /**
     * Validation
     */
    Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            if(newValue == oldValue){
                return false;
            }
            var rv = true;
            if( fieldName == 'COMPANY_NUM' ) {// '사업자번호'
                 if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) )    {
                    if(Unilite.validate('bizno', newValue) != true) {
//                        if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))    {
//
//                            record.set(fieldName, '');
//                            rv = false;
//                        }

                        alert(Msg.sMB173);
                        record.set(fieldName, '');
                        return false;

                    }else {
                        newValue = newValue.replace(/-/g,'');
                        var v = newValue.substring(0,3)+ "-"+ newValue.substring(3,5)+"-" + newValue.substring(5,10);
                        if(type == 'grid') {
                            e.cancel=true;
                            record.set(fieldName, v);
                        }else {
                            editor.setValue(v);
                        }
                    }
                 }
            }

            return rv;
        }
    }); // validator
};


</script>
