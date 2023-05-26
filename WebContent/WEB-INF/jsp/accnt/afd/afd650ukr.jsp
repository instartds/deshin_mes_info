<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd650ukr"  >
    <t:ExtComboStore comboType="BOR120"   />            <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    

<script type="text/javascript" >

function appMain() {
    
    var panelSearch = Unilite.createForm('searchForm', {        
        disabled :false
    ,    flex:1        
    ,    layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
    ,    items: [
        Unilite.popup('DEBT_NO',{
                fieldLabel: '차입금',
                allowBlank: false,
                valueFieldName:'DEBT_NO_CODE',
                textFieldName:'DEBT_NO_NAME',
                validateBlank:false,
                autoPopup:true
        })
        ,{
            fieldLabel: '사업장',
            name:'ACCNT_DIV_CODE', 
            xtype: 'uniCombobox',
            value:UserInfo.divCode,
            comboType:'BOR120',
            colspan:2,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('ACCNT_DIV_CODE', newValue);
                }
            }
        },{
            layout: {type:'uniTable', column:2},
            xtype: 'container',
            margin: '0 0 5 60',
            items: [{
                    xtype: 'button',
                    text: '실행',
                    width: 100,
//                    margin: '0 0 5 60',
                    handler: function(btn) {
                        if(confirm('차입금 상환계획을 생성하시겠습니까?')) {
                            doBatch();        
                        }
                    }
                },{
                    xtype: 'button',
                    text: '취소',
                    width: 100,
//                    margin: '0 0 5 100',
                    handler: function(btn) {
                        if(confirm('차입금 상환계획을 취소하시겠습니까?')) {
                            donBatch();        
                        }
                    }
                }
            ]}
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
                   }
            } else {
                  this.unmask();
            }
            return r;
        }
    });
    
    function doBatch() {
        var detailform = panelSearch.getForm();
           if (detailform.isValid()) {
                var param= Ext.getCmp('searchForm').getValues();
           
                param.S_USER_ID = "${loginVO.userID}";
                console.log(param);
                Ext.Ajax.on("beforerequest", function(){
                Ext.getBody().mask('로딩중...', 'loading')                                    
                }, 
                Ext.getBody());
                Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
                Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
                Ext.Ajax.request({
                url     : CPATH+'/human/doBatchHbs910ukr.do', //수정
                params: param,
                success: function(response){
                data = Ext.decode(response.responseText);
                console.log(data);
                
                alert('작업이 완료되었습니다.');
                
                }
                });

            }else{
                var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
                                  return !field.validate();
                              });

                if (invalid.length > 0) {
                    r = false;
                    var labelText = ''

                    if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
                    } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
                    }

                    // Ext.Msg.alert(타이틀, 표시문구); 
                    Ext.Msg.alert('확인', labelText + '필수입력값입니다.');
                    // validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
                    invalid.items[0].focus();
                }
            }
         
    }
    
    function donBatch() {
        var detailform = panelSearch.getForm();
           if (detailform.isValid()) {
                var param= Ext.getCmp('searchForm').getValues();
           
                param.S_USER_ID = "${loginVO.userID}";
                console.log(param);
                Ext.Ajax.on("beforerequest", function(){
                Ext.getBody().mask('로딩중...', 'loading')                                    
                }, 
                Ext.getBody());
                Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
                Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
                Ext.Ajax.request({
                url     : CPATH+'/human/doBatchHbs910ukr.do', //수정
                params: param,
                success: function(response){
                data = Ext.decode(response.responseText);
                console.log(data);
                
                alert('작업이 완료되었습니다.');
                
                }
                });

            }else{
                var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
                                  return !field.validate();
                              });

                if (invalid.length > 0) {
                    r = false;
                    var labelText = ''

                    if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
                    } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
                    }

                    // Ext.Msg.alert(타이틀, 표시문구); 
                    Ext.Msg.alert('확인', labelText + '필수입력값입니다.');
                    // validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
                    invalid.items[0].focus();
                }
            }
         
    }
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
  
    Unilite.Main( {
        items:[panelSearch],
        id  : 'afd650ukrApp',        
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons(['reset', 'query'], false); 
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
        }
    
    
    });

};


</script>
