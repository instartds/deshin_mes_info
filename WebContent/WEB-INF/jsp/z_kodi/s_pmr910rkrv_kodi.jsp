<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr910rkrv_kodi">
    <t:ExtComboStore comboType="BOR120" />
    <style type="text/css">
        #search_panel1 .x-panel-header-text-container-default {
            color: #333333;
            font-weight: normal;
            padding: 1px 2px;
        }
    </style>
</t:appConfig>
<script type="text/javascript">
var BsaCodeInfo = {
	gsReportGubun : '${gsReportGubun}'	// 레포트 구분
};
// 소박스 /대박스 항목 값  
var SmallBigGubun = {
	/* 소박스 */
	gsSmallBoxBarcode  : '',    // Box code
	gsUnitWgt          : '',    // 중량
	gsWgtUnit          : '',    // 중량 단위
	gsRemark1          : '',    // PCB
	
	/* 대박스 */
	gsBigBoxBarcode    : '',    // Box code
	gsUnitVol          : '',    // 중량
	gsVolUnit          : '',    // 중량 단위
	gsRemark2          : ''    // PCB	
};
    function appMain() {

        var panelResult = Unilite.createSearchForm('resultForm', {
            region: 'center',
            layout: { 
                type: 'uniTable',
                columns: 1
            },
            padding: '1 1 1 1',
            border: true,
            items: [{
                fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank: false,
                value: UserInfo.divCode
            }, {
            	xtype: 'container',
				layout:{type:'uniTable',columns:2},
				items:[{
	                xtype: 'radiogroup',
	                fieldLabel: '출력양식',
	                id: 'rdoSelect',
	                items: [{
	                    boxLabel: '소박스',
	                    width: 100,
	                    name: 'RDO_SELECT',
	                    inputValue: '1',
	                    checked: true
	                }, {
	                    boxLabel: '대박스',
	                    width: 100,
	                    inputValue: '2',
	                    name: 'RDO_SELECT'
	                }],
	                // 20210225 : 출력양식 change 이벤트 추가
	                listeners: {
	                	change: function(field, newValue, oldValue, eOpts){
							// 소박스
	                		if(newValue.RDO_SELECT == '1'){
								panelResult.setValue('SMALL_BIG_BOX_BARCODE',SmallBigGubun.gsSmallBoxBarcode);// Box code
								panelResult.setValue('UNIT_WGT_VOL'         ,SmallBigGubun.gsUnitWgt);        // 중량
								panelResult.setValue('WGT_VOL_UNIT'         ,SmallBigGubun.gsWgtUnit);        // 중량 단위
								panelResult.setValue('REMARK'               ,SmallBigGubun.gsRemark1);        // PCB
							// 대박스
							} else {
								panelResult.setValue('SMALL_BIG_BOX_BARCODE',SmallBigGubun.gsBigBoxBarcode);  // Box code
								panelResult.setValue('UNIT_WGT_VOL'         ,SmallBigGubun.gsUnitVol);        // 중량
								panelResult.setValue('WGT_VOL_UNIT'         ,SmallBigGubun.gsVolUnit);        // 중량 단위
								panelResult.setValue('REMARK'               ,SmallBigGubun.gsRemark2);        // PCB
							}
	                	}
	                }
	            }, {
	            	fieldLabel: '출력매수',
	                xtype: 'uniNumberfield',
	                name: 'PRINT_Q',
                	allowBlank: false,
	                width: 150
	            }]
            },
            Unilite.popup('DIV_PUMOK', { 
				fieldLabel: '품번', 
				valueFieldName: 'ITEM_CODE',
		   	 	textFieldName: 'ITEM_NAME',
				allowBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							/* 소박스 */
							SmallBigGubun.gsSmallBoxBarcode = records[0]["SMALL_BOX_BARCODE"]; // Box code
							SmallBigGubun.gsUnitWgt         = records[0]["UNIT_WGT"]; // 중량
							SmallBigGubun.gsWgtUnit         = records[0]["WGT_UNIT"]; // 중량 단위
							SmallBigGubun.gsRemark1         = records[0]["REMARK1"]; // PCB
							
							/* 대박스 */
							SmallBigGubun.gsBigBoxBarcode   = records[0]["BIG_BOX_BARCODE"]; // Box code
							SmallBigGubun.gsUnitVol         = records[0]["UNIT_VOL"]; // 중량
							SmallBigGubun.gsVolUnit         = records[0]["VOL_UNIT"]; // 중량 단위
							SmallBigGubun.gsRemark2         = records[0]["REMARK2"]; // PCB
	
							
							if(panelResult.getField('RDO_SELECT').getValue("1")){
								panelResult.setValue('SMALL_BIG_BOX_BARCODE',records[0]["SMALL_BOX_BARCODE"]);
								panelResult.setValue('UNIT_WGT_VOL',records[0]["UNIT_WGT"]);
								panelResult.setValue('WGT_VOL_UNIT',records[0]["WGT_UNIT"]);
								panelResult.setValue('REMARK',records[0]["REMARK1"]);
							
							}else{
								panelResult.setValue('SMALL_BIG_BOX_BARCODE',records[0]["BIG_BOX_BARCODE"]);
								panelResult.setValue('UNIT_WGT_VOL',records[0]["UNIT_VOL"]);
								panelResult.setValue('WGT_VOL_UNIT',records[0]["VOL_UNIT"]);
								panelResult.setValue('REMARK',records[0]["REMARK2"]);
							}
							panelResult.setValue('NAME',records[0]["ITEM_NAME"]);
							panelResult.setValue('ITEM_MAKER_PN',records[0]["ITEM_MAKER_PN"]);
							panelResult.setValue('BARCODE',records[0]["BARCODE"]);
							
							panelResult.getField('PACK_DATE').focus();
							panelResult.getField('PACK_DATE').blur();
	                	},
						scope: this
					},
					onClear: function(type)	{
							panelResult.setValue('NAME','');
							panelResult.setValue('SMALL_BIG_BOX_BARCODE','');
							panelResult.setValue('UNIT_WGT_VOL','');
							panelResult.setValue('WGT_VOL_UNIT', null); // 20210225 초기화 추가
							panelResult.setValue('REMARK','');
							panelResult.setValue('ITEM_MAKER_PN','');
							panelResult.setValue('BARCODE','');
							
							// 20210225 초기화 추가
							/* 소박스 */
							SmallBigGubun.gsSmallBoxBarcode = ''; // Box code
							SmallBigGubun.gsUnitWgt         = ''; // 중량
							SmallBigGubun.gsWgtUnit         = ''; // 중량 단위
							SmallBigGubun.gsRemark1         = ''; // PCB
							
							/* 대박스 */
							SmallBigGubun.gsBigBoxBarcode   = ''; // Box code
							SmallBigGubun.gsUnitVol         = ''; // 중량
							SmallBigGubun.gsVolUnit         = ''; // 중량 단위
							SmallBigGubun.gsRemark2         = ''; // PCB
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
            {
            	fieldLabel: '영문명',
                xtype: 'uniTextfield',
                name: 'NAME',
                width: 455
            },{
            	fieldLabel: 'BOX Code',
                xtype: 'uniTextfield',
                name: 'SMALL_BIG_BOX_BARCODE'
            },{
            	fieldLabel: 'PCB',
                xtype: 'uniTextfield',
                name: 'REMARK'
            },{
            	fieldLabel: 'LOT NO',
                xtype: 'uniTextfield',
                name: 'LOT_NO',
		     	allowBlank: false
            },{
            	
		        fieldLabel: '포장일자',
		        name: 'PACK_DATE',
		        xtype: 'uniDatefield',
//		       	value: UniDate.get('today'),
		     	allowBlank: false,
				listeners: {
					blur: function(field, The, eOpts){
						
						if(!Ext.isEmpty(panelResult.getValue('ITEM_CODE'))){
							if(!Ext.isEmpty(field.getValue())){
								var param = panelResult.getValues();
								pmp260ukrvService.selectExpirationdate(param, function(provider, response) {
									if(!Ext.isEmpty(provider) && provider.EXPIRATION_DAY != 0)	{

										panelResult.setValue('MAKE_EXP_DATE',UniDate.getDbDateStr(UniDate.add(field.getValue(), {months: + provider.EXPIRATION_DAY , days:-1})));
									}else{
										//alert('유효기간을 설정하지 않은 품목입니다. 유효기간을 설정해주세요.');
										panelResult.setValue('MAKE_EXP_DATE', '');
									}
								});
							}
						}else{
							Unilite.messageBox('품번을 입력해주세요');
						}
						
					}
				}
            },{
            	
		        fieldLabel: '사용기한',
		        name: 'MAKE_EXP_DATE',
		        xtype: 'uniDatefield',
//		       	value: UniDate.get('today'),
		     	allowBlank: false
            },{
            	xtype: 'container',
				layout:{type:'uniTable',columns:2},
				items:[{
	            	fieldLabel: '중량',
	                xtype: 'uniTextfield',
	                name: 'UNIT_WGT_VOL',
	                width:170
	            },{
	            	fieldLabel: '',
	                name: 'WGT_VOL_UNIT',
	                xtype:'uniCombobox' ,
	                comboType:'AU', 
	                comboCode:'B013', 
	                displayField: 'value',
	                width:75
	            }]
            },{
            	fieldLabel: '업체고유코드',
                xtype: 'uniTextfield',
                name: 'ITEM_MAKER_PN'
            },{
            	fieldLabel: 'Material EAN',
                xtype: 'uniTextfield',
                name: 'BARCODE'
            },{
				xtype:'button',
				text:'라벨출력',
				disabled:false,
				width: 150,
				margin: '50 0 0 95',
				handler: function(){
	                if(!panelResult.getInvalidMessage()) return;   //필수체크
	                var param = panelResult.getValues();
	                
		            param["USER_LANG"] = UserInfo.userLang;
		            param["PGM_ID"]= PGM_ID;
		            param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
	                param["sTxtValue2_fileTitle"]='';
	                
	                var win = null;
					win = Ext.create('widget.ClipReport', {
						url: CPATH+'/z_kodi/s_pmr910clrkrv_kodi.do',
						prgID: 's_pmr910rkrv_kodi',
						extParam: param
					});
					win.center();
					win.show();
				}
        	}]
        });


        Unilite.Main({
            borderItems: [{
                region: 'center',
                layout: 'border',
                border: false,
                items: [
                    panelResult
                ]
            }],
            id: 's_pmr910rkrv_kodiApp',
            fnInitBinding: function () {
                panelResult.setValue('DIV_CODE', UserInfo.divCode);
                panelResult.getField('RDO_SELECT').setValue("1");
                UniAppManager.setToolbarButtons(['query','print'], false);
            },
            onResetButtonDown: function () {
                panelResult.clearForm();
                this.fnInitBinding();
            },
            onPrintButtonDown: function () {
            },
        	onDirectPrintButtonDown: function() {
        	}
        });  
    };
</script>