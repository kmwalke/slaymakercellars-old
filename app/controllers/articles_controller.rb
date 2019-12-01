class ArticlesController < ApplicationController
  def index
    @articles = Article.order('date desc').paginate(per_page: 15, page: params[:page])

    respond_to do |format|
      format.html
    end
  end

  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
end
