<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eqt230skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"/> <!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="P103"/> <!-- 참조구분 -->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
	<t:ExtComboStore comboType="WU" />										<!-- 작업장-->
	<t:ExtComboStore comboType="AU" comboCode="M105"/> <!-- 사급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J018"/> <!-- 수동/자동 -->
    <t:ExtComboStore comboType="AU" comboCode="P700"/> <!-- 특기사항 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var activeGrid='eqt230skrvGridTab';

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
/**
 * 상세 Form
*/
//----- 2023.02.22 Dongsoo Park - (비가동실적등록) Start------- //
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'pmp300ukrvService.selectList',
			update:		'pmp300ukrvService.updateMaster',
			create:		'pmp300ukrvService.insertMaster',
			destroy:	'pmp300ukrvService.deleteMaster',
			syncAll:	'pmp300ukrvService.saveAll'
		}
	});
//----- 2023.02.22 Dongsoo Park - (비가동실적등록) End------- //
	var progWordComboStore = new Ext.data.Store({
		storeId: 'pmp300ukrvProgWordComboStore',
		fields	: ['value', 'text','refCode1','option'],
		//autoLoad: true,
		proxy: {
			type: 'direct',
			api: {
				 read: 'UniliteComboServiceImpl.getPmp100tProgWorkCode'
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
					if(successful)  {
					}
			}
		},

		loadStoreRecords: function(records)	{
			var param= masterForm.getValues();
			param.STOPDATE = records.get('STOPDATE');
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	var isEquipCode = false;
	if(BsaCodeInfo.gsEquipCode=='N') {
		isEquipCode = true;
	}

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
            },
            {
				fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				holdable: 'hold',
				comboType: 'WU',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WORK_SHOP_CODE', newValue);
					},
	                beforequery:function( queryPlan, eOpts )   {
	                    var store = queryPlan.combo.store;
	                    var prStore = masterForm.getField('WORK_SHOP_CODE').store;
	                    store.clearFilter();
	                    prStore.clearFilter();
	                    if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
	                        store.filterBy(function(record){
	                            return record.get('option') == masterForm.getValue('DIV_CODE');
	                        });
	                        prStore.filterBy(function(record){
	                            return record.get('option') == masterForm.getValue('DIV_CODE');
	                        });
	                    }else{
	                        store.filterBy(function(record){
	                            return false;
	                        });
	                        prStore.filterBy(function(record){
	                            return false;
	                        });
	                    }
	                }
				}
			},
			{
				fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDatefield',
				name: 'STOPDATE',
				allowBlank : false,
				value: UniDate.get('today'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('STOPDATE', newValue);
					}
				}
			},
			{
				fieldLabel : '공정',
				name : 'S_PROG_WORK_CODE',
				xtype : 'uniCombobox',
				store : Ext.data.StoreManager.lookup('pmp300ukrvProgWordComboStore'),
			//	allowBlank : false,
				width : 350,
				holdable : 'hold',
				listeners : {
				change : function(field,newValue,oldValue, eOpts) {
						masterForm.setValue('S_PROG_WORK_CODE',newValue);
						Ext.each(masterGrid.getStore().data.items,
							function(record,index) {
							if (record.get('PROG_WORK_CODE') == newValue) {
												masterGrid.getSelectionModel().select(index);
								}
							})

					},
					beforequery : function(queryPlan,eOpts)
					{
						var store = queryPlan.combo.store;
						store.clearFilter();
						if (!Ext.isEmpty(masterForm.getValue('WORK_SHOP_CODE')))
						{
							store.filterBy(function(record) {
										return record.get('refCode1') == masterForm.getValue('WORK_SHOP_CODE');
									});
						} else {
							store.filterBy(function(record) {
										return false;
									});
						}
					}
				}
			},
			Unilite.popup('EQU_CODE', {
				fieldLabel: '장비번호',
				valueFieldWidth:80,
				valueFieldName: 'EQU_CODE',
		   	 	textFieldName: 'EQU_NAME',
		//	    allowBlank:false,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			}),
			{
				fieldLabel: '<t:message code="system.label.product.inspecchargeperson" default="검사담당자"/>',
				name:'INSPEC_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU' ,
				comboCode:'Q024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_PRSN', newValue);
					}
				}
			}]

        }],
        api: {
            load: 'pmp300ukrvService.selectList'
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
	Unilite.defineModel('eqt230skrvMasterModel', {
	    fields: [
			{name: 'DIV_CODE'         	,text: '사업장코드'				,type:'string',allowBlank: false},
			{name: 'WORK_SHOP_CODE'     ,text: '작업장코드'				,type:'string',allowBlank: false, comboType:'WU'},
			{name: 'MACHINEID'			,text: '<t:message code="system.label.product.facilities" default="설비"/>'			,type:'string', allowBlank: false},
			{name: 'MACHINENAME'		,text: '<t:message code="system.label.product.facilitiesname" default="설비명"/>'		,type:'string', allowBlank: false},
			{name: 'WKORD_NUM'     		,text: '작업지시번호'				,type:'string'},
			{name: 'STOPDATE'     		,text: '비가동일자'				,type:'uniDate',allowBlank: false},
			{name: 'STOPSEQ'     		,text: '순번'					,type:'int',allowBlank: false},
			{name: 'STOPCODE'     		,text: '비가동항목'				,type:'string',allowBlank: false, comboType:'AU', comboCode:'P700' },

			{name: 'STARTTIME'			,text: '<t:message code="system.label.product.workhourfrom" default="시작시간"/>'		,type:'uniTime'},
			{name: 'ENDTIME'			,text: '<t:message code="system.label.product.workhourfrom" default="종료시간"/>'		,type:'uniTime'},
			{name: 'USETIME'			,text: '<t:message code="system.label.product.workhourfrom" default="발생시간"/>'		,type:'uniTime'},

			{name: 'ACTION'     		,text: '조치내역'				,type:'string'},
			{name: 'ORG_STIME'     		,text: '시작시점시간'				,type:'uniTime'},
			{name: 'MANUAL_GBN'         ,text: '수동구분'				,type:'int', comboType:'AU', comboCode:'J018' },
			{name: 'M_C_STIME'			,text: '수동비가동시작시간'			,type:'uniTime'},
			{name: 'M_C_ETIME'        	,text: '수동비가동종료시간'			,type:'uniTime'},
			{name: 'STARTQTY'        	,text: '생산시작량'				,type:'uniQty'},
			{name: 'STOPQTY'         	,text: '생산중지량'				,type:'uniQty'},
			{name: 'WORKQTY'         	,text: '생산량'				,type:'uniQty'},
			{name: 'DATAGBN'        	,text: '데이터구분'				,type:'uniQty'},
			{name: 'MEMO'     			,text: '비고'					,type:'string'},
			{name: 'INPUT_GBN'    		,text: '입력구분'				,type:'string'},
			{name: 'INTERFACETIEM'    	,text: '인터페이스FLAG'			,type:'string'},
			{name: 'INTERFACEFLAG'    	,text: '인터페이스FLAG'			,type:'string'}
		]
	});

 var MasterStore = Unilite.createStore('eqt230skrvMasterStore', {
	    model: 'eqt230skrvMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	true,			// 수정 모드 사용
			deletable:	true,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},

		proxy: directProxy,
		loadStoreRecords: function(){
			var param= masterForm.getValues();
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
				//		UniAppManager.setToolbarButtons(['delete', 'newData'], true);
					}
				}
			});
     	},

