class SearchCategoriesController < ApplicationController
  before_action :set_search_category, only: [:show, :edit, :update, :destroy]

  # GET /search_categories
  # GET /search_categories.json
  def index
    @search_categories = SearchCategory.all
    @items = SearchCategory.order(:name)
    @item  = SearchCategory.new
  end

  # GET /search_categories/1
  # GET /search_categories/1.json
  def show
  end

  # GET /search_categories/new
  def new
    @search_category = SearchCategory.new
  end

  # GET /search_categories/1/edit
  def edit
  end

  # POST /search_categories
  # POST /search_categories.json
  def create
    @search_category = SearchCategory.new(search_category_params)

    respond_to do |format|
      if @search_category.save
        format.html { redirect_to @search_category, notice: 'Search category was successfully created.' }
        format.json { render :show, status: :created, location: @search_category }
      else
        format.html { render :new }
        format.json { render json: @search_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /search_categories/1
  # PATCH/PUT /search_categories/1.json
  def update
    respond_to do |format|
      if @search_category.update(search_category_params)
        format.html { redirect_to @search_category, notice: 'Search category was successfully updated.' }
        format.json { render :show, status: :ok, location: @search_category }
      else
        format.html { render :edit }
        format.json { render json: @search_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_categories/1
  # DELETE /search_categories/1.json
  def destroy
    @search_category.destroy
    respond_to do |format|
      format.html { redirect_to search_categories_url, notice: 'Search category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_category
      @search_category = SearchCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_category_params
      params.require(:search_category).permit(:name)
    end
end
