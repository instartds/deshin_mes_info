<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd441ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'agd441ukrService.runProcedure',
            syncAll	: 'agd441ukrService.callProcedure'
		}
	});	

	
	var buttonStore = Unilite.createStore('agd441ukrButtonStore',{ 
        proxy	: directButtonProxy,     
        uniOpt	: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,            // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        saveStore: function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

            var paramMaster = panelSearch.getValues();
            paramMaster.OPR_FLAG	= buttonFlag;
            paramMaster.LANG_TYPE	= UserInfo.userLang;
            paramMaster.DATE_FR		= panelSearch.getValue('SLIP_DATE');
            paramMaster.DATE_TO		= panelSearch.getValue('SLIP_DATE');

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();
                        buttonStore.clearData();
                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('agd441ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
        }
    });
    
    
	/* 기간비용자동기표 Form
	 * @type
	 */     
	var panelSearch = Unilite.createForm('agd441ukrvDetail', {
    	disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 1},
		items :[{
		  xtype: 'fieldset',
		  title: '관련사MIS로 보내기',
		  height: 100,
		  width: 460,
		  margin: '0 0 0 20',
		  layout: {type: 'uniTable', columns: 3,
                tdAttrs: {style: 'font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}        
          },
          items:[{     
                fieldLabel: '전표일',
                xtype: 'uniDateRangefield',
                startFieldName: 'AC_DATE_FR',
                endFieldName: 'AC_DATE_TO',
                startDate: UniDate.get('today'), 
                endDate: UniDate.get('today'), 
                allowBlank:false,
                colspan: 3
            },{
                xtype: 'component',
                html: '조인스허브 -> 관련사MIS',
                margin: '15 0 0 20',
                width: 200
            },{                        
               width: 100,
               xtype: 'button',
               text: '이관',
               tdAttrs: {align: 'right'},
               margin: '15 100 0 0',
               handler : function() {
                    if(confirm("이관하시겠습니까?")){
                       var param = {FR_DATE: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_FR')), TO_DATE: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_TO'))};
                       Ext.getBody().mask('로딩중...','loading-indicator');
                       agd441ukrService.sendToMis(param, function(provider, response)   {                       
                            if(provider){
                                UniAppManager.updateStatus(Msg.sMB011);
                            }
                            Ext.getBody().unmask();
                        }); 
                    }               
               }
            },{                        
               width: 100,
               xtype: 'button',
               text: '이관취소',
               tdAttrs: {align: 'right'},
                margin: '15 100 0 10',
               handler : function() {
                    if(confirm("이관취소하시겠습니까?")){
                       var param = {FR_DATE: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_FR')), TO_DATE: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_TO'))};
                       Ext.getBody().mask('로딩중...','loading-indicator');
                       agd441ukrService.cancelToMis(param, function(provider, response)   {                       
                            if(provider){
                                UniAppManager.updateStatus(Msg.sMB011);
                            }
                            Ext.getBody().unmask();
                        }); 
                    }                
               }
            }
          ]
		},{
          xtype: 'fieldset',
          title: '조인스허브로 보내기',
          height: 120,
          width: 460,
          margin: '30 0 0 20',
          layout: {type: 'uniTable', columns: 3,
                tdAttrs: {style: 'font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;'}        
          },
          items:[{     
                fieldLabel: '전표일',
                xtype: 'uniDateRangefield',
                startFieldName: 'AC_DATE_FR2',
                endFieldName: 'AC_DATE_TO2',
                startDate: UniDate.get('today'), 
                endDate: UniDate.get('today'), 
                allowBlank:false,
                colspan: 3
            },{
                xtype: 'radiogroup',                      
                fieldLabel: '작업구분',
                id:'workOption',
                colspan: 3,
                items: [{
                    boxLabel: 'J Center',
                    width: 110,
                    name: 'WORK_OPTION',
                    inputValue: 'JC',
                    checked: true
                },{
                    boxLabel: '관계사',
                    width: 70,
                    name: 'WORK_OPTION',
                    inputValue: 'JM'
                }]
            },{
                xtype: 'component',
                html: '관련사MIS -> 조인스허브',
                margin: '15 0 0 20',
                width: 200
            },{                        
               width: 100,
               xtype: 'button',
               text: '이관',
               tdAttrs: {align: 'right'},
                margin: '15 100 0 0',
               handler : function() {
                    if(confirm("이관하시겠습니까?")){
                       var param = {FR_DATE: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_FR2')), TO_DATE: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_TO2')), WORK_OPTION:Ext.getCmp('workOption').getValue().WORK_OPTION };
                       Ext.getBody().mask('로딩중...','loading-indicator');
                       agd441ukrService.sendToHub(param, function(provider, response)   {                       
                            if(provider){
                                UniAppManager.updateStatus(Msg.sMB011);                               
                            }
                            Ext.getBody().unmask();
                        }); 
                    }               
               }
            },{                        
               width: 100,
               xtype: 'button',
               text: '이관취소',
               tdAttrs: {align: 'right'},
                margin: '15 100 0 10',
               handler : function() {
                    if(confirm("이관취소하시겠습니까?")){
                       var param = {FR_DATE: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_FR2')), TO_DATE: UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_TO2')), WORK_OPTION:Ext.getCmp('workOption').getValue().WORK_OPTION};
                       Ext.getBody().mask('로딩중...','loading-indicator');
                       agd441ukrService.cancelToHub(param, function(provider, response)   {                       
                            if(provider){
                                UniAppManager.updateStatus(Msg.sMB011);
                            }
                            Ext.getBody().unmask();
                        }); 
                    }               
               }
            }
          ]
        }]		
	});    

	
    Unilite.Main( {
		id		: 'agd441ukrApp',
		items	: [panelSearch],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			
			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('AC_DATE_FR');
		}
	});

	
	function fnMakeLogTable(buttonFlag) {														//자동기표 (insert log table  및 call SP)
		var param = panelSearch.getValues();
		agd441ukrService.getItemCode(param, function(provider, response) {
			var records = provider;

			buttonStore.clearData();																//clear buttonStore
			Ext.each(records, function(record, index) {
	            record.phantom 				= true;
				record.OPR_FLAG			= buttonFlag;	
				record.ACCNT_DIV_CODE	= param.ACCNT_DIV_CODE;	
				record.DATE_FR			= param.SLIP_DATE;
				record.DATE_TO			= param.SLIP_DATE;
				record.EX_DATE			= param.EX_DATE;
	            buttonStore.insert(index, record);
				
				if (records.length == index +1) {
	                buttonStore.saveStore(buttonFlag);
				}
			});
		});
	}
};
</script>
