<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tix901skrv_kd"  >
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
			read: 's_tix901skrv_kdService.selectList'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_tix901skrv_kdModel', {
	    fields: [
	    	{name: 'COMP_CODE'          ,text: '법인코드' 		   ,type: 'string'},
            {name: 'DIV_CODE'           ,text: '사업장'            ,type: 'string'},
            {name: 'DATE_DEPART'        ,text: 'OFFER일자'         ,type: 'string'},
            {name: 'CUSTOM_CODE'        ,text: '거래처명'          ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '거래처'            ,type: 'string'},
            {name: 'DATE_DEPART'        ,text: 'OFFER일자'         ,type: 'uniDate'},
            {name: 'OFFER_NO'           ,text: 'OFFER번호'          ,type: 'string'},
            {name: 'SO_AMT_WON'         ,text: 'OFFER금액'          ,type: 'uniPrice'},
            {name: 'EXCHG_RATE_O'       ,text: '환율'              ,type: 'uniER'},
            {name: 'CAL_MUL_DAE'        ,text: '물대'              ,type: 'uniPrice'},
            {name: 'LC_RATE'            ,text: 'LC요율'            ,type: 'uniER'},
            {name: 'CAL_LC_FEE'         ,text: 'LC수수료'          ,type: 'uniPrice'},
            {name: 'FOB_FOR_AMT'        ,text: 'FOB가격'           ,type: 'uniPrice'},
            {name: 'CBM'                ,text: 'CBM'               ,type: 'uniPrice'},
            {name: 'CAL_SUNIM'          ,text: '선임'              ,type: 'uniPrice'},
            {name: 'IMPORT_TAX_RATE'    ,text: '수입세율'          ,type: 'uniER'},
            {name: 'CAL_DUTY_FEE'       ,text: '관세'              ,type: 'uniPrice'},
            {name: 'CAL_TAX_AMT'        ,text: '부가세'            ,type: 'uniPrice'},
            {name: 'UNLOAD_AMT'         ,text: '하역기준료'        ,type: 'uniPrice'},
            {name: 'CAL_UNLOAD_AMT'     ,text: '하역료'            ,type: 'uniPrice'},
            {name: 'CAL_STOCK_AMT'      ,text: '보관료'            ,type: 'uniPrice'},
            {name: 'CAL_WORK_AMT'       ,text: '작업료'            ,type: 'uniPrice'},
            {name: 'CAL_CLEAR_AMT'      ,text: '통관료'            ,type: 'uniPrice'},
            {name: 'UNLOAD_PLACE'       ,text: '하역지'            ,type: 'string', comboType: "AU", comboCode: "WT01"},
            {name: 'CAL_UNIM'           ,text: '운임'              ,type: 'uniPrice'},
            {name: 'CAL_CFS'            ,text: 'C.F.S'             ,type: 'uniPrice'},
            {name: 'ETC_AMT'            ,text: '기타'              ,type: 'uniPrice'},
            {name: 'CAL_RETURN'         ,text: '환급'              ,type: 'uniPrice'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('s_tix901skrv_kdMasterStore',{
			model: 's_tix901skrv_kdModel',
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

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
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
            },
            Unilite.popup('INCOM_OFFER', {     //수입 OFFER 관리번호
                fieldLabel: 'OFFER번호',
                id: 'INCOM_OFFER2'
            }),{ 
                fieldLabel: 'OFFER일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'DATE_DEPART_FR',
                endFieldName: 'DATE_DEPART_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                extParam: {'CUSTOM_TYPE': ['1','2']}
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
    var masterGrid = Unilite.createGrid('s_tix901skrv_kdGrid', {
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
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
        	{ dataIndex: 'COMP_CODE'                  , 		    width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'                   ,             width: 100, hidden: true},
            { dataIndex: 'CUSTOM_CODE'                ,             width: 110},
            { dataIndex: 'CUSTOM_NAME'                ,             width: 200},
            { dataIndex: 'DATE_DEPART'                ,             width: 80},
            { dataIndex: 'OFFER_NO'                   ,             width: 100},
            { dataIndex: 'SO_AMT_WON'                 ,             width: 120},
            { dataIndex: 'EXCHG_RATE_O'               ,             width: 120},
            { dataIndex: 'CAL_MUL_DAE'                ,             width: 120},
            { dataIndex: 'LC_RATE'                    ,             width: 120},
            { dataIndex: 'CAL_LC_FEE'                 ,             width: 120},
            { dataIndex: 'FOB_FOR_AMT'                ,             width: 120},
            { dataIndex: 'CBM'                        ,             width: 120},
            { dataIndex: 'CAL_SUNIM'                  ,             width: 120},
            { dataIndex: 'IMPORT_TAX_RATE'            ,             width: 120},
            { dataIndex: 'CAL_DUTY_FEE'               ,             width: 120},
            { dataIndex: 'CAL_TAX_AMT'                ,             width: 120},
            { dataIndex: 'UNLOAD_AMT'                 ,             width: 120},
            { dataIndex: 'CAL_UNLOAD_AMT'             ,             width: 120},
            { dataIndex: 'CAL_STOCK_AMT'              ,             width: 120},
            { dataIndex: 'CAL_WORK_AMT'               ,             width: 120},
            { dataIndex: 'CAL_CLEAR_AMT'              ,             width: 120},
            { dataIndex: 'UNLOAD_PLACE'               ,             width: 120},
            { dataIndex: 'CAL_UNIM'                   ,             width: 120},
            { dataIndex: 'CAL_CFS'                    ,             width: 120},
            { dataIndex: 'ETC_AMT'                    ,             width: 120},
            { dataIndex: 'CAL_RETURN'                 ,             width: 120}
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
		id  : 's_tix901skrv_kdApp',
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
            panelResult.setValue('DATE_DEPART_FR',UniDate.get('startOfMonth'));
            panelResult.setValue('DATE_DEPART_TO',UniDate.get('today'));             
            UniAppManager.setToolbarButtons(['reset', 'save'], false); 
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