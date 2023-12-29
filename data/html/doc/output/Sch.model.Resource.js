Ext.data.JsonP.Sch_model_Resource({"tagname":"class","name":"Sch.model.Resource","autodetected":{},"files":[{"filename":"Resource.js","href":"Resource3.html#Sch-model-Resource"}],"extends":"Sch.model.Customizable","members":[{"name":"customizableFields","tagname":"cfg","owner":"Sch.model.Customizable","id":"cfg-customizableFields","meta":{}},{"name":"nameField","tagname":"cfg","owner":"Sch.model.Resource","id":"cfg-nameField","meta":{}},{"name":"getEvents","tagname":"method","owner":"Sch.model.Resource","id":"method-getEvents","meta":{}},{"name":"getName","tagname":"method","owner":"Sch.model.Resource","id":"method-getName","meta":{}},{"name":"setName","tagname":"method","owner":"Sch.model.Resource","id":"method-setName","meta":{}}],"alternateClassNames":[],"aliases":{},"id":"class-Sch.model.Resource","short_doc":"This class represent a single Resource in the scheduler chart. ...","component":false,"superclasses":["Ext.data.Model","Sch.model.Customizable"],"subclasses":["Gnt.model.Resource"],"mixedInto":[],"mixins":[],"parentMixins":[],"requires":[],"uses":[],"html":"<div><pre class=\"hierarchy\"><h4>Hierarchy</h4><div class='subclass first-child'>Ext.data.Model<div class='subclass '><a href='#!/api/Sch.model.Customizable' rel='Sch.model.Customizable' class='docClass'>Sch.model.Customizable</a><div class='subclass '><strong>Sch.model.Resource</strong></div></div></div><h4>Subclasses</h4><div class='dependency'><a href='#!/api/Gnt.model.Resource' rel='Gnt.model.Resource' class='docClass'>Gnt.model.Resource</a></div><h4>Files</h4><div class='dependency'><a href='source/Resource3.html#Sch-model-Resource' target='_blank'>Resource.js</a></div></pre><div class='doc-contents'><p>This class represent a single Resource in the scheduler chart. Its a subclass of the <a href=\"#!/api/Sch.model.Customizable\" rel=\"Sch.model.Customizable\" class=\"docClass\">Sch.model.Customizable</a>, which is in turn subclass of Ext.data.Model.\nPlease refer to documentation of those classes to become familar with the base interface of the resource.</p>\n\n<p>A Resource has only 2 mandatory fields - <code>Id</code> and <code>Name</code>. If you want to add more fields with meta data describing your resources then you should subclass this class:</p>\n\n<pre><code>Ext.define('MyProject.model.Resource', {\n    extend      : '<a href=\"#!/api/Sch.model.Resource\" rel=\"Sch.model.Resource\" class=\"docClass\">Sch.model.Resource</a>',\n\n    fields      : [\n        // `Id` and `Name` fields are already provided by the superclass\n        { name: 'Company',          type : 'string' }\n    ],\n\n    getCompany : function () {\n        return this.get('Company');\n    },\n    ...\n});\n</code></pre>\n\n<p>If you want to use other names for the Id and Name fields you can configure them as seen below:</p>\n\n<pre><code>Ext.define('MyProject.model.Resource', {\n    extend      : '<a href=\"#!/api/Sch.model.Resource\" rel=\"Sch.model.Resource\" class=\"docClass\">Sch.model.Resource</a>',\n\n    nameField   : 'UserName',\n    ...\n});\n</code></pre>\n\n<p>Please refer to <a href=\"#!/api/Sch.model.Customizable\" rel=\"Sch.model.Customizable\" class=\"docClass\">Sch.model.Customizable</a> for details.</p>\n</div><div class='members'><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-cfg'>Config options</h3><div class='subsection'><div id='cfg-customizableFields' class='member first-child inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><a href='#!/api/Sch.model.Customizable' rel='Sch.model.Customizable' class='defined-in docClass'>Sch.model.Customizable</a><br/><a href='source/Customizable.html#Sch-model-Customizable-cfg-customizableFields' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.model.Customizable-cfg-customizableFields' class='name expandable'>customizableFields</a> : Array<span class=\"signature\"></span></div><div class='description'><div class='short'><p>The array of customizale fields definitions.</p>\n</div><div class='long'><p>The array of customizale fields definitions.</p>\n</div></div></div><div id='cfg-nameField' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Sch.model.Resource'>Sch.model.Resource</span><br/><a href='source/Resource3.html#Sch-model-Resource-cfg-nameField' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.model.Resource-cfg-nameField' class='name expandable'>nameField</a> : String<span class=\"signature\"></span></div><div class='description'><div class='short'>The name of the field that holds the resource name. ...</div><div class='long'><p>The name of the field that holds the resource name. Defaults to \"Name\".</p>\n<p>Defaults to: <code>'Name'</code></p></div></div></div></div></div><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-method'>Methods</h3><div class='subsection'><div id='method-getEvents' class='member first-child not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Sch.model.Resource'>Sch.model.Resource</span><br/><a href='source/Resource3.html#Sch-model-Resource-method-getEvents' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.model.Resource-method-getEvents' class='name expandable'>getEvents</a>( <span class='pre'>[eventStore]</span> ) : <a href=\"#!/api/Sch.model.Event\" rel=\"Sch.model.Event\" class=\"docClass\">Sch.model.Event</a>[]<span class=\"signature\"></span></div><div class='description'><div class='short'>Returns an array of events, associated with this resource ...</div><div class='long'><p>Returns an array of events, associated with this resource</p>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>eventStore</span> : <a href=\"#!/api/Sch.data.EventStore\" rel=\"Sch.data.EventStore\" class=\"docClass\">Sch.data.EventStore</a> (optional)<div class='sub-desc'><p>The event store to get events for (if a resource is bound to multiple stores)</p>\n</div></li></ul><h3 class='pa'>Returns</h3><ul><li><span class='pre'><a href=\"#!/api/Sch.model.Event\" rel=\"Sch.model.Event\" class=\"docClass\">Sch.model.Event</a>[]</span><div class='sub-desc'>\n</div></li></ul></div></div></div><div id='method-getName' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Sch.model.Resource'>Sch.model.Resource</span><br/><a href='source/Resource3.html#Sch-model-Resource-method-getName' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.model.Resource-method-getName' class='name expandable'>getName</a>( <span class='pre'></span> ) : String<span class=\"signature\"></span></div><div class='description'><div class='short'>Returns the resource name ...</div><div class='long'><p>Returns the resource name</p>\n<h3 class='pa'>Returns</h3><ul><li><span class='pre'>String</span><div class='sub-desc'><p>The name of the resource</p>\n</div></li></ul></div></div></div><div id='method-setName' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='Sch.model.Resource'>Sch.model.Resource</span><br/><a href='source/Resource3.html#Sch-model-Resource-method-setName' target='_blank' class='view-source'>view source</a></div><a href='#!/api/Sch.model.Resource-method-setName' class='name expandable'>setName</a>( <span class='pre'>The</span> )<span class=\"signature\"></span></div><div class='description'><div class='short'>Sets the resource name ...</div><div class='long'><p>Sets the resource name</p>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>The</span> : String<div class='sub-desc'><p>new name of the resource</p>\n</div></li></ul></div></div></div></div></div></div></div>","meta":{}});