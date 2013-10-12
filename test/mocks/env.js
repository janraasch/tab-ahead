/*global $, window, document*/
(function () {
    'use strict';

    // Mock html.
    $(document.body).append(window.__html__['test/fixtures/form.html']);

    // Mock `chrome` object and its relevant methods.
    window.chrome = {
        windows: {
            getCurrent: function (options, callback) {
                $.getJSON('base/test/fixtures/window.json', function (data) {
                    callback(data);
                });
            }
        },
        tabs: {
            update: $.noop
        }
    };
}());
