class Admin::ArticlesController < ApplicationController
  before_action :logged_in_as_admin?
  def index
    @articles = Article.order('date desc')

    respond_to do |format|
      format.html
      format.json { render json: @articles }
    end
  end

  def new
    @article = Article.new

    respond_to do |format|
      format.html
      format.json { render json: @article }
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
        format.json { render json: articles_path, status: :created, location: @article }
      else
        format.html { render action: 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update!(article_params)
        format.html { redirect_to admin_articles_path, notice: 'Article was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to admin_articles_url }
      format.json { head :ok }
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :url, :date)
  end
end
