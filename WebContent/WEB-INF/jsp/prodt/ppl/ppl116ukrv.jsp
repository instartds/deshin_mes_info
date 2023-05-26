<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
    String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
    request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>

<t:appConfig pgmId="ppl116ukrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sbx900ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B018" />
    <t:ExtComboStore comboType="AU" comboCode="B010" />
    <t:ExtComboStore comboType="AU" comboCode="B013" />         <!-- 단위 -->
    <t:ExtComboStore comboType="AU" comboCode="B062" />         <!-- 카렌더타입 -->
    <t:ExtComboStore comboType="AU" comboCode="B011" />         <!-- 휴무구분 -->
    <t:ExtComboStore comboType="BOR120"  pgmId="ppl116ukrv"/>  <!-- 사업장 -->
    <t:ExtComboStore comboType="AU"  comboCode="B020"/>             <!-- 계정구분 -->
    <t:ExtComboStore comboType="AU"  comboCode="B014"/>             <!-- 조달구분 -->
    <t:ExtComboStore comboType="WU" />  <!-- 작업장 -->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
    /* 카렌더정보수정 */
    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'ppl116ukrvService.selectList3',
                create  : 'ppl116ukrvService.insertDetail3',
                update  : 'ppl116ukrvService.updateDetail23',
                //destroy   : 'ppl116ukrvService.deleteDetail2',
                syncAll : 'ppl116ukrvService.saveAll3'
            }
     });


    Unilite.defineModel('ppl116ukrv_3Model', {
        fields: [
                    {name: 'CAL_NO'                 ,text:'기간NO'        ,type : 'string'},
                    {name: 'START_DATE'             ,text:'기간시작일'       ,type : 'uniDate'},
                    {name: 'END_DATE'               ,text:'기간종료일'       ,type : 'uniDate'},
                    {name: 'WORK_DAY'               ,text:'가동일수'        ,type : 'string'}

            ]
    });

    var ppl116ukrv_3Store = Unilite.createStore('ppl116ukrv_3Store',{
            model: 'ppl116ukrv_3Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: false,        // 수정 모드 사용
                deletable:false,        // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
           proxy : directProxy3,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();

                var rv = true;

                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                }else {
                     panelDetail.down('#ppl116ukrv_3Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_Cal_Revise').getValues();
                 this.load({
                    params: param
                 });
             }
        });
    /* 카렌더정보수정 end */

	var prodt_Calender =	 {
    	region : 'center',
		itemId: 'tab_Cal_Revise',
		id: 'tab_Cal_Revise',
		xtype: 'uniDetailFormSimple',
   		layout: 'fit',
		items:[
			{
				xtype:'uxiframe',
				id : 'prodtppl116calendar',
				src: CPATH+"/prodt/ppl116ukrv1.do",
				layout	: 'fit'
			}
		]
	}

     Unilite.Main( {
        borderItems:[
        	prodt_Calender
        ],
        id : 'ppl116ukrvApp',
        fnInitBinding : function() {
           UniAppManager.setToolbarButtons(['query','reset','newData', 'delete', 'deleteAll'],false);
        },
        onQueryButtonDown : function()  {
        
        },
        onResetButtonDown: function() {     // 초기화
           
        },
        onNewDataButtonDown : function()    {
            
        },

        onSaveDataButtonDown: function (config) {
               
        },
        onDeleteDataButtonDown : function() {
            
        },onDeleteAllButtonDown: function() {
        	
        },
        onDetailButtonDown:function() {
            var as = Ext.getCmp('AdvanceSerch');
            if(as.isHidden())   {
                as.show();
            }else {
                as.hide()
            }
        }
    });
};


</script>

