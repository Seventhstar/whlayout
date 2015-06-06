class WhouseElementsController < ApplicationController
  before_action :logged_in_user

  # GET /whouses
  # GET /whouses.json
  def index
    
    @whouses = Whouse.order(:name)


    query = ""
    qparams = {}
    if !params[:whouse_id].nil? && params[:whouse_id]!=""
       query = 'whouses.id = :key1' 
       qparams.store( :key1, params[:whouse_id])
       puts "first add"
    end

    if params[:search]!=nil && params[:search]!=""
      @whels = WhouseElement.joins(:element)
      query = query == "" ? "": query+ " and "
      query = query + "lower(elements.name) LIKE lower(:key2)" 
      qparams.store( :key2, '%'+ params[:search].to_s+'%')
    else
      @whels = WhouseElement.all
    end

   # puts "qparams: " + qparams.to_s

    if query !="" 
     @whels = @whels.where(query,qparams)
    end

    @whels = @whels.joins(:whouse).joins(:element).order('whouses.name, elements.name')

  end

  

  # GET /whouses/1/edit
  def edit
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def whel_params
      params.require(:whouse_id,:element_id).permit(:name)
    end
end
