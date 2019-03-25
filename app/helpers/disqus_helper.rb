require 'rubygems'
require 'base64'
require 'cgi'
require 'openssl'
require 'json'
module DisqusHelper
  #### SSO with system user, put on application helper rails
  def disqus_sso(user)
    disqus_secret_key = 'rYhwzsEzLFQOZv7irh78vW3RXd9MPH7wpM0QwLpbdEyjjNSoURJ8HhlugZ09qsoT'
    disqus_public_key = 'dTNboyeYy8FrKbKFGXM0vGIKcdc3YWq7a4bJXMZdlei9h5JZSVbwh2W0rlSicbG8'
    if user && user.instance_of?(User)
      # create a JSON packet of our data attributes
      data =  {
        id:       user.id,
        username: user,
        email:    user.email,
        avatar: user.avatar
      }.to_json
    else
      data = {}.to_json
    end
    # encode the data to base64
    message  = Base64.encode64(data).gsub("\n", "")
    # generate a timestamp for signing the message
    timestamp = Time.now.to_i
    # generate our hmac signature
    sig = OpenSSL::HMAC.hexdigest('sha1', disqus_secret_key, '%s %s' % [message, timestamp])
    # return a script tag to insert the sso message
    "<script type=\"text/javascript\">
      var disqus_config = function() {
        this.page.remote_auth_s3 = \"#{message} #{sig} #{timestamp}\";
        this.page.api_key = \"#{disqus_public_key}\";
      };
    </script>".html_safe
  end

  def render_disqus(user, url)
    "<script type=\"text/javascript\">
      var disqus_shortname = \"saintlbeau-affiliate\";
      var disqus_identifier = \"#{user.id}\";
      var disqus_container_id = 'disqus_thread';
      var disqus_domain = 'disqus.com';
      var disqus_title = \"#{escape_javascript(user.try(:name))}\";
      var disqus_url = '#{url}';
      (function() {
        debugger;
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'https://saintlbeau-affiliate.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
      })();
      (function () {
        debugger;
        var s = document.createElement('script'); s.async = true;
        s.type = 'text/javascript';
        s.src = 'https://saintlbeau-affiliate.disqus.com/count.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(s);
      }());
    </script>".html_safe
  end
end
