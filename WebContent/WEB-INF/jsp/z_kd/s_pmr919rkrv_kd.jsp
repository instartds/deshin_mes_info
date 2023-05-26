<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr919rkrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 				            <!-- 사업장 -->   
    <t:ExtComboStore comboType="AU" comboCode="T005" />                 <!-- 가격조건  -->
    <t:ExtComboStore comboType="AU" comboCode="T071" />                 <!--진행구분-->
    <t:ExtComboStore comboType="AU" comboCode="WT01" />                 <!-- 원가산출운임,CFS-->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     
    gsDefaultMoney      : '${gsDefaultMoney}'
};

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmr919rkrv_kdService.selectList'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_pmr919rkrv_kdModel', {
	    fields: [
            {name : 'COMP_CODE',        text : '법인코드',      type : 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type : 'string', comboType : "BOR120"},
            {name : 'GUBUN',            text : '구분',        type : 'string'},
            {name : 'WORK_SHOP_CODE',   text : '작업장코드',     type : 'string'},
            {name : 'WORK_SHOP_NAME',   text : '작업장',       type : 'string'},
            {name : 'ITEM_CODE',        text : '제품코드',      type : 'string'},
            {name : 'ITEM_NAME',        text : '제품명',       type : 'string'},
            {name : 'SPEC',        		text : '규격',       type : 'string'},
            {name : 'CAR_TYPE',         text : '차종명',       type : 'string', comboType : "AU", comboCode : "WB04"},
            {name : 'NEXT_PLAN_QTY',    text : '익월판매계획량',   type : 'uniQty'},
            {name : 'STOCK_Q',          text : '현재고량',      type : 'uniQty'},
            {name : 'REMAIN1_QTY',      text : '미생산량',      type : 'uniQty'},
            {name : 'EXPECT_QTY',       text : '재고예정량',     type : 'uniQty'},
            {name : 'NOW_PLAN_QTY',     text : '당월판매계획량',   type : 'uniQty'},
            {name : 'OUT_Q',            text : '당월출고량',     type : 'uniQty'},
            {name : 'REMAIN2_QTY',      text : '당월생산예정량',   type : 'uniQty'}
		]                         
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('s_pmr919rkrv_kdMasterStore',{
		model: 's_pmr919rkrv_kdModel',
		uniOpt : {
        	isMaster: true,			    // 상위 버튼 연결
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			    // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('panelResultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
			
		}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    items :[{                  
                fieldLabel: '사업장',
                name:'DIV_CODE',    
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank: false
            },{ 
                fieldLabel: '기준월',
                xtype: 'uniMonthfield',
                name: 'BASE_MONTH',
                value: UniDate.get('today'),
                allowBlank:false
            },
            Unilite.popup('DIV_PUMOK',{ 
                fieldLabel: '품목코드',
                valueFieldName: 'ITEM_CODE', 
                textFieldName: 'ITEM_NAME',
                listeners: {
                    applyextparam: function(popup){                         
                        popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                    }
                }
            }),{
                xtype: 'radiogroup',
                fieldLabel: '구분',
                id: 'rdoSelect',
                items : [{
                    boxLabel: '작업장',
                    width: 60,
                    name: 'GUBUN',
                    checked: true,
                    inputValue: '1'
                },{
                    boxLabel: '외주처',
                    width: 60,
                    name: 'GUBUN',
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	if (Ext.getCmp('rdoSelect').getValue().GUBUN == '1') {
                            var workShopPopupId = Ext.getCmp('workShopId');
                            var customPopupId = Ext.getCmp('customId');
                            workShopPopupId.setVisible(true);
                            customPopupId.setVisible(false);
                        } else {
                            var workShopPopupId = Ext.getCmp('workShopId');
                            var customPopupId = Ext.getCmp('customId');
                            customPopupId.setVisible(true); 
                            workShopPopupId.setVisible(false);
                        }
                    }
                }   
            },
            Unilite.popup('WORK_SHOP',{ 
                    fieldLabel: '작업장',
                    id:  'workShopId',
                    valueFieldName: 'TREE_CODE', 
                    textFieldName: 'TREE_NAME',
                    listeners: {
                        applyextparam: function(popup) {                         
                            popup.setExtParam({'TYPE_LEVEL': panelResult.getValue('DIV_CODE')});
                        }
                    }
           }),
           Unilite.popup('AGENT_CUST', { 
                    fieldLabel: '외주처', 
                    id:  'customId',
                    valueFieldName: 'CUSTOM_CODE'
            })
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
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
		    me.setAllFieldsReadOnly(true);
		}
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_pmr919rkrv_kdGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: MasterStore,
//        tbar: [{                  
//            xtype: 'button',
//            text: '출력',
//            margin:'0 0 0 100',
//            handler: function() {
//            
//            } 
//        }],
        columns:  [        
            {dataIndex : 'COMP_CODE',           width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 120},
            {dataIndex : 'GUBUN',               width : 100},
            {dataIndex : 'WORK_SHOP_CODE',      width : 100, hidden : true},
            {dataIndex : 'WORK_SHOP_NAME',      width : 120},
            {dataIndex : 'ITEM_CODE',           width : 110},
            {dataIndex : 'ITEM_NAME',           width : 160},
            {dataIndex : 'SPEC',           width : 160},
            {dataIndex : 'CAR_TYPE',            width : 110},
            {dataIndex : 'NEXT_PLAN_QTY',       width : 120},
            {dataIndex : 'STOCK_Q',             width : 120},
            {dataIndex : 'REMAIN1_QTY',         width : 120},
            {dataIndex : 'EXPECT_QTY',          width : 120},
            {dataIndex : 'NOW_PLAN_QTY',        width : 120},
            {dataIndex : 'OUT_Q',               width : 120},
            {dataIndex : 'REMAIN2_QTY',         width : 120}
        ]
    }); 
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]	
		}
		],
		id  : 's_pmr919rkrv_kdApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
            this.setDefault();
		},
		onQueryButtonDown : function()	{
			if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset'], true); 
		},
		onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelResult.clearForm();
            masterGrid.reset();
            panelResult.setAllFieldsReadOnly(false);
            MasterStore.clearData();
            this.setDefault();
        },
        setDefault: function() {        // 기본값
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            var workShopPopupId = Ext.getCmp('workShopId');
            var customPopupId = Ext.getCmp('customId');
            workShopPopupId.setVisible(true);
            customPopupId.setVisible(false);
            UniAppManager.setToolbarButtons(['reset', 'save'], false);
            panelResult.setValue('BASE_MONTH', UniDate.get('today'));
            panelResult.setValue('GUBUN', '1');
            
        }
	});

};
		
</script>