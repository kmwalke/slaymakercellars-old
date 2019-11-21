require 'spec_helper'

describe 'News' do
  it 'renders news page' do
    visit root_path
    click_link 'News'
    expect(current_path).to eq(articles_path)
  end

  it 'renders news articles' do
    article = FactoryBot.create(:article)

    visit articles_path
    expect(page).to have_content(article.title)
  end
end
