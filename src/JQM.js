
function init_unit(menustyle_css_class, text_string) {

    $('.Lite_css_topmenu ul li').hover(

        function() {
            $(this).addClass("active");
            $(this).find('ul').stop(true, true); // останавливаем всю текущую анимацию
            $(this).find('ul').slideDown();
        },

        function() {
            $(this).removeClass("active");       
            $(this).find('ul').slideUp('fast');
        }

    );

}

