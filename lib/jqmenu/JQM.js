function jqm_init(menustyle) {

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

