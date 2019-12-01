class Admin::ArticlesController < ApplicationController
  before_action :logged_in_as_admin?
  def index
    @articles = Article.order('date desc')

    respond_to do |format|
      format.html
    end
  end

  def new
    @article = Article.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.create(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_articles_path, notice: 'Article was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update!(article_params)
        format.html { redirect_to admin_articles_path, notice: 'Article was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to admin_articles_url }
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :url, :date)
  end
end
