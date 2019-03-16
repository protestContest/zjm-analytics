module ApplicationHelper
  include SettingsHelper

  def own_tracking_tag
    return raw <<-'HTML'
<script>
  var clientId=document.cookie.replace(/(?:(?:^|.*;\s*)_za\s*\=\s*([^;]*).*$)|^.*$/,"$1");0===clientId.length&&(clientId=function(){var a=new Date().getTime(),b="xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(b){var c=0|(a+16*Math.random())%16;return a=Math.floor(a/16),("x"==b?c:8|3&c).toString(16)});return b}(),document.cookie="_za="+clientId+"; max-age=63072000; domain="+document.location.hostname);var i=new Image;i.src=`https://analytics.zjm.me/track?hit_type=pageview&location=${window.location}&language=${navigator.language}&encoding=${document.charset}&title=${document.title}&color_depth=${screen.colorDepth}&screen_res=${screen.width}x${screen.height}&viewport=${innerWidth}x${innerHeight}&tracking_id=ZA-000001-6&client_id=${clientId}`;
</script>
HTML
  end
end
