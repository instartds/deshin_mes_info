<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt500skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt500skrv_kd"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WR01" />                 <!--비율단가구분-->
    <t:ExtComboStore comboType="AU" comboCode="B010" />                 <!--사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="B004" />                 <!--화폐단위-->
        <t:ExtComboStore comboType="AU" comboCode="BS90" /> <!--작업년도-->
</t:appConfig>

<script type="text/javascript">

var SearchInfoWindow;   //조회버튼 누르면 나오는 조회창

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};

function appMain() {

	  //var groupUrl = "http://58.151.163.201:8070/approval/apprDraft.hi?actType=&mode=draft&submode=draft"; //그룹웨어 호출 url
	 var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	  var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt500skrv_kdService.selectList'
        }
    });

    Unilite.defineModel('s_ryt500skrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',             text : '법인코드',       type : 'string'},
            {name : 'DIV_CODE',              text : '사업장',         type : 'string', comboType : "BOR120"},
            {name: 'WORK_YEAR'                  ,text:'작업년도'                   ,type: 'string' , hidden:true},
            {name: 'WORK_SEQ'                  ,text:'반기'                   ,type: 'string' , hidden:true},
            {name : 'CUSTOM_CODE',           text : '거래처코드',      type : 'string'},
            {name : 'GUBUN1',                text : '비율/단가',      type : 'string', comboType:'AU', comboCode:'WR01'},
            {name : 'GUBUN3',                text : 'BOM적용',       type : 'string', comboType:'AU', comboCode:'B010'},
            {name : 'SUBJECT',               text : '과목',          type : 'string'},
