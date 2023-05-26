<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat920rkr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hat920rkr"/>             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="HX10" />                    <!-- cnffurrnqns --> 
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
    Unilite.defineModel('Hat920rkrModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'            ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'            ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서'               ,type:'string' },
            {name: 'DEPT_CNT'                 ,text:'출근자'              ,type:'int' },
            {name: 'REMARK'                   ,text:'비고'               ,type:'string' }
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hat920rkrMasterStore1',{
            model: 'Hat920rkrModel',
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
                       read: 'hat920rkrServiceImpl.selectList'                    
                }
            }
            ,loadStoreRecords : function()    {
                var param= Ext.getCmp('panelResultForm').getValues();            
                console.log( param );
                this.load({
                    params : param
                });
                
            }
    });
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [{
                fieldLabel: '근태일',
                xtype: 'uniDatefield',
                name: 'DUTY_YYYYMMDD',               
                allowBlank: false,
                value: new Date(),
                listeners: {
                      change: function(field, newValue, oldValue, eOpts) {                                  
                      }
                }
           },
           {
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                typeAhead: false,
                comboType:'BOR120',
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            {
                fieldLabel: '출력구분',
                name: 'SUPP_TYPE', 
                xtype: 'uniCombobox',
                allowBlank: false,
                comboType: 'AU',
                comboCode: 'HX10',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },          
            Unilite.popup('Employee',{ 
                
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
//                          dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            })]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hat920rkrGrid1', {
        region: 'center',
        layout: 'fit',
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false  }), 
        uniOpt:{    
            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
            useRowNumberer: true,       //첫번째 컬럼 순번 사용 여부
            useLiveSearch: true,        //찾기 버튼 사용 여부
            useRowContext: false,            
            onLoadSelectFirst    : true,
            filter: {                    //필터 사용 여부
                useFilter: true,
                autoCreate: true
            }
        },
        tbar:[
              '->',
          {
              xtype:'button',
              text:'출력',
              handler:function()  {
                  printType = 'slip'; /* 전표  */
                  //if(masterGrid.getSelectedRecords().length > 0 ){
                      UniAppManager.app.onPrintButtonDown(printType);
                  //} else {
                  //    alert("선택된 자료가 없습니다.");
                  //}
              }
          }
        ],
        store: directMasterStore1,
        columns:  [  { dataIndex: 'DEPT_CODE'              , width: 77},                     
                     { dataIndex: 'DEPT_NAME'              , width: 160},
                     { dataIndex: 'DEPT_CNT'               , width: 88},
                     { dataIndex: 'REMARK'                 , width: 200}
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
        id  : 'hat920rkrApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('SUPP_TYPE', '1');
            
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
        },
        onQueryButtonDown : function()    {
            if(!this.isValidSearchForm()){
                return false;
            }
            masterGrid.getStore().loadStoreRecords();
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
                url: CPATH+'/hat/hat920rkrPrint.do',
                prgID: 'hat920rkr',
                extParam: param
                });
            win.center();
            win.show();  
        }
    });
};


</script>
