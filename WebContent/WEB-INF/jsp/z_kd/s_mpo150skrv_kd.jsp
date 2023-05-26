<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo150skrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts="2;6"/> <!-- 생성경로 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var isLastMail = false;
	/**
	 *   Model 정의
	 * @type
	 */

	Unilite.defineModel('S_mpo150skrv_kdModel', {
	    fields: [
	    	{name: 'CHOICE'             		   ,text: '선택' 			,type: 'string'},
	    	{name: 'MAIL_YN'            		   ,text: '전송여부' 		,type: 'string', comboType:'AU', comboCode:'B010'},
	    	{name: 'AGREE_STATUS_CD'    		   ,text: '승인여부' 		,type: 'string'},
	    	{name: 'AGREE_STATUS_NM'    		   ,text: '승인여부' 		,type: 'string'},
	    	{name: 'CREATE_LOC'    		           ,text: '생성경로' 		,type: 'string', comboType:'AU', comboCode:'B031'},
	    	{name: 'ORDER_NUM'          		   ,text: '발주번호' 		,type: 'string'},
	    	{name: 'ORDER_DATE'         		   ,text: '발주일' 		,type: 'uniDate'},
	    	{name: 'CUSTOM_NAME'        		   ,text: '거래처' 		,type: 'string'},
	    	{name: 'ORDER_PRSN'         		   ,text: '구매담당' 		,type: 'string'},
	    	{name: 'ORDER_TYPE'         		   ,text: '발주형태' 		,type: 'string'},
	    	{name: 'ORDER_O'            		   ,text: '발주금액' 		,type: 'uniPrice'},
	    	{name: 'MONEY_UNIT'         		   ,text: '화폐' 			,type: 'string'},
	    	{name: 'EXCHG_RATE_O'       		   ,text: '환율' 			,type: 'uniER'},
	    	{name: 'RECEIPT_TYPE'       		   ,text: '결제방법' 		,type: 'string'},
	    	{name: 'REMARK'             		   ,text: '비고' 			,type: 'string'},
	    	{name: 'LC_NUM'             		   ,text: 'L/C번호' 		,type: 'string'},
	    	{name: 'PROJECT_NO'         		   ,text: '프로젝트 번호'   ,type: 'string'},
	    	{name: 'CUST_PRSN_NAME'                ,text: '거래처담당자'   ,type: 'string', allowBlank: false},
	    	{name: 'CUST_MAIL_ID'         		   ,text: '담당자e-mail' 		,type: 'string', allowBlank: false},
	    	{name: 'EDIT_FLAG'                     ,text: 'EDIT_FLAG'   ,type: 'string'},
	    	{name: 'CONTENTS'                      ,text: 'CONTENTS'   ,type: 'string'},
	    	{name: 'FROM_EMAIL'                    ,text: 'FROM_EMAIL'   ,type: 'string'},
	    	{name: 'FROM_NAME'                     ,text: 'FROM_NAME'   ,type: 'string'},
	    	{name: 'SUBJECT'                       ,text: 'SUBJECT'   ,type: 'string'},
	    	{name: 'DIV_CODE'                      ,text: 'DIV_CODE'   ,type: 'string'},
	    	{name: 'CUSTOM_CODE'                   ,text: 'CUSTOM_CODE'   ,type: 'string'},
	    	{name: 'KOR_FROM'                      ,text: 'KOR_FROM'   ,type: 'string'},
	    	{name: 'ENG_FROM'                   ,text: 'ENG_FROM'   ,type: 'string'},
	    	{name: 'ORDER_PRSN_DEPT'                   ,text: 'ORDER_PRSN_DEPT'   ,type: 'string'},
	    	{name: 'EN_ORDER_DATE'                   ,text: '영문발주일'   ,type: 'string'}
		]
	});

	Unilite.defineModel('S_mpo150skrv_kdModel2', {
        fields: [
            {name: 'ORDER_SEQ'                     ,text: '순번'          ,type: 'string'},
            {name: 'ITEM_CODE'                     ,text: '품목코드'        ,type: 'string'},
            {name: 'ITEM_NAME'                     ,text: '품명'          ,type: 'string'},
            {name: 'SPEC'                          ,text: '규격'          ,type: 'string'},
            {name: 'STOCK_UNIT'                    ,text: '재고단위'        ,type: 'string'},
            {name: 'ORDER_UNIT_Q'                  ,text: '발주량'         ,type: 'uniQty'},
            {name: 'ORDER_UNIT'                    ,text: '구매단위'        ,type: 'string'},
            {name: 'UNIT_PRICE_TYPE'               ,text: '단가형태'        ,type: 'string'},
            {name: 'ORDER_UNIT_P'                  ,text: '단가'          ,type: 'uniUnitPrice'},
            {name: 'ORDER_O'                       ,text: '금액'          ,type: 'uniPrice'},
            {name: 'DVRY_DATE'                     ,text: '납기일'         ,type: 'uniDate'},
            {name: 'WH_CODE'                       ,text: '납품창고'        ,type: 'string'},
            {name: 'TRNS_RATE'                     ,text: '변환계수'        ,type: 'string'},
            {name: 'ORDER_Q'                       ,text: '재고단위량'       ,type: 'uniQty'},
            {name: 'CONTROL_STATUS'                ,text: '진행상태'        ,type: 'string'},
            {name: 'ORDER_REQ_NUM'                 ,text: '발주예정번호'  ,type: 'string'},
            {name: 'INSPEC_FLAG'                   ,text: '품질검사여부'  ,type: 'string'},
            {name: 'REMARK'                        ,text: '비고'          ,type: 'string'},
    	    	{name: 'EN_DVRY_DATE'                  ,text: '영문납기일'   ,type: 'string'}            
        ]
    });

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read: 's_mpo150skrv_kdService.selectList'
        }
    });
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_mpo150skrv_kdMasterStore1',{
		model: 'S_mpo150skrv_kdModel',
		uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: true,			    // 수정 모드 사용
        	deletable: false,			// 삭제 가능 여부
            useNavi : false			    // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.MAIL_FORMAT =  inputTable.getValue("MAIL_FORMAT").MAIL_FORMAT;
			console.log( param );
			this.load({
				params : param
			});
		},
        saveStore : function()  {
            var inValidRecs = this.getInvalidRecords();
            if(inValidRecs.length == 0 )    {
                var config = {
                    params:[inputTable.getValues()],
                    success : function()    {
                        alert('처리되었습니다. 결과는 메일발송현황 화면에서 확인하세요.');
                    }
                }
                this.syncAllDirect(config);
            }else {
                masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
	});

	var directMasterStore2 = Unilite.createStore('s_mpo150skrv_kdMasterStore2',{
			model: 'S_mpo150skrv_kdModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable: false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 's_mpo150skrv_kdService.selectList2'
                }
            },
            loadStoreRecords : function(param)	{
				var param= param;

        param.MAIL_FORMAT =  inputTable.getValue("MAIL_FORMAT").MAIL_FORMAT;
				
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	// MAIL STORE

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
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items:[{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.popup('CUST', {
                fieldLabel: '거래처',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                extParam: {'CUSTOM_TYPE': ['1','2']},
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                            panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('CUSTOM_CODE', '');
                        panelResult.setValue('CUSTOM_NAME', '');
                    }
                }
            }),{
                fieldLabel: '발주일',
                xtype: 'uniDateRangefield',
                startFieldName: 'ORDER_DATE_FR',
                endFieldName: 'ORDER_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('ORDER_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('ORDER_DATE_TO',newValue);
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: '재전송',
                id: 'MAIL_YN',
                items: [{
                    boxLabel: '포함',
                    width:60,
                    name: 'MAIL_YN',
                    inputValue: '1',
                    checked: true
                },{
                    boxLabel: '포함하지 않음',
                    width:100,
                    name: 'MAIL_YN',
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('MAIL_YN').setValue(newValue.MAIL_YN);
                    }
                }
            },{
				fieldLabel: '생성경로',
				name:'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B031',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('CREATE_LOC', newValue);
                    }
                }
			},
			//{
			//	fieldLabel: '발주형태',
			//	name:'ORDER_TYPE',
			//	xtype: 'uniCombobox',
			//	comboType: 'AU',
			//	comboCode: 'M001',
             //   listeners: {
             //       change: function(field, newValue, oldValue, eOpts) {
             //           panelResult.setValue('ORDER_TYPE', newValue);
             //       }
             //   }
			//}
			{
				fieldLabel: '구매담당',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M201',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ORDER_PRSN', newValue);
                    }
                }
			}]
		}],
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

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        hidden: !UserInfo.appOption.collapseLeftSearch,
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },
        Unilite.popup('CUST', {
            fieldLabel: '거래처',
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
            extParam: {'CUSTOM_TYPE': ['1','2']},
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                        panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('CUSTOM_CODE', '');
                    panelSearch.setValue('CUSTOM_NAME', '');
                }
            }
        }),{
            fieldLabel: '발주일',
            xtype: 'uniDateRangefield',
            startFieldName: 'ORDER_DATE_FR',
            endFieldName: 'ORDER_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('ORDER_DATE_FR',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('ORDER_DATE_TO',newValue);
                }
            }
        },{
            xtype: 'radiogroup',
            fieldLabel: '재전송',
            id: 'MAIL_YN2',
            items: [{
                boxLabel: '포함',
                width:60,
                name: 'MAIL_YN',
                inputValue: '1',
                checked: true
            },{
                boxLabel: '포함하지 않음',
                width:100,
                name: 'MAIL_YN',
                inputValue: '2'
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.getField('MAIL_YN').setValue(newValue.MAIL_YN);
                }
            }
            },{
				fieldLabel: '생성경로',
				name:'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B031',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('CREATE_LOC', newValue);
                    }
                }
			},
			//{
			//	fieldLabel: '발주형태',
			//	name:'ORDER_TYPE',
			//	xtype: 'uniCombobox',
			//	comboType: 'AU',
			//	comboCode: 'M001',
             //   listeners: {
             //       change: function(field, newValue, oldValue, eOpts) {
             //           panelResult.setValue('ORDER_TYPE', newValue);
             //       }
             //   }
			//}
          {
            fieldLabel: '구매담당',
            name:'ORDER_PRSN',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'M201',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ORDER_PRSN', newValue);
                }
            }
        }],
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

    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 3},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
        region: 'center',
        masterGrid: masterGrid1,
        items: [{
                fieldLabel: '제목',
                xtype: 'uniTextfield',
                name: 'SUBJECT',
                width: 560,
                allowBlank: false,
                colspan: 2
            }, {
                fieldLabel: '메일양식구분',
                name: 'MAIL_FORMAT',
                id: 'formGubun',
                xtype: 'uniRadiogroup',
                allowBlank: false,
                colspan:2,
                labelWidth: 150,
                layout: {type: 'table', columns:2},
                items: [
                    {
                        boxLabel  : '한글',
                        name      : 'MAIL_FORMAT',
                        inputValue: 'K',
                        width: 60,
                        checked: true
                    }, {
                        boxLabel  : '영문',
                        name      : 'MAIL_FORMAT',
                        inputValue: 'E'
                    }
                ]
            },{
                fieldLabel: '발송자e-mail',
                xtype: 'uniTextfield',
                name: 'FROM_EMAIL',
                width: 280,
                allowBlank:false

            },{
                fieldLabel: '발송자',
                xtype: 'uniTextfield',
                name: 'FROM_NAME',
                width: 280,
                allowBlank:false
            }/*,{
                fieldLabel: '이메일 비밀번호 ',
                xtype: 'uniTextfield',
                labelWidth: 120,
                name: 'EMAIL_PASS',
                allowBlank:false,
                inputType: 'password',
                maxLength : 20,
                enforceMaxLength : true
            }*//*,{
                xtype: 'textareafield',
                name: 'CONTENTS',
                hidden: false
            },{
                xtype: 'button',
                text: '메일전송',
                id: 'SEND_MAIL',
                name: '',
                tdAttrs: {align: 'right'},
                width: 90,
                handler : function(grid, record) {
                	UniAppManager.app.checkForNewDetail();
                }
            }*/],
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
                    });
                }
                return r;
            }
    });


    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid1 = Unilite.createGrid('s_mpo150skrv_kdGrid1', {
    	// for tab
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    onLoadSelectFirst : false
        },
        tbar: [{
            id : 'sendBtn',
            text:'메일전송',
            handler: function() {
            	if(masterGrid1.getSelectedRecords().length > 0){
                    if(!inputTable.getInvalidMessage()) return;
            		var masterRecord = masterGrid1.getSelectedRecords();
                    var sCnt = 0;
                    var fCnt = 0;
                    Ext.each(masterRecord, function(rec, i){
                        if(!Ext.isEmpty(rec.get('CUST_MAIL_ID'))){ //이메일 존재 레코드
                           sCnt++;
                           rec.phantom = true;
                        }else{
                           fCnt++;
                        }
                    });
                    var inValidRecs = directMasterStore1.getInvalidRecords();
                    if(inValidRecs.length == 0 )    {
                    	if(confirm('발송가능: ' + sCnt + '건' + ' / 발송불가능: ' +  fCnt + '건' + '\n발송 하시겠습니까?')){
                            Ext.each(masterRecord, function(rec, i){
                            	if(masterRecord.length == i + 1){
                                    isLastMail = true;
                                }
                            	if(Ext.getCmp('formGubun').getChecked()[0].inputValue == "K"){
//                            		UniAppManager.app.makeContents(rec)
                            	   UniAppManager.app.makeContents_kr(rec);
                            	}else{
//                            		UniAppManager.app.makeContents(rec)
                            	   UniAppManager.app.makeContents_en(rec);
                            	}
                            });
                        }
                    }else {
                        masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
                    }
            	}
            }
         }],
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
       	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ) {
                	Ext.getCmp('sendBtn').setDisabled(false);
                	selectRecord.set('EDIT_FLAG', 'Y');
                },

                deselect:  function(grid, selectRecord, index, rowIndex, eOpts ) {
                    if(masterGrid1.getSelectedRecords().length == 0){
                        Ext.getCmp('sendBtn').setDisabled(true);
                    }
                    selectRecord.set('EDIT_FLAG', '');
                }
            }
        }),
        columns:  [
       		 { dataIndex: 'CHOICE'          			  , 	width:53, hidden: true},
       		 { dataIndex: 'MAIL_YN'         			  , 	width:80, align:'center'},
       		 { dataIndex: 'AGREE_STATUS_CD' 			  , 	width:66,hidden:true},
       		 { dataIndex: 'AGREE_STATUS_NM' 			  , 	width:80, align:'center'},
       		 { dataIndex: 'ORDER_NUM'       			  , 	width:100},
       		 { dataIndex: 'CREATE_LOC'      			  , 	width:80, hidden: true},
       		 { dataIndex: 'ORDER_DATE'      			  , 	width:90, align:'center'},
       		 { dataIndex: 'CUSTOM_NAME'     			  , 	width:200},
       		 { dataIndex: 'ORDER_PRSN'      			  , 	width:80},
       		 { dataIndex: 'ORDER_TYPE'      			  , 	width:80},
       		 { dataIndex: 'ORDER_O'         			  , 	width:80},
       		 { dataIndex: 'MONEY_UNIT'      			  , 	width:80, align:'center'},
       		 { dataIndex: 'EXCHG_RATE_O'    			  , 	width:80},
       		 { dataIndex: 'RECEIPT_TYPE'    			  , 	width:80, align:'center'},
       		 { dataIndex: 'REMARK'          			  , 	width:100},
       		 { dataIndex: 'LC_NUM'          			  , 	width:80},
       		 { dataIndex: 'PROJECT_NO'      			  , 	width:100},
       		 { dataIndex: 'CUST_PRSN_NAME'                ,     width:100},
       		 { dataIndex: 'CUST_MAIL_ID'      			  , 	width:250},
       		 { dataIndex: 'EDIT_FLAG'                     ,     width:300, hidden: true},
       		 { dataIndex: 'KOR_FROM'      			  , 	width:150, hidden: true},
       		 { dataIndex: 'ENG_FROM'                     ,     width:150, hidden: true},
       		 { dataIndex: 'ORDER_PRSN_DEPT'              ,     width:150, hidden: true},
       		 { dataIndex: 'EN_ORDER_DATE'              ,     width:150, hidden: true}
		],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
            	if(e.record.get('EDIT_FLAG') != "Y"){
            	   return false;
            	}
            	if(e.field=='CUST_MAIL_ID' || e.field=='CUST_PRSN_NAME') {
            		return true;
            	}
            	else {
            		return false;
            	}
            },
            selectionchange:function( model, selected, eOpts ){
            	var record = selected[0];
            	if(Ext.isEmpty(record)) return false;
                var param= panelSearch.getValues();
                param.ORDER_NUM  = record.data.ORDER_NUM;
                param.CREATE_LOC = record.data.CREATE_LOC;
                directMasterStore2.loadStoreRecords(param);
            }
        }
    });

        var masterGrid2 = Unilite.createGrid('s_mpo150skrv_kdGrid2', {
    	// for tab
        layout : 'fit',
        region:'south',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: directMasterStore2,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
//               		 { dataIndex: 'ORDER_SEQ'      			  , 	width:66},
               		 { dataIndex: 'ITEM_CODE'      			  , 	width:100},
               		 { dataIndex: 'ITEM_NAME'      			  , 	width:200},
               		 { dataIndex: 'SPEC'           			  , 	width:100},
               		 { dataIndex: 'STOCK_UNIT'     			  , 	width:80, align:'center'},
               		 { dataIndex: 'ORDER_UNIT_Q'   			  , 	width:80},
               		 { dataIndex: 'ORDER_UNIT'     			  , 	width:80, align:'center'},
               		 { dataIndex: 'UNIT_PRICE_TYPE'			  , 	width:80, align:'center'},
               		 { dataIndex: 'ORDER_UNIT_P'   			  , 	width:80},
               		 { dataIndex: 'ORDER_O'        			  , 	width:100},
               		 { dataIndex: 'DVRY_DATE'      			  , 	width:100, align:'center'},
               		 { dataIndex: 'WH_CODE'        			  , 	width:80,hidden:true},
               		 { dataIndex: 'TRNS_RATE'      			  , 	width:80},
               		 { dataIndex: 'ORDER_Q'        			  , 	width:85},
               		 { dataIndex: 'CONTROL_STATUS' 			  , 	width:80, hidden:true},
               		 { dataIndex: 'ORDER_REQ_NUM'  			  , 	width:100},
               		 { dataIndex: 'INSPEC_FLAG'    			  , 	width:100, align:'center'},
               		 { dataIndex: 'REMARK'         			  , 	width:133},
               		 { dataIndex: 'EN_DVRY_DATE'         			  , 	width:133, hidden:true}               		 
		]
    });
    Unilite.Main( {
		borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[/*{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid1]
                    },{
                        region : 'south',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid2]
                    },*/
                    masterGrid1, masterGrid2, panelResult,
                    {
                        region : 'north',
                        xtype : 'container',
                        highth: 20,
                        layout : 'fit',
                        items : [ inputTable ]
                    }
                ]
            },
            panelSearch
        ],
		id  : 's_mpo150skrv_kdApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			inputTable.setValue('SUBJECT', '발주서');
			inputTable.setValue('FROM_NAME', '${gsUserId}');
			inputTable.setValue('FROM_EMAIL', '${gsMailAddr}');
