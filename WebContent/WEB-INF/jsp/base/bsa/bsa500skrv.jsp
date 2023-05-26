<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa500skrv"  >
    <t:ExtComboStore comboType="AU" comboCode="B007" /> <!--업무구분 -->
    <t:ExtComboStore comboType="AU" comboCode="B003" /> <!-- 프로그램 사용권한 --> 
    <t:ExtComboStore comboType="AU" comboCode="B006" /> <!-- 파일저장 사용권한 -->      
    <t:ExtComboStore comboType="AU" comboCode="BS04" /> <!-- 권한범위 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('bsa500skrvModel', {
        fields: [{name: 'USER_ID'                ,text:'사용자ID'             ,type:'string'},
                 {name: 'USER_NAME'              ,text:'사용자명'             ,type:'string'},
                 {name: 'LOCATION'               ,text:'모듈'                 ,type:'string'},
                 {name: 'PGM_ID'                 ,text:'프로그램ID'           ,type:'string'},    
                 {name: 'PGM_NAME'               ,text:'프로그램명'           ,type:'string'},
                 {name: 'NUD_FLAG'               ,text:'변경로그'             ,type:'string'},
                 {name: 'REGIST_DB_TIME'         ,text:'변경일'               ,type:'uniDate'},
                 {name: 'REGIST_USER_NAME'       ,text:'변경자'               ,type:'string'}
            ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore = Unilite.createStore('bsa500skrvMasterStore',{
        model: 'bsa500skrvModel',
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,            // 삭제 가능 여부 
            useNavi: false              // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'bsa500skrvService.selectList'                    
            }
        }
        ,loadStoreRecords: function()    {
            //var param= Ext.getCmp('searchForm').getValues();            
            var param= Ext.getCmp('resultForm').getValues();            
            //console.log( param );
            this.load({
                params: param
            });
            
        }
    });

    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */
/*
    var panelSearch = Unilite.createSearchPanel('searchForm', {          
        title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
        defaultType: 'uniSearchSubPanel',
        items: [{     
            title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            items: [{
                fieldLabel: '변경일',
                xtype: 'uniDateRangefield',  
                startFieldName: 'DATE_FR',
                endFieldName: 'DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank: false,
                width: 315,
                //startDate: UniDate.get('startOfMonth'),
                textFieldWidth:200,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DATE_TO',newValue);
                    }
                }                
            },{
                fieldLabel: '프로그램 ID',
                name:'PGM_ID',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('PGM_ID', newValue);
                    }
                }                
            }, 
                Unilite.popup('USER',{
                    textFieldWidth:170,
                    fieldLabel: '사용자 ID',
                    valueFieldName:'USER_ID',
                    textFieldName:'USER_NAME',
                    validateBlank:false, 
                    popupWidth: 710,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelResult.setValue('USER_ID', panelResult.getValue('USER_ID'));
                                panelResult.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type)    {
                            panelResult.setValue('USER_ID', '');
                            panelResult.setValue('USER_NAME', '');
                        }
                    }                    
            }),{
                fieldLabel: '프로그램명' ,
                name:'PGM_NAME',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('PGM_NAME', newValue);
                    }
                }                    
            }]
        }]
    });
*/
       var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5},
        padding:'1 1 1 1',
        border:true,    
            items: [{
                fieldLabel: '변경일',
                xtype: 'uniDateRangefield',  
                startFieldName: 'DATE_FR',
                endFieldName: 'DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank: false,
                width: 315,
                //startDate: UniDate.get('startOfMonth'),
                textFieldWidth:200
/*
                ,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('DATE_TO',newValue);
                    }
                }
*/
            },{
                fieldLabel: '프로그램 ID',
                name:'PGM_ID',
                xtype: 'uniTextfield',
                listeners: {
/*
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('PGM_ID', newValue);
                    }
*/
                }                
            }, 
                Unilite.popup('USER',{
                    textFieldWidth:170,
                    fieldLabel: '사용자 ID',
                    valueFieldName:'USER_ID',
                    textFieldName:'USER_NAME',
                    validateBlank:false, 
                    popupWidth: 710,
                    listeners: {
/*
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('USER_ID', panelResult.getValue('USER_ID'));
                                panelSearch.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type)    {
                            panelSearch.setValue('USER_ID', '');
                            panelSearch.setValue('USER_NAME', '');
                        }
*/
                    }
            }),{
                fieldLabel: '프로그램명' ,
                name:'PGM_NAME',
                xtype: 'uniTextfield',
                listeners: {
/*
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('PGM_NAME', newValue);
                    }
*/
                }                    
            }]
     });        // end of var panelResul        
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('bsa500skrvGrid', {    
        region: 'center',
        layout: 'fit',
        uniOpt:{
            store: directMasterStore
        },
        // grid용 
        store: directMasterStore,
        columns: [{ dataIndex: 'USER_ID'            ,    width: 86  },                 
                  { dataIndex: 'USER_NAME'            ,    width: 120  },     
                  { dataIndex: 'LOCATION'            ,    width: 100 },                
                  { dataIndex: 'PGM_ID'                ,    width: 220 },                 
                  { dataIndex: 'PGM_NAME'            ,    width: 133 },                
                  { dataIndex: 'NUD_FLAG'            ,    width: 100 }, 
                  { dataIndex: 'REGIST_DB_TIME'         ,    width: 100},                
                  { dataIndex: 'REGIST_USER_NAME'     ,     width: 66 }
          ] 
    });
  
    
    Unilite.Main( {
        borderItems:[{
                border: false,
                region: 'center',
                layout: 'border',
                items:[
                    masterGrid, panelResult
                ]
            }     
            //,panelSearch
        ],
        id: 'bsa500skrvApp',
        fnInitBinding: function() {
            UniAppManager.setToolbarButtons('reset', false);
        },
        onQueryButtonDown: function()    {            
            masterGrid.getStore().loadStoreRecords();            
        }
    });

};


</script>
