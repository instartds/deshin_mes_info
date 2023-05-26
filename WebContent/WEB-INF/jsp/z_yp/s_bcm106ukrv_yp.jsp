<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bcm106ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="s_bcm106ukrv_yp"/> 	   <!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="Z001" /> 			   <!-- 인증구분 -->
	<t:ExtComboStore comboType="AU" comboCode="Z006" />                <!-- 농가유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" />                <!-- 사용여부 -->
</t:appConfig>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")   {
      document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
    document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 's_bcm106ukrv_ypService.selectList',
        	update: 's_bcm106ukrv_ypService.updateDetail',
			create: 's_bcm106ukrv_ypService.insertDetail',
			destroy: 's_bcm106ukrv_ypService.deleteDetail',
			syncAll: 's_bcm106ukrv_ypService.saveAll'
        }
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_bcm106ukrv_ypModel', {
	    fields: [        
            {name: 'CUSTOM_CODE'          ,text: '거래처코드'          ,type: 'string', allowBlank: false},
            {name: 'CUSTOM_NAME'          ,text: '거래처명'           ,type: 'string', allowBlank: false},
            {name: 'FARM_CODE'            ,text: '농가코드'           ,type: 'string', editable: false},					//20171214 자동채번으로 변경
            {name: 'FARM_NAME'            ,text: '농가명'            ,type: 'string', allowBlank: false},
            {name: 'FARM_TYPE'            ,text: '농가유형'           ,type: 'string', comboType: "AU", comboCode: "Z006"},
            {name: 'CERT_NO'              ,text: '인증번호'           ,type: 'string'},
            {name: 'CERT_TYPE'            ,text: '인증구분'           ,type: 'string', comboType: "AU", comboCode: "Z001"},
            {name: 'CERT_ORG'             ,text: '인증기관'           ,type: 'string'},
            {name: 'ORIGIN'               ,text: '원산지'             ,type: 'string'},
            {name: 'ITEM_NAME'            ,text: '품목'              ,type: 'string'},
            {name: 'CULTI_AREA'           ,text: '재배면적(m2)'           ,type: 'uniPrice'},
            {name: 'CERT_END_DATE'        ,text: '유효기간'           ,type: 'uniDate'},
            {name: 'ZIP_CODE'             ,text: '우편번호'           ,type: 'string'},
            {name: 'ADDR'               ,text: '주소'              ,type: 'string'},
            {name: 'USE_YN'               ,text: '사용여부'           ,type: 'string', comboType: "AU", comboCode: "B010", defaultValue: 'Y'},
            {name: 'REMARK'               ,text: '비고'              ,type: 'string'}        
        ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_bcm106ukrv_ypMasterStore',{
			model: 's_bcm106ukrv_ypModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy							
			,loadStoreRecords : function()	{
				var param= panelResult.getValues();			
				console.log( param );
				this.load({ params : param});
			},
			// 수정/추가/삭제된 내용 DB에 적용 하기
			saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			
    			var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords(); 
	       		
	       		var list = [].concat(toUpdate, toCreate);
				console.log("list:", list);
				
				var paramMaster= panelResult.getValues();	//syncAll 수정				
    			if(inValidRecs.length == 0 )	{
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
	
    
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			xtype: 'uniTextfield',
			fieldLabel: '농가',
			name:'FARM'
		},{
            fieldLabel: '인증구분',
            name:'CERT_TYPE', 
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'Z001'
        },
            Unilite.popup('AGENT_CUST',{ 
            fieldLabel: '거래처', 
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME',
            validateBlank: false,
            listeners: {
                applyextparam: function(popup){
                    popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                }
            }
        }),{
            fieldLabel: '농가유형',
            name:'FARM_TYPE', 
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'Z006'
        }]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_bcm106ukrv_ypGrid1', {
    	region: 'center',
        layout: 'fit',
        uniOpt: {
    		expandLastColumn: false,
		 	copiedRow: true,
		 	onLoadSelectFirst: true
        },
        store: directMasterStore,
        columns: [
                {dataIndex: 'CUSTOM_CODE'       , width: 100    ,
                  'editor': Unilite.popup('AGENT_CUST_G',{
                        textFieldName   : 'CUSTOM_CODE',
                        DBtextFieldName : 'CUSTOM_CODE',
                        allowBlank      : false,
                        autoPopup       : true,
                        listeners       : { 
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                            },
                            'onClear' : function(type)  {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('CUSTOM_CODE','');
                                grdRecord.set('CUSTOM_NAME','');
                            },
                            'applyextparam': function(popup){
                                popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
                                popup.setExtParam({'CUSTOM_TYPE'        : ['1','2']});
                            }
                        }
                    })
                },
                {dataIndex: 'CUSTOM_NAME'       , width: 180    ,
                  'editor': Unilite.popup('AGENT_CUST_G',{
                        allowBlank      : false,
                        autoPopup       : true,
                        listeners       : {
                            'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                            },
                            'onClear' : function(type)  {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('CUSTOM_CODE','');
                                grdRecord.set('CUSTOM_NAME','');
                            },
                            'applyextparam': function(popup){
                                popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
                                popup.setExtParam({'CUSTOM_TYPE'        : ['1','2']});
                            }
                        }
                    })
                }, 
                {dataIndex: 'FARM_CODE'            , width: 100 }, 
                {dataIndex: 'FARM_NAME'            , width: 150 }, 
                {dataIndex: 'FARM_TYPE'            , width: 100 }, 
                {dataIndex: 'CERT_NO'              , width: 130 }, 
                {dataIndex: 'CERT_TYPE'            , width: 100 },
                {dataIndex: 'CERT_ORG'             , width: 100 },
                {dataIndex: 'ORIGIN'               , width: 100 }, 
                {dataIndex: 'ITEM_NAME'            , width: 150 }, 
                {dataIndex: 'CULTI_AREA'           , width: 100 }, 
                {dataIndex: 'CERT_END_DATE'        , width: 100 }, 
                { dataIndex: 'ZIP_CODE',  width: 100 
                  ,'editor': Unilite.popup('ZIP_G',{showValue:false, textFieldName:'ZIP_CODE' ,DBtextFieldName:'ZIP_CODE',
                        uniOpt:{recordFields:['ADDR'],
                        grid: 'bor120ukrvGrid'},
                        autoPopup: true,
                        listeners: { 'onSelected': {
                                            fn: function(records, type  ){
                                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                                grdRecord.set('ADDR', records[0]['ZIP_NAME']);
                                                grdRecord.set('ZIP_CODE', records[0]['ZIP_CODE']);
                                                console.log("(records[0] : ", records[0]);
                                                //Ext.getCmp('ADDR2_F').setValue(records[0]['ADDR2']);
                                            },
                                            scope: this
                                          },
                                          'onClear' : function(type)    {
                                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                                grdRecord.set('ADDR', '');
                                                grdRecord.set('ZIP_CODE', '');
                                          }
                                        }
                        })
                 },
                {dataIndex: 'ADDR'               , width: 170 },
                {dataIndex: 'USE_YN'               , width: 100 }, 
                {dataIndex: 'REMARK'               , minWidth: 100, flex: 1 } 
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
		id  : 's_bcm106ukrv_ypApp',
		fnInitBinding : function() {
			var activeSForm ;
			activeSForm = panelResult;
			activeSForm.onLoadSelectText('FARM');
			
			UniAppManager.setToolbarButtons(['reset', 'newData'],true);
			
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onNewDataButtonDown: function()	{
			var compCode		 = UserInfo.compCode;
        	var divCode          = panelResult.getValue('DIV_CODE');
        	var r ={
        		COMP_CODE			: compCode,
        		DIV_CODE            : divCode,
        		FARM_CODE			: Msg.sMSR226
        	};
	        masterGrid.createRow(r , 'DEPT_NAME');
		},
		onResetButtonDown:function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
            if(selRow.phantom === true) {
                masterGrid.deleteSelectedRow();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid.deleteSelectedRow();
            }
		}
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			switch(fieldName) {
				
				case "" : 
				
					break;
			}
			return rv;
		}
		
	});
};

</script>