//			inputTable.setValue('EMAIL_PASS', '${gsMailPass}');
            Ext.getCmp('sendBtn').setDisabled(true);
//            alert('${pageContext.request.scheme}' + '://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}' + '${pageContext.request.contextPath}');

		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
			masterGrid1.getStore().loadStoreRecords();
		},
        makeContents:function(masterRec) {
        	var param = {ORDER_NUM: masterRec.get('ORDER_NUM'), CREATE_LOC: masterRec.get('CREATE_LOC'), DIV_CODE: masterRec.get('DIV_CODE')}
        	s_mpo150skrv_kdService.selectList_yp(param, function(provider, response)  {
        	    var formatDate = UniAppManager.app.getTodayFormat();
        	    var moneyUnit = provider[0].MONEY_UNIT;
                var requestMsg =              '<!doctype html>';
                    requestMsg = requestMsg + '<html lang=\"ko\">';
                    requestMsg = requestMsg + '<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">';
                    requestMsg = requestMsg + '<title>Untitled Document</title>';
                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 16px; font-family:돋움" width= "1000" align="center">';
                    requestMsg = requestMsg + '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis; font-size: 50px;" colspan="6" height= "200px">&nbsp;발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서&nbsp;</td>';
                    requestMsg = requestMsg + '  </tr>';
                    requestMsg = requestMsg + '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" colspan="4"></td>';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="2" ><b>발주번호: <ins>'+ provider[0].ORDER_NUM +'</ins></b></td>';
                    requestMsg = requestMsg + '  </tr>';
                    requestMsg = requestMsg + '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" colspan="4"></td>';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="2" ><b>구매담당: <ins>'+ provider[0].ORDER_PRSN +'</ins></b></td>';
                    requestMsg = requestMsg + '  </tr>';
                    requestMsg = requestMsg + '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;"  width= "50%"><b>발주일자:&nbsp;'+ UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(6, 8) +'</td></b>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" rowspan="5">발<br><br>주<br><br>자</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">등록번호</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" colspan="3">'+ provider[0].MY_COMPANY_NUM +'</td>';
                    requestMsg = requestMsg + '  </tr>';
                    requestMsg = requestMsg + '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b><ins>'+ provider[0].CUSTOM_NAME +'&nbsp;&nbsp;&nbsp;&nbsp;貴中</ins></b></td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].MY_CUSTOM_NAME +'</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">대표자</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].MY_TOP_NAME;
                    requestMsg = requestMsg + '  </tr>';
                    requestMsg = requestMsg + '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>다음과 같이 발주합니다.</td></b>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="3">'+ provider[0].MY_ADDR +'</td>';
                    requestMsg = requestMsg + '  </tr>';
                    requestMsg = requestMsg + '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>TEL:&nbsp;'+ provider[0].CUST_TEL_PHON +'</td></b>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">업&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;태</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].COMP_TYPE +'</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">종&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].COMP_CLASS +'</td>';
                    requestMsg = requestMsg + '  </tr>';
                    requestMsg = requestMsg + '  <tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '    <td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>FAX:&nbsp;'+ provider[0].CUST_FAX_NUM +'</td></b>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">전&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;화</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].TELEPHON +'</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">팩&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스</td>';
                    requestMsg = requestMsg + '    <td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].FAX_NUM +'</td>';
                    requestMsg = requestMsg + '  </tr>';
                    requestMsg = requestMsg + '</table>';


                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; font-size: 16px; font-family:돋움" width= "1000" align="center">';
                    requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "6%">';
                    requestMsg = requestMsg +       '번호';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
                    requestMsg = requestMsg +       '품목코드';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "20%">';
                    requestMsg = requestMsg +       '품&nbsp;&nbsp;&nbsp;&nbsp;명';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
                    requestMsg = requestMsg +       '규&nbsp;&nbsp;&nbsp;&nbsp;격';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
                    requestMsg = requestMsg +       '수&nbsp;&nbsp;&nbsp;&nbsp;량';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
                    requestMsg = requestMsg +       '단&nbsp;&nbsp;&nbsp;&nbsp;위';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
                    requestMsg = requestMsg +       '단&nbsp;&nbsp;&nbsp;&nbsp;가';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
                    requestMsg = requestMsg +       '금&nbsp;&nbsp;&nbsp;&nbsp;액';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
                    requestMsg = requestMsg +       '납&nbsp;기&nbsp;일';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
                    requestMsg = requestMsg +       '비&nbsp;&nbsp;&nbsp;&nbsp;고';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
//                    var totRecord = directMasterStore2.data.items;
                    var amount = 0;
                    Ext.each(provider, function(rec, i){
                        requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height= "30" >';
                        requestMsg = requestMsg +       rec.ORDER_SEQ;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
                        requestMsg = requestMsg +       rec.ITEM_CODE;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
                        requestMsg = requestMsg +       rec.ITEM_NAME;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
                        requestMsg = requestMsg +       rec.SPEC;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
                        requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000.00');
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">';
                        requestMsg = requestMsg +       rec.ORDER_UNIT;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
                        if (moneyUnit == "KRW")
                        {
                          requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000');
                        }
                        else
                        {
                          requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000.00');                        
                        }
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';

                        if (moneyUnit == "KRW")
                        {
                          requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_O,'0,000');
                        }
                        else
                        {
                          requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_O,'0,000.00');                 
                        }
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
                        requestMsg = requestMsg +       UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8);
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
                        requestMsg = requestMsg +       rec.REMARK;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg + '</tr>';
                        amount = amount + rec.ORDER_O;
                        if(provider.length == i + 1){
                            requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                            requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "20%" colspan=10>';
                            if (moneyUnit == "KRW")
                            {
                              requestMsg = requestMsg +       'T O T A L&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + Ext.util.Format.number(amount,'0,000') + '&nbsp;원';
                            }
                            else
                            {
                              requestMsg = requestMsg +       'T O T A L&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + Ext.util.Format.number(amount,'0,000.00') + '&nbsp;';
                            }                            
                            requestMsg = requestMsg +   '</th>';
                            requestMsg = requestMsg + '</tr>';

                            requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                            requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px;text-align:left; vertical-align:top;" height= "100" width = "20%" colspan=10>';
                            requestMsg = requestMsg +       '<b>비고(REMARK) :</b>' + rec.M_REMARK;
                            requestMsg = requestMsg +   '</td>';
                            requestMsg = requestMsg + '</tr>';
                        }
                    });
                    requestMsg = requestMsg + '</table>';
                    requestMsg = requestMsg + '</body>';
                    requestMsg = requestMsg + '</html>';

                masterRec.set('CONTENTS', requestMsg);
                masterRec.set('SUBJECT', inputTable.getValue('SUBJECT'));
                masterRec.set('FROM_EMAIL', inputTable.getValue('FROM_EMAIL'));
                masterRec.set('CC', '');
                masterRec.set('BCC', '');
                masterRec.set('FROM_NAME', inputTable.getValue('FROM_NAME'));

                var param = masterRec.data;
                s_mpo150skrv_kdService.sendMail(param, function(provider, response)  {
                    if(provider){
                    	if(provider.STATUS == "1"){
                            if(isLastMail){
                               UniAppManager.updateStatus('메일이 전송 되었습니다.');
                            }
                            masterRec.set('MAIL_YN', 'Y');
                            directMasterStore1.commitChanges();
                        }else{
                            alert('메일 전송중 오류가 발생하였습니다. 관리자에게 문의 바랍니다.');
                        }
                        isLastMail = false;
                    }
//                    panelSearch.getEl().unmask();
                });
