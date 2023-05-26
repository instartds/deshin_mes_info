<%@page language="java" contentType="text/html; charset=utf-8"%>

	 
/*	var mba020ukrvs_selectFormStore = Unilite.createStore('mba020ukrvs_selectFormStore',{
			//model: 'mba020ukrvs_1Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,		// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,		// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
//           proxy : directProxy,
			proxy: {
                type: 'direct',
                api: {
                	    read :  'mba020ukrvService.selectForm'
            	   		//update: bsa100ukrvService.updateCodes	
                }
            },
            saveStore : function()	{	
				var inValidRecs = this.getInvalidRecords();
            	
            	var rv = true;
            	
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();
				}else {
					panelDetail.down('#mba020ukrvs_1Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			loadStoreRecords : function(){
				this.load();
			}
			 Test 
			fnMasterSet: function(provider) {
				operating_Criteria.setValue('S012_1', provider.S012_1);
				operating_Criteria.setValue('S012_2', provider.S012_2);
				operating_Criteria.setValue('S012_3', provider.S012_3);
				operating_Criteria.setValue('S012_4', provider.S012_4);
				operating_Criteria.setValue('S012_5', provider.S012_5);
				operating_Criteria.setValue('S012_6', provider.S012_6);
				operating_Criteria.setValue('S012_7', provider.S012_7);
				operating_Criteria.setValue('S012_8', provider.S012_8);
			}
		});
		*/
		

	var operating_Criteria = Unilite.createSearchPanel('searchForm', {
		itemId: 'operating_Criteria',
		defaultType: 'uniSearchSubPanel',
		layout: {type: 'vbox', align:'stretch'},
		items:[{
			title:'<t:message code="system.label.purchase.purchasebasissetup" default="구매자재기준설정"/>',
			itemId: 'tab_operating',
			xtype: 'container',
    		layout: {type: 'hbox', align:'stretch'},
    		flex:1,
 			autoScroll:false,
 			items:[{
			
			fieldLabel:'ㅇㅇㅇ',
			name:'AA',
			xtype: 'uniTextfield'
		}]
			/*,listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		bsa100ukrvService.selectForm(param, function(provider, response)	{
	           			operating_Criteria.setValues({'S012_1':provider.REF_CODE1});
	           		});		
	           	}
			}*/
		}],
		api: {
                load :  'mba020ukrvService.selectForm'
            	   		//update: bsa100ukrvService.updateCodes	
                }
	})
	 
	 
	 
	 