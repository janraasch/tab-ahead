/*global chrome, window*/
(function ($) {
    'use strict';

    // Put together `typeahead` options.
    var source = function (query, process) {

            chrome.windows.getCurrent({populate: true}, function (current_window) {

                process(current_window.tabs);

            });

        },
        matcher = function (item) {

            var query_regexp = new RegExp(this.query, 'i');

            return item.title.match(query_regexp) || item.url.match(query_regexp);
        },
        sorter = function (items) {

            var query_regexp = new RegExp(this.query, 'i'),
                title_and_url = [],
                title = [],
                url = [],
                tab_indices = [],
                item;

            while (items.length) {
                item = items.shift();

                if (item.title.match(query_regexp)) {
                    if (item.url.match(query_regexp)) {
                        title_and_url.push(item);
                    } else {
                        title.push(item);
                    }
                } else {
                    if (item.url.match(query_regexp)) {
                        url.push(item);
                    }
                }
            }

            return title_and_url.concat(title, url);
        },
        highlighter = function (item) {

            var query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&'),
                highlight = function (string) {
                    return string.replace(new RegExp('(' + query + ')', 'ig'), function ($1, match) {
                        return '<strong class="text-info">' + match + '</strong>';
                    });
                },
                title_highlighted = highlight(item.title),
                url_highlighted = highlight(item.url),
                result = '<div class="title">' + title_highlighted + '</div>' + '<small class="muted url">' + url_highlighted + '</small>';

            return result;
        },
        updater = function (item) {

            chrome.tabs.update(item.id, {
                selected: true
            });

            return item.title;
        };

    //
    // Quick and dirty monkey patch
    // implementing `$.fn.data` instead of
    // using `$.fn.attr('data-value')`
    // to be able to handle `item` objects
    // instead of simple strings.
    //
    $.fn.typeahead.Constructor.prototype.render = function (items) {
        var that = this;

        items = $(items).map(function (i, item) {
            i = $(that.options.item).data('value', item); // Monkey patched.
            i.find('a').html(that.highlighter(item));
            return i[0];
        });

        items.first().addClass('active');
        this.$menu.html(items);
        return this;
    };
    $.fn.typeahead.Constructor.prototype.select = function () {
        var val = this.$menu.find('.active').data('value'); // Monkey patched.

        this.$element.val(this.updater(val)).change();
        return this.hide();
    };

    // Init `typeahead`.
    $('#typeahead').typeahead({
        updater: updater,
        source: source,
        matcher: matcher,
        sorter: sorter,
        highlighter: highlighter,
        items: 10
    });
}(window.jQuery));
