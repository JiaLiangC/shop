// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(function(){
    // $(document).on('turbolinks:load', function() {
        $('.add-to-cart-btn').on('click', function(){
            console.log('clicked');

            var $this = $(this),
            $prog = $this.find('i');
            $.ajax({
                url: "/shopping_carts",
                method: 'post',
                dataType: 'script',
                data: {product_id: $this.data('product-id')},
                beforeSend: function(){
                    if (!$prog.hasClass('fa-spin')){
                        $prog.addClass('fa-spin');
                    }
                    $prog.show();
                },
                success: function(){
                    // if($())
                },
                complete: function(){
                    $prog.hide();
                }

            })
            return false;
        });
    // });
});