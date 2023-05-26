<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eqt300ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"/> <!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="P103"/> <!-- 참조구분 -->
	<t:ExtComboStore comboType="AU" comboCode="0"/>    <!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="M105"/> <!-- 사급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B081"/> <!-- 대체품목여부 -->
    <t:ExtComboStore comboType="AU" comboCode="P103"/> <!-- 참조구분 -->
    <t:ExtComboStore comboType="AU" comboCode="I800" /> <!-- 장비구분 -->
    <t:ExtComboStore comboType="AU" comboCode="I812" /> <!-- 점검항목 -->
    <t:ExtComboStore comboType="AU" comboCode="I813" /> <!-- 판정기준 -->
    <t:ExtComboStore comboType="AU" comboCode="I814" /> <!-- 판정방법 -->
    <t:ExtComboStore comboType="AU" comboCode="I815" /> <!-- 판정주기 -->
    <t:ExtComboStore comboType="WU" />        <!-- 작업장-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var activeGrid='eqt300ukrvGridTab';

var BsaCodeInfo = {
		gsUseWorkColumnYn	: '${gsUseWorkColumnYn}',	//작업 관련컬럼(작업자, 작업호기, 작업시간, 주야구분) 사용여부
		gsAutoType			: '${gsAutoType}',
		gsAutoNo			: '${gsAutoNo}',			//생산자동채번여부
		gsBadInputYN		: '${gsBadInputYN}',		//자동입고시 불량입고 반영여부
		gsChildStockPopYN	: '${gsChildStockPopYN}',	//자재부족수량 팝업 호출여부
		gsShowBtnReserveYN	: '${gsShowBtnReserveYN}',	//BOM PATH 관리여부
		gsManageLotNoYN		: '${gsManageLotNoYN}',		//재고와 작업지시LOT 연계여부

		gsLotNoInputMethod	: '${gsLotNoInputMethod}',	//LOT 연계여부
		gsLotNoEssential	: '${gsLotNoEssential}',
		gsEssItemAccount	: '${gsEssItemAccount}',

		gsLinkPGM			: '${gsLinkPGM}',			//등록 PG 내 링크 ID 설정
		gsGoodsInputYN		: '${gsGoodsInputYN}',		//상품등록 가능여부
		gsSetWorkShopWhYN	: '${gsSetWorkShopWhYN}',	//작업장의 가공창고 설정여부
		gsMoldCode			: '${gsMoldCode}',			//작업지시 설비여부
		gsEquipCode			: '${gsEquipCode}',			//작업지시 금형여부
		gsReportGubun		: '${gsReportGubun}',		//레포트 구분
		gsCompName			: '${gsCompName}',			//출력 관련해서 제이월드 report만 따로 사용... 하기 위해 comp_name 가져오는 로직

		gsSiteCode			: '${gsSiteCode}',
		gsIfCode			: '${gsIfCode}',            //작업지시데이터 연동여부
		gsIfSiteCode		: '${gsIfSiteCode}'         //작업지시데이터 연동주소
	};

function appMain() {

	var isEquipCode = false;
	if(BsaCodeInfo.gsEquipCode=='N') {
		isEquipCode = true;
	}

	var isMoldCode = false;
	if(BsaCodeInfo.gsMoldCode=='N') {
		isMoldCode = true;
	}

/**
 * 상세 Form
*/

//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) Start------- //
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'eqt300ukrvService.selectMasterList4',
			update:		'eqt300ukrvService.updateMaster',
			create:		'eqt300ukrvService.insertMaster4',
			destroy:	'eqt300ukrvService.deleteMaster',
			syncAll:	'eqt300ukrvService.saveAll4'
		}
	});
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //

