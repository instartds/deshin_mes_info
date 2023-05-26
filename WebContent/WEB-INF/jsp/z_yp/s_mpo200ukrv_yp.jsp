<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo200ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mpo200ukrv_yp" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P401" /> <!-- 확정여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B019" /> <!-- 국내외구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위-->
	<t:ExtComboStore comboType="AU" comboCode="Q032" /> <!-- 검사여부-->
	<t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="MPO200ukrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="MPO200ukrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="MPO200ukrvLevel3Store" />
</t:appConfig>
<script type="text/javascript" >
var referPurchaseWindow;	//구매요청참조
var BsaCodeInfo = {
	gsApproveYN: '${gsApproveYN}',
	gsExchgRegYN: '${gsExchgRegYN}',
	gsOrderPrsn: '${gsOrderPrsn}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};

var isExchgReg = false;
if(BsaCodeInfo.gsExchgRegYN =='Y')    {
    isExchgReg = true;
}
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);
*/

var outDivCode = UserInfo.divCode;
var isErr = false;
function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_mpo200ukrv_ypService.gridDown',
			update: 's_mpo200ukrv_ypService.updateDetail',
			syncAll: 's_mpo200ukrv_ypService.orderConfirm'
		}
	});

	var adjustProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_mpo200ukrv_ypService.selectAdjustList',
            update: 's_mpo200ukrv_ypService.updateAdjust',
            syncAll: 's_mpo200ukrv_ypService.saveAll'
        }
    });

	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo200ukrvModel', {
	    fields: [
	    	{name: 'CHK'                   ,text: 'CHK'             ,type: 'string'},
            {name: 'CONFIRM_YN'            ,text: '확정여부'           ,type: 'string'},
            {name: 'COMP_CODE'             ,text: 'COMP_CODE'        ,type: 'string'},
            {name: 'DIV_CODE'              ,text: '사업장'            ,type: 'string',comboType:'BOR120'},
            {name: 'CUSTOM_CODE'           ,text: '거래처'            ,type: 'string', allowBlank: false},
            {name: 'CUSTOM_NAME'           ,text: '거래처명'           ,type: 'string', allowBlank: false},
            {name: 'ORDER_DATE'            ,text: '발주일'             ,type: 'uniDate', allowBlank: false},
            {name: 'ORDER_PLAN_DATE'       ,text: '발주예정일'          ,type: 'uniDate'},
            {name: 'ORDER_NUM'             ,text: '발주번호'           ,type: 'string'},
            {name: 'SUPPLY_TYPE'           ,text: '조달구분'           ,type: 'string',comboType:'AU', comboCode:'B014'},
            {name: 'ORDER_TYPE'            ,text: '발주형태'           ,type: 'string',comboType:'AU', comboCode:'M001'},
            {name: 'ORDER_PRSN'            ,text: '구매담당'           ,type: 'string',comboType:'AU', comboCode:'M201', allowBlank: false},
            {name: 'ORDER_PRSN1'           ,text: '담당자'            ,type: 'string'},
            {name: 'AGREE_PRSN'            ,text: '승인자'            ,type: 'string'},
            {name: 'AGREE_NAME'            ,text: '승인자명'           ,type: 'string'},
            {name: 'MONEY_UNIT'            ,text: '화폐'              ,type: 'string',comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'EXCHG_RATE_O'          ,text: '환율'              ,type: 'uniER'},
            {name: 'ORDER_O'               ,text: '발주금액'           ,type: 'string'},
            {name: 'AGREE_STATUS'          ,text: '승인상태'           ,type: 'string'},
            {name: 'CHECKTYPE'             ,text: '체크상태'           ,type: 'string'},
            {name: 'CHECKSEQ'              ,text: '체크순번'           ,type: 'int'},
            {name: 'REMARK'                ,text: '비고'              ,type: 'string'},
            {name: 'USER_ID'               ,text: 'USER_ID'          ,type: 'string'},
            {name: 'ORDER_REQ_PRSN'        ,text: 'ORDER_REQ_PRSN'   ,type: 'string'}
		]
	});
	Unilite.defineModel('Mpo200ukrvModel2', {
	    fields: [
	    	{name: 'CHK'		           ,text: '선택'              ,type: 'string'},
            {name: 'COMP_CODE'		       ,text: 'COMP_CODE'        ,type: 'string'},
            {name: 'DIV_CODE'		       ,text: '사업장'             ,type: 'string'},
            {name: 'CUSTOM_CODE'	       ,text: '거래처'             ,type: 'string'},
            {name: 'ORDER_NUM'		       ,text: '발주번호'            ,type: 'string'},
            {name: 'ORDER_SEQ'		       ,text: '순번'               ,type: 'int'},
            {name: 'ITEM_CODE'		       ,text: '품목코드'            ,type: 'string'},
            {name: 'ITEM_NAME'		       ,text: '품목명'              ,type: 'string'},
            {name: 'SPEC'			       ,text: '규격'               ,type: 'string'},
            {name: 'STOCK_UNIT'		       ,text: '재고단위'            ,type: 'string',comboType:'AU', comboCode:'B013', displayField: 'value'},
            {name: 'ORDER_UNIT_Q'	       ,text: '발주량'              ,type: 'uniQty'},
            {name: 'ORDER_UNIT'		       ,text: '구매단위'             ,type: 'string' ,comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false},
            {name: 'UNIT_PRICE_TYPE'       ,text: '단가형태'             ,type: 'string',comboType:'AU', comboCode:'M301', allowBlank: false},
            {name: 'ORDER_UNIT_P'	       ,text: '단가'               ,type: 'uniUnitPrice'},
            {name: 'ORDER_O'		       ,text: '금액'               ,type: 'uniPrice'},
            {name: 'DVRY_DATE'		       ,text: '납기일'              ,type: 'uniDate', allowBlank: false},
            {name: 'WH_CODE'		       ,text: '납품창고'            ,type: 'string', allowBlank: false, store: Ext.data.StoreManager.lookup('whList')},
            {name: 'INSPEC_YN'		       ,text: '품질대상여부'          ,type: 'string',comboType:'AU', comboCode:'Q032'},
            {name: 'TRNS_RATE'		       ,text: '입수'               ,type: 'string'},
            {name: 'ORDER_Q'		       ,text: '재고단위량'           ,type: 'uniQty'},
            {name: 'MONEY_UNIT'		       ,text: '화폐단위'            ,type: 'string'},
            {name: 'ORDER_P'		       ,text: '재고단가'            ,type: 'uniPrice'},
            {name: 'CONTROL_STATUS'	       ,text: '진행상태'            ,type: 'string',comboType:'AU', comboCode:'M002'},
            {name: 'ORDER_REQ_NUM'	       ,text: '발주예정번호'          ,type: 'string'},
            {name: 'PURCH_LDTIME'	       ,text: '리드타임'            ,type: 'string'},
            {name: 'BASIS_DATE'		       ,text: '기준일'              ,type: 'string'},
            {name: 'CREATE_DATE'	       ,text: '생성일'              ,type: 'uniDate'},
            {name: 'ORDER_PLAN_DATE'       ,text: '발주일'              ,type: 'uniDate'},
            {name: 'SUPPLY_TYPE'	       ,text: '조달구분'            ,type: 'string'},
            {name: 'CHECKSEQ'		       ,text: '체크순번'            ,type: 'int'},
            {name: 'UPDATE_DB_USER'        ,text: 'UPDATE_DB_USER'    ,type: 'string'},
            {name: 'UPDATE_DB_TIME'        ,text: 'UPDATE_DB_TIME'    ,type: 'string'},
            {name: 'ORDER_PRSN'            ,text: '구매담당'             ,type: 'string'},
            {name: 'LOT_NO'                ,text: 'LOT NO'             ,type: 'string'},
            {name: 'REMARK'                ,text: '비고'                ,type: 'string'},
            {name: 'PROJECT_NO'            ,text: '관리번호'             ,type: 'string'},
            {name: 'SO_NUM'                ,text: '수주번호'             ,type: 'string'},
            {name: 'SO_SEQ'                ,text: '수주순번'             ,type: 'int'},
            //마스터 정보
            {name: 'ORDER_DATE'            ,text: '발주일'      ,type: 'uniDate'},
            {name: 'ORDER_TYPE'            ,text: '발주형태'     ,type: 'string'},
            {name: 'ORDER_PRSN1'           ,text: '담당자'      ,type: 'string'},
            {name: 'AGREE_PRSN'            ,text: '승인자'      ,type: 'string'},
            {name: 'AGREE_NAME'            ,text: '승인자명'     ,type: 'string'},
            {name: 'EXCHG_RATE_O'          ,text: '환율'       ,type: 'uniER'},
            {name: 'AGREE_STATUS'          ,text: '승인상태'     ,type: 'string'},
            {name: 'CHECKTYPE'             ,text: '체크상태'     ,type: 'string'},
            {name: 'SAVE_FLAG'             ,text: 'SAVE_FLAG' ,type: 'string', defaulutValue: 'N'}
		]
	});

	Unilite.defineModel('Mpo200ukrvModel3', {  //구매요청정보조정
        fields: [
            {name: 'COMP_CODE'                             ,text: 'COMP_CODE'            ,type: 'string'},
            {name: 'DIV_CODE'                              ,text: '사업장'                 ,type: 'string'},
            {name: 'ORDER_PLAN_DATE'                       ,text: '발주예정일'              ,type: 'uniDate'},
            {name: 'CUSTOM_CODE'                           ,text: '거래처코드'              ,type: 'string'},
            {name: 'CUSTOM_NAME'                           ,text: '거래처'                 ,type: 'string'},
            {name: 'PROD_ITEM_CODE'                        ,text: '모품목코드'              ,type: 'string'},
            {name: 'ITEM_CODE'                             ,text: '품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'                             ,text: '품명'                  ,type: 'string'},
            {name: 'SPEC'                                  ,text: '규격'                  ,type: 'string'},
            {name: 'ORDER_PLAN_Q'                          ,text: '발주예정량'              ,type: 'uniQty'},
            {name: 'STOCK_UNIT'                            ,text: '단위'                  ,type: 'string',comboType:'AU', comboCode:'B013', displayField: 'value'},
            {name: 'BASIS_DATE'                            ,text: '생산시작일'              ,type: 'uniDate'},
            {name: 'REQ_PLAN_Q'                            ,text: '요청량'                 ,type: 'uniQty'},
            {name: 'SUPPLY_TYPE'                           ,text: '조달구분'                ,type: 'string',comboType:'AU', comboCode:'B014'},
            {name: 'PAB_STOCK_Q'                           ,text: '가용재고량'               ,type: 'string'},
            {name: 'EXCHG_EXIST_YN'                        ,text: '대체품목존재여부'           ,type: 'string'},
            {name: 'REF_ITEM_CODE'                         ,text: '대체전품목코드'            ,type: 'string'},
            {name: 'REF_ITEM_NAME'                         ,text: '대체전품목명'             ,type: 'string'},
            {name: 'EXCHG_YN'                              ,text: '대체여부'                ,type: 'string'},
            {name: 'DOM_FORIGN'                            ,text: '국내외구분'              ,type: 'string',comboType:'AU', comboCode:'B019'},
            {name: 'ORDER_REQ_DEPT_CODE'                   ,text: '요청부서'                ,type: 'string'},
            {name: 'ORDER_PRSN'                            ,text: '구매담당'                ,type: 'string',comboType:'AU', comboCode:'M201'},
            {name: 'ORDER_YN'                              ,text: '진행상태'                ,type: 'string',comboType:'AU', comboCode:'M002'},
            {name: 'ORDER_NUM'                             ,text: '수주번호'                ,type: 'string'},
            {name: 'ORDER_SEQ'                             ,text: '수주순번'                ,type: 'string'},
            {name: 'ORDER_REQ_NUM'                         ,text: '요청번호'                ,type: 'string'},
            {name: 'MRP_CONTROL_NUM'                       ,text: '수급계획번호'              ,type: 'string'},
            {name: 'WKORD_NUM'                             ,text: '작업지시번호'              ,type: 'string'},
            {name: 'ITEM_ACCOUNT'                          ,text: '품목계정'                ,type: 'string'},
            {name: 'PURCH_LDTIME'                          ,text: '구매리드타임'              ,type: 'string'},
            {name: 'CREATE_DATE'                           ,text: '요청일'                  ,type: 'uniDate'},
            {name: 'MRP_YN'                                ,text: '소요량구분'               ,type: 'string'},
            {name: 'LOT_NO'                                ,text: 'LOT NO'                ,type: 'string'},
            {name: 'REMARK'                                ,text: '비고'                   ,type: 'string'},
            {name: 'PROJECT_NO'                            ,text: '관리번호'                ,type: 'string'},

            {name: 'DVRY_DATE'                            ,text: '납기일'                ,type: 'uniDate'},
            {name: 'ORDER_DVRY_DATE'                      ,text: '납기일'                ,type: 'uniDate'},
            {name: 'ORDER_CUSTOM_NAME'                    ,text: '수주처'                ,type: 'string'},
            {name: 'PROD_END_DATE'                    ,text: '생산완료요청일'                ,type: 'uniDate'},
            {name: 'EXP_ISSUE_DATE'                    ,text: '출하예정일'                ,type: 'uniDate'}

        ]
    });
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_mpo200ukrv_ypMasterStore1',{
		model: 'Mpo200ukrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결
           	editable: true,			// 수정 모드 사용
           	deletable: false,			// 삭제 가능 여부
	        useNavi: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 's_mpo200ukrv_ypService.gridUp'
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
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	var directMasterStore2 = Unilite.createStore('s_mpo200ukrv_ypMasterStore2', {
		model: 'Mpo200ukrvModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: directProxy,
		loadStoreRecords: function(record){
			var param = record.data;
			param.ORDER_PLAN_DATE = UniDate.getDbDateStr(record.get('ORDER_PLAN_DATE'));
			param.ORDER_TO_DATE = UniDate.getDbDateStr(panelResult.getValue('ORDER_TO_DATE'));
//			var record = masterGrid.getSelectedRecord();
//			param.CUSTOM_CODE = record.get('CUSTOM_CODE');
//			param.CUSTOM_NAME = record.get('CUSTOM_NAME');
//			param.MONEY_UNIT = record.get('MONEY_UNIT');
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
//			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var list = [].concat(toUpdate, toCreate);
       		var isErr = false;
            Ext.each(list, function(record, index) {
                if(record.data['UNIT_PRICE_TYPE'] == 'Y' && record.data['ORDER_UNIT_P'] == 0 && record.data['SAVE_FLAG'] == 'Y') {
                	if(confirm('단가가 0원입니다. 계속 진행하시겠습니까?')){
                        return false;
                	}else{
                	   isErr = true;
                        return false;
                	}
                }
            });
            if(isErr) return false;
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						var master = batch.operations[0].getResultSet();
//						directMasterStore1.loadStoreRecords();
//						masterGrid2.reset();
						masterGrid2.deleteSelectedRow();
						if(directMasterStore2.count() == 0){
							directMasterStore1.loadStoreRecords();
						}else{
						    var record = masterGrid.getSelectedRecord();
                            directMasterStore2.loadData({});
                            if(!record.phantom){
                                directMasterStore2.loadStoreRecords(record);
                            }
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
                masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners: {
            load: function(store, records, successful, eOpts) {
                isErr = false;
                var mRecord = masterGrid.getSelectedRecord();
//                if(!Ext.isEmpty(mRecord.get('ORDER_PRSN'))){
                	masterGrid2.getSelectionModel().selectAll();
//                }
            }
        }
	});

	var adjustStore = Unilite.createStore('s_mpo200ukrv_ypadjustStore', {
        model: 'Mpo200ukrvModel3',
        uniOpt: {
            isMaster: true,            // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
            autoLoad: false,
            proxy: adjustProxy,
        loadStoreRecords: function(record){
            var param = panelResult.getValues();
            this.load({
                params : param
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
            var paramMaster= panelResult.getValues();   //syncAll 수정
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        panelResult.setValue("ORDER_NUM_G", master.ORDER_NUM);
                        var orderNum = panelResult.getValue('ORDER_NUM_G');
                        Ext.each(list, function(record, index) {
                            if(record.data['ORDER_NUM'] != orderNum) {
                                record.set('ORDER_NUM', orderNum);
                            }
                        });
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);

                        directMasterStore1.loadStoreRecords();
                        masterGrid2.reset();
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('s_mpo200ukrv_ypGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			value: UserInfo.divCode
		},{
            fieldLabel: '발주예정일',
            xtype: 'uniDateRangefield',
            startFieldName: 'ORDER_FR_DATE',
            endFieldName: 'ORDER_TO_DATE',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },{
            fieldLabel: '국내외구분',
            name: 'DOM_FORIGN',
            xtype:'uniCombobox',
            comboType:'AU',
            comboCode:'B019'
        },{
            fieldLabel: '판매유형',
            name:'ORDER_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'S002'
            //value: UserInfo.divCode
        },{
            fieldLabel: '조달구분',
            name: 'SUPPLY_TYPE',
            xtype:'uniCombobox',
            comboType:'AU',
            comboCode:'B014'
        },
    	   Unilite.popup('AGENT_CUST', {
            fieldLabel: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>',
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
          //validateBlank	: false,
			autoPopup : true,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                    },
                    scope: this
                },
                onClear: function(type) {
                	panelResult.setValue('CUSTOM_CODE', '');
					panelResult.setValue('CUSTOM_NAME', '');
                },
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                }
            }
        }),{
            xtype: 'uniTextfield',
            fieldLabel: 'LOT번호',
            name: 'LOT_NO',
            colspan:2
        },{
            fieldLabel: '구매담당',
            name: 'ORDER_PRSN',
            xtype:'uniCombobox',
            comboType:'AU',
            comboCode:'M201'
        },
        Unilite.popup('DIV_PUMOK',{
            fieldLabel: '품목코드',
            valueFieldName: 'ITEM_CODE',
            textFieldName: 'ITEM_NAME',
          //validateBlank	: false,
			autoPopup : true,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                    },
                    scope: this
                },
                onClear: function(type) {
                	panelResult.setValue('ITEM_CODE', '');
					panelResult.setValue('ITEM_NAME', '');
                },
                applyextparam: function(popup){
                    popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                }
            }
       }),{
           width: 100,
           xtype: 'button',
           text: '구매오더 확정',
           id: 'confirmBtn',
           colspan:2,
           margin: '0 0 0 95',
           handler : function() {
               	var detailSelectedRecs = masterGrid2.getSelectedRecords();
                if(detailSelectedRecs.length == 0) return false;
                if(confirm("확정 하시겠습니까?")){
                	var mRecord = masterGrid.getSelectedRecord();
                    if(Ext.isEmpty(mRecord.get('ORDER_PRSN'))){
                       alert('구매담당은 필수 입니다.');
                       return false;
                    }
                    directMasterStore2.saveStore();
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
    var masterGrid= Unilite.createGrid('s_mpo200ukrv_ypGrid', {
    	region: 'center' ,
        layout: 'fit',
        excelTitle: '구매오더 조정/확정',
//        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true }),
		uniOpt: {
			allowDeselect : false,
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns: [
//        	{dataIndex:'CHK'                   , width: 100, hidden: true },
//        	{xtype : 'checkcolumn', text : '거래처일괄적용', dataIndex : 'CUST_APPLY', width:100,
//        	   listeners:{
//                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
//                        var grdRecord = masterGrid.getStore().getAt(rowIndex);
//                        if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))){
//                            alert('거래처를 선택해 주세요.');
//                            grdRecord.set('CUST_APPLY', false);
//                            return false;
//                        }
//                        if(checked == true){
//                            if(Ext.isEmpty(grdRecord.get('CUSTOM_CODE'))){
//                                grdRecord.set('CUST_APPLY', true);
//                            }else{
//                                grdRecord.set('CUST_APPLY', false);
//                            }
//                        }
//                    }
//                }
//        	},
            {dataIndex:'CONFIRM_YN'            , width: 100, hidden: true },
            {dataIndex:'COMP_CODE'             , width: 100, hidden: true },
            {dataIndex:'DIV_CODE'              , width: 100, hidden: true },
            {dataIndex:'CUSTOM_CODE'           , width: 100 },
            {dataIndex:'CUSTOM_NAME'           , width: 160 },
            {dataIndex:'ORDER_DATE'            , width: 100 },
            {dataIndex:'ORDER_PLAN_DATE'       , width: 100 },
            {dataIndex:'ORDER_NUM'             , width: 120, hidden: true },
            {dataIndex:'SUPPLY_TYPE'           , width: 100, hidden: true },
            {dataIndex:'ORDER_TYPE'            , width: 100 },
            {dataIndex:'ORDER_PRSN'            , width: 100 },
            {dataIndex:'ORDER_PRSN1'           , width: 100, hidden: true },
            {dataIndex:'AGREE_PRSN'            , width: 100, hidden: true },
            {dataIndex: 'AGREE_NAME'   ,   width: 150,
                'editor' : Unilite.popup('USER_G',{
                        DBtextFieldName: 'USER_NAME',
                        autoPopup: true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    grdRecord = masterGrid.uniOpt.currentRecord;
                                    record = records[0];
                                    grdRecord.set('AGREE_PRSN', record.USER_ID);
                                    grdRecord.set('AGREE_NAME', record.USER_NAME);
                                    var detailSelectedRecs = masterGrid2.getSelectedRecords();
                                    Ext.each(detailSelectedRecs, function(rec, i){
                                        rec.set('AGREE_PRSN', record.USER_ID);
                                        rec.set('AGREE_NAME', record.USER_NAME);
                                    });
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('AGREE_PRSN', '');
                                grdRecord.set('AGREE_NAME', '');
                                var detailSelectedRecs = masterGrid2.getSelectedRecords();
                                Ext.each(detailSelectedRecs, function(rec, i){
                                    rec.set('AGREE_PRSN', '');
                                    rec.set('AGREE_NAME', '');
                                });
                            }/*,
                            applyextparam: function(popup){
                                grdRecord = Ext.getCmp('tab_pay').down('#aba060ukrs3Grid').getSelectedRecord();
                                popup.setExtParam({'ALLOW_TAG'  : grdRecord.data.ALLOW_TAG});
                            }*/
                        }
                    })
              },
//            {dataIndex:'AGREE_NAME'            , width: 100 },
            {dataIndex:'MONEY_UNIT'            , width: 100 },
            {dataIndex:'EXCHG_RATE_O'          , width: 100 },
            {dataIndex:'ORDER_O'               , width: 100, hidden: true },
            {dataIndex:'AGREE_STATUS'          , width: 100, hidden: true },
            {dataIndex:'CHECKTYPE'             , width: 100, hidden: true },
            {dataIndex:'CHECKSEQ'              , width: 100, hidden: true },
            {dataIndex:'REMARK'                , width: 100 }
        ],
        listeners: {
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    directMasterStore2.loadData({});
                    if(!record.phantom){
                        directMasterStore2.loadStoreRecords(record);
                    }
                }
            },
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_DATE','ORDER_TYPE', 'ORDER_PRSN', 'AGREE_NAME', 'MONEY_UNIT', 'EXCHG_RATE_O'])){
					return true;
				}else{
					return false;
				}
			}
		}
    });

    var masterGrid2 = Unilite.createGrid('s_mpo200ukrv_ypGrid2', {
		layout: 'fit',
		region: 'south',
		excelTitle: '구매오더 조정/확정(detail)',
		selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true }),
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
		store: directMasterStore2,
		columns: [
				{dataIndex: 'CHK'		           ,width:100, hidden: true},
                {dataIndex: 'COMP_CODE'		       ,width:100, hidden: true},
                {dataIndex: 'DIV_CODE'		       ,width:100, hidden: true},
                {dataIndex: 'CUSTOM_CODE'	       ,width:100, hidden: true},
                {dataIndex: 'ORDER_NUM'		       ,width:100, hidden: true},
                {dataIndex: 'ORDER_SEQ'		       ,width:60, align: 'center'},
                {dataIndex: 'ITEM_CODE'		       ,width:80},
                {dataIndex: 'ITEM_NAME'		       ,width:140},
                {dataIndex: 'SPEC'			       ,width:100},
                {dataIndex: 'STOCK_UNIT'		   ,width:80, align: 'center'},
                {dataIndex: 'ORDER_UNIT_Q'	       ,width:100},
                {dataIndex: 'ORDER_UNIT'		   ,width:80, align: 'center'},
                {dataIndex: 'UNIT_PRICE_TYPE'      ,width:100},
                {dataIndex: 'ORDER_UNIT_P'	       ,width:100},
                {dataIndex: 'ORDER_O'		       ,width:100},
                {dataIndex: 'DVRY_DATE'		       ,width:100},
                {dataIndex: 'WH_CODE'		       ,width:100},
                {dataIndex: 'INSPEC_YN'		       ,width:100},
                {dataIndex: 'TRNS_RATE'		       ,width:60, align: 'right'},
                {dataIndex: 'ORDER_Q'		       ,width:100},
                {dataIndex: 'MONEY_UNIT'		   ,width:100, hidden: true},
                {dataIndex: 'ORDER_P'		       ,width:100, hidden: true},
                {dataIndex: 'CONTROL_STATUS'	   ,width:100},
                {dataIndex: 'ORDER_REQ_NUM'	       ,width:100},
                {dataIndex: 'PURCH_LDTIME'	       ,width:100, hidden: true},
                {dataIndex: 'BASIS_DATE'		   ,width:100, hidden: true},
                {dataIndex: 'CREATE_DATE'	       ,width:100, hidden: true},
                {dataIndex: 'ORDER_PLAN_DATE'      ,width:100, hidden: true},
                {dataIndex: 'SUPPLY_TYPE'	       ,width:100, hidden: true},
                {dataIndex: 'CHECKSEQ'		       ,width:100, hidden: true},
                {dataIndex: 'UPDATE_DB_USER'       ,width:100, hidden: true},
                {dataIndex: 'UPDATE_DB_TIME'       ,width:100, hidden: true},
                {dataIndex: 'ORDER_PRSN'           ,width:100, hidden: true},
                {dataIndex: 'LOT_NO'               ,width:100},
                {dataIndex: 'REMARK'               ,width:100},
                {dataIndex: 'PROJECT_NO'           ,width:100},

                {dataIndex: 'ORDER_DATE'           ,width:100, hidden: true},
                {dataIndex: 'ORDER_TYPE'           ,width:100, hidden: true},
                {dataIndex: 'ORDER_PRSN1'          ,width:100, hidden: true},
                {dataIndex: 'AGREE_PRSN'           ,width:100, hidden: true},
                {dataIndex: 'AGREE_NAME'           ,width:100, hidden: true},
                {dataIndex: 'EXCHG_RATE_O'         ,width:100, hidden: true},
                {dataIndex: 'AGREE_STATUS'         ,width:100, hidden: true},
                {dataIndex: 'CHECKTYPE'            ,width:100, hidden: true},
                {dataIndex: 'SO_NUM'               ,width:100, hidden: false},
                {dataIndex: 'SO_SEQ'               ,width:100, hidden: false},
                {dataIndex: 'SAVE_FLAG'            ,width:100, hidden: false}

		],
		listeners: {
			select: function(grid, record, index, eOpts ){
				var mRecord = masterGrid.getSelectedRecord();
				record.set('ORDER_DATE', mRecord.get('ORDER_DATE'));
                record.set('ORDER_TYPE', mRecord.get('ORDER_TYPE'));
                record.set('ORDER_PRSN', mRecord.get('ORDER_PRSN'));
                record.set('AGREE_PRSN', mRecord.get('AGREE_PRSN'));
                record.set('AGREE_NAME', mRecord.get('AGREE_NAME'));
                record.set('EXCHG_RATE_O', mRecord.get('EXCHG_RATE_O'));
                record.set('AGREE_STATUS', mRecord.get('AGREE_STATUS'));
                record.set('CHECKTYPE', mRecord.get('CHECKTYPE'));
                record.set('SAVE_FLAG', 'Y');
                isErr = false;
          	},
			deselect:  function(grid, record, index, eOpts ){
				var mRecord = masterGrid.getSelectedRecord();
                record.set('ORDER_DATE', '');
                record.set('ORDER_TYPE', '');
                record.set('ORDER_PRSN1', '');
                record.set('ORDER_PRSN', '');
                record.set('AGREE_PRSN', '');
                record.set('AGREE_NAME', '');
                record.set('EXCHG_RATE_O', '');
                record.set('AGREE_STATUS', '');
                record.set('CHECKTYPE', '');
                record.set('SAVE_FLAG', 'N');
			},
			selectionchange: function(){
			},
            beforeselect: function(grid, record, index, eOpts){
            	var mRecord = masterGrid.getSelectedRecord();
//            	if(Ext.isEmpty(mRecord.get('ORDER_PRSN'))){
//            	   if(!isErr){
////            	       alert('구매담당은 필수 입니다.');
//                       isErr = true;
//                       return false;
//            	   }else{
//            	       return false;
//            	   }
//            	}
            },
			beforeedit  : function( editor, e, eOpts ) {
				if(!masterGrid2.getSelectionModel().isSelected(e.record)){
                    return false;
                }
				if(UniUtils.indexOf(e.field, ['ORDER_UNIT_P','ORDER_O', 'DVRY_DATE', 'WH_CODE', 'INSPEC_YN'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});
    var adjustForm = Unilite.createSearchForm('adjustForm', { //createForm
        layout : {type : 'uniTable', columns : 4},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
//        region: 'north',
        masterGrid: masterGrid2,
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', column: 2},
            items:[
               Unilite.popup('AGENT_CUST', {
                fieldLabel: '<t:message code="Mpo501.label.CUSTOM_NAME" default="거래처"/>',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
              //validateBlank	: false,
    			autoPopup : true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	adjustForm.setValue('CUSTOM_CODE', '');
                    	adjustForm.setValue('CUSTOM_NAME', '');
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                        popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                    }
                }
            }),{
               width: 100,
               xtype: 'button',
               text: '거래처일괄적용',
               margin: '0 0 0 10',
               handler : function() {
                    if(Ext.isEmpty(adjustForm.getValue('CUSTOM_CODE'))){
                        alert('거래처를 선택해 주세요.');
                        return false;
                    }
                    var mRecord = adjustGrid.getSelectedRecords();
                    Ext.each(mRecord, function(rec, i) {
                        rec.set('CUSTOM_CODE', adjustForm.getValue('CUSTOM_CODE'));
                        rec.set('CUSTOM_NAME', adjustForm.getValue('CUSTOM_NAME'));
                    });
               }
            }]
        },{
            xtype: 'container',
            layout: {type: 'uniTable', column: 2},
            items:[{
                fieldLabel: '발주예정일',
                name: 'APPLY_ORDER_DATE',
                xtype: 'uniDatefield'
            },{
               xtype: 'button',
               text: '발주예정일일괄적용',
               margin: '0 0 0 10',
               handler : function() {
                    if(Ext.isEmpty(adjustForm.getValue('APPLY_ORDER_DATE'))){
                        alert('발주예정일을 선택해 주세요.');
                        return false;
                    }
                    var mRecord = adjustGrid.getSelectedRecords();
                    Ext.each(mRecord, function(rec, i) {
                        rec.set('ORDER_PLAN_DATE', adjustForm.getValue('APPLY_ORDER_DATE'));
                        rec.set('ORDER_PLAN_DATE', adjustForm.getValue('APPLY_ORDER_DATE'));
                    });
               }
            }]
        },{
            xtype: 'container',
            layout: {type: 'uniTable', column: 2},
            items:[
               Unilite.popup('DIV_PUMOK', {
                fieldLabel: '품목코드',
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME',
              //validateBlank	: false,
    			autoPopup : true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	adjustForm.setValue('ITEM_CODE', '');
                    	adjustForm.setValue('ITEM_NAME', '');
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                    }
                }
            }),{
               width: 100,
               xtype: 'button',
               text: '품목일괄적용',
               margin: '0 0 0 10',
               handler : function() {
                    if(Ext.isEmpty(adjustForm.getValue('ITEM_CODE'))){
                        alert('품목을 선택해 주세요.');
                        return false;
                    }
                    var mRecord = adjustGrid.getSelectedRecords();
                    Ext.each(mRecord, function(rec, i) {
                        rec.set('ITEM_CODE', adjustForm.getValue('ITEM_CODE'));
                        rec.set('ITEM_NAME', adjustForm.getValue('ITEM_NAME'));
                    });
               }
            }]
        }]
    });

	var adjustGrid = Unilite.createGrid('s_mpo200ukrv_ypAdjustGrid', {
        layout: 'fit',
        region: 'south',
        excelTitle: '구매요청정보 조정',
        selModel:  Ext.create('Ext.selection.CheckboxModel', { checkOnly : true }),
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            onLoadSelectFirst : false,
            expandLastColumn: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }
        },
        store: adjustStore,
        columns: [
                {dataIndex: 'COMP_CODE'                             ,width:100, hidden: true},
                {dataIndex: 'DIV_CODE'                              ,width:100, hidden: true},
                {dataIndex: 'ORDER_PLAN_DATE'                       ,width:90},
                {dataIndex: 'CUSTOM_CODE'       , width: 100    ,
                  editor: Unilite.popup('AGENT_CUST_G',{
                        DBtextFieldName : 'CUSTOM_CODE',
                        autoPopup       : true,
                        listeners       : {
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = adjustGrid.uniOpt.currentRecord;
                                    grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                            },
                            'onClear' : function(type)  {
                                var grdRecord = adjustGrid.uniOpt.currentRecord;
                                grdRecord.set('CUSTOM_CODE','');
                                grdRecord.set('CUSTOM_NAME','');
                            },
                            'applyextparam': function(popup){
                                popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
                                popup.setExtParam({'CUSTOM_TYPE'        : ['1','2']});
                            }
                        }
                    })
                },
                {dataIndex: 'CUSTOM_NAME'       , width: 140    ,
                  editor: Unilite.popup('AGENT_CUST_G',{
                        DBtextFieldName : 'CUSTOM_NAME',
                        autoPopup       : true,
                        listeners       : {
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = adjustGrid.uniOpt.currentRecord;
                                    grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                            },
                            'onClear' : function(type)  {
                                var grdRecord = adjustGrid.uniOpt.currentRecord;
                                grdRecord.set('CUSTOM_CODE','');
                                grdRecord.set('CUSTOM_NAME','');
                            },
                            'applyextparam': function(popup){
                                popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
                                popup.setExtParam({'CUSTOM_TYPE'        : ['1','2']});
                            }
                        }
                    })
                },
                {dataIndex: 'PROD_ITEM_CODE'                        ,width:100, hidden: true},
                {dataIndex: 'ITEM_CODE'                             ,width:90},
                {dataIndex: 'ITEM_NAME'                             ,width:150},
                {dataIndex: 'SPEC'                                  ,width:100},
                {dataIndex: 'ORDER_PLAN_Q'                          ,width:90},
                {dataIndex: 'STOCK_UNIT'                            ,width:100},
                {dataIndex: 'BASIS_DATE'                            ,width:100, hidden: true},
                {dataIndex: 'REQ_PLAN_Q'                            ,width:90, hidden: true},
                {dataIndex: 'SUPPLY_TYPE'                           ,width:100, hidden: true},
                {dataIndex: 'PAB_STOCK_Q'                           ,width:90, hidden: true},
                {dataIndex: 'EXCHG_EXIST_YN'                        ,width:100, hidden: true},
                {dataIndex: 'REF_ITEM_CODE'                         ,width:100, hidden: true},
                {dataIndex: 'REF_ITEM_NAME'                         ,width:100, hidden: true},
                {dataIndex: 'EXCHG_YN'                              ,width:100, hidden: true},
                {dataIndex: 'DVRY_DATE'                             ,width:100, hidden: true},
                {dataIndex: 'ORDER_DVRY_DATE'                     ,width:100, hidden: false},
                {dataIndex: 'EXP_ISSUE_DATE'            ,width:100, hidden: false},
                {dataIndex: 'DOM_FORIGN'                            ,width:80},
                {dataIndex: 'ORDER_REQ_DEPT_CODE'                   ,width:100},
                {dataIndex: 'ORDER_PRSN'                            ,width:90},
                {dataIndex: 'ORDER_YN'                              ,width:100, hidden: true},
                {dataIndex: 'ORDER_NUM'                             ,width:110},
                {dataIndex: 'ORDER_SEQ'                             ,width:66},
                {dataIndex: 'ORDER_CUSTOM_NAME'                     ,width:130},
                {dataIndex: 'PROD_END_DATE'                     ,width:100, hidden: true},
                {dataIndex: 'ORDER_REQ_NUM'                         ,width:110},
                {dataIndex: 'MRP_CONTROL_NUM'                       ,width:110, hidden: true},
                {dataIndex: 'WKORD_NUM'                             ,width:110},
                {dataIndex: 'ITEM_ACCOUNT'                          ,width:100, hidden: true},
                {dataIndex: 'PURCH_LDTIME'                          ,width:100, hidden: true},
                {dataIndex: 'CREATE_DATE'                           ,width:100, hidden: true},
                {dataIndex: 'MRP_YN'                                ,width:100, hidden: true},
                {dataIndex: 'LOT_NO'                                ,width:100},
                {dataIndex: 'REMARK'                                ,width:100},
           		{dataIndex: 'PROJECT_NO'                            ,width:100,
           		   editor: Unilite.popup('PROJECT_G', {
                        extParam: {DIV_CODE: UserInfo.divCode},
                        autoPopup: true,
                        listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        console.log('records : ', records);
                                        var grdRecord = masterGrid.uniOpt.currentRecord;
                                        Ext.each(records, function(record,i) {
                                            if(i==0) {
                                                grdRecord.set('PROJECT_NO', record['PJT_CODE']);
                                            }
                                        });
                                    },
                                    scope: this
                                    },
                                    'onClear': function(type) {
                                        var grdRecord = masterGrid.uniOpt.currentRecord;
                                        grdRecord.set('PROJECT_NO', '');
                                    }
                        }
                    })
           		}

        ],
        listeners: {
            select: function(grid, record, index, eOpts ){

            },
            deselect:  function(grid, record, index, eOpts ){

            },
            selectionchange: function(){

            },
            beforeselect: function(grid, record, index, eOpts){
//            	if(Ext.isEmpty(record.get('CUSTOM_CODE'))){
//                    return true;
//                }else{
//                    return false;
//                }
//            	if(Ext.isEmpty(adjustForm.getValue('CUSTOM_CODE'))){
//                    alert('거래처를 선택해 주세요.');
//                    return false;
//                }
            },
            beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['ORDER_PLAN_DATE','CUSTOM_CODE', 'CUSTOM_NAME', 'ORDER_PLAN_Q', 'SUPPLY_TYPE', 'DOM_FORIGN', 'ORDER_PRSN', 'REMARK', 'PROJECT_NO'])){
                    return true;
                }else{
                    return false;
                }
            }
        },
		viewConfig: {
			 getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(Number(UniDate.getDbDateStr(record.get('EXP_ISSUE_DATE'))) != Number(UniDate.getDbDateStr(record.get('ORDER_DVRY_DATE')))) {
					cls = 'x-change-cell_light';
				}
				return cls;
			}
		}
    });

	var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [{
            xtype: 'container',
            layout: {type: 'vbox', align: 'stretch'},
            title: '발주확정',
            items:[
                masterGrid, masterGrid2
            ],
            id: 's_mpo200ukrv_ypMasterTab'
        },{
            xtype: 'container',
            layout: {type: 'vbox', align: 'stretch'},
            title: '발주예정 조정',
            items:[
                adjustForm,adjustGrid
            ],
            id: 's_mpo200ukrv_ypAdjustTab'
        }],
        listeners:  {
        	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )   {
                if(Ext.isObject(oldCard))   {
                    if(UniAppManager.app._needSave())   {
                        if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
                            UniAppManager.app.onSaveDataButtonDown();
                            return false;
                        }else {
                            adjustGrid.getStore().loadData({});
                        }
                     }
                }
            },
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                if(newTabId == 's_mpo200ukrv_ypAdjustTab'){
                    Ext.getCmp('confirmBtn').setDisabled(true);
                }else{
                    Ext.getCmp('confirmBtn').setDisabled(false);
                }
                UniAppManager.app.onQueryButtonDown();
