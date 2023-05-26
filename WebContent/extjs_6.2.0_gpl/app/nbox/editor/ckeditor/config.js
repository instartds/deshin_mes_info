/**
 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.language = 'ko';	
	config.font_defaultLabel = '굴림';
	config.font_names = '굴림/Gulim;돋움/Dotum;바탕/Batang;궁서/Gungsuh;Arial/Arial;Comic Sans MS/Comic Sans MS;Courier New/Courier New;Georgia/Georgia;Lucida Sans Unicode/Lucida Sans Unicode;Tahoma/Tahoma;Times New Roman/Times New Roman;Trebuchet MS/Trebuchet MS;Verdana/Verdana';
	config.fontSize_defaultLabel = '12px';
	config.fontSize_sizes = '8/8px;9/9px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;22/22px;24/24px;26/26px;28/28px;36/36px;48/48px;';
	config.extraPlugins = 'showborders,tableresize,tabletoolstoolbar,quicktable';
	config.enterMode = CKEDITOR.ENTER_BR;
	config.ShowTableBorders = true;
	 
	config.toolbar = [['Font','FontSize'],
	                  ['Bold','Italic','Underline','Strike','Subscript','Superscript','TextColor','BGColor','Blockquote','RemoveFormat','NumberedList','BulletedList'],
	                  ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	                  ['Link','Unlink','Find','Replace','SelectAll','-','Image','Table','Smiley','SpecialChar'],
	                  '/',
	                  ['Source','Preview','Templates','Print'],
	                  ['Cut','Copy','Paste','PasteText','PasteFromWord','Undo','Redo','Maximize'],
					  ['tableinsert','tabledelete','tableproperties','tablerowinsertbefore','tablerowinsertafter','tablerowdelete','tablecolumninsertbefore','tablecolumninsertafter','tablecolumndelete','tablecellinsertafter','tablecelldelete','tablecellproperties','tablecellsplithorizontal','tablecellsplitvertical']];

};



