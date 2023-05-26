<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mtr130rkrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_mtr130rkrv_yp"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read : 's_mtr130rkrv_ypService.selectList'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_mtr130rkrv_ypModel', {
        fields: [
            {name: 'COMP_CODE'          ,text: 'COMP_CODE'       ,type: 'string'},
            {name: 'DIV_CODE'           ,text: 'DIV_CODE'        ,type: 'string'},
            {name: 'CUSTOM_CODE'        ,text: '거래처코드'         ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '거래처명'          ,type: 'string'},
            {name: 'INOUT_I'            ,text: '매입금액'          ,type: 'uniPrice'},
            {name: 'S_INOUT_I'          ,text: '실지급액'          ,type: 'uniPrice'},
            {name: 'CUST_TYPE'          ,text: '거래처구분'         ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_mtr130rkrv_ypMasterStore',{
            model: 's_mtr130rkrv_ypModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: false,         // 수정 모드 사용
                deletable:false,         // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: directProxy
            ,loadStoreRecords : function()  {
                var param= panelResult.getValues();
                console.log( param );
                this.load({ params : param});
            },
            // 수정/추가/삭제된 내용 DB에 적용 하기
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);

                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();

                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);

                var paramMaster= panelResult.getValues();   //syncAll 수정
                if(inValidRecs.length == 0 )    {
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {

                        }
                    };
                    this.syncAllDirect(config);
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    });

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
//    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
            xtype: 'radiogroup',
            fieldLabel: '보고서 유형',
            id: 'RDO',
            colspan: 2,
            items : [{
                boxLabel: '상세내역',
                width:80 ,
                name: 'RDO',
                inputValue: '1',
                checked: true
            }, {
                boxLabel: '집계내역',
                width:80 ,
                name: 'RDO' ,
                inputValue: '2'
            }]
		},{
	    	fieldLabel: '사업장',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox',
	    	comboType:'BOR120',
	    	allowBlank:false,
	    	value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
    	},{
            fieldLabel: '입고창고',
            name:'WH_CODE',
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('whList')
        },{
    		fieldLabel: '입고일',
    		xtype: 'uniDateRangefield',
    		startFieldName: 'INOUT_FR_DATE',
    		endFieldName: 'INOUT_TO_DATE',
    		startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
    		width:315,

    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    }
		},{
            fieldLabel: '품목계정',
            name:'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B020'
        },{
	    	fieldLabel: '발주형태',
	    	name:'ORDER_TYPE',
	    	xtype: 'uniCombobox',
	    	comboType:'AU',
	    	comboCode:'M001',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
    	},{
            fieldLabel: '대분류',
            name: 'ITEM_LEVEL1',
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('itemLeve1Store'),
            child: 'ITEM_LEVEL2'
        },
            Unilite.popup('AGENT_CUST',{
            fieldLabel: '거래처',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
          //validateBlank	: false,
			autoPopup : true,
            listeners: {
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                }
            }
        }), {
            fieldLabel: '중분류',
            name: 'ITEM_LEVEL2',
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('itemLeve2Store'),
            child: 'ITEM_LEVEL3'
        },
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '품목코드',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			//validateBlank	: false,
			autoPopup : true
		}), {
            fieldLabel: '소분류',
            name: 'ITEM_LEVEL3',
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('itemLeve3Store'),
            parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
            levelType:'ITEM'
        },{
            fieldLabel: '품목명',
            xtype:'uniTextfield',
            name:'ITEM_NAME_SEARCH'
        },{
            fieldLabel: '입고담당',
            name:'INOUT_PRSN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B024'
        },{
            fieldLabel: '관리번호',
            xtype:'uniTextfield',
            name:'PROJECT_NO'
        },{
            fieldLabel: '입고유형',
            name:'INOUT_TYPE_DETAIL',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'M103'
        },{
            fieldLabel: 'CUSTOM_CODES',
            xtype: 'uniTextfield',
            name: 'CUSTOM_CODES',
            hidden: true
        }]
    });

    var masterGrid = Unilite.createGrid('s_mtr130rkrv_ypGrid1', {
        region: 'center',
        layout: 'fit',
        uniOpt: {
            expandLastColumn: false,
            copiedRow: true,
            onLoadSelectFirst: false
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                    if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODES'))) {
                        panelResult.setValue('CUSTOM_CODES', selectRecord.get('CUSTOM_CODE'));
                    } else {
                        var customCodes = panelResult.getValue('CUSTOM_CODES');
                        customCodes = customCodes + ',' + selectRecord.get('CUSTOM_CODE');
                        panelResult.setValue('CUSTOM_CODES', customCodes);
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                    var customCodes     = panelResult.getValue('CUSTOM_CODES');
                    var deselectedNum0  = selectRecord.get('CUSTOM_CODE') + ',';
                    var deselectedNum1  = ',' + selectRecord.get('CUSTOM_CODE');
                    var deselectedNum2  = selectRecord.get('CUSTOM_CODE');
                    customCodes = customCodes.split(deselectedNum0).join("");
                    customCodes = customCodes.split(deselectedNum1).join("");
                    customCodes = customCodes.split(deselectedNum2).join("");
                    panelResult.setValue('CUSTOM_CODES', customCodes);
                }
            }
        }),
        store: directMasterStore,
        columns: [
                {dataIndex: 'COMP_CODE'          , width: 100, hidden: true },
                {dataIndex: 'DIV_CODE'           , width: 100, hidden: true },
                {dataIndex: 'CUSTOM_CODE'        , width: 120 },
                {dataIndex: 'CUSTOM_NAME'        , width: 240 },
                {dataIndex: 'INOUT_I'            , width: 170 },
                {dataIndex: 'S_INOUT_I'          , width: 170 },
                {dataIndex: 'CUST_TYPE'          , width: 100, hidden: true }
            ],
            listeners: {
                beforeedit: function( editor, e, eOpts ) {
                    if(!e.record.phantom == true) { // 신규가 아닐 때
                        if(UniUtils.indexOf(e.field, ['CUSTOM_CODE', 'CUSTOM_NAME' ,'FARM_CODE' ,'FARM_NAME'])) {
                            return false;
                        }
                    }
                }
            }
    });

    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}
		],
		id  : 's_mtr130rkrv_ypApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('INOUT_FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_TO_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('print',true);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
        onQueryButtonDown : function()  {
            if(!this.isValidSearchForm()){
                return false;
            }
            panelResult.setValue('CUSTOM_CODES','');
            masterGrid.getStore().loadStoreRecords();
        },
        onPrintButtonDown: function() {
        	if(this.onFormValidate()){
        		if(directMasterStore.getCount() != 0 && masterGrid.getSelectedRecords().length == 0){
                    alert('출력할 거래처를 선택해 주세요.');
                    return false;
        		}
        		var param = panelResult.getValues();
        		var customCodes = panelResult.getValue('CUSTOM_CODES').split(',');
                param.CUSTOM_CODES = customCodes;
        		if(Ext.getCmp('RDO').getChecked()[0].inputValue == '1'){
                    var win = Ext.create('widget.CrystalReport', {
                        url: CPATH+'/z_yp/mtr130cskrv_yp1.do',
                        prgID: 'mtr130skrv',
                            extParam: param
                    });
        		}else{
                    var win = Ext.create('widget.CrystalReport', {
                        url: CPATH+'/z_yp/mtr130cskrv_yp2.do',
                        prgID: 'mtr130skrv',
                            extParam: param
                    });
        		}
                win.center();
                win.show();
        	}
		},
	    onFormValidate: function(){
	    	var r= true
	        var invalid = panelResult.getForm().getFields().filterBy(
	     		function(field) {
					return !field.validate();
				}
		    );

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
			}
			return r;
	    }
	});
};

</script>
