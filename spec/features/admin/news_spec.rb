require 'rails_helper'

describe 'Admin::News' do
  it 'opens Admin::News' do
    login_as_admin
    visit admin_articles_path

    expect(current_path).to eq(admin_articles_path)
    expect(page).to have_content('Articles')
  end

  it 'creates an article' do
    login_as_admin
    article = FactoryBot.create(:article)
    visit admin_articles_path

    first(:link, 'New Article').click
    expect(current_path).to eq(new_admin_article_path)

    fill_in 'Title', with: article.title
    fill_in 'Date', with: article.date
    fill_in 'Url', with: article.url
    fill_in 'Body', with: article.body

    click_button 'Create Article'
    expect(current_path).to eq(admin_articles_path)
  end

  it 'updates an article' do
    login_as_admin
    article    = FactoryBot.create(:article)
    article_id = article.id
    new_title  = "new #{article.title}"
    visit admin_articles_path

    click_link article.title
    expect(current_path).to eq(edit_admin_article_path(article_id))

    fill_in 'Title', with: new_title

    click_button 'Update Article'
    expect(current_path).to eq(admin_articles_path)
    expect(Article.find_by_id(article_id).title).to eq(new_title)
  end

  it 'deletes an article' do
    login_as_admin
    article    = FactoryBot.create(:article)
    article_id = article.id
    visit admin_articles_path

    click_link "delete_#{article.id}"

    expect(current_path).to eq(admin_articles_path)
    expect(Article.find_by_id(article_id)).to eq(nil)
  end
end
