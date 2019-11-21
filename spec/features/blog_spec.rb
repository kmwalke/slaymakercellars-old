require 'spec_helper'

describe 'Blog' do
  xit 'visits blog#index' do
    visit root_path

    click_link 'Blog'

    expect(current_path).to eq(blog_path)
  end

  xit 'views a blog post' do
    visit root_path

    click_link 'Blog'

    first(:link, '.blog_post_link').click
  end
end
