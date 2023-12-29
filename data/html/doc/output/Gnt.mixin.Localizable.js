Ext.data.JsonP.Gnt_mixin_Localizable({"tagname":"class","name":"Gnt.mixin.Localizable","autodetected":{"aliases":true,"alternateClassNames":true,"extends":true,"mixins":true,"requires":true,"uses":true,"members":true,"code_type":true},"files":[{"filename":"Localizable.js","href":"Localizable.html#Gnt-mixin-Localizable"}],"aliases":{},"alternateClassNames":[],"extends":"Sch.mixin.Localizable","mixins":[],"requires":["Gnt.locale.En"],"uses":[],"members":[{"name":"l10n","tagname":"cfg","owner":"Sch.mixin.Localizable","id":"cfg-l10n","meta":{}},{"name":"activeLocaleId","tagname":"property","owner":"Sch.mixin.Localizable","id":"property-activeLocaleId","meta":{"private":true}},{"name":"legacyMode","tagname":"property","owner":"Sch.mixin.Localizable","id":"property-legacyMode","meta":{"private":true}},{"name":"L","tagname":"method","owner":"Sch.mixin.Localizable","id":"method-L","meta":{}},{"name":"applyLocale","tagname":"method","owner":"Sch.mixin.Localizable","id":"method-applyLocale","meta":{"private":true}},{"name":"isLocaleApplied","tagname":"method","owner":"Sch.mixin.Localizable","id":"method-isLocaleApplied","meta":{"private":true}},{"name":"localize","tagname":"method","owner":"Sch.mixin.Localizable","id":"method-localize","meta":{}}],"code_type":"ext_define","id":"class-Gnt.mixin.Localizable","component":false,"superclasses":["Ext.Base","Sch.mixin.Localizable"],"subclasses":[],"mixedInto":["Gnt.column.AddNew","Gnt.column.BaselineEndDate","Gnt.column.BaselineStartDate","Gnt.column.Calendar","Gnt.column.ConstraintDate","Gnt.column.ConstraintType","Gnt.column.Duration","Gnt.column.EarlyEndDate","Gnt.column.EarlyStartDate","Gnt.column.EndDate","Gnt.column.LateEndDate","Gnt.column.LateStartDate","Gnt.column.Milestone","Gnt.column.Name","Gnt.column.Note","Gnt.column.PercentDone","Gnt.column.Predecessor","Gnt.column.ResourceAssignment","Gnt.column.Rollup","Gnt.column.SchedulingMode","Gnt.column.Sequence","Gnt.column.Slack","Gnt.column.StartDate","Gnt.column.Successor","Gnt.column.WBS","Gnt.feature.DependencyDragDrop","Gnt.field.Assignment","Gnt.field.Calendar","Gnt.field.ConstraintType","Gnt.field.Dependency","Gnt.field.Duration","Gnt.field.EndDate","Gnt.field.Milestone","Gnt.field.Percent","Gnt.plugin.DependencyEditor","Gnt.plugin.TaskContextMenu","Gnt.plugin.TaskEditor","Gnt.util.DependencyParser","Gnt.widget.AssignmentEditGrid","Gnt.widget.Calendar","Gnt.widget.ConstraintResolutionForm","Gnt.widget.ConstraintResolutionWindow","Gnt.widget.DependencyGrid","Gnt.widget.calendar.Calendar","Gnt.widget.calendar.CalendarManager","Gnt.widget.calendar.CalendarManagerWindow","Gnt.widget.calendar.CalendarWindow","Gnt.widget.taskeditor.TaskEditor","Gnt.widget.taskeditor.TaskForm"],"parentMixins":[],"html":"<div><pre class=\"hierarchy\"><h4>Hierarchy</h4><div class='subclass first-child'>Ext.Base<div class='subclass '><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='docClass'>Sch.mixin.Localizable</a><div class='subclass '><strong>Gnt.mixin.Localizable</strong></div></div></div><h4>Requires</h4><div class='dependency'>Gnt.locale.En</div><h4>Mixed into</h4><div class='dependency'><a href='#!/api/Gnt.column.AddNew' rel='Gnt.column.AddNew' class='docClass'>Gnt.column.AddNew</a></div><div class='dependency'><a href='#!/api/Gnt.column.BaselineEndDate' rel='Gnt.column.BaselineEndDate' class='docClass'>Gnt.column.BaselineEndDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.BaselineStartDate' rel='Gnt.column.BaselineStartDate' class='docClass'>Gnt.column.BaselineStartDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.Calendar' rel='Gnt.column.Calendar' class='docClass'>Gnt.column.Calendar</a></div><div class='dependency'><a href='#!/api/Gnt.column.ConstraintDate' rel='Gnt.column.ConstraintDate' class='docClass'>Gnt.column.ConstraintDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.ConstraintType' rel='Gnt.column.ConstraintType' class='docClass'>Gnt.column.ConstraintType</a></div><div class='dependency'><a href='#!/api/Gnt.column.Duration' rel='Gnt.column.Duration' class='docClass'>Gnt.column.Duration</a></div><div class='dependency'><a href='#!/api/Gnt.column.EarlyEndDate' rel='Gnt.column.EarlyEndDate' class='docClass'>Gnt.column.EarlyEndDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.EarlyStartDate' rel='Gnt.column.EarlyStartDate' class='docClass'>Gnt.column.EarlyStartDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.EndDate' rel='Gnt.column.EndDate' class='docClass'>Gnt.column.EndDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.LateEndDate' rel='Gnt.column.LateEndDate' class='docClass'>Gnt.column.LateEndDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.LateStartDate' rel='Gnt.column.LateStartDate' class='docClass'>Gnt.column.LateStartDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.Milestone' rel='Gnt.column.Milestone' class='docClass'>Gnt.column.Milestone</a></div><div class='dependency'><a href='#!/api/Gnt.column.Name' rel='Gnt.column.Name' class='docClass'>Gnt.column.Name</a></div><div class='dependency'><a href='#!/api/Gnt.column.Note' rel='Gnt.column.Note' class='docClass'>Gnt.column.Note</a></div><div class='dependency'><a href='#!/api/Gnt.column.PercentDone' rel='Gnt.column.PercentDone' class='docClass'>Gnt.column.PercentDone</a></div><div class='dependency'><a href='#!/api/Gnt.column.Predecessor' rel='Gnt.column.Predecessor' class='docClass'>Gnt.column.Predecessor</a></div><div class='dependency'><a href='#!/api/Gnt.column.ResourceAssignment' rel='Gnt.column.ResourceAssignment' class='docClass'>Gnt.column.ResourceAssignment</a></div><div class='dependency'><a href='#!/api/Gnt.column.Rollup' rel='Gnt.column.Rollup' class='docClass'>Gnt.column.Rollup</a></div><div class='dependency'><a href='#!/api/Gnt.column.SchedulingMode' rel='Gnt.column.SchedulingMode' class='docClass'>Gnt.column.SchedulingMode</a></div><div class='dependency'><a href='#!/api/Gnt.column.Sequence' rel='Gnt.column.Sequence' class='docClass'>Gnt.column.Sequence</a></div><div class='dependency'><a href='#!/api/Gnt.column.Slack' rel='Gnt.column.Slack' class='docClass'>Gnt.column.Slack</a></div><div class='dependency'><a href='#!/api/Gnt.column.StartDate' rel='Gnt.column.StartDate' class='docClass'>Gnt.column.StartDate</a></div><div class='dependency'><a href='#!/api/Gnt.column.Successor' rel='Gnt.column.Successor' class='docClass'>Gnt.column.Successor</a></div><div class='dependency'><a href='#!/api/Gnt.column.WBS' rel='Gnt.column.WBS' class='docClass'>Gnt.column.WBS</a></div><div class='dependency'><a href='#!/api/Gnt.feature.DependencyDragDrop' rel='Gnt.feature.DependencyDragDrop' class='docClass'>Gnt.feature.DependencyDragDrop</a></div><div class='dependency'><a href='#!/api/Gnt.field.Assignment' rel='Gnt.field.Assignment' class='docClass'>Gnt.field.Assignment</a></div><div class='dependency'><a href='#!/api/Gnt.field.Calendar' rel='Gnt.field.Calendar' class='docClass'>Gnt.field.Calendar</a></div><div class='dependency'><a href='#!/api/Gnt.field.ConstraintType' rel='Gnt.field.ConstraintType' class='docClass'>Gnt.field.ConstraintType</a></div><div class='dependency'><a href='#!/api/Gnt.field.Dependency' rel='Gnt.field.Dependency' class='docClass'>Gnt.field.Dependency</a></div><div class='dependency'><a href='#!/api/Gnt.field.Duration' rel='Gnt.field.Duration' class='docClass'>Gnt.field.Duration</a></div><div class='dependency'><a href='#!/api/Gnt.field.EndDate' rel='Gnt.field.EndDate' class='docClass'>Gnt.field.EndDate</a></div><div class='dependency'><a href='#!/api/Gnt.field.Milestone' rel='Gnt.field.Milestone' class='docClass'>Gnt.field.Milestone</a></div><div class='dependency'><a href='#!/api/Gnt.field.Percent' rel='Gnt.field.Percent' class='docClass'>Gnt.field.Percent</a></div><div class='dependency'><a href='#!/api/Gnt.plugin.DependencyEditor' rel='Gnt.plugin.DependencyEditor' class='docClass'>Gnt.plugin.DependencyEditor</a></div><div class='dependency'><a href='#!/api/Gnt.plugin.TaskContextMenu' rel='Gnt.plugin.TaskContextMenu' class='docClass'>Gnt.plugin.TaskContextMenu</a></div><div class='dependency'><a href='#!/api/Gnt.plugin.TaskEditor' rel='Gnt.plugin.TaskEditor' class='docClass'>Gnt.plugin.TaskEditor</a></div><div class='dependency'><a href='#!/api/Gnt.util.DependencyParser' rel='Gnt.util.DependencyParser' class='docClass'>Gnt.util.DependencyParser</a></div><div class='dependency'><a href='#!/api/Gnt.widget.AssignmentEditGrid' rel='Gnt.widget.AssignmentEditGrid' class='docClass'>Gnt.widget.AssignmentEditGrid</a></div><div class='dependency'><a href='#!/api/Gnt.widget.Calendar' rel='Gnt.widget.Calendar' class='docClass'>Gnt.widget.Calendar</a></div><div class='dependency'><a href='#!/api/Gnt.widget.ConstraintResolutionForm' rel='Gnt.widget.ConstraintResolutionForm' class='docClass'>Gnt.widget.ConstraintResolutionForm</a></div><div class='dependency'><a href='#!/api/Gnt.widget.ConstraintResolutionWindow' rel='Gnt.widget.ConstraintResolutionWindow' class='docClass'>Gnt.widget.ConstraintResolutionWindow</a></div><div class='dependency'><a href='#!/api/Gnt.widget.DependencyGrid' rel='Gnt.widget.DependencyGrid' class='docClass'>Gnt.widget.DependencyGrid</a></div><div class='dependency'><a href='#!/api/Gnt.widget.calendar.Calendar' rel='Gnt.widget.calendar.Calendar' class='docClass'>Gnt.widget.calendar.Calendar</a></div><div class='dependency'><a href='#!/api/Gnt.widget.calendar.CalendarManager' rel='Gnt.widget.calendar.CalendarManager' class='docClass'>Gnt.widget.calendar.CalendarManager</a></div><div class='dependency'><a href='#!/api/Gnt.widget.calendar.CalendarManagerWindow' rel='Gnt.widget.calendar.CalendarManagerWindow' class='docClass'>Gnt.widget.calendar.CalendarManagerWindow</a></div><div class='dependency'><a href='#!/api/Gnt.widget.calendar.CalendarWindow' rel='Gnt.widget.calendar.CalendarWindow' class='docClass'>Gnt.widget.calendar.CalendarWindow</a></div><div class='dependency'><a href='#!/api/Gnt.widget.taskeditor.TaskEditor' rel='Gnt.widget.taskeditor.TaskEditor' class='docClass'>Gnt.widget.taskeditor.TaskEditor</a></div><div class='dependency'><a href='#!/api/Gnt.widget.taskeditor.TaskForm' rel='Gnt.widget.taskeditor.TaskForm' class='docClass'>Gnt.widget.taskeditor.TaskForm</a></div><h4>Files</h4><div class='dependency'><a href='source/Localizable.html#Gnt-mixin-Localizable' target='_blank'>Localizable.js</a></div></pre><div class='doc-contents'><p>A mixin providing localization functionality to the consuming class.</p>\n</div><div class='members'><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-cfg'>Config options</h3><div class='subsection'><div id='cfg-l10n' class='member first-child inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-cfg-l10n' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-cfg-l10n' class='name expandable'>l10n</a> : Object<span class=\"signature\"></span></div><div class='description'><div class='short'><p>Container of locales for the class.</p>\n</div><div class='long'><p>Container of locales for the class.</p>\n</div></div></div></div></div><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-property'>Properties</h3><div class='subsection'><div id='property-activeLocaleId' class='member first-child inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-property-activeLocaleId' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-property-activeLocaleId' class='name expandable'>activeLocaleId</a> : String<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n<p>Defaults to: <code>''</code></p></div></div></div><div id='property-legacyMode' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-property-legacyMode' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-property-legacyMode' class='name expandable'>legacyMode</a> : Boolean<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n<p>Defaults to: <code>true</code></p></div></div></div></div></div><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-method'>Methods</h3><div class='subsection'><div id='method-L' class='member first-child inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-method-L' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-method-L' class='name expandable'>L</a>( <span class='pre'>id, [legacyHolderProp], [skipLocalizedCheck]</span> ) : String<span class=\"signature\"></span></div><div class='description'><div class='short'>This is shorthand reference to localize. ...</div><div class='long'><p>This is shorthand reference to <a href=\"#!/api/Sch.mixin.Localizable-method-localize\" rel=\"Sch.mixin.Localizable-method-localize\" class=\"docClass\">localize</a>. Retrieves translation of a phrase.</p>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>id</span> : String<div class='sub-desc'><p>Identifier of phrase.</p>\n</div></li><li><span class='pre'>legacyHolderProp</span> : String (optional)<div class='sub-desc'><p>Legacy class property name containing locales.</p>\n<p>Defaults to: <code>this.legacyHolderProp</code></p></div></li><li><span class='pre'>skipLocalizedCheck</span> : Boolean (optional)<div class='sub-desc'><p>Do not localize class if it's not localized yet.</p>\n<p>Defaults to: <code>false</code></p></div></li></ul><h3 class='pa'>Returns</h3><ul><li><span class='pre'>String</span><div class='sub-desc'><p>Translation of specified phrase.</p>\n</div></li></ul></div></div></div><div id='method-applyLocale' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-method-applyLocale' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-method-applyLocale' class='name expandable'>applyLocale</a>( <span class='pre'></span> )<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n</div></div></div><div id='method-isLocaleApplied' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-method-isLocaleApplied' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-method-isLocaleApplied' class='name expandable'>isLocaleApplied</a>( <span class='pre'></span> )<span class=\"signature\"><span class='private' >private</span></span></div><div class='description'><div class='short'> ...</div><div class='long'>\n</div></div></div><div id='method-localize' class='member  inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.mixin.Localizable' rel='Sch.mixin.Localizable' class='defined-in docClass'>Sch.mixin.Localizable</a><br/><a href='source/Localizable2.html#Sch-mixin-Localizable-method-localize' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.mixin.Localizable-method-localize' class='name expandable'>localize</a>( <span class='pre'>id, [legacyHolderProp], [skipLocalizedCheck]</span> ) : String<span class=\"signature\"></span></div><div class='description'><div class='short'>Retrieves translation of a phrase. ...</div><div class='long'><p>Retrieves translation of a phrase. There is a shorthand <a href=\"#!/api/Sch.mixin.Localizable-method-L\" rel=\"Sch.mixin.Localizable-method-L\" class=\"docClass\">L</a> for this method.</p>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>id</span> : String<div class='sub-desc'><p>Identifier of phrase.</p>\n</div></li><li><span class='pre'>legacyHolderProp</span> : String (optional)<div class='sub-desc'><p>Legacy class property name containing locales.</p>\n<p>Defaults to: <code>this.legacyHolderProp</code></p></div></li><li><span class='pre'>skipLocalizedCheck</span> : Boolean (optional)<div class='sub-desc'><p>Do not localize class if it's not localized yet.</p>\n<p>Defaults to: <code>false</code></p></div></li></ul><h3 class='pa'>Returns</h3><ul><li><span class='pre'>String</span><div class='sub-desc'><p>Translation of specified phrase.</p>\n</div></li></ul></div></div></div></div></div></div></div>","meta":{}});