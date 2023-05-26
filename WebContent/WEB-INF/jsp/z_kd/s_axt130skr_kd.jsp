<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_axt130skr_kd"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="s_axt130skr_kd"/>             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {

    /**
     *   Model 정의 
     * @type 
     */
	Unilite.defineModel('s_axt130skr_kdModel', {
		fields: [
			{name: 'COMP_CODE'			, text:'법인코드'			, type:'string'},
			{name: 'DIV_CODE'			, text:'사업장코드'			, type:'string'},
			{name: 'SORT_SEQ'			, text:'순서'				, type:'string'},
			{name: 'CUSTOM_CODE'		, text:'거래처코드'			, type:'string' },
			{name: 'CUSTOM_NAME'		, text:'거래처명'			, type:'string'},
			{name: 'AMT_I'				, text:'송금액'			, type:'uniPrice'},
			{name: 'BOOK_NAME'			, text:'통장명'			, type:'string'},
			{name: 'BANK_CODE'			, text:'은행코드'			, type:'string'},
			{name: 'BANK_NAME'			, text:'은행명'			, type:'string'},
			{name: 'BANKBOOK_NAME'		, text:'예금주'			, type:'string'},
			{name: 'BANKBOOK_NUM'		, text:'계좌번호'			, type:'string'},
			{name: 'REMARK'				, text:'비고'				, type:'string'}
		]
	});
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('s_axt130skr_kdMasterStore1',{
            model: 's_axt130skr_kdModel',
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable:false,            // 삭제 가능 여부 
                useNavi : false            // prev | newxt 버튼 사용
               
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {            
                       read: 's_axt130skr_kdService.selectList'                    
                }
            }
            ,loadStoreRecords : function()    {
                var param= Ext.getCmp('panelResultForm').getValues();            
                console.log( param );
                this.load({
                    params : param
                });
                
            },
            listeners: {
            load: function(store, records, successful, eOpts) {
            	var count = masterGrid.getStore().getCount();  
				if(count > 0){
					Ext.getCmp('GW').setDisabled(false);
				}else{
					Ext.getCmp('GW').setDisabled(true);
				}
            }
        }
    });
    

    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [
            	/*{
                    fieldLabel        : '신청기간',
                    xtype             : 'uniDateRangefield',
                    startFieldName    : 'FR_DATE',
                    endFieldName      : 'TO_DATE',
                    startDate         : UniDate.get('startOfMonth'),
                    endDate           : UniDate.get('today'),
                    allowBlank        : false,          
                    tdAttrs           : {width: 350},
                    width             : 315,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    }
               }*/
               {
	                fieldLabel: '기준 월',
	                xtype: 'uniMonthfield',
	                name: 'ST_DATE',
	                labelWidth:90,
	                value: new Date(),
	                allowBlank: false,
	                listeners: {
	                      change: function(field, newValue, oldValue, eOpts) {                                  
	                            panelResult.setValue('ST_DATE', newValue);
	                      }
	                }
	           },
               {
                    fieldLabel: '사업장',
                    name:'DIV_CODE', 
                    xtype: 'uniCombobox',
//                  multiSelect: true, 
                    typeAhead: false,
                    comboType:'BOR120',
                    width: 325,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                },       
	            Unilite.popup('CUST',{ 
	                fieldLabel: '거래처', 
	                popupWidth: 710,
	                autoPopup   : true ,
	                hidden: true,
	                colspan:3,
	                valueFieldName: 'CUSTOM_CODE',
	                textFieldName: 'CUSTOM_NAME',
	                listeners: {
	                    onSelected: {
	                        fn: function(records, type) {
	                        },
	                        scope: this
	                    },
	                    onClear: function(type) {
	                    },
	                    applyextparam: function(popup){                         
	                    },
	                    onTextSpecialKey: function(elm, e){
	                        if (e.getKey() == e.ENTER) {
	                            UniAppManager.app.onQueryButtonDown();  
	                        }
	                    }
	                }
	            })
            ]
    });
    
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_axt130skr_kdGrid1', {
		region: 'center',
		layout: 'fit',
		uniOpt:{    
			expandLastColumn: false,    //마지막 컬럼 * 사용 여부
			useRowNumberer: true,        //첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,        //찾기 버튼 사용 여부
			useRowContext: false,            
			onLoadSelectFirst    : true,
			filter: {                    //필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		tbar: [{
			itemId : 'GWBtn',
			id:'GW',
			iconCls : 'icon-referance'  ,
			text:'기안',
			handler: function() {
				var param = panelResult.getValues();
				
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
				if(confirm('기안 하시겠습니까?')) {
					UniAppManager.app.requestApprove();
				}
			}
		}],
		features: [ 
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
		],
		store: directMasterStore1,
		columns:  [
			{ dataIndex: 'SORT_SEQ'			, width: 133, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'		, width: 80	, align: 'center'},
			{ dataIndex: 'CUSTOM_NAME'		, width: 133},
			{ dataIndex: 'AMT_I'			, width: 133},					
			{ dataIndex: 'BOOK_NAME'		, width: 133},
			{ dataIndex: 'BANK_CODE'		, width: 80	, align: 'center'},
			{ dataIndex: 'BANK_NAME'		, width: 133},
			{ dataIndex: 'BANKBOOK_NAME'	, width: 133},
			{ dataIndex: 'BANKBOOK_NUM'		, width: 133},
			{ dataIndex: 'REMARK'			, width: 133}
		]
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
        id  : 's_axt130skr_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            var activeSForm = panelResult;
            //activeSForm.onLoadSelectText('PERSON_NUMB');
            
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
            
            Ext.getCmp('GW').setDisabled(true);
        },
        onQueryButtonDown : function()    {
            if(!this.isValidSearchForm()){
                return false;
            }
            masterGrid.getStore().loadStoreRecords();
            
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            console.log("viewLocked : ",viewLocked);
            console.log("viewNormal : ",viewNormal);
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
        },
        onResetButtonDown:function() {
            panelResult.clearForm();
            masterGrid.getStore().loadData({});
            
            this.fnInitBinding();
        },
        onPrintButtonDown: function() {
               
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID
            var stmonth     = UniDate.getDbDateStr(panelResult.getValue('ST_DATE'));
            var personnumb  = panelResult.getValue('CUSTOM_CODE');
            
            
            //var record = masterGrid.getSelectedRecord();
            var groupUrl    = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=axt130skr&draft_no=0&sp=EXEC " 
                                   
            var spText      = 'omegaplus_kdg.unilite.USP_ACCNT_AXT130SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + stmonth + "'" 
                            + ', ' + "'" + divCode + "'" + ', ' + "''"
                            + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
            var spCall      = encodeURIComponent(spText); 
            

            frm.action   = groupUrl + spCall/* + Base64.encode()*/;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        }
    });
};


</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
