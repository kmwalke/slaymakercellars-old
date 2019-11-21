class BlogController < ApplicationController
  def index
    client = Tumblr::Client.new(
      consumer_key: 'lOhhkRKtJp9OR3HJ8nUR86Y4O3IssSNPmkDZfepyRBPwqlZIIi',
      consumer_secret: 'DZHJ1QjrnvK579LIoHZGsDH0aloy7Rnyps3TzUSbgUVPIRCP9A',
      oauth_token: 'EP7uf7AvhnmGaLNEeRNHDGZ4vXkfPG07BSz5jD2piLgOM78fRk',
      oauth_token_secret: 'WEEo7bOzFRFtWl9vF0VbDOyz54sEkMr2T4r6lD9gGKxLzadbOY'
    )

    #    tumblr = client.posts("kentwalkercheese.tumblr.com")

    @title       = '' # tumblr["blog"]["title"]
    @posts       = [] # tumblr["posts"].select {|post| post['state'] == "published"}
    @POST_LENGTH = 600
  end
end
