<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sva220skrv"  >
<t:ExtComboStore comboType="BOR120" pgmId="sva220skrv" />          <!-- 사업장 -->
<t:ExtComboStore items="${COMBO_VENDING_MACHINE_NO}" storeId="MachineNo" /><!--자판기명-->
</t:appConfig>
<script type="text/javascript" >


function appMain() {
   
   /**
    * Model 정의 
    * @type 
    */             
   Unilite.defineModel('sva220skrvModel', {
       fields: [
          {name:'POS_NO'        	, text: '자판기 번호'          	, type: 'string'},
          {name:'POS_NAME'        	, text: '자판기명'          	, type: 'string'},
          {name:'COLUMN_NO'        	, text: '컬럼번호'          	, type: 'string'},
          {name:'ITEM_CODE'        	, text: '품목코드'          	, type: 'string'},
          {name:'ITEM_NAME'        	, text: '품목명칭'          	, type: 'string'},
          {name:'SALE_P'        	, text: '단가'          		, type: 'uniPrice'},
          {name:'SALE_Q'        	, text: '판매수량'          	, type: 'uniQty'},
          {name:'SALE_O'        	, text: '판매금액'          	, type: 'uniPrice'},
          {name:'BEFORE_CNT'        , text: '이월누적도수'          , type: 'uniQty'},
          {name:'AFTER_CNT'        	, text: '당기누적도수'          , type: 'uniQty'},
          {name:'PURCHASE_CODE'     , text: '매입처코드'           , type: 'string'},
          {name:'PURCHASE_NAME'     , text: '매입처명'          	, type: 'string'}
       ]       
   });      //End of Unilite.defineModel     
     
   /**
    * Store 정의(Service 정의)
    * @type 
    */
   var MasterStore = Unilite.createStore('sva220skrvMasterStore',{
         model: 'sva220skrvModel',
         uniOpt : {
               isMaster: true,         // 상위 버튼 연결 
               editable: false,      // 수정 모드 사용 
               deletable: false,      // 삭제 가능 여부 
               useNavi: false         // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'Sva220skrvService.selectList'                	
                }
            },
         loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'POS_NO',
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
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
	        fieldLabel: '조회일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'INOUT_DATE_FR',
	        endFieldName: 'INOUT_DATE_TO',
	        startDate: UniDate.get('startOfMonth'),
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
	     },{
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
           }, {
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
      layout : {type : 'uniTable', columns : 4},
      padding:'1 1 1 1',
      border:true,
          items: [{
            fieldLabel: '조회일',
            xtype: 'uniDateRangefield',
            startFieldName: 'INOUT_DATE_FR',
            endFieldName: 'INOUT_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
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
         },{
              fieldLabel: '사업장',
              name: 'DIV_CODE',
              value : UserInfo.divCode,
              xtype: 'uniCombobox',
              comboType: 'BOR120',
              holdable: 'hold',
              allowBlank: false,
              listeners: {
               change: function(field, newValue, oldValue, eOpts) {                  
                  panelSearch.setValue('DIV_CODE', newValue);
               }
            }
           }, {
				fieldLabel: '자판기',
				name:'POS_CODE', 
				xtype: 'uniCombobox',
				width: 400,
				store:Ext.data.StoreManager.lookup('MachineNo'),
		        multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('POS_CODE', newValue);
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
    var masterGrid = Unilite.createGrid('sva220skrvGrid', {
       region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
           expandLastColumn: false,
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
         {dataIndex:'POS_NO'                  , width: 90,
    		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }
         },    
         {dataIndex:'POS_NAME'                , width: 180},    
         {dataIndex:'COLUMN_NO'               , width: 70},    
         {dataIndex:'ITEM_CODE'               , width: 110},    
         {dataIndex:'ITEM_NAME'               , width: 200}, 
         {dataIndex:'PURCHASE_CODE'           , width: 100},    
         {dataIndex:'PURCHASE_NAME'           , width: 150},    
         {dataIndex:'SALE_P'                  , width: 85},    
         {dataIndex:'BEFORE_CNT'              , width: 85},    
         {dataIndex:'AFTER_CNT'               , width: 85},    
         {dataIndex:'SALE_Q'                  , width: 85, summaryType: 'sum'},    
         {dataIndex:'SALE_O'                  , width: 85, summaryType: 'sum'}   
      ]
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
      id: 'sva220skrvApp',
      fnInitBinding: function() {
         panelResult.setValue('DIV_CODE',UserInfo.divCode);
         UniAppManager.setToolbarButtons('NewData',false);
         UniAppManager.setToolbarButtons('Delete',false);
        /* panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
         panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
         panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
         panelResult.setValue('DEPT_NAME', UserInfo.deptName);*/
         
         panelSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
		 panelResult.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
         
		 panelSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
		 panelResult.setValue('INOUT_DATE_TO',UniDate.get('today'));
      },
      onQueryButtonDown: function()   {
         if(panelSearch.setAllFieldsReadOnly(true) == false){
            return false;
         }
         masterGrid.getStore().loadStoreRecords();
      },
      onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			UniAppManager.setToolbarButtons(['print'], false);
			this.fnInitBinding();
	  },
      onPrintButtonDown: function() {
         var param= Ext.getCmp('searchForm').getValues();

         var win = Ext.create('widget.PDFPrintWindow', {
            url: CPATH+'/sva/sva220rkrPrint.do',
            prgID: 'sva220rkr',
               extParam: {
                  DIV_CODE  	: param.DIV_CODE,
                  POS_CODE		: param.POS_CODE,
                  ITEM_CODE 	: param.ITEM_CODE,
                  ITEM_NAME		: param.ITEM_NAME,
                  INOUT_DATE_FR : param.INOUT_DATE_FR,
                  INOUT_DATE_TO	: param.INOUT_DATE_TO
               }
            });
            win.center();
            win.show();
	    }
   });
};
</script>