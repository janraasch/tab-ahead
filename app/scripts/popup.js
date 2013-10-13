(function() {
  window.tabahead = function($, fuzzy, chrome, setTimeout) {
    var all_colons, fuzzy_options, highlighter, matcher, sorter, source, string_separator;
    string_separator = ':::::';
    all_colons = /:/g;
    fuzzy_options = {
      pre: '<strong class="text-info">',
      post: '</strong>',
      extract: function(el) {
        return "" + el.title + string_separator + el.url;
      }
    };
    source = function(query, process) {
      return chrome.windows.getCurrent({
        populate: true
      }, function(current_window) {
        var results;
        results = fuzzy.filter(query.replace(all_colons, ''), current_window.tabs, fuzzy_options);
        return process(results);
      });
    };
    matcher = function() {
      return true;
    };
    sorter = function(items) {
      return items;
    };
    highlighter = function(item) {
      var matches, title_highlighted, url_highlighted;
      matches = item.string.split(string_separator);
      title_highlighted = matches[0], url_highlighted = matches[1];
      return "<div class=\"title\">" + title_highlighted + "</div><small class=\"muted url\">" + url_highlighted + "</small>";
    };
    $.fn.typeahead.Constructor.prototype.render = function(items) {
      var _this = this;
      items = ($(items)).map(function(i, item) {
        i = ($(_this.options.item)).data('value', item);
        (i.find('a')).html(_this.highlighter(item));
        return i[0];
      });
      items.first().addClass('active');
      this.$menu.html(items);
      return this;
    };
    $.fn.typeahead.Constructor.prototype.select = function() {
      var item;
      item = (this.$menu.find('.active')).data('value');
      setTimeout(function() {
        return chrome.tabs.update(item.original.id, {
          active: true
        });
      }, 1);
    };
    ($('#typeahead')).typeahead({
      source: source,
      matcher: matcher,
      sorter: sorter,
      highlighter: highlighter,
      items: 10
    });
    return ($('form')).on('submit', function() {
      ($('#typeahead')).val('');
      return false;
    });
  };

  if (window.__karma__ == null) {
    window.tabahead(window.jQuery, window.fuzzy, window.chrome, window.setTimeout);
  }

}).call(this);
