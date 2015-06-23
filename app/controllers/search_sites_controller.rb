class SearchSitesController < ApplicationController
  before_action :set_search_site, only: [:show, :edit, :update, :destroy]

  # GET /search_sites
  # GET /search_sites.json
  def index
    @search_sites = SearchSite.all
    @items  = SearchSite.order(:name)
    @item   = SearchSite.new
  end

  # GET /search_sites/1
  # GET /search_sites/1.json
  def show
  end

  # GET /search_sites/new
  def new
    @search_site = SearchSite.new
  end

  # GET /search_sites/1/edit
  def edit
  end

  # POST /search_sites
  # POST /search_sites.json
  def create
    @search_site = SearchSite.new(search_site_params)

    respond_to do |format|
      if @search_site.save
        format.html { redirect_to @search_site, notice: 'Search site was successfully created.' }
        format.json { render :show, status: :created, location: @search_site }
      else
        format.html { render :new }
        format.json { render json: @search_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /search_sites/1
  # PATCH/PUT /search_sites/1.json
  def update
    respond_to do |format|
      if @search_site.update(search_site_params)
        format.html { redirect_to @search_site, notice: 'Search site was successfully updated.' }
        format.json { render :show, status: :ok, location: @search_site }
      else
        format.html { render :edit }
        format.json { render json: @search_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_sites/1
  # DELETE /search_sites/1.json
  def destroy
    @search_site.destroy
    respond_to do |format|
      format.html { redirect_to search_sites_url, notice: 'Search site was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_site
      @search_site = SearchSite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_site_params
      params.require(:search_site).permit(:name)
    end
end