//작업장에 따른 공정코드 콤보load..
  var cbStore = Unilite.createStore('eqt200ukrvComboStoreGrid',{
        autoLoad: false,
        uniOpt: {
            isMaster: false         // 상위 버튼 연결
        },
        fields: [
                {name: 'SUB_CODE', type : 'string'},
                {name: 'CODE_NAME', type : 'string'}
                ],
 //       proxy: cbDirectProxy,
        proxy: {
            type: 'direct',
            api: {
            	read: 'pmr800ukrvService.progWorkCombo'
            }
        },

        loadStoreRecords: function() {

            var param= panelResult.getValues();
            param.COMP_CODE= UserInfo.compCode;
            param.DIV_CODE = UserInfo.divCode;
            param.WORK_SHOP_CODE = panelResult.getValue('WORK_SHOP_CODE');

            //console.log(param);
            this.load({
                params : param
            });

        }
    });

	var panelResult = Unilite.createSearchForm('resultForm',{

    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel:'사업장',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
		    name: 'DIV_CODE',
		    value:UserInfo.divCode

    	},
		{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			holdable: 'hold',
			comboType: 'WU',
	 		allowBlank:false,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {
		      		panelResult.setValue('WORK_SHOP_CODE', newValue);
		      	//작업장변경시  공정코드 load
		      		cbStore.loadStoreRecords();

		     	}
		    }
		},
		{
			fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일자"/>',
			xtype: 'uniDatefield',
			name: 'WORKDATE',
			allowBlank : false,
			value: UniDate.get('today'),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('WORKDATE', newValue);
				}
			}
		},
		Unilite.popup('EQU_MACH_CODE', {
			fieldLabel: '장비번호',
			valueFieldWidth:200,
			name: 'EQU_MACH_CODE',
			valueFieldName: 'EQU_MACH_CODE',
	   	 	textFieldName: 'EQU_MACH_NAME',

	   	   // allowBlank:false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})],

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
                    //  this.mask();
                    }
                } else {
                    this.unmask();
                }
                return r;
            }
	    });

	var masterForm = Unilite.createSearchForm('masterForm',{
		region: 'north',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        autoScroll: true,
//        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            xtype: 'container',
            colspan: 3,
            layout: {type: 'uniTable', columns: 5},
            items:[{
            	name:'EQU_CODE',
            	xtype: 'uniTextfield',
            	hidden : true
            }]

        }],

        api: {
            load: 'eqt300ukrvService.selectOrderNumMaster'
        },
        listeners: {
            uniOnChange:function( basicForm, field, newValue, oldValue ) {
//                if(!oldValue) return false;
//                if(basicForm.isDirty() && newValue != oldValue && directMasterStore2.data.items[0]) {
//                    UniAppManager.setToolbarButtons('save', true);
//                }else {
//                    UniAppManager.setToolbarButtons('save', false);
//                }
//                if(Ext.isEmpty(basicForm.getField('TOT_PACKING_COUNT').getValue())){
//                    basicForm.getField('TOT_PACKING_COUNT').setValue(0);
//                }
            }
         },
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
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
//          me.setAllFieldsReadOnly(true);
        },
        loadForm: function(record)  {
//                this.reset();
            this.setActiveRecord(record || null);
            this.resetDirtyStatus();
        }
    });


	/**Model 정의
	 * @type
	 */
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) Start------- //
	Unilite.defineModel('eqt300ukrvMasterModel', {
	    fields: [
			{name: 'DIV_CODE'         	,text: '사업장코드'				,type:'string',allowBlank: false},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string', comboType: 'WU'},
			{name: 'PROG_WORK_CODE' 	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string' , store: cbStore},
			{name: 'SEQ'         		,text: '순번'				    ,type:'int',allowBlank: false},
			{name: 'EQU_CODE_TYPE'		,text: '장비구분'				,type:'string', allowBlank:false, comboType:'AU', comboCode:'I800' },
			{name: 'EQU_CODE'        	,text: '장비(금형)번호'			,type:'string',allowBlank: false},
			{name: 'EQU_NAME'        	,text: '장비(금형)명'			,type:'string',allowBlank: false},
			{name: 'CHECKHISTNO'        ,text: '점검항목'				,type:'string',comboType:'AU', comboCode:'I812'},
			{name: 'CHECKNOTE'         	,text: '점검내용'				,type:'string'},
			{name: 'WORKDATE'         	,text: '점검일자'				,type:'uniDate'},
			{name: 'RESULTS_STD'        ,text: '판정기준'				,type:'string',comboType:'AU', comboCode:'I813'},
			{name: 'RESULTS_METHOD'     ,text: '판정방법'				,type:'string',comboType:'AU', comboCode:'I814'},
			{name: 'RESULTS_ROUTINE'    ,text: '판정주기'				,type:'string',comboType:'AU', comboCode:'I815'},
			{name: 'PRESSUREVALUE'    	,text: '압력'					,type:'string'},
			{name: 'INTERFACEFLAG'    	,text: '인터페이스FLAG'			,type:'string'},
			{name: 'INTERFACETIME'    	,text: '인터페이스시간'			,type:'string'},
			{name: 'WORKHISTORYNO'    	,text: '작업지시번호'				,type:'string'}

		]
	});

 var MasterStore = Unilite.createStore('eqt300ukrvMasterStore', {
	    model: 'eqt300ukrvMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	true,			// 수정 모드 사용
			deletable:	true,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},

		proxy: directProxy,

		loadStoreRecords: function(){
			var param= panelResult.getValues();
			console.log(param);

			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
					}
				}
			});
 		},
     	saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);


			var equCode = panelResult.getValue('EQU_CODE');

			//Ext.each(list, function(record, index) {
			//	if(record.data['EQU_CODE'] != equCode) {
			//		record.set('EQU_CODE', equCode);
			//	}
			//})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			var paramMaster= panelResult.getValues();	//syncAll 수정
			paramMaster.TYPE='C';
			if(inValidRecs.length == 0) {
				console.log("paramMaster : ", paramMaster);
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						//alert('여기까지 디버그!!!.');
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('eqt300ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var MasterGrid3 = Unilite.createGrid('eqt300ukrvGrid', {
	    	layout: 'fit',
	        region:'center',
	        uniOpt: {
				expandLastColumn:	false,
				useRowNumberer:		false
	        },
	    	store: MasterStore,
	    	features: [ {id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
	           	{id : 'MasterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
	        columns: [
	   			{dataIndex: 'DIV_CODE'        	 	, width: 110, 	hidden: false,comboType:'BOR120'},
	   			{dataIndex: 'SEQ'           		, width: 80, align: 'center' },
	   			{dataIndex: 'WORK_SHOP_CODE'		, width: 80},
	   			{dataIndex: 'PROG_WORK_CODE'     	, width: 110},
	   			{dataIndex: 'EQU_CODE_TYPE'         , width: 110, 	hidden: false,comboType:'I800'},
	   			{dataIndex: 'EQU_CODE'		, width: 110, hidden: isEquipCode
					,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
									textFieldName:'EQU_MACH_NAME',
									DBtextFieldName: 'EQU_MACH_NAME',
									autoPopup: true,
									listeners: {'onSelected': {
										fn: function(records, type) {
											var grdRecord = MasterGrid3.uniOpt.currentRecord;
											grdRecord.set('EQU_CODE',records[0]['EQU_MACH_CODE']);
											grdRecord.set('EQU_NAME',records[0]['EQU_MACH_NAME']);
										},
										scope: this
									},
									'onClear': function(type) {
										grdRecord = MasterGrid3.getSelectedRecord();
										grdRecord.set('EQU_CODE', '');
										grdRecord.set('EQU_NAME', '');
									},
									applyextparam: function(popup){
										var param =panelResult.getValues();
										popup.setExtParam({'DIV_CODE': param.DIV_CODE});
									}
								}
					})
				},
				{dataIndex: 'EQU_NAME'		, width: 200, hidden: isEquipCode
					,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
							textFieldName:'EQU_MACH_NAME',
							DBtextFieldName: 'EQU_MACH_NAME',
							autoPopup: true,
							listeners: {'onSelected': {
										fn: function(records, type) {
											var grdRecord = MasterGrid3.uniOpt.currentRecord;
											grdRecord.set('EQU_CODE',records[0]['EQU_MACH_CODE']);
											grdRecord.set('EQUIP_NAME',records[0]['EQU_MACH_NAME']);
										},
										scope: this
									},
									'onClear': function(type) {
										grdRecord = MasterGrid3.getSelectedRecord();
										grdRecord.set('EQU_CODE', '');
										grdRecord.set('EQU_NAME', '');
									},
									applyextparam: function(popup){
										var param =panelResult.getValues();
										popup.setExtParam({'DIV_CODE': param.DIV_CODE});
									}
							 }
					})
				},
	   			{dataIndex: 'CHECKHISTNO'     		, width: 110, 	hidden: false,comboType:'I812'},
	   			{dataIndex: 'CHECKNOTE'     		, width: 110},
	   			{dataIndex: 'WORKDATE'     			, width: 110},
	   			{dataIndex: 'RESULTS_STD'         	, width: 110,	hidden: false,comboType:'I813'},
	   			{dataIndex: 'RESULTS_METHOD'     	, width: 110,	hidden: false,comboType:'I814'},
	   			{dataIndex: 'RESULTS_ROUTINE'     	, width: 110,	hidden: false,comboType:'I815'},
	   			{dataIndex: 'PRESSUREVALUE'     	, width: 110},
	   			{dataIndex: 'INTERFACEFLAG'     	, width: 110},
	   			{dataIndex: 'INTERFACETIME'     	, width: 110},
	   			{dataIndex: 'WORKHISTORYNO'     	, width: 110}
			],
			listeners: {
	/*			beforeedit현재는 필요 없음(masterStore에서 uniOpt에 editable:	false처리 해 놓았음	*/
	  			beforeedit: function( editor, e, eOpts ) {
					if (UniUtils.indexOf(e.field,
						['DIV_CODE','WORK_SHOP_CODE','WORKDATE']))
					return false;
	        	}
	  			}
		});
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //

    var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) Start------- //
        {
              title: '일상점검내역'
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid3]
             ,id: 'eqt300ukrvGridTab'
 		}
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //
		],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
            	activeGrid=newCard.id;
            	if(panelResult.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
    			{
            		return false;
    			}else{
    				if(activeGrid=="eqt300ukrvGridTab"){

	            		MasterStore.loadStoreRecords();
	            	}
    			}
            }
        }
    });

    Unilite.Main({
		id: 'eqt300ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult ,masterForm,tab
			]
		}
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			panelResult.setValue("DIV_CODE",UserInfo.divCode);
		},

		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
			{
        		return false;
			}else{
				var param= panelResult.getValues();
                masterForm.uniOpt.inLoading=true;
                Ext.getBody().mask('로딩중...','loading-indicator');
 //               masterForm.getForm().load({
 //                   params: param,
 //                   success:function(actionform, action)    {

 //                       panelResult.setValue("EQU_CODE",action.result.data.EQU_CODE);
//                        masterForm.uniOpt.inLoading=false;
                    	if(activeGrid=="eqt300ukrvGridTab"){
    	            		MasterStore.loadStoreRecords();
    	            	}
                        UniAppManager.setToolbarButtons('delete',true);
                        UniAppManager.setToolbarButtons('newData',true);
                        Ext.getBody().unmask();
//                    },
//                     failure: function(batch, option) {
//                    	UniAppManager.setToolbarButtons('delete',true);
//                        UniAppManager.setToolbarButtons('newData',true);
//                        console.log("option:",option);
 //                       masterForm.uniOpt.inLoading=false;
 //                       Ext.getBody().unmask();
 //                    }
               // });
			}
		},

		onPrevDataButtonDown:  function()   {
            var param= panelResult.getValues();
            	param.page="prev";
                masterForm.uniOpt.inLoading=true;
                Ext.getBody().mask('로딩중...','loading-indicator');
                masterForm.getForm().load({
                    params: param,
                    success:function(actionform, action)    {
                        panelResult.setValue("EQU_CODE",action.result.data.EQU_CODE);
                        masterForm.uniOpt.inLoading=false;
                    	if(activeGrid=="eqt300ukrvGridTab"){
    	            		MasterStore.loadStoreRecords();
    	            	}

                        UniAppManager.setToolbarButtons('deleteAll',false);
//                        Ext.getCmp("btn_3").enable();
                        Ext.getBody().unmask();
                    },
                     failure: function(batch, option) {
                        console.log("option:",option);
                        Ext.Msg.alert("확인",'<t:message code="unilite.msg.sMS035"  default="자료의 처음입니다" />');
                        //UniAppManager.app.onResetButtonDown();
                        masterForm.uniOpt.inLoading=false;
                        Ext.getBody().unmask();
                     }
                });
            console.log("param:",param);

            UniAppManager.setToolbarButtons('excel',true);
        },

        onNextDataButtonDown:  function()   {
            var param= panelResult.getValues();
            	param.page="next";
                masterForm.uniOpt.inLoading=true;
                Ext.getBody().mask('로딩중...','loading-indicator');
                masterForm.getForm().load({
                    params: param,
                    success:function(actionform, action)    {
                        panelResult.setValue("EQU_CODE",action.result.data.EQU_CODE);
                        masterForm.uniOpt.inLoading=false;
                    	if(activeGrid=="eqt300ukrvGridTab"){
    	            		MasterStore.loadStoreRecords();
    	            	}

                        UniAppManager.setToolbarButtons('deleteAll',false);
//                        Ext.getCmp("btn_3").enable();
                        Ext.getBody().unmask();
                    },
                     failure: function(batch, option) {
                        console.log("option:",option);
                        Ext.Msg.alert("확인",'<t:message code="unilite.msg.sMS036"  default="자료의 마지막입니다" />');
                        masterForm.uniOpt.inLoading=false;
                        Ext.getBody().unmask();
                     }
                });
            console.log("param:",param);

            UniAppManager.setToolbarButtons('excel',true);
        },

		onResetButtonDown: function() {
			panelResult.clearForm();
            masterForm.clearForm();
            MasterGrid3.getStore().loadData({});

            UniAppManager.setToolbarButtons('save', false);
            UniAppManager.setToolbarButtons('deleteAll', false);
            UniAppManager.setToolbarButtons('delete', false);
            UniAppManager.setToolbarButtons('newData', false);
			this.fnInitBinding();
		},

		onNewDataButtonDown: function()	{
		 if(activeGrid=="eqt300ukrvGridTab"){
				var seq = MasterStore.max('SEQ');
   	           	 if(!seq) seq = 1;
   	           	 else  seq += 1;
           		var r={
           			DIV_CODE:panelResult.getValue("DIV_CODE")
           			,WORK_SHOP_CODE:panelResult.getValue("WORK_SHOP_CODE")
           			,SEQ:seq
           			,EQU_CODE:''
           			,WORKDATE:new Date()
           			,CHECKHISTNO:''
       				,CHECKNOTE:''
       				,RESULTS_STD:''
       				,RESULTS_METHOD:''
       				,RESULTS_ROUTINE:''
           		};
           		MasterGrid3.createRow(r);
        	}
		},

		onDeleteDataButtonDown: function() {
			var selRow = MasterGrid3.getSelectedRecord();

			if(activeGrid=="eqt300ukrvGridTab")
			{
				selRow= MasterGrid3.getSelectedRecord();
			}

			if(selRow.phantom === true) {
				MasterGrid3.getSelectedRecord();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				MasterGrid3.deleteSelectedRow();
            }
			UniAppManager.setToolbarButtons('save', true);
		},

		onSaveDataButtonDown: function() {

			if(activeGrid=="eqt300ukrvGridTab")
			{
				//Ext.Msg.alert("확인",'여기까지123.....');
				MasterStore.saveStore();
			}
		}
	});

}
</script>
