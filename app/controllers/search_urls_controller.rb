class SearchUrlsController < ApplicationController
  before_action :set_search_url, only: [:show, :edit, :update, :destroy]

  # GET /search_urls
  # GET /search_urls.json
  def index

    @search_urls = SearchUrl.order(:search_category_id)
    @categories = SearchCategory.order(:name)
    @sites = SearchSite.all

    if params[:url_sites] && (params[:url_sites].to_i > 0)
      @search_urls = @search_urls.where(:site=>params[:url_sites])
    end
    if params[:url_category] && (params[:url_category].to_i > 0)
      @search_urls = @search_urls.where(:category=>params[:url_category])
    end

  end

  # GET /search_urls/1
  # GET /search_urls/1.json
  def show
  end

  # GET /search_urls/new
  def new
    @search_url = SearchUrl.new
    @sites = SearchSite.all
    @categories =SearchCategory.all
  end

  # GET /search_urls/1/edit
  def edit
    @sites = SearchSite.all
    @categories =SearchCategory.all
  end

  # POST /search_urls
  # POST /search_urls.json
  def create
    @search_url = SearchUrl.new(search_url_params)

    respond_to do |format|
      if @search_url.save
        format.html { redirect_to search_urls_url, notice: 'Search url was successfully created.' }
        format.json { render :show, status: :created, location: @search_url }
      else
        format.html { render :new }
        format.json { render json: @search_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /search_urls/1
  # PATCH/PUT /search_urls/1.json
  def update
    respond_to do |format|
      if @search_url.update(search_url_params)
        format.html { redirect_to search_urls_url, notice: 'Search url was successfully updated.' }
        format.json { render :show, status: :ok, location: @search_url }
      else
        format.html { render :edit }
        format.json { render json: @search_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_urls/1
  # DELETE /search_urls/1.json
  def destroy
    @search_url.destroy
    respond_to do |format|
      format.html { redirect_to search_urls_url, notice: 'Search url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_url
      @search_url = SearchUrl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_url_params
      params.require(:search_url).permit(:url, :search_site_id, :search_category_id)
    end
end
