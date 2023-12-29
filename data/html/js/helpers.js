getParameterByName = function(name, url)
{
  if (!url)
  {
    url = window.location.href;
  }
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
    results = regex.exec(url);
  if (!results)
  {
    return null;
  }
  if (!results[2])
  {
    return '';
  }
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function rand()
{
  return Math.random() * 1000;
}
/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * Using Math.round() will give you a non-uniform distribution!
 */
function getRandomInt(min, max)
{
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
function randomString()
{
  var text = "";
  var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for(var i = 0; i < 5; i++)
    text += possible.charAt(Math.floor(Math.random() * possible.length));

  return text;
}

/**
 * Compare to objects (a) and (b). If the objects differs, it returns the cause why it doesn't equal.
 *
 * For any function in child-object a the function will be called with the child-object in b as argument.
 * The function should return false, if it doesn't accept the child-object in b, otherwise true.
 *
 * @function equalReturnCause

 * @param a first object
 * @param b second object
 * @param path
 * @return "": a and b is equl, else: the rease why a and b is not equal
 *
 * @example
 *
 *   // (a and b is equal)
 *   a = {foo: function(fooInB) { return fooInB == "bar"; }, pos:{x:10, y:20}};
 *   b = {foo: "bar", pos:{x:10, y:20}};
 *   equalReturnCause(a, b); // return ""
 *
 *   // (a and b is not equal)
 *   a = {pos:[1, 2], foo: function(fooInB) { return fooInB == "hello"; }};
 *   b = {pos:[1, 2], foo: "bar"};
 *   equalReturnCause(a, b); // return "/.foo / function return false"
 *
 */
function equalReturnCause(a, b, path) // return - "": equal, else: why not equal
{
  if (typeof(path) == "undefined")
  {
    path = "/";
  }
  if (path == "")
  {
    path = "/";
  }
  // partly based on https://stackoverflow.com/questions/13142968/deep-comparison-of-objects-arrays
  var ta = typeof(a);
  var tb = typeof(b);

  if (ta == "function" && tb != "function")
  {
    return a(b) ? "" : (path + " / function return false");
  }

  if (Array.isArray(a))
  {
    ta = "array";
  }
  if (Array.isArray(b))
  {
    tb = "array";
  }

  if (ta != tb)
  {
    return path + " / type diff: " + ta + "!=" + tb;
  }

  if (ta == "array")
  {
    if (a.length != b.length)
    {
      return path + " / length diff: " + a.length + "!=" + b.length;
    }
    for(var i = 0; i < a.length; i++)
    {
      var s = equalReturnCause(a[i], b[i], path + "[" + i + "]");
      if (s != "")
      {
        return s;
      }
    }
    return "";
  }

  if (ta == "object")
  {
    var ka = Object.keys(a).sort();
    var kb = Object.keys(b).sort();
    if (ka.length != kb.length)
    {
      return path + " / key length diff: " + ka.length + "!=" + kb.length;
    }
    {
      var kas = ka.join("");
      var kbs = kb.join("");
      if (kas != kbs)
      {
        return path + " / keys diff: '" + kas + "'!='" + kbs + "'";
      }
    }
    for(var i = 0; i < ka.length; i++)
    {
      var s = equalReturnCause(a[ka[i]], b[ka[i]], path + "." + ka[i]);
      if (s != "")
      {
        return s;
      }
    }
    return "";
  }

  var jas = JSON.stringify(a);
  var jbs = JSON.stringify(b);
  return jas == jbs ? "" : (path + " / json: '" + jas + "'!='" + jbs + "'");
}

function isEqual(a, b)
{
  return equalReturnCause(a, b, "") == "";
}

// ///
/**
 * Do a deep object clone. Call cb on every element in object obj.
 *
 * @function deepCloneObject
 * @param obj the object which should be cloned
 * @param {function=} cb optional callback-function, which is called on every element in obj as function-argument. deepCloneObject stops calling rekursiv, if the callback function return != undefined (= returnig nothing).
 *
 * @example
 *   var obj2 = deepCloneObject({
 *                date: new Date(), i:123, {
 *                   foo:"bar", hello:"world"}
 *                }, function(ent) {
 *     if ( ent instanceof Date ) return ent;
 *     // it's safe to return nothing here
 *   });
 */
function deepCloneObject(obj, cb)
{
  if (typeof(cb) != "undefined")
  {
    var ret = cb(obj);

    if (typeof(ret) != "undefined")
    {
      return ret;
    }
  }

  if (typeof(obj) == "object")
  {
    if (obj instanceof Date)
    {
      return new Date(obj);
    }

    var ret = {};

    if (Array.isArray(obj))
    {
      ret = [];
    }

    for(var key in obj)
    {
      ret[key] = deepCloneObject(obj[key], cb)
    }
    return ret;
  }

  return obj;
}

function isPositivNumber(value)
{
  return value >= 1;
}

function isSomeValue(value)
{
  return (value + "") != "";
}

function isUndefined(value)
{
  return typeof(value) == "undefined";
}

function isValidIsoDateStr(strDate)
{
  var d = Date.parse(strDate);

  return (typeof(d) != "undefined");
}

function verifyPayloadSize(payloadSize)
{
  var sizeMB = 10;
  if (payloadSize > 10 * 1024 * 1024)
  {
    throw new Error("Message payload to large (> " + sizeMB + " MB)");
  }
}

(function($)
{
  $.getStylesheet = function(href)
  {
    var $d = $.Deferred();
    var $link = $('<link/>', {
      rel: 'stylesheet',
      type: 'text/css',
      href: href
    }).appendTo('head');
    $d.resolve($link);
    return $d.promise();
  };
})(jQuery);

Object.extend = function(destination, source)
{
  for(var property in source)
  {
    if (source.hasOwnProperty(property))
    {
      destination[property] = source[property];
    }
  }
  return destination;
};

Array.prototype.push16 = function(num)
{
  this.push((num >> 8) & 0xFF,
    (num     ) & 0xFF  );
};
Array.prototype.push32 = function(num)
{
  this.push((num >> 24) & 0xFF,
    (num >> 16) & 0xFF,
    (num >>  8) & 0xFF,
    (num      ) & 0xFF  );
};