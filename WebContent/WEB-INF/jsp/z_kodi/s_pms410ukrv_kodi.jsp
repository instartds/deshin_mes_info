<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pms410ukrv_kodi"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="W" />					<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B001" />	<!-- 발주형태 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정  -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />	<!-- 구매담당 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" />	<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" />	<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="Q031" />	<!-- 접수구분 -->
	<t:ExtComboStore comboType="AU" comboCode="Q023" />	<!-- 접수자 -->
	<t:ExtComboStore comboType="AU" comboCode="Q024" />	<!-- 검사자 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var checkDraftStatus = false;

function appMain() {
	var activeTabId = '';

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pms410ukrv_kodiService.selectList',
			update: 's_pms410ukrv_kodiService.updateDetail',
			syncAll: 's_pms410ukrv_kodiService.saveAll'
		}
	});

	/**
	 * Model 정의
	 *
	 * @type
		 */
	Unilite.defineModel('s_pms410ukrv_kodiModel', {
		fields: [
	    	{name: 'DIV_CODE'      	,text: '<t:message code="system.label.product.division" default="사업장"/>'	    ,type : 'string', comboType:'BOR120', defaultValue:UserInfo.divCode},
		    {name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	 ,type: 'string'},
		    {name: 'TREE_NAME'     	,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	 ,type: 'string'},
		    {name: 'PRODT_DATE'    	,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'	     ,type: 'uniDate'},
		    {name: 'PRODT_NUM'     	,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'	 ,type: 'string'},
		    {name: 'ITEM_ACCOUNT'   ,text: '<t:message code="system.label.product.itemaccount" default="품목계정"/>'	 ,type: 'string', comboType:'AU' , comboCode:'B020'},
		    {name: 'ITEM_CODE'     	,text: '<t:message code="system.label.product.item" default="품목"/>'	 ,type: 'string'},
		    {name: 'ITEM_NAME'     	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'	     ,type: 'string'},
		    {name: 'SPEC'          	,text: '<t:message code="system.label.product.spec" default="규격"/>'		 ,type: 'string'},
		    {name: 'PRODT_Q'       	,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'	 ,type: 'uniQty'},
		    {name: 'GOOD_PRODT_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			,type:'uniQty', allowBlank:false},
		    {name: 'LOT_NO'        	,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'	     ,type: 'string'},
		    {name: 'MICROBE_DATE'    	,text: '미생물의뢰일'	     ,type: 'uniDate'},
		    {name: 'EXPECTED_END_DATE'  ,text: '완료예정일'	     ,type: 'uniDate'},
		    {name: 'RECEIPT_DATE'  	,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'	     ,type: 'uniDate'},
		    {name: 'RECEIPT_NUM'   	,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'	 ,type: 'string'},
		    {name: 'RECEIPT_SEQ'   	,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'	 ,type: 'string'},
		    {name: 'INSPEC_DATE'  	,text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'	     ,type: 'uniDate'},
		    {name: 'INSPEC_NUM'     ,text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'  , type: 'string'},
		    {name: 'INSPEC_SEQ'     ,text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'   ,type: 'string'},
		    {name: 'RECEIPT_PRSN'  	,text: '<t:message code="system.label.product.receptionist" default="접수자"/>'	     ,type: 'string', comboType:'AU' , comboCode:'Q023'},
		    {name: 'INSPEC_PRSN'    ,text: '<t:message code="system.label.product.inspector" default="검사자"/>'      ,type: 'string' , comboType:'AU' , comboCode:'Q024'},
		    {name: 'RECEIPT_Q'      ,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'	     ,type: 'uniQty'},
		    {name: 'NOTRECEIPT_Q'  	,text: '<t:message code="system.label.product.notreceiveqty" default="미접수량"/>'	 ,type: 'uniQty'},
		    {name: 'INSPEC_Q'       ,text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'  ,type: 'uniQty'},
		    {name: 'BAD_INSPEC_Q'   ,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'      ,type: 'uniQty'},
		    {name: 'INSTOCK_Q'      ,text: '<t:message code="system.label.product.receiptqty" default="입고량"/>'      ,type: 'uniQty'},
		    {name: 'BAD_LATE'     	,text: '<t:message code="system.label.product.defectrate" default="불량률"/>'							, type: 'uniER'},
		    {name: 'NOINSPEC_Q'     ,text: '<t:message code="system.label.product.noinspecqty" default="미검사량"/>'  ,type: 'uniQty'},
		    {name:'GOODBAD_TYPE'	,text: '<t:message code="system.label.product.passyn" default="합격여부"/>'					,type:'string' , comboType:'AU' , comboCode:'M414'},
		    {name: 'RECEIPT_REMARK'	,text: '<t:message code="system.label.product.receiptremark" default="접수비고"/>'	 ,type: 'string'},
		    {name: 'INSPEC_REMARK'  ,text: '<t:message code="system.label.product.inspecremark" default="검사비고"/>'  ,type: 'string'}
		]
	});


	/**
	 * Store 정의(Service 정의)
	 *
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_pms410ukrv_kodiMasterStore',{
		model: 's_pms410ukrv_kodiModel',
		uniOpt : {
            isMaster: true,		// 상위 버튼 연결
            editable: true,		// 수정 모드 사용
            deletable: false,		// 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			param.INSPEC_ITEM = Ext.getCmp('rdoSelect1').getChecked()[0].inputValue;
			param.RECEIPT_DATE_FR = UniDate.getDateStr(panelSearch.getValue('RECEIPT_DATE_FR'));
			param.RECEIPT_DATE_TO = UniDate.getDateStr(panelSearch.getValue('RECEIPT_DATE_TO'));
			param.INSPEC_DATE_FR = UniDate.getDateStr(panelSearch.getValue('INSPEC_DATE_FR'));
			param.INSPEC_DATE_TO = UniDate.getDateStr(panelSearch.getValue('INSPEC_DATE_TO'));
			param.TOT_RECEIPT_Q = panelSearch.getValue('TOT_RECEIPT_Q');
			param.TOT_INSPEC_Q = panelSearch.getValue('TOT_INSPEC_Q');
			panelResult.setValue('PRODT_NUMS','');
			panelResult.setValue('ITEM_CODES','');
			console.log( param );
			this.load({
				params : param
			});
		},saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
                                var master = batch.operations[0].getResultSet();
								panelSearch.getForm().wasDirty = false;
								panelSearch.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);

								directMasterStore.loadStoreRecords();
								if(directMasterStore.getCount() == 0){
									UniAppManager.app.onResetButtonDown();
								}
							 }
					};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if(store.isDirty() ) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
//		groupField: 'ITEM_NAME'
	});


	/**
	 * 검색조건 (Search Panel)
	 *
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	    		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	    		name: 'DIV_CODE',
	    		xtype: 'uniCombobox',
	    		comboType: 'BOR120' ,
	    		width:285,
	    		allowBlank:false,
	    		value : UserInfo.divCode,
	    		listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
		    },
		    	Unilite.popup('ITEM',{
		    		fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
		    		valueFieldName:'ITEM_CODE',
		    		textFieldName:'ITEM_NAME',
		    		textFieldWidth:100,
		    		validateBlank: false,
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					}
		   	}),{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
		    	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
		    	name:'WORK_SHOP_CODE',
		    	xtype: 'uniCombobox',
		    	width:285,
		    	comboType:'W',
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WORK_SHOP_CODE', newValue);
						},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
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
		    },{
		    	fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_DATE_FR',
	        	endFieldName:'PRODT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('PRODT_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PRODT_DATE_TO',newValue);
				    	}
				    }
			}]
		},{
				xtype		: 'radiogroup',
				fieldLabel	: '검사품목',
				id			: 'rdoSelect1',
				items		: [{
					boxLabel	: '반제품',
					name		: 'INSPEC_ITEM',
					width		: 80,
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '제품',
					name		: 'INSPEC_ITEM',
					width		: 70,
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('INSPEC_ITEM').setValue(newValue.INSPEC_ITEM);
					}
				}
			},{
			title: '<t:message code="system.label.product.basisinfo" default="추가정보"/>',
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
						fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
						xtype: 'uniDateRangefield',
						startFieldName: 'RECEIPT_DATE_FR',
			        	endFieldName:'RECEIPT_DATE_TO',
						width: 315
//						startDate: UniDate.get('startOfMonth'),
//						endDate: UniDate.get('today')
					},{
					    fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
						xtype: 'uniDateRangefield',
						startFieldName: 'INSPEC_DATE_FR',
			        	endFieldName:'INSPEC_DATE_TO',
						width: 315
//						startDate: UniDate.get('startOfMonth'),
//						endDate: UniDate.get('today')
					},{
						fieldLabel: '접수구분',
						name:'TOT_RECEIPT_Q',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'Q031'
//						value: 'N'
				  },{
						fieldLabel: '검사구분',
						name:'TOT_INSPEC_Q',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'Q032'
//						value: 'N'
		  }]
		}]
    });

    var panelResult = Unilite.createSimpleForm('s_pms410ukrv_kodipanelResult', {
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
	    		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	    		name: 'DIV_CODE',
	    		xtype: 'uniCombobox',
	    		comboType: 'BOR120' ,
	    		allowBlank:false,
	    		value : UserInfo.divCode,
	    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
		    },
	    	Unilite.popup('ITEM',{
	    		fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
	    		valueFieldName:'ITEM_CODE',
	    		textFieldName:'ITEM_NAME',
	    		validateBlank: false,
	    		listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				}
		   	}),{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			} ,
/**			{
				text:'<div style="color: red"><t:message code="system.label.product.inspecgradereportprint" default="검사의뢰서출력"/></div>',
	            xtype: 'button',
	            margin: '0 0 0 15',
	            handler: function(){
	            	if(!panelResult.getInvalidMessage()) return;   //필수체크
	            	var selectedRecords ;
    				selectedRecords = masterGrid.getSelectedRecords();

	              if(Ext.isEmpty(selectedRecords)){
	                  alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
	                  return;
	              }

	              var param = panelResult.getValues();

	              param["dataCount"] = selectedRecords.length;
	              param["sTxtValue2_fileTitle"]='검사결과서';
	              param["PGM_ID"]='pms300skrv';
	              param["MAIN_CODE"]='P010';
	              param.RECEIPT_DATE_FR = UniDate.getDateStr(panelSearch.getValue('RECEIPT_DATE_FR'));
	  			  param.RECEIPT_DATE_TO = UniDate.getDateStr(panelSearch.getValue('RECEIPT_DATE_TO'));
	              if(activeTabId == 'set210ukrvGridTab1'){
		            	param["SEL_TAB"] = '01';
	    			}else if(activeTabId == 'set210ukrvGridTab2'){
	    				param["SEL_TAB"] = '02';
	    			}else{
	    				param["SEL_TAB"] = '03';
	    		 }
	              var win = '';
	 				 	win = Ext.create('widget.ClipReport', {
	 		                url: CPATH+'/prodt/pms300clrkrv.do',
	 		                prgID: 'pms300skrv',
	 		                extParam: param
	 		            });
	 					win.center();
	 					win.show();
	            }
	       },		**/
	       {
	           text:'<div style="color: red">공정이동전표발행</div>',
	           xtype: 'button',
	           colspan: 2,
	           margin: '0 0 0 238',
	           handler: function(){
	           		UniAppManager.app.onPrintButtonDown();
	           }

	      },{
                fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
                name:'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                comboType:'W',
                listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    	panelSearch.setValue('WORK_SHOP_CODE', newValue);
                    },
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
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
            },{
            	fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'PRODT_DATE_FR',
                endFieldName:'PRODT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('PRODT_DATE_FR',newValue);

                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('PRODT_DATE_TO',newValue);
                    }
                }
            },{
				xtype		: 'radiogroup',
				fieldLabel	: '검사품목',
				id			: 'rdoSelect2',
				items		: [{
					boxLabel	: '반제품',
					name		: 'INSPEC_ITEM',
					width		: 80,
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '제품',
					name		: 'INSPEC_ITEM',
					width		: 70,
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('INSPEC_ITEM').setValue(newValue.INSPEC_ITEM);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '성적서 구분',
				id			: 'rdoPrintGubun',
				items		: [{
					boxLabel	: '한글',
					name		: 'PRINT_GUBUN',
					width		: 60,
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '영문',
					name		: 'PRINT_GUBUN',
					width		: 60,
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			},{
              text:'<div style="color: red"><t:message code="system.label.product.inspecgradereportprint" default="공정검서성적출력"/></div>',
              xtype: 'button',
              margin: '0 0 0 15',
              colspan		: 2,
              handler: function(){
              	if(!panelResult.getInvalidMessage()) return;   //필수체크

                var selectedRecords = masterGrid.getSelectedRecords();
                if(Ext.isEmpty(selectedRecords)){
                    alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
                    return;
                }
                var param = panelResult.getValues();
                var inspecNums = '';
                Ext.each(selectedRecords, function(record, idx) {
                    if(idx ==0) {
						inspecNums	= inspecNums + record.get('INSPEC_NUM') + record.get('INSPEC_SEQ');
					}else{
						inspecNums	= inspecNums + ',' + record.get('INSPEC_NUM') + record.get('INSPEC_SEQ');
					}
                });

                param["dataCount"] = selectedRecords.length;
                param["INSPEC_NUMS2"] = inspecNums;
                param["sTxtValue2_fileTitle"]='검사결과서';

                param["RPT_ID"]='pms410rkrv';
                param["PGM_ID"]='pms410skrv';
                param["MAIN_CODE"]='P010';
                var win = '';
			 	win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/prodt/pms410clrkrv.do',
	                prgID: 'pms410skrv',
	                extParam: param
	            });
				win.center();
				win.show();


              }
         },{
    			fieldLabel: 'PRODT_NUMS',
    			xtype: 'uniTextfield',
    			name: 'PRODT_NUMS',
    			hidden: true
    		},{
    			fieldLabel: 'ITEM_CODES',
    			xtype: 'uniTextfield',
    			name: 'ITEM_CODES',
    			hidden: true
    		},{
			fieldLabel: 'INSPEC_NUMS',
			xtype: 'uniTextfield',
			name: 'INSPEC_NUMS',
			hidden: true
		}]
    });

    /**
	 * Master Grid1 정의(Grid Panel)
	 *
	 * @type
	 */

    var masterGrid = Unilite.createGrid('s_pms410ukrv_kodiGrid', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore,
        selModel: 'rowmodel',
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },selModel : Ext.create("Ext.selection.CheckboxModel", {
        	singleSelect : true ,
        	checkOnly : false,showHeaderCheckbox :true,
        	listeners: {
        		select: function(grid, selectRecord, index, rowIndex, eOpts ){
        			if(Ext.isEmpty(panelResult.getValue('PRODT_NUMS'))) {
						panelResult.setValue('PRODT_NUMS', selectRecord.get('PRODT_NUM'));
					} else {
						var prodtNums = panelResult.getValue('PRODT_NUMS');
						prodtNums = prodtNums + ',' + selectRecord.get('PRODT_NUM');
						panelResult.setValue('PRODT_NUMS', prodtNums);
					}
        			if(Ext.isEmpty(panelResult.getValue('ITEM_CODES'))) {
						panelResult.setValue('ITEM_CODES', selectRecord.get('ITEM_CODE'));
					} else {
						var itemCodes = panelResult.getValue('ITEM_CODES');
						itemCodes = itemCodes + ',' + selectRecord.get('ITEM_CODE') ;
						panelResult.setValue('ITEM_CODES', itemCodes);
					}

        			if(Ext.isEmpty(panelResult.getValue('INSPEC_NUMS'))) {
						panelResult.setValue('INSPEC_NUMS', selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ'));
					} else {
						var inspecNums = panelResult.getValue('INSPEC_NUMS');
						inspecNums = inspecNums + ',' + selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');
						panelResult.setValue('INSPEC_NUMS', inspecNums);
					}
        		},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var prodtNums	 = panelResult.getValue('PRODT_NUMS');
					var deselectedNum0  = selectRecord.get('PRODT_NUM') + ',';
					var deselectedNum1  = ',' + selectRecord.get('PRODT_NUM');
					var deselectedNum2  = selectRecord.get('PRODT_NUM');

					prodtNums = prodtNums.split(deselectedNum0).join("");
					prodtNums = prodtNums.split(deselectedNum1).join("");
					prodtNums = prodtNums.split(deselectedNum2).join("");

					var itemCodes	 = panelResult.getValue('ITEM_CODES');
					var deselectedNum00  = selectRecord.get('ITEM_CODE') + ',';
					var deselectedNum11  = ',' + selectRecord.get('ITEM_CODE') ;
					var deselectedNum22  = selectRecord.get('ITEM_CODE') ;

					itemCodes = itemCodes.split(deselectedNum00).join("");
					itemCodes = itemCodes.split(deselectedNum11).join("");
					itemCodes = itemCodes.split(deselectedNum22).join("");

					var inspecNums	 = panelResult.getValue('INSPEC_NUMS');
					var deselectedNum0  = selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ') + ',';
					var deselectedNum1  = ',' + selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');
					var deselectedNum2  = selectRecord.get('INSPEC_NUM') + selectRecord.get('INSPEC_SEQ');

					inspecNums = inspecNums.split(deselectedNum0).join("");
					inspecNums = inspecNums.split(deselectedNum1).join("");
					inspecNums = inspecNums.split(deselectedNum2).join("");

					panelResult.setValue('PRODT_NUMS', prodtNums);
					panelResult.setValue('ITEM_CODES', itemCodes);
					panelResult.setValue('INSPEC_NUMS', inspecNums);
				}

        	}
        }),
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true}
    	],
        columns: [
        	{dataIndex: 'DIV_CODE'      	, width: 100, hidden :true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80},
			{dataIndex: 'TREE_NAME'     	, width: 80},
			{dataIndex: 'PRODT_DATE'    	, width: 93},
			{dataIndex: 'PRODT_NUM'     	, width: 120},
			{dataIndex: 'ITEM_ACCOUNT'     	, width: 90},
			{dataIndex: 'ITEM_CODE'     	, width: 100},
			{dataIndex: 'ITEM_NAME'     	, width: 160},
			{dataIndex: 'SPEC'          	, width: 100},
			{dataIndex: 'PRODT_Q'       	, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_PRODT_Q'      , width: 100, summaryType: 'sum'},
			{dataIndex: 'LOT_NO'        	, width: 100},
			{dataIndex: 'MICROBE_DATE'    	, width: 93},
			{dataIndex: 'EXPECTED_END_DATE' , width: 93},
			{dataIndex: 'RECEIPT_DATE'  	, width: 93},
			{dataIndex: 'RECEIPT_NUM'   	, width: 120},
			{dataIndex: 'RECEIPT_SEQ'   	, width: 70, align: 'center'},
			{dataIndex: 'INSPEC_DATE'    	, width: 93},
			{dataIndex:'INSPEC_NUM'	, width: 120},
			{dataIndex:'INSPEC_SEQ'	, width: 70, align: 'center'},
			{dataIndex: 'RECEIPT_PRSN'  	, width: 100, align: 'center'},
			{dataIndex: 'INSPEC_PRSN'  	, width: 100, align: 'center'},
			{dataIndex: 'RECEIPT_Q'     	, width: 100, summaryType: 'sum'},
			{dataIndex: 'NOTRECEIPT_Q'       , width: 100, summaryType: 'sum'},
			{dataIndex: 'INSPEC_Q'          , width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_INSPEC_Q'      , width: 100, summaryType: 'sum'},
			{dataIndex: 'INSTOCK_Q'      , width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_LATE'      , width: 100},
			{dataIndex: 'NOINSPEC_Q'       , width: 100, summaryType: 'sum'},
			{dataIndex: 'GOODBAD_TYPE'	, width: 80, align: 'center'},
			{dataIndex: 'RECEIPT_REMARK'	, width: 133},
			{dataIndex: 'RECEIPT_REMARK'	, width: 133}
		],
		listeners: {
				beforeedit  : function( editor, e, eOpts ) {
	      			if(checkDraftStatus)	{
	      				return false;
	      			}else if(e.record.data.INSPEC_NUM == "") {
	      				return false;
	      			}else if(e.record.data.INSPEC_NUM != "") {
		      			if(!e.record.phantom )	{
							if (UniUtils.indexOf(e.field,
													['WORK_SHOP_CODE','TREE_NAME','PRODT_DATE','PRODT_NUM','ITEM_ACCOUNT','ITEM_CODE','ITEM_NAME','SPEC','PRODT_Q','GOOD_PRODT_Q',
													 'LOT_NO','RECEIPT_DATE','RECEIPT_NUM','RECEIPT_SEQ','INSPEC_DATE', 'INSPEC_NUM', 'INSPEC_SEQ', 'RECEIPT_PRSN', 'INSPEC_PRSN',
													 'RECEIPT_Q','NOTRECEIPT_Q','INSPEC_Q','BAD_INSPEC_Q','INSTOCK_Q','BAD_LATE','NOINSPEC_Q','GOODBAD_TYPE','RECEIPT_REMARK','RECEIPT_REMARK']) )
									return false;
						}
	      			}
				}
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
      },
         panelSearch
      ],
		id: 's_pms410ukrv_kodiApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},

		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{

			masterGrid.getStore().loadStoreRecords();

			var viewNormal = masterGrid.getView();
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);

			}
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();

		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
        onPrintButtonDown: function() {
	        	if(!panelResult.getInvalidMessage()) return;	//필수체크

	        	 var selectedRecords ;

    				selectedRecords = masterGrid.getSelectedRecords();
		            if(Ext.isEmpty(selectedRecords)){
		                alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
		                return;
		            }

	            var param = panelResult.getValues();
	            param.RECEIPT_DATE_FR = UniDate.getDateStr(panelSearch.getValue('RECEIPT_DATE_FR'));
	  			param.RECEIPT_DATE_TO = UniDate.getDateStr(panelSearch.getValue('RECEIPT_DATE_TO'));
	            param["dataCount"] = selectedRecords.length;
	            param["sTxtValue2_fileTitle"]='검사결과서';

	            param["PGM_ID"]='pms300skrv';
	            param["MAIN_CODE"]='P010';

	            if(activeTabId == 'set210ukrvGridTab1'){
	            	param["SEL_TAB"] = '01';
    			}else if(activeTabId == 'set210ukrvGridTab2'){
    				param["SEL_TAB"] = '02';
    			}else{
    				param["SEL_TAB"] = '03';
    			}
	            console.log("111111:"+param["dataCount"])
	            console.log("2222:"+param["PRODT_NUM"])
	            var win = '';
	           		 win = Ext.create('widget.ClipReport', {
		                    url: CPATH+'/prodt/pms300clrkrv_label.do',
		                    prgID: 'pms300skrv',
		                    extParam: param
		                });
		                    win.center();
		                    win.show();

		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};


</script>
