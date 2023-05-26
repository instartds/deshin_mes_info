<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pbs070ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A020"/> <!-- 예/아니오 -->  
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B024"/> <!-- 입고담당 -->  
	<t:ExtComboStore comboType="AU" comboCode="P003"/> <!-- 불량유형 --> 
	<t:ExtComboStore comboType="AU" comboCode="P002"/> <!-- 특기사항 분류 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var outDivCode = UserInfo.divCode;
var selectedMasterGrid = 's_pbs070ukrv_kdGrid'; 

var BsaCodeInfo = {
    gsMoldCode      : '${gsMoldCode}',             // 작업지시 설비여부
    gsEquipCode     : '${gsEquipCode}',             // 작업지시 금형여부
    gsProgWorkCode  : '${gsProgWorkCode}'          // 공정등록기준
};

//var output ='';
//for(var key in BsaCodeInfo){
// output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {   
	
	var isMoldCode = false;
    if(BsaCodeInfo.gsMoldCode=='N') {
        isMoldCode = true;
    }
    
    var isEquipCode = false;
    if(BsaCodeInfo.gsEquipCode=='N') {
        isEquipCode = true;
    }
	
    var isProgWorkCode = false;
    if(BsaCodeInfo.gsProgWorkCode=='2') {
        isProgWorkCode = true;
    }
    
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{		// 공정 등록
		api: {
			read: 's_pbs070ukrv_kdService.selectList',
			update: 's_pbs070ukrv_kdService.updateDetail',
			create: 's_pbs070ukrv_kdService.insertDetail',
			destroy: 's_pbs070ukrv_kdService.deleteDetail',
			syncAll: 's_pbs070ukrv_kdService.saveAll'
		}
	});
	    
    // 공정등록 모델
    Unilite.defineModel('pbs071ukrvsModel', {
        fields: [
            {name: 'DIV_CODE'                   ,text:'사업장'             ,type : 'string', comboType:'BOR120'},
            {name: 'WORK_SHOP_CODE'             ,text:'작업장'             ,type : 'string', allowBlank: isProgWorkCode},
            {name: 'WORK_SHOP_NAME'             ,text:'작업장명'           ,type : 'string'},
            {name: 'PROG_WORK_CODE'             ,text:'공정코드'           ,type : 'string', allowBlank: false},
            {name: 'PROG_WORK_NAME'             ,text:'공정명'             ,type : 'string', allowBlank: false},
            {name: 'STD_TIME'                   ,text:'공정표준시간'       ,type : 'int', allowBlank: false},
            {name: 'PROG_UNIT'                  ,text:'공정단위'           ,type : 'string', comboType: 'AU', comboCode: 'B013',align:'center', displayField: 'value'},
            {name: 'PROG_UNIT_COST'             ,text:'단위당원가'         ,type : 'uniPrice'},
            {name: 'USE_YN'                     ,text:'사용유무'           ,type : 'string', comboType: 'AU', comboCode: 'B010'},
            {name: 'UPDATE_DB_USER'             ,text:'수정자'             ,type : 'string'},
            {name: 'UPDATE_DB_TIME'             ,text:'수정일'             ,type : 'uniDate'},
            {name: 'EXIST'                      ,text:'공정수순등록여부'   ,type : 'string'},
            {name: 'COMP_CODE'                  ,text:'법인코드'           ,type : 'string'}
        ]                   
    });

    // 공정등록 스토어
    var directMasterStore = Unilite.createStore('directMasterStore',{
            model: 'pbs071ukrvsModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결 
                editable: true,         // 수정 모드 사용 
                deletable:true,         // 삭제 가능 여부 
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy,
            saveStore : function()  {   
                var inValidRecs = this.getInvalidRecords();
                
                var rv = true;
                
                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                    var grid = Ext.getCmp('s_pbs070ukrv_kdGrid');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(){
                var param= panelResult.getValues();  
                param.GS_WORK_SHOP_CODE = BsaCodeInfo.gsProgWorkCode;
                console.log(param);
                this.load({
                    params : param
                });
                
            }
    });
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox', 
                comboType:'BOR120' ,
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode
            },
            Unilite.popup('WORK_SHOP',{ 
                    fieldLabel: '작업장',
                    hidden: isProgWorkCode,
                    allowBlank: isProgWorkCode,
                    valueFieldName: 'TREE_CODE', 
                    textFieldName: 'TREE_NAME',
                	holdable: 'hold',
                    listeners: {
                        applyextparam: function(popup) {                         
                            popup.setExtParam({'TYPE_LEVEL': panelResult.getValue('DIV_CODE')});
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
    		}
	});	
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_pbs070ukrv_kdGrid', {
        layout : 'fit',
        region:'center',
        store : directMasterStore, 
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        columns: [
            {dataIndex: 'DIV_CODE'              ,       width: 100, hidden: true},
            {dataIndex: 'WORK_SHOP_CODE'        ,       width: 80, hidden: isProgWorkCode
                ,'editor' : Unilite.popup('WORK_SHOP_G',{textFieldName:'TREE_CODE', textFieldWidth:100, DBtextFieldName: 'TREE_CODE',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        UniAppManager.app.fnWorkShopChange(records); 
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                                    record = records[0];
                                    grdRecord.set('WORK_SHOP_CODE', '');
                                    grdRecord.set('WORK_SHOP_NAME', '');
                                },
                                applyextparam: function(popup){ 
                                    var param =  panelResult.getValues();
                                    popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                                }
                            }
                })
            },
            {dataIndex: 'WORK_SHOP_NAME'        ,       width: 200, hidden: isProgWorkCode
                ,'editor' : Unilite.popup('WORK_SHOP_G',{textFieldName:'TREE_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        UniAppManager.app.fnWorkShopChange(records);     
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                                    record = records[0];
                                    grdRecord.set('WORK_SHOP_CODE', '');
                                    grdRecord.set('WORK_SHOP_NAME', '');
                                },
                                applyextparam: function(popup){ 
                                    var param =  panelResult.getValues();
                                    popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                                }
                            }
                })
            },
            {dataIndex: 'PROG_WORK_CODE'        ,       width: 100},
            {dataIndex: 'PROG_WORK_NAME'        ,       width: 400},
            {dataIndex: 'STD_TIME'              ,       width: 105},
            {dataIndex: 'PROG_UNIT'             ,       width: 80, align: 'center'},
            {dataIndex: 'PROG_UNIT_COST'        ,       width: 100},
            {dataIndex: 'USE_YN'                ,       width: 133},
            {dataIndex: 'UPDATE_DB_USER'        ,       width: 100, hidden: true},
            {dataIndex: 'UPDATE_DB_TIME'        ,       width: 100, hidden: true},
            {dataIndex: 'EXIST'                 ,       width: 100, hidden: true},
            {dataIndex: 'COMP_CODE'             ,       width: 100, hidden: true}
        ],
        listeners :{
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['WORK_SHOP_CODE', 'WORK_SHOP_NAME', 'PROG_WORK_CODE'])) 
                    { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    if(UniUtils.indexOf(e.field)) 
                    { 
                        return true;
                    } 
                }
            }
        }
    });
    
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
    		border : false,
			items:[
				masterGrid, panelResult
			]	
		}
		],
		id: 's_pbs070ukrv_kdApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next', 'newData'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
		},
		onNewDataButtonDown: function()	{
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
		    var compCode      = UserInfo.compCode;
            var divCode       = panelResult.getValue('DIV_CODE');
            var workShopCode  = panelResult.getValue('TREE_CODE');
            var workShopName  = panelResult.getValue('TREE_NAME');
            var stdTime       = '0';
            var progUnit      = 'BOX';
            var progUnitCost  = '0';
            var useYn         = 'Y';
            
            var r = {
                COMP_CODE      : compCode,
                DIV_CODE       : divCode,
                WORK_SHOP_CODE : workShopCode,
                WORK_SHOP_NAME : workShopName,
                STD_TIME       : stdTime,     
                PROG_UNIT      : progUnit,       
                PROG_UNIT_COST : progUnitCost,
                USE_YN         : useYn      
            }
            masterGrid.createRow(r); 
		},
		onDeleteDataButtonDown: function() {
			var grdRecord = masterGrid.getSelectedRecord();
            if(grdRecord.get('EXIST') == 'Y') {
                alert('공정수순에 반영되어 있습니다.');
                return false;
            } else {
            	var selRow1 = masterGrid.getSelectedRecord();
                if(selRow1.phantom === true)    {
                	masterGrid.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid.deleteSelectedRow();
                    }
                }
            }
        },
		onSaveDataButtonDown: function(config) {
		    directMasterStore.saveStore();
		},
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
			panelResult.setAllFieldsReadOnly(false);
            this.fnInitBinding();  
        },
		setDefault: function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.getForm().wasDirty = false;											
			UniAppManager.setToolbarButtons('save', false);	
		},
		fnWorkShopChange: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('WORK_SHOP_CODE', record.TREE_CODE);
            grdRecord.set('WORK_SHOP_NAME', record.TREE_NAME);
            if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
                grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
            }
        }
	});
}
</script>