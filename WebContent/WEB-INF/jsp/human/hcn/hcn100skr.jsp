<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hcn100skr"  >
    <t:ExtComboStore comboType="AU" comboCode="H199" /> <!-- 상담군 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
    <t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직급 -->
    <t:ExtComboStore comboType="AU" comboCode="H200" /> <!-- 상담유형 -->
    
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var checkCnlnGrp = '';

if('${checkCnlnGrp}' == '03'){//관리자
    checkCnlnGrp = '02';    
}else if('${checkCnlnGrp}' == '07'){//부서장
    checkCnlnGrp = '01';    
}
function appMain() {
	
	Unilite.defineModel('hcn100skrModel', {
	   fields:[
            {name: 'COMP_CODE'        ,text: '법인코드'      ,type: 'string',allowBlank:false},
            {name: 'CNLN_DATE'        ,text: '상담일'        ,type: 'uniDate',allowBlank:false},
            {name: 'CNLN_SEQ'         ,text: '상담차수'      ,type: 'int'},
            {name: 'CNLN_GRP'        ,text: '상담군'        ,type: 'string' ,comboType: 'AU' ,comboCode: 'H199',allowBlank:false},
            {name: 'DEPT_CODE'        ,text: '부서코드'      ,type: 'string',allowBlank:false},
            {name: 'DEPT_NAME'        ,text: '부서'         ,type: 'string'},
            
            {name: 'ABIL_NAME'        ,text: '직급명'         ,type: 'string'},
            {name: 'PERSON_NUMB1'     ,text: '사번'         ,type: 'string',allowBlank:false},
            {name: 'NAME'             ,text: '성명'         ,type: 'string'},
//            {name: 'ABIL_CODE'        ,text: '직급'         ,type: 'string' ,comboType: 'AU' ,comboCode: 'H006'},
//            {name: 'ABIL_NAME'        ,text: '직급명'         ,type: 'string'},
            
            
            
            
            
//            {name: 'POST_CODE_CS'         ,text: '직위'              ,type: 'string' ,comboType: 'AU' ,comboCode: 'H005'},
            {name: 'POST_NAME_CS'         ,text: '상담자직위'             ,type: 'string' },
            {name: 'NAME_CS'         ,text: '상담자성명'             ,type: 'string' },
            {name: 'CNLN_TTL'          ,text: '제목'              ,type: 'string'}
          
            
        ]
	});		
	  
			
	var directMasterStore = Unilite.createStore('hcn100skrdirectMasterStore',{
		model: 'hcn100skrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hcn100skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('panelSearch').getValues();
			this.load({
				params : param
			});
		}
	});
	
	var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '기간',
            xtype: 'uniDateRangefield',
            startFieldName: 'CNLN_DATE_FR',
            endFieldName: 'CNLN_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank: false
        },{
            xtype: 'uniCombobox',
            fieldLabel: '상담군',
            name: 'CNLN_GRP',
            comboType: 'AU',
            comboCode: 'H199',
            allowBlank: false,
            readOnly:true
        },
        Unilite.popup('DEPT', {
            fieldLabel: '부서',
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            listeners: {
                applyextparam: function(popup) {
                    if(checkCnlnGrp == '01'){
                        popup.setExtParam({'DEPT_CODE' : UserInfo.deptCode})
                    }
                }
            }
        }),
        Unilite.popup('Employee', {
            fieldLabel: '상담자', 
            valueFieldName: 'PERSON_NUMB',
            textFieldName: 'NAME',
            listeners: {
                applyextparam: function(popup) {
                    if(checkCnlnGrp == '01'){
                        popup.setExtParam({'DEPT_CODE_01' : Ext.isEmpty(panelSearch.getValue('DEPT_CODE')) ? UserInfo.deptCode : panelSearch.getValue('DEPT_CODE')})
                    }else if(checkCnlnGrp == '02'){
                    	popup.setExtParam({'DEPT_CODE_01' : panelSearch.getValue('DEPT_CODE')})
                    }
                }
            }
        })
        ]
    });
    var masterGrid = Unilite.createGrid('hcn100skrGrid', {
    	features: [{
			id: 'masterGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false//, enableGroupingMenu:false
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: false
		}],
        region : 'center',
		store: directMasterStore,
        selModel	: 'rowmodel',
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
//    		useGroupSummary		: true,
    		useSqlTotal			: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			},
			state: {
				useState: false,			
				useStateList: false		
			}
        },
        columns:[
            
            { dataIndex: 'COMP_CODE'              ,width:100,hidden:true},
            { dataIndex: 'CNLN_DATE'              ,width:100},
            { dataIndex: 'CNLN_SEQ'               ,width:80,align:'center'},
            { dataIndex: 'CNLN_GRP'               ,width:80,hidden:true},
            { dataIndex: 'DEPT_CODE'              ,width:100,align:'center'},
            { dataIndex: 'DEPT_NAME'              ,width:200},
            { dataIndex: 'ABIL_NAME'              ,width:100,align:'center'},
            { dataIndex: 'PERSON_NUMB1'           ,width:100,align:'center'},
            { dataIndex: 'NAME'                   ,width:100,align:'center'},
            
            
            { dataIndex: 'POST_NAME_CS'           ,width:100,align:'center'},
            { dataIndex: 'NAME_CS'                ,width:100,align:'center'},
            { dataIndex: 'CNLN_TTL'               ,width:100,hidden:true}
            
        ]
    });   
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelSearch,masterGrid
			]
		}], 
		id : 'hcn100skrApp',
		fnInitBinding : function() {
			
            UniAppManager.app.fnInitInputFields();
		},
		onQueryButtonDown : function()	{		
			if(!panelSearch.getInvalidMessage()) return;   //필수체크		
				directMasterStore.loadStoreRecords();
			
		},
		
		fnInitInputFields: function(){
			
            panelSearch.setValue('CNLN_YEAR',new Date().getFullYear());
            
            panelSearch.setValue('CNLN_GRP',checkCnlnGrp);
            
         
        }
	});
};


</script>
