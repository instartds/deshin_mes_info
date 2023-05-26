<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zdd100ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zdd100ukrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="I802" /> <!--장비타입-->
    <t:ExtComboStore comboType="AU" comboCode="I801" /> <!--진행(검교정)-->
    <t:ExtComboStore comboType="AU" comboCode="WZ03" /> <!--주기(월)-->
    <t:ExtComboStore comboType="AU" comboCode="WB09" /> <!--금형구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB10" /> <!--위치상태-->
    <t:ExtComboStore comboType="AU" comboCode="WB11" /> <!--수금구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="WB04" /> <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WB12" /> <!--의뢰구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB13" /> <!--보수코드-->
    <t:ExtComboStore comboType="AU" comboCode="I801" /> <!--상태구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB15" /> <!--단계--> 
    <t:ExtComboStore comboType="AU" comboCode="WB16" /> <!--문서종류-->
   <t:ExtComboStore comboType="AU" comboCode="I800" /> <!-- 장비구분 -->
   <t:ExtComboStore comboType="AU" comboCode="I806" /> <!-- 검교정방법 -->
	<t:ExtComboStore items="${COMBO_EQUIP_TYPE}" storeId="comboEquipTypeStore" />
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}'
};

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zdd100ukrv_kdService.selectList',
            update: 's_zdd100ukrv_kdService.updateList',
            syncAll: 's_zdd100ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zdd100ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'          ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'           ,type: 'string'},
            {name: 'EQU_CODE_TYPE'		    , text: '장비구분'		   ,type: 'string'},
            {name: 'EQU_CODE'             ,text:'설비코드'           ,type: 'string'},
            {name: 'EQU_NAME'             ,text:'설비명'             ,type: 'string'},
            {name: 'EQU_SPEC'             ,text:'규격'              ,type: 'string'},
            {name: 'MODEL_CODE'              ,text:'대표모델'        ,type: 'string'},
            {name: 'EQU_TYPE'              ,text:'장비타입'          ,type: 'string', comboType: 'AU', comboCode: 'I802'},
            {name: 'EQU_DEPT'              ,text:'관리부서코드'       ,type: 'string'},
            {name: 'TREE_NAME'              ,text:'관리부서'         ,type: 'string'},
            {name: 'INS_PLACE'              ,text:'설치장소'         ,type: 'string'},
            {name: 'CAL_CYCLE_MM'          ,text:'주기(월)'         ,type: 'string', comboType: 'AU', comboCode: 'WZ03'},
            {name: 'LAST_DATE'        		,text:'검교정일자'       ,type: 'uniDate'},
            {name: 'NEXT_DATE'     			,text:'차기검교정일'      ,type: 'uniDate'},
            {name: 'CAL_WAY'              ,text:'검교정방법'         ,type: 'string', comboType: 'AU', comboCode: 'I806'},	//테이블추가필
            {name: 'CAL_COMPANY'           ,text:'검교정업체'     	  ,type: 'string'},	//테이블추가필
            {name: 'EQU_GRADE'            ,text:'상태구분'          ,type: 'string', comboType: 'AU', comboCode: 'I801'},
            {name: 'CUSTOM_NAME'            ,text:'제작처명'        ,type: 'string'},
            {name: 'PRODT_DATE'            ,text:'제작일'          ,type: 'uniDate'},
            {name: 'INSTOCK_DATE'            ,text:'설치일자'      ,type: 'uniDate'},
            {name: 'BUY_COMP_NAME'            ,text:'매입처명'        ,type: 'string'},
            {name: 'BUY_AMT'            	,text:'매입액'        ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'REMARK'            		,text:'비고'          ,type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zdd100ukrv_kdMasterStore1',{
        model: 's_zdd100ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
//            var isErr = false;
//            Ext.each(list, function(record, index) {
//                if(Ext.isEmpty(record.get('CALI_STATUS')) || record.get('CALI_STATUS') == 'D') {
//                	if(Ext.isEmpty(record.get('CALI_CYCLE_MM_TEMP'))) {
//                		alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '차기검교정일: 필수 입력값 입니다.');
//                        isErr = true;
//                        return false;
//                	}
//                }
//            });
//            if(isErr) return false;

            
            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        UniAppManager.setToolbarButtons('save', false); 
                        directMasterStore.loadStoreRecords();
                    } 
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1 
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        id: 'RESULT_SEARCH',
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },{
                fieldLabel: '장비구분',
                name:'EQU_CODE_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'I800',
                child: 'EQUIP_TYPE',
                allowBlank:false
            },{
                fieldLabel: '장비타입',
                name:'EQUIP_TYPE',  
                xtype: 'uniCombobox',
                store:Ext.data.StoreManager.lookup('comboEquipTypeStore')
            },
            Unilite.popup('EQUIP_CODE',{ 
                    fieldLabel: '설비',
                    validateBlank: false,
                    valueFieldName:'EQUIP_CODE',
                    textFieldName:'EQUIP_NAME'
            }),{ 
                fieldLabel: '차기검교정일',
                xtype: 'uniDateRangefield',
                startFieldName: 'CALI_CYCLE_MM_TEMP_FR',
                endFieldName: 'CALI_CYCLE_MM_TEMP_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },{
                fieldLabel: '관리부서',
                name:'EQU_DEPT',  
                xtype: 'uniTextfield'
            },{
                fieldLabel: '상태구분',
                name:'EQU_GRADE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'I801'
            }
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
    
    var masterGrid = Unilite.createGrid('s_zdd100ukrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [ 
            { dataIndex: 'COMP_CODE'                              ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                               ,           width: 80, hidden: true},
            { dataIndex: 'EQU_CODE_TYPE'	                      ,           width: 100, hidden: true},
            { dataIndex: 'EQU_CODE'                               ,           width: 80},
            { dataIndex: 'EQU_NAME'                               ,           width: 150},
            { dataIndex: 'EQU_SPEC'                               ,           width: 150},
            { dataIndex: 'MODEL_CODE'                             ,           width: 100},
            { dataIndex: 'EQU_TYPE'                               ,           width: 100},
            { dataIndex: 'EQU_DEPT'                               ,           width: 100},
            { dataIndex: 'TREE_NAME'                              ,           width: 150},
            { dataIndex: 'INS_PLACE'                              ,           width: 100},
            { dataIndex: 'CAL_CYCLE_MM'                           ,           width: 100},
            { dataIndex: 'LAST_DATE'                              ,           width: 100},
            { dataIndex: 'NEXT_DATE'                              ,           width: 100},
            { dataIndex: 'CAL_WAY'                                ,           width: 100},
            { dataIndex: 'CAL_COMPANY'                            ,           width: 100},
            { dataIndex: 'EQU_GRADE'                              ,           width: 100},
            { dataIndex: 'CUSTOM_NAME'                            ,           width: 100},
            { dataIndex: 'PRODT_DATE'                             ,           width: 100},
            { dataIndex: 'INSTOCK_DATE'                           ,           width: 100},
            { dataIndex: 'BUY_COMP_NAME'                           ,           width: 100},
            { dataIndex: 'BUY_AMT'                                ,           width: 100},
            { dataIndex: 'REMARK'                                 ,           width: 200}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['INS_PLACE','CAL_CYCLE_MM', 'LAST_DATE', 'NEXT_DATE', 'CAL_WAY', 'CAL_COMPANY', 'EQU_GRADE', 'REMARK'])) { 
                    return true;
                } else {
                    return false;
                }
        		
            }
        }
    });
    
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    masterGrid, panelResult
                ]
            }
        ],
        id  : 's_zdd100ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll', 'newData'],false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData'], false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault();
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();  
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll', 'newData'],false);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('EQU_CODE_TYPE', '2');
            
            panelResult.setValue('CALI_AVAIL_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('CALI_AVAIL_DATE_TO', UniDate.get('today'));
        }                         
    });
    
    Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "CAL_CYCLE_MM" :
					record.set('NEXT_DATE',UniDate.add(record.get('LAST_DATE'), {months: + masterGrid.getColumn("CAL_CYCLE_MM").field.rawValue}));
				break;
				case "LAST_DATE" :
					record.set('NEXT_DATE',UniDate.add(newValue, {months: + masterGrid.getColumn("CAL_CYCLE_MM").field.rawValue}));
				break;
			}
			return rv;
		}
	});
}
</script>