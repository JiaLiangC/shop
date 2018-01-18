// $(document).on('turbolinks:load', function() {
  var autoSave;
  if($(".article_form").attr("data-edit")=="true")
  {
      if($(".article_form").length > 0){
        window.lastArticleData = $(".article_form").serialize();    
      }

      autoSave = function(){
        post_url = $(".article_form").attr("action"); 
        data = $(".article_form").serialize();
        if (window.lastArticleData === data)
        {
          return;
        }
        $.post(post_url+"?autosave=1&",data,function(res){
          window.lastArticleData =  data;
        },"json");
      };
    setInterval(autoSave,1000*60);
  }
// });