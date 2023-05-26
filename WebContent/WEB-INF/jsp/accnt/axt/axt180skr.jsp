<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="axt180skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="axt180skr"/>             <!-- 사업장 -->
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
    Unilite.defineModel('Axt180skrModel', {
        fields: [
            {name: 'COMP_CODE'                  ,text:'법인코드'        ,type:'string'},
            {name: 'DEPT_CODE'                  ,text:'부서코드'          ,type:'string' },
            {name: 'DEPT_NAME'                  ,text:'부서명'            ,type:'string'},
            {name: 'PERSON_NUMB'                ,text:'사원번호'            ,type:'string'},
            {name: 'PERSON_NAME'                ,text:'성명'            ,type:'string'},
            {name: 'JOIN_DATE'                  ,text:'입사일자'            ,type:'string'},
            {name: 'LONG_TOT_DAY'               ,text:'근속일'            ,type:'int'},
            {name: 'PAY_TOTAL_I'                ,text:'급여'            ,type:'int'},
            {name: 'BONUS_SUM'                  ,text:'상여'            ,type:'int'},
            {name: 'PAY_AMT_SUM'                ,text:'계'                       ,type:'int'},
            {name: 'AVG_PAY_3'                  ,text:'최근3개월급여'            ,type:'int'},
            {name: 'BONUS_SUM_3'                ,text:'최근3개월상여'         ,type:'int'},
            {name: 'DAY_3'                      ,text:'일수'                  ,type:'int'},
            {name: 'AVG_DAY'                    ,text:'일평균급여'               ,type:'int'},
            {name: 'AVG_WAGES_I'                ,text:'충당금'                 ,type:'int'},
            {name: 'REMARK'                     ,text:'비고'                  ,type:'string'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('axt180skrMasterStore1',{
            model: 'Axt180skrModel',
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
                       read: 'axt180skrService.selectList'                    
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
            }
        }
    });
    

    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [/*{
                    fieldLabel        : '기준일자',
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
				fieldLabel: '기준일자',
				xtype: 'uniDatefield',
				name: 'ST_DATE',                
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DUTY_YYYYMMDD', newValue);
					}
				}
			  },
	          {
	                fieldLabel: '사업장',
	                name:'DIV_CODE', 
	                xtype: 'uniCombobox',
					colspan: 2,
	                //multiSelect: true, 
	                typeAhead: false,
	                comboType:'BOR120',
	                width: 325,
	                listeners: {
	                    change: function(field, newValue, oldValue, eOpts) {                        
	                    }
	                }
	           },			
		     	Unilite.popup('Employee',{ 
					
					validateBlank: false,
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
						}
					}
				}),
			   Unilite.treePopup('DEPTTREE',{
					fieldLabel: '부서',
					valueFieldName:'DEPT_CODE',
					textFieldName:'DEPT_NAME' ,
					valuesName:'DEPTS' ,
					DBvalueFieldName:'TREE_CODE',
					DBtextFieldName:'TREE_NAME',
					selectChildren:true,
					validateBlank:true,
					autoPopup:true,
					useLike:true,
					listeners: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	panelResult.setValue('DEPT_CODE',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	panelResult.setValue('DEPT_NAME',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelResult.getField('DEPTS') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				})
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('axt180skrGrid1', {
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

        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        store: directMasterStore1,
        columns:  [  
                 { dataIndex: 'DEPT_CODE'               , width: 80},
                 { dataIndex: 'DEPT_NAME'               , width: 80},
                 { dataIndex: 'PERSON_NUMB'               , width: 80},
                 { dataIndex: 'PERSON_NAME'               , width: 80},
                 { dataIndex: 'JOIN_DATE'               , width: 80},
                 { dataIndex: 'LONG_TOT_DAY'               , width: 80},
                 { dataIndex: 'PAY_TOTAL_I'               , width: 80},
                 { dataIndex: 'BONUS_SUM'               , width: 80},
                 { dataIndex: 'PAY_AMT_SUM'               , width: 130},
                 { dataIndex: 'AVG_PAY_3'               , width: 150},
                 { dataIndex: 'BONUS_SUM_3'               , width: 150},
                 { dataIndex: 'DAY_3'               , width: 80},
                 { dataIndex: 'AVG_DAY'               , width: 120},
                 { dataIndex: 'AVG_WAGES_I'               , width: 80},
                 { dataIndex: 'REMARK'               , width: 300}
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
        id  : 'axt180skrApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('ST_DATE', new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0));
            
            var activeSForm = panelResult;
            //activeSForm.onLoadSelectText('PERSON_NUMB');
            
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
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
        onPrintButtonDown: function(printType) {
            var param= panelResult.getValues();
            //param.ACCNT_DIV_NAME = panelSearch.getField('ACCNT_DIV_CODE').getRawValue();
            var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/accnt/axt180rkrPrint.do',
                prgID: 'axt180rkr',
                extParam: param
                });
            win.center();
            win.show();  
        }
    });
};


</script>