//                console.log("newCard:  " + newCard.getId());
//                console.log("oldCard:  " + oldCard.getId());
//                //탭 넘길때마다 초기화
//                UniAppManager.setToolbarButtons(['save', 'newData' ], false);
//                panelResult.setAllFieldsReadOnly(false);
////              Ext.getCmp('confirm_check').hide(); //확정버튼 hidden
//                UniAppManager.app.onQueryButtonDown();

            }
        }
    });

	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		}
		],
		id: 's_mpo200ukrv_ypApp',
		fnInitBinding: function(params) {
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('ORDER_TO_DATE', UniDate.get('today'));
            panelResult.setValue('ORDER_FR_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_DATE')));

            adjustForm.setValue('APPLY_ORDER_DATE', UniDate.get('today'))
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			this.setDefault(params);
			tab.setActiveTab(Ext.getCmp('s_mpo200ukrv_ypMasterTab'));
		},
		onQueryButtonDown: function()	{
			var activeTabId = tab.getActiveTab().getId();
            if(activeTabId == 's_mpo200ukrv_ypMasterTab'){
                masterGrid.getStore().loadStoreRecords();
                masterGrid2.reset();
            }else if(activeTabId == 's_mpo200ukrv_ypAdjustTab'){
                adjustGrid.getStore().loadStoreRecords();
            }
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.clearForm();
			adjustForm.clearForm();
			directMasterStore1.loadData({});
			directMasterStore2.loadData({});
			adjustStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
            if(activeTabId == 's_mpo200ukrv_ypAdjustTab'){
                adjustStore.saveStore();
            }
		},
		setDefault: function(params) {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('ORDER_PRSN', BsaCodeInfo.gsOrderPrsn);
		},
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params) {
				if(params.action == 'newMpo060') {
					panelResult.setValue('DIV_CODE'			, params.DIV_CODE);
					panelResult.setValue('DIV_CODE'			, params.DIV_CODE);
					panelResult.setValue('DEPT_CODE'		, params.DEPT_CODE);
					panelResult.setValue('DEPT_CODE'		, params.DEPT_CODE);
					panelResult.setValue('DEPT_NAME'		, params.DEPT_NAME);
					panelResult.setValue('DEPT_NAME'		, params.DEPT_NAME);
					panelResult.setValue('WH_CODE'			, params.WH_CODE);
					panelResult.setValue('WH_CODE'			, params.WH_CODE);
					panelResult.setValue('ORDER_PRSN'		, params.ORDER_PRSN);
					panelResult.setValue('ORDER_PRSN'		, params.ORDER_PRSN);
					panelResult.setValue('ORDER_EXPECTED_FR' , params.ORDER_EXPECTED_FR);
					panelResult.setValue('ORDER_EXPECTED_FR', params.ORDER_EXPECTED_FR);
					panelResult.setValue('ORDER_EXPECTED_TO' , params.ORDER_EXPECTED_TO);
					panelResult.setValue('ORDER_EXPECTED_TO', params.ORDER_EXPECTED_TO);
				}
			}
		}
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var detailSelectedRecs = masterGrid2.getSelectedRecords();
			if(detailSelectedRecs.length == 0) return rv;
			switch(fieldName) {
				case "ORDER_DATE" :
				    Ext.each(detailSelectedRecs, function(rec, i){
				        rec.set('ORDER_DATE', newValue);
				    });
				break;
				case "ORDER_TYPE" :
                    Ext.each(detailSelectedRecs, function(rec, i){
                        rec.set('ORDER_TYPE', newValue);
                    });
                break;
                case "ORDER_PRSN" :
                    Ext.each(detailSelectedRecs, function(rec, i){
                        rec.set('ORDER_PRSN', newValue);
                    });
                break;
                case "AGREE_NAME" :
                    Ext.each(detailSelectedRecs, function(rec, i){
                        rec.set('AGREE_NAME', newValue);
                    });
                break;
                case "MONEY_UNIT" :
                    Ext.each(detailSelectedRecs, function(rec, i){
                        rec.set('MONEY_UNIT', newValue);
                    });
                break;
                case "EXCHG_RATE_O" :
                    Ext.each(detailSelectedRecs, function(rec, i){
                        rec.set('EXCHG_RATE_O', newValue);
                    });
                break;
			}
				return rv;
		}
	});

	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_Q" :
					if(record.get('OREDER_UNIT_P') != '' ){
						record.set('ORDER_O',newValue * record.get('ORDER_UNIT_P'));
					}else if(record.get('ORDER_UNIT_P') == ''){
						record.set('ORDER_UNIT_P',record.get('ORDER_O') / newValue);
					}
					break;
				case "ORDER_UNIT_P" :
					record.set('ORDER_O',record.get('ORDER_Q') * newValue);
					break;
				case "ORDER_O" :
					record.set('ORDER_UNIT_P', newValue / record.get('ORDER_Q'));
					break;
			}
				return rv;
		}
	});
};
</script>
