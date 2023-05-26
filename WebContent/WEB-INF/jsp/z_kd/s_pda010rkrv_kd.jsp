<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_pda010rkrv_kd"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_pda010rkrv_kd"  /> 			<!-- 사업장   -->
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />               <!--창고      -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />                         <!-- 차종     -->
    <t:ExtComboStore comboType="AU" comboCode="WB08" />                         <!-- 금형구분 -->
    <t:ExtComboStore comboType="AU" comboCode="WB10" />                         <!-- 위치상태 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" />                         <!-- 품목계정 -->
</t:appConfig>

<script type="text/javascript" >
var settingWindow;
var checkedCount = 0;   // 체크된 레코드

function appMain() {/**
					 * LocationModel 정의
					 * 
					 * @type
					 */
    Unilite.defineModel('s_pda010rkrv_kdModel1', {
        fields: [
            {name: 'PRINT_YN'           ,text: '출력'                 ,type: 'boolean', defaultValue: false},
            {name: 'COMP_CODE'          ,text: '법인코드'             ,type: 'string'},
            {name: 'DIV_CODE'           ,text: '사업장'               ,type: 'string'},
            {name: 'WH_CODE'            ,text: '창고'                 ,type: 'string'},
            {name: 'WH_NAME'            ,text: '창고명'               ,type: 'string'},
            {name: 'WH_CELL_CODE'       ,text: 'Location코드'         ,type: 'string'},
            {name: 'WH_CELL_NAME'       ,text: 'Location명'           ,type: 'string'},
            {name: 'CUSTOM_CODE'        ,text: '거래처코드'           ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '거래처명'             ,type: 'string'},
            {name: 'PRINT_CNT'          ,text: '출력수'               ,type: 'uniQty', allowBlank:false, defaultValue: 1}
        ]
    });

    /**
	 * 금형Model 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('s_pda010rkrv_kdModel2', {
        fields: [
            {name: 'PRINT_YN'           ,text: '출력'                 ,type: 'boolean', defaultValue: false},
            {name: 'COMP_CODE'          ,text: '법인코드'             ,type: 'string'},
            {name: 'DIV_CODE'           ,text: '사업장'               ,type: 'string'},
            {name: 'MOLD_TYPE'          ,text: '금형구분'             ,type: 'string', comboType: 'AU', comboCode: 'WB08'},
            {name: 'MOLD_CODE'          ,text: '금형코드'             ,type: 'string'},
            {name: 'MOLD_NAME'          ,text: '금형명'               ,type: 'string'},
            {name: 'OEM_ITEM_CODE'      ,text: '품번'                 ,type: 'string'},
            {name: 'CAR_TYPE'           ,text: '차종'                 ,type: 'string'},
            {name: 'ST_LOCATION'        ,text: '위치상태'             ,type: 'string', comboType: 'AU', comboCode: 'WB09'},
            {name: 'MAX_DEPR'           ,text: '최대상각'             ,type: 'uniQty'},
            {name: 'CHK_DEPR'           ,text: '점검상각'             ,type: 'uniQty'},
            {name: 'NOW_DEPR'           ,text: '현상각수'             ,type: 'uniQty'},
            {name: 'PRINT_CNT'          ,text: '출력수'               ,type: 'uniQty', allowBlank:false, defaultValue: 1},
            {name: 'PROG_WORK_NAME'     ,text: '공정명'               ,type: 'string'},
            {name: 'DATE_MAKE'          ,text: '제작일자'             ,type: 'uniDate'},
            {name: 'MOL_MTL'           ,text: '소재'                 ,type: 'string'},
            {name: 'MOL_SPEC'          ,text: '규격'                 ,type: 'string'},
            {name: 'DATE_INST'          ,text: '설치일자'             ,type: 'uniDate'}
        ]
    });

    /**
	 * 품목LotModel 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('s_pda010rkrv_kdModel3', {
        fields: [
            {name: 'PRINT_YN'           ,text: '출력'                 ,type: 'boolean', defaultValue: false},
            {name: 'COMP_CODE'          ,text: '법인코드'             ,type: 'string'},
            {name: 'DIV_CODE'           ,text: '사업장'               ,type: 'string'},
            {name: 'WH_CODE'            ,text: '창고'                 ,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
            {name: 'ITEM_CODE'          ,text: '품목코드'             ,type: 'string'},
            {name: 'ITEM_NAME'          ,text: '품목명'               ,type: 'string'},
            {name: 'SPEC'               ,text: '규격'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'      ,text: '품번'                 ,type: 'string'},
            {name: 'LOT_NO'             ,text: 'LOT번호'              ,type: 'string'},
            {name: 'STOCK_UNIT'         ,text: '재고단위'             ,type: 'string'},
            {name: 'QTY'                ,text: '수량'                 ,type: 'float', allowBlank: false, maxLength: 17, decimalPrecision: 4, format: '0,000,000.0000'},
            {name: 'PRINT_CNT'          ,text: '출력수'               ,type: 'uniQty', allowBlank: false, defaultValue: 1},
            {name: 'STATUS'             ,text: '양식선택'             ,type: 'string'}
        ]
    });
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_pda010rkrv_kdMasterStore1',{
            model: 's_pda010rkrv_kdModel1',
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
                    read: 's_pda010rkrv_kdService.selectList1'
                }
            },
            loadStoreRecords : function()  {
                var param= Ext.getCmp('resultForm1').getValues();
                console.log( param );
                this.load({
                    params : param
                });

            }
    });

    var directMasterStore2 = Unilite.createStore('s_pda010rkrv_kdMasterStore2',{
            model: 's_pda010rkrv_kdModel2',
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
                    read: 's_pda010rkrv_kdService.selectList2'
                }
            },
            loadStoreRecords : function()  {
                var param= Ext.getCmp('resultForm2').getValues();
                console.log( param );
                this.load({
                    params : param
                });

            }
    });

    var directMasterStore3 = Unilite.createStore('s_pda010rkrv_kdMasterStore3',{
            model: 's_pda010rkrv_kdModel3',
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
                    read: 's_pda010rkrv_kdService.selectList3'
                }
            },
            loadStoreRecords : function()  {
                var param= Ext.getCmp('resultForm3').getValues();
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

    var describedPanel1 = Unilite.createSearchForm('s_pda010rkrv_kdDescribedPanel1',{
        region: 'east',
        padding: '1 1 1 1',
        layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
        defaults:{labelWidth: 100, margin:'5 0 0 20', width: 600},
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
                    html: '&nbsp;&nbsp;&nbsp;2.&nbsp;라벨출력프로그램을 C:&nbsp;/&nbsp;OmegaPlusPDA&nbsp;/&nbsp;locationLabel 폴더를 생성후, 해당폴더에 압축을 푼다.'
                }/*
					 * ,{ margin: '0 0 0 6', xtype: 'button', text: '출력 프로그램
					 * 다운로드', handler : function() {
					 *  } }
					 */]
            },{
                xtype:'container',
                margin: '10 0 0 20',
                html: '&nbsp;&nbsp;&nbsp;3.&nbsp;위 사항이 준비되었으면 [바코드 출력] 버튼을 클릭하여 출력한다.'
            }]
    });

    var describedPanel2 = Unilite.createSearchForm('s_pda010rkrv_kdDescribedPanel2',{
        region: 'east',
        padding: '1 1 1 1',
        layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
        defaults:{labelWidth: 100, margin:'5 0 0 20', width: 600},
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
                    html: '&nbsp;&nbsp;&nbsp;2.&nbsp;라벨출력프로그램을 C:&nbsp;/&nbsp;OmegaPlusPDA&nbsp;/&nbsp;moldLabel 폴더를 생성후, 해당폴더에 압축을 푼다.'
                }/*
					 * ,{ margin: '0 0 0 6', xtype: 'button', text: '출력 프로그램
					 * 다운로드', handler : function() {
					 *  } }
					 */]
            },{
                xtype:'container',
                margin: '10 0 0 20',
                html: '&nbsp;&nbsp;&nbsp;3.&nbsp;위 사항이 준비되었으면 [바코드 출력] 버튼을 클릭하여 출력한다.'
            }]
    });

    var describedPanel3 = Unilite.createSearchForm('s_pda010rkrv_kdDescribedPanel3',{
        region: 'east',
        padding: '1 1 1 1',
        layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
        defaults:{labelWidth: 100, margin:'5 0 0 20', width: 2000},
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
                    html: '&nbsp;&nbsp;&nbsp;2.&nbsp;라벨출력프로그램을 제품형인경우 C:&nbsp;/&nbsp;OmegaPlusPDA&nbsp;/&nbsp;itemLotLabel1, 원자재형인경우 C:&nbsp;/&nbsp;OmegaPlusPDA&nbsp;/&nbsp;itemLotLabel2 폴더를 생성후, 해당폴더에 압축을 푼다.'
                }/*
					 * ,{ margin: '0 0 0 6', xtype: 'button', text: '출력 프로그램
					 * 다운로드', handler : function() {
					 *  } }
					 */]
            },{
                xtype:'container',
                margin: '10 0 0 20',
                html: '&nbsp;&nbsp;&nbsp;3.&nbsp;위 사항이 준비되었으면 [바코드 출력] 버튼을 클릭하여 출력한다.'
            }]
    });

    var panelPrint1 = Unilite.createForm('printForm1', {
        url: CPATH+'/z_kd/printBarcode1',
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
                            'WH_CODE'        : record.get('WH_CODE'),
                            'WH_NAME'        : record.get('WH_NAME'),
                            'WH_CELL_CODE'   : record.get('WH_CELL_CODE'),
                            'PRINT_CNT'      : record.get('PRINT_CNT')
                        })

                        if (record.get('PRINT_YN') == true){

                        	data1 = data1 + record.get('WH_CODE') + "|" + record.get('WH_NAME') + "|" + record.get('WH_CELL_CODE') + "|"
                        						+ record.get('PRINT_CNT') + "\r\n";

                        }
                    });
                    // var jJsonData = JSON.stringify(data);

                   // form.setValue('data',Ext.encode(data)); //
					// Ext.encode(jJsonData));
                    writeFile("locationLabel.txt", data1);
                   // form.submit();
                    setTimeout(function(){
                            directMasterStore1.commitChanges();
                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\locationLabel\\Label.exe", 1);
                            } catch(e) {
                                alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                            }
                       /*
						 * Ext.Msg.show({ title:'바코드 출력', message: '파일 다운로드가
						 * 완료되면 확인버튼을 클릭하세요', buttons: Ext.Msg.OKCANCEL, icon:
						 * Ext.Msg.QUESTION, fn: function(btn) { if (btn ===
						 * 'ok') { try{ var WshShell = new
						 * ActiveXObject("WScript.Shell");
						 * WshShell.Run("C:\\OmegaPlusPDA\\locationLabel\\Label.exe",
						 * 1); } catch(e) { alert('바코드 출력 프로그램의 정상작동 여부를 확인 후
						 * 바코드 버튼을 재실행하세요.'); } } else if (btn === 'cancel') {
						 * alert('바코드 출력이 취소되었습니다.'); } else {
						 * console.log('Cancel pressed'); } } });
						 */
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
        url: CPATH+'/z_kd/printBarcode2',
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
                if(directMasterStore2.getCount() == 0) return false;
                var inValidRecs = directMasterStore2.getInvalidRecords();
                if(inValidRecs.length == 0){
                    var form = this.up('uniDetailForm');
                    var data = new Array();
                    var data1 = "";
                    var dateMake = "";
                    Ext.each(directMasterStore2.data.items, function(record, index){
                        data.push({
                            'PRINT_YN'          : record.get('PRINT_YN'),
                            'MOLD_CODE'         : record.get('MOLD_CODE'),
                            'OEM_ITEM_CODE'     : record.get('OEM_ITEM_CODE'),
                            'CAR_TYPE'          : record.get('CAR_TYPE'),
                            'PROG_WORK_NAME'    : record.get('PROG_WORK_NAME'),
                            'DATE_MAKE'         : UniDate.getDbDateStr(record.get('DATE_MAKE')),
                            'MOLD_MTL'          : record.get('MOL_MTL'),
                            'MOLD_SPEC'         : record.get('MOL_SPEC'),
                            'PRINT_CNT'         : record.get('PRINT_CNT')
                        })

                        if (record.get('PRINT_YN') == true){

                        		dateMake = "";

                        	if(!Ext.isEmpty(record.get('DATE_MAKE'))){

                        		dateMake = UniDate.getDbDateStr(record.get('DATE_MAKE')).substring(0,4) + "." + UniDate.getDbDateStr(record.get('DATE_MAKE')).substring(4,6) + "." + UniDate.getDbDateStr(record.get('DATE_MAKE')).substring(6,8);

                        	}
                        	data1 = data1 + record.get('MOLD_CODE') + "|" + record.get('OEM_ITEM_CODE') + "|" + record.get('CAR_TYPE') + "|"
                        						+ record.get('PROG_WORK_NAME') + "|" +  dateMake + "|" + record.get('MOL_MTL') + "|"
                        						+ record.get('MOL_SPEC') + "|" +  record.get('PRINT_CNT') + "\r\n";

                        }
                    });
                    // var jJsonData = JSON.stringify(data);
                   // form.setValue('data',Ext.encode(data)); //
					// Ext.encode(jJsonData));

                   // form.submit();

                    writeFile("moldLabel.txt", data1);
                    setTimeout(function(){
                            directMasterStore2.commitChanges();
                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\moldLabel\\Label.exe", 1);
                            } catch(e) {
                                alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                            }
                          /*
							 * Ext.Msg.show({ title:'바코드 출력', message: '파일 다운로드가
							 * 완료되면 확인버튼을 클릭하세요', buttons: Ext.Msg.OKCANCEL,
							 * icon: Ext.Msg.QUESTION, fn: function(btn) { if
							 * (btn === 'ok') { try{ var WshShell = new
							 * ActiveXObject("WScript.Shell");
							 * WshShell.Run("C:\\OmegaPlusPDA\\moldLabel\\Label.exe",
							 * 1); } catch(e) { alert('바코드 출력 프로그램의 정상작동 여부를 확인
							 * 후 바코드 버튼을 재실행하세요.'); } } else if (btn ===
							 * 'cancel') { alert('바코드 출력이 취소되었습니다.'); } else {
							 * console.log('Cancel pressed'); } } });
							 */
                        }
                        , 2000
                    )
                }else{
                    masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });

    var panelPrint3 = Unilite.createForm('printForm3', {
        url: CPATH+'/z_kd/printBarcode3',
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
                if(directMasterStore3.getCount() == 0) return false;
                var inValidRecs = directMasterStore3.getInvalidRecords();
                if(inValidRecs.length == 0){
                    var form = this.up('uniDetailForm');
                    var data = new Array();
                    var data1 = "";
                    Ext.each(directMasterStore3.data.items, function(record, index){
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
                    // var JsonData = JSON.stringify(data);

                    // form.setValue('data',Ext.encode(data)); //
					// Ext.encode(jJsonData));

                    // form.submit();

                    writeFile("itemLotLabel1.txt", data1);

                    setTimeout(function(){
                            directMasterStore3.commitChanges();
                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel1\\Label.exe", 1);
                            } catch(e) {
                                alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                            }
                        /*
						 * Ext.Msg.show({ title:'바코드 출력', message: '파일 다운로드가
						 * 완료되면 확인버튼을 클릭하세요', buttons: Ext.Msg.OKCANCEL, icon:
						 * Ext.Msg.QUESTION, fn: function(btn) { try{ var
						 * WshShell = new ActiveXObject("WScript.Shell");
						 * WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel1\\epp312.exe",
						 * 1); } catch(e) { alert('바코드 출력 프로그램의 정상작동 여부를 확인 후
						 * 바코드 버튼을 재실행하세요.'); } } });
						 */
                        }
                        , 2000
                    )
                }else{
                    masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });


    var panelPrint4 = Unilite.createForm('printForm4', {
        url: CPATH+'/z_kd/printBarcode4',
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
            text: '바코드 출력',
            handler : function() {
                if(directMasterStore3.getCount() == 0) return false;
                var inValidRecs = directMasterStore3.getInvalidRecords();
                if(inValidRecs.length == 0){
                    var form = this.up('uniDetailForm');
                    var data = new Array();
                    var data1 = "";
                    Ext.each(directMasterStore3.data.items, function(record, index){
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
                    // var jJsonData = JSON.stringify(data);

                    // form.setValue('data',Ext.encode(data)); //
					// Ext.encode(jJsonData));

                    // form.submit();

                    writeFile("itemLotLabel2.txt", data1);

                    setTimeout(function(){
                            directMasterStore3.commitChanges();
                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel2\\Label.exe", 1);
                            } catch(e) {
                                alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.');
                            }
   /*
	 * Ext.Msg.show({ title:'바코드 출력', message: '파일 다운로드가 완료되면 확인버튼을 클릭하세요',
	 * buttons: Ext.Msg.OKCANCEL, icon: Ext.Msg.QUESTION, fn: function(btn) { if
	 * (btn === 'ok') { try{ var WshShell = new ActiveXObject("WScript.Shell");
	 * WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel2\\Label.exe", 1); } catch(e) {
	 * alert('바코드 출력 프로그램의 정상작동 여부를 확인 후 바코드 버튼을 재실행하세요.'); } } else if (btn ===
	 * 'cancel') { alert('바코드 출력이 취소되었습니다.'); } else { console.log('Cancel
	 * pressed'); } } });
	 */
                        }
                        , 2000
                    )
                }else{
                    masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });

    function writeFile(name, msg){
        if(name == "") return false;

        var defaultpath = "C:\\OmegaPlusPDA"; // 기록하고자 하는 경로. ex) C:\\Program
												// Files\\logs
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var fullpath = defaultpath+"\\"+name;


        // 파일삭제
        if(fso.FileExists(fullpath)){
             fso.DeleteFile(fullpath);
        }

        // 파일이 생성되어있지 않으면 새로 만들고 기록
        if(!fso.FileExists(fullpath)){
            // var fWrite = fso.CreateTextFile(fullpath,false);
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
// hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },{
                fieldLabel: '창고',
                name:'WH_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList'),
                allowBlank:false
            },{
                fieldLabel: '창고CELL',
                xtype: 'uniTextfield',
                name:'TXT_SEARCH'
            },{
                fieldLabel: '레코드(HIDDEN)',
                name:'COUNT',
                xtype: 'uniNumberfield',
                hidden: true
            },
            panelPrint1
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
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
// hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                holdable: 'hold'
            },{
                fieldLabel: '설치일자',
                startFieldName: 'INSTALL_DATE_FR',
                endFieldName: 'INSTALL_DATE_TO',
                xtype: 'uniDateRangefield',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                //colspan: 2,
                holdable: 'hold'
            },
            {
                fieldLabel: '폐기포함',
                name:'DATE_DISP',
                xtype: 'checkboxfield',
                checked: false,
                holdable: 'hold'
            },{
                fieldLabel: '금형구분',
                name:'MOLD_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WB08',
                allowBlank:false,
                holdable: 'hold'
            },
            Unilite.popup('MOLD_CODE',{ 
                fieldLabel: '금형',
                valueFieldName:'MOLD_CODE',
                textFieldName:'MOLD_NAME',
                valueFieldWidth: 100,
                textFieldWidth: 200,
                holdable: 'hold',
                autoPopup:true,
                listeners: {
                    applyextparam: function(popup){                         
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }
                }
        }),
            panelPrint2,
            {
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

    var panelResult3 = Unilite.createSearchForm('resultForm3',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
// hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                holdable: 'hold'
            },{
                fieldLabel: '창고',
                name:'WH_CODE',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('whList'),
                holdable: 'hold',
                allowBlank:false,
                colspan: 3
            },{
                fieldLabel: '품목계정',
                name:'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B020',
                allowBlank:false,
                holdable: 'hold'
            },     
            Unilite.popup('DIV_PUMOK',{ 
                fieldLabel: '품목', 
                valueFieldName: 'ITEM_CODE',
                textFieldName: 'ITEM_NAME',
                holdable: 'hold',
                autoPopup: false,
                validateBlank: false,
          }),
            {
            	fieldLabel: 'Lot번호',
                xtype: 'uniTextfield',
                name: 'LOT_NO',
                holdable: 'hold'
            },
            panelPrint3,
            panelPrint4,
            {
                xtype: 'radiogroup',
                fieldLabel: '양식선택',
                id: 'GUBUN',
                items : [{
                    boxLabel: '제품형',
                    name: 'STATUS',
// checked: true,
                    inputValue: '1'
                },{
                    boxLabel: '원자재형',
                    name: 'STATUS',
                    width: 80,
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(Ext.getCmp('GUBUN').getValue().STATUS == '1') {
                            Ext.getCmp('printForm4').setVisible(false);
                            Ext.getCmp('printForm3').setVisible(true);
                        } else {
                            Ext.getCmp('printForm4').setVisible(true);
                        	Ext.getCmp('printForm3').setVisible(false);
                        }
                    }
                }
            },
            {
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
	 * 
	 * @type
	 */

    var masterGrid1 = Unilite.createGrid('s_pda010rkrv_kdGrid1', {
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
                    } else {
                        Ext.getCmp('printBtn1').setDisabled(true);
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ) {
                    UniAppManager.setToolbarButtons(['save'], false);
                    checkedCount = checkedCount - 1;
                    selectRecord.set('PRINT_YN' , false);
                    panelResult1.setValue('COUNT', checkedCount);
                    if(panelResult1.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn1').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn1').setDisabled(true);
                    }
                }
            }
        }),
        columns:  [
            { dataIndex: 'PRINT_YN'                       ,           width: 70, hidden: true /*
																								 * xtype :
																								 * 'checkcolumn',
																								 * align:
																								 * 'center',
																								 * listeners:{
																								 * checkchange:
																								 * function(
																								 * CheckColumn,
																								 * rowIndex,
																								 * checked,
																								 * eOpts ){
																								 * var
																								 * grdRecord =
																								 * masterGrid1.getStore().getAt(rowIndex);
																								 * if(checked ==
																								 * true) {
																								 * UniAppManager.setToolbarButtons(['save'],
																								 * false);
																								 * checkedCount =
																								 * checkedCount +
																								 * 1;
																								 * panelResult1.setValue('COUNT',
																								 * checkedCount);
																								 * if(panelResult1.getValue('COUNT') >
																								 * 0) {
																								 * Ext.getCmp('printBtn1').setDisabled(false); }
																								 * else {
																								 * Ext.getCmp('printBtn1').setDisabled(true); } }
																								 * else {
																								 * UniAppManager.setToolbarButtons(['save'],
																								 * false);
																								 * checkedCount =
																								 * checkedCount -
																								 * 1;
																								 * panelResult1.setValue('COUNT',
																								 * checkedCount);
																								 * if(panelResult1.getValue('COUNT') >
																								 * 0) {
																								 * Ext.getCmp('printBtn1').setDisabled(false); }
																								 * else {
																								 * Ext.getCmp('printBtn1').setDisabled(true); } } } }
																								 */
            },
            { dataIndex: 'COMP_CODE'                      ,           width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'                       ,           width: 100, hidden: true},
            { dataIndex: 'WH_CODE'                        ,           width: 100},
            { dataIndex: 'WH_NAME'                        ,           width: 200},
            { dataIndex: 'WH_CELL_CODE'                   ,           width: 100},
            { dataIndex: 'WH_CELL_NAME'                   ,           width: 200},
            { dataIndex: 'CUSTOM_CODE'                    ,           width: 100, hidden: true},
            { dataIndex: 'CUSTOM_NAME'                    ,           width: 100, hidden: true},
            { dataIndex: 'PRINT_CNT'                      ,           width: 100}
        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                    if(e.field=='PRINT_CNT') {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(e.field=='PRINT_CNT') {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    });

    var masterGrid2 = Unilite.createGrid('s_pda010rkrv_kdGrid2', {
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
                        Ext.getCmp('printBtn2').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn2').setDisabled(true);
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ) {
                    UniAppManager.setToolbarButtons(['save'], false);
                    checkedCount = checkedCount - 1;
                    selectRecord.set('PRINT_YN' , false);
                    panelResult1.setValue('COUNT', checkedCount);
                    if(panelResult1.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn2').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn2').setDisabled(true);
                    }
                }
            }
        }),
        columns:  [
            { dataIndex: 'PRINT_YN'                       ,           width: 70, hidden: true /*
																								 * xtype :
																								 * 'checkcolumn',
																								 * align:
																								 * 'center',
																								 * listeners:{
																								 * checkchange:
																								 * function(
																								 * CheckColumn,
																								 * rowIndex,
																								 * checked,
																								 * eOpts ){
																								 * var
																								 * grdRecord =
																								 * masterGrid2.getStore().getAt(rowIndex);
																								 * if(checked ==
																								 * true) {
																								 * UniAppManager.setToolbarButtons(['save'],
																								 * false);
																								 * checkedCount =
																								 * checkedCount +
																								 * 1;
																								 * panelResult2.setValue('COUNT',
																								 * checkedCount);
																								 * if(panelResult2.getValue('COUNT') >
																								 * 0) {
																								 * Ext.getCmp('printBtn2').setDisabled(false); }
																								 * else {
																								 * Ext.getCmp('printBtn2').setDisabled(true); } }
																								 * else {
																								 * UniAppManager.setToolbarButtons(['save'],
																								 * false);
																								 * checkedCount =
																								 * checkedCount -
																								 * 1;
																								 * panelResult2.setValue('COUNT',
																								 * checkedCount);
																								 * if(panelResult2.getValue('COUNT') >
																								 * 0) {
																								 * Ext.getCmp('printBtn2').setDisabled(false); }
																								 * else {
																								 * Ext.getCmp('printBtn2').setDisabled(true); } } } }
																								 */
            },
            { dataIndex: 'COMP_CODE'                       ,           width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'                        ,           width: 100, hidden: true},
            { dataIndex: 'MOLD_TYPE'                       ,           width: 100},
            { dataIndex: 'MOLD_CODE'                       ,           width: 100},
            { dataIndex: 'MOLD_NAME'                       ,           width: 200},
            { dataIndex: 'OEM_ITEM_CODE'                   ,           width: 100},
            { dataIndex: 'CAR_TYPE'                        ,           width: 100},
            { dataIndex: 'ST_LOCATION'                     ,           width: 100},
            { dataIndex: 'MAX_DEPR'                        ,           width: 100},
            { dataIndex: 'CHK_DEPR'                        ,           width: 100},
            { dataIndex: 'NOW_DEPR'                        ,           width: 100},
            { dataIndex: 'PRINT_CNT'                       ,           width: 100},
            { dataIndex: 'PROG_WORK_NAME'                  ,           width: 200},
            { dataIndex: 'DATE_MAKE'                       ,           width: 80},
            { dataIndex: 'MOL_MTL'                        ,           width: 100},
            { dataIndex: 'MOL_SPEC'                       ,           width: 100},
            { dataIndex: 'DATE_INST'                       ,           width: 80}
        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                    if(e.field=='PRINT_CNT') {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(e.field=='PRINT_CNT') {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    });

    var masterGrid3 = Unilite.createGrid('s_pda010rkrv_kdGrid3', {
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
        store: directMasterStore3,
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
            { dataIndex: 'PRINT_YN'                       ,           width: 70, hidden: true /*
																								 * xtype :
																								 * 'checkcolumn',
																								 * align:
																								 * 'center',
																								 * listeners:{
																								 * checkchange:
																								 * function(
																								 * CheckColumn,
																								 * rowIndex,
																								 * checked,
																								 * eOpts ){
																								 * var
																								 * grdRecord =
																								 * masterGrid3.getStore().getAt(rowIndex);
																								 * if(checked ==
																								 * true) {
																								 * UniAppManager.setToolbarButtons(['save'],
																								 * false);
																								 * checkedCount =
																								 * checkedCount +
																								 * 1;
																								 * panelResult3.setValue('COUNT',
																								 * checkedCount);
																								 * if(panelResult3.getValue('COUNT') >
																								 * 0) {
																								 * Ext.getCmp('printBtn3').setDisabled(false);
																								 * Ext.getCmp('printBtn4').setDisabled(false); }
																								 * else {
																								 * Ext.getCmp('printBtn3').setDisabled(true);
																								 * Ext.getCmp('printBtn4').setDisabled(true); } }
																								 * else {
																								 * UniAppManager.setToolbarButtons(['save'],
																								 * false);
																								 * checkedCount =
																								 * checkedCount -
																								 * 1;
																								 * panelResult3.setValue('COUNT',
																								 * checkedCount);
																								 * if(panelResult2.getValue('COUNT') >
																								 * 0) {
																								 * Ext.getCmp('printBtn3').setDisabled(false);
																								 * Ext.getCmp('printBtn4').setDisabled(false); }
																								 * else {
																								 * Ext.getCmp('printBtn3').setDisabled(true);
																								 * Ext.getCmp('printBtn4').setDisabled(true); } } } }
																								 */
            },
            { dataIndex: 'COMP_CODE'                      ,           width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'                       ,           width: 100, hidden: true},
            { dataIndex: 'WH_CODE'                        ,           width: 100},
            { dataIndex: 'ITEM_CODE'                      ,           width: 120},
            { dataIndex: 'ITEM_NAME'                      ,           width: 200},
            { dataIndex: 'SPEC'                           ,           width: 100},
            { dataIndex: 'OEM_ITEM_CODE'                  ,           width: 100},
            { dataIndex: 'LOT_NO'                         ,           width: 100},
            { dataIndex: 'STOCK_UNIT'                     ,           width: 80},
            { dataIndex: 'QTY'                            ,           width: 80, align: 'right'},
            { dataIndex: 'PRINT_CNT'                      ,           width: 100},
            { dataIndex: 'STATUS'                         ,           width: 100, hidden: true}
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
                 title: 'Location바코드'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[panelResult1, masterGrid1, describedPanel1]
                 ,id: 'tabGrid1'
             },
             {
                 title: '금형바코드'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[panelResult2, masterGrid2, describedPanel2]
                 ,id: 'tabGrid2'
             },
             {
                 title: '품목LOT바코드'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[panelResult3, masterGrid3, describedPanel3]
                 ,id: 'tabGrid3'
             }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());
                UniAppManager.app.onResetButtonDown();
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
            panelResult1.setValue('COUNT', '');
            Ext.getCmp('printBtn1').setDisabled(true);

            panelResult2.setValue('PRINT_Q', '1');
            panelResult2.setValue('DIV_CODE', UserInfo.divCode);
            panelResult2.setValue('INSTALL_DATE_FR', UniDate.get('startOfMonth'));
            panelResult2.setValue('INSTALL_DATE_TO', UniDate.get('today'));
            panelResult2.setValue('COUNT', '');
            Ext.getCmp('printBtn2').setDisabled(true);

            panelResult3.setValue('PRINT_Q', '1');
            panelResult3.setValue('DIV_CODE', UserInfo.divCode);
            panelResult3.setValue('STATUS', '1');
            panelResult3.setValue('COUNT', '');
            Ext.getCmp('printBtn3').setDisabled(true);
            Ext.getCmp('printBtn4').setDisabled(true);
            UniAppManager.setToolbarButtons(['save'], false);

		},
        onQueryButtonDown: function() {
        	var activeTabId = tab.getActiveTab().getId();
            if(activeTabId == 'tabGrid1') {
                if(panelResult1.setAllFieldsReadOnly(true) == false){
                    return false;
                } else {
                    masterGrid1.getStore().loadStoreRecords();
                }
            } 
            else if(activeTabId == 'tabGrid2') {
// if(panelResult2.setAllFieldsReadOnly(true) == false){
// return false;
// }
// else {
                    masterGrid2.getStore().loadStoreRecords();
                
            } 
            else {
// if(panelResult3.setAllFieldsReadOnly(true) == false){
// return false;
// }
// else {
	       if(Ext.isEmpty(panelResult3.getValue('WH_CODE')) || Ext.isEmpty(panelResult3.getValue('ITEM_ACCOUNT')))
	    	   {
	    	   alert('필수항목은 입력하십시오.');
	    	   return false;
	    	   }else{
	    		   masterGrid3.getStore().loadStoreRecords();
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

            panelResult3.setAllFieldsReadOnly(false);
            panelResult3.clearForm();
            masterGrid3.reset();
            directMasterStore3.clearData();

			this.fnInitBinding();
		}
	});

};


</script>
