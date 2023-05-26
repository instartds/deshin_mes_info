<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_pda030rkrv_kd"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_pda030rkrv_kd"  /> 			<!-- 사업장   -->
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />               <!-- 창고     -->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />               <!-- 작업장   -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />                         <!-- 차종     -->
    <t:ExtComboStore comboType="AU" comboCode="WB08" />                         <!-- 금형구분 -->
    <t:ExtComboStore comboType="AU" comboCode="WB10" />                         <!-- 위치상태 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" />                         <!-- 품목계정 -->
</t:appConfig>

<script type="text/javascript" >
var settingWindow;
var checkedCount = 0;   // 체크된 레코드

function appMain() {/**
     *   LocationModel 정의
     * @type
     */
    Unilite.defineModel('s_pda030rkrv_kdModel1', {
        fields: [
            {name: 'PRINT_YN'           ,text: '출력'                  ,type: 'boolean'},
            {name: 'WORK_SHOP_CODE'     ,text: '작업장'               ,type: 'string'},
            {name: 'WORK_SHOP_NAME'     ,text: '작업장명'             ,type: 'string'},
            {name: 'PRODT_DATE'         ,text: '생산일'               ,type: 'uniDate'},
            {name: 'ITEM_CODE'          ,text: '품목코드'             ,type: 'string'},
            {name: 'ITEM_NAME'          ,text: '품목명'               ,type: 'string'},
            {name: 'SPEC'               ,text: '규격'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'      ,text: '품번'                 ,type: 'string'},
            {name: 'LOT_NO'             ,text: 'LOT번호'              ,type: 'string'},
            {name: 'STOCK_UNIT'         ,text: '재고단위'             ,type: 'string'},
            {name: 'QTY'                ,text: '수량'                 ,type: 'float', allowBlank: false, maxLength: 17, decimalPrecision: 4, format: '0,000,000.0000'},
            {name: 'PRINT_CNT'          ,text: '출력수'               ,type: 'uniQty', allowBlank: false, defaultValue: 1},
            {name: 'PRODT_NUM'          ,text: '생산실적번호'         ,type: 'string'},
            {name: 'WKORD_NUM'          ,text: '작업지시번호'         ,type: 'string'},
            {name: 'DIV_CODE'           ,text: '사업장'               ,type: 'string'}
        ]
    });

    /**
     *   금형Model 정의
     * @type
     */
    Unilite.defineModel('s_pda030rkrv_kdModel2', {
        fields: [
            {name: 'PRINT_YN'           ,text: '출력'                  ,type: 'boolean'},
            {name: 'WORK_SHOP_CODE'     ,text: '작업장'               ,type: 'string'},
            {name: 'WORK_SHOP_NAME'     ,text: '작업장명'             ,type: 'string'},
            {name: 'INSPEC_DATE'        ,text: '검사일'               ,type: 'uniDate'},
            {name: 'ITEM_CODE'          ,text: '품목코드'             ,type: 'string'},
            {name: 'ITEM_NAME'          ,text: '품목명'               ,type: 'string'},
            {name: 'SPEC'               ,text: '규격'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'      ,text: '품번'                 ,type: 'string'},
            {name: 'LOT_NO'             ,text: 'LOT번호'              ,type: 'string'},
            {name: 'STOCK_UNIT'         ,text: '재고단위'             ,type: 'string'},
            {name: 'QTY'                ,text: '수량'                 ,type: 'float', allowBlank: false, maxLength: 17, decimalPrecision: 4, format: '0,000,000.0000'},
            {name: 'PRINT_CNT'          ,text: '출력수'               ,type: 'uniQty', allowBlank: false, defaultValue: 1},
            {name: 'INSPEC_NUM'         ,text: '검사번호'             ,type: 'string'},
            {name: 'INSPEC_SEQ'         ,text: '검사순번'             ,type: 'int'},
            {name: 'PRODT_NUM'          ,text: '생산실적번호'         ,type: 'string'},
            {name: 'WKORD_NUM'          ,text: '작업지시번호'         ,type: 'string'},
            {name: 'DIV_CODE'           ,text: '사업장'               ,type: 'string'}
        ]
    });

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_pda030rkrv_kdMasterStore1',{
            model: 's_pda030rkrv_kdModel1',
            autoLoad: false,
            uniOpt : {
                isMaster: false,         // 상위 버튼 연결
                editable: true,        // 수정 모드 사용
                deletable:false,        // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read: 's_pda030rkrv_kdService.selectList1'
                }
            },
            loadStoreRecords : function()  {
                var param= Ext.getCmp('resultForm1').getValues();
                param.TAB_FLAG = '1';
                console.log( param );
                this.load({
                    params : param
                });

            }
    });

    var directMasterStore2 = Unilite.createStore('s_pda030rkrv_kdMasterStore2',{
            model: 's_pda030rkrv_kdModel2',
            autoLoad: false,
            uniOpt : {
                isMaster: false,         // 상위 버튼 연결
                editable: true,        // 수정 모드 사용
                deletable:false,        // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read: 's_pda030rkrv_kdService.selectList1'
                }
            },
            loadStoreRecords : function()  {
                var param= Ext.getCmp('resultForm2').getValues();
                param.TAB_FLAG = '2';
                console.log( param );
                this.load({
                    params : param
                });

            }
    });

    function openSettingWindow() {
        if(!settingWindow) {
            settingWindow = Ext.create('widget.uniDetailWindow', {
                title: '바코드 출력전 보안 설정',
                resizable:false,
                width: 1200,
                height:1000,
                autoScroll: true,
                layout: {type:'uniTable', columns: 1},
                items: [{
                    xtype: 'image',
                    src:CPATH+'/resources/images/barcodeSetting1.png',
                    overflow:'auto'
                }, {
                    xtype: 'image',
                    src:CPATH+'/resources/images/barcodeSetting2.png',
                    overflow:'auto'
                }],
                tbar:  ['->',{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            settingWindow.hide();
                        },
                        disabled: false
                    }
                ]
            })
        }
        settingWindow.show();
    }

    var describedPanel1 = Unilite.createSearchForm('s_pda030rkrv_kdDescribedPanel1',{
        region: 'east',
        padding: '1 1 1 1',
        layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
        defaults:{labelWidth: 100, margin:'5 0 0 20', width: 1200},
        border:true,
        items: [{
            xtype:'container',
            html: '<b>◆ 확인사항</b>',
            style: {
                color: 'blue'
            }},{
                xtype:'container',
                margin: '10 0 10 20',
                html: '&nbsp;&nbsp;&nbsp;<b>바코드 라벨출력을 위해서는 다음과 같은 설정을 해야 합니다.</b>'
            },{
                xtype:'container',
                layout: {type: 'uniTable', columns: 2},
                items:[{
                    xtype:'container',
                    html: '&nbsp;&nbsp;&nbsp;1. Internet Explorer 보안설정 하기.'
                },{
                    margin: '0 0 0 6',
                    xtype: 'button',
                    width: 90,
                    text: '보안설정 방법',
                    handler : function() {
                        openSettingWindow();
                    }
                }]
            },{
                xtype:'container',
                layout: {type: 'uniTable', columns: 2},
                items:[{
                    xtype:'container',
                    html: '&nbsp;&nbsp;&nbsp;2.&nbsp;라벨출력프로그램을 제품형인경우 C:&nbsp;/&nbsp;OmegaPlusPDA&nbsp;/&nbsp;itemLotLabel1 폴더를 생성후, 해당폴더에 압축을 푼다.'
                }/*,{
                    margin: '0 0 0 6',
                    xtype: 'button',
                    text: '출력 프로그램 다운로드',
                    handler : function() {

                    }
                }*/]
            },{
                xtype:'container',
                margin: '10 0 0 20',
                html: '&nbsp;&nbsp;&nbsp;3.&nbsp;위 사항이 준비되었으면 [바코드 출력] 버튼을 클릭하여 출력한다.'
            }]
    });

    var describedPanel2 = Unilite.createSearchForm('s_pda030rkrv_kdDescribedPanel2',{
        region: 'east',
        padding: '1 1 1 1',
        layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
        defaults:{labelWidth: 100, margin:'5 0 0 20', width: 1200},
        border:true,
        items: [{
            xtype:'container',
            html: '<b>◆ 확인사항</b>',
            style: {
                color: 'blue'
            }},{
                xtype:'container',
                margin: '10 0 10 20',
                html: '&nbsp;&nbsp;&nbsp;<b>바코드 라벨출력을 위해서는 다음과 같은 설정을 해야 합니다.</b>'
            },{
                xtype:'container',
                layout: {type: 'uniTable', columns: 2},
                items:[{
                    xtype:'container',
                    html: '&nbsp;&nbsp;&nbsp;1. Internet Explorer 보안설정 하기.'
                },{
                    margin: '0 0 0 6',
                    xtype: 'button',
                    width: 90,
                    text: '보안설정 방법',
                    handler : function() {
                        openSettingWindow();
                    }
                }]
            },{
                xtype:'container',
                layout: {type: 'uniTable', columns: 2},
                items:[{
                    xtype:'container',
                    html: '&nbsp;&nbsp;&nbsp;2.&nbsp;라벨출력프로그램을 제품형인경우 C:&nbsp;/&nbsp;OmegaPlusPDA&nbsp;/&nbsp;itemLotLabel1 폴더를 생성후, 해당폴더에 압축을 푼다.'
                }/*,{
                    margin: '0 0 0 6',
                    xtype: 'button',
                    text: '출력 프로그램 다운로드',
                    handler : function() {

                    }
                }*/]
            },{
                xtype:'container',
                margin: '10 0 0 20',
                html: '&nbsp;&nbsp;&nbsp;3.&nbsp;위 사항이 준비되었으면 [바코드 출력] 버튼을 클릭하여 출력한다.'
            }]
    });

    var panelPrint1 = Unilite.createForm('printForm1', {
        url: CPATH+'/z_kd/prdtPrintBarcode1',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 195',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,
        items:[{
            xtype: 'uniTextfield',
            name: 'data',
            hidden: true
        },{
            xtype: 'button',
            id: 'printBtn1',
            width: 90,
            text: '바코드 출력',
            handler : function() {
                if(directMasterStore1.getCount() == 0) return false;
                var inValidRecs = directMasterStore1.getInvalidRecords();
                if(inValidRecs.length == 0){
                    var form = this.up('uniDetailForm');
                    var data = new Array();
                    var data1 = "";
                    Ext.each(directMasterStore1.data.items, function(record, index){
                        data.push({
                            'PRINT_YN'       : record.get('PRINT_YN'),
                            'STATUS'         : record.get('STATUS'),
                            'ITEM_CODE'      : record.get('ITEM_CODE'),
                            'ITEM_NAME'      : record.get('ITEM_NAME'),
                            'LOT_NO'         : record.get('LOT_NO'),
                            'SPEC'           : record.get('SPEC'),
                            'OEM_ITEM_CODE'  : record.get('OEM_ITEM_CODE'),
                            'STOCK_UNIT'     : record.get('STOCK_UNIT'),
                            'QTY'            : record.get('QTY').toFixed(4),
                            'PRINT_CNT'      : record.get('PRINT_CNT')
                        })

                        if (record.get('PRINT_YN') == true){

                        	data1 = data1 + record.get('ITEM_CODE') + "|" + record.get('LOT_NO') + "|" + record.get('ITEM_NAME') + "|"
                        						+ record.get('SPEC') + "|" +  record.get('OEM_ITEM_CODE') + "|" +  String(record.get('QTY').toFixed(4)) + "|"
                        						+ record.get('STOCK_UNIT') + "|" +  record.get('PRINT_CNT') + "\r\n";
                        }

                    });
                    //var jJsonData = JSON.stringify(data);

                    //form.setValue('data',Ext.encode(data)); // Ext.encode(jJsonData));

                    //form.submit();

                     writeFile("itemLotLabel1.txt", data1)

                    setTimeout(function(){
                            directMasterStore1.commitChanges();

                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel1\\Label.exe", 1);
                            } catch(e) {
                                alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                            }

                       /*      Ext.Msg.show({
                                title:'바코드 출력',
                                message: '파일 다운로드가 완료되면 확인버튼을 클릭하세요',
                                buttons: Ext.Msg.OKCANCEL,
                                icon: Ext.Msg.QUESTION,
                                fn: function(btn) {
                                    if (btn === 'ok') {
                                        try{
                                            var WshShell = new ActiveXObject("WScript.Shell");
                                            WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel1\\Label.exe", 1);
                                        } catch(e) {
                                            alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                                        }
                                    } else if (btn === 'cancel') {
                                        alert('바코드 출력이 취소되었습니다.');
                                    } else {
                                        console.log('Cancel pressed');
                                    }
                                }
                            }); */
                        }
                        , 2000
                    )
                }else{
                    masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });

    var panelPrint2 = Unilite.createForm('printForm2', {
        url: CPATH+'/z_kd/prdtPrintBarcode2',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 195',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,
        items:[{
            xtype: 'uniTextfield',
            name: 'data',
            hidden: true
        },{
            xtype: 'button',
            id: 'printBtn2',
            width: 90,
            text: '바코드 출력',
            handler : function() {
                if(directMasterStore1.getCount() == 0) return false;
                var inValidRecs = directMasterStore1.getInvalidRecords();
                if(inValidRecs.length == 0){
                    var form = this.up('uniDetailForm');
                    var data = new Array();
                    var data1 = "";

                    Ext.each(directMasterStore1.data.items, function(record, index){
                        data.push({
                            'PRINT_YN'       : record.get('PRINT_YN'),
                            'STATUS'         : record.get('STATUS'),
                            'ITEM_CODE'      : record.get('ITEM_CODE'),
                            'ITEM_NAME'      : record.get('ITEM_NAME'),
                            'LOT_NO'         : record.get('LOT_NO'),
                            'SPEC'           : record.get('SPEC'),
                            'OEM_ITEM_CODE'  : record.get('OEM_ITEM_CODE'),
                            'STOCK_UNIT'     : record.get('STOCK_UNIT'),
                            'QTY'            : record.get('QTY').toFixed(4),
                            'PRINT_CNT'      : record.get('PRINT_CNT')
                        })

                        if (record.get('PRINT_YN') == true){

                        	data1 = data1 + record.get('ITEM_CODE') + "|" + record.get('LOT_NO') + "|" + record.get('ITEM_NAME') + "|"
                        						+ record.get('SPEC') + "|" +  record.get('OEM_ITEM_CODE') + "|" +  String(record.get('QTY').toFixed(4)) + "|"
                        						+ record.get('STOCK_UNIT') + "|" +  record.get('PRINT_CNT') + "\r\n";

                        }

                    });
                    //var jJsonData = JSON.stringify(data);

                    //form.setValue('data',Ext.encode(data)); // Ext.encode(jJsonData));

                    //form.submit();

                    writeFile("itemLotLabel2.txt", data1);

                    setTimeout(function(){
                            directMasterStore1.commitChanges();

                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel1\\Label.exe", 1);
                            } catch(e) {
                                alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                            }

                          /*   Ext.Msg.show({
                                title:'바코드 출력',
                                message: '파일 다운로드가 완료되면 확인버튼을 클릭하세요',
                                buttons: Ext.Msg.OKCANCEL,
                                icon: Ext.Msg.QUESTION,
                                fn: function(btn) {
                                    if (btn === 'ok') {
                                        try{
                                            var WshShell = new ActiveXObject("WScript.Shell");
                                            WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel1\\Label.exe", 1);
                                        } catch(e) {
                                            alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                                        }
                                    } else if (btn === 'cancel') {
                                        alert('바코드 출력이 취소되었습니다.');
                                    } else {
                                        console.log('Cancel pressed');
                                    }
                                }
                            }); */
                        }
                        , 2000
                    )
                }else{
                    masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });

    var panelPrint3 = Unilite.createForm('printForm3', {
        url: CPATH+'/z_kd/prdtPrintBarcode3',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 195',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,
        items:[{
            xtype: 'uniTextfield',
            name: 'data',
            hidden: true
        },{
            xtype: 'button',
            id: 'printBtn3',
            width: 90,
            text: '바코드 출력',
            handler : function() {
                if(directMasterStore2.getCount() == 0) return false;
                var inValidRecs = directMasterStore2.getInvalidRecords();
                if(inValidRecs.length == 0){
                    var form = this.up('uniDetailForm');
                    var data = new Array();
                    var data1 = "";

                    Ext.each(directMasterStore2.data.items, function(record, index){
                        data.push({
                            'PRINT_YN'       : record.get('PRINT_YN'),
                            'STATUS'         : record.get('STATUS'),
                            'ITEM_CODE'      : record.get('ITEM_CODE'),
                            'ITEM_NAME'      : record.get('ITEM_NAME'),
                            'LOT_NO'         : record.get('LOT_NO'),
                            'SPEC'           : record.get('SPEC'),
                            'OEM_ITEM_CODE'  : record.get('OEM_ITEM_CODE'),
                            'STOCK_UNIT'     : record.get('STOCK_UNIT'),
                            'QTY'            : record.get('QTY').toFixed(4),
                            'PRINT_CNT'      : record.get('PRINT_CNT')
                        })

                        if (record.get('PRINT_YN') == true){

                        	data1 = data1 + record.get('ITEM_CODE') + "|" + record.get('LOT_NO') + "|" + record.get('ITEM_NAME') + "|"
                        						+ record.get('SPEC') + "|" +  record.get('OEM_ITEM_CODE') + "|" +  String(record.get('QTY').toFixed(4)) + "|"
                        						+ record.get('STOCK_UNIT') + "|" +  record.get('PRINT_CNT') + "\r\n";

                        }

                    });
                    //var jJsonData = JSON.stringify(data);

                    //form.setValue('data',Ext.encode(data)); // Ext.encode(jJsonData));

                    //form.submit();

                     writeFile("itemLotLabel1.txt", data1);

                    setTimeout(function(){
                            directMasterStore2.commitChanges();
                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel1\\Label.exe", 1);
                            } catch(e) {
                                alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                            }
                            /* Ext.Msg.show({
                                title:'바코드 출력',
                                message: '파일 다운로드가 완료되면 확인버튼을 클릭하세요',
                                buttons: Ext.Msg.OKCANCEL,
                                icon: Ext.Msg.QUESTION,
                                fn: function(btn) {
                                    if (btn === 'ok') {
                                        try{
                                            var WshShell = new ActiveXObject("WScript.Shell");
                                            WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel2\\Label.exe", 1);
                                        } catch(e) {
                                            alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                                        }
                                    } else if (btn === 'cancel') {
                                        alert('바코드 출력이 취소되었습니다.');
                                    } else {
                                        console.log('Cancel pressed');
                                    }
                                }
                            }); */
                        }
                        , 2000
                    )
                }else{
                    masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });

    var panelPrint4 = Unilite.createForm('printForm4', {
        url: CPATH+'/z_kd/prdtPrintBarcode4',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 195',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,
        items:[{
            xtype: 'uniTextfield',
            name: 'data',
            hidden: true
        },{
            xtype: 'button',
            id: 'printBtn4',
            width: 90,
            text: '바코드 출력4',
            handler : function() {
                if(directMasterStore2.getCount() == 0) return false;
                var inValidRecs = directMasterStore2.getInvalidRecords();
                if(inValidRecs.length == 0){
                    var form = this.up('uniDetailForm');
                    var data = new Array();
                    var data1 = "";
                    Ext.each(directMasterStore2.data.items, function(record, index){
                        data.push({
                            'PRINT_YN'       : record.get('PRINT_YN'),
                            'STATUS'         : record.get('STATUS'),
                            'ITEM_CODE'      : record.get('ITEM_CODE'),
                            'ITEM_NAME'      : record.get('ITEM_NAME'),
                            'LOT_NO'         : record.get('LOT_NO'),
                            'SPEC'           : record.get('SPEC'),
                            'OEM_ITEM_CODE'  : record.get('OEM_ITEM_CODE'),
                            'STOCK_UNIT'     : record.get('STOCK_UNIT'),
                            'QTY'            : record.get('QTY').toFixed(4),
                            'PRINT_CNT'      : record.get('PRINT_CNT')
                        })

                        if (record.get('PRINT_YN') == true){

                        	data1 = data1 + record.get('ITEM_CODE') + "|" + record.get('LOT_NO') + "|" + record.get('ITEM_NAME') + "|"
                        						+ record.get('SPEC') + "|" +  record.get('OEM_ITEM_CODE') + "|" +  String(record.get('QTY').toFixed(4)) + "|"
                        						+ record.get('STOCK_UNIT') + "|" +  record.get('PRINT_CNT') + "\r\n";

                        }

                    });
                    //var jJsonData = JSON.stringify(data);

                   // form.setValue('data',Ext.encode(data)); // Ext.encode(jJsonData));

                    //form.submit();
                     writeFile("itemLotLabel2.txt", data1);

                    setTimeout(function(){
                            directMasterStore2.commitChanges();
                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel2\\Label.exe", 1);
                            } catch(e) {
                                alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                            }
                           /*  Ext.Msg.show({
                                title:'바코드 출력',
                                message: '파일 다운로드가 완료되면 확인버튼을 클릭하세요',
                                buttons: Ext.Msg.OKCANCEL,
                                icon: Ext.Msg.QUESTION,
                                fn: function(btn) {
                                    if (btn === 'ok') {
                                        try{
                                            var WshShell = new ActiveXObject("WScript.Shell");
                                            WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel2\\Label.exe", 1);
                                        } catch(e) {
                                            alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                                        }
                                    } else if (btn === 'cancel') {
                                        alert('바코드 출력이 취소되었습니다.');
                                    } else {
                                        console.log('Cancel pressed');
                                    }
                                }
                            }); */
                        }
                        , 2000
                    )
                }else{
                    masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });

    function writeFile(name, msg){
        if(name == "") return false;

        var defaultpath = "C:\\OmegaPlusPDA"; // 기록하고자 하는 경로. ex) C:\\Program Files\\logs
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var fullpath = defaultpath+"\\"+name;


        //파일삭제
        if(fso.FileExists(fullpath)){
             fso.DeleteFile(fullpath);
        }

        // 파일이 생성되어있지 않으면 새로 만들고 기록
        if(!fso.FileExists(fullpath)){
            //var fWrite = fso.CreateTextFile(fullpath,false);
	    var fWrite = fso.CreateTextFile(fullpath ,true,true);
            fWrite.write(msg);
            fWrite.close();
        }else{
        // 파일이 이미 생성되어 있으면 appending 모드로 파일 열고 기록
            var fWrite = fso.OpenTextFile(fullpath, 8);
            fWrite.write(msg);
            fWrite.close();
        }


    }

	var panelResult1 = Unilite.createSearchForm('resultForm1',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
//		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },{
                fieldLabel: '품목계정',
                name: 'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B020',
                allowBlank:false
            },{
                fieldLabel: '생산일',
                startFieldName: 'DATE_FR',
                endFieldName: 'DATE_TO',
                xtype: 'uniDateRangefield',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                colspan: 4
            },{
                fieldLabel: '작업장',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('wsList')
            },
            Unilite.popup('DIV_PUMOK', {
                fieldLabel: '품목',
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME',
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': panelResult1.getValue('DIV_CODE')});
                    }
                }
            }),{
                fieldLabel: 'LOT번호',
                xtype: 'uniTextfield',
                name: 'LOT_NO'
            },
            panelPrint1,
            panelPrint2,
            {
                xtype: 'radiogroup',
                fieldLabel: '양식선택',
                id: 'GUBUN',
                items : [{
                    boxLabel: '제품형',
                    name: 'STATUS',
                    checked: true,
                    inputValue: '1'
                }],
//                    {
//                    boxLabel: '원자재형',
//                    name: 'STATUS',
//                    width: 80,
//                    inputValue: '2'
//                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(Ext.getCmp('GUBUN').getValue().STATUS == '1') {
                            Ext.getCmp('printForm2').setVisible(false);
                            Ext.getCmp('printForm1').setVisible(true);
                        } else {
                            Ext.getCmp('printForm2').setVisible(true);
                            Ext.getCmp('printForm1').setVisible(false);
                        }
                    }
                }
            },{
                fieldLabel: '레코드(HIDDEN)',
                name:'COUNT',
                xtype: 'uniNumberfield',
                hidden: true
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
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
   				}
	  		} else {
	  			var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
    });

    var panelResult2 = Unilite.createSearchForm('resultForm2',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5},
        padding:'1 1 1 1',
        border:true,
//      hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },{
                fieldLabel: '품목계정',
                name: 'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B020',
                allowBlank:false
            },{
                fieldLabel: '검사일',
                startFieldName: 'DATE_FR',
                endFieldName: 'DATE_TO',
                xtype: 'uniDateRangefield',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                colspan: 4
            },{
                fieldLabel: '작업장',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('wsList')
            },
            Unilite.popup('DIV_PUMOK', {
                fieldLabel: '품목',
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME',
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': panelResult2.getValue('DIV_CODE')});
                    }
                }
            }),{
                fieldLabel: 'LOT번호',
                xtype: 'uniTextfield',
                name: 'LOT_NO'
            },
            panelPrint3,
            panelPrint4,
            {
                xtype: 'radiogroup',
                fieldLabel: '양식선택',
                id: 'GUBUN2',
                items : [{
                    boxLabel: '제품형',
                    name: 'STATUS',
                    checked: true,
                    inputValue: '1'
                }],
//                	{
//                    boxLabel: '원자재형',
//                    name: 'STATUS',
//                    width: 80,
//                    inputValue: '2'
//                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(Ext.getCmp('GUBUN2').getValue().STATUS == '1') {
                            Ext.getCmp('printForm4').setVisible(false);
                            Ext.getCmp('printForm3').setVisible(true);
                        } else {
                            Ext.getCmp('printForm3').setVisible(false);
                            Ext.getCmp('printForm4').setVisible(true);
                        }
                    }
                }
            },{
                fieldLabel: '레코드(HIDDEN)',
                name:'COUNT',
                xtype: 'uniNumberfield',
                hidden: true
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
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid1 = Unilite.createGrid('s_pda030rkrv_kdGrid1', {
    	// for tab
    	region: 'center',
    	layout: 'fit',
    	flex: 1,
		uniOpt: {
		 	expandLastColumn: true,
		 	useRowNumberer: true,
		 	useContextMenu: true,
            onLoadSelectFirst: false
        },
    	store: directMasterStore1,
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ) {
                    UniAppManager.setToolbarButtons(['save'], false);
                    checkedCount = checkedCount + 1;
                    selectRecord.set('PRINT_YN' , true);
                    panelResult1.setValue('COUNT', checkedCount);
                    if(panelResult1.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn1').setDisabled(false);
                        Ext.getCmp('printBtn2').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn1').setDisabled(true);
                        Ext.getCmp('printBtn2').setDisabled(true);
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ) {
                    UniAppManager.setToolbarButtons(['save'], false);
                    checkedCount = checkedCount - 1;
                    selectRecord.set('PRINT_YN' , false);
                    panelResult1.setValue('COUNT', checkedCount);
                    if(panelResult1.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn1').setDisabled(false);
                        Ext.getCmp('printBtn2').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn1').setDisabled(true);
                        Ext.getCmp('printBtn2').setDisabled(true);
                    }
                }
            }
        }),
        columns:  [
            { dataIndex: 'PRINT_YN'                       ,           width: 70, hidden : true/*  xtype : 'checkcolumn', align: 'center',*/
//                listeners:{
//                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
//                        var grdRecord = masterGrid1.getStore().getAt(rowIndex);
//                        if(checked == true) {
//                            UniAppManager.setToolbarButtons(['save'], false);
//                            checkedCount = checkedCount + 1;
//                            selectRecord.set('PRINT_YN' , true);
//                            panelResult1.setValue('COUNT', checkedCount);
//                            if(panelResult1.getValue('COUNT') > 0) {
//                                Ext.getCmp('printBtn1').setDisabled(false);
//                                Ext.getCmp('printBtn2').setDisabled(false);
//                            } else {
//                            	Ext.getCmp('printBtn1').setDisabled(true);
//                                Ext.getCmp('printBtn2').setDisabled(true);
//                            }
//                        } else {
//                            UniAppManager.setToolbarButtons(['save'], false);
//                            checkedCount = checkedCount - 1;
//                            selectRecord.set('PRINT_YN' , false);
//                            panelResult1.setValue('COUNT', checkedCount);
//                            if(panelResult1.getValue('COUNT') > 0) {
//                                Ext.getCmp('printBtn1').setDisabled(false);
//                                Ext.getCmp('printBtn2').setDisabled(false);
//                            } else {
//                                Ext.getCmp('printBtn1').setDisabled(true);
//                                Ext.getCmp('printBtn2').setDisabled(true);
//                            }
//                        }
//                    }
//                }
            },
            { dataIndex: 'WORK_SHOP_CODE'                    ,           width: 110},
            { dataIndex: 'WORK_SHOP_NAME'                    ,           width: 200},
            { dataIndex: 'PRODT_DATE'                        ,           width: 100},
            { dataIndex: 'ITEM_CODE'                         ,           width: 110},
            { dataIndex: 'ITEM_NAME'                         ,           width: 200},
            { dataIndex: 'SPEC'                              ,           width: 100},
            { dataIndex: 'OEM_ITEM_CODE'                     ,           width: 100},
            { dataIndex: 'LOT_NO'                            ,           width: 100},
            { dataIndex: 'STOCK_UNIT'                        ,           width: 100},
            { dataIndex: 'QTY'                               ,           width: 80},
            { dataIndex: 'PRINT_CNT'                         ,           width: 80},
            { dataIndex: 'PRODT_NUM'                         ,           width: 100},
            { dataIndex: 'WKORD_NUM'                         ,           width: 100},
            { dataIndex: 'DIV_CODE'                          ,           width: 100, hidden: true}
        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                    if(UniUtils.indexOf(e.field, ['QTY', 'PRINT_CNT'])) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['QTY', 'PRINT_CNT'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    });

    var masterGrid2 = Unilite.createGrid('s_pda030rkrv_kdGrid2', {
        // for tab
        region: 'center',
        layout: 'fit',
        flex: 1,
        uniOpt: {
            expandLastColumn: true,
            useRowNumberer: true,
            useContextMenu: true,
            onLoadSelectFirst: false
        },
        store: directMasterStore2,
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ) {
                    UniAppManager.setToolbarButtons(['save'], false);
                    checkedCount = checkedCount + 1;
                    selectRecord.set('PRINT_YN' , true);
                    panelResult1.setValue('COUNT', checkedCount);
                    if(panelResult1.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn3').setDisabled(false);
                        Ext.getCmp('printBtn4').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn3').setDisabled(true);
                        Ext.getCmp('printBtn4').setDisabled(true);
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ) {
                    UniAppManager.setToolbarButtons(['save'], false);
                    checkedCount = checkedCount - 1;
                    selectRecord.set('PRINT_YN' , false);
                    panelResult1.setValue('COUNT', checkedCount);
                    if(panelResult1.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn3').setDisabled(false);
                        Ext.getCmp('printBtn4').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn3').setDisabled(true);
                        Ext.getCmp('printBtn4').setDisabled(true);
                    }
                }
            }
        }),
        columns:  [
            { dataIndex: 'PRINT_YN'                       ,           width: 70, hidden : true/*  xtype : 'checkcolumn', align: 'center',*/
//                listeners:{
//                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
//                        var grdRecord = masterGrid2.getStore().getAt(rowIndex);
//                        if(checked == true) {
//                            UniAppManager.setToolbarButtons(['save'], false);
//                            checkedCount = checkedCount + 1;
//                            selectRecord.set('PRINT_YN' , true);
//                            panelResult2.setValue('COUNT', checkedCount);
//                            if(panelResult2.getValue('COUNT') > 0) {
//                                Ext.getCmp('printBtn3').setDisabled(false);
//                                Ext.getCmp('printBtn4').setDisabled(false);
//                            } else {
//                                Ext.getCmp('printBtn3').setDisabled(true);
//                                Ext.getCmp('printBtn4').setDisabled(true);
//                            }
//                        } else {
//                            UniAppManager.setToolbarButtons(['save'], false);
//                            checkedCount = checkedCount - 1;
//                            selectRecord.set('PRINT_YN' , false);
//                            panelResult2.setValue('COUNT', checkedCount);
//                            if(panelResult2.getValue('COUNT') > 0) {
//                                Ext.getCmp('printBtn3').setDisabled(false);
//                                Ext.getCmp('printBtn4').setDisabled(false);
//                            } else {
//                                Ext.getCmp('printBtn3').setDisabled(true);
//                                Ext.getCmp('printBtn4').setDisabled(true);
//                            }
//                        }
//                    }
//                }
            },
            { dataIndex: 'WORK_SHOP_CODE'                  ,           width: 110},
            { dataIndex: 'WORK_SHOP_NAME'                  ,           width: 200},
            { dataIndex: 'INSPEC_DATE'                     ,           width: 100},
            { dataIndex: 'ITEM_CODE'                       ,           width: 110},
            { dataIndex: 'ITEM_NAME'                       ,           width: 200},
            { dataIndex: 'SPEC'                            ,           width: 100},
            { dataIndex: 'OEM_ITEM_CODE'                   ,           width: 100},
            { dataIndex: 'LOT_NO'                          ,           width: 100},
            { dataIndex: 'STOCK_UNIT'                      ,           width: 100},
            { dataIndex: 'QTY'                             ,           width: 80},
            { dataIndex: 'PRINT_CNT'                       ,           width: 80},
            { dataIndex: 'INSPEC_NUM'                      ,           width: 100},
            { dataIndex: 'INSPEC_SEQ'                      ,           width: 100},
            { dataIndex: 'PRODT_NUM'                       ,           width: 100},
            { dataIndex: 'WKORD_NUM'                       ,           width: 100},
            { dataIndex: 'DIV_CODE'                        ,           width: 100, hidden: true}
        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                    if(UniUtils.indexOf(e.field, ['QTY', 'PRINT_CNT'])) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['QTY', 'PRINT_CNT'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    });

    var tab = Unilite.createTabPanel('tabPanel',{
        activeTab:  0,
        region: 'center',
        items:  [
             {
                 title: '생산실적'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[panelResult1, masterGrid1, describedPanel1]
                 ,id: 'tabGrid1'
             },
             {
                 title: '생산검사'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[panelResult2, masterGrid2, describedPanel2]
                 ,id: 'tabGrid2'
             }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());
                UniAppManager.app.onResetButtonDown();
                Ext.getCmp('printForm1').setVisible(true);
                Ext.getCmp('printForm2').setVisible(false);
                Ext.getCmp('printForm3').setVisible(true);
                Ext.getCmp('printForm4').setVisible(false);
            }
        }
    });

	Unilite.Main( {
		borderItems:[{
    			region:'center',
    			layout: 'border',
    			border: false,
    			items:[
    				tab
    			]
    		}
		],
		fnInitBinding: function(params) {
		    panelResult1.setValue('PRINT_Q', '1');
            panelResult1.setValue('DIV_CODE', UserInfo.divCode);
            panelResult1.setValue('DATE_FR', UniDate.get('startOfMonth'));
            panelResult1.setValue('DATE_TO', UniDate.get('today'));
            panelResult1.setValue('COUNT', '');
            Ext.getCmp('printBtn1').setDisabled(true);
            Ext.getCmp('printBtn2').setDisabled(true);

            panelResult2.setValue('PRINT_Q', '1');
            panelResult2.setValue('DIV_CODE', UserInfo.divCode);
            panelResult2.setValue('DATE_FR', UniDate.get('startOfMonth'));
            panelResult2.setValue('DATE_TO', UniDate.get('today'));
            panelResult2.setValue('COUNT', '');
            Ext.getCmp('printBtn3').setDisabled(true);
            Ext.getCmp('printBtn4').setDisabled(true);

            UniAppManager.setToolbarButtons(['save'], false);
            this.setDefault();
		},
        onQueryButtonDown: function() {
        	var activeTabId = tab.getActiveTab().getId();
            if(activeTabId == 'tabGrid1') {
                if(panelResult1.setAllFieldsReadOnly(true) == false){
                    return false;
                } else {
                    masterGrid1.getStore().loadStoreRecords();
                }
            } else if(activeTabId == 'tabGrid2') {
            	if(panelResult2.setAllFieldsReadOnly(true) == false){
                    return false;
                } else {
                    masterGrid2.getStore().loadStoreRecords();
                }
            }
            UniAppManager.setToolbarButtons(['reset'],true);
        },
		onResetButtonDown: function() {
			panelResult1.setAllFieldsReadOnly(false);
			panelResult1.clearForm();
			masterGrid1.reset();
			directMasterStore1.clearData();

            panelResult2.setAllFieldsReadOnly(false);
            panelResult2.clearForm();
            masterGrid2.reset();
            directMasterStore2.clearData();

			this.fnInitBinding();
		},
        setDefault: function() {
            Ext.getCmp('printForm1').setVisible(true);
            Ext.getCmp('printForm2').setVisible(false);
            panelResult1.setValue('ITEM_ACCOUNT', '10');
            panelResult2.setValue('ITEM_ACCOUNT', '10');
        }
	});

};


</script>
