/**
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * (C) 2008 Syronex / J.M. Rosengard
 * http://www.syronex.com/software/jquery-color-picker
 *
 * - Check mark is either black or white, depending on the darkness
 *   of the color selected.
 * - Fixed a bug in the original plugin that led to problems when there is
 *   more than one colorPicker in a document.
 *
 * This is based on:
 *
 * jQuery colorSelect plugin 0.9
 * http://plugins.jquery.com/project/colorPickerAgain
 * Copyright (c) 2008 Otaku RzO (Renzo Galo Castro Jurado).
 * (Original author URL & domain name no longer available.)
 *
 */

(function($) {
    $.fn.colorPicker = function($$options) {

        var eventTypes = gon.event_types,
            colors = [],
            texts = [],
            ids = [];

        for (var et in eventTypes) {
            if (eventTypes.hasOwnProperty(et)) {
                texts.push(eventTypes[et].name);
                colors.push(eventTypes[et].color);
                ids.push(eventTypes[et].id);
            }
        }

        // Defaults
        var $defaults = {
            color: colors,
            text: texts,
            ids: ids,
            columns: 0,
            click: function($color) {}
        };

        var $settings = $.extend({}, $defaults, $$options);

        // Iterate and reformat each matched element
        return this.each(function() {
            var $this = $(this);
            // build element specific options
            var o = $.meta ? $.extend({}, $settings, $this.data()) : $settings;
            var $$oldIndex = typeof(o.defaultColor) == 'number' ? o.defaultColor : -1;

            var _html = "";
            for (i = 0; i < o.color.length; i++) {
                _html += '<div class="color_block">';
                _html += '<div style="background-color:' + o.color[i] + ';"></div>';
                _html += '<p>' + o.text[i] + '</p>';
                _html += '</div>';
                if ($$oldIndex == -1 && o.defaultColor == o.color[i]) $$oldIndex = i;
            }

            $this.html('<div class="jColorSelect">' + _html + '</div>');
            var $color = $this.children('.jColorSelect').children('.color_block');
            // Set container width
            var w = ($color.width() + 2 + 2) * (o.columns > 0 ? o.columns : o.color.length) + 2;
            //$this.children('.jColorSelect').css('width', w*2);

            // Subscribe to click event of each color box
            $color.each(function(i) {
                $(this).click(function() {
                    if ($$oldIndex == i) return;
                    if ($$oldIndex > -1) {
                        cell = $color.eq($$oldIndex).children('div');
                        if (cell.hasClass('check')) cell.removeClass('check').removeClass('checkwht').removeClass('checkblk');
                    }
                    // Keep index
                    $$oldIndex = i;
                    $(this).children('div').addClass('check').addClass(isdark(o.color[i]) ? 'checkwht' : 'checkblk');
                    // Trigger user event
                    o.click(o.ids[i]);
                });
            });

            // Simulate click for defaultColor
            _tmp = $$oldIndex;
            $$oldIndex = -1;
            $color.eq(_tmp).trigger('click');
        });
        return this;
    };


})(jQuery);

/**
 * Return true if color is dark, false otherwise.
 * (C) 2008 Syronex / J.M. Rosengard
 **/
function isdark(color) {
    var colr = parseInt(color.substr(1), 16);
    return (colr >>> 16) // R
        + ((colr >>> 8) & 0x00ff) // G 
        + (colr & 0x0000ff) // B
        < 500;
}
