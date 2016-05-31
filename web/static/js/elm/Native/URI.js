var _wfleming$fourohfourfinder$Native_URI = function() {
  // Useful hack from https://gist.github.com/jlong/2428561
  function parse(uri_str) {
    var parser = document.createElement('a');
    parser.href = uri_str;

    return {
      orig: uri_str,
      protocol: parser.protocol,
      hostname: parser.hostname,
      hostPort: parseInt(parser.port, 10),
      path: parser.pathname,
      query: parser.search,
      hash: parser.hash
    };
  }

  return {
    parse: parse
  };
}();
