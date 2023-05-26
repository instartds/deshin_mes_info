<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssu100ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="ssu100ukrv" /> <!-- 사업장 -->       
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'ssu100ukrvService.selectList',
            update: 'ssu100ukrvService.updateDetail',
            create: 'ssu100ukrvService.insertDetail',
            destroy: 'ssu100ukrvService.deleteDetail',
            syncAll: 'ssu100ukrvService.saveAll'
        }
    });
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Ssu100ukrvModel', {
	    fields: [{name: 'DIV_CODE'       	,text:'<t:message code="system.label.sales.division" default="사업장"/>' 	       		,type:'string'},		
				 {name: 'FIN_DATE'       	,text:'<t:message code="system.label.sales.closingdate" default="마감일"/>' 	       	,type:'uniDate', allowBlank: false},		
				 {name: 'ISSUE_FIN_YN'   	,text:'<t:message code="system.label.sales.issueclosing" default="출고마감"/>' 	   	,type:'boolean'},		
				 {name: 'SALE_FIN_YN'    	,text:'<t:message code="system.label.sales.salesclosing" default="매출마감"/>' 	   	,type:'boolean'},		
				 {name: 'COLLECT_YN'     	,text:'<t:message code="system.label.sales.collectionclosing" default="수금마감"/>' 	,type:'boolean'},		
				 {name: 'UPDATE_DB_USER' 	,text:'<t:message code="system.label.sales.updateuser" default="수정자"/>' 	       	,type:'string'},		
				 {name: 'UPDATE_DB_TIME'	,text:'<t:message code="system.label.sales.updatedate" default="수정일"/>' 	       	,type:'uniDate'}				 	
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssu100ukrvMasterStore1',{
			model: 'Ssu100ukrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			saveStore : function(config)    {               
                var inValidRecs = this.getInvalidRecords();
                if(inValidRecs.length == 0 )    {       
                            directMasterStore1.syncAllDirect(config);
                }else {
                    masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
	});
	
	var panelSearch = Unilite.createSearchForm('searchForm',{ 
		region: 'top',
		itemId: 'search_panel1',
		layout : {type : 'uniTable', columns : 2},
        items : [{
        	fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        	name:'DIV_CODE',
        	xtype: 'uniCombobox',
        	comboType:'BOR120',
        	allowBlank:false 
        }, {
			fieldLabel: '<t:message code="system.label.sales.closingdate" default="마감일"/>',
	        width: 315,
            xtype: 'uniDateRangefield',
            startFieldName: 'FIN_DATE_FR',
            endFieldName: 'FIN_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank: false
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } else {
//                  this.mask();
//                  var fields = this.getForm().getFields();
//                  Ext.each(fields.items, function(item) {
//                      if(Ext.isDefined(item.holdable) ){
//                          if (item.holdable == 'hold') {
//                              item.setReadOnly(true); 
//                          }
//                      } 
//                      if(item.isPopupField)   {
//                          var popupFC = item.up('uniPopupField')  ;                           
//                          if(popupFC.holdable == 'hold') {
//                              popupFC.setReadOnly(true);
//                          }
//                      }
//                  })
                }
            } else {
                //this.unmask();
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
        }
    });
    
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('ssu100ukrvGrid1', {
    	// for tab
    	region: 'center',
        layout : 'fit', 
    	store: directMasterStore1,
        columns:  [{dataIndex: 'DIV_CODE'       		, width: 66, hidden: true},
    			   {dataIndex: 'FIN_DATE'       		, width: 100},
    			   {dataIndex: 'ISSUE_FIN_YN'   		, width: 133, xtype : 'checkcolumn'},
    			   {dataIndex: 'SALE_FIN_YN'    		, width: 133, xtype : 'checkcolumn'},
    			   {dataIndex: 'COLLECT_YN'     		, width: 133, xtype : 'checkcolumn'},
    			   {dataIndex: 'UPDATE_DB_USER' 		, width: 66, hidden: true},
    			   {dataIndex: 'UPDATE_DB_TIME' 		, width: 66, hidden: true}
		]
    });
    

   	
    Unilite.Main( {
		items : [panelSearch, 	masterGrid1],
		fnInitBinding : function() {			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{	
			if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
			directMasterStore1.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset','newData'], true);
			
		},
        onResetButtonDown: function() {     // 초기화
            panelSearch.setAllFieldsReadOnly(false);
            this.suspendEvents();
            panelSearch.clearForm();
            directMasterStore1.clearData();
            masterGrid1.reset();
            panelSearch.getField('DIV_CODE').focus();
            this.fnInitBinding();
        },
        onSaveDataButtonDown: function(config) {    // 저장 버튼
            directMasterStore1.saveStore();
        },
        onDeleteDataButtonDown: function() {    // 행삭제 버튼
            var selRow1 = masterGrid1.getSelectedRecord();
            if(selRow1.phantom === true)    {
                masterGrid1.deleteSelectedRow();
            }else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                masterGrid1.deleteSelectedRow();
            }
        },
        onNewDataButtonDown: function() {       // 행추가
            var divCode         = panelSearch.getValue('DIV_CODE'); 
            var finDate         = UniDate.get('today'); 
            var issueFinYn      = 'true'; 
            var saleFinYn       = 'true'; 
            var collectYn       = 'true'; 
            
            var r = {
                DIV_CODE        : divCode,      
                FIN_DATE        : finDate,    
                ISSUE_FIN_YN    : issueFinYn,
                SALE_FIN_YN     : saleFinYn, 
                COLLECT_YN      : collectYn 
            };
            masterGrid1.createRow(r);
            panelSearch.setAllFieldsReadOnly(true);
        }
	});

};


</script>
