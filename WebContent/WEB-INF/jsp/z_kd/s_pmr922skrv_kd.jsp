<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr922skrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 				            <!-- 사업장 -->   
    <t:ExtComboStore comboType="AU" comboCode="WB04" />                 <!-- 차종  -->

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
			read: 's_pmr922skrv_kdService.selectList'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_pmr922skrv_kdModel', {
	    fields: [
            {name : 'COMP_CODE',            text : '법인코드',        type : 'string'},
            {name : 'DIV_CODE',             text : '사업장코드',       type : 'string', comboType : "BOR120"},
            {name : 'WORK_SHOP_CODE',       text : '주작업장코드',      type : 'string'},
            {name : 'WORK_SHOP_NAME',       text : '주작업장',         type : 'string'},
            {name : 'ITEM_CODE',            text : '제품코드',         type : 'string'},
            {name : 'ITEM_NAME',            text : '제품명',           type : 'string'},
            {name : 'CAR_TYPE',             text : '차종',            type : 'string', comboType : "AU", comboCode : "WB04"},
            {name : 'SPEC',            text : '규격',           type : 'string'},
            {name : 'QTY_01',               text : '1월',            type : 'uniQty'},
            {name : 'QTY_02',               text : '2월',            type : 'uniQty'},
            {name : 'QTY_03',               text : '3월',            type : 'uniQty'},
            {name : 'QTY_04',               text : '4월',            type : 'uniQty'},
            {name : 'QTY_05',               text : '5월',            type : 'uniQty'},
            {name : 'QTY_06',               text : '6월',            type : 'uniQty'},
            {name : 'QTY_07',               text : '7월',            type : 'uniQty'},
            {name : 'QTY_08',               text : '8월',            type : 'uniQty'},
            {name : 'QTY_09',               text : '9월',            type : 'uniQty'},
            {name : 'QTY_10',               text : '10월',           type : 'uniQty'},
            {name : 'QTY_11',               text : '11월',           type : 'uniQty'},
            {name : 'QTY_12',               text : '12월',           type : 'uniQty'},
            {name : 'SUM_QTY',              text : '합계',            type : 'uniQty'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('s_pmr922skrv_kdMasterStore',{
		model: 's_pmr922skrv_kdModel',
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
		},
        groupField: 'WORK_SHOP_NAME'
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
                fieldLabel: '기준년도',
                name: 'YYYY',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false
            },
            Unilite.popup('WORK_SHOP',{ 
                    fieldLabel: '작업장',
                    id:  'workShopId2',
                    valueFieldName: 'TREE_CODE', 
                    textFieldName: 'TREE_NAME',
                    listeners: {
                        applyextparam: function(popup) {                         
                            popup.setExtParam({'TYPE_LEVEL': panelResult.getValue('DIV_CODE')});
                        }
                    }
           }),
            Unilite.popup('DIV_PUMOK',{ 
                fieldLabel: '품목코드',
                valueFieldName: 'ITEM_CODE', 
                textFieldName: 'ITEM_NAME',
                listeners: {
                    applyextparam: function(popup){                         
                        popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                    }
                }
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
    var masterGrid = Unilite.createGrid('s_pmr922skrv_kdGrid', {
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
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary',   showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	       showSummaryRow: true} ],
        columns:  [        
            {dataIndex : 'COMP_CODE',       width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 100, hidden : true},
            {dataIndex : 'WORK_SHOP_CODE',  width : 100, hidden : true},
            {dataIndex : 'WORK_SHOP_NAME',  width : 130,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex : 'ITEM_CODE',       width : 110},
            {dataIndex : 'ITEM_NAME',       width : 160},
            {dataIndex : 'SPEC',       width : 160},
            {dataIndex : 'CAR_TYPE',        width : 110},
            {dataIndex : 'QTY_01',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_02',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_03',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_04',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_05',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_06',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_07',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_08',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_09',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_10',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_11',          width : 120, summaryType: 'sum'},
            {dataIndex : 'QTY_12',          width : 120, summaryType: 'sum'},
            {dataIndex : 'SUM_QTY',         width : 120, summaryType: 'sum'}
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
		id  : 's_pmr922skrv_kdApp',
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
			UniAppManager.setToolbarButtons(['save'], false); 
		},
		onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelResult.clearForm();
            masterGrid.reset();
            panelResult.setAllFieldsReadOnly(false);
            MasterStore.clearData();
            UniAppManager.setToolbarButtons(['save'], false); 
            this.setDefault();
        },
        setDefault: function() {        // 기본값
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['reset','save'], false); 
        }/*,
        fnExchngRateO:function(isIni) {
            var param = {
                "AC_DATE"    : UniDate.getDbDateStr(panelSearch.getValue('INOUT_DATE')),
                "MONEY_UNIT" : panelSearch.getValue('MONEY_UNIT')
            };            
            salesCommonService.fnExchgRateO(param, function(provider, response) {   
                if(!Ext.isEmpty(provider)){
                    if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelSearch.getValue('MONEY_UNIT')) && panelSearch.getValue('MONEY_UNIT') != "KRW"){
                        alert('환율정보가 없습니다.')
                    }
                    panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
                    panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
                }
                
            });
        }*/
	});

};
		
</script>