//                directMasterStore1.saveStore();
        	});

        },
        makeContents_kr:function(masterRec) {       //극동 발주서(한글버전)

            var param = {ORDER_NUM: masterRec.get('ORDER_NUM'), CREATE_LOC: masterRec.get('CREATE_LOC'), DIV_CODE: masterRec.get('DIV_CODE'), MAIL_FORMAT: inputTable.getValue("MAIL_FORMAT").MAIL_FORMAT}
            s_mpo150skrv_kdService.selectList2(param, function(provider, response)  {
                var formatDate = UniAppManager.app.getTodayFormat();
                var formatDate1 = UniDate.getDbDateStr(masterRec.get('ORDER_DATE'));
          	  		  formatDate1 = formatDate1.substring(0,4) + "." + formatDate1.substring(4,6) + "." + formatDate1.substring(6,8) ;
                var fromName = "" ;
//                 	 if(Ext.isEmpty(masterRec.get('ORDER_PRSN')) || Ext.isEmpty(masterRec.get('ORDER_PRSN'))){
//                 		fromName =  '오원석 전무 / 경영지원본부장, 김영준 주임 / 외자과' ;
//                 	 }else{
                 		fromName = masterRec.get('KOR_FROM')  + ", " + masterRec.get('ORDER_PRSN') + " / " + masterRec.get('ORDER_PRSN_DEPT');
//                 	 }
          	    var moneyUnit = masterRec.get('MONEY_UNIT');

                var requestMsg =              '<!doctype html>';
                    requestMsg = requestMsg + '<html lang=\"ko\">';
                    requestMsg = requestMsg + '<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">';
                    requestMsg = requestMsg + '<title>Untitled Document</title>';
                    requestMsg = requestMsg + '<body>';
                    requestMsg = requestMsg + '<div align= "center" style="margin:70px 0 0px 0;">';
                    requestMsg = requestMsg + '<img src="'+'${pageContext.request.scheme}' + '://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}' + '${pageContext.request.contextPath}' + '/resources/images/kdg/kdg_logo.png" width="40%" height="6%"/>';
                    requestMsg = requestMsg + '</div>';
                    requestMsg = requestMsg + '<div align= "center">';
                    requestMsg = requestMsg + '<table border=0 width=900 cellpadding=0 cellspacing=0 align="center"><tr><td>';

                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 0 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:1px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white" height= "30">';
                    //requestMsg = requestMsg +       'F R O M : ' + '오원석 전무 / 경영지원본부장, 김영준 주임 / 외자과'
                    requestMsg = requestMsg +       'D A T E : ' + formatDate1;
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
                    requestMsg = requestMsg +       'T O : ' + masterRec.get('CUSTOM_NAME');
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
                    requestMsg = requestMsg +       'A T T N : ' + masterRec.get('CUST_PRSN_NAME');
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
                    requestMsg = requestMsg +       'F R O M : ' + fromName;
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-bottom:5px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
                    requestMsg = requestMsg +       'SUBJECT : ' + 'Purchase Order(' + masterRec.get('ORDER_NUM') + ')';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';

                    requestMsg = requestMsg + '<br>';

                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:50px 0 30px 0; font-size: 17px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;" width= "50%" align: "center">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" colspan=0 bgcolor ="white" height= "40" align="center" >';
                    requestMsg = requestMsg +       '1. 귀사의 익일 번창하심을 진심으로 기원합니다.'
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" colspan=0 bgcolor ="white" height= "40" align="center" >';
                    requestMsg = requestMsg +       '2. 귀사로부터 구입할 제품을 발주하오니 입고일에 맞추어 입고 바랍니다.'
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:center;" colspan=0 bgcolor ="white" height= "40" align="center" >';
                    requestMsg = requestMsg +       '- Purchase Order -'
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';


                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 15px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border:0px gray solid;padding: 5px 10px; text-align:right;" height= "20", colspan= 8>';
                    requestMsg = requestMsg +       'UNIT : ' + masterRec.get('MONEY_UNIT');
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "5%">';
                    requestMsg = requestMsg +       'No';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "18%">';
                    requestMsg = requestMsg +       '품 명';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "18%">';
                    requestMsg = requestMsg +       '규 격';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "11%">';
                    requestMsg = requestMsg +       '단 위';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
                    requestMsg = requestMsg +       '수 량';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
                    requestMsg = requestMsg +       '단 가';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
                    requestMsg = requestMsg +       '금 액';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
                    requestMsg = requestMsg +       '입고요청일';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';

//                    var totRecord = directMasterStore2.data.items;
                    var amount = 0;
                    Ext.each(provider, function(rec, i){
                        requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height= "30" >';
                        requestMsg = requestMsg +       rec.ORDER_SEQ;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
                        requestMsg = requestMsg +       rec.ITEM_NAME;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
                        requestMsg = requestMsg +       rec.SPEC;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">';
                        requestMsg = requestMsg +       rec.ORDER_UNIT;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
                        requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000');
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
                        if (moneyUnit == "KRW")
                        {
                          requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000');
                        }
                        else
                        {
                          requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000.00');
                        }                          

                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
                        if (moneyUnit == "KRW")
                        {
                          requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_O,'0,000');
                        }
                        else
                        {
                          requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_O,'0,000.00');
                        }                          
                        
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
                        requestMsg = requestMsg +       UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8);
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg + '</tr>';
                        amount = amount + rec.ORDER_O;
                        if(provider.length == i + 1){
                            requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                            requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "20%" colspan=6>';
                            requestMsg = requestMsg +       'T O T A L';
                            requestMsg = requestMsg +   '</th>';
                            requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right;" height= "30" text-overflow: ellipsis;>';
                            if (moneyUnit == "KRW")
                            {
                              requestMsg = requestMsg +       Ext.util.Format.number(amount,'0,000');
                            }
                            else
                            {
                              requestMsg = requestMsg +       Ext.util.Format.number(amount,'0,000.00');
                            }                             

                            requestMsg = requestMsg +   '</td>';
                            requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center;" height= "30">';
                            requestMsg = requestMsg +   '</td>';
                            requestMsg = requestMsg + '</tr>';
                        }
                    });
                    requestMsg = requestMsg + '</table>';

                    requestMsg = requestMsg + '<table border=0 width ="100%" style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 15px; font-family:돋움">';
                    requestMsg = requestMsg + '<tr><td>';
                    requestMsg = requestMsg +  masterRec.get('REMARK').replace(/\n/gi, '<br>');
                    requestMsg = requestMsg + '</td></tr>';
                    requestMsg = requestMsg + '</table>';   

                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:30px 0 0 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
                    requestMsg = requestMsg + '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 17px;  letter-spacing: 1.3px" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'Sincerely Yours,';
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
                    requestMsg = requestMsg + '<td align= "left" style="margin:70px 0 0px 0;">';
                    requestMsg = requestMsg + '<img src="'+'${pageContext.request.scheme}' + '://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}' + '${pageContext.request.contextPath}' + '/resources/images/kdg/kdg_sign.png" width="200" height="70"/>';
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 "valign=top>';
                    requestMsg = requestMsg + '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 19px;  letter-spacing: 1.3px" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'W.S. OH / Director';
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';


                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:50px 0 20px 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
                    requestMsg = requestMsg + '<th style="border-top:1px gray solid;padding: 5px 10px; text-align:left; font-size: 11px;  letter-spacing: 0.4px" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'Incheon Factory(Head Office): 37B-12L, NAMDONG COMPLEX, 332. NAMDONG-DAERO.NAMDONG-GU, INCHEON, 21638,KOREA TEL: +82-32-812-3451~5 FAX: +82-32-812-3352';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-bootom:0px height= 10 " valign=top>';
                    requestMsg = requestMsg + '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 11px;  letter-spacing: 0.4px" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'China Factory(Qingdao KDG): No.8 PINGKANGROAD, TONGHETOWN, PINGDUCITY QINGDAO. SHANDONG PROVINCE 266706, CHINA TEL: 0532-8731-5840 FAX: 0532-8731-5841';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 35px 10px; border-bootom:0px height= 30; margin:30px 0 20px 0;">';
                    requestMsg = requestMsg + '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 15px;  letter-spacing: 0.4px; margin:50px 0 50px 0;" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'ⓒ KDG Limited.';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';


                    requestMsg = requestMsg + '</td></tr></table>';
                    requestMsg = requestMsg + '</div>';
                    requestMsg = requestMsg + '</body>';
                    requestMsg = requestMsg + '</html>';

                masterRec.set('CONTENTS', requestMsg);
                masterRec.set('SUBJECT', inputTable.getValue('SUBJECT'));
                masterRec.set('FROM_EMAIL', inputTable.getValue('FROM_EMAIL'));
                masterRec.set('CC', '');
                masterRec.set('BCC', '');
                masterRec.set('FROM_NAME', inputTable.getValue('FROM_NAME'));

                var param = masterRec.data;
              s_mpo150skrv_kdService.sendMail(param, function(provider, response)  {
                    if(provider){
                        if(provider.STATUS == "1"){
                            if(isLastMail){
                               UniAppManager.updateStatus('메일이 전송 되었습니다.');
                            }
                            masterRec.set('MAIL_YN', 'Y');
                            directMasterStore1.commitChanges();
                        }else{
                            alert('메일 전송중 오류가 발생하였습니다. 관리자에게 문의 바랍니다.');
                        }
                        isLastMail = false;
                    }
//                    panelSearch.getEl().unmask();
                });
