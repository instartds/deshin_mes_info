<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt410skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt410skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="WB04" /> <!--차종-->
     <t:ExtComboStore comboType="AU" comboCode="BS90" /> <!--작업년도-->
</t:appConfig>

<script type="text/javascript">

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};

function appMain() {
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt410skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_ryt410skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE',             text: '법인코드',       type : 'string'},
            {name: 'DIV_CODE',              text: '사업장',        type : 'string', comboType : "BOR120"},
            {name: 'PROD_ITEM_CODE',        text: '품목코드',      type : 'string'},
            {name: 'PROD_ITEM_NAME',        text: '품목명',        type : 'string'},
            {name: 'PROD_ITEM_SPEC',        text: '규격',         type : 'string'},
            {name: 'OEM_ITEM_CODE',         text: '품번(OEM)',    type : 'string'},
            {name: 'CAR_TYPE',              text: '차종',         type : 'string', comboType : 'AU', comboCode : 'WB04'},
            {name: 'CHILD_ITEM_CODE',       text: '자재코드',      type : 'string'},
            {name: 'CHILD_ITEM_NAME',       text: '자재명',        type : 'string'},
            {name: 'CHILD_ITEM_SPEC',       text: '규격',         type : 'string'},
            {name: 'KG_PRICE',              text: 'KG당단가',      type: 'uniUnitPrice'},
            {name: 'KG_REQ_QTY',            text: 'KG당소요량'					 , type: 'float', decimalPrecision:3 ,format:'0,000.000'},
            {name: 'UNIT_REQ_QTY',          text: '단위소요량'					 , type: 'float', decimalPrecision:6 ,format:'0,000.000000'},
            {name: 'AMT',                   text: '금액'										 , type: 'float', decimalPrecision:6 ,format:'0,000.000000'},
            {name: 'CUSTOM_CODE',           text: '거래처코드',     type : 'string'}
        ]
    }); 
    
    var directMasterStore = Unilite.createStore('s_ryt410skrv_kdMasterStore',{
        model: 's_ryt410skrv_kdModel',
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
                  params : param
            });         
        },
        listeners: {
            load:function( store, records, successful, operation, eOpts ) {

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
            },
            {
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
				},
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
            }), {
                fieldLabel: '차종',
                name: 'CAR_TYPE',
                xtype: 'uniCombobox', 
                colspan: 2,
                comboType: 'AU',
                comboCode: 'WB04'
            },
                    Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '품목코드',
                        valueFieldName: 'FR_ITEM_CODE', 
                        textFieldName: 'FR_ITEM_NAME', 
                        textFieldWidth: 170, 
                        validateBlank: false, 
                        popupWidth: 710,
                        listeners : {
                            applyextparam: function(popup){
                                popup.setExtParam({
                                    'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                    'ADD_QUERY1': "ITEM_CODE IN ((SELECT  A.ITEM_CODE" +
                                                  "               FROM               S_RYT210T_KD AS A WITH (NOLOCK) " +
                                                  "                       INNER JOIN S_RYT200T_KD AS B WITH (NOLOCK) ON B.COMP_CODE   = A.COMP_CODE" +
                                                  "                                                                 AND B.DIV_CODE    = A.DIV_CODE" +
                                                  "                                                                 AND B.CUSTOM_CODE = A.CUSTOM_CODE" +
                                                  "                                                                 AND B.CON_FR_YYMM = A.CON_FR_YYMM" +
                                                  "                                                                 AND B.CON_TO_YYMM = A.CON_TO_YYMM" +
                                                  "                                                                 AND B.GUBUN1      = A.GUBUN1" +
                                                  "               WHERE   A.COMP_CODE = ",
                                    'ADD_QUERY2': "               AND     A.DIV_CODE  = ",
                                    'ADD_QUERY3': "               AND     A.GUBUN1    = 'R'" +
                                                  "               AND     B.GUBUN3    = 'Y'))"
                                });   //WHERE절 추가 쿼리
                            }
                        }
                    }),
                    Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '~', 
                        valueFieldName: 'TO_ITEM_CODE', 
                        textFieldName: 'TO_ITEM_NAME', 
                        textFieldWidth: 170, 
                        validateBlank: false, 
                        popupWidth: 710,
                        listeners : {
                            applyextparam: function(popup){
                                popup.setExtParam({
                                    'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                    'ADD_QUERY1': "ITEM_CODE IN ((SELECT  A.ITEM_CODE" +
                                                  "               FROM               S_RYT210T_KD AS A WITH (NOLOCK) " +
                                                  "                       INNER JOIN S_RYT200T_KD AS B WITH (NOLOCK) ON B.COMP_CODE   = A.COMP_CODE" +
                                                  "                                                                 AND B.DIV_CODE    = A.DIV_CODE" +
                                                  "                                                                 AND B.CUSTOM_CODE = A.CUSTOM_CODE" +
                                                  "                                                                 AND B.CON_FR_YYMM = A.CON_FR_YYMM" +
                                                  "                                                                 AND B.CON_TO_YYMM = A.CON_TO_YYMM" +
                                                  "                                                                 AND B.GUBUN1      = A.GUBUN1" +
                                                  "               WHERE   A.COMP_CODE = ",
                                    'ADD_QUERY2': "               AND     A.DIV_CODE  = ",
                                    'ADD_QUERY3': "               AND     A.GUBUN1    = 'R'" +
                                                  "               AND     B.GUBUN3    = 'Y'))"
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
    var masterGrid = Unilite.createGrid('s_ryt410skrv_kdmasterGrid', { 
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
        tbar: [{
                xtype : 'button',
                id: 'printBtn',
                text:'출력',
                handler: function() {
                    if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    UniAppManager.app.requestApprove();
                }
            }
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',       width : 120, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 130, hidden : true},
            {dataIndex : 'PROD_ITEM_CODE',  width : 120},
            {dataIndex : 'PROD_ITEM_NAME',  width : 180},
            {dataIndex : 'PROD_ITEM_SPEC',  width : 180},
            {dataIndex : 'OEM_ITEM_CODE',   width : 120},
            {dataIndex : 'CAR_TYPE',        width : 120, align : 'center'},
            {dataIndex : 'CHILD_ITEM_CODE', width : 120},
            {dataIndex : 'CHILD_ITEM_NAME', width : 180},
            {dataIndex : 'CHILD_ITEM_SPEC', width : 180},
            {dataIndex : 'KG_PRICE',        width : 100},
            {dataIndex : 'KG_REQ_QTY',      width : 100},
            {dataIndex : 'UNIT_REQ_QTY',    width : 100},
            {dataIndex : 'AMT',             width : 130},
            {dataIndex : 'CUSTOM_CODE',     width : 180, hidden : true}
        ],             
        listeners: {

        }
    });
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }],
        id  : 's_ryt410skrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        requestApprove: function(){     //결재 요청
            if(!panelResult.setAllFieldsReadOnly(true)){
                return false;
            }
            
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var customCode  = panelResult.getValue('CUSTOM_CODE');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_RYT410RKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + customCode + "'";
            var spCall      = encodeURIComponent(spText);
            
//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ryt410rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_ryt410skrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE',    UserInfo.divCode);
            panelResult.setValue('WORK_YEAR',    new Date().getFullYear());
            panelResult.setValue('WORK_SEQ',    '1');            
        }
    });
};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>