//저장프로세스
     	saveStore: function() {
			var inValidRecs = this.getInvalidRecords();

			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);

       		console.log("list:", list);

			var equCode = masterForm.getValue('EQU_CODE');
			Ext.each(list, function(record, index) {
				if(record.data['EQU_CODE'] != equCode) {
					record.set('EQU_CODE', equCode);
				}
			})

     		console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			var paramMaster= masterForm.getValues();	//syncAll 수정

			paramMaster.TYPE='C'; //模具维修

			//alert('여기까지 디버그!!!.');

			if(inValidRecs.length == 0) {

				config = {
					params: [paramMaster],
					success: function(batch, option) {
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};

				this.syncAllDirect(config);

			} else {
                var grid = Ext.getCmp('eqt230skrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var MasterGrid = Unilite.createGrid('eqt230skrvGrid', {

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
	   			{dataIndex: 'DIV_CODE'        	 	, width: 110, 	hidden: false,	comboType:'BOR120'},
	   			{dataIndex: 'STOPSEQ'           	, width: 80, align: 'center' },
	   			{dataIndex: 'WORK_SHOP_CODE'     	, width: 110, comboType:'WU'},
	   			{dataIndex: 'WKORD_NUM'     		, width: 110},
	   		   	{dataIndex: 'MACHINEID'		, width: 110, hidden: isEquipCode
					,'editor' : Unilite.popup('EQU_MACH_CODE_G',{
									textFieldName:'EQU_MACH_NAME',
									DBtextFieldName: 'EQU_MACH_NAME',
									autoPopup: true,
									listeners: {'onSelected': {
										fn: function(records, type) {
											var grdRecord = MasterGrid.uniOpt.currentRecord;
											grdRecord.set('MACHINEID',records[0]['EQU_MACH_CODE']);
											grdRecord.set('MACHINENAME',records[0]['EQU_MACH_NAME']);
										},
										scope: this
									},
									'onClear': function(type) {
										grdRecord = MasterGrid.getSelectedRecord();
										grdRecord.set('MACHINEID', '');
										grdRecord.set('MACHINENAME', '');
									},
									applyextparam: function(popup){
										var param =masterForm.getValues();
										popup.setExtParam({'DIV_CODE': param.DIV_CODE});
									}
								}
					})
				},
				{dataIndex: 'MACHINENAME'     		, width: 110},
				{dataIndex: 'STOPDATE'     			, width: 110},
	   			{dataIndex: 'STOPCODE'     			, width: 110, 	hidden: false,  comboType:'P700'},
	   			{dataIndex: 'STARTTIME'     		, width: 110},
	   			{dataIndex: 'ENDTIME'         		, width: 110},
	   			{dataIndex: 'USETIME'     			, width: 110},
	   			{dataIndex: 'ACTION'     			, width: 110},
	   			{dataIndex: 'ORG_STIME'     		, width: 110},
	   			{dataIndex: 'MANUAL_GBN'     		, width: 110, comboType:'J018'},
	   			{dataIndex: 'M_C_STIME'     		, width: 110},
	   			{dataIndex: 'M_C_ETIME'     		, width: 110},
	   			{dataIndex: 'STARTQTY'     			, width: 110},
	   			{dataIndex: 'STOPQTY'     			, width: 110},
	   			{dataIndex: 'WORKQTY'     			, width: 110},
	   			{dataIndex: 'DATAGBN'     			, width: 110},
	   			{dataIndex: 'MEMO'     				, width: 110},
	   			{dataIndex: 'INPUT_GBN'     		, width: 110},
	   			{dataIndex: 'INTERFACEFLAG'     	, width: 110},
	   			{dataIndex: 'INTERFACETIME'     	, width: 110}
	   						],
			listeners: {
	/*			beforeedit현재는 필요 없음(masterStore에서 uniOpt에 editable:	false처리 해 놓았음	*/
	  			beforeedit: function( editor, e, eOpts ) {
					if (UniUtils.indexOf(e.field,
						['DIV_CODE','WORK_SHOP_CODE','STOPDATE']))
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
              title: '비가동발생현황'
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid]
             ,id: 'eqt230skrvGridTab'
 		}
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //
		],

        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
            	activeGrid=newCard.id;
            	if(masterForm.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
    			{
            		return false;
    			}else{
    				if(activeGrid=="eqt230skrvGridTab"){
   	            		MasterStore.loadStoreRecords();
	            	}
    			}
            }
        }
    });

    Unilite.Main({
		id: 'eqt230skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterForm ,tab
			]
		}
		],
		fnInitBinding: function(params) {
		//	UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			masterForm.setValue("DIV_CODE",UserInfo.divCode);
		},

		onQueryButtonDown: function() {
			if(masterForm.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
			{	return false;
			}else{
				var param= masterForm.getValues();
                masterForm.uniOpt.inLoading=true;
              	Ext.getBody().mask('로딩중...','loading-indicator');

//              	masterForm.getForm().load({
//                    params: param,
//                    success:function(actionform, action)    {
//                    	masterForm.setValue("STOPDATE",action.result.data.STOPDATE);
//                        masterForm.uniOpt.inLoading=false;
                    	if(activeGrid=="eqt230skrvGridTab"){
    	            		MasterStore.loadStoreRecords();
    	             	}
                      //  UniAppManager.setToolbarButtons('delete',true);
                      //  UniAppManager.setToolbarButtons('deleteAll',true);
                     //  UniAppManager.setToolbarButtons('newData',true);

                        Ext.getBody().unmask();
//                    },

//                    failure: function(batch, option) {
//                    	UniAppManager.setToolbarButtons('delete',true);
//                        UniAppManager.setToolbarButtons('newData',true);
//                        console.log("option:",option);
//                        masterForm.uniOpt.inLoading=false;
//                        Ext.getBody().unmask();
//                    }
//            	});
 			}
		},

		onPrevDataButtonDown:  function()   {
            var param= masterForm.getValues();
            	param.page="prev";
                masterForm.uniOpt.inLoading=true;
                Ext.getBody().mask('로딩중...','loading-indicator');
                masterForm.getForm().load({
                    params: param,
                    success:function(actionform, action)    {
                    	masterForm.setValue("STOPDATE",action.result.data.STOPDATE);
                        masterForm.uniOpt.inLoading=false;
                    	if(activeGrid=="eqt230skrvGridTab"){
    	            		MasterStore.loadStoreRecords();
    	            	}
                       // UniAppManager.setToolbarButtons('deleteAll',true);
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
                    	masterForm.setValue("STOPDATE",action.result.data.STOPDATE);
                        masterForm.uniOpt.inLoading=false;
                    	if(activeGrid=="eqt230skrvGridTab"){
    	            		MasterStore.loadStoreRecords();
    	            	}

 //                       UniAppManager.setToolbarButtons('deleteAll',true);
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

            //UniAppManager.setToolbarButtons('excel',true);
        },

		onResetButtonDown: function() {
			masterForm.clearForm();
            //masterForm.clearForm();
            MasterGrid.getStore().loadData({});

            UniAppManager.setToolbarButtons('save', false);
            UniAppManager.setToolbarButtons('deleteAll', false);
            UniAppManager.setToolbarButtons('delete', false);
            UniAppManager.setToolbarButtons('newData', false);
			this.fnInitBinding();
		},

		onNewDataButtonDown: function()	{
		 if(activeGrid=="eqt230skrvGridTab"){
				var seq = MasterStore.max('STOPSEQ');
   	           	 if(!seq) seq = 1;
   	           	 else  seq += 1;
           		var r={
           			DIV_CODE:masterForm.getValue("DIV_CODE")
              		,STOPSEQ:seq
           			,MACHINEID:''
           			,STOPDATE:masterForm.getValue("STOPDATE")
           			,WORK_SHOP_CODE:masterForm.getValue('WORK_SHOP_CODE')
       				,STOPCODE:''
       				,CHECKNOTE:''
       				,RESULTS_STD:''
       				,RESULTS_METHOD:''
       				,RESULTS_ROUTINE:''
           		};

           		MasterGrid.createRow(r);
        	}
		},

		onDeleteDataButtonDown: function() {
			var selRow = MasterGrid.getSelectedRecord();

			if(activeGrid=="pmp300ukrvGridTab")
			{
				selRow= MasterGrid.getSelectedRecord();
			}

			if(selRow.phantom === true) {
				MasterGrid.getSelectedRecord();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				MasterGrid.deleteSelectedRow();
            }
			//UniAppManager.setToolbarButtons('save', true);
		},

		onSaveDataButtonDown: function() {
			if(activeGrid=="eqt230skrvGridTab")
			{
				MasterStore.saveStore();
			}
		}
	});

}
</script>