//             {name : 'MONEY_UNIT',            text : '단위',          type : 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name : 'MONEY_UNIT',            text : '단위',          type : 'string'},
            {name : 'AMT_QTY',               text : '금액/수량',      type : 'float', format: '0,000,000.000000'},
            {name : 'RATE_N',                text : 'Royalty%',     type : 'uniPercent'},
            {name: 'GW_DOC'             , text: 'GW문서'                , type: 'string'},
            {name: 'GW_FLAG'            , text: 'GW상태'                 , type: 'string', comboType:'AU', comboCode:'WB17'},
            {name: 'DRAFT_NO'           , text: 'DRAFT_NO'              , type: 'string'}
        ]
    });

    Unilite.defineModel('closePopupModel', {          // 검색팝업창(MASTER)
        fields: [
            {name : 'COMP_CODE',         text :'법인코드',       type : 'string'},
            {name : 'DIV_CODE',          text :'사업자코드',      type : 'string'},
            {name: 'WORK_YEAR'                  ,text:'작업년도'                   ,type: 'string' , hidden:true},
            {name: 'WORK_SEQ'                  ,text:'반기'                   ,type: 'string' , hidden:true},
            {name : 'CUSTOM_CODE',       text :'거래처코드',      type : 'string'},
            {name : 'CUSTOM_NAME',       text :'거래처명',       type : 'string'},
            {name : 'CON_FR_YYMM',       text :'정산시작년월',    type : 'string'},
            {name : 'CON_TO_YYMM',       text :'정산종료년월',    type : 'string'},
            {name : 'GUBUN1',            text :'비율/단가',      type : 'string', comboType:'AU', comboCode:'WR01'},
            {name : 'MONEY_UNIT',        text :'화폐',          type : 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name : 'EXCHG_RATE_O',      text :'환율',          type : 'uniER'},
            {name : 'CAL_DATE',          text :'정산일자',       type : 'string'},
            {name : 'AMT_SELL',          text :'매출액',        type : 'uniUnitPrice'},
            {name : 'AMT_DEDUCT',        text :'차감총액',       type : 'uniUnitPrice'},
            {name : 'AMT_NET_SELL',      text :'순매가',         type : 'uniUnitPrice'},
            {name : 'AMT_ROYALTY_FOR',   text :'로열티',         type : 'uniUnitPrice'},
            {name : 'AMT_ROYALTY',       text :'로열티(자사)',    type : 'uniUnitPrice'},
            {name : 'GUBUN3',            text :'BOM적용',       type : 'string'}
        ]
    });

    var directMasterStore = Unilite.createStore('s_ryt500skrv_kdMasterStore',{
        model: 's_ryt500skrv_kdModel',
        uniOpt : {
            isMaster: true,          // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false          // prev | newxt 버튼 사용
        },
        expanded : false,
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param,
                  // NEW ADD
  				callback: function(records, operation, success){
  					console.log(records);
  					if(success){
  						if(masterGrid.getStore().getCount() == 0){
  							Ext.getCmp('GW').setDisabled(true);
  						}else if(masterGrid.getStore().getCount() != 0){
  							UniBase.fnGwBtnControl('GW',directMasterStore.data.items[0].data.GW_FLAG);
  						}
  					}
  				}
  				//END
            });
        },
            listeners: {
	          	load: function(store, records, successful, eOpts) {
	          		if(! Ext.isEmpty(records[0])){
	          			panelResult2.setValue('TXT_GW_FLAG',records[0].get('GW_FLAG'));
						panelResult2.setValue('TXT_GW_DOC',records[0].get('GW_DOC'));
						panelResult2.setValue('TXT_DRAFT_NO',records[0].get('DRAFT_NO'));
	          		}

				}
          	}
    });

    //panelResult(검색조건)
    var panelResult = Unilite.createSearchForm('resultForm', {
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },{
				fieldLabel: '작업년도',
				name: 'WORK_YEAR',
				xtype: 'uniCombobox',
				comboType : 'AU',
			    comboCode : 'BS90',
				value: new Date().getFullYear(),
				allowBlank: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				allowBlank: false
				}
			/* ,
                {
                fieldLabel: '작업년월',
                xtype: 'uniMonthRangefield',
                startFieldName: 'FROM_MONTH',
                endFieldName: 'TO_MONTH',
                allowBlank: false
            } */
                ,
                Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                allowBlank:false,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({
                            'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                            'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                            'ADD_QUERY2': " AND DIV_CODE = ",
                            'ADD_QUERY3': "))"
                        });   //WHERE절 추가 쿼리
                    }
                }
            }) /*, {
                fieldLabel: '비율/단가',
                name: 'GUBUN1',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'WR01',
                allowBlank:false
            }
            ,{
                xtype: 'radiogroup',
                fieldLabel: 'BOM적용',
                itemId:'GUBUN3',
                width:230,
                items: [{
                    boxLabel:'적용',
                    name:'GUBUN3',
                    inputValue: 'Y',
                    checked: true
                },{
                    boxLabel:'미적용',
                    name:'GUBUN3',
                    inputValue: 'N'
                }]
            }
            */
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

    var panelResult2 = Unilite.createSearchForm('detailForm', { //createForm
        disabled: false,
        border:true,
        padding: '1',
        region: 'north',
        autoScroll: true,
        layout: {
            type: 'uniTable',
            columns :1

        },
		masterGrid: masterGrid,
        items: [
					{
	                   xtype:'container',
	                   layout: {
	       	            type: 'uniTable',
	       	            columns : 3
       	       		 },
                   items:[
						{		fieldLabel:'기안',
								labelWidth: 90,
								name:'TXT_GW_FLAG',
								xtype: 'uniTextfield',
								readOnly: true,
								hidden: false
							},{
								fieldLabel:'기안문서번호',
								labelWidth: 100,
								name:'TXT_GW_DOC',
								xtype: 'uniTextfield',
								readOnly: true,
								hidden: false
							},{
								fieldLabel:'기안번호',
								name:'TXT_DRAFT_NO',
								xtype: 'uniTextfield',
								readOnly: true,
								hidden: false
							}
                          ]
                   }
			]
    });


    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_ryt500skrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [
            {dataIndex : 'COMP_CODE',       width : 120, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 130, hidden : true},
            {dataIndex : 'WORK_YEAR',     width : 100, hidden : true},
            {dataIndex : 'WORK_SEQ',     width : 70, hidden : true},
            {dataIndex : 'CUSTOM_CODE',     width : 120, hidden : true},
            {dataIndex : 'CUSTOM_NAME',     width : 180, hidden : true},
            {dataIndex : 'GUBUN1',          width : 80, hidden : true},
            {dataIndex : 'GUBUN3',          width : 80, hidden : true},
            {dataIndex : 'SUBJECT',         width : 130},
            {dataIndex : 'MONEY_UNIT',      width : 110, align: 'center'},
            {dataIndex : 'AMT_QTY',         width : 160},
            {dataIndex : 'RATE_N',          width : 110, hidden : true},
            {dataIndex: 'GW_DOC'          , width: 150, hidden : true},
            {dataIndex: 'GW_FLAG'         , width: 150, hidden : true},
            {dataIndex: 'DRAFT_NO'        , width: 150, hidden : true}
        ],
        listeners: {

		},
        tbar: [/* {
            id: 'GW_DRAFT',
            text: 'GW기안',
            handler: function() {
                alert('GW기안');
            }
        } */
        {
            itemId : 'GWBtn',
            id:'GW',
            iconCls : 'icon-referance'  ,
            text:'기안',
            handler: function() {
            	var param = panelResult.getValues();
            	param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('WORK_YEAR') + panelResult.getValue('WORK_SEQ') + panelResult.getValue('CUSTOM_CODE');
            	if(confirm('기안 하시겠습니까?')) {
            		s_ryt500skrv_kdService.selectGwData(param, function(provider, response) {
            			if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
            				s_ryt500skrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                UniAppManager.app.requestApprove();
                            });
                        } else {
                            alert('이미 기안된 자료입니다.');
                            return false;
                        }
                    });
            	}
            	UniAppManager.app.onQueryButtonDown();
            }
        }
        ],
        listeners: {

        }
    });

    var closePopupStore = Unilite.createStore('closePopupStore', {    //조회버튼 누르면 나오는 조회창
        model: 'closePopupModel',
        autoLoad: false,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_ryt500skrv_kdService.selectList2'
            }
        }
        ,loadStoreRecords : function()  {
            var param= closePopupSearch.getValues();
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var closePopupSearch = Unilite.createSearchForm('closePopupSearchForm', {     //조회버튼 누르면 나오는 조회창
        layout: {type: 'uniTable', columns : 4},
        trackResetOnLoad: true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                value: UserInfo.divCode
            }/*
            ,
            {
                fieldLabel: '작업년월',
                xtype: 'uniMonthRangefield',
                startFieldName: 'FROM_MONTH',
                endFieldName: 'TO_MONTH',
                allowBlank: false
            } */
            ,{
            	fieldLabel: '작업년도',
				name: 'WORK_YEAR',
				xtype: 'uniCombobox',
				comboType : 'AU',
			    comboCode : 'BS90',
				value: new Date().getFullYear(),
				allowBlank: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				holdable: 'hold',
				allowBlank: false
				},
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처',
                    allowBlank: false,
                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({
                                'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                                'ADD_QUERY2': " AND DIV_CODE = ",
                                'ADD_QUERY3': "))"
                            });   //WHERE절 추가 쿼리
                        }
                    }
            })
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
        }
    }); // createSearchForm

    var closePopupGrid = Unilite.createGrid('closePopupGrid', {     //조회버튼 누르면 나오는 조회창
        layout : 'fit',
        excelTitle: '기술마스터팝업',
        store: closePopupStore,
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false
        },
        columns:  [
            {dataIndex : 'COMP_CODE',       width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 100, hidden : true},
            {dataIndex : 'WORK_YEAR',     width : 100, hidden : true},
            {dataIndex : 'WORK_SEQ',     width : 70, hidden : true},
            {dataIndex : 'CUSTOM_CODE',     width : 100},
            {dataIndex : 'CUSTOM_NAME',     width : 160},
            {dataIndex : 'CON_FR_YYMM',     width : 100, align : 'center'},
            {dataIndex : 'CON_TO_YYMM',     width : 100, align : 'center'},
            {dataIndex : 'GUBUN1',          width : 90},
            {dataIndex : 'MONEY_UNIT',      width : 90},
            {dataIndex : 'EXCHG_RATE_O',    width : 80},
            {dataIndex : 'CAL_DATE',        width : 100, align : 'center'},
            {dataIndex : 'AMT_SELL',        width : 140},
            {dataIndex : 'AMT_DEDUCT',      width : 140},
            {dataIndex : 'AMT_NET_SELL',    width : 140},
            {dataIndex : 'AMT_ROYALTY',     width : 140},
            {dataIndex : 'AMT_ROYALTY_FOR', width : 140},
            {dataIndex : 'GUBUN3',          width : 120, hidden : true}
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                closePopupGrid.returnData(record);
//                UniAppManager.app.onQueryButtonDown();
                SearchInfoWindow.hide();
//                panelResult.setAllFieldsReadOnly(true);
            }
        },
        returnData: function(record)    {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({
                'DIV_CODE'          : record.get('DIV_CODE'),
                'CUSTOM_CODE'       : record.get('CUSTOM_CODE'),
                'CUSTOM_NAME'       : record.get('CUSTOM_NAME'),
                'GUBUN1'            : record.get('GUBUN1'),
                'GUBUN3'            : record.get('GUBUN3')
            });
        }
    });

    function openSearchInfoWindow() {           //조회버튼 누르면 나오는 조회창
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '마감팝업',
                width: 1000,
                height: 500,
                layout: {type:'vbox', align:'stretch'}, //위치 확인 필요
                items: [closePopupSearch, closePopupGrid],
                tbar:  ['->',
                    {
                        itemId : 'saveBtn',
                        text: '조회',
                        handler: function() {
                            if(closePopupSearch.setAllFieldsReadOnly(true) == false){
                                return false;
                            }
                            closePopupStore.loadStoreRecords();
                        },
                        disabled: false
                    }, {
                        itemId : 'inoutNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchInfoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        closePopupSearch.clearForm();
                        closePopupGrid.reset();
                    },
                     beforeclose: function( panel, eOpts )  {
                        closePopupSearch.clearForm();
                        closePopupGrid.reset();
                    },
                    show: function( panel, eOpts )  {
                        closePopupSearch.setValue('DIV_CODE'    , panelResult.getValue('DIV_CODE'));
                        closePopupSearch.setValue('WORK_YEAR'   , panelResult.getValue('WORK_YEAR'));
                        closePopupSearch.setValue('WORK_SEQ'  , panelResult.getValue('WORK_SEQ'));
                        //closePopupSearch.setValue('FROM_MONTH'  , panelResult.getValue('FROM_MONTH'));
                        //closePopupSearch.setValue('TO_MONTH'    , panelResult.getValue('TO_MONTH'));
                     }
                }
            })
        }
        SearchInfoWindow.center();
        SearchInfoWindow.show();
    };

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult,panelResult2
            ]
        }],
        id  : 's_ryt500skrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm();
            directMasterStore.clearData();
            UniAppManager.setToolbarButtons(['save'], false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            var customCode = panelResult.getValue('CUSTOM_CODE');
            if(Ext.isEmpty(customCode)) {
                openSearchInfoWindow()
            } else {
                if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                directMasterStore.loadStoreRecords();
            }
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['save'], false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            Ext.getCmp('GW').setDisabled(true);
            masterGrid.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
        	//Ext.getCmp('GW').setDisabled(true);
            panelResult.setValue('DIV_CODE',    UserInfo.divCode);
           // panelResult.setValue('FROM_MONTH',  Ext.Date.format(new Date(), 'Y') + "01");
           // panelResult.setValue('TO_MONTH',    Ext.Date.format(new Date(), 'Y') + "12");
            panelResult.setValue('WORK_SEQ','1');
            panelResult.setValue('WORK_YEAR', UniDate.get('startOfYear').substring(0,4));
        },
        requestApprove: function(){     //결재 요청

        	var winWidth=1300;
            var winHeight=750;

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var customCode	= panelResult.getValue('CUSTOM_CODE');
            var workYear	= panelResult.getValue('WORK_YEAR');
            var workSeq	= panelResult.getValue('WORK_SEQ');
            var fromMonth	= '';
            var toMonth	= '';
			if(panelResult.getValue('WORK_SEQ') == '1'){
				fromMonth = panelResult.getValue('WORK_YEAR') + "0101";
				toMonth = panelResult.getValue('WORK_YEAR') + "0630";
            }else if(panelResult.getValue('WORK_SEQ') == '2'){
            	fromMonth = panelResult.getValue('WORK_YEAR') + "0701";
				toMonth = panelResult.getValue('WORK_YEAR') + "1231";
            }
            var guBun1 = panelResult.getValue('GUBUN1');
            var guBun3 = panelResult.getValue('GUBUN3');
            if (guBun3 == true){
            	guBun3 = 'Y';
            }else{
            	guBun3 = 'N';
            }
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_RYT500SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + customCode + "'"+ ', '+ "'" + workYear + "'"+ ', '+ "'" + workSeq  + "'";
            var spCall      = encodeURIComponent(spText);

			 var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ryt500skrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('WORK_YEAR') + panelResult.getValue('WORK_SEQ') + panelResult.getValue('CUSTOM_CODE') + "&sp=" + spCall + "&viewMode=docuDraft&recv_yn="/* + Base64.encode()*/;
			 console.log("[gwurl]" + gwurl);
			 console.log("[spText]" + spCall);
			UniBase.fnGw_Call(gwurl,frm,'GW');
        }
    });
};

</script>
<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>