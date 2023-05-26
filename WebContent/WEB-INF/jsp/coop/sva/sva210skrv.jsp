<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sva210skrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="sva210skrv" />          <!-- 사업장 -->
<t:ExtComboStore items="${COMBO_VENDING_MACHINE_NO}" storeId="MachineNo" /><!--자판기명-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
   
   /**
    * Model 정의 
    * @type 
    */             
   Unilite.defineModel('sva210skrvModel', {
       fields: [
          {name:'COMP_CODE'        , text: '법인코드'          , type: 'string'},
          {name:'DIV_CODE'         , text: '사업장'         	, type: 'string'},
          {name:'INOUT_DATE'       , text: '출고일'         	, type: 'uniDate'},
          {name:'ITEM_CODE'        , text: '품목'         	, type: 'string'},
          {name:'ITEM_NAME'        , text: '품목명'         	, type: 'string'},
          {name:'INOUT_CODE'       , text: '자판기코드'      	, type: 'string'},
          {name:'CUSTOM_NAME'      , text: '자판기명'          , type: 'string'},
          {name:'MANAGE_CUSTOM'    , text: '매입사'         	, type: 'string'},
          {name:'INOUT_Q'          , text: '투입수량'          , type: 'uniQty'}
       ]       
   });      //End of Unilite.defineModel
   
   // GroupField string type으로 변환
   function dateToString(v, record){
      return UniDate.safeFormat(v);
     }
     
     
   var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'sva210skrvService.selectList',
        	update: 'sva210skrvService.updateDetail',
			create: 'sva210skrvService.insertDetail',
			destroy: 'sva210skrvService.deleteDetail',
			syncAll: 'sva210skrvService.saveAll'
        }
	});  
     
     
   /**
    * Store 정의(Service 정의)
    * @type 
    */
   var MasterStore = Unilite.createStore('sva210skrvMasterStore',{
         model: 'sva210skrvModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: true,      // 수정 모드 사용 
               deletable: false,      // 삭제 가능 여부 
               useNavi: false         // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
         loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},saveStore : function(config)	{	

				var inValidRecs = this.getInvalidRecords();
				//var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	
				if(inValidRecs.length == 0 )	{										
					config = {
							success: function(batch, option) {								
								panelResult.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);			
							 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
   });      // End of var MasterStore 
   
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
          items: [{
              fieldLabel: '사업장',
              name: 'DIV_CODE',
              value : UserInfo.divCode,
              xtype: 'uniCombobox',
              comboType: 'BOR120',
              holdable: 'hold',
              allowBlank: false,
              listeners: {
               change: function(field, newValue, oldValue, eOpts) {                  
                  panelResult.setValue('DIV_CODE', newValue);
               }
            }
           },{
			fieldLabel: '자판기',
			name:'POS_CODE', 
			xtype: 'uniCombobox',
			store:Ext.data.StoreManager.lookup('MachineNo'),
	        multiSelect: true, 
	        typeAhead: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('POS_CODE', newValue);
				}
			}
		},{
            fieldLabel: '출고일',
            xtype: 'uniDateRangefield',
            startFieldName: 'INOUT_DATE_FR',
            endFieldName: 'INOUT_DATE_TO',
            startDate: UniDate.get('today'),
            endDate: UniDate.get('today'),
            allowBlank: false,
            width: 315,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                   if(panelResult) {
                  panelResult.setValue('INOUT_DATE_FR',newValue);         
                   }
             },
             onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                   panelResult.setValue('INOUT_DATE_TO',newValue);                   
                }
             }
         },
          Unilite.popup('ITEM',{ 
               fieldLabel: '품목', 
               valueFieldName: 'ITEM_CODE',
               textFieldName: 'ITEM_NAME',
               listeners: {
                  onSelected: {
                     fn: function(records, type) {
                        panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
                        panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));                                                                                  
                     },
                     scope: this
                  },
                  onClear: function(type)   {
                     panelResult.setValue('ITEM_CODE', '');
                     panelResult.setValue('ITEM_NAME', '');
                  }
               }
         })]
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
                        var popupFC = item.up('uniPopupField')   ;                     
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
                     var popupFC = item.up('uniPopupField')   ;   
                     if(popupFC.holdable == 'hold' ) {
                        item.setReadOnly(false);
                     }
                  }
               })
              }
            return r;
           }
   });
   
    var panelResult = Unilite.createSearchForm('panelResultForm', {
       hidden: !UserInfo.appOption.collapseLeftSearch,
      region: 'north',
      layout : {type : 'uniTable', columns : 3},
      padding:'1 1 1 1',
      border:true,
          items: [{
              fieldLabel: '사업장',
              name: 'DIV_CODE',
              holdable: 'hold',
              value : UserInfo.divCode,
              xtype: 'uniCombobox',
              comboType: 'BOR120',
              allowBlank: false,
              listeners: {
               change: function(field, newValue, oldValue, eOpts) {                  
                  panelSearch.setValue('DIV_CODE', newValue);
               }
            }
           },{
			fieldLabel: '자판기',
			name:'POS_CODE', 
			xtype: 'uniCombobox',
			store:Ext.data.StoreManager.lookup('MachineNo'),
	        multiSelect: true, 
	        typeAhead: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('POS_CODE', newValue);
				}
			}
		},{
            fieldLabel: '출고일',
            xtype: 'uniDateRangefield',
            startFieldName: 'INOUT_DATE_FR',
            endFieldName: 'INOUT_DATE_TO',
            startDate: UniDate.get('today'),
            endDate: UniDate.get('today'),
            allowBlank: false,
            width: 315,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                   if(panelSearch) {
                  panelSearch.setValue('INOUT_DATE_FR',newValue);         
                   }
             },
             onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                   panelSearch.setValue('INOUT_DATE_TO',newValue);                   
                }
             }
         },
         
          Unilite.popup('ITEM',{ 
               fieldLabel: '품목', 
               valueFieldName: 'ITEM_CODE',
               textFieldName: 'ITEM_NAME',
               listeners: {
                  onSelected: {
                     fn: function(records, type) {
                        panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
                        panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));                                                                                  
                     },
                     scope: this
                  },
                  onClear: function(type)   {
                     panelSearch.setValue('ITEM_CODE', '');
                     panelSearch.setValue('ITEM_NAME', '');
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
                    var fields = this.getForm().getFields();
                  Ext.each(fields.items, function(item) {
                     if(Ext.isDefined(item.holdable) )   {
                         if (item.holdable == 'hold') {
                           item.setReadOnly(true); 
                        }
                     } 
                     if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')   ;                     
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
                     var popupFC = item.up('uniPopupField')   ;   
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
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sva210skrvGrid', {
       region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
           expandLastColumn: true,
          useLiveSearch: true,
         useContextMenu: true,
         useMultipleSorting: true,
          useGroupSummary: false,
         useRowNumberer: false,
         filter: {
            useFilter: true,
            autoCreate: true
         }
        },
       features: [
          {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
           {id : 'masterGridTotal' ,   ftype: 'uniSummary',         showSummaryRow: true}
       ],
        columns:  [
         {dataIndex:'COMP_CODE'             , width: 100, hidden:true },            
         {dataIndex:'DIV_CODE'              , width: 100, hidden:true },            
         {dataIndex:'INOUT_DATE'            , width: 110
         ,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
         {dataIndex:'ITEM_CODE'              , width: 130 },                                      
         {dataIndex:'ITEM_NAME'             , width: 200  },
         {dataIndex:'INOUT_CODE'          , width: 100 },                                     
         {dataIndex:'CUSTOM_NAME'          , width: 200 },
         {dataIndex:'MANAGE_CUSTOM'          , width: 120 },
         {dataIndex:'INOUT_Q'             , width: 100 , summaryType: 'sum'}                                                
      ],
      listeners: {
        	beforeedit: function( editor, e, eOpts ) {
	        	if(e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE','INOUT_DATE','ITEM_CODE'
	        									 ,'ITEM_NAME','INOUT_CODE','CUSTOM_NAME','MANAGE_CUSTOM','INOUT_Q'])) {
						return false;
					}
	        	}else{
	        		if(UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'INOUT_DATE','ITEM_CODE'
	        									 ,'ITEM_NAME','INOUT_CODE','CUSTOM_NAME','MANAGE_CUSTOM'])) {
						return false;
					}
	        	}
	        } 	
        }
    });      //End of var masterGrid 
    
    /**
    * Main 정의(Main 정의)
    * @type 
    */
    Unilite.Main ({
      borderItems: [{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                 masterGrid, panelResult
            ]   
         },
         panelSearch     
         ],
      id: 'sva210skrvApp',
      fnInitBinding: function() {
         panelResult.setValue('DIV_CODE',UserInfo.divCode);
         UniAppManager.setToolbarButtons('reset',false);
         UniAppManager.setToolbarButtons('NewData',false);
         UniAppManager.setToolbarButtons('Delete',false);
        /* panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
         panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
         panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
         panelResult.setValue('DEPT_NAME', UserInfo.deptName);*/
      },
      onQueryButtonDown: function()   {
         if(panelSearch.setAllFieldsReadOnly(true) == false){
            return false;
         }
         masterGrid.getStore().loadStoreRecords();
      },
      onSaveDataButtonDown: function (config) {
			MasterStore.saveStore(config);
	  },
      onDetailButtonDown:function() {
         var as = Ext.getCmp('AdvanceSerch');   
         if(as.isHidden())   {
            as.show();
         }else {
            as.hide()
         }
      }
   });
};
</script>