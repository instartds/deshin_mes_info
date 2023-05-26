<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hxt110ukr">
    <t:ExtComboStore comboType="BOR120"  />                     <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H034"  />                       <!-- 공제코드 -->
    <t:ExtComboStore comboType="AU" comboCode="S06" />         <!-- 사용여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create    : 'hxt110ukrService.insertList',                
            read      : 'hxt110ukrService.selectList',
            update    : 'hxt110ukrService.updateList',
            destroy   : 'hxt110ukrService.deleteList',
            syncAll   : 'hxt110ukrService.saveAll'
        }
    });
    
    /** Model 정의 
     * @type 
     */
    Unilite.defineModel('hxt110ukrModel', {
        fields: [
            {name: 'COMP_CODE'            , text: '법인코드'         , type: 'string'},
            {name: 'PERSON_NUMB'          , text: '사번'             , type: 'string'             , allowBlank: false},
            {name: 'NAME'                 , text: '성명'             , type: 'string'             , editable:false},
            {name: 'WAGES_CODE'           , text: '공제코드'         , type: 'string'             , allowBlank: false             , comboType:'AU',      comboCode:'H034'},
            {name: 'REG_DATE'             , text: '등록일'           , type: 'uniDate'            , editable:false},
            {name: 'PAY_YYYYMM'           , text: '급여귀속월'       , type: 'string'             , allowBlank: false },
            {name: 'STD_PAY'              , text: '기본금'           , type: 'uniPrice'           , defaultValue:0 },
            {name: 'WAGES_AMT'            , text: '금액'             , type: 'uniPrice'           , defaultValue:0 },
            {name: 'PAY_YN'               , text: '급여반영여부'     , type: 'string'             , comboType:'AU'                , comboCode:'S06'              , align:'center'},
            {name: 'REMARK'               , text: '비고'             , type: 'string'}
        ]                                        
    });//End of Unilite.defineModel('hxt110ukrModel', {
    
    
    
    /** Store 정의(Service 정의)
     * @type 
     */            
    var masterStore = Unilite.createStore('hxt110ukrMasterStore1', {
        model    : 'hxt110ukrModel',
        proxy    : directProxy,
        uniOpt    : {
            isMaster    : true,              // 상위 버튼 연결 
            editable    : true,              // 수정 모드 사용 
            deletable   : true,              // 삭제 가능 여부 
            useNavi     : false              // prev | newxt 버튼 사용
        },
        autoLoad: false,
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();
            //var payyyyymm = panelResult2.getValue('PAY_YYYYMM');
            var payyyyymm = UniDate.getDbDateStr(panelResult2.getValue('PAY_YYYYMM')).substring(0, 6);

            param.PAY_YYYYMM = payyyyymm
            console.log(param);
            this.load({
                params: param
            });
        },
                
        saveStore : function()    {                
            var inValidRecs = this.getInvalidRecords();
            if(inValidRecs.length == 0 )    {
                config = {
                    success: function(batch, option) {
                        
                    } 
                };
                this.syncAllDirect(config);                
            }else {                    
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function() {
                if (this.getCount() > 0) {
//                      UniAppManager.setToolbarButtons('delete', true);
                    } else {
//                            UniAppManager.setToolbarButtons('delete', false);
                    }  
            }
        }
    });
        

    
    
    /** 검색조건 (Search Panel)
     * @type 
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region    : 'north',
        layout    : {type : 'uniTable', columns : 3},
        padding    : '1 1 1 1',
        border    : true,
        items    : [{ 
                fieldLabel        : '등록일',
                xtype            : 'uniDateRangefield',
                startFieldName    : 'REG_DATE_FR',
                endFieldName    : 'REG_DATE_TO',
                tdAttrs            : {width: 350}, 
                width            : 315,
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
                        panelResult.setValue('REG_DATE_FR', newValue);                     
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
                        panelResult.setValue('REG_DATE_TO', newValue);                         
                    }
                }
            }, {
                fieldLabel  : '사업장',
                name        : 'DIV_CODE', 
                xtype       : 'uniCombobox',
                multiSelect : true, 
                typeAhead   : false,
                comboType   : 'BOR120',
                colspan		: 2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            }, 
            Unilite.popup('Employee',{
                    fieldLabel      : '사원',
                    valueFieldName  : 'PERSON_NUMB',
                    textFieldName   : 'NAME',
                    validateBlank   : false,
                    autoPopup       : true,
                    listeners: {
                        onValueFieldChange: function(field, newValue){
                        },
                        onTextFieldChange: function(field, newValue){
                        }
                    }
            }), 
            Unilite.treePopup('DEPTTREE',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT',
                textFieldName   : 'DEPT_NAME' ,
                valuesName      : 'DEPTS' ,
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                selectChildren  : true,
                validateBlank   : true,
                autoPopup       : true,
                useLike         : true,
                colspan			: 2,
                listeners       : {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                    },
                    'onValuesChange':  function( field, records){
                    }
                }
            }), {
            	xtype: 'uniTextfield',
                fieldLabel  : 'test',
                name        : 'flag',
                value: '',
                colspan     : 2, 
                hidden: true
            }
        ]
    });
    
    var panelResult2 = Unilite.createSearchForm('panelDetailForm',{
        padding:'0 1 0 1',
        layout : {type : 'uniTable', columns : 6},
        border:true,
        region: 'center',
        items: [
                {
				fieldLabel: '작업일',
				xtype		: 'uniDatefield',
				name		: 'WORK_DATE',                
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult2.setValue('WORK_DATE', newValue);
					}
				}
			}, {
                fieldLabel	: '공제코드',
                name		: 'DED_CODE', 
                xtype		: 'uniCombobox',
                comboType	: 'AU',
                comboCode	: 'H034',
                allowBlank	: true
            },{
                xtype:'uniTextfield',
                fieldLabel:'공제율',
                name:'DED_RATE',
                labelWidth:45
            }, {
	        	fieldLabel	: '기준급여년월',
	        	xtype		: 'uniMonthfield',
	        	allowBlank	:true,
	        	name		: 'ST_MONTH',
				value		: UniDate.get('startOfMonth'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult2.setValue('ST_MONTH', newValue);
					}
				}
	       	}, {
	        	fieldLabel	: '급여년월',
	        	xtype		: 'uniMonthfield',
	        	allowBlank	:true,
	        	name		: 'PAY_YYYYMM',
				value		: UniDate.get('startOfMonth'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult2.setValue('PAY_YYYYMM', newValue);
					}
				}
	       	},{
				xtype: 'button',
				text: '적 용',
				margin: '0 0 0 10', 
				name: 'PROC',
				
				handler: function(){		
					//UniAppManager.app.fnApproval();
					var param = panelResult2.getValues();
                   /* var workdate = param.WORK_DATE;
                    var stmonth = panelResult2.getValue('ST_MONTH').replace('.','');
                    var payyyyymm = panelResult2.getValue('PAY_YYYYMM').replace('.','');*/
                    
                    /*param.WORK_DATE = workdate
                    param.ST_MONTH = stmonth
                    param.PAY_YYYYMM = payyyyymm       */             
                    panelResult2.getEl().mask('로딩중...','loading-indicator');
                    
                    hxt110ukrService.insertMaster(param, function(provider, response)  {
                    if(provider){
                        UniAppManager.updateStatus(Msg.sMB011);
                        
                        //hxt110ukrService.spSelect(param, function(provider, response)  {
                                panelResult.setValue('flag', '1');
                                masterStore.loadStoreRecords();
                                panelResult.setValue('flag', '');
                        //});
                        
                    }
                    
                    panelResult2.getEl().unmask();
                    });
                    
				}
			}]
    });
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hxt110ukrGrid1', {
        store    : masterStore,
        layout    : 'fit',
        region    : 'center',
        uniOpt    : {
            expandLastColumn: true,
             useRowNumberer    : true,
             copiedRow        : true
//             useContextMenu    : true,
        },
        features: [ {id : 'masterGridSubTotal'   , ftype: 'uniGroupingsummary'    , showSummaryRow: false },
                    {id : 'masterGridTotal'      , ftype: 'uniSummary'            , showSummaryRow: false } ],
        columns    : [    
            {dataIndex: 'PERSON_NUMB'          , width: 130,
            	'editor' : Unilite.popup('Employee_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {'onSelected': {
                                        fn: function(records, type) {
                                            UniAppManager.app.fnHumanCheck(records);    
                                        },
                                        scope: this
                                    },
                                    'onClear': function(type) {
                                        var grdRecord = Ext.getCmp('hum305ukrGrid1').uniOpt.currentRecord;
                                        grdRecord.set('PERSON_NUMB','');
                                        grdRecord.set('NAME','');
                                    }
                        }
                    })},
            {dataIndex: 'NAME'                 , width: 110},
            {dataIndex: 'WAGES_CODE'           , width: 110},
            {dataIndex: 'REG_DATE'             , width: 100},
            {dataIndex: 'PAY_YYYYMM'           , width: 100                 , align: 'center'
            	,renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    if(!Ext.isEmpty(val)){
                        return  val.substring(0,4) + '.' + val.substring(4,6);
                       }}},
            {dataIndex: 'STD_PAY'              , width: 110},
            {dataIndex: 'WAGES_AMT'            , width: 110},
            {dataIndex: 'PAY_YN'               , width: 100},
            {dataIndex: 'REMARK'               , width: 250}
        ], 
        listeners: {
              beforeedit  : function( editor, e, eOpts ) {
                  if(!e.record.phantom){  // 신규가 아닐 때
                      if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'WAGES_CODE', 'PAY_YYYYMM', 'STD_PAY'])){
                        return false;
                      }
                  }
                  if(!e.record.phantom == true || e.record.phantom == true) {   // 신규이던 아니던
                      if(UniUtils.indexOf(e.field, ['NAME'])) {
                          return false;
                      }
                  }
              }
        }
    });  //End of var masterGrid = Unilite.createGr100id('hxt110ukrGrid1', {    
            
    
    Unilite.Main( {
        id            : 'hxt110ukrApp',
        border        : false,
        borderItems    : [{
            region    : 'center',
            layout    : {type: 'vbox', align: 'stretch'},
            border    : false,
            items    : [
                panelResult, panelResult2, masterGrid 
            ]
        }],
        
        fnInitBinding: function() {
            //초기값 설정
            panelResult.setValue('USE_YN'    , 'Y');

            //버튼 설정
            UniAppManager.setToolbarButtons(['newData']            , true);
            UniAppManager.setToolbarButtons(['reset', 'save']    , false);

            //초기화 시, 포커스 설정
            panelResult.setValue('REG_DATE_FR',UniDate.get('today'));
            panelResult.setValue('REG_DATE_TO',UniDate.get('today'));
            panelResult2.setValue('WORK_DATE',UniDate.get('today'));
            panelResult.onLoadSelectText('REG_DATE_FR');
        },
        
        onQueryButtonDown: function() {
            //필수입력값 체크
            if(!this.isValidSearchForm()){
                return false;
            }
            
            masterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        
        onNewDataButtonDown : function() {
            if(!this.isValidSearchForm()){
                return false;
            }
            var record = {};
            masterGrid.createRow(record, null, masterGrid.getStore().getCount()-1);
            UniAppManager.setToolbarButtons('reset', true);
        },
        
        onSaveDataButtonDown : function() {
            masterGrid.getStore().saveStore();
        },
        
        onDeleteDataButtonDown : function()    {
            var selRow = masterGrid.getSelectedRecord();
            if(selRow.phantom === true)    {
                masterGrid.deleteSelectedRow();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid.deleteSelectedRow();
            }
        },
        
        onResetButtonDown : function() {
            panelResult.clearForm();
            masterGrid.getStore().loadData({});
            this.fnInitBinding();;
        },
                
        fnHumanCheck: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
            grdRecord.set('NAME', record.NAME);
        }
    });//End of Unilite.Main( {
};
</script>
