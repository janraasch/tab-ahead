/*global describe, it, expect, $, window, jasmine, beforeEach, spyOn, waitsFor, runs*/
describe('Tab Ahead', function () {
    'use strict';

    describe('expects the chrome popup environment', function () {
        it('expects to find a form.navbar-search', function () {
            expect($('body')).toContain('form.navbar-search');
        });

        it('expects to find an input#typeahead', function () {
            expect($('form.navbar-search')).toContain('input#typeahead');
        });
    });

    describe('Typing some text into the input field', function () {
        var getCurrentWindowSpy;

        beforeEach(function () {
            getCurrentWindowSpy = spyOn(window.chrome.windows, 'getCurrent').andCallThrough();

            $('#typeahead')
                .val('jan')
                .trigger('keyup');
        });

        it('should ask chrome API for current window', function () {
            expect(getCurrentWindowSpy).toHaveBeenCalled();
        });

        it('should show suggestions', function () {
            waitsFor(function () {
                return $('ul').length > 0;
            });
            runs(function () {
                expect($('ul')).toHaveLength(1);

                // Add `\n` due to `new line at the end of the fixture.
                expect($('ul').html() + '\n').toBe(window.__html__['test/fixtures/suggestions.html']);
            });
        });

    });

    describe('Selecting a suggestion', function () {
        var updateSpy, item, li;

        beforeEach(function () {
            updateSpy = spyOn(window.chrome.tabs, 'update');

            $('#typeahead')
                .val('jan')
                .trigger('keyup');

            waitsFor(function () {
                return $('ul').length > 0;
            });
        });

        describe('by hitting return', function () {
            beforeEach(function () {
                li = $('li:nth-child(1)');
                item = li.data('value');

                jasmine.Clock.useMock();

                $('input')
                    .trigger('keyup')
                    .trigger($.Event('keyup', {keyCode: 13}));

                jasmine.Clock.tick(200);
            });

            it('should update the tab', function () {
                expect(updateSpy).toHaveBeenCalled();
                expect(updateSpy).toHaveBeenCalledWith(item.original.id, {
                    active: true
                });
            });
        });

        describe('by click', function () {
            beforeEach(function () {
                li = $('li:nth-child(2)');
                item = li.data('value');

                jasmine.Clock.useMock();

                $(li).trigger('mouseenter');
                $(li).trigger('click');

                jasmine.Clock.tick(200);
            });

            it('should update the tab', function () {
                expect(updateSpy).toHaveBeenCalled();
                expect(updateSpy).toHaveBeenCalledWith(item.original.id, {
                    active: true
                });
            });
        });

    });

});
