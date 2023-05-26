/******************************************************************************************
 * Multi File Script (lite 버전) @ Cracky
 * 단순 멀티 파일 업로드 형태만 구현 (확장자 검사 , css 적용 , 기본 기능 제외함)
 * 속성 : class = 'jfile' 추가
 *     : target = 'div id' 지정 
 * _delImg : 삭제 이미지 경로 
 * 
 * * * 업로드 파일 temp div에 적용
 * 
 * jQuery('#divId').addTempFile({
 * 		url : '',		// 삭제시 통신 할 ajax url
 *      param : {} ,    // parameter json data
 *      value : '첨부파일명' ,
 *      download : 'download url' (optional)
 * });
 ******************************************************************************************/


var _jFileId = 0;
var _jFileId_max = 5;	/* temp file max*/ 
var _addImg = '<img src="/images/attd.png" width="15" height="15" border="0" />&nbsp;&nbsp;';
var _delImg = '<img src="/images/delp.png" border="0" />';
var _downImg = '<img src="/images/dwn.png" border="0" />';

var _tmpDvId = 0;	/* temp file add*/ 
var _tmpJsnData = {};

//function _delTempJFile(a){var b=_tmpJsnData["joy_dv_"+a+"_k"];confirm("["+b.value+"] 정말로 삭제하시겠습니까?")&&_isNotEmptys(b.url)&&_isNotEmptys(b.param)&&jQuery.ajax({url:b.url,data:b.param,type:"post",dataType:"json",success:function(b){alert("삭제되었습니다."),remJfileDiv(a)}})}function _downloadJfAttach(a){var b=_tmpJsnData["joy_dv_"+a+"_k"];if(_isNotEmptys(b.download)&&_isNotEmptys(b.param)){var c=jQuery('<form name = "_joy_kr_Frm" id = "_joy_kr_Frm" method = "post"></form>');jQuery.each(b.param,function(a,b){jQuery('<input type = "hidden" name = "'+a+'" value = "'+b+'"/>').appendTo(c)}),c.appendTo(document.body),document._joy_kr_Frm.action=b.download,document._joy_kr_Frm.submit(),c.remove()}}function _getFileName(a){return _isNotEmptys(a)?a.replace(/\\/g,"/").replace(/.*\//,""):null}function remJfileDiv(a){_isNotEmptys(a)&&jQuery("#joy_dv_"+a+"_k").remove()}function _isNotEmptys(a){return null!=a&&void 0!=a&&""!=jQuery.trim(a)&&0!=a.length}jQuery(document).ready(function(){jQuery.each($(".jfile"),function(){jQuery(this).bind("change",function(){jQuery(this).attr("id",jQuery(this).attr("name")+_jFileId),jQuery(this).bindEvt()})})}),jQuery.fn.addTempFile=function(a){var b=jQuery(this).attr("id"),c='<span style="cursor:pointer;" onClick="_delTempJFile(\''+_tmpDvId+"')\">&nbsp;&nbsp;"+_delImg+"</span>";_isNotEmptys(a.download)&&(c='<span style="cursor:pointer;" onClick="_delTempJFile(\''+_tmpDvId+"')\">&nbsp;&nbsp;"+_delImg+'</span>&nbsp;[<span style="cursor:pointer;" onClick="_downloadJfAttach(\''+_tmpDvId+"')\">DOWNLOAD</span>]");var d='<div id = "joy_dv_'+_tmpDvId+'_k">-&nbsp;'+a.value+c+"</div>";_tmpJsnData["joy_dv_"+_tmpDvId+"_k"]=a,$(d).appendTo($("#"+b)),_tmpDvId++,_jFileId++},jQuery.fn.bindEvt=function(){var a=jQuery(this),b=a.attr("target"),c=a.val();c.split("\\");c=_getFileName(c);var e=a.attr("id"),f='<div id = "joy_dv_'+e+'_k">-&nbsp;'+c+'<span style="cursor:pointer;" onClick="remJfileDiv(\''+e+"')\">&nbsp;&nbsp;"+_delImg+"</span></div>";$(f).appendTo($("#"+b)),a.hide(),a.appendTo(jQuery("#joy_dv_"+e+"_k")),_jFileId++;var g=a.attr("name")+_jFileId,h=1==_isNotEmptys(a.attr("class"))?a.attr("class"):"",i=$('<input type = "file" id = "'+g+'" name = "'+a.attr("name")+'" target ="'+b+'" class="'+h+'"/>');jQuery(i).prependTo(jQuery("#"+b)),jQuery(i).bind("change",function(){jQuery(this).bindEvt()})};
function _delTempJFile(a) {
    var b = _tmpJsnData["joy_dv_" + a + "_k"];
    confirm("[" + b.value + "] 정말로 삭제하시겠습니까?") && _isNotEmptys(b.url) && _isNotEmptys(b.param) && jQuery.ajax({
        url: b.url,
        data: b.param,
        type: "post",
        dataType: "json",
        success: function(b) {
            alert("삭제되었습니다."), remJfileDiv(a)
        }
    })
}

