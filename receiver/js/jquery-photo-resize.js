/// <reference path="jquery-1.5.1.min.js" />

/*
* Adjust photo on browser window resize
* 
* @example: $('selector').photoResize();
* 
* @example:
    $('selector').photoResize({
        bottomSpacing:"Bottom Spacing adjustment"
    });
*/

(function ($) {

    $.fn.photoResize = function (options) {

        var element = $(this), 
            defaults = {
                bottomSpacing: 10
            };
        
        $(element).load(function () {
            updatePhotoHeight();

            $(window).bind('resize', function () {
                updatePhotoHeight();
            });
        });

        options = $.extend(defaults, options);

        function updatePhotoHeight() {
            var o = options, 
                photoHeight = $(window).height();

            $(element).attr('height', photoHeight - o.bottomSpacing);
        }
    };

}(jQuery));