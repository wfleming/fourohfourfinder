//import Maybe //

var _wfleming$fourohfourfinder$Native_URI = function() {
  // Useful hack from https://gist.github.com/jlong/2428561
  function parse(uri_str) {
    var parser = document.createElement('a');
    parser.href = uri_str;

    var query, hash;

    if (parser.search && parser.search.length > 0) {
      query = _elm_lang$core$Maybe$Just(parser.search);
    } else {
      query = _elm_lang$core$Maybe$Nothing;
    }

    if (parser.hash && parser.hash.length > 0) {
      hash = _elm_lang$core$Maybe$Just(parser.hash);
    } else {
      hash = _elm_lang$core$Maybe$Nothing;
    }

    return {
      orig: uri_str,
      protocol: parser.protocol,
      host: parser.host,
      hostname: parser.hostname,
      path: parser.pathname,
      query: query,
      hash: hash
    };
  }

  return {
    parse: parse
  };
}();
