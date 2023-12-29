Ext.data.JsonP.Gnt_column_StartDate({"tagname":"class","name":"Gnt.column.StartDate","autodetected":{"aliases":true,"alternateClassNames":true,"mixins":true,"requires":true,"uses":true,"members":true,"code_type":true},"files":[{"filename":"StartDate.js","href":"StartDate2.html#Gnt-column-StartDate"}],"extends":"Ext.grid.column.Date","aliases":{"widget":["startdatecolumn"]},"alternateClassNames":[],"mixins":["Gnt.mixin.Localizable"],"requires":["Gnt.field.StartDate"],"uses":[],"members":[{"name":"adjustMilestones","tagname":"cfg","owner":"Gnt.column.StartDate","id":"cfg-adjustMilestones","meta":{}},{"name":"align","tagname":"cfg","owner":"Gnt.column.StartDate","id":"cfg-align","meta":{}},{"name":"editorFormat","tagname":"cfg","owner":"Gnt.column.StartDate","id":"cfg-editorFormat","meta":{}},{"name":"instantUpdate","tagname":"cfg","owner":"Gnt.column.StartDate","id":"cfg-instantUpdate","meta":{}},{"name":"keepDuration","tagname":"cfg","owner":"Gnt.column.StartDate","id":"cfg-keepDuration","meta":{}},{"name":"l10n","tagname":"cfg","owner":"Gnt.column.StartDate","id":"cfg-l10n","meta":{}},{"name":"text","tagname":"cfg","owner":"Gnt.column.StartDate","id":"cfg-text","meta":{"deprecated":{"text":"<p>Please use <a href=\"#!/api/Gnt.column.StartDate-cfg-l10n\" rel=\"Gnt.column.StartDate-cfg-l10n\" class=\"docClass\">l10n</a> instead.</p>\n"}}},{"name":"width","tagname":"cfg","owner":"Gnt.column.StartDate","id":"cfg-width","meta":{}},{"name":"activeLocaleId","tagname":"property","owner":"Sch.mixin.Localizable","id":"property-activeLocaleId","meta":{"private":true}},{"name":"field","tagname":"property","owner":"Gnt.column.StartDate","id":"property-field","meta":{"private":true}},{"name":"fieldProperty","tagname":"property","owner":"Gnt.column.StartDate","id":"property-fieldProperty","meta":{"private":true}},{"name":"legacyMode","tagname":"property","owner":"Sch.mixin.Localizable","id":"property-legacyMode","meta":{"private":true}},{"name":"constructor","tagname":"method","owner":"Gnt.column.StartDate","id":"method-constructor","meta":{}},{"name":"L","tagname":"method","owner":"Sch.mixin.Localizable","id":"method-L","meta":{}},{"name":"afterRender","tagname":"method","owner":"Gnt.column.StartDate","id":"method-afterRender","meta":{"private":true}},{"name":"applyLocale","tagname":"method","owner":"Sch.mixin.Localizable","id":"method-applyLocale","meta":{"private":true}},{"name":"isLocaleApplied","tagname":"method","owner":"Sch.mixin.Localizable","id":"method-isLocaleApplied","meta":{"private":true}},{"name":"localize","tagname":"method","owner":"Sch.mixin.Localizable","id":"method-localize","meta":{}},{"name":"rendererFunc","tagname":"method","owner":"Gnt.column.StartDate","id":"method-rendererFunc","meta":{"private":true}}],"code_type":"ext_define","id":"class-Gnt.column.StartDate","short_doc":"A Column representing a StartDate field of a task. ...","component":false,"superclasses":["Ext.grid.column.Date"],"subclasses":[],"mixedInto":[],"parentMixins":[],"html":"<div><pre class=\"hierarchy\"><h4>Hierarchy</h4><div class='subclass first-child'>Ext.grid.column.Date<div class='subclass '><strong>Gnt.column.StartDate</strong></div></div><h4>Mixins</h4><div class='dependency'><a href='#!/api/Gnt.mixin.Localizable' rel='Gnt.mixin.Localizable' class='docClass'>Gnt.mixin.Localizable</a></div><h4>Requires</h4><div class='dependency'><a href='#!/api/Gnt.field.StartDate' rel='Gnt.field.StartDate' class='docClass'>Gnt.field.StartDate</a></div><h4>Files</h4><div class='dependency'><a href='source/StartDate2.html#Gnt-column-StartDate' target='_blank'>StartDate.js</a></div></pre><div class='doc-contents'><p>A Column representing a <code>StartDate</code> field of a task. The column is editable, however to enable the editing you will need to add a\n<code><a href=\"#!/api/Sch.plugin.TreeCellEditing\" rel=\"Sch.plugin.TreeCellEditing\" class=\"docClass\">Sch.plugin.TreeCellEditing</a></code> plugin to your gantt panel. The overall setup will look like this:</p>\n\n<pre><code>var gantt = Ext.create('<a href=\"#!/api/Gnt.panel.Gantt\" rel=\"Gnt.panel.Gantt\" class=\"docClass\">Gnt.panel.Gantt</a>', {\n    height      : 600,\n    width       : 1000,\n\n    columns         : [\n        ...\n        {\n            xtype       : 'startdatecolumn',\n            width       : 80\n        }\n        ...\n    ],\n\n    plugins             : [\n        Ext.create('<a href=\"#!/api/Sch.plugin.TreeCellEditing\" rel=\"Sch.plugin.TreeCellEditing\" class=\"docClass\">Sch.plugin.TreeCellEditing</a>', {\n            clicksToEdit: 1\n        })\n    ],\n    ...\n})\n</code></pre>\n\n<p>Note, that this column will provide only a day-level editor (using a subclassed Ext JS DateField). If you need a more precise editing (ie also specify\nthe start hour/minute) you will need to provide your own field which should subclass <a href=\"#!/api/Gnt.field.StartDate\" rel=\"Gnt.field.StartDate\" class=\"docClass\">Gnt.field.StartDate</a>. See <a href=\"http://bryntum.com/forum/viewtopic.php?f=16&amp;t=2277&amp;start=10#p13964\">forumthread</a> for more information.</p>\n\n<p>Also note, that this class inherits from <a href=\"http://docs.sencha.com/ext-js/4-1/#!/api/Ext.grid.column.Date\">Ext.grid.column.Date</a> and supports its configuration options, notably the \"format\" option.</p>\n</div><div class='members'><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-cfg'>Config options</h3><div class='subsection'><div id='cfg-adjustMilestones' class='member first-child not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-cfg-adjustMilestones' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-cfg-adjustMilestones' class='name expandable'>adjustMilestones</a> : Boolean<span class=\"signature\"></span></div><div class='description'><div class='short'>When set to true, the start/end dates of the milestones will be adjusted -1 day during rendering and editing. ...</div><div class='long'><p>When set to <code>true</code>, the start/end dates of the milestones will be adjusted -1 day <em>during rendering and editing</em>. The task model will still hold unmodified date.</p>\n<p>Defaults to: <code>true</code></p></div></div></div><div id='cfg-align' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-cfg-align' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-cfg-align' class='name expandable'>align</a> : String<span class=\"signature\"></span></div><div class='description'><div class='short'>An align of the text in the column, default value is 'left' ...</div><div class='long'><p>An align of the text in the column, default value is 'left'</p>\n<p>Defaults to: <code>'left'</code></p></div></div></div><div id='cfg-editorFormat' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-cfg-editorFormat' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-cfg-editorFormat' class='name expandable'>editorFormat</a> : String<span class=\"signature\"></span></div><div class='description'><div class='short'>A date format to be used when editing the value of the column. ...</div><div class='long'><p>A date format to be used when editing the value of the column. By default it is the same as <code>format</code> configuration\noption of the column itself.</p>\n</div></div></div><div id='cfg-instantUpdate' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-cfg-instantUpdate' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-cfg-instantUpdate' class='name expandable'>instantUpdate</a> : Boolean<span class=\"signature\"></span></div><div class='description'><div class='short'>Set to true to instantly apply any changes in the field to the task. ...</div><div class='long'><p>Set to <code>true</code> to instantly apply any changes in the field to the task.\nThis option is just translated to the <a href=\"#!/api/Gnt.field.mixin.TaskField-cfg-instantUpdate\" rel=\"Gnt.field.mixin.TaskField-cfg-instantUpdate\" class=\"docClass\">Gnt.field.mixin.TaskField.instantUpdate</a> config option.</p>\n<p>Defaults to: <code>false</code></p></div></div></div><div id='cfg-keepDuration' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-cfg-keepDuration' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-cfg-keepDuration' class='name expandable'>keepDuration</a> : Boolean<span class=\"signature\"></span></div><div class='description'><div class='short'>Pass true to keep the duration of the task (\"move\" the task), false to change the duration (\"resize\" the task). ...</div><div class='long'><p>Pass <code>true</code> to keep the duration of the task (\"move\" the task), <code>false</code> to change the duration (\"resize\" the task).</p>\n<p>Defaults to: <code>true</code></p></div></div></div><div id='cfg-l10n' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-cfg-l10n' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-cfg-l10n' class='name expandable'>l10n</a> : Object<span class=\"signature\"></span></div><div class='description'><div class='short'>A object, purposed for the class localization. ...</div><div class='long'><p>A object, purposed for the class localization. Contains the following keys/values:</p>\n\n<pre><code>        - text : 'Start'\n</code></pre>\n<p>Overrides: <a href=\"#!/api/Sch.mixin.Localizable-cfg-l10n\" rel=\"Sch.mixin.Localizable-cfg-l10n\" class=\"docClass\">Sch.mixin.Localizable.l10n</a></p></div></div></div><div id='cfg-text' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-cfg-text' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-cfg-text' class='name expandable'>text</a> : string<span class=\"signature\"><span class='deprecated' >deprecated</span></span></div><div class='description'><div class='short'>The text to show in the column header, defaults to Start ...</div><div class='long'><p>The text to show in the column header, defaults to <code>Start</code></p>\n        <div class='rounded-box deprecated-box deprecated-tag-box'>\n        <p>This cfg has been <strong>deprected</strong> </p>\n        <p>Please use <a href=\"#!/api/Gnt.column.StartDate-cfg-l10n\" rel=\"Gnt.column.StartDate-cfg-l10n\" class=\"docClass\">l10n</a> instead.</p>\n\n        </div>\n</div></div></div><div id='cfg-width' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-cfg-width' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-cfg-width' class='name expandable'>width</a> : Number<span class=\"signature\"></span></div><div class='description'><div class='short'>A width of the column, default value is 100 ...</div><div class='long'><p>A width of the column, default value is 100</p>\n<p>Defaults to: <code>100</code></p></div></div></div></div></div><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-property'>Properties</h3><div class='subsection'><div id='property-activeLocaleId' class='member first-child inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-property-activeLocaleId' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-property-activeLocaleId' class='name expandable'>activeLocaleId</a> : String<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n<p>Defaults to: <code>''</code></p></div></div></div><div id='property-field' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-property-field' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-property-field' class='name expandable'>field</a> : Object<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'>\n</div><div class='long'>\n</div></div></div><div id='property-fieldProperty' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-property-fieldProperty' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-property-fieldProperty' class='name expandable'>fieldProperty</a> : String<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n<p>Defaults to: <code>'startDateField'</code></p></div></div></div><div id='property-legacyMode' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-property-legacyMode' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-property-legacyMode' class='name expandable'>legacyMode</a> : Boolean<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n<p>Defaults to: <code>true</code></p></div></div></div></div></div><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-method'>Methods</h3><div class='subsection'><div id='method-constructor' class='member first-child not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-method-constructor' target='_blank' class='view-source'>view source</a></div><strong class='new-keyword'>new</strong><a href='#!/api/Gnt.column.StartDate-method-constructor' class='name expandable'>Gnt.column.StartDate</a>( <span class='pre'>config</span> ) : <a href=\"#!/api/Gnt.column.StartDate\" rel=\"Gnt.column.StartDate\" class=\"docClass\">Gnt.column.StartDate</a><span class=\"signature\"></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>config</span> : Object<div class='sub-desc'></div></li></ul><h3 class='pa'>Returns</h3><ul><li><span class='pre'><a href=\"#!/api/Gnt.column.StartDate\" rel=\"Gnt.column.StartDate\" class=\"docClass\">Gnt.column.StartDate</a></span><div class='sub-desc'>\n</div></li></ul></div></div></div><div id='method-L' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-method-L' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-method-L' class='name expandable'>L</a>( <span class='pre'>id, [legacyHolderProp], [skipLocalizedCheck]</span> ) : String<span class=\"signature\"></span></div><div class='description'><div class='short'>This is shorthand reference to localize. ...</div><div class='long'><p>This is shorthand reference to <a href=\"#!/api/Sch.mixin.Localizable-method-localize\" rel=\"Sch.mixin.Localizable-method-localize\" class=\"docClass\">localize</a>. Retrieves translation of a phrase.</p>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>id</span> : String<div class='sub-desc'><p>Identifier of phrase.</p>\n</div></li><li><span class='pre'>legacyHolderProp</span> : String (optional)<div class='sub-desc'><p>Legacy class property name containing locales.</p>\n<p>Defaults to: <code>this.legacyHolderProp</code></p></div></li><li><span class='pre'>skipLocalizedCheck</span> : Boolean (optional)<div class='sub-desc'><p>Do not localize class if it's not localized yet.</p>\n<p>Defaults to: <code>false</code></p></div></li></ul><h3 class='pa'>Returns</h3><ul><li><span class='pre'>String</span><div class='sub-desc'><p>Translation of specified phrase.</p>\n</div></li></ul></div></div></div><div id='method-afterRender' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-method-afterRender' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-method-afterRender' class='name expandable'>afterRender</a>( <span class='pre'></span> )<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n</div></div></div><div id='method-applyLocale' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-method-applyLocale' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-method-applyLocale' class='name expandable'>applyLocale</a>( <span class='pre'></span> )<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n</div></div></div><div id='method-isLocaleApplied' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-method-isLocaleApplied' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-method-isLocaleApplied' class='name expandable'>isLocaleApplied</a>( <span class='pre'></span> )<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n</div></div></div><div id='method-localize' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-method-localize' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-method-localize' class='name expandable'>localize</a>( <span class='pre'>id, [legacyHolderProp], [skipLocalizedCheck]</span> ) : String<span class=\"signature\"></span></div><div class='description'><div class='short'>Retrieves translation of a phrase. ...</div><div class='long'><p>Retrieves translation of a phrase. There is a shorthand <a href=\"#!/api/Sch.mixin.Localizable-method-L\" rel=\"Sch.mixin.Localizable-method-L\" class=\"docClass\">L</a> for this method.</p>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>id</span> : String<div class='sub-desc'><p>Identifier of phrase.</p>\n</div></li><li><span class='pre'>legacyHolderProp</span> : String (optional)<div class='sub-desc'><p>Legacy class property name containing locales.</p>\n<p>Defaults to: <code>this.legacyHolderProp</code></p></div></li><li><span class='pre'>skipLocalizedCheck</span> : Boolean (optional)<div class='sub-desc'><p>Do not localize class if it's not localized yet.</p>\n<p>Defaults to: <code>false</code></p></div></li></ul><h3 class='pa'>Returns</h3><ul><li><span class='pre'>String</span><div class='sub-desc'><p>Translation of specified phrase.</p>\n</div></li></ul></div></div></div><div id='method-rendererFunc' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Gnt.column.StartDate'>Gnt.column.StartDate</span><br/><a href='source/StartDate2.html#Gnt-column-StartDate-method-rendererFunc' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Gnt.column.StartDate-method-rendererFunc' class='name expandable'>rendererFunc</a>( <span class='pre'>value, meta, task</span> )<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>value</span> : Object<div class='sub-desc'></div></li><li><span class='pre'>meta</span> : Object<div class='sub-desc'></div></li><li><span class='pre'>task</span> : Object<div class='sub-desc'></div></li></ul></div></div></div></div></div></div></div>","meta":{}});