<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_pda020rkrv_kd"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_pda020rkrv_kd"  /> 			<!-- 사업장   -->
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />               <!-- 창고      -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />                         <!-- 차종     -->
    <t:ExtComboStore comboType="AU" comboCode="WB08" />                         <!-- 금형구분 -->
    <t:ExtComboStore comboType="AU" comboCode="WB10" />                         <!-- 위치상태 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" />                         <!-- 품목계정 -->
</t:appConfig>

<script type="text/javascript" >
var settingWindow;
var checkedCount = 0;   // 체크된 레코드
var printData = "";
function appMain() {
    /**
     *   LocationModel 정의
     * @type
     */
    Unilite.defineModel('s_pda020rkrv_kdModel1', {
        fields: [
            {name: 'PRINT_YN'           ,text: '출력'                  ,type: 'boolean'},
            {name: 'ORDER_TYPE'         ,text: '발주형태'              ,type: 'string'},
            {name: 'ORDER_DATE'         ,text: '발주일'                ,type: 'uniDate'},
            {name: 'CUSTOM_CODE'        ,text: '거래처코드'            ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '거래처명'              ,type: 'string'},
            {name: 'ITEM_CODE'          ,text: '품목코드'              ,type: 'string'},
            {name: 'ITEM_NAME'          ,text: '품목명'                ,type: 'string'},
            {name: 'SPEC'               ,text: '규격'                  ,type: 'string'},
            {name: 'OEM_ITEM_CODE'      ,text: '품번'                  ,type: 'string'},
            {name: 'LOT_NO'             ,text: 'LOT번호'               ,type: 'string'},
            {name: 'STOCK_UNIT'         ,text: '재고단위'              ,type: 'string'},
            {name: 'ORDER_NUM'          ,text: '발주번호'              ,type: 'string'},
            {name: 'ORDER_SEQ'          ,text: '발주순번'              ,type: 'int'},
            {name: 'PO_QTY'             ,text: '발주량'              ,type: 'float', decimalPrecision:4,format: "0,000,000.0000"},
            {name: 'QTY'                ,text: '미입고량'                ,type: 'float', allowBlank: true, maxLength: 17, decimalPrecision: 4, format: '0,000,000.0000'},
            {name: 'PRINT_CNT'          ,text: '출력수'                ,type: 'uniQty', allowBlank: false},
            {name: 'DIV_CODE'           ,text: '사업장'                ,type: 'string'},
            {name: 'IN_QTY1'                ,text: '입고량1'                ,type: 'float', allowBlank: false, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY2'                ,text: '입고량2'                ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY3'                ,text: '입고량3'                ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY4'                ,text: '입고량4'                ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY5'                ,text: '입고량5'                ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY6'                ,text: '입고량6'                ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY7'                ,text: '입고량7'                ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY8'                ,text: '입고량8'                ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY9'                ,text: '입고량9'                ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'IN_QTY10'               ,text: '입고량10'              ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'},
            {name: 'ROW_COUNT'               ,text: '로우카운트'              ,type: 'string'},
            {name: 'RECORD_ID'               ,text: '레코드아이디'              ,type: 'string'},
            {name: 'TEMP'               ,text: 'TEMP'              ,type: 'float',  maxLength: 17, decimalPrecision: 4,  maxLength: 17,  format: '0,000,000.0000'}
        ]
    });

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_pda020rkrv_kdMasterStore1',{
            model: 's_pda020rkrv_kdModel1',
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
                    read: 's_pda020rkrv_kdService.selectList1'
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

    var describedPanel = Unilite.createSearchForm('s_pda020rkrv_kdDescribedPanel1',{
        region: 'south',
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
            },
//                {
//                xtype:'container',
//                layout: {type: 'uniTable', columns: 2},
//                items:[{
//                    xtype:'container',
//                    html: '&nbsp;&nbsp;&nbsp;2.&nbsp;라벨출력프로그램을 제품형인경우 C:&nbsp;/&nbsp;OmegaPlusPDA&nbsp;/&nbsp;itemLotLabel1, 원자재형인경우 C:&nbsp;/&nbsp;OmegaPlusPDA&nbsp;/&nbsp;itemLotLabel2 폴더를 생성후, 해당폴더에 압축을 푼다.'
//                }/*,{
//                    margin: '0 0 0 6',
//                    xtype: 'button',
//                    text: '출력 프로그램 다운로드',
//                    handler : function() {
//
//                    }
//                }*/]
//            },
                {
                xtype:'container',
                margin: '10 0 0 20',
                html: '&nbsp;&nbsp;&nbsp;2.&nbsp;위 사항이 준비되었으면 [바코드 출력] 버튼을 클릭하여 출력한다.'
            }]
    });

    var panelPrint1 = Unilite.createForm('printForm1', {
        url: CPATH+'/z_kd/matlPrintBarcode1',
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
        }/* ,{
            xtype: 'button',
            width: 90,
            text: '조회',
            handler : function() {
                if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            } else {
                masterGrid.getStore().loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'],true);
            }
            }
        } */
        ,{
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
                    var myMap = new Map();
                    var data1 = "";
                    var newLotNo = "";


                 //   paramMaster.data = data;


	   				   Ext.each(masterGrid.getSelectedRecords(), function(rec, i){
								  rec.phantom = true;
								  rec.set("RECORD_ID",rec.getId());
			                      buttonStore.insert(i, rec);
	                   });

	   				buttonStore.saveStore();

                   /*  Ext.each(directMasterStore1.data.items, function(record, index){
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
					*/


                    //var jJsonData = JSON.stringify(data);

                    //form.setValue('data',Ext.encode(data)); // Ext.encode(jJsonData));

                    //form.submit();



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
                	masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });


    var panelPrint2 = Unilite.createForm('printForm2', {
        url: CPATH+'/z_kd/matlPrintBarcode2',
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

             	   Ext.each(masterGrid.getSelectedRecords(), function(rec, i){
						  rec.phantom = true;
						  rec.set("RECORD_ID",rec.getId());
	                      buttonStore.insert(i, rec);
            		});

                 /*    Ext.each(directMasterStore1.data.items, function(record, index){
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



                    }); */
                    //var jJsonData = JSON.stringify(data);

                    //form.setValue('data',Ext.encode(data)); // Ext.encode(jJsonData));

                    //form.submit();
					buttonStore.saveStore();

                    setTimeout(function(){
                            directMasterStore1.commitChanges();

                            try{
                                var WshShell = new ActiveXObject("WScript.Shell");
                                WshShell.Run("C:\\OmegaPlusPDA\\itemLotLabel2\\Label.exe", 1);
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
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        }]
    });

	var panelResult = Unilite.createSearchForm('resultForm1',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
//		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },{
                fieldLabel: '발주일',
                startFieldName: 'ORDER_DATE_FR',
                endFieldName: 'ORDER_DATE_TO',
                xtype: 'uniDateRangefield',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                colspan: 3
            },{
                xtype: 'radiogroup',
                fieldLabel: '발주형태',
                id: 'ORDER_TYPE_ID',
                items : [{
                    boxLabel: '내자',
                    name: 'ORDER_FLAG',
                    checked: true,
                    width: 53,
                    inputValue: '1'
                },{
                    boxLabel: '외주',
                    name: 'ORDER_FLAG',
                    width: 53,
                    inputValue: '4'
                },{
                    boxLabel: '수입',
                    name: 'ORDER_FLAG',
                    width: 53,
                    inputValue: 'O'
                }]
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                autoPopup: true,
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                extParam: {'CUSTOM_TYPE': ['1','2']}
            }),{
                fieldLabel: '발주번호',
                xtype: 'uniTextfield',
                name: 'ORDER_NUM'
            },
            panelPrint1,
            panelPrint2,
            {
                xtype: 'radiogroup',
                fieldLabel: '양식선택',
                id: 'GUBUN',
                colspan: 3,
                items : [{
                    boxLabel: '제품형',
                    name: 'STATUS',
                    checked: true,
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
                
            },{
               xtype:'container',
                width: 1000,
                margin: '30 0 0 20',
                html: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※새로운 LOT NO를 적용하기 위해서는 LOT NO를 지우고 출력하세요.'
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
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('s_pda020rkrv_kdGrid1', {
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
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false, mode: 'MULTI' ,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ) {

                	UniAppManager.setToolbarButtons(['save'], false);
                    checkedCount = checkedCount + 1;
                    selectRecord.set('PRINT_YN' , true);
                    panelResult.setValue('COUNT', checkedCount);
                    if(panelResult.getValue('COUNT') > 0) {
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
                    panelResult.setValue('COUNT', checkedCount);
                    if(panelResult.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn1').setDisabled(false);
                        Ext.getCmp('printBtn2').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn1').setDisabled(true);
                        Ext.getCmp('printBtn2').setDisabled(true);
                    }
                },selectionchange:function ( grid, selectRecord, eOpts ){

                	//Ext.getCmp('s_pda020rkrv_kdGrid1').getSelectionModel().deselect(1);
            	}
            }
        }),
        columns:  [
            { dataIndex: 'PRINT_YN'                       ,           width: 70, hidden: true, locked:true /*xtype : 'checkcolumn', align: 'center',
                listeners:{
                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
                        var grdRecord = masterGrid.getStore().getAt(rowIndex);
                        if(checked == true) {
                            UniAppManager.setToolbarButtons(['save'], false);
                            checkedCount = checkedCount + 1;
                            panelResult.setValue('COUNT', checkedCount);
                            if(panelResult.getValue('COUNT') > 0) {
                                Ext.getCmp('printBtn1').setDisabled(false);
                                Ext.getCmp('printBtn2').setDisabled(false);
                            } else {
                            	Ext.getCmp('printBtn1').setDisabled(true);
                                Ext.getCmp('printBtn2').setDisabled(true);
                            }
                        } else {
                            UniAppManager.setToolbarButtons(['save'], false);
                            checkedCount = checkedCount - 1;
                            panelResult.setValue('COUNT', checkedCount);
                            if(panelResult.getValue('COUNT') > 0) {
                                Ext.getCmp('printBtn1').setDisabled(false);
                                Ext.getCmp('printBtn2').setDisabled(false);
                            } else {
                                Ext.getCmp('printBtn1').setDisabled(true);
                                Ext.getCmp('printBtn2').setDisabled(true);
                            }
                        }
                    }
                }*/
            },
            { dataIndex: 'ORDER_TYPE'                     ,           width: 70, locked:true, hidden: true},
            { dataIndex: 'ORDER_DATE'                     ,           width: 80, locked:true},
            { dataIndex: 'CUSTOM_CODE'                    ,           width: 90, locked:true},
            { dataIndex: 'CUSTOM_NAME'                    ,           width: 120, locked:true},
            { dataIndex: 'ITEM_CODE'                      ,           width: 80, locked:true},
            { dataIndex: 'ITEM_NAME'                      ,           width: 130},
            { dataIndex: 'SPEC'                           ,           width: 100},
            { dataIndex: 'OEM_ITEM_CODE'                  ,           width: 150, hidden:true},
            { dataIndex: 'LOT_NO'                         ,           width: 100},
            { dataIndex: 'STOCK_UNIT'                     ,           width: 70},
            { dataIndex: 'ORDER_NUM'                      ,           width: 100},
            { dataIndex: 'ORDER_SEQ'                      ,           width: 70},
            { dataIndex: 'PO_QTY'                         ,           width: 80},
            { dataIndex: 'QTY'                            ,           width: 80},
            { dataIndex: 'PRINT_CNT'                      ,           width: 70},
            { dataIndex: 'DIV_CODE'                       ,           width: 100, hidden: true},
            { dataIndex: 'IN_QTY1'                            ,           width: 80},
            { dataIndex: 'IN_QTY2'                            ,           width: 80},
            { dataIndex: 'IN_QTY3'                            ,           width: 80},
            { dataIndex: 'IN_QTY4'                            ,           width: 80},
            { dataIndex: 'IN_QTY5'                            ,           width: 80},
            { dataIndex: 'IN_QTY6'                            ,           width: 80},
            { dataIndex: 'IN_QTY7'                            ,           width: 80},
            { dataIndex: 'IN_QTY8'                            ,           width: 80},
            { dataIndex: 'IN_QTY9'                            ,           width: 80},
            { dataIndex: 'IN_QTY10'                           ,           width: 80}


        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                    if(UniUtils.indexOf(e.field, ['LOT_NO', 'PRINT_CNT', 'IN_QTY1', 'IN_QTY2', 'IN_QTY3', 'IN_QTY4', 'IN_QTY5', 'IN_QTY6', 'IN_QTY7', 'IN_QTY8', 'IN_QTY9', 'IN_QTY10'])) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['LOT_NO', 'PRINT_CNT', 'IN_QTY1', 'IN_QTY2', 'IN_QTY3', 'IN_QTY4', 'IN_QTY5', 'IN_QTY6', 'IN_QTY7', 'IN_QTY8', 'IN_QTY9', 'IN_QTY10'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            },
            edit: function(editor, e) { console.log(e);
            	//masterGrid.getSelectionModel().select(e.rowIdx);

               var fieldName = e.field;
				 if(fieldName == "IN_QTY1"){
				     if (e.originalValue != e.value) {
				    	 e.record.set("TEMP",e.originalValue);
				     }
					 var records = directMasterStore1.data.items;
				     data = new Object();
				     data.records = [];
				     Ext.each(records, function(record, i){
				      if(record.get('IN_QTY1') != record.get('TEMP')) {
				      	 data.records.push(record);

				     	}
				     });
				      masterGrid.getSelectionModel().select(data.records);

			 	}
            }

        }
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

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_pda020rkrv_kdService.createBarcode',
			syncAll	: 's_pda020rkrv_kdService.createBarcodeData'
		}
	});



  //라벨 출력 후, 해당 데이터 저장을 위한 Store
	var buttonStore = Unilite.createStore('s_pda020rkrv_kdButtonStore',{
		uniOpt: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy		: directButtonProxy,
		saveStore	: function(buttonFlag) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					useSavedMessage : false,
					success : function(batch, option) {
						var master = batch.operations[0].getResultSet();

						printData = master.DESC;
						 if(Ext.getCmp('GUBUN').getValue().STATUS == '1') {

							 writeFile("itemLotLabel1.txt", printData)
	                     } else {

	                    	 writeFile("itemLotLabel2.txt", printData)
	                     }

						//return 값 저장

						buttonStore.clearData();
					 },

					 failure: function(batch, option) {

						buttonStore.clearData();

					 }
				};
				this.syncAllDirect(config);
			} else {
				/* var grid = Ext.getCmp('s_pmp111ukrv_ypMasterGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs); */
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {

			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
    Unilite.Main( {
		borderItems:[{
    			region:'center',
    			layout: 'border',
    			border: false,
    			items:[
                    panelResult, masterGrid
                ]
    		}, describedPanel
		],
		fnInitBinding: function(params) {
		    panelResult.setValue('PRINT_Q', '1');
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
            panelResult.setValue('COUNT', '');
            Ext.getCmp('printBtn1').setDisabled(true);
            Ext.getCmp('printBtn2').setDisabled(true);
//            panelResult.setValue('STATUS', '2');
//            panelResult.setValue('STATUS', '1');
            UniAppManager.setToolbarButtons(['save'], false);
//            if(Ext.getCmp('GUBUN').getChecked()[0].inputValue =='1') {
//                Ext.getCmp('printForm1').setVisible(true);
//                Ext.getCmp('printForm2').setVisible(false);
//            } else {
//                Ext.getCmp('printForm2').setVisible(true);
//                Ext.getCmp('printForm1').setVisible(false);
//            }
            this.setDefault();
		},
        onQueryButtonDown: function() {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            } else {
                masterGrid.getStore().loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'],true);
            }
        },
		onResetButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
        setDefault: function() {
            Ext.getCmp('printForm1').setVisible(true);
            Ext.getCmp('printForm2').setVisible(false);
        }
	});

};


</script>
