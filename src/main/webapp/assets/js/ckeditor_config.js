/*
 Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function(config)
{
    // Define changes to default configuration here. For example:
    // config.language = 'fr';
    // config.uiColor = '#AADC6E';

    config.toolbar = 'CUSTOM';

    config.toolbar_CUSTOM =
    [
        ['Source'],
        ['Cut','Copy','Paste','PasteText'],
        //'PasteFromWord'
        ['Bold','Italic','Underline'],
        //['Undo','Redo'],
        ['NumberedList','BulletedList'],
        //['Subscript','Superscript'],
        //['Outdent','Indent','Blockquote'],
        ['Link','Unlink'],
        //['Scayt','SpecialChar','Maximize'],
        ['About']
    ];
    config.toolbar_simple =
    [
        ['Source'],
        //['Cut','Copy','Paste','PasteText'],
        //'PasteFromWord'
        ['Bold','Italic','Underline'],
        //['Undo','Redo'],
        ['NumberedList','BulletedList'],
        //['Subscript','Superscript'],
        //['Outdent','Indent','Blockquote'],
        //['Link','Unlink'],
        //['Scayt','SpecialChar','Maximize'],
        ['About']
    ];
};