//                directMasterStore1.saveStore();
            });

        },
        makeContents_en:function(masterRec) {   //극동 발주서(영문버전)
            var param = {ORDER_NUM: masterRec.get('ORDER_NUM'), CREATE_LOC: masterRec.get('CREATE_LOC'), DIV_CODE: masterRec.get('DIV_CODE'), MAIL_FORMAT: inputTable.getValue("MAIL_FORMAT").MAIL_FORMAT}
            s_mpo150skrv_kdService.selectList2(param, function(provider, response)  {
                var formatDate = UniAppManager.app.getTodayFormat();
                var formatDate1 = UniDate.getDbDateStr(masterRec.get('ORDER_DATE'));
          	  		  formatDate1 = formatDate1.substring(0,4) + "." + formatDate1.substring(4,6) + "." + formatDate1.substring(6,8) ;
                var fromName = "" ;
//                	  if(Ext.isEmpty(masterRec.get('ORDER_PRSN')) || Ext.isEmpty(masterRec.get('ORDER_PRSN_DEPT'))){
//                		  fromName = 'Ys.Cho / Overseas Purchase Section';
//                	  }else{
                		  fromName = masterRec.get('ENG_FROM')  + ", " + masterRec.get('ORDER_PRSN') + " / Overseas Purchase Section";  // -- + masterRec.get('ORDER_PRSN_DEPT');
//                	  }

                var requestMsg =              '<!doctype html>';
                    requestMsg = requestMsg + '<html lang=\"ko\">';
                    requestMsg = requestMsg + '<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">';
                    requestMsg = requestMsg + '<title>Untitled Document</title>';
                    requestMsg = requestMsg + '<body>';
                    requestMsg = requestMsg + '<div align= "center" style="margin:70px 0 0px 0;">';
                    requestMsg = requestMsg + '<img src="'+'${pageContext.request.scheme}' + '://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}' + '${pageContext.request.contextPath}' + '/resources/images/kdg/kdg_logo.png" width="40%" height="6%"/>';
                    requestMsg = requestMsg + '</div>';

                    requestMsg = requestMsg + '<div align= "center">';
                    requestMsg = requestMsg + '<table border=0 width=900 cellpadding=0 cellspacing=0  align="center"><tr><td>';

                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 0 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:1px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white" height= "30">';
                    requestMsg = requestMsg +       'D A T E : ' + masterRec.get('EN_ORDER_DATE');
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
                    requestMsg = requestMsg +       'T O : ' + masterRec.get('CUSTOM_NAME');
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
                    requestMsg = requestMsg +       'A T T N : ' + masterRec.get('CUST_PRSN_NAME');
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
                    //requestMsg = requestMsg +       'F R O M : ' + 'Ys.Cho / Overseas Purchase Section';
                    requestMsg = requestMsg +       'F R O M : ' + fromName;
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-bottom:5px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
                    requestMsg = requestMsg +       'SUBJECT : ' + 'Purchase Order(' + masterRec.get('ORDER_NUM') + ')';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';

                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:50px 0 30px 0; font-size: 17px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;" width= "50%" align: "center">';
                    requestMsg = requestMsg +   '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; font-size: 17px" colspan=0 bgcolor ="white" height= "35" align="center" >';
                    requestMsg = requestMsg +       'Dear ' + masterRec.get('CUST_PRSN_NAME') + ', ';
                    requestMsg = requestMsg +   '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;" width= "50%" align: "center">';
                    requestMsg = requestMsg +   '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; font-size: 17px" colspan=0 bgcolor ="white" height= "35" align="center" >';
                    requestMsg = requestMsg +       'We are pleased to place an order you as below.'
                    requestMsg = requestMsg +   '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;" width= "50%" align: "center">';
                    requestMsg = requestMsg +   '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; font-size: 17px" colspan=0 bgcolor ="white" height= "35" align="center" >';
                    requestMsg = requestMsg +       'Your prompt attention will be appreciated.'
                    requestMsg = requestMsg +   '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:center;" colspan=0 bgcolor ="white" height= "40" align="center" >';
                    requestMsg = requestMsg +       '- Purchase Order -'
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';


                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 15px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border:0px gray solid;padding: 5px 10px; text-align:right;" height= "20", colspan= 8>';
                    requestMsg = requestMsg +       'UNIT : ' + masterRec.get('MONEY_UNIT');
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "5%">';
                    requestMsg = requestMsg +       'No';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "18%">';
                    requestMsg = requestMsg +       'Item';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "18%">';
                    requestMsg = requestMsg +       'Spec';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
                    requestMsg = requestMsg +       'Unit';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
                    requestMsg = requestMsg +       'Quantity';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
                    requestMsg = requestMsg +       'Unit Price';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
                    requestMsg = requestMsg +       'Amount';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "13%">';
                    requestMsg = requestMsg +       'Shipping date';
                    requestMsg = requestMsg +   '</th>';
                    requestMsg = requestMsg + '</tr>';

//                    var totRecord = directMasterStore2.data.items;
                    var amount = 0;
                    Ext.each(provider, function(rec, i){
                    
                        var itemDtlName = rec.ITEM_NAME;
                        if(!Ext.isEmpty(rec.REMARK))
                        {
                          itemDtlName = rec.REMARK;
                        }
                    
                    
                        requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height= "30" >';
                        requestMsg = requestMsg +       rec.ORDER_SEQ;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
                        requestMsg = requestMsg +       itemDtlName;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
                        requestMsg = requestMsg +       rec.SPEC;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">';
                        requestMsg = requestMsg +       rec.ORDER_UNIT;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
                        requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000');
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
                        requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000.00');
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
                        requestMsg = requestMsg +       Ext.util.Format.number(rec.ORDER_O,'0,000.00');
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
//                        requestMsg = requestMsg +       UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8);
                        requestMsg = requestMsg +       rec.EN_DVRY_DATE;
                        requestMsg = requestMsg +   '</td>';
                        requestMsg = requestMsg + '</tr>';
                        amount = amount + rec.ORDER_O;
                        if(provider.length == i + 1){
                            requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                            requestMsg = requestMsg +   '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "20%" colspan=6>';
                            requestMsg = requestMsg +       'T O T A L';
                            requestMsg = requestMsg +   '</th>';
                            requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:right;" height= "30" text-overflow: ellipsis;>';
                            requestMsg = requestMsg +       Ext.util.Format.number(amount,'0,000.00');
                            requestMsg = requestMsg +   '</td>';
                            requestMsg = requestMsg +   '<td style="border:1px gray solid;padding: 5px 10px; text-align:center;" height= "30">';
                            requestMsg = requestMsg +   '</td>';
                            requestMsg = requestMsg + '</tr>';
                        }
                    });
                    requestMsg = requestMsg + '</table>';
                    
                    requestMsg = requestMsg + '<table border=0 width ="100%" style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 15px; font-family:돋움">';
                    requestMsg = requestMsg + '<tr><td>';
                    requestMsg = requestMsg +  masterRec.get('REMARK').replace(/\n/gi, '<br>');
                    requestMsg = requestMsg + '</td></tr>';
                    requestMsg = requestMsg + '</table>';                    

                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:30px 0 0 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
                    requestMsg = requestMsg + '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 17px;  letter-spacing: 1.3px" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'Sincerely Yours,';
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
                    requestMsg = requestMsg + '<td align= "left" style="margin:70px 0 0px 0;">';
                    requestMsg = requestMsg + '<img src="'+'${pageContext.request.scheme}' + '://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}' + '${pageContext.request.contextPath}' + '/resources/images/kdg/kdg_sign.png" width="200" height="70"/>';
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 "valign=top>';
                    requestMsg = requestMsg + '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 19px;  letter-spacing: 1.3px" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'W.S. OH / Director';
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';


                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:0px gray solid; margin:50px 0 20px 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
                    requestMsg = requestMsg + '<th style="border-top:1px gray solid;padding: 5px 10px; text-align:left; font-size: 11px;  letter-spacing: 0.4px" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'Incheon Factory(Head Office): 37B-12L, NAMDONG COMPLEX, 332. NAMDONG-DAERO.NAMDONG-GU, INCHEON, 21638,KOREA TEL: +82-32-812-3451~5 FAX: +82-32-812-3352';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 5px 10px; border-bootom:0px height= 10 " valign=top>';
                    requestMsg = requestMsg + '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 11px;  letter-spacing: 0.4px" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'China Factory(Qingdao KDG): No.8 PINGKANGROAD, TONGHETOWN, PINGDUCITY QINGDAO. SHANDONG PROVINCE 266706, CHINA TEL: 0532-8731-5840 FAX: 0532-8731-5841';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '<tr style="border:0px gray solid;padding: 35px 10px; border-bootom:0px height= 30; margin:30px 0 20px 0;">';
                    requestMsg = requestMsg + '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 15px;  letter-spacing: 0.4px; margin:50px 0 50px 0;" colspan=0 bgcolor ="white" height= "5">';
                    requestMsg = requestMsg + 'ⓒ KDG Limited.';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';

                    requestMsg = requestMsg + '</td></tr></table>';
                    requestMsg = requestMsg + '</div>';
                    requestMsg = requestMsg + '</body>';
                    requestMsg = requestMsg + '</html>';

                masterRec.set('CONTENTS', requestMsg);
                masterRec.set('SUBJECT', inputTable.getValue('SUBJECT'));
                masterRec.set('FROM_EMAIL', inputTable.getValue('FROM_EMAIL'));
                masterRec.set('CC', '');
                masterRec.set('BCC', '');
                masterRec.set('FROM_NAME', inputTable.getValue('FROM_NAME'));

                var param = masterRec.data;
                s_mpo150skrv_kdService.sendMail(param, function(provider, response)  {
                    if(provider){
                        if(provider.STATUS == "1"){
                            if(isLastMail){
                        	   UniAppManager.updateStatus('메일이 전송 되었습니다.');
                        	}
                        	masterRec.set('MAIL_YN', 'Y');
                        	directMasterStore1.commitChanges();
                        }else{
                            alert('메일 전송중 오류가 발생하였습니다. 관리자에게 문의 바랍니다.');
                        }
                        isLastMail = false;
                    }
//                    panelSearch.getEl().unmask();
                });
//                directMasterStore1.saveStore();
            });

        },
        getTodayFormat:function() {
            var monthNames = [
                "Jan", "Jul", "Feb", "Aug", "Mar", "Sept", "Apr", "Oct", "May", "Nov", "June", "Dec"
            ];
            var date = new Date();
            var day = date.getDate();
            var monthIndex = date.getMonth();
            var year = date.getFullYear();

            return monthNames[monthIndex] + ' ' + day + ', ' + year;
        }
	});

	Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid1,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
        console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "CUST_MAIL_ID":
                    if(newValue){
                        UniAppManager.setToolbarButtons('save',false);
                    }
                    break;
            }
            return rv;
        }
    });
};

</script>