function _downloadJfAttach(a) {
    var b = _tmpJsnData["joy_dv_" + a + "_k"];
    if (_isNotEmptys(b.download) && _isNotEmptys(b.param)) {
        var c = jQuery('<form name = "_joy_kr_Frm" id = "_joy_kr_Frm" method = "post"></form>');
        jQuery.each(b.param, function(a, b) {
            jQuery('<input type = "hidden" name = "' + a + '" value = "' + b + '"/>').appendTo(c)
        }), c.appendTo(document.body), document._joy_kr_Frm.action = b.download, document._joy_kr_Frm.submit(), c.remove()
    }
}

function _getFileName(a) {
    return _isNotEmptys(a) ? a.replace(/\\/g, "/").replace(/.*\//, "") : null
}

function remJfileDiv(a) {
    _isNotEmptys(a) && jQuery("#joy_dv_" + a + "_k").remove()
}

function _isNotEmptys(a) {
    return null != a && void 0 != a && "" != jQuery.trim(a) && 0 != a.length
}

jQuery(document).ready(function() {
    jQuery.each($(".jfile"), function() {
        jQuery(this).bind("change", function() {
            jQuery(this).attr("id", jQuery(this).attr("name") + _jFileId), jQuery(this).bindEvt()
        })
    })
}), jQuery.fn.addTempFile = function(a) {
_jFileId_max = $('#_jFileId_max').val();
    var b = jQuery(this).attr("id"),
        c = '<span style="cursor:pointer;" onClick="_delTempJFile(\'' + _tmpDvId + "')\">&nbsp;&nbsp;" + _delImg + "</span>";
    _isNotEmptys(a.download) && (c = '<span style="cursor:pointer;" onClick="_delTempJFile(\'' + _tmpDvId + "')\">&nbsp;&nbsp;" + _delImg + '</span>&nbsp;<span style="cursor:pointer;" onClick="_downloadJfAttach(\'' + _tmpDvId + "')\">" + _downImg + "</span>");
    var d = '<div id = "joy_dv_' + _tmpDvId + '_k" class="maqt">' + _addImg + a.value + c + "</div>";
    _tmpJsnData["joy_dv_" + _tmpDvId + "_k"] = a, $(d).appendTo($("#" + b)), _tmpDvId++, _jFileId++
}, jQuery.fn.bindEvt = function() {
_jFileId_max = $('#_jFileId_max').val();
    var a = jQuery(this),
        b = a.attr("target"),
        c = a.val();
    c.split("\\");
    c = _getFileName(c);
    var e = a.attr("id"),
        f = '<div id = "joy_dv_' + e + '_k" class="maqt">' + _addImg + c + '<span style="cursor:pointer;" onClick="remJfileDiv(\'' + e + "')\">&nbsp;&nbsp;" + _delImg + "</span></div>";
    $(f).appendTo($("#" + b)), a.hide(), a.appendTo(jQuery("#joy_dv_" + e + "_k")), _jFileId++;
    var g = a.attr("name") + _jFileId,
        h = 1 == _isNotEmptys(a.attr("class")) ? a.attr("class") : "",
        i = $('<input type = "file" id = "' + g + '" name = "' + a.attr("name") + '" target ="' + b + '" class="' + h + '"/>');
    jQuery(i).prependTo(jQuery("#" + b)), jQuery(i).bind("change", function() {
        jQuery(this).bindEvt()
    })
//console.log("aaaaaaaaa 1["+_jFileId +"]["+_jFileId_max);
	if(_jFileId > _jFileId_max){
		remJfileDiv(e);
		_jFileId--;
	}

};