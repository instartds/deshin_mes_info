<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd150ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	/*var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'agd150ukrService.runProcedure',
            syncAll	: 'agd150ukrService.callProcedure'
		}
	});	

	
	var buttonStore = Unilite.createStore('agd150ukrButtonStore',{ 
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
                var grid = Ext.getCmp('agd150ukrGrid');
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
    });*/
    
    
	/* 기간비용자동기표 Form
	 * @type
	 */     
	var panelSearch = Unilite.createForm('agd150ukrvDetail', {
    	disabled :false,
        flex:1,        
        layout: {type: 'uniTable', columns: 2, tdAttrs: {valign:'top'}},
		items :[{
			fieldLabel		: '실행월',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'FR_EXEC_MONTH',
			endFieldName	: 'TO_EXEC_MONTH',
    		startDate		: UniDate.get('today'),
    		endDate			: UniDate.get('today'),
			allowBlank		: false,
		  	colspan			: 2
	     },{
			fieldLabel	: '사업장',
			name		: 'ACCNT_DIV_CODE',
			xtype		: 'uniCombobox',
			multiSelect	: false, 
			typeAhead	: false,
	        allowBlank	: false,
			value		: UserInfo.divCode,
		  	colspan		: 2,
			comboType	: 'BOR120'
		},		    
        	Unilite.popup('COST',{
	        fieldLabel	: '기간비용',
	        validateBlank:true,
		    valueFieldName:'ITEM_CD_FR',
		    textFieldName:'ITEM_NM_FR',
		  	colspan		: 2
		}),		    
        	Unilite.popup('COST',{
	        fieldLabel	: '~',
	        validateBlank: true,
		    valueFieldName:'ITEM_CD_TO',
		    textFieldName:'ITEM_NM_TO',
		  	colspan		: 2
	    }),{
			fieldLabel	: '전표일',
	        xtype		: 'uniDatefield',
	 		name		: 'EX_DATE',
	 		value		: UniDate.get('today'),
		  	colspan		: 2,
	        allowBlank	: false
	     },{
			xtype		: 'container',
	    	items		: [{
	    		xtype	: 'button',
	    		text	: '실행',
	    		width	: 60,
	    		margin	: '0 0 0 120',	
				handler : function() {
					if(!panelSearch.getInvalidMessage()){				//자동기표 전 필수 입력값 체크
						return false;
					}
		            var buttonFlag = 'N';								//자동기표 FLAG
		            fnMakeLogTable(buttonFlag);
				}
	    	},{
	    		xtype	: 'button',
	    		text	: '취소',
	    		width	: 60,
	    		margin	: '0 0 0 0',                                                       
				handler	: function() {
					if(!panelSearch.getInvalidMessage()){				//자동기표 전 필수 입력값 체크
						return false;
					}
		            var buttonFlag = 'D';								//자동기표취소 FLAG
		            fnMakeLogTable(buttonFlag);
				}
    		}]
		}]		
	});    

	
    Unilite.Main( {
		id		: 'agd150ukrApp',
		items	: [panelSearch],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			
			var activeSForm = panelSearch;
			activeSForm.onLoadSelectText('FR_EXEC_MONTH');
		}
	});

	
	function fnMakeLogTable(buttonFlag) {														//자동기표 (insert log table  및 call SP)
		var param = panelSearch.getValues();
		param.OPR_FLAG = buttonFlag;
		var message = "자동기표가 실행되었습니다.";
		if(buttonFlag == 'D')	{
			message = "기표취소 되었습니다.";
		}
		agd150ukrService.callProcedure(param, function(provider, response) {
			if(provider && Ext.isEmpty(provider.ERROR_DESC))	{
				UniAppManager.updateStatus(message);
				
			}
		});
	}
};
</script>
